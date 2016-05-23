# install and launch needed packages
library(reshape2)

# Download and unzip dataset
filename <- "C:/Users/Wicitra/Desktop/Coursera/GettingCleaningData/project/data/project_dataset.zip"

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL,filename)
}

if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}

# Load acitvity labels + features
activitylabelsmess <- read.table("UCI Har Dataset/activity_labels.txt")
activitylabelsmess[,2] <- as.character(activitylabelsmess[,2])
activitylabels <- activitylabelsmess[,2]

featuresmess <- read.table("UCI Har Dataset/features.txt")
featuresmess[,2] <- as.character(featuresmess[,2])
features <- featuresmess[,2]

# Extract data on mean and standard deviation
featureswanted <- grep('mean|std', features)
featureswanted.names <- features[featureswanted]

# Clean up featureswanted.names
featureswanted.names <- gsub('-mean', 'Mean', featureswanted.names)
featureswanted.names <- gsub('-std', 'Std', featureswanted.names)
featureswanted.names <- gsub('[-()]','', featureswanted.names)

# Load the datasets
trainx <- read.table("UCI HAR Dataset/train/X_train.txt")[featureswanted]
trainy <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainsubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainsubject,trainy,trainx)

testx <- read.table("UCI HAR Dataset/test/X_test.txt")[featureswanted]
testy <- read.table("UCI HAR Dataset/test/Y_test.txt")
testsubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testsubject,testy,testx)

# Merge datasets and add coloumn names
mergedata <- rbind(train,test)
colnames(mergedata) <- c("subject","activity",featureswanted.names)

# Activity and Subjects are integers, turn into factors
mergedata$subject <- as.factor(mergedata$subject)
mergedata$activity <- factor(mergedata$activity, levels = c(1:6), labels = activitylabels)

# Melt and Recast data

mergedata.melted <- melt(mergedata, id = c("subject","activity"))
mergedata.mean <- dcast(mergedata.melted, subject + activity ~ variable, mean)

write.table(mergedata.mean,"tidy.txt",row.names = FALSE, quote = FALSE)

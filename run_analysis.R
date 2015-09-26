library(dplyr)
library(reshape2)
#Declaring txt files to read data
testDataFile <- "./data/UCI_HAR_Dataset/test/X_test.txt"
testLabelsFile <- "./data/UCI_HAR_Dataset/test/y_test.txt"
subject_test <- "./data/UCI_HAR_Dataset/test/subject_test.txt"
trainDataFile <- "./data/UCI_HAR_Dataset/train/X_train.txt"
trainLabelsFile <- "./data/UCI_HAR_Dataset/train/y_train.txt"
subject_train <- "./data/UCI_HAR_Dataset/train/subject_train.txt"
featuresFile <- "./data/UCI_HAR_Dataset/features.txt"
activitiesFile <- "./data/UCI_HAR_Dataset/activity_labels.txt"

#Reading txt file data
testXdata <- read.table(testDataFile)
testLabels <- read.table(testLabelsFile)

trainXdata <- read.table(trainDataFile)
trainLabels <- read.table(trainLabelsFile)
test_subject <- read.table(subject_test)
train_subject <- read.table(subject_train)

features <- read.table(featuresFile)
activitiesLbl <- read.table(activitiesFile)

#updating column names for test & train data
names(testXdata) = features$V2
names(trainXdata) = features$V2

#Getting mean, sdt, an mad columns index to filter final Data
requiredColumns <- grep(".-mean().|.-std().", features$V2)

#filtering test & train data for mean & Sd vales
testXdata <- testXdata[,requiredColumns]
trainXdata <- trainXdata[,requiredColumns]

#Adding labes to y_test & y_train to label them with id & label
testLabels$V2 = activitiesLbl$V2[testLabels$V1]
trainLabels$V2 = activitiesLbl$V2[trainLabels$V1]

#Labeling y_ data columns
names(testLabels) = c("activity_id", "activity_label")
names(trainLabels) = c("activity_id", "activity_label")
#Assigning label for subject data
names(test_subject) = c("subject" )
names(train_subject) = c("subject" )

#Merging subject, activity (id and label) and data for test & train
finalTestData <- cbind(test_subject,testLabels, testXdata)
finalTrainData <- cbind(train_subject,trainLabels, trainXdata)

nrow(finalTestData)
nrow(finalTrainData)
#Merging Test & Train data using rbind
finalData <- rbind(finalTestData, finalTrainData)

#Melting the data with id & measure variables
mlt_id = c("subject", "activity_id", "activity_label")
#getting the data columns (i.e, colnames ~  mlt_ids)
mlt_data_cols = setdiff(colnames(finalData),mlt_id)
melted_data = melt(finalData, id.vars = mlt_id, measure.vars = mlt_data_cols)

#preparing tidy data
data = dcast(melted_data, subject + activity_label ~ variable, mean)
#wiring tidy data to a file 'tidy_data.txt'
write.table(data, "./data/UCI_HAR_Dataset/tidy_data.txt",row.name=FALSE)

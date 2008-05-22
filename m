Return-Path: <linux-kernel-owner+w=401wt.eu-S1760650AbYEVV1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbYEVV1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYEVV1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:27:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45204 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752383AbYEVV1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:27:09 -0400
Date: Thu, 22 May 2008 22:14:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] DAC960: Push down BKL
Message-ID: <20080522221436.5e872b09@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index cd03473..28ee661 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -6628,15 +6628,18 @@ static void DAC960_DestroyProcEntries(DAC960_Controller_T *Controller)
  * DAC960_gam_ioctl is the ioctl function for performing RAID operations.
 */
 
-static int DAC960_gam_ioctl(struct inode *inode, struct file *file,
-			    unsigned int Request, unsigned long Argument)
+static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
+						unsigned long Argument)
 {
-  int ErrorCode = 0;
+  long ErrorCode = 0;
   if (!capable(CAP_SYS_ADMIN)) return -EACCES;
+  
+  lock_kernel();
   switch (Request)
     {
     case DAC960_IOCTL_GET_CONTROLLER_COUNT:
-      return DAC960_ControllerCount;
+      ErrorCode = DAC960_ControllerCount;
+      break;
     case DAC960_IOCTL_GET_CONTROLLER_INFO:
       {
 	DAC960_ControllerInfo_T __user *UserSpaceControllerInfo =
@@ -6644,15 +6647,20 @@ static int DAC960_gam_ioctl(struct inode *inode, struct file *file,
 	DAC960_ControllerInfo_T ControllerInfo;
 	DAC960_Controller_T *Controller;
 	int ControllerNumber;
-	if (UserSpaceControllerInfo == NULL) return -EINVAL;
-	ErrorCode = get_user(ControllerNumber,
+	if (UserSpaceControllerInfo == NULL)
+		ErrorCode = -EINVAL;
+	else ErrorCode = get_user(ControllerNumber,
 			     &UserSpaceControllerInfo->ControllerNumber);
-	if (ErrorCode != 0) return ErrorCode;
+	if (ErrorCode != 0)
+		break;;
+	ErrorCode = -ENXIO;
 	if (ControllerNumber < 0 ||
-	    ControllerNumber > DAC960_ControllerCount - 1)
-	  return -ENXIO;
+	    ControllerNumber > DAC960_ControllerCount - 1) {
+	  break;
+	}
 	Controller = DAC960_Controllers[ControllerNumber];
-	if (Controller == NULL) return -ENXIO;
+	if (Controller == NULL)
+		break;;
 	memset(&ControllerInfo, 0, sizeof(DAC960_ControllerInfo_T));
 	ControllerInfo.ControllerNumber = ControllerNumber;
 	ControllerInfo.FirmwareType = Controller->FirmwareType;
@@ -6665,8 +6673,9 @@ static int DAC960_gam_ioctl(struct inode *inode, struct file *file,
 	ControllerInfo.PCI_Address = Controller->PCI_Address;
 	strcpy(ControllerInfo.ModelName, Controller->ModelName);
 	strcpy(ControllerInfo.FirmwareVersion, Controller->FirmwareVersion);
-	return (copy_to_user(UserSpaceControllerInfo, &ControllerInfo,
+	ErrorCode = (copy_to_user(UserSpaceControllerInfo, &ControllerInfo,
 			     sizeof(DAC960_ControllerInfo_T)) ? -EFAULT : 0);
+	break;
       }
     case DAC960_IOCTL_V1_EXECUTE_COMMAND:
       {
@@ -6684,30 +6693,39 @@ static int DAC960_gam_ioctl(struct inode *inode, struct file *file,
 	int ControllerNumber, DataTransferLength;
 	unsigned char *DataTransferBuffer = NULL;
 	dma_addr_t DataTransferBufferDMA;
-	if (UserSpaceUserCommand == NULL) return -EINVAL;
+	if (UserSpaceUserCommand == NULL) {
+		ErrorCode = -EINVAL;
+		break;
+	}
 	if (copy_from_user(&UserCommand, UserSpaceUserCommand,
 				   sizeof(DAC960_V1_UserCommand_T))) {
 		ErrorCode = -EFAULT;
-		goto Failure1a;
+		break;
 	}
 	ControllerNumber = UserCommand.ControllerNumber;
+    	ErrorCode = -ENXIO;
 	if (ControllerNumber < 0 ||
 	    ControllerNumber > DAC960_ControllerCount - 1)
-	  return -ENXIO;
+	    	break;
 	Controller = DAC960_Controllers[ControllerNumber];
-	if (Controller == NULL) return -ENXIO;
-	if (Controller->FirmwareType != DAC960_V1_Controller) return -EINVAL;
+	if (Controller == NULL)
+		break;
+	ErrorCode = -EINVAL;
+	if (Controller->FirmwareType != DAC960_V1_Controller)
+		break;
 	CommandOpcode = UserCommand.CommandMailbox.Common.CommandOpcode;
 	DataTransferLength = UserCommand.DataTransferLength;
-	if (CommandOpcode & 0x80) return -EINVAL;
+	if (CommandOpcode & 0x80)
+		break;
 	if (CommandOpcode == DAC960_V1_DCDB)
 	  {
 	    if (copy_from_user(&DCDB, UserCommand.DCDB,
 			       sizeof(DAC960_V1_DCDB_T))) {
 		ErrorCode = -EFAULT;
-		goto Failure1a;
+		break;
 	    }
-	    if (DCDB.Channel >= DAC960_V1_MaxChannels) return -EINVAL;
+	    if (DCDB.Channel >= DAC960_V1_MaxChannels)
+	    		break;
 	    if (!((DataTransferLength == 0 &&
 		   DCDB.Direction
 		   == DAC960_V1_DCDB_NoDataTransfer) ||
@@ -6717,38 +6735,37 @@ static int DAC960_gam_ioctl(struct inode *inode, struct file *file,
 		  (DataTransferLength < 0 &&
 		   DCDB.Direction
 		   == DAC960_V1_DCDB_DataTransferSystemToDevice)))
-	      return -EINVAL;
+		   	break;
 	    if (((DCDB.TransferLengthHigh4 << 16) | DCDB.TransferLength)
 		!= abs(DataTransferLength))
-	      return -EINVAL;
+			break;
 	    DCDB_IOBUF = pci_alloc_consistent(Controller->PCIDevice,
 			sizeof(DAC960_V1_DCDB_T), &DCDB_IOBUFDMA);
-	    if (DCDB_IOBUF == NULL)
-			return -ENOMEM;
+	    if (DCDB_IOBUF == NULL) {
+	    		ErrorCode = -ENOMEM;
+			break;
+		}
 	  }
+	ErrorCode = -ENOMEM;
 	if (DataTransferLength > 0)
 	  {
 	    DataTransferBuffer = pci_alloc_consistent(Controller->PCIDevice,
 				DataTransferLength, &DataTransferBufferDMA);
-	    if (DataTransferBuffer == NULL) {
-		ErrorCode = -ENOMEM;
-		goto Failure1;
-	    }
+	    if (DataTransferBuffer == NULL)
+	    	break;
 	    memset(DataTransferBuffer, 0, DataTransferLength);
 	  }
 	else if (DataTransferLength < 0)
 	  {
 	    DataTransferBuffer = pci_alloc_consistent(Controller->PCIDevice,
 				-DataTransferLength, &DataTransferBufferDMA);
-	    if (DataTransferBuffer == NULL) {
-		ErrorCode = -ENOMEM;
-		goto Failure1;
-	    }
+	    if (DataTransferBuffer == NULL)
+	    	break;
 	    if (copy_from_user(DataTransferBuffer,
 			       UserCommand.DataTransferBuffer,
 			       -DataTransferLength)) {
 		ErrorCode = -EFAULT;
-		goto Failure1;
+		break;
 	    }
 	  }
 	if (CommandOpcode == DAC960_V1_DCDB)
@@ -6825,8 +6842,7 @@ static int DAC960_gam_ioctl(struct inode *inode, struct file *file,
 	if (DCDB_IOBUF != NULL)
 	  pci_free_consistent(Controller->PCIDevice, sizeof(DAC960_V1_DCDB_T),
 			DCDB_IOBUF, DCDB_IOBUFDMA);
-      Failure1a:
-	return ErrorCode;
+      	break;
       }
     case DAC960_IOCTL_V2_EXECUTE_COMMAND:
       {
@@ -6844,32 +6860,43 @@ static int DAC960_gam_ioctl(struct inode *inode, struct file *file,
 	dma_addr_t DataTransferBufferDMA;
 	unsigned char *RequestSenseBuffer = NULL;
 	dma_addr_t RequestSenseBufferDMA;
-	if (UserSpaceUserCommand == NULL) return -EINVAL;
+	
+	ErrorCode = -EINVAL;
+	if (UserSpaceUserCommand == NULL)
+		break;
 	if (copy_from_user(&UserCommand, UserSpaceUserCommand,
 			   sizeof(DAC960_V2_UserCommand_T))) {
 		ErrorCode = -EFAULT;
-		goto Failure2a;
+		break;
 	}
+	ErrorCode = -ENXIO;
 	ControllerNumber = UserCommand.ControllerNumber;
 	if (ControllerNumber < 0 ||
 	    ControllerNumber > DAC960_ControllerCount - 1)
-	  return -ENXIO;
+	    	break;
 	Controller = DAC960_Controllers[ControllerNumber];
-	if (Controller == NULL) return -ENXIO;
-	if (Controller->FirmwareType != DAC960_V2_Controller) return -EINVAL;
+	if (Controller == NULL)
+		break;
+	if (Controller->FirmwareType != DAC960_V2_Controller){
+		ErrorCode = -EINVAL;
+		break;
+	}
 	DataTransferLength = UserCommand.DataTransferLength;
+    	ErrorCode = -ENOMEM;
 	if (DataTransferLength > 0)
 	  {
 	    DataTransferBuffer = pci_alloc_consistent(Controller->PCIDevice,
 				DataTransferLength, &DataTransferBufferDMA);
-	    if (DataTransferBuffer == NULL) return -ENOMEM;
+	    if (DataTransferBuffer == NULL)
+	    	break;
 	    memset(DataTransferBuffer, 0, DataTransferLength);
 	  }
 	else if (DataTransferLength < 0)
 	  {
 	    DataTransferBuffer = pci_alloc_consistent(Controller->PCIDevice,
 				-DataTransferLength, &DataTransferBufferDMA);
-	    if (DataTransferBuffer == NULL) return -ENOMEM;
+	    if (DataTransferBuffer == NULL)
+	    	break;
 	    if (copy_from_user(DataTransferBuffer,
 			       UserCommand.DataTransferBuffer,
 			       -DataTransferLength)) {
@@ -6979,8 +7006,7 @@ static int DAC960_gam_ioctl(struct inode *inode, struct file *file,
 	if (RequestSenseBuffer != NULL)
 	  pci_free_consistent(Controller->PCIDevice, RequestSenseLength,
 		RequestSenseBuffer, RequestSenseBufferDMA);
-      Failure2a:
-	return ErrorCode;
+        break;
       }
     case DAC960_IOCTL_V2_GET_HEALTH_STATUS:
       {
@@ -6990,21 +7016,33 @@ static int DAC960_gam_ioctl(struct inode *inode, struct file *file,
 	DAC960_V2_HealthStatusBuffer_T HealthStatusBuffer;
 	DAC960_Controller_T *Controller;
 	int ControllerNumber;
-	if (UserSpaceGetHealthStatus == NULL) return -EINVAL;
+	if (UserSpaceGetHealthStatus == NULL) {
+		ErrorCode = -EINVAL;
+		break;
+	}
 	if (copy_from_user(&GetHealthStatus, UserSpaceGetHealthStatus,
-			   sizeof(DAC960_V2_GetHealthStatus_T)))
-		return -EFAULT;
+			   sizeof(DAC960_V2_GetHealthStatus_T))) {
+		ErrorCode = -EFAULT;
+		break;
+	}
+	ErrorCode = -ENXIO;
 	ControllerNumber = GetHealthStatus.ControllerNumber;
 	if (ControllerNumber < 0 ||
 	    ControllerNumber > DAC960_ControllerCount - 1)
-	  return -ENXIO;
+		    break;
 	Controller = DAC960_Controllers[ControllerNumber];
-	if (Controller == NULL) return -ENXIO;
-	if (Controller->FirmwareType != DAC960_V2_Controller) return -EINVAL;
+	if (Controller == NULL)
+		break;
+	if (Controller->FirmwareType != DAC960_V2_Controller) {
+		ErrorCode = -EINVAL;
+		break;
+	}
 	if (copy_from_user(&HealthStatusBuffer,
 			   GetHealthStatus.HealthStatusBuffer,
-			   sizeof(DAC960_V2_HealthStatusBuffer_T)))
-		return -EFAULT;
+			   sizeof(DAC960_V2_HealthStatusBuffer_T))) {
+		ErrorCode = -EFAULT;
+		break;
+	}
 	while (Controller->V2.HealthStatusBuffer->StatusChangeCounter
 	       == HealthStatusBuffer.StatusChangeCounter &&
 	       Controller->V2.HealthStatusBuffer->NextEventSequenceNumber
@@ -7012,21 +7050,28 @@ static int DAC960_gam_ioctl(struct inode *inode, struct file *file,
 	  {
 	    interruptible_sleep_on_timeout(&Controller->HealthStatusWaitQueue,
 					   DAC960_MonitoringTimerInterval);
-	    if (signal_pending(current)) return -EINTR;
+	    if (signal_pending(current)) {
+	    	ErrorCode = -EINTR;
+	    	break;
+	    }
 	  }
 	if (copy_to_user(GetHealthStatus.HealthStatusBuffer,
 			 Controller->V2.HealthStatusBuffer,
 			 sizeof(DAC960_V2_HealthStatusBuffer_T)))
-		return -EFAULT;
-	return 0;
+		ErrorCode = -EFAULT;
+	else
+		ErrorCode =  0;
       }
+      default:
+	ErrorCode = -ENOTTY;
     }
-  return -EINVAL;
+  unlock_kernel();
+  return ErrorCode;
 }
 
 static const struct file_operations DAC960_gam_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= DAC960_gam_ioctl
+	.unlocked_ioctl	= DAC960_gam_ioctl
 };
 
 static struct miscdevice DAC960_gam_dev = {

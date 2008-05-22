Return-Path: <linux-kernel-owner+w=401wt.eu-S1761671AbYEVU5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761671AbYEVU5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbYEVU5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:57:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54318 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755955AbYEVU5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:57:20 -0400
Date: Thu, 22 May 2008 21:44:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] mwave: ioctl BKL pushdown
Message-ID: <20080522214448.7dd1f7f8@core>
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

Push the BKL down to the point it wraps the actual mwave method handlers

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/mwave/mwavedd.c b/drivers/char/mwave/mwavedd.c
index 8d14823..ee12de1 100644
--- a/drivers/char/mwave/mwavedd.c
+++ b/drivers/char/mwave/mwavedd.c
@@ -85,8 +85,8 @@ module_param(mwave_uart_io, int, 0);
 
 static int mwave_open(struct inode *inode, struct file *file);
 static int mwave_close(struct inode *inode, struct file *file);
-static int mwave_ioctl(struct inode *inode, struct file *filp,
-                       unsigned int iocmd, unsigned long ioarg);
+static long mwave_ioctl(struct file *filp, unsigned int iocmd,
+							unsigned long ioarg);
 
 MWAVE_DEVICE_DATA mwave_s_mdd;
 
@@ -117,16 +117,16 @@ static int mwave_close(struct inode *inode, struct file *file)
 	return retval;
 }
 
-static int mwave_ioctl(struct inode *inode, struct file *file,
-                       unsigned int iocmd, unsigned long ioarg)
+static long mwave_ioctl(struct file *file, unsigned int iocmd,
+							unsigned long ioarg)
 {
 	unsigned int retval = 0;
 	pMWAVE_DEVICE_DATA pDrvData = &mwave_s_mdd;
 	void __user *arg = (void __user *)ioarg;
 
-	PRINTK_5(TRACE_MWAVE,
-		"mwavedd::mwave_ioctl, entry inode %p file %p cmd %x arg %x\n",
-		 inode,  file, iocmd, (int) ioarg);
+	PRINTK_4(TRACE_MWAVE,
+		"mwavedd::mwave_ioctl, entry file %p cmd %x arg %x\n",
+		file, iocmd, (int) ioarg);
 
 	switch (iocmd) {
 
@@ -134,7 +134,9 @@ static int mwave_ioctl(struct inode *inode, struct file *file,
 			PRINTK_1(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_RESET"
 				" calling tp3780I_ResetDSP\n");
+			lock_kernel();
 			retval = tp3780I_ResetDSP(&pDrvData->rBDData);
+			unlock_kernel();
 			PRINTK_2(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_RESET"
 				" retval %x from tp3780I_ResetDSP\n",
@@ -145,7 +147,9 @@ static int mwave_ioctl(struct inode *inode, struct file *file,
 			PRINTK_1(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_RUN"
 				" calling tp3780I_StartDSP\n");
+			lock_kernel();
 			retval = tp3780I_StartDSP(&pDrvData->rBDData);
+			unlock_kernel();
 			PRINTK_2(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_RUN"
 				" retval %x from tp3780I_StartDSP\n",
@@ -159,8 +163,10 @@ static int mwave_ioctl(struct inode *inode, struct file *file,
 				"mwavedd::mwave_ioctl,"
 				" IOCTL_MW_DSP_ABILITIES calling"
 				" tp3780I_QueryAbilities\n");
+			lock_kernel();
 			retval = tp3780I_QueryAbilities(&pDrvData->rBDData,
 					&rAbilities);
+			unlock_kernel();
 			PRINTK_2(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_DSP_ABILITIES"
 				" retval %x from tp3780I_QueryAbilities\n",
@@ -191,11 +197,13 @@ static int mwave_ioctl(struct inode *inode, struct file *file,
 				"mwavedd::mwave_ioctl IOCTL_MW_READ_DATA,"
 				" size %lx, ioarg %lx pusBuffer %p\n",
 				rReadData.ulDataLength, ioarg, pusBuffer);
+			lock_kernel();
 			retval = tp3780I_ReadWriteDspDStore(&pDrvData->rBDData,
 					iocmd,
 					pusBuffer,
 					rReadData.ulDataLength,
 					rReadData.usDspAddress);
+			unlock_kernel();
 		}
 			break;
 	
@@ -213,10 +221,12 @@ static int mwave_ioctl(struct inode *inode, struct file *file,
 				" size %lx, ioarg %lx pusBuffer %p\n",
 				rReadData.ulDataLength / 2, ioarg,
 				pusBuffer);
+			lock_kernel();
 			retval = tp3780I_ReadWriteDspDStore(&pDrvData->rBDData,
 				iocmd, pusBuffer,
 				rReadData.ulDataLength / 2,
 				rReadData.usDspAddress);
+			unlock_kernel();
 		}
 			break;
 	
@@ -234,10 +244,12 @@ static int mwave_ioctl(struct inode *inode, struct file *file,
 				" size %lx, ioarg %lx pusBuffer %p\n",
 				rWriteData.ulDataLength, ioarg,
 				pusBuffer);
+			lock_kernel();
 			retval = tp3780I_ReadWriteDspDStore(&pDrvData->rBDData,
 					iocmd, pusBuffer,
 					rWriteData.ulDataLength,
 					rWriteData.usDspAddress);
+			unlock_kernel();
 		}
 			break;
 	
@@ -255,10 +267,12 @@ static int mwave_ioctl(struct inode *inode, struct file *file,
 				" size %lx, ioarg %lx pusBuffer %p\n",
 				rWriteData.ulDataLength, ioarg,
 				pusBuffer);
+			lock_kernel();
 			retval = tp3780I_ReadWriteDspIStore(&pDrvData->rBDData,
 					iocmd, pusBuffer,
 					rWriteData.ulDataLength,
 					rWriteData.usDspAddress);
+			unlock_kernel();
 		}
 			break;
 	
@@ -279,8 +293,10 @@ static int mwave_ioctl(struct inode *inode, struct file *file,
 						ipcnum);
 				return -EINVAL;
 			}
+			lock_kernel();
 			pDrvData->IPCs[ipcnum].bIsHere = FALSE;
 			pDrvData->IPCs[ipcnum].bIsEnabled = TRUE;
+			unlock_kernel();
 	
 			PRINTK_2(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl IOCTL_MW_REGISTER_IPC"
@@ -305,6 +321,7 @@ static int mwave_ioctl(struct inode *inode, struct file *file,
 				return -EINVAL;
 			}
 	
+			lock_kernel();
 			if (pDrvData->IPCs[ipcnum].bIsEnabled == TRUE) {
 				DECLARE_WAITQUEUE(wait, current);
 
@@ -345,6 +362,7 @@ static int mwave_ioctl(struct inode *inode, struct file *file,
 					" processing\n",
 					ipcnum);
 			}
+			unlock_kernel();
 		}
 			break;
 	
@@ -363,19 +381,18 @@ static int mwave_ioctl(struct inode *inode, struct file *file,
 						ipcnum);
 				return -EINVAL;
 			}
+			lock_kernel();
 			if (pDrvData->IPCs[ipcnum].bIsEnabled == TRUE) {
 				pDrvData->IPCs[ipcnum].bIsEnabled = FALSE;
 				if (pDrvData->IPCs[ipcnum].bIsHere == TRUE) {
 					wake_up_interruptible(&pDrvData->IPCs[ipcnum].ipc_wait_queue);
 				}
 			}
+			unlock_kernel();
 		}
 			break;
 	
 		default:
-			PRINTK_ERROR(KERN_ERR_MWAVE "mwavedd::mwave_ioctl:"
-					" Error: Unrecognized iocmd %x\n",
-					iocmd);
 			return -ENOTTY;
 			break;
 	} /* switch */
@@ -458,7 +475,7 @@ static const struct file_operations mwave_fops = {
 	.owner		= THIS_MODULE,
 	.read		= mwave_read,
 	.write		= mwave_write,
-	.ioctl		= mwave_ioctl,
+	.unlocked_ioctl	= mwave_ioctl,
 	.open		= mwave_open,
 	.release	= mwave_close
 };

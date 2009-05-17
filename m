Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbZEQLHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbZEQLHT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 07:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZEQLGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 07:06:42 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:36061 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZEQLGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 07:06:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RN8NEiRiob+Req1wpgCDjcRlYqNEVamyIh8Hv+P0aXDDdnED9dxZiIu2cjr01L7k4N
         sRsEktBj0Hm2SevAUeqOpYkLdz0lVqmFKsYoqwireezXxN4nagCZ02xbKc9LY0lGmivC
         lEnb5KHwfZg5RS7kqA7OyPPmS/YukDn/I1V/M=
From: Richard Genoud <richard.genoud@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Judd Montgomery <judd@jpilot.org>, Jeff Frontz <jeff.frontz@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 2/3] rspiusb.c: break the huge piusb_ioctl function into several ones
Date: Sun, 17 May 2009 13:06:31 +0200
Message-Id: <92fedd0af6bfccd6bb8d69f430148e4630eeeb28.1242557192.git.richard.genoud@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <128c57bf092e08fe6372f6e8c3d02fc88b62e094.1242557192.git.richard.genoud@gmail.com>
References: <128c57bf092e08fe6372f6e8c3d02fc88b62e094.1242557192.git.richard.genoud@gmail.com>
In-Reply-To: <128c57bf092e08fe6372f6e8c3d02fc88b62e094.1242557192.git.richard.genoud@gmail.com>
References: <128c57bf092e08fe6372f6e8c3d02fc88b62e094.1242557192.git.richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the code more readable, makes checkpatch really happy and factorize some code.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/staging/rspiusb/rspiusb.c |  206 +++++++++++++++++++++----------------
 1 files changed, 116 insertions(+), 90 deletions(-)

diff --git a/drivers/staging/rspiusb/rspiusb.c b/drivers/staging/rspiusb/rspiusb.c
index 72241f2..685ab3f 100644
--- a/drivers/staging/rspiusb/rspiusb.c
+++ b/drivers/staging/rspiusb/rspiusb.c
@@ -198,6 +198,111 @@ object_null:
 	return retval;
 }
 
+static int pixis_io(struct ioctl_struct *ctrl, struct device_extension *pdx,
+		struct ioctl_struct *arg)
+{
+	unsigned int numToRead = 0;
+	unsigned int totalRead = 0;
+	unsigned char *uBuf;
+	int numbytes;
+	int i;
+
+	uBuf = kmalloc(ctrl->numbytes, GFP_KERNEL);
+	if (!uBuf) {
+		dbg("Alloc for uBuf failed");
+		return 0;
+	}
+	numbytes = (int) ctrl->numbytes;
+	numToRead = (unsigned int) ctrl->numbytes;
+	dbg("numbytes to read = %d", numbytes);
+	dbg("endpoint # %d", ctrl->endpoint);
+
+	if (copy_from_user(uBuf, ctrl->pData, numbytes))
+		dbg("copying ctrl->pData to dummyBuf failed");
+
+	do {
+		i = usb_bulk_msg(pdx->udev, pdx->hEP[ctrl->endpoint],
+				(uBuf + totalRead),
+				/* EP0 can only handle 64 bytes at a time */
+				(numToRead > 64) ? 64 : numToRead,
+				&numbytes, HZ * 10);
+		if (i) {
+			dbg("CMD = %s, Address = 0x%02X",
+					((uBuf[3] == 0x02) ? "WRITE" : "READ"),
+					uBuf[1]);
+			dbg("Number of bytes Attempted to read = %d",
+					(int)ctrl->numbytes);
+			dbg("Blocking ReadI/O Failed with status %d", i);
+			kfree(uBuf);
+			return -1;
+		}
+		dbg("Pixis EP0 Read %d bytes", numbytes);
+		totalRead += numbytes;
+		numToRead -= numbytes;
+	} while (numToRead);
+
+	memcpy(ctrl->pData, uBuf, totalRead);
+	dbg("Total Bytes Read from PIXIS EP0 = %d", totalRead);
+	ctrl->numbytes = totalRead;
+
+	if (copy_to_user(arg, ctrl, sizeof(struct ioctl_struct)))
+		dbg("copy_to_user failed in IORB");
+
+	kfree(uBuf);
+	return ctrl->numbytes;
+}
+
+static int pixis_io2(struct ioctl_struct *ctrl, struct device_extension *pdx,
+		struct ioctl_struct *arg)
+{
+	unsigned char *uBuf;
+	int numbytes;
+	int i;
+
+	uBuf = kmalloc(ctrl->numbytes, GFP_KERNEL);
+	if (!uBuf) {
+		dbg("Alloc for uBuf failed");
+		return 0;
+	}
+	numbytes = (int) ctrl->numbytes;
+	/* dbg( "numbytes to read = %d", numbytes ); */
+	if (copy_from_user(uBuf, ctrl->pData, numbytes))
+		dbg("copying ctrl->pData to dummyBuf failed");
+
+	i = usb_bulk_msg(pdx->udev, pdx->hEP[ctrl->endpoint],
+			uBuf, numbytes, &numbytes, HZ * 10);
+	if (i) {
+		dbg("Blocking ReadI/O Failed with status %d", i);
+		kfree(uBuf);
+		return -1;
+	}
+	ctrl->numbytes = numbytes;
+	memcpy(ctrl->pData, uBuf, numbytes);
+	if (copy_to_user(arg, ctrl, sizeof(struct ioctl_struct)))
+		dbg("copy_to_user failed in IORB");
+	kfree(uBuf);
+	return ctrl->numbytes;
+}
+
+static int pixel_data(struct ioctl_struct *ctrl, struct device_extension *pdx)
+{
+	int i;
+
+	if (!pdx->gotPixelData)
+		return 0;
+
+	pdx->gotPixelData = 0;
+	ctrl->numbytes = pdx->bulk_in_size_returned;
+	pdx->bulk_in_size_returned -= pdx->frameSize;
+
+	for (i = 0; i < pdx->maplist_numPagesMapped[pdx->active_frame]; i++)
+		SetPageDirty(pdx->sgl[pdx->active_frame][i].page_link);
+
+	pdx->active_frame = ((pdx->active_frame + 1) % pdx->num_frames);
+
+	return ctrl->numbytes;
+}
+
 /**
  *	piusb_ioctl
  */
@@ -207,12 +312,9 @@ static int piusb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	struct device_extension *pdx;
 	char dummyCtlBuf[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
 	unsigned long devRB = 0;
-	int i = 0;
 	int err = 0;
 	int retval = 0;
 	struct ioctl_struct ctrl;
-	unsigned char *uBuf;
-	int numbytes = 0;
 	unsigned short controlData = 0;
 
 	pdx = (struct device_extension *)file->private_data;
@@ -292,104 +394,28 @@ static int piusb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		return retval;
 
 	case PIUSB_READPIPE:
-		if (copy_from_user
-		    (&ctrl, (void __user *)arg, sizeof(struct ioctl_struct)))
+		if (copy_from_user(&ctrl, (void __user *)arg,
+					sizeof(struct ioctl_struct)))
 			dev_err(&pdx->udev->dev, "copy_from_user failed\n");
+
 		switch (ctrl.endpoint) {
 		case 0:	/* ST133 Pixel Data or PIXIS IO */
 			if (pdx->iama == PIXIS_PID) {
-				unsigned int numToRead = 0;
-				unsigned int totalRead = 0;
-				uBuf = kmalloc(ctrl.numbytes, GFP_KERNEL);
-				if (!uBuf) {
-					dbg("Alloc for uBuf failed");
-					return 0;
-				}
-				numbytes = ctrl.numbytes;
-				numToRead = numbytes;
-				dbg("numbytes to read = %d", numbytes);
-				dbg("endpoint # %d", ctrl.endpoint);
-				if (copy_from_user(uBuf, ctrl.pData, numbytes))
-					dbg("copying ctrl.pData to dummyBuf failed");
-				do {
-					i = usb_bulk_msg(pdx->udev, pdx->hEP[ctrl.endpoint], (uBuf + totalRead), (numToRead > 64) ? 64 : numToRead, &numbytes, HZ * 10);	/* EP0 can only handle 64 bytes at a time */
-					if (i) {
-						dbg("CMD = %s, Address = 0x%02X", ((uBuf[3] == 0x02) ? "WRITE" : "READ"), uBuf[1]);
-						dbg("Number of bytes Attempted to read = %d", (int)ctrl.numbytes);
-						dbg("Blocking ReadI/O Failed with status %d", i);
-						kfree(uBuf);
-						return -1;
-					}
-					dbg("Pixis EP0 Read %d bytes",
-							numbytes);
-					totalRead += numbytes;
-					numToRead -= numbytes;
-				} while (numToRead);
-				memcpy(ctrl.pData, uBuf, totalRead);
-				dbg("Total Bytes Read from PIXIS EP0 = %d",
-				    totalRead);
-				ctrl.numbytes = totalRead;
-				if (copy_to_user
-				    ((struct ioctl_struct *) arg, &ctrl,
-				     sizeof(struct ioctl_struct)))
-					dbg("copy_to_user failed in IORB");
-				kfree(uBuf);
-				return ctrl.numbytes;
+				return pixis_io(&ctrl, pdx,
+						(struct ioctl_struct *)arg);
 			}
 			/* ST133 Pixel Data */
-			if (!pdx->gotPixelData)
-				return 0;
-			pdx->gotPixelData = 0;
-			ctrl.numbytes = pdx->bulk_in_size_returned;
-			pdx->bulk_in_size_returned -= pdx->frameSize;
-			for (i = 0; i < pdx->maplist_numPagesMapped[pdx->active_frame]; i++)
-				SetPageDirty(pdx->sgl[pdx->active_frame][i].page_link);
-			pdx->active_frame = ((pdx->active_frame + 1)
-					% pdx->num_frames);
-			return ctrl.numbytes;
-
-		case 1:	/* ST133IO */
 			/* fall through */
-		case 4:	/* PIXIS IO */
-			uBuf = kmalloc(ctrl.numbytes, GFP_KERNEL);
-			if (!uBuf) {
-				dbg("Alloc for uBuf failed");
-				return 0;
-			}
-			numbytes = ctrl.numbytes;
-			/* dbg( "numbytes to read = %d", numbytes ); */
-			if (copy_from_user(uBuf, ctrl.pData, numbytes))
-				dbg("copying ctrl.pData to dummyBuf failed");
-			i = usb_bulk_msg(pdx->udev, pdx->hEP[ctrl.endpoint],
-					 uBuf, numbytes, &numbytes, HZ * 10);
-			if (i) {
-				dbg("Blocking ReadI/O Failed with status %d",
-				    i);
-				kfree(uBuf);
-				return -1;
-			}
-			ctrl.numbytes = numbytes;
-			memcpy(ctrl.pData, uBuf, numbytes);
-			if (copy_to_user((struct ioctl_struct *) arg, &ctrl,
-						sizeof(struct ioctl_struct)))
-				dbg("copy_to_user failed in IORB");
-			kfree(uBuf);
-			return ctrl.numbytes;
-
 		case 2:	/* PIXIS Ping */
 			/* fall through */
 		case 3:	/* PIXIS Pong */
-			if (!pdx->gotPixelData)
-				return 0;
-			pdx->gotPixelData = 0;
-			ctrl.numbytes = pdx->bulk_in_size_returned;
-			pdx->bulk_in_size_returned -= pdx->frameSize;
-			for (i = 0; i < pdx->maplist_numPagesMapped[pdx->active_frame]; i++)
-				SetPageDirty(pdx->sgl[pdx->active_frame][i].page_link);
-			pdx->active_frame =
-				((pdx->active_frame + 1) % pdx->num_frames);
-			return ctrl.numbytes;
+			return pixel_data(&ctrl, pdx);
 
+		case 1:	/* ST133IO */
+			/* fall through */
+		case 4:	/* PIXIS IO */
+			return pixis_io2(&ctrl, pdx,
+					(struct ioctl_struct *)arg);
 		default:
 			break;
 		}
-- 
1.6.0.4


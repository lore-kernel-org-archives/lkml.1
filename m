Return-Path: <linux-kernel-owner+w=401wt.eu-S1762500AbXJMOpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762500AbXJMOpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761580AbXJMOmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:17 -0400
Received: from 1wt.eu ([62.212.114.60]:2941 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760319AbXJMOmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:15 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143453.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:36 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Oliver Neukum <oneukum@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 14/35] USB: fix DoS in pwc USB video driver
Content-Disposition: inline; filename=0047-USB-fix-DoS-in-pwc-USB-video-driver.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the pwc driver has a disconnect method that waits for user space to
close the device. This opens up an opportunity for a DoS attack,
blocking the USB subsystem and making khubd's task busy wait in
kernel space. This patch shifts freeing resources to close if an opened
device is disconnected.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/media/video/pwc/pwc-if.c |   52 +++++++++++++++++++++++++------------
 drivers/media/video/pwc/pwc.h    |    1 +
 2 files changed, 36 insertions(+), 17 deletions(-)

Index: 2.6/drivers/media/video/pwc/pwc-if.c
===================================================================
--- 2.6.orig/drivers/media/video/pwc/pwc-if.c
+++ 2.6/drivers/media/video/pwc/pwc-if.c
@@ -1196,12 +1196,19 @@ static int pwc_video_open(struct inode *
 	return 0;
 }
 
+
+static void pwc_cleanup(struct pwc_device *pdev)
+{
+	pwc_remove_sysfs_files(pdev->vdev);
+	video_unregister_device(pdev->vdev);
+}
+
 /* Note that all cleanup is done in the reverse order as in _open */
 static int pwc_video_close(struct inode *inode, struct file *file)
 {
 	struct video_device *vdev = file->private_data;
 	struct pwc_device *pdev;
-	int i;
+	int i, hint;
 
 	PWC_DEBUG_OPEN(">> video_close called(vdev = 0x%p).
", vdev);
 
@@ -1224,8 +1231,9 @@ static int pwc_video_close(struct inode 
 	pwc_isoc_cleanup(pdev);
 	pwc_free_buffers(pdev);
 
+	lock_kernel();
 	/* Turn off LEDS and power down camera, but only when not unplugged */
-	if (pdev->error_status != EPIPE) {
+	if (!pdev->unplugged) {
 		/* Turn LEDs off */
 		if (pwc_set_leds(pdev, 0, 0) < 0)
 			PWC_DEBUG_MODULE("Failed to set LED on/off time.
");
@@ -1234,9 +1242,19 @@ static int pwc_video_close(struct inode 
 			if (i < 0)
 				PWC_ERROR("Failed to power down camera (%d)
", i);
 		}
+		pdev->vopen--;
+		PWC_DEBUG_OPEN("<< video_close() vopen=%d
", i);
+	} else {
+		pwc_cleanup(pdev);
+		/* Free memory (don't set pdev to 0 just yet) */
+		kfree(pdev);
+		/* search device_hint[] table if we occupy a slot, by any chance */
+		for (hint = 0; hint < MAX_DEV_HINTS; hint++)
+			if (device_hint[hint].pdev == pdev)
+				device_hint[hint].pdev = NULL;
 	}
-	pdev->vopen--;
-	PWC_DEBUG_OPEN("<< video_close() vopen=%d
", pdev->vopen);
+	unlock_kernel();
+
 	return 0;
 }
 
@@ -1783,21 +1801,21 @@ static void usb_pwc_disconnect(struct us
 	/* Alert waiting processes */
 	wake_up_interruptible(&pdev->frameq);
 	/* Wait until device is closed */
-	while (pdev->vopen)
-		schedule();
-	/* Device is now closed, so we can safely unregister it */
-	PWC_DEBUG_PROBE("Unregistering video device in disconnect().
");
-	pwc_remove_sysfs_files(pdev->vdev);
-	video_unregister_device(pdev->vdev);
-
-	/* Free memory (don't set pdev to 0 just yet) */
-	kfree(pdev);
+	if(pdev->vopen) {
+		pdev->unplugged = 1;
+	} else {
+		/* Device is closed, so we can safely unregister it */
+		PWC_DEBUG_PROBE("Unregistering video device in disconnect().
");
+		pwc_cleanup(pdev);
+		/* Free memory (don't set pdev to 0 just yet) */
+		kfree(pdev);
 
 disconnect_out:
-	/* search device_hint[] table if we occupy a slot, by any chance */
-	for (hint = 0; hint < MAX_DEV_HINTS; hint++)
-		if (device_hint[hint].pdev == pdev)
-			device_hint[hint].pdev = NULL;
+		/* search device_hint[] table if we occupy a slot, by any chance */
+		for (hint = 0; hint < MAX_DEV_HINTS; hint++)
+			if (device_hint[hint].pdev == pdev)
+				device_hint[hint].pdev = NULL;
+	}
 
 	unlock_kernel();
 }
Index: 2.6/drivers/media/video/pwc/pwc.h
===================================================================
--- 2.6.orig/drivers/media/video/pwc/pwc.h
+++ 2.6/drivers/media/video/pwc/pwc.h
@@ -198,6 +198,7 @@ struct pwc_device
    char vsnapshot;		/* snapshot mode */
    char vsync;			/* used by isoc handler */
    char vmirror;		/* for ToUCaM series */
+	char unplugged;
 
    int cmd_len;
    unsigned char cmd_buf[13];

-- 

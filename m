Return-Path: <linux-kernel-owner+w=401wt.eu-S1760021AbYBGCGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021AbYBGCGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 21:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbYBGCGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 21:06:25 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:11007 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051AbYBGCGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 21:06:24 -0500
Date: Wed, 6 Feb 2008 19:06:18 -0700
From: dann frazier <dannf@hp.com>
To: Willy TARREAU <w@1wt.eu>
Cc: Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] 2.4: USB: fix DoS in pwc USB video driver
Message-ID: <20080207020618.GB14829@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a 2.4 backport of a linux-2.6 change by Oliver Neukum.
(commit 85237f202d46d55c1bffe0c5b1aa3ddc0f1dce4d)

CVE-2007-5093 was assigned for this issue.
This backport has been compile-tested only.

Commit log from 2.6 follows.

  the pwc driver has a disconnect method that waits for user space to
  close the device. This opens up an opportunity for a DoS attack,
  blocking the USB subsystem and making khubd's task busy wait in
  kernel space. This patch shifts freeing resources to close if an opened
  device is disconnected.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/usb/pwc-if.c |   50 +++++++++++++++++++++++++++++++++-----------------
 drivers/usb/pwc.h    |    1 +
 2 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/pwc-if.c b/drivers/usb/pwc-if.c
index e458515..a1c3989 100644
--- a/drivers/usb/pwc-if.c
+++ b/drivers/usb/pwc-if.c
@@ -1055,11 +1055,16 @@ static int pwc_video_open(struct video_device *vdev, int mode)
 	return 0;
 }
 
+static void pwc_cleanup(struct pwc_device *pdev)
+{
+	video_unregister_device(&pdev->vdev);
+}
+
 /* Note that all cleanup is done in the reverse order as in _open */
 static void pwc_video_close(struct video_device *vdev)
 {
 	struct pwc_device *pdev;
-	int i;
+	int i, hint;
 
 	Trace(TRACE_OPEN, ">> video_close called(vdev = 0x%p).\n", vdev);
 
@@ -1083,8 +1088,9 @@ static void pwc_video_close(struct video_device *vdev)
 	pwc_isoc_cleanup(pdev);
 	pwc_free_buffers(pdev);
 
+	lock_kernel();
 	/* Turn off LEDS and power down camera, but only when not unplugged */
-	if (pdev->error_status != EPIPE) {
+	if (!pdev->unplugged) {
 		if (pwc_set_leds(pdev, 0, 0) < 0)
 			Info("Failed to set LED on/off time.\n");
 		if (power_save) {
@@ -1092,9 +1098,18 @@ static void pwc_video_close(struct video_device *vdev)
 			if (i < 0) 
 				Err("Failed to power down camera (%d)\n", i);
 		}
+		pdev->vopen = 0;
+		Trace(TRACE_OPEN, "<< video_close()\n");
+	} else {
+		pwc_cleanup(pdev);
+		/* Free memory (don't set pdev to 0 just yet) */
+		kfree(pdev);
+		/* search device_hint[] table if we occupy a slot, by any chance */
+		for (hint = 0; hint < MAX_DEV_HINTS; hint++)
+			if (device_hint[hint].pdev == pdev)
+				device_hint[hint].pdev = NULL;
 	}
-	pdev->vopen = 0;
-	Trace(TRACE_OPEN, "<< video_close()\n");
+	unlock_kernel();
 }
 
 /*
@@ -1897,19 +1912,20 @@ static void usb_pwc_disconnect(struct usb_device *udev, void *ptr)
 	/* Alert waiting processes */
 	wake_up_interruptible(&pdev->frameq);
 	/* Wait until device is closed */
-	while (pdev->vopen)
-		schedule();
-	/* Device is now closed, so we can safely unregister it */
-	Trace(TRACE_PROBE, "Unregistering video device in disconnect().\n");
-	video_unregister_device(&pdev->vdev); 
-
-	/* Free memory (don't set pdev to 0 just yet) */
-	kfree(pdev);
-
-	/* search device_hint[] table if we occupy a slot, by any chance */
-	for (hint = 0; hint < MAX_DEV_HINTS; hint++)
-		if (device_hint[hint].pdev == pdev)
-			device_hint[hint].pdev = NULL;
+	if(pdev->vopen) {
+		pdev->unplugged = 1;
+	} else {
+		/* Device is closed, so we can safely unregister it */
+		Trace(TRACE_PROBE, "Unregistering video device in disconnect().\n");
+		pwc_cleanup(pdev);
+		/* Free memory (don't set pdev to 0 just yet) */
+		kfree(pdev);
+	
+		/* search device_hint[] table if we occupy a slot, by any chance */
+		for (hint = 0; hint < MAX_DEV_HINTS; hint++)
+			if (device_hint[hint].pdev == pdev)
+				device_hint[hint].pdev = NULL;
+	}
 
 	unlock_kernel();
 }
diff --git a/drivers/usb/pwc.h b/drivers/usb/pwc.h
index b020769..999daf2 100644
--- a/drivers/usb/pwc.h
+++ b/drivers/usb/pwc.h
@@ -141,6 +141,7 @@ struct pwc_device
    char vsnapshot;		/* snapshot mode */
    char vsync;			/* used by isoc handler */
    char vmirror;		/* for ToUCaM series */
+	char unplugged;
 
    /* The image acquisition requires 3 to 4 steps:
       1. data is gathered in short packets from the USB controller
-- 
1.5.3.7


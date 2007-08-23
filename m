Return-Path: <linux-kernel-owner+w=401wt.eu-S964883AbXHWWlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883AbXHWWlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932494AbXHWWac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:30:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33331 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383AbXHWWaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:30:30 -0400
Date: Thu, 23 Aug 2007 15:27:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-usb-devel@lists.sourceforge.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oneukum@suse.de>
Subject: [patch 27/28] USB: fix DoS in pwc USB video driver
Message-ID: <20070823222757.GA18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-dos-in-pwc-usb-video-driver.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Neukum <oneukum@suse.de>

the pwc driver has a disconnect method that waits for user space to
close the device. This opens up an opportunity for a DoS attack,
blocking the USB subsystem and making khubd's task busy wait in
kernel space. This patch shifts freeing resources to close if an opened
device is disconnected.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/pwc/pwc-if.c |   52 ++++++++++++++++++++++++++-------------
 drivers/media/video/pwc/pwc.h    |    1 
 2 files changed, 36 insertions(+), 17 deletions(-)

--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
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
 
 	PWC_DEBUG_OPEN(">> video_close called(vdev = 0x%p).\n", vdev);
 
@@ -1224,8 +1231,9 @@ static int pwc_video_close(struct inode 
 	pwc_isoc_cleanup(pdev);
 	pwc_free_buffers(pdev);
 
+	lock_kernel();
 	/* Turn off LEDS and power down camera, but only when not unplugged */
-	if (pdev->error_status != EPIPE) {
+	if (!pdev->unplugged) {
 		/* Turn LEDs off */
 		if (pwc_set_leds(pdev, 0, 0) < 0)
 			PWC_DEBUG_MODULE("Failed to set LED on/off time.\n");
@@ -1234,9 +1242,19 @@ static int pwc_video_close(struct inode 
 			if (i < 0)
 				PWC_ERROR("Failed to power down camera (%d)\n", i);
 		}
+		pdev->vopen--;
+		PWC_DEBUG_OPEN("<< video_close() vopen=%d\n", i);
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
-	PWC_DEBUG_OPEN("<< video_close() vopen=%d\n", pdev->vopen);
+	unlock_kernel();
+
 	return 0;
 }
 
@@ -1791,21 +1809,21 @@ static void usb_pwc_disconnect(struct us
 	/* Alert waiting processes */
 	wake_up_interruptible(&pdev->frameq);
 	/* Wait until device is closed */
-	while (pdev->vopen)
-		schedule();
-	/* Device is now closed, so we can safely unregister it */
-	PWC_DEBUG_PROBE("Unregistering video device in disconnect().\n");
-	pwc_remove_sysfs_files(pdev->vdev);
-	video_unregister_device(pdev->vdev);
-
-	/* Free memory (don't set pdev to 0 just yet) */
-	kfree(pdev);
+	if(pdev->vopen) {
+		pdev->unplugged = 1;
+	} else {
+		/* Device is closed, so we can safely unregister it */
+		PWC_DEBUG_PROBE("Unregistering video device in disconnect().\n");
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
--- a/drivers/media/video/pwc/pwc.h
+++ b/drivers/media/video/pwc/pwc.h
@@ -193,6 +193,7 @@ struct pwc_device
    char vsnapshot;		/* snapshot mode */
    char vsync;			/* used by isoc handler */
    char vmirror;		/* for ToUCaM series */
+	char unplugged;
 
    int cmd_len;
    unsigned char cmd_buf[13];

-- 

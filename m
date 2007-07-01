Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbXGAQ3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbXGAQ3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 12:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbXGAQ3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 12:29:33 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:37267
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754039AbXGAQ3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 12:29:33 -0400
Date: Sun, 1 Jul 2007 18:30:41 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: mchehab@infradead.org, video4linux-list@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/5] use mutex instead of semaphore in Philips webcam driver
Message-ID: <20070701163041.GE3940@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	mchehab@infradead.org, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070701162529.GC3940@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701162529.GC3940@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Philips webcam driver uses a semaphore as mutex. Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index 085332a..9c0e8d1 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -1099,7 +1099,7 @@ static int pwc_video_open(struct inode *inode, struct file *file)
 		return -EBUSY;
 	}
 
-	down(&pdev->modlock);
+	mutex_lock(&pdev->modlock);
 	if (!pdev->usb_init) {
 		PWC_DEBUG_OPEN("Doing first time initialization.\n");
 		pdev->usb_init = 1;
@@ -1131,7 +1131,7 @@ static int pwc_video_open(struct inode *inode, struct file *file)
 	if (i < 0) {
 		PWC_DEBUG_OPEN("Failed to allocate buffers memory.\n");
 		pwc_free_buffers(pdev);
-		up(&pdev->modlock);
+		mutex_unlock(&pdev->modlock);
 		return i;
 	}
 
@@ -1172,7 +1172,7 @@ static int pwc_video_open(struct inode *inode, struct file *file)
 	if (i) {
 		PWC_DEBUG_OPEN("Second attempt at set_video_mode failed.\n");
 		pwc_free_buffers(pdev);
-		up(&pdev->modlock);
+		mutex_unlock(&pdev->modlock);
 		return i;
 	}
 
@@ -1181,7 +1181,7 @@ static int pwc_video_open(struct inode *inode, struct file *file)
 		PWC_DEBUG_OPEN("Failed to init ISOC stuff = %d.\n", i);
 		pwc_isoc_cleanup(pdev);
 		pwc_free_buffers(pdev);
-		up(&pdev->modlock);
+		mutex_unlock(&pdev->modlock);
 		return i;
 	}
 
@@ -1191,7 +1191,7 @@ static int pwc_video_open(struct inode *inode, struct file *file)
 
 	pdev->vopen++;
 	file->private_data = vdev;
-	up(&pdev->modlock);
+	mutex_unlock(&pdev->modlock);
 	PWC_DEBUG_OPEN("<< video_open() returns 0.\n");
 	return 0;
 }
@@ -1685,7 +1685,7 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 		pdev->angle_range.tilt_max =  2500;
 	}
 
-	init_MUTEX(&pdev->modlock);
+	mutex_init(&pdev->modlock);
 	spin_lock_init(&pdev->ptrlock);
 
 	pdev->udev = udev;
diff --git a/drivers/media/video/pwc/pwc.h b/drivers/media/video/pwc/pwc.h
index acbb931..910a04f 100644
--- a/drivers/media/video/pwc/pwc.h
+++ b/drivers/media/video/pwc/pwc.h
@@ -31,7 +31,7 @@
 #include <linux/wait.h>
 #include <linux/smp_lock.h>
 #include <linux/version.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 #include <asm/errno.h>
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
@@ -244,7 +244,7 @@ struct pwc_device
    int image_read_pos;			/* In case we read data in pieces, keep track of were we are in the imagebuffer */
    int image_used[MAX_IMAGES];		/* For MCAPTURE and SYNC */
 
-   struct semaphore modlock;		/* to prevent races in video_open(), etc */
+   struct mutex modlock;		/* to prevent races in video_open(), etc */
    spinlock_t ptrlock;			/* for manipulating the buffer pointers */
 
    /*** motorized pan/tilt feature */


-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

             "The only important thing Windows does better
            than Debian is implementing the win32 platform"
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-

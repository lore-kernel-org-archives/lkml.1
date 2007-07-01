Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbXGAQcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbXGAQcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 12:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXGAQcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 12:32:41 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:43254
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752325AbXGAQcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 12:32:41 -0400
Date: Sun, 1 Jul 2007 18:33:49 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: mchehab@infradead.org, video4linux-list@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 4/5] use mutex instead of semaphore in Virtual Video driver
Message-ID: <20070701163349.GG3940@traven>
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

The Virtual Video driver uses a semaphore as mutex. Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index f7e1d19..e86f4cd 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <linux/random.h>
 #include <linux/version.h>
+#include <linux/mutex.h>
 #include <linux/videodev2.h>
 #include <linux/dma-mapping.h>
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
@@ -168,7 +169,7 @@ static LIST_HEAD(vivi_devlist);
 struct vivi_dev {
 	struct list_head           vivi_devlist;
 
-	struct semaphore           lock;
+	struct mutex               lock;
 
 	int                        users;
 
@@ -892,16 +893,16 @@ static struct videobuf_queue_ops vivi_video_qops = {
 static int res_get(struct vivi_dev *dev, struct vivi_fh *fh)
 {
 	/* is it free? */
-	down(&dev->lock);
+	mutex_lock(&dev->lock);
 	if (dev->resources) {
 		/* no, someone else uses it */
-		up(&dev->lock);
+		mutex_unlock(&dev->lock);
 		return 0;
 	}
 	/* it's free, grab it */
 	dev->resources =1;
 	dprintk(1,"res: get\n");
-	up(&dev->lock);
+	mutex_unlock(&dev->lock);
 	return 1;
 }
 
@@ -912,10 +913,10 @@ static int res_locked(struct vivi_dev *dev)
 
 static void res_free(struct vivi_dev *dev, struct vivi_fh *fh)
 {
-	down(&dev->lock);
+	mutex_lock(&dev->lock);
 	dev->resources = 0;
 	dprintk(1,"res: put\n");
-	up(&dev->lock);
+	mutex_lock(&dev->lock);
 }
 
 /* ------------------------------------------------------------------
@@ -1422,7 +1423,7 @@ static int __init vivi_init(void)
 	init_waitqueue_head(&dev->vidq.wq);
 
 	/* initialize locks */
-	init_MUTEX(&dev->lock);
+	mutex_init(&dev->lock);
 
 	dev->vidq.timeout.function = vivi_vid_timeout;
 	dev->vidq.timeout.data     = (unsigned long)dev;

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

      In itself, homosexuality is as limiting as heterosexuality: the
     ideal should be to be capable of loving a woman or a man; either,
      a human being, without  feeling fear, restraint, or obligation
                          (Simone de Beauvoir)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-

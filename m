Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360Ab0AWAYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab0AWAYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746Ab0AWAY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:24:28 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43320 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab0AWAY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:24:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=i5FZu3ffYhENxr42LvF9KOUBWngFufQr3IWFuAKAa3qu1flLEpXFSRByeZ/LeqQLUv
         7yDzRJmTpWPhqqFMaCF5OFbKp8f8IXwL2H7rsf82xVy31/pgRK9pjDjnusJf3Iyx2IJ6
         U6Q6SqOJkD9Cta/BBjAPNdYex0VoFWRr3dxHU=
Subject: [PATCH 5/8] blktrans: add proper locking
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1264205925.31827.3.camel@maxim-laptop>
References: <1264205925.31827.3.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Jan 2010 02:24:22 +0200
Message-ID: <1264206262.31827.9.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 695c50a575ba7e004931e234f4706766be507289 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Sat, 23 Jan 2010 02:07:53 +0200
Subject: [PATCH 5/8] blktrans: add proper locking

First, use lockless versions of get/put_mtd_device
We don't care what happened to mtd table, because we have a pointer
to mtd device. It guaranteed to exist till we do final put_mtd_device

Also add locking to prevent all kinds or races

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c |   83 ++++++++++++++++++++++++++++----------------
 1 files changed, 53 insertions(+), 30 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index c95e1ff..f165115 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -123,34 +123,34 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
 {
 	struct mtd_blktrans_dev *dev = bdev->bd_disk->private_data;
 	struct mtd_blktrans_ops *tr = dev->tr;
-	int ret = -ENODEV;
-
-	if (!get_mtd_device(NULL, dev->mtd->index))
-		goto out;
+	int ret = 0;
 
+	mutex_lock(&dev->lock);
 	if (dev->open++)
 		goto out;
 
 	if (dev->deleted)
 		goto out;
 
-
+	ret = -ENODEV;
 	if (!try_module_get(tr->owner))
-		goto out_tr;
+		goto out;
+
+	if (__get_mtd_device(dev->mtd)) {
+		module_put(tr->owner);
+		goto out;
+	}
 
-	/* FIXME: Locking. A hot pluggable device can go away
-	   (del_mtd_device can be called for it) without its module
-	   being unloaded. */
-	dev->mtd->usecount++;
 
 	ret = 0;
 	if (tr->open && (ret = tr->open(dev))) {
-		dev->mtd->usecount--;
-		put_mtd_device(dev->mtd);
-	out_tr:
 		module_put(tr->owner);
+		__put_mtd_device(dev->mtd);
+		goto out;
+
 	}
  out:
+	mutex_unlock(&dev->lock);
 	return ret;
 }
 
@@ -160,18 +160,11 @@ static int blktrans_release(struct gendisk *disk, fmode_t mode)
 	struct mtd_blktrans_ops *tr = dev->tr;
 	int ret = 0;
 
+	mutex_lock(&dev->lock);
 	dev->open--;
 	if (dev->open)
 		return 0;
 
-	if (tr->release)
-		ret = tr->release(dev);
-
-	if (!ret) {
-		dev->mtd->usecount--;
-		put_mtd_device(dev->mtd);
-		module_put(tr->owner);
-	}
 
 	/* Free the private data */
 	if (dev->deleted) {
@@ -181,33 +174,59 @@ static int blktrans_release(struct gendisk *disk, fmode_t mode)
 		return 0;
 	}
 
+	ret = tr->release ? tr->release(dev) : 0;
+	module_put(tr->owner);
+
+	if (dev->mtd)
+		__put_mtd_device(dev->mtd);
+out:
+	mutex_unlock(&dev->lock);
 	return ret;
 }
 
 static int blktrans_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
 	struct mtd_blktrans_dev *dev = bdev->bd_disk->private_data;
+	int error;
+
+	mutex_lock(&dev->lock);
 
+	error = -ENODEV;
+	if (dev->deleted)
+		goto out;
+
+	error = -ENOTTY;
 	if (dev->tr->getgeo)
-		return dev->tr->getgeo(dev, geo);
-	return -ENOTTY;
+		error = dev->tr->getgeo(dev, geo);
+out:
+	mutex_unlock(&dev->lock);
+	return error;
 }
 
 static int blktrans_ioctl(struct block_device *bdev, fmode_t mode,
 			      unsigned int cmd, unsigned long arg)
 {
 	struct mtd_blktrans_dev *dev = bdev->bd_disk->private_data;
-	struct mtd_blktrans_ops *tr = dev->tr;
+	int error = -ENODEV;
+
+	mutex_lock(&dev->lock);
+
+	if (dev->deleted)
+		goto out;
+
+	error = -ENOTTY;
 
 	switch (cmd) {
 	case BLKFLSBUF:
-		if (tr->flush)
-			return tr->flush(dev);
-		/* The core code did the work, we had nothing to do. */
-		return 0;
+		if (dev->tr->flush)
+			error = dev->tr->flush(dev);
+		break;
 	default:
-		return -ENOTTY;
+		break;
 	}
+out:
+	mutex_unlock(&dev->lock);
+	return error;
 }
 
 static const struct block_device_operations mtd_blktrans_ops = {
@@ -355,15 +374,19 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 	/* Stop the thread */
 	kthread_stop(old->thread);
 
+	/* Tell trans driver to release the device */
+	mutex_lock(&old->lock);
+
 	if (old->open) {
 		if (old->tr->release)
 			old->tr->release(old);
-		put_mtd_device(old->mtd);
+		__put_mtd_device(old->mtd);
 	}
 
 	/* From now on, no calls into trans can be made */
 	/* Mtd device will be gone real soon now */
 	old->mtd = NULL;
+	mutex_unlock(&old->lock);
 
  
 	blk_cleanup_queue(old->rq);
-- 
1.6.3.3




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0BIQ6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 11:58:17 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:38923 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab0BIQ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 11:58:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SrIaYBxt6lj/1F6L5VfDWRL0IrwJh8ueXx5Hb58rPCCg0I53SnR2ZE/XePMbOlYLab
         mKQMD7aahJXduIWmgt8NLHN5f6f8bCImWN3OJcYsxyiNQ+Q+esU0sO/PP+/KaZuE2smS
         EaZU9MPiLDLItW1WUzLbZXATGRtGkybjwceBE=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 05/17] blktrans: add proper locking
Date: Tue,  9 Feb 2010 18:57:33 +0200
Message-Id: <1265734665-22656-6-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265734665-22656-1-git-send-email-maximlevitsky@gmail.com>
References: <1265734665-22656-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, use lockless versions of get/put_mtd_device
We don't care what happened to mtd table, because we have a pointer
to mtd device. It guaranteed to exist till we do final put_mtd_device

Also add locking to prevent all kinds or races

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c |   84 ++++++++++++++++++++++++++++----------------
 1 files changed, 53 insertions(+), 31 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 1b89e59..082969c 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -123,33 +123,33 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
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
 
+	ret = -ENODEV;
 	if (!try_module_get(tr->owner))
-		goto out_tr;
+		goto out;
 
-	/* FIXME: Locking. A hot pluggable device can go away
-	   (del_mtd_device can be called for it) without its module
-	   being unloaded. */
-	dev->mtd->usecount++;
+	if (__get_mtd_device(dev->mtd)) {
+		module_put(tr->owner);
+		goto out;
+	}
 
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
 
@@ -159,17 +159,10 @@ static int blktrans_release(struct gendisk *disk, fmode_t mode)
 	struct mtd_blktrans_ops *tr = dev->tr;
 	int ret = 0;
 
+	mutex_lock(&dev->lock);
 	if (--dev->open)
-		return 0;
-
-	if (tr->release)
-		ret = tr->release(dev);
+		goto out;
 
-	if (!ret) {
-		dev->mtd->usecount--;
-		put_mtd_device(dev->mtd);
-		module_put(tr->owner);
-	}
 
 	/* Free the private data */
 	if (dev->deleted) {
@@ -179,33 +172,59 @@ static int blktrans_release(struct gendisk *disk, fmode_t mode)
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
@@ -353,16 +372,19 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
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
-
+	mutex_unlock(&old->lock);
 	blk_cleanup_queue(old->rq);
 	return 0;
 }
-- 
1.6.3.3


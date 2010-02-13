Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab0BMNDn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 08:03:43 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:49010 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab0BMNDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:03:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DGpw4RfBUg2mAooQ5JkpmPUrIn5wjHmrPwML7mPDaYRPaBJ4RA1zcHx+GxLv+aaapa
         xqsj/NnCO4XebCterXve8Py1urVtnBhEBYDyOP/E3KRE3ehcnakUFMdNHKoVTyUSxQyP
         BPU2Fp11llY1QntaE5VRZPNb8hKOEq4ifl6Ds=
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
Subject: [PATCH 03/14] blktrans: Hotplug fixes
Date: Sat, 13 Feb 2010 15:03:02 +0200
Message-Id: <1266066193-17625-4-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266066193-17625-1-git-send-email-maximlevitsky@gmail.com>
References: <1266066193-17625-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add locking where it was missing.
* Don't do a get_mtd_device in blktrans_open because it would lead to a deadlock
  instead do that in add_mtd_blktrans_dev.

* Only free the mtd_blktrans_dev structure when the last user exits.

* Flush request queue on device removal.

* Track users, and call tr->release in del_mtd_blktrans_dev
  Due to that ->open and release aren't called more that once.

Now it is safe to call del_mtd_blktrans_dev while the device is still in use.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/ftl.c            |    1 -
 drivers/mtd/inftlcore.c      |    1 -
 drivers/mtd/mtd_blkdevs.c    |  183 ++++++++++++++++++++++++++++++------------
 drivers/mtd/mtdblock.c       |    1 -
 drivers/mtd/mtdblock_ro.c    |    1 -
 drivers/mtd/nftlcore.c       |    1 -
 drivers/mtd/rfd_ftl.c        |    1 -
 drivers/mtd/ssfdc.c          |    1 -
 include/linux/mtd/blktrans.h |    3 +
 9 files changed, 134 insertions(+), 59 deletions(-)

diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
index e56d6b4..62da9eb 100644
--- a/drivers/mtd/ftl.c
+++ b/drivers/mtd/ftl.c
@@ -1082,7 +1082,6 @@ static void ftl_remove_dev(struct mtd_blktrans_dev *dev)
 {
 	del_mtd_blktrans_dev(dev);
 	ftl_freepart((partition_t *)dev);
-	kfree(dev);
 }
 
 static struct mtd_blktrans_ops ftl_tr = {
diff --git a/drivers/mtd/inftlcore.c b/drivers/mtd/inftlcore.c
index 8aca552..015a7fe 100755
--- a/drivers/mtd/inftlcore.c
+++ b/drivers/mtd/inftlcore.c
@@ -139,7 +139,6 @@ static void inftl_remove_dev(struct mtd_blktrans_dev *dev)
 
 	kfree(inftl->PUtable);
 	kfree(inftl->VUtable);
-	kfree(inftl);
 }
 
 /*
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index bbdb26d..1bc9c76 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -24,6 +24,39 @@
 #include "mtdcore.h"
 
 static LIST_HEAD(blktrans_majors);
+static DEFINE_MUTEX(blktrans_ref_mutex);
+
+void blktrans_dev_release(struct kref *kref)
+{
+	struct mtd_blktrans_dev *dev =
+		container_of(kref, struct mtd_blktrans_dev, ref);
+
+	dev->disk->private_data = NULL;
+	put_disk(dev->disk);
+	kfree(dev);
+}
+
+static struct mtd_blktrans_dev *blktrans_dev_get(struct gendisk *disk)
+{
+	struct mtd_blktrans_dev *dev;
+
+	mutex_lock(&blktrans_ref_mutex);
+	dev = disk->private_data;
+
+	if (!dev)
+		goto unlock;
+	kref_get(&dev->ref);
+unlock:
+	mutex_unlock(&blktrans_ref_mutex);
+	return dev;
+}
+
+void blktrans_dev_put(struct mtd_blktrans_dev *dev)
+{
+	mutex_lock(&blktrans_ref_mutex);
+	kref_put(&dev->ref, blktrans_dev_release);
+	mutex_unlock(&blktrans_ref_mutex);
+}
 
 
 static int do_blktrans_request(struct mtd_blktrans_ops *tr,
@@ -111,81 +144,102 @@ static int mtd_blktrans_thread(void *arg)
 
 static void mtd_blktrans_request(struct request_queue *rq)
 {
-	struct mtd_blktrans_dev *dev = rq->queuedata;
-	wake_up_process(dev->thread);
-}
+	struct mtd_blktrans_dev *dev;
+	struct request *req = NULL;
+
+	dev = rq->queuedata;
 
+	if (!dev)
+		while ((req = blk_fetch_request(rq)) != NULL)
+			__blk_end_request_all(req, -ENODEV);
+	else
+		wake_up_process(dev->thread);
+}
 
 static int blktrans_open(struct block_device *bdev, fmode_t mode)
 {
-	struct mtd_blktrans_dev *dev = bdev->bd_disk->private_data;
-	struct mtd_blktrans_ops *tr = dev->tr;
-	int ret = -ENODEV;
-
-	if (!get_mtd_device(NULL, dev->mtd->index))
-		goto out;
-
-	if (!try_module_get(tr->owner))
-		goto out_tr;
-
-	/* FIXME: Locking. A hot pluggable device can go away
-	   (del_mtd_device can be called for it) without its module
-	   being unloaded. */
-	dev->mtd->usecount++;
-
-	ret = 0;
-	if (tr->open && (ret = tr->open(dev))) {
-		dev->mtd->usecount--;
-		put_mtd_device(dev->mtd);
-	out_tr:
-		module_put(tr->owner);
-	}
- out:
+	struct mtd_blktrans_dev *dev = blktrans_dev_get(bdev->bd_disk);
+	int ret = -ENXIO;
+
+	if (!dev)
+		return ret;
+
+	mutex_lock(&dev->lock);
+
+	if (!dev->mtd)
+		goto unlock;
+
+	ret = !dev->open++ && dev->tr->open ? dev->tr->open(dev) : 0;
+unlock:
+	mutex_unlock(&dev->lock);
+	blktrans_dev_put(dev);
 	return ret;
 }
 
 static int blktrans_release(struct gendisk *disk, fmode_t mode)
 {
-	struct mtd_blktrans_dev *dev = disk->private_data;
-	struct mtd_blktrans_ops *tr = dev->tr;
-	int ret = 0;
+	struct mtd_blktrans_dev *dev = blktrans_dev_get(disk);
+	int ret = -ENXIO;
+
+	if (!dev)
+		return ret;
 
-	if (tr->release)
-		ret = tr->release(dev);
+	mutex_lock(&dev->lock);
 
-	if (!ret) {
-		dev->mtd->usecount--;
-		put_mtd_device(dev->mtd);
-		module_put(tr->owner);
-	}
+	if (!dev->mtd)
+		goto unlock;
 
+	ret = !--dev->open && dev->tr->release ? dev->tr->release(dev) : 0;
+unlock:
+	mutex_unlock(&dev->lock);
+	blktrans_dev_put(dev);
 	return ret;
 }
 
 static int blktrans_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
-	struct mtd_blktrans_dev *dev = bdev->bd_disk->private_data;
+	struct mtd_blktrans_dev *dev = blktrans_dev_get(bdev->bd_disk);
+	int ret = -ENXIO;
+
+	if (!dev)
+		return ret;
+
+	mutex_lock(&dev->lock);
+
+	if (!dev->mtd)
+		goto unlock;
 
-	if (dev->tr->getgeo)
-		return dev->tr->getgeo(dev, geo);
-	return -ENOTTY;
+	ret = dev->tr->getgeo ? dev->tr->getgeo(dev, geo) : 0;
+unlock:
+	mutex_unlock(&dev->lock);
+	blktrans_dev_put(dev);
+	return ret;
 }
 
 static int blktrans_ioctl(struct block_device *bdev, fmode_t mode,
 			      unsigned int cmd, unsigned long arg)
 {
-	struct mtd_blktrans_dev *dev = bdev->bd_disk->private_data;
-	struct mtd_blktrans_ops *tr = dev->tr;
+	struct mtd_blktrans_dev *dev = blktrans_dev_get(bdev->bd_disk);
+	int ret = -ENXIO;
+
+	if (!dev)
+		return ret;
+
+	mutex_lock(&dev->lock);
+
+	if (!dev->mtd)
+		goto unlock;
 
 	switch (cmd) {
 	case BLKFLSBUF:
-		if (tr->flush)
-			return tr->flush(dev);
-		/* The core code did the work, we had nothing to do. */
-		return 0;
+		ret = dev->tr->flush ? dev->tr->flush(dev) : 0;
 	default:
-		return -ENOTTY;
+		ret = -ENOTTY;
 	}
+unlock:
+	mutex_unlock(&dev->lock);
+	blktrans_dev_put(dev);
+	return ret;
 }
 
 static const struct block_device_operations mtd_blktrans_ops = {
@@ -239,10 +293,10 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	list_add_tail(&new->list, &tr->devs);
  added:
 	mutex_init(&new->lock);
+	kref_init(&new->ref);
 	if (!tr->writesect)
 		new->readonly = 1;
 
-
 	/* Create gendisk */
 	ret = -ENOMEM;
 	gd = alloc_disk(1 << tr->part_bits);
@@ -271,7 +325,6 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 
 	set_capacity(gd, (new->size * tr->blksize) >> 9);
 
-
 	/* Create the request queue */
 	spin_lock_init(&new->queue_lock);
 	new->rq = blk_init_queue(mtd_blktrans_request, &new->queue_lock);
@@ -288,6 +341,9 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 
 	gd->queue = new->rq;
 
+	__get_mtd_device(new->mtd);
+	__module_get(tr->owner);
+
 	/* Create processing thread */
 	/* TODO: workqueue ? */
 	new->thread = kthread_run(mtd_blktrans_thread, new,
@@ -305,6 +361,8 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 
 	return 0;
 error4:
+	module_put(tr->owner);
+	__put_mtd_device(new->mtd);
 	blk_cleanup_queue(new->rq);
 error3:
 	put_disk(new->disk);
@@ -317,6 +375,8 @@ error1:
 
 int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 {
+	unsigned long flags;
+
 	if (mutex_trylock(&mtd_table_mutex)) {
 		mutex_unlock(&mtd_table_mutex);
 		BUG();
@@ -324,13 +384,34 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 
 	list_del(&old->list);
 
-	/* stop new requests to arrive */
+	/* Stop new requests to arrive */
 	del_gendisk(old->disk);
 
 	/* Stop the thread */
 	kthread_stop(old->thread);
 
+	/* Kill current requests */
+	spin_lock_irqsave(&old->queue_lock, flags);
+	old->rq->queuedata = NULL;
+	blk_start_queue(old->rq);
+	spin_unlock_irqrestore(&old->queue_lock, flags);
 	blk_cleanup_queue(old->rq);
+
+	/* Ask trans driver for release to the mtd device */
+	mutex_lock(&old->lock);
+	if (old->open && old->tr->release) {
+		old->tr->release(old);
+		old->open = 0;
+	}
+
+	__put_mtd_device(old->mtd);
+	module_put(old->tr->owner);
+
+	/* At that point, we don't touch the mtd anymore */
+	old->mtd = NULL;
+
+	mutex_unlock(&old->lock);
+	blktrans_dev_put(old);
 	return 0;
 }
 
@@ -393,7 +474,6 @@ int register_mtd_blktrans(struct mtd_blktrans_ops *tr)
 	}
 
 	mutex_unlock(&mtd_table_mutex);
-
 	return 0;
 }
 
@@ -403,7 +483,6 @@ int deregister_mtd_blktrans(struct mtd_blktrans_ops *tr)
 
 	mutex_lock(&mtd_table_mutex);
 
-
 	/* Remove it from the list of active majors */
 	list_del(&tr->list);
 
diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index 9f41b1a..d8322cc 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -368,7 +368,6 @@ static void mtdblock_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
 static void mtdblock_remove_dev(struct mtd_blktrans_dev *dev)
 {
 	del_mtd_blktrans_dev(dev);
-	kfree(dev);
 }
 
 static struct mtd_blktrans_ops mtdblock_tr = {
diff --git a/drivers/mtd/mtdblock_ro.c b/drivers/mtd/mtdblock_ro.c
index 852165f..54ff288 100644
--- a/drivers/mtd/mtdblock_ro.c
+++ b/drivers/mtd/mtdblock_ro.c
@@ -49,7 +49,6 @@ static void mtdblock_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
 static void mtdblock_remove_dev(struct mtd_blktrans_dev *dev)
 {
 	del_mtd_blktrans_dev(dev);
-	kfree(dev);
 }
 
 static struct mtd_blktrans_ops mtdblock_tr = {
diff --git a/drivers/mtd/nftlcore.c b/drivers/mtd/nftlcore.c
index 1002e18..a4578bf 100644
--- a/drivers/mtd/nftlcore.c
+++ b/drivers/mtd/nftlcore.c
@@ -126,7 +126,6 @@ static void nftl_remove_dev(struct mtd_blktrans_dev *dev)
 	del_mtd_blktrans_dev(dev);
 	kfree(nftl->ReplUnitTable);
 	kfree(nftl->EUNtable);
-	kfree(nftl);
 }
 
 /*
diff --git a/drivers/mtd/rfd_ftl.c b/drivers/mtd/rfd_ftl.c
index d2aa9c4..63b83c0 100644
--- a/drivers/mtd/rfd_ftl.c
+++ b/drivers/mtd/rfd_ftl.c
@@ -817,7 +817,6 @@ static void rfd_ftl_remove_dev(struct mtd_blktrans_dev *dev)
 	vfree(part->sector_map);
 	kfree(part->header_cache);
 	kfree(part->blocks);
-	kfree(part);
 }
 
 static struct mtd_blktrans_ops rfd_ftl_tr = {
diff --git a/drivers/mtd/ssfdc.c b/drivers/mtd/ssfdc.c
index 3f67e00..81c4ecd 100644
--- a/drivers/mtd/ssfdc.c
+++ b/drivers/mtd/ssfdc.c
@@ -375,7 +375,6 @@ static void ssfdcr_remove_dev(struct mtd_blktrans_dev *dev)
 
 	del_mtd_blktrans_dev(dev);
 	kfree(ssfdc->logic_block_map);
-	kfree(ssfdc);
 }
 
 static int ssfdcr_readsect(struct mtd_blktrans_dev *dev,
diff --git a/include/linux/mtd/blktrans.h b/include/linux/mtd/blktrans.h
index a4b3928..d89b8fb 100644
--- a/include/linux/mtd/blktrans.h
+++ b/include/linux/mtd/blktrans.h
@@ -9,6 +9,7 @@
 #define __MTD_TRANS_H__
 
 #include <linux/mutex.h>
+#include <linux/kref.h>
 
 struct hd_geometry;
 struct mtd_info;
@@ -24,6 +25,8 @@ struct mtd_blktrans_dev {
 	int devnum;
 	unsigned long size;
 	int readonly;
+	int open;
+	struct kref ref;
 	struct gendisk *disk;
 	struct task_struct *thread;
 	struct request_queue *rq;
-- 
1.6.3.3


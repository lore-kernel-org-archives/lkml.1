Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344Ab0AFVqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab0AFVqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334Ab0AFVqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:46:51 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:33441 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab0AFVqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:46:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OHeN78jupzPA8KYk8zspBihCtujyuFQ/VZ0i6L4gnEdi6uG89W8XY4Us4PpVjukLAI
         ihWGLCJrK12c2PeI36Vy6gI+d+7nZhKdd5gLfrTxH1m25ci1TKsOvBjPxS2Jp5UMPul2
         OdP3dPyQhvXatO1bhyZWGvafOqZVDt6dG6Ha4=
Subject: [PATCH 3/9] MTD: blkdevs: major cleanups
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>,
       joern <joern@logfs.org>
In-Reply-To: <1262814216.14552.22.camel@maxim-laptop>
References: <1262814216.14552.22.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 23:46:39 +0200
Message-ID: <1262814399.14552.25.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ebc405ef4e2bcf14870e1b17fb3e356f1a20980c Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Tue, 5 Jan 2010 23:25:12 +0200
Subject: [PATCH 3/9] MTD: blkdevs: major cleanups.

* Make disk queue and thread per mtd device
* Handle the case of mtd device diappearence correctly

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/ftl.c            |    1 -
 drivers/mtd/inftlcore.c      |    1 -
 drivers/mtd/mtd_blkdevs.c    |  237 ++++++++++++++++++++++++++---------------
 drivers/mtd/mtdblock.c       |    1 -
 drivers/mtd/mtdblock_ro.c    |    1 -
 drivers/mtd/mtdcore.c        |    3 +-
 drivers/mtd/nftlcore.c       |    1 -
 drivers/mtd/rfd_ftl.c        |    1 -
 drivers/mtd/ssfdc.c          |    1 -
 include/linux/mtd/blktrans.h |   13 ++-
 10 files changed, 160 insertions(+), 100 deletions(-)

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
index 8ca17a3..6af4673 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -26,11 +26,6 @@
 
 static LIST_HEAD(blktrans_majors);
 
-struct mtd_blkcore_priv {
-	struct task_struct *thread;
-	struct request_queue *rq;
-	spinlock_t queue_lock;
-};
 
 static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 			       struct mtd_blktrans_dev *dev,
@@ -78,8 +73,8 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 
 static int mtd_blktrans_thread(void *arg)
 {
-	struct mtd_blktrans_ops *tr = arg;
-	struct request_queue *rq = tr->blkcore_priv->rq;
+	struct mtd_blktrans_dev *dev = arg;
+	struct request_queue *rq = dev->rq;
 	struct request *req = NULL;
 
 	/* we might get involved when memory gets low, so use PF_MEMALLOC */
@@ -88,7 +83,6 @@ static int mtd_blktrans_thread(void *arg)
 	spin_lock_irq(rq->queue_lock);
 
 	while (!kthread_should_stop()) {
-		struct mtd_blktrans_dev *dev;
 		int res;
 
 		if (!req && !(req = blk_fetch_request(rq))) {
@@ -99,13 +93,10 @@ static int mtd_blktrans_thread(void *arg)
 			continue;
 		}
 
-		dev = req->rq_disk->private_data;
-		tr = dev->tr;
-
 		spin_unlock_irq(rq->queue_lock);
 
 		mutex_lock(&dev->lock);
-		res = do_blktrans_request(tr, dev, req);
+		res = do_blktrans_request(dev->tr, dev, req);
 		mutex_unlock(&dev->lock);
 
 		spin_lock_irq(rq->queue_lock);
@@ -124,8 +115,14 @@ static int mtd_blktrans_thread(void *arg)
 
 static void mtd_blktrans_request(struct request_queue *rq)
 {
-	struct mtd_blktrans_ops *tr = rq->queuedata;
-	wake_up_process(tr->blkcore_priv->thread);
+	struct mtd_blktrans_dev *dev = rq->queuedata;
+	struct request *req = NULL;
+
+	if (dev->deleted)
+		while ((req = blk_fetch_request(rq)) != NULL)
+			__blk_end_request_all(req, -ENODEV);
+	else
+		wake_up_process(dev->thread);
 }
 

@@ -133,72 +130,108 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
 {
 	struct mtd_blktrans_dev *dev = bdev->bd_disk->private_data;
 	struct mtd_blktrans_ops *tr = dev->tr;
-	int ret = -ENODEV;
+	int ret = 0;
+
+	mutex_lock(&dev->lock);
+	if (dev->open++)
+		goto out;
 
-	if (!get_mtd_device(NULL, dev->mtd->index))
+	if (dev->deleted)
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
 	}
  out:
+	mutex_unlock(&dev->lock);
 	return ret;
 }
 
+
 static int blktrans_release(struct gendisk *disk, fmode_t mode)
 {
 	struct mtd_blktrans_dev *dev = disk->private_data;
 	struct mtd_blktrans_ops *tr = dev->tr;
 	int ret = 0;
 
-	if (tr->release)
-		ret = tr->release(dev);
+	mutex_lock(&dev->lock);
+	dev->open--;
+	if (dev->open)
+		goto out;
 
-	if (!ret) {
-		dev->mtd->usecount--;
-		put_mtd_device(dev->mtd);
+	/* Free the private data */
+	if (dev->deleted) {
 		module_put(tr->owner);
+		mutex_unlock(&dev->lock);
+		kfree(dev);
+		return 0;
 	}
 
+	ret = tr->release ? tr->release(dev) : 0;
+	module_put(tr->owner);
+
+	if(dev->mtd)
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
@@ -215,6 +248,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	struct mtd_blktrans_dev *d;
 	int last_devnum = -1;
 	struct gendisk *gd;
+	int ret;
 
 	if (mutex_trylock(&mtd_table_mutex)) {
 		mutex_unlock(&mtd_table_mutex);
@@ -240,12 +274,13 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 		}
 		last_devnum = d->devnum;
 	}
+
+	ret=  -EBUSY;
 	if (new->devnum == -1)
 		new->devnum = last_devnum+1;
 
-	if ((new->devnum << tr->part_bits) > 256) {
-		return -EBUSY;
-	}
+	if ((new->devnum << tr->part_bits) > 256)
+		goto error1;
 
 	list_add_tail(&new->list, &tr->devs);
  added:
@@ -253,11 +288,16 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	if (!tr->writesect)
 		new->readonly = 1;
 
+
+	/* Create gendisk */
+	ret = -ENOMEM;
 	gd = alloc_disk(1 << tr->part_bits);
-	if (!gd) {
-		list_del(&new->list);
-		return -ENOMEM;
-	}
+
+	if (!gd)
+		goto error2;
+
+	new->disk = gd;
+	gd->private_data = new;
 	gd->major = tr->major;
 	gd->first_minor = (new->devnum) << tr->part_bits;
 	gd->fops = &mtd_blktrans_ops;
@@ -275,25 +315,58 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 		snprintf(gd->disk_name, sizeof(gd->disk_name),
 			 "%s%d", tr->name, new->devnum);
 
-	/* 2.5 has capacity in units of 512 bytes while still
-	   having BLOCK_SIZE_BITS set to 10. Just to keep us amused. */
 	set_capacity(gd, (new->size * tr->blksize) >> 9);
 
-	gd->private_data = new;
-	new->blkcore_priv = gd;
-	gd->queue = tr->blkcore_priv->rq;
+
+	/* Create the request queue */
+	spin_lock_init(&new->queue_lock);
+	new->rq = blk_init_queue(mtd_blktrans_request, &new->queue_lock);
+
+	if (!new->rq)
+		goto error3;
+
+	new->rq->queuedata = new;
+	blk_queue_logical_block_size(new->rq, tr->blksize);
+
+	if (tr->discard)
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
+					new->rq);
+
+	gd->queue = new->rq;
+
+	/* Create processing thread */
+	/* TODO: workqueue ? */
+	new->thread = kthread_run(mtd_blktrans_thread, new,
+			"%s%d", tr->name, new->mtd->index);
+	if (IS_ERR(new->thread)) {
+		ret = PTR_ERR(new->thread);
+		goto error4;
+	}
+
 	gd->driverfs_dev = &new->mtd->dev;
 
 	if (new->readonly)
 		set_disk_ro(gd, 1);
 
+	new->open = 0;
 	add_disk(gd);
 
 	return 0;
+error4:
+	blk_cleanup_queue(new->rq);
+error3:
+	put_disk(new->disk);
+error2:
+	list_del(&new->list);
+error1:
+	kfree(new);
+	return ret;
 }
 
 int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 {
+	unsigned long flags;
+
 	if (mutex_trylock(&mtd_table_mutex)) {
 		mutex_unlock(&mtd_table_mutex);
 		BUG();
@@ -301,9 +374,35 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 
 	list_del(&old->list);
 
-	del_gendisk(old->blkcore_priv);
-	put_disk(old->blkcore_priv);
+	/* stop new requests to arrive */
+	del_gendisk(old->disk);
+
+
+	/* flush current requests */
+	spin_lock_irqsave(&old->queue_lock, flags);
+	old->deleted = 1;
+	blk_start_queue(old->rq);
+	spin_unlock_irqrestore(&old->queue_lock, flags);
+
+
+	/* Stop the thread */
+	kthread_stop(old->thread);
 
+	/* Tell trans driver to release the device */
+	mutex_lock(&old->lock);
+
+	if (old->open) {
+		if (old->tr->release)
+			old->tr->release(old);
+		__put_mtd_device(old->mtd);
+	}
+
+	/* From now on, no calls into trans can be made */
+	/* Mtd device will be gone real soon now */
+	old->mtd = NULL;
+	mutex_unlock(&old->lock);
+
+	blk_cleanup_queue(old->rq);
 	return 0;
 }
 
@@ -344,9 +443,6 @@ int register_mtd_blktrans(struct mtd_blktrans_ops *tr)
 	if (!blktrans_notifier.list.next)
 		register_mtd_user(&blktrans_notifier);
 
-	tr->blkcore_priv = kzalloc(sizeof(*tr->blkcore_priv), GFP_KERNEL);
-	if (!tr->blkcore_priv)
-		return -ENOMEM;
 
 	mutex_lock(&mtd_table_mutex);
 
@@ -354,39 +450,12 @@ int register_mtd_blktrans(struct mtd_blktrans_ops *tr)
 	if (ret) {
 		printk(KERN_WARNING "Unable to register %s block device on major %d: %d\n",
 		       tr->name, tr->major, ret);
-		kfree(tr->blkcore_priv);
 		mutex_unlock(&mtd_table_mutex);
 		return ret;
 	}
-	spin_lock_init(&tr->blkcore_priv->queue_lock);
-
-	tr->blkcore_priv->rq = blk_init_queue(mtd_blktrans_request, &tr->blkcore_priv->queue_lock);
-	if (!tr->blkcore_priv->rq) {
-		unregister_blkdev(tr->major, tr->name);
-		kfree(tr->blkcore_priv);
-		mutex_unlock(&mtd_table_mutex);
-		return -ENOMEM;
-	}
-
-	tr->blkcore_priv->rq->queuedata = tr;
-	blk_queue_logical_block_size(tr->blkcore_priv->rq, tr->blksize);
-	if (tr->discard)
-		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
-					tr->blkcore_priv->rq);
 
 	tr->blkshift = ffs(tr->blksize) - 1;
 
-	tr->blkcore_priv->thread = kthread_run(mtd_blktrans_thread, tr,
-			"%sd", tr->name);
-	if (IS_ERR(tr->blkcore_priv->thread)) {
-		int ret = PTR_ERR(tr->blkcore_priv->thread);
-		blk_cleanup_queue(tr->blkcore_priv->rq);
-		unregister_blkdev(tr->major, tr->name);
-		kfree(tr->blkcore_priv);
-		mutex_unlock(&mtd_table_mutex);
-		return ret;
-	}
-
 	INIT_LIST_HEAD(&tr->devs);
 	list_add(&tr->list, &blktrans_majors);
 
@@ -406,8 +475,6 @@ int deregister_mtd_blktrans(struct mtd_blktrans_ops *tr)
 
 	mutex_lock(&mtd_table_mutex);
 
-	/* Clean up the kernel thread */
-	kthread_stop(tr->blkcore_priv->thread);
 
 	/* Remove it from the list of active majors */
 	list_del(&tr->list);
@@ -415,13 +482,9 @@ int deregister_mtd_blktrans(struct mtd_blktrans_ops *tr)
 	list_for_each_entry_safe(dev, next, &tr->devs, list)
 		tr->remove_dev(dev);
 
-	blk_cleanup_queue(tr->blkcore_priv->rq);
 	unregister_blkdev(tr->major, tr->name);
-
 	mutex_unlock(&mtd_table_mutex);
 
-	kfree(tr->blkcore_priv);
-
 	BUG_ON(!list_empty(&tr->devs));
 	return 0;
 }
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
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index e9daf87..8c9c020 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -532,7 +532,6 @@ void put_mtd_device(struct mtd_info *mtd)
 	__put_mtd_device(mtd);
 	mutex_unlock(&mtd_table_mutex);
 
-	module_put(mtd->owner);
 }
 
 void __put_mtd_device(struct mtd_info *mtd)
@@ -542,6 +541,8 @@ void __put_mtd_device(struct mtd_info *mtd)
 
 	if (mtd->put_device)
 		mtd->put_device(mtd);
+
+	module_put(mtd->owner);
 }
 
 /* default_mtd_writev - default mtd writev method for MTD devices that
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
index 8b4aa05..054b053 100644
--- a/include/linux/mtd/blktrans.h
+++ b/include/linux/mtd/blktrans.h
@@ -24,10 +24,15 @@ struct mtd_blktrans_dev {
 	int devnum;
 	unsigned long size;
 	int readonly;
-	void *blkcore_priv; /* gendisk in 2.5, devfs_handle in 2.4 */
-};
+	int deleted;
+	int open;
 
-struct blkcore_priv; /* Differs for 2.4 and 2.5 kernels; private */
+	struct gendisk *disk;
+	struct task_struct *thread;
+	struct request_queue *rq;
+	spinlock_t queue_lock;
+	void *priv;
+};
 
 struct mtd_blktrans_ops {
 	char *name;
@@ -60,8 +65,6 @@ struct mtd_blktrans_ops {
 	struct list_head devs;
 	struct list_head list;
 	struct module *owner;
-
-	struct mtd_blkcore_priv *blkcore_priv;
 };
 
 extern int register_mtd_blktrans(struct mtd_blktrans_ops *tr);
-- 
1.6.3.3




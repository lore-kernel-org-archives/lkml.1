Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab0BVSkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:40:05 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56979 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab0BVSj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:39:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=B1kJTpT/w4iq/Vq073KxvxFN054HLgNicjDNyIPCyysKnM52mx3rRhQal28Mb3jgDt
         xjvK1W3bA0z/taoRCwlLDB9rVtVOP0QFpWzdsSUu2/+a8gnaDSbHxacAUt71KRY09gvo
         g6ECiwivp0iFYPkx1m5rw0mQ9A4228wVNjfGI=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>, <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 02/15] blktrans: remove mtd_blkcore_priv and switch to per device queue and thread
Date: Mon, 22 Feb 2010 20:39:29 +0200
Message-Id: <1266863982-5258-3-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
References: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the biggest change. To make hotplug possible, and this layer clean,
the mtd_blktrans_dev now contains everything for a single mtd block translation device.
Also removed some very old leftovers

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c    |  124 ++++++++++++++++++++----------------------
 include/linux/mtd/blktrans.h |   10 ++--
 2 files changed, 63 insertions(+), 71 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 2f8c202..6a57262 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -14,7 +14,6 @@
 #include <linux/mtd/mtd.h>
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
-#include <linux/freezer.h>
 #include <linux/spinlock.h>
 #include <linux/hdreg.h>
 #include <linux/init.h>
@@ -26,11 +25,6 @@
 
 static LIST_HEAD(blktrans_majors);
 
-struct mtd_blkcore_priv {
-	struct task_struct *thread;
-	struct request_queue *rq;
-	spinlock_t queue_lock;
-};
 
 static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 			       struct mtd_blktrans_dev *dev,
@@ -61,7 +55,6 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 				return -EIO;
 		rq_flush_dcache_pages(req);
 		return 0;
-
 	case WRITE:
 		if (!tr->writesect)
 			return -EIO;
@@ -71,7 +64,6 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 			if (tr->writesect(dev, block, buf))
 				return -EIO;
 		return 0;
-
 	default:
 		printk(KERN_NOTICE "Unknown request %u\n", rq_data_dir(req));
 		return -EIO;
@@ -80,14 +72,13 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 
 static int mtd_blktrans_thread(void *arg)
 {
-	struct mtd_blktrans_ops *tr = arg;
-	struct request_queue *rq = tr->blkcore_priv->rq;
+	struct mtd_blktrans_dev *dev = arg;
+	struct request_queue *rq = dev->rq;
 	struct request *req = NULL;
 
 	spin_lock_irq(rq->queue_lock);
 
 	while (!kthread_should_stop()) {
-		struct mtd_blktrans_dev *dev;
 		int res;
 
 		if (!req && !(req = blk_fetch_request(rq))) {
@@ -98,13 +89,10 @@ static int mtd_blktrans_thread(void *arg)
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
@@ -123,8 +111,8 @@ static int mtd_blktrans_thread(void *arg)
 
 static void mtd_blktrans_request(struct request_queue *rq)
 {
-	struct mtd_blktrans_ops *tr = rq->queuedata;
-	wake_up_process(tr->blkcore_priv->thread);
+	struct mtd_blktrans_dev *dev = rq->queuedata;
+	wake_up_process(dev->thread);
 }
 
 
@@ -214,6 +202,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	struct mtd_blktrans_dev *d;
 	int last_devnum = -1;
 	struct gendisk *gd;
+	int ret;
 
 	if (mutex_trylock(&mtd_table_mutex)) {
 		mutex_unlock(&mtd_table_mutex);
@@ -239,6 +228,8 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 		}
 		last_devnum = d->devnum;
 	}
+
+	ret = -EBUSY;
 	if (new->devnum == -1)
 		new->devnum = last_devnum+1;
 
@@ -247,7 +238,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	 * with this number. */
 	if (new->devnum > (MINORMASK >> tr->part_bits) ||
 	    (tr->part_bits && new->devnum >= 27 * 26))
-		return -EBUSY;
+		goto error1;
 
 	list_add_tail(&new->list, &tr->devs);
  added:
@@ -255,11 +246,16 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
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
@@ -277,21 +273,49 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
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
 	gd->driverfs_dev = &new->mtd->dev;
 
 	if (new->readonly)
 		set_disk_ro(gd, 1);
 
 	add_disk(gd);
-
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
@@ -303,9 +327,13 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 
 	list_del(&old->list);
 
-	del_gendisk(old->blkcore_priv);
-	put_disk(old->blkcore_priv);
+	/* stop new requests to arrive */
+	del_gendisk(old->disk);
 
+	/* Stop the thread */
+	kthread_stop(old->thread);
+
+	blk_cleanup_queue(old->rq);
 	return 0;
 }
 
@@ -347,9 +375,6 @@ int register_mtd_blktrans(struct mtd_blktrans_ops *tr)
 	if (!blktrans_notifier.list.next)
 		register_mtd_user(&blktrans_notifier);
 
-	tr->blkcore_priv = kzalloc(sizeof(*tr->blkcore_priv), GFP_KERNEL);
-	if (!tr->blkcore_priv)
-		return -ENOMEM;
 
 	mutex_lock(&mtd_table_mutex);
 
@@ -357,39 +382,12 @@ int register_mtd_blktrans(struct mtd_blktrans_ops *tr)
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
-		ret = PTR_ERR(tr->blkcore_priv->thread);
-		blk_cleanup_queue(tr->blkcore_priv->rq);
-		unregister_blkdev(tr->major, tr->name);
-		kfree(tr->blkcore_priv);
-		mutex_unlock(&mtd_table_mutex);
-		return ret;
-	}
-
 	INIT_LIST_HEAD(&tr->devs);
 	list_add(&tr->list, &blktrans_majors);
 
@@ -408,8 +406,6 @@ int deregister_mtd_blktrans(struct mtd_blktrans_ops *tr)
 
 	mutex_lock(&mtd_table_mutex);
 
-	/* Clean up the kernel thread */
-	kthread_stop(tr->blkcore_priv->thread);
 
 	/* Remove it from the list of active majors */
 	list_del(&tr->list);
@@ -417,13 +413,9 @@ int deregister_mtd_blktrans(struct mtd_blktrans_ops *tr)
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
diff --git a/include/linux/mtd/blktrans.h b/include/linux/mtd/blktrans.h
index 8b4aa05..a4b3928 100644
--- a/include/linux/mtd/blktrans.h
+++ b/include/linux/mtd/blktrans.h
@@ -24,11 +24,13 @@ struct mtd_blktrans_dev {
 	int devnum;
 	unsigned long size;
 	int readonly;
-	void *blkcore_priv; /* gendisk in 2.5, devfs_handle in 2.4 */
+	struct gendisk *disk;
+	struct task_struct *thread;
+	struct request_queue *rq;
+	spinlock_t queue_lock;
+	void *priv;
 };
 
-struct blkcore_priv; /* Differs for 2.4 and 2.5 kernels; private */
-
 struct mtd_blktrans_ops {
 	char *name;
 	int major;
@@ -60,8 +62,6 @@ struct mtd_blktrans_ops {
 	struct list_head devs;
 	struct list_head list;
 	struct module *owner;
-
-	struct mtd_blkcore_priv *blkcore_priv;
 };
 
 extern int register_mtd_blktrans(struct mtd_blktrans_ops *tr);
-- 
1.6.3.3


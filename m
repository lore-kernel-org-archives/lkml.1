Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab0BIRBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:01:35 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:65144 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab0BIQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 11:58:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AEMIgK72c4Uq0xTYVqPZhyyYdCeptlUzOxYX9jAiFcaqJ2I+eKq0ptABNtiBGc/zcH
         u3mN+iKRlieLsmop2E1qw9/oYLxOqy5bvZDjby3bXVLGOThtB8U79QCUUlk3HleGwZhK
         v64jFGy4FcvjaxMpBac4+nnLGGdI7DeaqgBDE=
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
Subject: [PATCH 02/17] blktrans: nuke mtd_blkcore_priv and make both thread and disk queue be per device
Date: Tue,  9 Feb 2010 18:57:30 +0200
Message-Id: <1265734665-22656-3-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265734665-22656-1-git-send-email-maximlevitsky@gmail.com>
References: <1265734665-22656-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the biggest change. To make hotplug possible, and this layer clearer, now
mtd_blktrans_dev contains everything for a single mtd block translation device.
Also removed some very old leftovers

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c    |  123 ++++++++++++++++++++----------------------
 include/linux/mtd/blktrans.h |   10 ++--
 2 files changed, 64 insertions(+), 69 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index c82e09b..93c87af 100644
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
@@ -80,14 +75,13 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 
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
@@ -98,13 +92,10 @@ static int mtd_blktrans_thread(void *arg)
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
@@ -123,8 +114,8 @@ static int mtd_blktrans_thread(void *arg)
 
 static void mtd_blktrans_request(struct request_queue *rq)
 {
-	struct mtd_blktrans_ops *tr = rq->queuedata;
-	wake_up_process(tr->blkcore_priv->thread);
+	struct mtd_blktrans_dev *dev = rq->queuedata;
+	wake_up_process(dev->thread);
 }
 
 
@@ -214,6 +205,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	struct mtd_blktrans_dev *d;
 	int last_devnum = -1;
 	struct gendisk *gd;
+	int ret;
 
 	if (mutex_trylock(&mtd_table_mutex)) {
 		mutex_unlock(&mtd_table_mutex);
@@ -239,12 +231,13 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 		}
 		last_devnum = d->devnum;
 	}
+
+	ret = -EBUSY;
 	if (new->devnum == -1)
 		new->devnum = last_devnum+1;
 
-	if ((new->devnum << tr->part_bits) > 256) {
-		return -EBUSY;
-	}
+	if ((new->devnum << tr->part_bits) > 256)
+		goto error1;
 
 	list_add_tail(&new->list, &tr->devs);
  added:
@@ -252,11 +245,16 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
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
@@ -274,13 +272,33 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
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
@@ -289,6 +307,15 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
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
@@ -300,9 +327,13 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 
 	list_del(&old->list);
 
-	del_gendisk(old->blkcore_priv);
-	put_disk(old->blkcore_priv);
+	/* stop new requests to arrive */
+	del_gendisk(old->disk);
+
+	/* Stop the thread */
+	kthread_stop(old->thread);
 
+	blk_cleanup_queue(old->rq);
 	return 0;
 }
 
@@ -343,9 +374,6 @@ int register_mtd_blktrans(struct mtd_blktrans_ops *tr)
 	if (!blktrans_notifier.list.next)
 		register_mtd_user(&blktrans_notifier);
 
-	tr->blkcore_priv = kzalloc(sizeof(*tr->blkcore_priv), GFP_KERNEL);
-	if (!tr->blkcore_priv)
-		return -ENOMEM;
 
 	mutex_lock(&mtd_table_mutex);
 
@@ -353,39 +381,12 @@ int register_mtd_blktrans(struct mtd_blktrans_ops *tr)
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
 
@@ -405,8 +406,6 @@ int deregister_mtd_blktrans(struct mtd_blktrans_ops *tr)
 
 	mutex_lock(&mtd_table_mutex);
 
-	/* Clean up the kernel thread */
-	kthread_stop(tr->blkcore_priv->thread);
 
 	/* Remove it from the list of active majors */
 	list_del(&tr->list);
@@ -414,13 +413,9 @@ int deregister_mtd_blktrans(struct mtd_blktrans_ops *tr)
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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZEZJgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZEZJgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZEZJeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:34:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54800 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbZEZJdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:33:53 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 03/12] writeback: move dirty inodes from super_block to backing_dev_info
Date: Tue, 26 May 2009 11:33:41 +0200
Message-Id: <1243330430-9964-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a first step at introducing per-bdi flusher threads. We should
have no change in behaviour, although sb_has_dirty_inodes() is now
ridiculously expensive, as there's no easy way to answer that question.
Not a huge problem, since it'll be deleted in subsequent patches.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c           |  196 +++++++++++++++++++++++++++---------------
 fs/super.c                  |    3 -
 include/linux/backing-dev.h |    9 ++
 include/linux/fs.h          |    5 +-
 mm/backing-dev.c            |   24 +++++
 mm/page-writeback.c         |   11 +--
 6 files changed, 164 insertions(+), 84 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 91013ff..1137408 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -25,6 +25,7 @@
 #include <linux/buffer_head.h>
 #include "internal.h"
 
+#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
 
 /**
  * writeback_acquire - attempt to get exclusive writeback access to a device
@@ -158,12 +159,13 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			goto out;
 
 		/*
-		 * If the inode was already on s_dirty/s_io/s_more_io, don't
-		 * reposition it (that would break s_dirty time-ordering).
+		 * If the inode was already on b_dirty/b_io/b_more_io, don't
+		 * reposition it (that would break b_dirty time-ordering).
 		 */
 		if (!was_dirty) {
 			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &sb->s_dirty);
+			list_move(&inode->i_list,
+					&inode_to_bdi(inode)->b_dirty);
 		}
 	}
 out:
@@ -184,31 +186,30 @@ static int write_inode(struct inode *inode, int sync)
  * furthest end of its superblock's dirty-inode list.
  *
  * Before stamping the inode's ->dirtied_when, we check to see whether it is
- * already the most-recently-dirtied inode on the s_dirty list.  If that is
+ * already the most-recently-dirtied inode on the b_dirty list.  If that is
  * the case then the inode must have been redirtied while it was being written
  * out and we don't reset its dirtied_when.
  */
 static void redirty_tail(struct inode *inode)
 {
-	struct super_block *sb = inode->i_sb;
+	struct backing_dev_info *bdi = inode_to_bdi(inode);
 
-	if (!list_empty(&sb->s_dirty)) {
-		struct inode *tail_inode;
+	if (!list_empty(&bdi->b_dirty)) {
+		struct inode *tail;
 
-		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
-		if (time_before(inode->dirtied_when,
-				tail_inode->dirtied_when))
+		tail = list_entry(bdi->b_dirty.next, struct inode, i_list);
+		if (time_before(inode->dirtied_when, tail->dirtied_when))
 			inode->dirtied_when = jiffies;
 	}
-	list_move(&inode->i_list, &sb->s_dirty);
+	list_move(&inode->i_list, &bdi->b_dirty);
 }
 
 /*
- * requeue inode for re-scanning after sb->s_io list is exhausted.
+ * requeue inode for re-scanning after bdi->b_io list is exhausted.
  */
 static void requeue_io(struct inode *inode)
 {
-	list_move(&inode->i_list, &inode->i_sb->s_more_io);
+	list_move(&inode->i_list, &inode_to_bdi(inode)->b_more_io);
 }
 
 static void inode_sync_complete(struct inode *inode)
@@ -255,18 +256,50 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 /*
  * Queue all expired dirty inodes for io, eldest first.
  */
-static void queue_io(struct super_block *sb,
-				unsigned long *older_than_this)
+static void queue_io(struct backing_dev_info *bdi,
+		     unsigned long *older_than_this)
+{
+	list_splice_init(&bdi->b_more_io, bdi->b_io.prev);
+	move_expired_inodes(&bdi->b_dirty, &bdi->b_io, older_than_this);
+}
+
+static int sb_on_inode_list(struct super_block *sb, struct list_head *list)
 {
-	list_splice_init(&sb->s_more_io, sb->s_io.prev);
-	move_expired_inodes(&sb->s_dirty, &sb->s_io, older_than_this);
+	struct inode *inode;
+	int ret = 0;
+
+	spin_lock(&inode_lock);
+	list_for_each_entry(inode, list, i_list) {
+		if (inode->i_sb == sb) {
+			ret = 1;
+			break;
+		}
+	}
+	spin_unlock(&inode_lock);
+	return ret;
 }
 
 int sb_has_dirty_inodes(struct super_block *sb)
 {
-	return !list_empty(&sb->s_dirty) ||
-	       !list_empty(&sb->s_io) ||
-	       !list_empty(&sb->s_more_io);
+	struct backing_dev_info *bdi;
+	int ret = 0;
+
+	/*
+	 * This is REALLY expensive right now, but it'll go away
+	 * when the bdi writeback is introduced
+	 */
+	mutex_lock(&bdi_lock);
+	list_for_each_entry(bdi, &bdi_list, bdi_list) {
+		if (sb_on_inode_list(sb, &bdi->b_dirty) ||
+		    sb_on_inode_list(sb, &bdi->b_io) ||
+		    sb_on_inode_list(sb, &bdi->b_more_io)) {
+			ret = 1;
+			break;
+		}
+	}
+	mutex_unlock(&bdi_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(sb_has_dirty_inodes);
 
@@ -322,11 +355,11 @@ __sync_single_inode(struct inode *inode, struct writeback_control *wbc)
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
 			 * sometimes bales out without doing anything. Redirty
-			 * the inode; Move it from s_io onto s_more_io/s_dirty.
+			 * the inode; Move it from b_io onto b_more_io/b_dirty.
 			 */
 			/*
 			 * akpm: if the caller was the kupdate function we put
-			 * this inode at the head of s_dirty so it gets first
+			 * this inode at the head of b_dirty so it gets first
 			 * consideration.  Otherwise, move it to the tail, for
 			 * the reasons described there.  I'm not really sure
 			 * how much sense this makes.  Presumably I had a good
@@ -336,7 +369,7 @@ __sync_single_inode(struct inode *inode, struct writeback_control *wbc)
 			if (wbc->for_kupdate) {
 				/*
 				 * For the kupdate function we move the inode
-				 * to s_more_io so it will get more writeout as
+				 * to b_more_io so it will get more writeout as
 				 * soon as the queue becomes uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
@@ -402,10 +435,10 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	if ((wbc->sync_mode != WB_SYNC_ALL) && (inode->i_state & I_SYNC)) {
 		/*
 		 * We're skipping this inode because it's locked, and we're not
-		 * doing writeback-for-data-integrity.  Move it to s_more_io so
-		 * that writeback can proceed with the other inodes on s_io.
+		 * doing writeback-for-data-integrity.  Move it to b_more_io so
+		 * that writeback can proceed with the other inodes on b_io.
 		 * We'll have another go at writing back this inode when we
-		 * completed a full scan of s_io.
+		 * completed a full scan of b_io.
 		 */
 		requeue_io(inode);
 		return 0;
@@ -428,51 +461,34 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	return __sync_single_inode(inode, wbc);
 }
 
-/*
- * Write out a superblock's list of dirty inodes.  A wait will be performed
- * upon no inodes, all inodes or the final one, depending upon sync_mode.
- *
- * If older_than_this is non-NULL, then only write out inodes which
- * had their first dirtying at a time earlier than *older_than_this.
- *
- * If we're a pdflush thread, then implement pdflush collision avoidance
- * against the entire list.
- *
- * If `bdi' is non-zero then we're being asked to writeback a specific queue.
- * This function assumes that the blockdev superblock's inodes are backed by
- * a variety of queues, so all inodes are searched.  For other superblocks,
- * assume that all inodes are backed by the same queue.
- *
- * FIXME: this linear search could get expensive with many fileystems.  But
- * how to fix?  We need to go from an address_space to all inodes which share
- * a queue with that address_space.  (Easy: have a global "dirty superblocks"
- * list).
- *
- * The inodes to be written are parked on sb->s_io.  They are moved back onto
- * sb->s_dirty as they are selected for writing.  This way, none can be missed
- * on the writer throttling path, and we get decent balancing between many
- * throttled threads: we don't want them all piling up on inode_sync_wait.
- */
-void generic_sync_sb_inodes(struct super_block *sb,
-				struct writeback_control *wbc)
+static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
+				    struct writeback_control *wbc,
+				    struct super_block *sb,
+				    int is_blkdev_sb)
 {
 	const unsigned long start = jiffies;	/* livelock avoidance */
-	int sync = wbc->sync_mode == WB_SYNC_ALL;
 
 	spin_lock(&inode_lock);
-	if (!wbc->for_kupdate || list_empty(&sb->s_io))
-		queue_io(sb, wbc->older_than_this);
 
-	while (!list_empty(&sb->s_io)) {
-		struct inode *inode = list_entry(sb->s_io.prev,
+	if (!wbc->for_kupdate || list_empty(&bdi->b_io))
+		queue_io(bdi, wbc->older_than_this);
+
+	while (!list_empty(&bdi->b_io)) {
+		struct inode *inode = list_entry(bdi->b_io.prev,
 						struct inode, i_list);
-		struct address_space *mapping = inode->i_mapping;
-		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		long pages_skipped;
 
+		/*
+		 * super block given and doesn't match, skip this inode
+		 */
+		if (sb && sb != inode->i_sb) {
+			redirty_tail(inode);
+			continue;
+		}
+
 		if (!bdi_cap_writeback_dirty(bdi)) {
 			redirty_tail(inode);
-			if (sb_is_blkdev_sb(sb)) {
+			if (is_blkdev_sb) {
 				/*
 				 * Dirty memory-backed blockdev: the ramdisk
 				 * driver does this.  Skip just this inode
@@ -494,14 +510,14 @@ void generic_sync_sb_inodes(struct super_block *sb,
 
 		if (wbc->nonblocking && bdi_write_congested(bdi)) {
 			wbc->encountered_congestion = 1;
-			if (!sb_is_blkdev_sb(sb))
+			if (!is_blkdev_sb)
 				break;		/* Skip a congested fs */
 			requeue_io(inode);
 			continue;		/* Skip a congested blockdev */
 		}
 
 		if (wbc->bdi && bdi != wbc->bdi) {
-			if (!sb_is_blkdev_sb(sb))
+			if (!is_blkdev_sb)
 				break;		/* fs has the wrong queue */
 			requeue_io(inode);
 			continue;		/* blockdev has wrong queue */
@@ -539,13 +555,55 @@ void generic_sync_sb_inodes(struct super_block *sb,
 			wbc->more_io = 1;
 			break;
 		}
-		if (!list_empty(&sb->s_more_io))
+		if (!list_empty(&bdi->b_more_io))
 			wbc->more_io = 1;
 	}
 
-	if (sync) {
+	spin_unlock(&inode_lock);
+	/* Leave any unwritten inodes on b_io */
+}
+
+/*
+ * Write out a superblock's list of dirty inodes.  A wait will be performed
+ * upon no inodes, all inodes or the final one, depending upon sync_mode.
+ *
+ * If older_than_this is non-NULL, then only write out inodes which
+ * had their first dirtying at a time earlier than *older_than_this.
+ *
+ * If we're a pdlfush thread, then implement pdflush collision avoidance
+ * against the entire list.
+ *
+ * If `bdi' is non-zero then we're being asked to writeback a specific queue.
+ * This function assumes that the blockdev superblock's inodes are backed by
+ * a variety of queues, so all inodes are searched.  For other superblocks,
+ * assume that all inodes are backed by the same queue.
+ *
+ * FIXME: this linear search could get expensive with many fileystems.  But
+ * how to fix?  We need to go from an address_space to all inodes which share
+ * a queue with that address_space.  (Easy: have a global "dirty superblocks"
+ * list).
+ *
+ * The inodes to be written are parked on bdi->b_io.  They are moved back onto
+ * bdi->b_dirty as they are selected for writing.  This way, none can be missed
+ * on the writer throttling path, and we get decent balancing between many
+ * throttled threads: we don't want them all piling up on inode_sync_wait.
+ */
+void generic_sync_sb_inodes(struct super_block *sb,
+				struct writeback_control *wbc)
+{
+	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
+	struct backing_dev_info *bdi;
+
+	mutex_lock(&bdi_lock);
+	list_for_each_entry(bdi, &bdi_list, bdi_list)
+		generic_sync_bdi_inodes(bdi, wbc, sb, is_blkdev_sb);
+	mutex_unlock(&bdi_lock);
+
+	if (wbc->sync_mode == WB_SYNC_ALL) {
 		struct inode *inode, *old_inode = NULL;
 
+		spin_lock(&inode_lock);
+
 		/*
 		 * Data integrity sync. Must wait for all pages under writeback,
 		 * because there may have been pages dirtied before our sync
@@ -583,10 +641,8 @@ void generic_sync_sb_inodes(struct super_block *sb,
 		}
 		spin_unlock(&inode_lock);
 		iput(old_inode);
-	} else
-		spin_unlock(&inode_lock);
+	}
 
-	return;		/* Leave any unwritten inodes on s_io */
 }
 EXPORT_SYMBOL_GPL(generic_sync_sb_inodes);
 
@@ -601,8 +657,8 @@ static void sync_sb_inodes(struct super_block *sb,
  *
  * Note:
  * We don't need to grab a reference to superblock here. If it has non-empty
- * ->s_dirty it's hadn't been killed yet and kill_super() won't proceed
- * past sync_inodes_sb() until the ->s_dirty/s_io/s_more_io lists are all
+ * ->b_dirty it's hadn't been killed yet and kill_super() won't proceed
+ * past sync_inodes_sb() until the ->b_dirty/b_io/b_more_io lists are all
  * empty. Since __sync_single_inode() regains inode_lock before it finally moves
  * inode from superblock lists we are OK.
  *
diff --git a/fs/super.c b/fs/super.c
index 1943fdf..76dd5b2 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -64,9 +64,6 @@ static struct super_block *alloc_super(struct file_system_type *type)
 			s = NULL;
 			goto out;
 		}
-		INIT_LIST_HEAD(&s->s_dirty);
-		INIT_LIST_HEAD(&s->s_io);
-		INIT_LIST_HEAD(&s->s_more_io);
 		INIT_LIST_HEAD(&s->s_files);
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 0ec2c59..8719c87 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -40,6 +40,8 @@ enum bdi_stat_item {
 #define BDI_STAT_BATCH (8*(1+ilog2(nr_cpu_ids)))
 
 struct backing_dev_info {
+	struct list_head bdi_list;
+
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
 	unsigned long state;	/* Always use atomic bitops on this */
 	unsigned int capabilities; /* Device capabilities */
@@ -58,6 +60,10 @@ struct backing_dev_info {
 
 	struct device *dev;
 
+	struct list_head	b_dirty;	/* dirty inodes */
+	struct list_head	b_io;		/* parked for writeback */
+	struct list_head	b_more_io;	/* parked for more writeback */
+
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debug_dir;
 	struct dentry *debug_stats;
@@ -72,6 +78,9 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
 
+extern struct mutex bdi_lock;
+extern struct list_head bdi_list;
+
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item, s64 amount)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b534e5..6b475d4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -712,7 +712,7 @@ static inline int mapping_writably_mapped(struct address_space *mapping)
 
 struct inode {
 	struct hlist_node	i_hash;
-	struct list_head	i_list;
+	struct list_head	i_list;		/* backing dev IO list */
 	struct list_head	i_sb_list;
 	struct list_head	i_dentry;
 	unsigned long		i_ino;
@@ -1329,9 +1329,6 @@ struct super_block {
 	struct xattr_handler	**s_xattr;
 
 	struct list_head	s_inodes;	/* all inodes */
-	struct list_head	s_dirty;	/* dirty inodes */
-	struct list_head	s_io;		/* parked for writeback */
-	struct list_head	s_more_io;	/* parked for more writeback */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_files;
 	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 493b468..de0bbfe 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -22,6 +22,8 @@ struct backing_dev_info default_backing_dev_info = {
 EXPORT_SYMBOL_GPL(default_backing_dev_info);
 
 static struct class *bdi_class;
+DEFINE_MUTEX(bdi_lock);
+LIST_HEAD(bdi_list);
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
@@ -211,6 +213,10 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		goto exit;
 	}
 
+	mutex_lock(&bdi_lock);
+	list_add_tail(&bdi->bdi_list, &bdi_list);
+	mutex_unlock(&bdi_lock);
+
 	bdi->dev = dev;
 	bdi_debug_register(bdi, dev_name(dev));
 
@@ -225,9 +231,17 @@ int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev)
 }
 EXPORT_SYMBOL(bdi_register_dev);
 
+static void bdi_remove_from_list(struct backing_dev_info *bdi)
+{
+	mutex_lock(&bdi_lock);
+	list_del(&bdi->bdi_list);
+	mutex_unlock(&bdi_lock);
+}
+
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
+		bdi_remove_from_list(bdi);
 		bdi_debug_unregister(bdi);
 		device_unregister(bdi->dev);
 		bdi->dev = NULL;
@@ -245,6 +259,10 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
+	INIT_LIST_HEAD(&bdi->bdi_list);
+	INIT_LIST_HEAD(&bdi->b_io);
+	INIT_LIST_HEAD(&bdi->b_dirty);
+	INIT_LIST_HEAD(&bdi->b_more_io);
 
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init(&bdi->bdi_stat[i], 0);
@@ -259,6 +277,8 @@ int bdi_init(struct backing_dev_info *bdi)
 err:
 		while (i--)
 			percpu_counter_destroy(&bdi->bdi_stat[i]);
+
+		bdi_remove_from_list(bdi);
 	}
 
 	return err;
@@ -269,6 +289,10 @@ void bdi_destroy(struct backing_dev_info *bdi)
 {
 	int i;
 
+	WARN_ON(!list_empty(&bdi->b_dirty));
+	WARN_ON(!list_empty(&bdi->b_io));
+	WARN_ON(!list_empty(&bdi->b_more_io));
+
 	bdi_unregister(bdi);
 
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index bb553c3..7c44314 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -319,15 +319,13 @@ static void task_dirty_limit(struct task_struct *tsk, long *pdirty)
 /*
  *
  */
-static DEFINE_SPINLOCK(bdi_lock);
 static unsigned int bdi_min_ratio;
 
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 {
 	int ret = 0;
-	unsigned long flags;
 
-	spin_lock_irqsave(&bdi_lock, flags);
+	mutex_lock(&bdi_lock);
 	if (min_ratio > bdi->max_ratio) {
 		ret = -EINVAL;
 	} else {
@@ -339,27 +337,26 @@ int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 			ret = -EINVAL;
 		}
 	}
-	spin_unlock_irqrestore(&bdi_lock, flags);
+	mutex_unlock(&bdi_lock);
 
 	return ret;
 }
 
 int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned max_ratio)
 {
-	unsigned long flags;
 	int ret = 0;
 
 	if (max_ratio > 100)
 		return -EINVAL;
 
-	spin_lock_irqsave(&bdi_lock, flags);
+	mutex_lock(&bdi_lock);
 	if (bdi->min_ratio > max_ratio) {
 		ret = -EINVAL;
 	} else {
 		bdi->max_ratio = max_ratio;
 		bdi->max_prop_frac = (PROP_FRAC_BASE * max_ratio) / 100;
 	}
-	spin_unlock_irqrestore(&bdi_lock, flags);
+	mutex_unlock(&bdi_lock);
 
 	return ret;
 }
-- 
1.6.3.rc0.1.gf800


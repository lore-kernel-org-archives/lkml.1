Return-Path: <linux-kernel-owner+w=401wt.eu-S933808AbZDHMJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbZDHMJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZDHMAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:00:52 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48921 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933399AbZDHMAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:00:22 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 05/13] writeback: separate the flushing state/task from the bdi
Date: Wed,  8 Apr 2009 14:00:08 +0200
Message-Id: <1239192016-19857-6-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.2.446.gfbdc0
In-Reply-To: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a struct bdi_writeback for tracking and handling dirty IO. This
is in preparation for adding > 1 flusher task per bdi.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c           |  140 +++++++++++++++++-----------
 include/linux/backing-dev.h |   42 +++++----
 mm/backing-dev.c            |  218 ++++++++++++++++++++++++++++--------------
 3 files changed, 256 insertions(+), 144 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 816cf8e..2ec8569 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -46,9 +46,11 @@ int nr_pdflush_threads = 0;
  * unless they implement their own.  Which is somewhat inefficient, as this
  * may prevent concurrent writeback against multiple devices.
  */
-static int writeback_acquire(struct backing_dev_info *bdi)
+static int writeback_acquire(struct bdi_writeback *wb)
 {
-	return !test_and_set_bit(BDI_pdflush, &bdi->state);
+	struct backing_dev_info *bdi = wb->bdi;
+
+	return !test_and_set_bit(wb->nr, &bdi->wb_active);
 }
 
 /**
@@ -59,19 +61,38 @@ static int writeback_acquire(struct backing_dev_info *bdi)
  */
 int writeback_in_progress(struct backing_dev_info *bdi)
 {
-	return test_bit(BDI_pdflush, &bdi->state);
+	return bdi->wb_active != 0;
 }
 
 /**
  * writeback_release - relinquish exclusive writeback access against a device.
  * @bdi: the device's backing_dev_info structure
  */
-static void writeback_release(struct backing_dev_info *bdi)
+static void writeback_release(struct bdi_writeback *wb)
 {
-	WARN_ON_ONCE(!writeback_in_progress(bdi));
-	bdi->wb_arg.nr_pages = 0;
-	bdi->wb_arg.sb = NULL;
-	clear_bit(BDI_pdflush, &bdi->state);
+	struct backing_dev_info *bdi = wb->bdi;
+
+	wb->nr_pages = 0;
+	wb->sb = NULL;
+	clear_bit(wb->nr, &bdi->wb_active);
+}
+
+static void wb_start_writeback(struct bdi_writeback *wb, struct super_block *sb,
+			       long nr_pages)
+{
+	if (!wb_has_dirty_io(wb))
+		return;
+
+	if (writeback_acquire(wb)) {
+		wb->nr_pages = nr_pages;
+		wb->sb = sb;
+
+		/*
+		 * make above store seen before the task is woken
+		 */
+		smp_mb();
+		wake_up(&wb->wait);
+	}
 }
 
 int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
@@ -81,21 +102,12 @@ int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 	 * This only happens the first time someone kicks this bdi, so put
 	 * it out-of-line.
 	 */
-	if (unlikely(!bdi->task)) {
+	if (unlikely(!bdi->wb.task)) {
 		bdi_add_default_flusher_task(bdi);
 		return 1;
 	}
 
-	if (writeback_acquire(bdi)) {
-		bdi->wb_arg.nr_pages = nr_pages;
-		bdi->wb_arg.sb = sb;
-		/*
-		 * make above store seen before the task is woken
-		 */
-		smp_mb();
-		wake_up(&bdi->wait);
-	}
-
+	wb_start_writeback(&bdi->wb, sb, nr_pages);
 	return 0;
 }
 
@@ -123,11 +135,11 @@ int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
  * older_than_this takes precedence over nr_to_write.  So we'll only write back
  * all dirty pages if they are all attached to "old" mappings.
  */
-static void bdi_kupdated(struct backing_dev_info *bdi)
+static void wb_kupdated(struct bdi_writeback *wb)
 {
 	long nr_to_write;
 	struct writeback_control wbc = {
-		.bdi		= bdi,
+		.bdi		= wb->bdi,
 		.sync_mode	= WB_SYNC_NONE,
 		.nr_to_write	= 0,
 		.for_kupdate	= 1,
@@ -151,15 +163,19 @@ static void bdi_kupdated(struct backing_dev_info *bdi)
 	}
 }
 
-static void bdi_pdflush(struct backing_dev_info *bdi)
+static void generic_sync_wb_inodes(struct bdi_writeback *wb,
+				   struct super_block *sb,
+				   struct writeback_control *wbc);
+
+static void wb_writeback(struct bdi_writeback *wb)
 {
 	struct writeback_control wbc = {
-		.bdi			= bdi,
+		.bdi			= wb->bdi,
 		.sync_mode		= WB_SYNC_NONE,
 		.older_than_this	= NULL,
 		.range_cyclic		= 1,
 	};
-	long nr_pages = bdi->wb_arg.nr_pages;
+	long nr_pages = wb->nr_pages;
 
 	for (;;) {
 		unsigned long background_thresh, dirty_thresh;
@@ -173,7 +189,7 @@ static void bdi_pdflush(struct backing_dev_info *bdi)
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
-		generic_sync_bdi_inodes(bdi->wb_arg.sb, &wbc);
+		generic_sync_wb_inodes(wb, wb->sb, &wbc);
 		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		/*
 		 * If we ran out of stuff to write, bail unless more_io got set
@@ -190,13 +206,13 @@ static void bdi_pdflush(struct backing_dev_info *bdi)
  * Handle writeback of dirty data for the device backed by this bdi. Also
  * wakes up periodically and does kupdated style flushing.
  */
-int bdi_writeback_task(struct backing_dev_info *bdi)
+int bdi_writeback_task(struct bdi_writeback *wb)
 {
 	while (!kthread_should_stop()) {
 		unsigned long wait_jiffies;
 		DEFINE_WAIT(wait);
 
-		prepare_to_wait(&bdi->wait, &wait, TASK_INTERRUPTIBLE);
+		prepare_to_wait(&wb->wait, &wait, TASK_INTERRUPTIBLE);
 		wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
 		schedule_timeout(wait_jiffies);
 		try_to_freeze();
@@ -215,13 +231,13 @@ int bdi_writeback_task(struct backing_dev_info *bdi)
 		 *  pdflush style writeout.
 		 *
 		 */
-		if (writeback_acquire(bdi))
-			bdi_kupdated(bdi);
+		if (writeback_acquire(wb))
+			wb_kupdated(wb);
 		else
-			bdi_pdflush(bdi);
+			wb_writeback(wb);
 
-		writeback_release(bdi);
-		finish_wait(&bdi->wait, &wait);
+		writeback_release(wb);
+		finish_wait(&wb->wait, &wait);
 	}
 
 	return 0;
@@ -244,6 +260,14 @@ restart:
 	rcu_read_unlock();
 }
 
+/*
+ * We have only a single wb per bdi, so just return that.
+ */
+static inline struct bdi_writeback *inode_get_wb(struct inode *inode)
+{
+	return &inode_to_bdi(inode)->wb;
+}
+
 /**
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
@@ -342,9 +366,10 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 * reposition it (that would break b_dirty time-ordering).
 		 */
 		if (!was_dirty) {
+			struct bdi_writeback *wb = inode_get_wb(inode);
+
 			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list,
-					&inode_to_bdi(inode)->b_dirty);
+			list_move(&inode->i_list, &wb->b_dirty);
 		}
 	}
 out:
@@ -371,16 +396,16 @@ static int write_inode(struct inode *inode, int sync)
  */
 static void redirty_tail(struct inode *inode)
 {
-	struct backing_dev_info *bdi = inode_to_bdi(inode);
+	struct bdi_writeback *wb = inode_get_wb(inode);
 
-	if (!list_empty(&bdi->b_dirty)) {
+	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
-		tail = list_entry(bdi->b_dirty.next, struct inode, i_list);
+		tail = list_entry(wb->b_dirty.next, struct inode, i_list);
 		if (time_before(inode->dirtied_when, tail->dirtied_when))
 			inode->dirtied_when = jiffies;
 	}
-	list_move(&inode->i_list, &bdi->b_dirty);
+	list_move(&inode->i_list, &wb->b_dirty);
 }
 
 /*
@@ -388,7 +413,9 @@ static void redirty_tail(struct inode *inode)
  */
 static void requeue_io(struct inode *inode)
 {
-	list_move(&inode->i_list, &inode_to_bdi(inode)->b_more_io);
+	struct bdi_writeback *wb = inode_get_wb(inode);
+
+	list_move(&inode->i_list, &wb->b_more_io);
 }
 
 static void inode_sync_complete(struct inode *inode)
@@ -435,11 +462,10 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 /*
  * Queue all expired dirty inodes for io, eldest first.
  */
-static void queue_io(struct backing_dev_info *bdi,
-		     unsigned long *older_than_this)
+static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
 {
-	list_splice_init(&bdi->b_more_io, bdi->b_io.prev);
-	move_expired_inodes(&bdi->b_dirty, &bdi->b_io, older_than_this);
+	list_splice_init(&wb->b_more_io, wb->b_io.prev);
+	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
 }
 
 /*
@@ -600,20 +626,20 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	return __sync_single_inode(inode, wbc);
 }
 
-void generic_sync_bdi_inodes(struct super_block *sb,
-			     struct writeback_control *wbc)
+static void generic_sync_wb_inodes(struct bdi_writeback *wb,
+				   struct super_block *sb,
+				   struct writeback_control *wbc)
 {
 	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
-	struct backing_dev_info *bdi = wbc->bdi;
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
 	spin_lock(&inode_lock);
 
-	if (!wbc->for_kupdate || list_empty(&bdi->b_io))
-		queue_io(bdi, wbc->older_than_this);
+	if (!wbc->for_kupdate || list_empty(&wb->b_io))
+		queue_io(wb, wbc->older_than_this);
 
-	while (!list_empty(&bdi->b_io)) {
-		struct inode *inode = list_entry(bdi->b_io.prev,
+	while (!list_empty(&wb->b_io)) {
+		struct inode *inode = list_entry(wb->b_io.prev,
 						struct inode, i_list);
 		long pages_skipped;
 
@@ -625,7 +651,7 @@ void generic_sync_bdi_inodes(struct super_block *sb,
 			continue;
 		}
 
-		if (!bdi_cap_writeback_dirty(bdi)) {
+		if (!bdi_cap_writeback_dirty(wb->bdi)) {
 			redirty_tail(inode);
 			if (is_blkdev_sb) {
 				/*
@@ -647,7 +673,7 @@ void generic_sync_bdi_inodes(struct super_block *sb,
 			continue;
 		}
 
-		if (wbc->nonblocking && bdi_write_congested(bdi)) {
+		if (wbc->nonblocking && bdi_write_congested(wb->bdi)) {
 			wbc->encountered_congestion = 1;
 			if (!is_blkdev_sb)
 				break;		/* Skip a congested fs */
@@ -681,7 +707,7 @@ void generic_sync_bdi_inodes(struct super_block *sb,
 			wbc->more_io = 1;
 			break;
 		}
-		if (!list_empty(&bdi->b_more_io))
+		if (!list_empty(&wb->b_more_io))
 			wbc->more_io = 1;
 	}
 
@@ -689,6 +715,14 @@ void generic_sync_bdi_inodes(struct super_block *sb,
 	/* Leave any unwritten inodes on b_io */
 }
 
+void generic_sync_bdi_inodes(struct super_block *sb,
+			     struct writeback_control *wbc)
+{
+	struct backing_dev_info *bdi = wbc->bdi;
+
+	generic_sync_wb_inodes(&bdi->wb, sb, wbc);
+}
+
 /*
  * Write out a superblock's list of dirty inodes.  A wait will be performed
  * upon no inodes, all inodes or the final one, depending upon sync_mode.
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index a848eea..a0c70f1 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -23,8 +23,8 @@ struct dentry;
  * Bits in backing_dev_info.state
  */
 enum bdi_state {
-	BDI_pdflush,		/* A pdflush thread is working this device */
 	BDI_pending,		/* On its way to being activated */
+	BDI_wb_alloc,		/* Default embedded wb allocated */
 	BDI_async_congested,	/* The async (write) queue is getting full */
 	BDI_sync_congested,	/* The sync queue is getting full */
 	BDI_unused,		/* Available bits start here */
@@ -40,15 +40,23 @@ enum bdi_stat_item {
 
 #define BDI_STAT_BATCH (8*(1+ilog2(nr_cpu_ids)))
 
-struct bdi_writeback_arg {
-	unsigned long nr_pages;
-	struct super_block *sb;
+struct bdi_writeback {
+	struct backing_dev_info *bdi;		/* our parent bdi */
+	unsigned int nr;
+
+	struct task_struct	*task;		/* writeback task */
+	wait_queue_head_t	wait;
+	struct list_head	b_dirty;	/* dirty inodes */
+	struct list_head	b_io;		/* parked for writeback */
+	struct list_head	b_more_io;	/* parked for more writeback */
+
+	unsigned long		nr_pages;
+	struct super_block	*sb;
 };
 
 struct backing_dev_info {
-	struct list_head bdi_list;
 	struct rcu_head rcu_head;
-
+	struct list_head bdi_list;
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
 	unsigned long state;	/* Always use atomic bitops on this */
 	unsigned int capabilities; /* Device capabilities */
@@ -65,14 +73,11 @@ struct backing_dev_info {
 	unsigned int min_ratio;
 	unsigned int max_ratio, max_prop_frac;
 
-	struct device *dev;
+	struct bdi_writeback wb;  /* default writeback info for this bdi */
+	unsigned long wb_active;  /* bitmap of active tasks */
+	unsigned long wb_mask;	  /* number of registered tasks */
 
-	struct task_struct	*task;		/* writeback task */
-	wait_queue_head_t	wait;
-	struct bdi_writeback_arg wb_arg;	/* protected by BDI_pdflush */
-	struct list_head	b_dirty;	/* dirty inodes */
-	struct list_head	b_io;		/* parked for writeback */
-	struct list_head	b_more_io;	/* parked for more writeback */
+	struct device *dev;
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debug_dir;
@@ -89,18 +94,19 @@ int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
 int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 			 long nr_pages);
-int bdi_writeback_task(struct backing_dev_info *bdi);
+int bdi_writeback_task(struct bdi_writeback *wb);
 void bdi_writeback_all(struct super_block *sb, long nr_pages);
 void bdi_add_default_flusher_task(struct backing_dev_info *bdi);
+int bdi_has_dirty_io(struct backing_dev_info *bdi);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
 
-static inline int bdi_has_dirty_io(struct backing_dev_info *bdi)
+static inline int wb_has_dirty_io(struct bdi_writeback *wb)
 {
-	return !list_empty(&bdi->b_dirty) ||
-	       !list_empty(&bdi->b_io) ||
-	       !list_empty(&bdi->b_more_io);
+	return !list_empty(&wb->b_dirty) ||
+	       !list_empty(&wb->b_io) ||
+	       !list_empty(&wb->b_more_io);
 }
 
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index c759449..677a8c6 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -199,17 +199,59 @@ static int __init default_bdi_init(void)
 }
 subsys_initcall(default_bdi_init);
 
+static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
+{
+	memset(wb, 0, sizeof(*wb));
+
+	wb->bdi = bdi;
+	init_waitqueue_head(&wb->wait);
+	INIT_LIST_HEAD(&wb->b_dirty);
+	INIT_LIST_HEAD(&wb->b_io);
+	INIT_LIST_HEAD(&wb->b_more_io);
+}
+
+static void bdi_flush_io(struct backing_dev_info *bdi)
+{
+	struct writeback_control wbc = {
+		.bdi			= bdi,
+		.sync_mode		= WB_SYNC_NONE,
+		.older_than_this	= NULL,
+		.range_cyclic		= 1,
+		.nr_to_write		= 1024,
+	};
+
+	generic_sync_bdi_inodes(NULL, &wbc);
+}
+
+static int wb_assign_nr(struct backing_dev_info *bdi, struct bdi_writeback *wb)
+{
+	set_bit(0, &bdi->wb_mask);
+	wb->nr = 0;
+	return 0;
+}
+
+static void bdi_put_wb(struct backing_dev_info *bdi, struct bdi_writeback *wb)
+{
+	clear_bit(wb->nr, &bdi->wb_mask);
+	clear_bit(BDI_wb_alloc, &bdi->state);
+}
+
+static struct bdi_writeback *bdi_new_wb(struct backing_dev_info *bdi)
+{
+	struct bdi_writeback *wb;
+
+	set_bit(BDI_wb_alloc, &bdi->state);
+	wb = &bdi->wb;
+	wb_assign_nr(bdi, wb);
+	return wb;
+}
+
 static int bdi_start_fn(void *ptr)
 {
-	struct backing_dev_info *bdi = ptr;
+	struct bdi_writeback *wb = ptr;
+	struct backing_dev_info *bdi = wb->bdi;
 	struct task_struct *tsk = current;
-
-	/*
-	 * Add us to the active bdi_list
-	 */
-	spin_lock_bh(&bdi_lock);
-	list_add_rcu(&bdi->bdi_list, &bdi_list);
-	spin_unlock_bh(&bdi_lock);
+	int ret;
 
 	tsk->flags |= PF_FLUSHER | PF_SWAPWRITE;
 	set_freezable();
@@ -225,77 +267,81 @@ static int bdi_start_fn(void *ptr)
 	clear_bit(BDI_pending, &bdi->state);
 	wake_up_bit(&bdi->state, BDI_pending);
 
-	return bdi_writeback_task(bdi);
+	ret = bdi_writeback_task(wb);
+
+	bdi_put_wb(bdi, wb);
+	return ret;
+}
+
+int bdi_has_dirty_io(struct backing_dev_info *bdi)
+{
+	return wb_has_dirty_io(&bdi->wb);
 }
 
 static int bdi_forker_task(void *ptr)
 {
-	struct backing_dev_info *bdi, *me = ptr;
+	struct bdi_writeback *me = ptr;
 
 	for (;;) {
+		struct backing_dev_info *bdi;
+		struct bdi_writeback *wb;
 		DEFINE_WAIT(wait);
 
 		/*
 		 * Should never trigger on the default bdi
 		 */
-		WARN_ON(bdi_has_dirty_io(me));
+		if (wb_has_dirty_io(me)) {
+			bdi_flush_io(me->bdi);
+			WARN_ON(1);
+		}
 
 		prepare_to_wait(&me->wait, &wait, TASK_INTERRUPTIBLE);
+
 		smp_mb();
 		if (list_empty(&bdi_pending_list))
 			schedule();
-		else {
+
+		finish_wait(&me->wait, &wait);
 repeat:
-			bdi = NULL;
+		bdi = NULL;
+		spin_lock_bh(&bdi_lock);
+		if (!list_empty(&bdi_pending_list)) {
+			bdi = list_entry(bdi_pending_list.next,
+					 struct backing_dev_info, bdi_list);
+			list_del_init(&bdi->bdi_list);
+		}
+		spin_unlock_bh(&bdi_lock);
 
-			spin_lock_bh(&bdi_lock);
-			if (!list_empty(&bdi_pending_list)) {
-				bdi = list_entry(bdi_pending_list.next,
-						 struct backing_dev_info,
-						 bdi_list);
-				list_del_init(&bdi->bdi_list);
-			}
-			spin_unlock_bh(&bdi_lock);
+		if (!bdi)
+			continue;
 
-			/*
-			 * If no bdi or bdi already got setup, continue
-			 */
-			if (!bdi || bdi->task)
-				continue;
+		wb = bdi_new_wb(bdi);
+		if (!wb)
+			goto readd_flush;
 
-			bdi->task = kthread_run(bdi_start_fn, bdi, "bdi-%s",
+		wb->task = kthread_run(bdi_start_fn, wb, "bdi-%s",
 						dev_name(bdi->dev));
+		/*
+		 * If task creation fails, then readd the bdi to
+		 * the pending list and force writeout of the bdi
+		 * from this forker thread. That will free some memory
+		 * and we can try again.
+		 */
+		if (!wb->task) {
+			bdi_put_wb(bdi, wb);
+readd_flush:
 			/*
-			 * If task creation fails, then readd the bdi to
-			 * the pending list and force writeout of the bdi
-			 * from this forker thread. That will free some memory
-			 * and we can try again.
+			 * Add this 'bdi' to the back, so we get
+			 * a chance to flush other bdi's to free
+			 * memory.
 			 */
-			if (!bdi->task) {
-				struct writeback_control wbc = {
-					.bdi			= bdi,
-					.sync_mode		= WB_SYNC_NONE,
-					.older_than_this	= NULL,
-					.range_cyclic		= 1,
-				};
-
-				/*
-				 * Add this 'bdi' to the back, so we get
-				 * a chance to flush other bdi's to free
-				 * memory.
-				 */
-				spin_lock_bh(&bdi_lock);
-				list_add_tail(&bdi->bdi_list,
-						&bdi_pending_list);
-				spin_unlock_bh(&bdi_lock);
-
-				wbc.nr_to_write = 1024;
-				generic_sync_bdi_inodes(NULL, &wbc);
-				goto repeat;
-			}
-		}
+			spin_lock_bh(&bdi_lock);
+			list_add_tail(&bdi->bdi_list, &bdi_pending_list);
+			spin_unlock_bh(&bdi_lock);
 
-		finish_wait(&me->wait, &wait);
+			bdi_flush_io(bdi);
+			goto repeat;
+		}
 	}
 
 	return 0;
@@ -318,11 +364,21 @@ static void bdi_add_to_pending(struct rcu_head *head)
 	list_add_tail(&bdi->bdi_list, &bdi_pending_list);
 	spin_unlock(&bdi_lock);
 
-	wake_up(&default_backing_dev_info.wait);
+	wake_up(&default_backing_dev_info.wb.wait);
 }
 
+/*
+ * Add a new flusher task that gets created for any bdi
+ * that has dirty data pending writeout
+ */
 void bdi_add_default_flusher_task(struct backing_dev_info *bdi)
 {
+	if (!bdi_cap_writeback_dirty(bdi))
+		return;
+
+	/*
+	 * Someone already marked this pending for task creation
+	 */
 	if (test_and_set_bit(BDI_pending, &bdi->state))
 		return;
 
@@ -363,9 +419,18 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 	 * on-demand when they need it.
 	 */
 	if (bdi_cap_flush_forker(bdi)) {
-		bdi->task = kthread_run(bdi_forker_task, bdi, "bdi-%s",
+		struct bdi_writeback *wb;
+
+		wb = bdi_new_wb(bdi);
+		if (!wb) {
+			ret = -ENOMEM;
+			goto exit;
+		}
+
+		wb->task = kthread_run(bdi_forker_task, wb, "bdi-%s",
 						dev_name(dev));
-		if (!bdi->task) {
+		if (!wb->task) {
+			bdi_put_wb(bdi, wb);
 			ret = -ENOMEM;
 			goto exit;
 		}
@@ -395,34 +460,44 @@ static int sched_wait(void *word)
 	return 0;
 }
 
+/*
+ * Remove bdi from global list and shutdown any threads we have running
+ */
 static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 {
+	if (!bdi_cap_writeback_dirty(bdi))
+		return;
+
 	/*
 	 * If setup is pending, wait for that to complete first
+	 * Make sure nobody finds us on the bdi_list anymore
 	 */
 	wait_on_bit(&bdi->state, BDI_pending, sched_wait, TASK_UNINTERRUPTIBLE);
 
+	/*
+	 * Make sure nobody finds us on the bdi_list anymore
+	 */
 	spin_lock_bh(&bdi_lock);
 	list_del_rcu(&bdi->bdi_list);
 	spin_unlock_bh(&bdi_lock);
 
 	/*
-	 * In case the bdi is freed right after unregister, we need to
-	 * make sure any RCU sections have exited
+	 * Now make sure that anybody who is currently looking at us from
+	 * the bdi_list iteration have exited.
 	 */
 	synchronize_rcu();
+
+	/*
+	 * Finally, kill the kernel thread
+	 */
+	kthread_stop(bdi->wb.task);
 }
 
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
-		if (!bdi_cap_flush_forker(bdi)) {
+		if (!bdi_cap_flush_forker(bdi))
 			bdi_wb_shutdown(bdi);
-			if (bdi->task) {
-				kthread_stop(bdi->task);
-				bdi->task = NULL;
-			}
-		}
 		bdi_debug_unregister(bdi);
 		device_unregister(bdi->dev);
 		bdi->dev = NULL;
@@ -440,11 +515,10 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
-	init_waitqueue_head(&bdi->wait);
 	INIT_LIST_HEAD(&bdi->bdi_list);
-	INIT_LIST_HEAD(&bdi->b_io);
-	INIT_LIST_HEAD(&bdi->b_dirty);
-	INIT_LIST_HEAD(&bdi->b_more_io);
+	bdi->wb_mask = bdi->wb_active = 0;
+
+	bdi_wb_init(&bdi->wb, bdi);
 
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init(&bdi->bdi_stat[i], 0);
@@ -469,9 +543,7 @@ void bdi_destroy(struct backing_dev_info *bdi)
 {
 	int i;
 
-	WARN_ON(!list_empty(&bdi->b_dirty));
-	WARN_ON(!list_empty(&bdi->b_io));
-	WARN_ON(!list_empty(&bdi->b_more_io));
+	WARN_ON(bdi_has_dirty_io(bdi));
 
 	bdi_unregister(bdi);
 
-- 
1.6.2.2.446.gfbdc0


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221AbZEYHmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbZEYHmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758789AbZEYHfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:35:50 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38994 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758532AbZEYHev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:34:51 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 07/12] writeback: support > 1 flusher thread per bdi
Date: Mon, 25 May 2009 09:34:42 +0200
Message-Id: <1243236887-3931-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236887-3931-1-git-send-email-jens.axboe@oracle.com>
References: <1243236887-3931-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build on the bdi_writeback support by allowing registration of
more than 1 flusher thread. File systems can call bdi_add_flusher_task(bdi)
to add more flusher threads to the device. If they do so, they must also
provide a super_operations function to return the suitable bdi_writeback
struct from any given inode.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c           |  346 +++++++++++++++++++++++++++++++++----------
 include/linux/backing-dev.h |   32 ++++-
 include/linux/fs.h          |    3 +
 mm/backing-dev.c            |  244 ++++++++++++++++++++++++------
 mm/page-writeback.c         |    4 +-
 5 files changed, 495 insertions(+), 134 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 7a9f0b0..563860c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -34,86 +34,196 @@
  */
 int nr_pdflush_threads;
 
-/**
- * writeback_acquire - attempt to get exclusive writeback access to a device
- * @bdi: the device's backing_dev_info structure
- *
- * It is a waste of resources to have more than one pdflush thread blocked on
- * a single request queue.  Exclusion at the request_queue level is obtained
- * via a flag in the request_queue's backing_dev_info.state.
- *
- * Non-request_queue-backed address_spaces will share default_backing_dev_info,
- * unless they implement their own.  Which is somewhat inefficient, as this
- * may prevent concurrent writeback against multiple devices.
+static void generic_sync_wb_inodes(struct bdi_writeback *wb,
+				   struct super_block *sb,
+				   struct writeback_control *wbc);
+
+/*
+ * Work items for the bdi_writeback threads
  */
-static int writeback_acquire(struct bdi_writeback *wb)
+struct bdi_work {
+	struct list_head list;
+	struct rcu_head rcu_head;
+
+	unsigned long seen;
+	atomic_t pending;
+
+	unsigned long sb_data;
+	unsigned long nr_pages;
+	enum writeback_sync_modes sync_mode;
+
+	unsigned long state;
+};
+
+static struct super_block *bdi_work_sb(struct bdi_work *work)
 {
-	struct backing_dev_info *bdi = wb->bdi;
+	return (struct super_block *) (work->sb_data & ~1UL);
+}
+
+static inline bool bdi_work_on_stack(struct bdi_work *work)
+{
+	return work->sb_data & 1UL;
+}
+
+static inline void bdi_work_init(struct bdi_work *work, struct super_block *sb,
+				 unsigned long nr_pages,
+				 enum writeback_sync_modes sync_mode)
+{
+	INIT_RCU_HEAD(&work->rcu_head);
+	work->sb_data = (unsigned long) sb;
+	work->nr_pages = nr_pages;
+	work->sync_mode = sync_mode;
+	work->state = 0;
+}
 
-	return !test_and_set_bit(wb->nr, &bdi->wb_active);
+static inline void bdi_work_init_on_stack(struct bdi_work *work,
+					  struct super_block *sb,
+					  unsigned long nr_pages,
+					  enum writeback_sync_modes sync_mode)
+{
+	bdi_work_init(work, sb, nr_pages, sync_mode);
+	set_bit(0, &work->state);
+	work->sb_data |= 1UL;
 }
 
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @bdi: the device's backing_dev_info structure.
  *
- * Determine whether there is writeback in progress against a backing device.
+ * Determine whether there is writeback waiting to be handled against a
+ * backing device.
  */
 int writeback_in_progress(struct backing_dev_info *bdi)
 {
-	return bdi->wb_active != 0;
+	return !list_empty(&bdi->work_list);
 }
 
-/**
- * writeback_release - relinquish exclusive writeback access against a device.
- * @bdi: the device's backing_dev_info structure
- */
-static void writeback_release(struct bdi_writeback *wb)
+static void bdi_work_free(struct rcu_head *head)
 {
-	struct backing_dev_info *bdi = wb->bdi;
+	struct bdi_work *work = container_of(head, struct bdi_work, rcu_head);
+
+	if (!bdi_work_on_stack(work))
+		kfree(work);
+	else {
+		clear_bit(0, &work->state);
+		smp_mb__after_clear_bit();
+		wake_up_bit(&work->state, 0);
+	}
+}
+
+static void wb_clear_pending(struct bdi_writeback *wb, struct bdi_work *work)
+{
+	/*
+	 * The caller has retrieved the work arguments from this work,
+	 * drop our reference. If this is the last ref, delete and free it
+	 */
+	if (atomic_dec_and_test(&work->pending)) {
+		struct backing_dev_info *bdi = wb->bdi;
 
-	wb->nr_pages = 0;
-	wb->sb = NULL;
-	clear_bit(wb->nr, &bdi->wb_active);
+		spin_lock(&bdi->wb_lock);
+		list_del_rcu(&work->list);
+		spin_unlock(&bdi->wb_lock);
+
+		call_rcu(&work->rcu_head, bdi_work_free);
+	}
 }
 
-static void wb_start_writeback(struct bdi_writeback *wb, struct super_block *sb,
-			       long nr_pages,
-			       enum writeback_sync_modes sync_mode)
+static void wb_start_writeback(struct bdi_writeback *wb, struct bdi_work *work)
 {
-	if (!wb_has_dirty_io(wb))
-		return;
+	/*
+	 * If we failed allocating the bdi work item, wake up the wb thread
+	 * always. As a safety precaution, it'll flush out everything
+	 */
+	if (!wb_has_dirty_io(wb) && work)
+		wb_clear_pending(wb, work);
+	else
+		wake_up(&wb->wait);
+}
 
-	if (writeback_acquire(wb)) {
-		wb->nr_pages = nr_pages;
-		wb->sb = sb;
-		wb->sync_mode = sync_mode;
+/*
+ * Add work to bdi work list.
+ */
+static int bdi_queue_writeback(struct backing_dev_info *bdi,
+			       struct bdi_work *work)
+{
+	if (work) {
+		work->seen = bdi->wb_mask;
+		atomic_set(&work->pending, bdi->wb_cnt);
 
 		/*
-		 * make above store seen before the task is woken
+		 * Make sure stores are seen before it appears on the list
 		 */
 		smp_mb();
-		wake_up(&wb->wait);
+
+		spin_lock(&bdi->wb_lock);
+		list_add_tail_rcu(&work->list, &bdi->work_list);
+		spin_unlock(&bdi->wb_lock);
 	}
-}
 
-int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
-			 long nr_pages, enum writeback_sync_modes sync_mode)
-{
 	/*
 	 * This only happens the first time someone kicks this bdi, so put
 	 * it out-of-line.
 	 */
-	if (unlikely(!bdi->wb.task)) {
+	if (unlikely(list_empty_careful(&bdi->wb_list))) {
+		mutex_lock(&bdi_lock);
 		bdi_add_default_flusher_task(bdi);
+		mutex_unlock(&bdi_lock);
 		return 1;
 	}
 
-	wb_start_writeback(&bdi->wb, sb, nr_pages, sync_mode);
+	if (!bdi_wblist_needs_lock(bdi))
+		wb_start_writeback(&bdi->wb, work);
+	else {
+		struct bdi_writeback *wb;
+		int idx;
+
+		idx = srcu_read_lock(&bdi->srcu);
+
+		list_for_each_entry_rcu(wb, &bdi->wb_list, list)
+			wb_start_writeback(wb, work);
+
+		srcu_read_unlock(&bdi->srcu, idx);
+	}
+
 	return 0;
 }
 
 /*
+ * Used for on-stack allocated work items. The caller needs to wait until
+ * the wb threads have acked the work before it's safe to continue.
+ */
+static void bdi_wait_on_work_start(struct bdi_work *work)
+{
+	wait_on_bit(&work->state, 0, bdi_sched_wait, TASK_UNINTERRUPTIBLE);
+}
+
+int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
+			 long nr_pages, enum writeback_sync_modes sync_mode)
+{
+	struct bdi_work work_stack, *work;
+	int ret;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (work)
+		bdi_work_init(work, sb, nr_pages, sync_mode);
+	else {
+		work = &work_stack;
+		bdi_work_init_on_stack(work, sb, nr_pages, sync_mode);
+	}
+
+	ret = bdi_queue_writeback(bdi, work);
+
+	/*
+	 * If this came from our stack, we need to wait until the wb threads
+	 * have noticed this work before we return (and invalidate the stack)
+	 */
+	if (work == &work_stack)
+		bdi_wait_on_work_start(work);
+
+	return ret;
+}
+
+/*
  * The maximum number of pages to writeout in a single bdi flush/kupdate
  * operation.  We do this so we don't hold I_SYNC against an inode for
  * enormous amounts of time, which would block a userspace task which has
@@ -162,7 +272,7 @@ static void wb_kupdated(struct bdi_writeback *wb)
 		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
-		generic_sync_bdi_inodes(NULL, &wbc);
+		generic_sync_wb_inodes(wb, NULL, &wbc);
 		if (wbc.nr_to_write > 0)
 			break;	/* All the old data is written */
 		nr_to_write -= MAX_WRITEBACK_PAGES;
@@ -179,22 +289,19 @@ static inline bool over_bground_thresh(void)
 		global_page_state(NR_UNSTABLE_NFS) >= background_thresh);
 }
 
-static void generic_sync_wb_inodes(struct bdi_writeback *wb,
-				   struct super_block *sb,
-				   struct writeback_control *wbc);
-
-static void wb_writeback(struct bdi_writeback *wb)
+static void __wb_writeback(struct bdi_writeback *wb, long nr_pages,
+			   struct super_block *sb,
+			   enum writeback_sync_modes sync_mode)
 {
 	struct writeback_control wbc = {
 		.bdi			= wb->bdi,
-		.sync_mode		= wb->sync_mode,
+		.sync_mode		= sync_mode,
 		.older_than_this	= NULL,
 		.range_cyclic		= 1,
 	};
-	long nr_pages = wb->nr_pages;
 
 	for (;;) {
-		if (wbc.sync_mode == WB_SYNC_NONE && nr_pages <= 0 &&
+		if (sync_mode == WB_SYNC_NONE && nr_pages <= 0 &&
 		    !over_bground_thresh())
 			break;
 
@@ -202,7 +309,7 @@ static void wb_writeback(struct bdi_writeback *wb)
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
-		generic_sync_wb_inodes(wb, wb->sb, &wbc);
+		generic_sync_wb_inodes(wb, sb, &wbc);
 		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		/*
 		 * If we ran out of stuff to write, bail unless more_io got set
@@ -216,46 +323,91 @@ static void wb_writeback(struct bdi_writeback *wb)
 }
 
 /*
+ * Return the next bdi_work struct that hasn't been processed by this
+ * wb thread yet
+ */
+static struct bdi_work *get_next_work_item(struct backing_dev_info *bdi,
+					   struct bdi_writeback *wb)
+{
+	struct bdi_work *work, *ret = NULL;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(work, &bdi->work_list, list) {
+		if (!test_and_clear_bit(wb->nr, &work->seen))
+			continue;
+
+		ret = work;
+		break;
+	}
+
+	rcu_read_unlock();
+	return ret;
+}
+
+static void wb_writeback(struct bdi_writeback *wb)
+{
+	struct backing_dev_info *bdi = wb->bdi;
+	struct bdi_work *work;
+
+	while ((work = get_next_work_item(bdi, wb)) != NULL) {
+		struct super_block *sb = bdi_work_sb(work);
+		long nr_pages = work->nr_pages;
+		enum writeback_sync_modes sync_mode = work->sync_mode;
+
+		wb_clear_pending(wb, work);
+		__wb_writeback(wb, nr_pages, sb, sync_mode);
+	}
+}
+
+/*
+ * This will be inlined in bdi_writeback_task() once we get rid of any
+ * dirty inodes on the default_backing_dev_info
+ */
+static void wb_do_writeback(struct bdi_writeback *wb)
+{
+	/*
+	 * We get here in two cases:
+	 *
+	 *  schedule_timeout() returned because the dirty writeback
+	 *  interval has elapsed. If that happens, the work item list
+	 *  will be empty and we will proceed to do kupdated style writeout.
+	 *
+	 *  Someone called bdi_start_writeback(), which put one/more work
+	 *  items on the work_list. Process those.
+	 */
+	if (list_empty(&wb->bdi->work_list))
+		wb_kupdated(wb);
+	else
+		wb_writeback(wb);
+}
+
+/*
  * Handle writeback of dirty data for the device backed by this bdi. Also
  * wakes up periodically and does kupdated style flushing.
  */
 int bdi_writeback_task(struct bdi_writeback *wb)
 {
+	DEFINE_WAIT(wait);
+
 	while (!kthread_should_stop()) {
 		unsigned long wait_jiffies;
-		DEFINE_WAIT(wait);
+
+		wb_do_writeback(wb);
 
 		prepare_to_wait(&wb->wait, &wait, TASK_INTERRUPTIBLE);
 		wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
 		schedule_timeout(wait_jiffies);
 		try_to_freeze();
-
-		/*
-		 * We get here in two cases:
-		 *
-		 *  schedule_timeout() returned because the dirty writeback
-		 *  interval has elapsed. If that happens, we will be able
-		 *  to acquire the writeback lock and will proceed to do
-		 *  kupdated style writeout.
-		 *
-		 *  Someone called bdi_start_writeback(), which will acquire
-		 *  the writeback lock. This means our writeback_acquire()
-		 *  below will fail and we call into bdi_pdflush() for
-		 *  pdflush style writeout.
-		 *
-		 */
-		if (writeback_acquire(wb))
-			wb_kupdated(wb);
-		else
-			wb_writeback(wb);
-
-		writeback_release(wb);
-		finish_wait(&wb->wait, &wait);
 	}
 
+	finish_wait(&wb->wait, &wait);
 	return 0;
 }
 
+/*
+ * Do in-line writeback for all backing devices. Expensive!
+ */
 void bdi_writeback_all(struct super_block *sb, long nr_pages,
 		       enum writeback_sync_modes sync_mode)
 {
@@ -266,18 +418,38 @@ void bdi_writeback_all(struct super_block *sb, long nr_pages,
 	list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
 		if (!bdi_has_dirty_io(bdi))
 			continue;
-		bdi_start_writeback(bdi, sb, nr_pages, sync_mode);
+
+		if (!bdi_wblist_needs_lock(bdi))
+			__wb_writeback(&bdi->wb, 0, sb, sync_mode);
+		else {
+			struct bdi_writeback *wb;
+			int idx;
+
+			idx = srcu_read_lock(&bdi->srcu);
+
+			list_for_each_entry_rcu(wb, &bdi->wb_list, list)
+				__wb_writeback(&bdi->wb, 0, sb, sync_mode);
+
+			srcu_read_unlock(&bdi->srcu, idx);
+		}
 	}
 
 	mutex_unlock(&bdi_lock);
 }
 
 /*
- * We have only a single wb per bdi, so just return that.
+ * If the filesystem didn't provide a way to map an inode to a dedicated
+ * flusher thread, it doesn't support more than 1 thread. So we know it's
+ * the default thread, return that.
  */
 static inline struct bdi_writeback *inode_get_wb(struct inode *inode)
 {
-	return &inode_to_bdi(inode)->wb;
+	const struct super_operations *sop = inode->i_sb->s_op;
+
+	if (!sop->inode_get_wb)
+		return &inode_to_bdi(inode)->wb;
+
+	return sop->inode_get_wb(inode);
 }
 
 /**
@@ -731,8 +903,24 @@ void generic_sync_bdi_inodes(struct super_block *sb,
 			     struct writeback_control *wbc)
 {
 	struct backing_dev_info *bdi = wbc->bdi;
+	struct bdi_writeback *wb;
+
+	/*
+	 * Common case is just a single wb thread and that is embedded in
+	 * the bdi, so it doesn't need locking
+	 */
+	if (!bdi_wblist_needs_lock(bdi))
+		generic_sync_wb_inodes(&bdi->wb, sb, wbc);
+	else {
+		int idx;
 
-	generic_sync_wb_inodes(&bdi->wb, sb, wbc);
+		idx = srcu_read_lock(&bdi->srcu);
+
+		list_for_each_entry_rcu(wb, &bdi->wb_list, list)
+			generic_sync_wb_inodes(wb, sb, wbc);
+
+		srcu_read_unlock(&bdi->srcu, idx);
+	}
 }
 
 /*
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 77dc62c..72b4797 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -13,6 +13,8 @@
 #include <linux/proportions.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/srcu.h>
 #include <linux/writeback.h>
 #include <asm/atomic.h>
 
@@ -26,6 +28,7 @@ struct dentry;
 enum bdi_state {
 	BDI_pending,		/* On its way to being activated */
 	BDI_wb_alloc,		/* Default embedded wb allocated */
+	BDI_wblist_lock,	/* bdi->wb_list now needs locking */
 	BDI_async_congested,	/* The async (write) queue is getting full */
 	BDI_sync_congested,	/* The sync queue is getting full */
 	BDI_unused,		/* Available bits start here */
@@ -42,6 +45,8 @@ enum bdi_stat_item {
 #define BDI_STAT_BATCH (8*(1+ilog2(nr_cpu_ids)))
 
 struct bdi_writeback {
+	struct list_head list;			/* hangs off the bdi */
+
 	struct backing_dev_info *bdi;		/* our parent bdi */
 	unsigned int nr;
 
@@ -50,13 +55,12 @@ struct bdi_writeback {
 	struct list_head	b_dirty;	/* dirty inodes */
 	struct list_head	b_io;		/* parked for writeback */
 	struct list_head	b_more_io;	/* parked for more writeback */
-
-	unsigned long		nr_pages;
-	struct super_block	*sb;
-	enum writeback_sync_modes sync_mode;
 };
 
+#define BDI_MAX_FLUSHERS	32
+
 struct backing_dev_info {
+	struct srcu_struct srcu; /* for wb_list read side protection */
 	struct list_head bdi_list;
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
 	unsigned long state;	/* Always use atomic bitops on this */
@@ -75,8 +79,12 @@ struct backing_dev_info {
 	unsigned int max_ratio, max_prop_frac;
 
 	struct bdi_writeback wb;  /* default writeback info for this bdi */
-	unsigned long wb_active;  /* bitmap of active tasks */
-	unsigned long wb_mask;	  /* number of registered tasks */
+	spinlock_t wb_lock;	  /* protects update side of wb_list */
+	struct list_head wb_list; /* the flusher threads hanging off this bdi */
+	unsigned long wb_mask;	  /* bitmask of registered tasks */
+	unsigned int wb_cnt;	  /* number of registered tasks */
+
+	struct list_head work_list;
 
 	struct device *dev;
 
@@ -99,11 +107,17 @@ int bdi_writeback_task(struct bdi_writeback *wb);
 void bdi_writeback_all(struct super_block *sb, long nr_pages,
 			enum writeback_sync_modes sync_mode);
 void bdi_add_default_flusher_task(struct backing_dev_info *bdi);
+void bdi_add_flusher_task(struct backing_dev_info *bdi);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 
 extern struct mutex bdi_lock;
 extern struct list_head bdi_list;
 
+static inline int bdi_wblist_needs_lock(struct backing_dev_info *bdi)
+{
+	return test_bit(BDI_wblist_lock, &bdi->state);
+}
+
 static inline int wb_has_dirty_io(struct bdi_writeback *wb)
 {
 	return !list_empty(&wb->b_dirty) ||
@@ -316,4 +330,10 @@ static inline bool mapping_cap_swap_backed(struct address_space *mapping)
 	return bdi_cap_swap_backed(mapping->backing_dev_info);
 }
 
+static inline int bdi_sched_wait(void *word)
+{
+	schedule();
+	return 0;
+}
+
 #endif		/* _LINUX_BACKING_DEV_H */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ecdc544..d3bda5d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1550,11 +1550,14 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
 extern ssize_t vfs_writev(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *);
 
+struct bdi_writeback;
+
 struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*destroy_inode)(struct inode *);
 
    	void (*dirty_inode) (struct inode *);
+	struct bdi_writeback *(*inode_get_wb) (struct inode *);
 	int (*write_inode) (struct inode *, int);
 	void (*drop_inode) (struct inode *);
 	void (*delete_inode) (struct inode *);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index df90b0e..3e74041 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -199,7 +199,42 @@ static int __init default_bdi_init(void)
 }
 subsys_initcall(default_bdi_init);
 
-static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
+static int wb_assign_nr(struct backing_dev_info *bdi, struct bdi_writeback *wb)
+{
+	unsigned long mask = BDI_MAX_FLUSHERS - 1;
+	unsigned int nr;
+
+	do {
+		if ((bdi->wb_mask & mask) == mask)
+			return 1;
+
+		nr = find_first_zero_bit(&bdi->wb_mask, BDI_MAX_FLUSHERS);
+	} while (test_and_set_bit(nr, &bdi->wb_mask));
+
+	wb->nr = nr;
+
+	spin_lock(&bdi->wb_lock);
+	bdi->wb_cnt++;
+	spin_unlock(&bdi->wb_lock);
+
+	return 0;
+}
+
+static void bdi_put_wb(struct backing_dev_info *bdi, struct bdi_writeback *wb)
+{
+	clear_bit(wb->nr, &bdi->wb_mask);
+
+	if (wb == &bdi->wb)
+		clear_bit(BDI_wb_alloc, &bdi->state);
+	else
+		kfree(wb);
+
+	spin_lock(&bdi->wb_lock);
+	bdi->wb_cnt--;
+	spin_unlock(&bdi->wb_lock);
+}
+
+static int bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
 {
 	memset(wb, 0, sizeof(*wb));
 
@@ -208,6 +243,30 @@ static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
 	INIT_LIST_HEAD(&wb->b_dirty);
 	INIT_LIST_HEAD(&wb->b_io);
 	INIT_LIST_HEAD(&wb->b_more_io);
+
+	return wb_assign_nr(bdi, wb);
+}
+
+static struct bdi_writeback *bdi_new_wb(struct backing_dev_info *bdi)
+{
+	struct bdi_writeback *wb;
+
+	/*
+	 * Default bdi->wb is already assigned, so just return it
+	 */
+	if (!test_and_set_bit(BDI_wb_alloc, &bdi->state))
+		wb = &bdi->wb;
+	else {
+		wb = kmalloc(sizeof(struct bdi_writeback), GFP_KERNEL);
+		if (wb) {
+			if (bdi_wb_init(wb, bdi)) {
+				kfree(wb);
+				wb = NULL;
+			}
+		}
+	}
+
+	return wb;
 }
 
 static void bdi_flush_io(struct backing_dev_info *bdi)
@@ -223,35 +282,26 @@ static void bdi_flush_io(struct backing_dev_info *bdi)
 	generic_sync_bdi_inodes(NULL, &wbc);
 }
 
-static int wb_assign_nr(struct backing_dev_info *bdi, struct bdi_writeback *wb)
+static void bdi_task_init(struct backing_dev_info *bdi,
+			  struct bdi_writeback *wb)
 {
-	set_bit(0, &bdi->wb_mask);
-	wb->nr = 0;
-	return 0;
-}
-
-static void bdi_put_wb(struct backing_dev_info *bdi, struct bdi_writeback *wb)
-{
-	clear_bit(wb->nr, &bdi->wb_mask);
-	clear_bit(BDI_wb_alloc, &bdi->state);
-}
+	struct task_struct *tsk = current;
+	int was_empty;
 
-static struct bdi_writeback *bdi_new_wb(struct backing_dev_info *bdi)
-{
-	struct bdi_writeback *wb;
+	/*
+	 * Add us to the active bdi_list. If we are adding threads beyond
+	 * the default embedded bdi_writeback, then we need to start using
+	 * proper locking. Check the list for empty first, then set the
+	 * BDI_wblist_lock flag if there's > 1 entry on the list now
+	 */
+	spin_lock(&bdi->wb_lock);
 
-	set_bit(BDI_wb_alloc, &bdi->state);
-	wb = &bdi->wb;
-	wb_assign_nr(bdi, wb);
-	return wb;
-}
+	was_empty = list_empty(&bdi->wb_list);
+	list_add_tail_rcu(&wb->list, &bdi->wb_list);
+	if (!was_empty)
+		set_bit(BDI_wblist_lock, &bdi->state);
 
-static int bdi_start_fn(void *ptr)
-{
-	struct bdi_writeback *wb = ptr;
-	struct backing_dev_info *bdi = wb->bdi;
-	struct task_struct *tsk = current;
-	int ret;
+	spin_unlock(&bdi->wb_lock);
 
 	tsk->flags |= PF_FLUSHER | PF_SWAPWRITE;
 	set_freezable();
@@ -260,6 +310,15 @@ static int bdi_start_fn(void *ptr)
 	 * Our parent may run at a different priority, just set us to normal
 	 */
 	set_user_nice(tsk, 0);
+}
+
+static int bdi_start_fn(void *ptr)
+{
+	struct bdi_writeback *wb = ptr;
+	struct backing_dev_info *bdi = wb->bdi;
+	int ret;
+
+	bdi_task_init(bdi, wb);
 
 	/*
 	 * Clear pending bit and wakeup anybody waiting to tear us down
@@ -268,15 +327,53 @@ static int bdi_start_fn(void *ptr)
 	smp_mb__after_clear_bit();
 	wake_up_bit(&bdi->state, BDI_pending);
 
+	/*
+	 * Make us discoverable on the bdi_list again
+	 */
+	mutex_lock(&bdi_lock);
+	list_add_tail(&bdi->bdi_list, &bdi_list);
+	mutex_unlock(&bdi_lock);
+
 	ret = bdi_writeback_task(wb);
 
+	/*
+	 * Remove us from the list
+	 */
+	spin_lock(&bdi->wb_lock);
+	list_del_rcu(&wb->list);
+	spin_unlock(&bdi->wb_lock);
+
+	/*
+	 * wait for rcu grace period to end, so we can free wb
+	 */
+	synchronize_srcu(&bdi->srcu);
+
 	bdi_put_wb(bdi, wb);
 	return ret;
 }
 
 int bdi_has_dirty_io(struct backing_dev_info *bdi)
 {
-	return wb_has_dirty_io(&bdi->wb);
+	struct bdi_writeback *wb;
+	int ret = 0;
+
+	if (!bdi_wblist_needs_lock(bdi))
+		ret = wb_has_dirty_io(&bdi->wb);
+	else {
+		int idx;
+
+		idx = srcu_read_lock(&bdi->srcu);
+
+		list_for_each_entry_rcu(wb, &bdi->wb_list, list) {
+			ret = wb_has_dirty_io(wb);
+			if (ret)
+				break;
+		}
+
+		srcu_read_unlock(&bdi->srcu, idx);
+	}
+
+	return ret;
 }
 
 static int bdi_forker_task(void *ptr)
@@ -284,6 +381,8 @@ static int bdi_forker_task(void *ptr)
 	struct bdi_writeback *me = ptr;
 	DEFINE_WAIT(wait);
 
+	bdi_task_init(me->bdi, me);
+
 	for (;;) {
 		struct backing_dev_info *bdi, *tmp;
 		struct bdi_writeback *wb;
@@ -360,26 +459,69 @@ readd_flush:
 }
 
 /*
- * Add a new flusher task that gets created for any bdi
- * that has dirty data pending writeout
+ * bdi_lock held on entry
  */
-void bdi_add_default_flusher_task(struct backing_dev_info *bdi)
+static void bdi_add_one_flusher_task(struct backing_dev_info *bdi,
+				     int(*func)(struct backing_dev_info *))
 {
 	if (!bdi_cap_writeback_dirty(bdi))
 		return;
 
 	/*
-	 * Someone already marked this pending for task creation
+	 * Check with the helper whether to proceed adding a task. Will only
+	 * abort if we two or more simultanous calls to
+	 * bdi_add_default_flusher_task() occured, further additions will block
+	 * waiting for previous additions to finish.
 	 */
-	if (test_and_set_bit(BDI_pending, &bdi->state))
-		return;
+	if (!func(bdi)) {
+		list_move_tail(&bdi->bdi_list, &bdi_pending_list);
 
-	mutex_lock(&bdi_lock);
-	list_move_tail(&bdi->bdi_list, &bdi_pending_list);
+		/*
+		 * We are now on the pending list, wake up bdi_forker_task()
+		 * to finish the job and add us back to the active bdi_list
+		 */
+		wake_up(&default_backing_dev_info.wb.wait);
+	}
+}
+
+static int flusher_add_helper_block(struct backing_dev_info *bdi)
+{
 	mutex_unlock(&bdi_lock);
+	wait_on_bit_lock(&bdi->state, BDI_pending, bdi_sched_wait,
+				TASK_UNINTERRUPTIBLE);
+	mutex_lock(&bdi_lock);
+	return 0;
+}
+
+static int flusher_add_helper_test(struct backing_dev_info *bdi)
+{
+	return test_and_set_bit(BDI_pending, &bdi->state);
+}
+
+/*
+ * Add the default flusher task that gets created for any bdi
+ * that has dirty data pending writeout
+ */
+void bdi_add_default_flusher_task(struct backing_dev_info *bdi)
+{
+	bdi_add_one_flusher_task(bdi, flusher_add_helper_test);
+}
 
-	wake_up(&default_backing_dev_info.wb.wait);
+/**
+ * bdi_add_flusher_task - add one more flusher task to this @bdi
+ *  @bdi:	the bdi
+ *
+ * Add an additional flusher task to this @bdi. Will block waiting on
+ * previous additions, if any.
+ *
+ */
+void bdi_add_flusher_task(struct backing_dev_info *bdi)
+{
+	mutex_lock(&bdi_lock);
+	bdi_add_one_flusher_task(bdi, flusher_add_helper_block);
+	mutex_unlock(&bdi_lock);
 }
+EXPORT_SYMBOL(bdi_add_flusher_task);
 
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...)
@@ -444,17 +586,13 @@ int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev)
 }
 EXPORT_SYMBOL(bdi_register_dev);
 
-static int sched_wait(void *word)
-{
-	schedule();
-	return 0;
-}
-
 /*
  * Remove bdi from global list and shutdown any threads we have running
  */
 static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 {
+	struct bdi_writeback *wb;
+
 	if (!bdi_cap_writeback_dirty(bdi))
 		return;
 
@@ -462,7 +600,8 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	 * If setup is pending, wait for that to complete first
 	 * Make sure nobody finds us on the bdi_list anymore
 	 */
-	wait_on_bit(&bdi->state, BDI_pending, sched_wait, TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&bdi->state, BDI_pending, bdi_sched_wait,
+			TASK_UNINTERRUPTIBLE);
 
 	/*
 	 * Make sure nobody finds us on the bdi_list anymore
@@ -472,9 +611,11 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	mutex_unlock(&bdi_lock);
 
 	/*
-	 * Finally, kill the kernel thread
+	 * Finally, kill the kernel threads. We don't need to be RCU
+	 * safe anymore, since the bdi is gone from visibility.
 	 */
-	kthread_stop(bdi->wb.task);
+	list_for_each_entry(wb, &bdi->wb_list, list)
+		kthread_stop(wb->task);
 }
 
 void bdi_unregister(struct backing_dev_info *bdi)
@@ -499,8 +640,12 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
+	spin_lock_init(&bdi->wb_lock);
+	bdi->wb_mask = 0;
+	bdi->wb_cnt = 0;
 	INIT_LIST_HEAD(&bdi->bdi_list);
-	bdi->wb_mask = bdi->wb_active = 0;
+	INIT_LIST_HEAD(&bdi->wb_list);
+	INIT_LIST_HEAD(&bdi->work_list);
 
 	bdi_wb_init(&bdi->wb, bdi);
 
@@ -510,10 +655,15 @@ int bdi_init(struct backing_dev_info *bdi)
 			goto err;
 	}
 
+	err = init_srcu_struct(&bdi->srcu);
+	if (err)
+		goto err;
+
 	bdi->dirty_exceeded = 0;
 	err = prop_local_init_percpu(&bdi->completions);
 
 	if (err) {
+		cleanup_srcu_struct(&bdi->srcu);
 err:
 		while (i--)
 			percpu_counter_destroy(&bdi->bdi_stat[i]);
@@ -531,6 +681,8 @@ void bdi_destroy(struct backing_dev_info *bdi)
 
 	bdi_unregister(bdi);
 
+	cleanup_srcu_struct(&bdi->srcu);
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
 		percpu_counter_destroy(&bdi->bdi_stat[i]);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 54a4a65..7dd7de7 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -665,8 +665,7 @@ void throttle_vm_writeout(gfp_t gfp_mask)
 
 /*
  * Start writeback of `nr_pages' pages.  If `nr_pages' is zero, write back
- * the whole world.  Returns 0 if a pdflush thread was dispatched.  Returns
- * -1 if all pdflush threads were busy.
+ * the whole world.
  */
 void wakeup_flusher_threads(long nr_pages)
 {
@@ -674,7 +673,6 @@ void wakeup_flusher_threads(long nr_pages)
 		nr_pages = global_page_state(NR_FILE_DIRTY) +
 				global_page_state(NR_UNSTABLE_NFS);
 	bdi_writeback_all(NULL, nr_pages, WB_SYNC_NONE);
-	return;
 }
 
 static void laptop_timer_fn(unsigned long unused);
-- 
1.6.3.rc0.1.gf800


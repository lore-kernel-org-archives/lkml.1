Return-Path: <linux-kernel-owner+w=401wt.eu-S1762624AbZE1LtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624AbZE1LtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759587AbZE1LrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:47:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58711 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbZE1Lqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:46:50 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 07/11] writeback: support > 1 flusher thread per bdi
Date: Thu, 28 May 2009 13:46:40 +0200
Message-Id: <1243511204-2328-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
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
 fs/fs-writeback.c           |  445 +++++++++++++++++++++++++++++++++++--------
 include/linux/backing-dev.h |   34 +++-
 include/linux/fs.h          |    3 +
 include/linux/writeback.h   |    1 +
 mm/backing-dev.c            |  242 +++++++++++++++++++-----
 5 files changed, 592 insertions(+), 133 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ed242d5..f3db578 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -34,80 +34,249 @@
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
+	struct list_head wait_list;
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
 
-	return !test_and_set_bit(wb->nr, &bdi->wb_active);
+static inline void bdi_work_init(struct bdi_work *work, struct super_block *sb,
+				 unsigned long nr_pages,
+				 enum writeback_sync_modes sync_mode)
+{
+	INIT_RCU_HEAD(&work->rcu_head);
+	work->sb_data = (unsigned long) sb;
+	work->nr_pages = nr_pages;
+	work->sync_mode = sync_mode;
+	work->state = 1;
+}
+
+static inline void bdi_work_init_on_stack(struct bdi_work *work,
+					  struct super_block *sb,
+					  unsigned long nr_pages,
+					  enum writeback_sync_modes sync_mode)
+{
+	bdi_work_init(work, sb, nr_pages, sync_mode);
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
+static void bdi_work_clear(struct bdi_work *work)
 {
-	struct backing_dev_info *bdi = wb->bdi;
+	clear_bit(0, &work->state);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&work->state, 0);
+}
 
-	wb->nr_pages = 0;
-	wb->sb = NULL;
-	clear_bit(wb->nr, &bdi->wb_active);
+static void bdi_work_free(struct rcu_head *head)
+{
+	struct bdi_work *work = container_of(head, struct bdi_work, rcu_head);
+
+	if (!bdi_work_on_stack(work))
+		kfree(work);
+	else
+		bdi_work_clear(work);
 }
 
-static void wb_start_writeback(struct bdi_writeback *wb, struct super_block *sb,
-			       long nr_pages,
-			       enum writeback_sync_modes sync_mode)
+static void wb_work_complete(struct bdi_work *work)
 {
-	if (!wb_has_dirty_io(wb))
-		return;
+	const enum writeback_sync_modes sync_mode = work->sync_mode;
 
-	if (writeback_acquire(wb)) {
-		wb->nr_pages = nr_pages;
-		wb->sb = sb;
-		wb->sync_mode = sync_mode;
+	/*
+	 * For allocated work, we can clear the done/seen bit right here.
+	 * For on-stack work, we need to postpone both the clear and free
+	 * to after the RCU grace period, since the stack could be invalidated
+	 * as soon as bdi_work_clear() has done the wakeup.
+	 */
+	if (!bdi_work_on_stack(work))
+		bdi_work_clear(work);
+	if (sync_mode == WB_SYNC_NONE || bdi_work_on_stack(work))
+		call_rcu(&work->rcu_head, bdi_work_free);
+}
 
-		if (wb->task)
-			wake_up_process(wb->task);
+static void wb_clear_pending(struct bdi_writeback *wb, struct bdi_work *work)
+{
+	/*
+	 * The caller has retrieved the work arguments from this work,
+	 * drop our reference. If this is the last ref, delete and free it
+	 */
+	if (atomic_dec_and_test(&work->pending)) {
+		struct backing_dev_info *bdi = wb->bdi;
+
+		spin_lock(&bdi->wb_lock);
+		list_del_rcu(&work->list);
+		spin_unlock(&bdi->wb_lock);
+
+		wb_work_complete(work);
 	}
 }
 
-int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
-			 long nr_pages, enum writeback_sync_modes sync_mode)
+static void wb_start_writeback(struct bdi_writeback *wb, struct bdi_work *work)
 {
 	/*
-	 * This only happens the first time someone kicks this bdi, so put
-	 * it out-of-line.
+	 * If we failed allocating the bdi work item, wake up the wb thread
+	 * always. As a safety precaution, it'll flush out everything
 	 */
-	if (unlikely(!bdi->wb.task)) {
+	if (!wb_has_dirty_io(wb) && work)
+		wb_clear_pending(wb, work);
+	else if (wb->task)
+		wake_up_process(wb->task);
+}
+
+static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
+{
+	if (work) {
+		work->seen = bdi->wb_mask;
+		BUG_ON(!work->seen);
+		atomic_set(&work->pending, bdi->wb_cnt);
+		BUG_ON(!bdi->wb_cnt);
+
+		/*
+		 * Make sure stores are seen before it appears on the list
+		 */
+		smp_mb();
+
+		spin_lock(&bdi->wb_lock);
+		list_add_tail_rcu(&work->list, &bdi->work_list);
+		spin_unlock(&bdi->wb_lock);
+	}
+}
+
+static void bdi_sched_work(struct backing_dev_info *bdi, struct bdi_work *work)
+{
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
+}
+
+static void __bdi_start_work(struct backing_dev_info *bdi,
+			     struct bdi_work *work)
+{
+	/*
+	 * If the default thread isn't there, make sure we add it. When
+	 * it gets created and wakes up, we'll run this work.
+	 */
+	if (unlikely(list_empty_careful(&bdi->wb_list)))
 		bdi_add_default_flusher_task(bdi);
-		return 1;
+	else
+		bdi_sched_work(bdi, work);
+}
+
+static void bdi_start_work(struct backing_dev_info *bdi, struct bdi_work *work)
+{
+	/*
+	 * If the default thread isn't there, make sure we add it. When
+	 * it gets created and wakes up, we'll run this work.
+	 */
+	if (unlikely(list_empty_careful(&bdi->wb_list))) {
+		mutex_lock(&bdi_lock);
+		bdi_add_default_flusher_task(bdi);
+		mutex_unlock(&bdi_lock);
+	} else
+		bdi_sched_work(bdi, work);
+}
+
+/*
+ * Used for on-stack allocated work items. The caller needs to wait until
+ * the wb threads have acked the work before it's safe to continue.
+ */
+static void bdi_wait_on_work_clear(struct bdi_work *work)
+{
+	wait_on_bit(&work->state, 0, bdi_sched_wait, TASK_UNINTERRUPTIBLE);
+}
+
+static struct bdi_work *bdi_alloc_work(struct super_block *sb, long nr_pages,
+				       enum writeback_sync_modes sync_mode)
+{
+	struct bdi_work *work;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (work)
+		bdi_work_init(work, sb, nr_pages, sync_mode);
+
+	return work;
+}
+
+void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
+			 long nr_pages, enum writeback_sync_modes sync_mode)
+{
+	const bool must_wait = sync_mode == WB_SYNC_ALL;
+	struct bdi_work work_stack, *work = NULL;
+
+	if (!must_wait)
+		work = bdi_alloc_work(sb, nr_pages, sync_mode);
+
+	if (!work) {
+		work = &work_stack;
+		bdi_work_init_on_stack(work, sb, nr_pages, sync_mode);
 	}
 
-	wb_start_writeback(&bdi->wb, sb, nr_pages, sync_mode);
-	return 0;
+	bdi_queue_work(bdi, work);
+	bdi_start_work(bdi, work);
+
+	/*
+	 * If the sync mode is WB_SYNC_ALL, block waiting for the work to
+	 * complete. If not, we only need to wait for the work to be started,
+	 * if we allocated it on-stack. We use the same mechanism, if the
+	 * wait bit is set in the bdi_work struct, then threads will not
+	 * clear pending until after they are done.
+	 *
+	 * Note that work == &work_stack if must_wait is true, so we don't
+	 * need to do call_rcu() here ever, since the completion path will
+	 * have done that for us.
+	 */
+	if (must_wait || work == &work_stack) {
+		bdi_wait_on_work_clear(work);
+		if (work != &work_stack)
+			call_rcu(&work->rcu_head, bdi_work_free);
+	}
 }
 
 /*
@@ -157,7 +326,7 @@ static void wb_kupdated(struct bdi_writeback *wb)
 		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
-		generic_sync_bdi_inodes(NULL, &wbc);
+		generic_sync_wb_inodes(wb, NULL, &wbc);
 		if (wbc.nr_to_write > 0)
 			break;	/* All the old data is written */
 		nr_to_write -= MAX_WRITEBACK_PAGES;
@@ -174,22 +343,19 @@ static inline bool over_bground_thresh(void)
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
 
@@ -197,7 +363,7 @@ static void wb_writeback(struct bdi_writeback *wb)
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
-		generic_sync_wb_inodes(wb, wb->sb, &wbc);
+		generic_sync_wb_inodes(wb, sb, &wbc);
 		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		/*
 		 * If we ran out of stuff to write, bail unless more_io got set
@@ -211,6 +377,82 @@ static void wb_writeback(struct bdi_writeback *wb)
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
+/*
+ * Retrieve work items and do the writeback they describe
+ */
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
+		/*
+		 * If this isn't a data integrity operation, just notify
+		 * that we have seen this work and we are now starting it.
+		 */
+		if (sync_mode == WB_SYNC_NONE)
+			wb_clear_pending(wb, work);
+
+		__wb_writeback(wb, nr_pages, sb, sync_mode);
+
+		/*
+		 * This is a data integrity writeback, so only do the
+		 * notification when we have completed the work.
+		 */
+		if (sync_mode == WB_SYNC_ALL)
+			wb_clear_pending(wb, work);
+	}
+}
+
+/*
+ * This will be inlined in bdi_writeback_task() once we get rid of any
+ * dirty inodes on the default_backing_dev_info
+ */
+void wb_do_writeback(struct bdi_writeback *wb)
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
@@ -219,57 +461,84 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 	while (!kthread_should_stop()) {
 		unsigned long wait_jiffies;
 
+		wb_do_writeback(wb);
+
 		wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
 		set_current_state(TASK_INTERRUPTIBLE);
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
 	}
 
 	return 0;
 }
 
+/*
+ * Schedule writeback for all backing devices. Expensive! If this is a data
+ * integrity operation, writeback will be complete when this returns. If
+ * we are simply called for WB_SYNC_NONE, then writeback will merely be
+ * scheduled to run.
+ */
 void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc)
 {
+	const bool must_wait = wbc->sync_mode == WB_SYNC_ALL;
 	struct backing_dev_info *bdi, *tmp;
+	struct bdi_work *work;
+	LIST_HEAD(list);
 
 	mutex_lock(&bdi_lock);
 
 	list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
+		struct bdi_work *work;
+
 		if (!bdi_has_dirty_io(bdi))
 			continue;
-		bdi_start_writeback(bdi, sb, wbc->nr_to_write, wbc->sync_mode);
+
+		/*
+		 * If work allocation fails, do the writes inline. An
+		 * alternative approach would be too fall back to an on-stack
+		 * allocation of work. For that we need to drop the bdi_lock
+		 * and restart the scan afterwards, though.
+		 */
+		work = bdi_alloc_work(sb, wbc->nr_to_write, wbc->sync_mode);
+		if (!work) {
+			wbc->bdi = bdi;
+			generic_sync_bdi_inodes(sb, wbc);
+			continue;
+		}
+		if (must_wait)
+			list_add_tail(&work->wait_list, &list);
+
+		bdi_queue_work(bdi, work);
+		__bdi_start_work(bdi, work);
 	}
 
 	mutex_unlock(&bdi_lock);
+
+	/*
+	 * If this is for WB_SYNC_ALL, wait for pending work to complete
+	 * before returning.
+	 */
+	while (!list_empty(&list)) {
+		work = list_entry(list.next, struct bdi_work, wait_list);
+		list_del(&work->wait_list);
+		bdi_wait_on_work_clear(work);
+		call_rcu(&work->rcu_head, bdi_work_free);
+	}
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
@@ -723,8 +992,24 @@ void generic_sync_bdi_inodes(struct super_block *sb,
 			     struct writeback_control *wbc)
 {
 	struct backing_dev_info *bdi = wbc->bdi;
+	struct bdi_writeback *wb;
 
-	generic_sync_wb_inodes(&bdi->wb, sb, wbc);
+	/*
+	 * Common case is just a single wb thread and that is embedded in
+	 * the bdi, so it doesn't need locking
+	 */
+	if (!bdi_wblist_needs_lock(bdi))
+		generic_sync_wb_inodes(&bdi->wb, sb, wbc);
+	else {
+		int idx;
+
+		idx = srcu_read_lock(&bdi->srcu);
+
+		list_for_each_entry_rcu(wb, &bdi->wb_list, list)
+			generic_sync_wb_inodes(wb, sb, wbc);
+
+		srcu_read_unlock(&bdi->srcu, idx);
+	}
 }
 
 /*
@@ -751,7 +1036,7 @@ void generic_sync_sb_inodes(struct super_block *sb,
 				struct writeback_control *wbc)
 {
 	if (wbc->bdi)
-		generic_sync_bdi_inodes(sb, wbc);
+		bdi_start_writeback(wbc->bdi, sb, wbc->nr_to_write, wbc->sync_mode);
 	else
 		bdi_writeback_all(sb, wbc);
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 59f88e5..8584438 100644
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
 
@@ -49,13 +54,12 @@ struct bdi_writeback {
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
@@ -74,8 +78,12 @@ struct backing_dev_info {
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
 
@@ -92,16 +100,22 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...);
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
-int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
+void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 			 long nr_pages, enum writeback_sync_modes sync_mode);
 int bdi_writeback_task(struct bdi_writeback *wb);
 void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc);
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
@@ -314,4 +328,10 @@ static inline bool mapping_cap_swap_backed(struct address_space *mapping)
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
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index baf04a9..e414702 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -69,6 +69,7 @@ void writeback_inodes(struct writeback_control *wbc);
 int inode_wait(void *);
 void sync_inodes_sb(struct super_block *, int wait);
 void sync_inodes(int wait);
+void wb_do_writeback(struct bdi_writeback *wb);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 75c9054..8980f6f 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -213,52 +213,100 @@ static int __init default_bdi_init(void)
 }
 subsys_initcall(default_bdi_init);
 
-static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
+static int wb_assign_nr(struct backing_dev_info *bdi, struct bdi_writeback *wb)
 {
-	memset(wb, 0, sizeof(*wb));
+	unsigned long mask = BDI_MAX_FLUSHERS - 1;
+	unsigned int nr;
 
-	wb->bdi = bdi;
-	INIT_LIST_HEAD(&wb->b_dirty);
-	INIT_LIST_HEAD(&wb->b_io);
-	INIT_LIST_HEAD(&wb->b_more_io);
-}
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
 
-static int wb_assign_nr(struct backing_dev_info *bdi, struct bdi_writeback *wb)
-{
-	set_bit(0, &bdi->wb_mask);
-	wb->nr = 0;
 	return 0;
 }
 
 static void bdi_put_wb(struct backing_dev_info *bdi, struct bdi_writeback *wb)
 {
-	clear_bit(wb->nr, &bdi->wb_mask);
-	clear_bit(BDI_wb_alloc, &bdi->state);
+	/*
+	 * If this is the default wb thread exiting, leave the bit set
+	 * in the wb mask as we set that before it's created as well. This
+	 * is done to make sure that assigned work with no thread has at
+	 * least one receipient.
+	 */
+	if (wb == &bdi->wb)
+		clear_bit(BDI_wb_alloc, &bdi->state);
+	else {
+		clear_bit(wb->nr, &bdi->wb_mask);
+		kfree(wb);
+		spin_lock(&bdi->wb_lock);
+		bdi->wb_cnt--;
+		spin_unlock(&bdi->wb_lock);
+	}
+}
+
+static int bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
+{
+	memset(wb, 0, sizeof(*wb));
+
+	wb->bdi = bdi;
+	INIT_LIST_HEAD(&wb->b_dirty);
+	INIT_LIST_HEAD(&wb->b_io);
+	INIT_LIST_HEAD(&wb->b_more_io);
+
+	return wb_assign_nr(bdi, wb);
 }
 
 static struct bdi_writeback *bdi_new_wb(struct backing_dev_info *bdi)
 {
 	struct bdi_writeback *wb;
 
-	set_bit(BDI_wb_alloc, &bdi->state);
-	wb = &bdi->wb;
-	wb_assign_nr(bdi, wb);
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
 	return wb;
 }
 
-static int bdi_start_fn(void *ptr)
+static void bdi_task_init(struct backing_dev_info *bdi,
+			  struct bdi_writeback *wb)
 {
-	struct bdi_writeback *wb = ptr;
-	struct backing_dev_info *bdi = wb->bdi;
 	struct task_struct *tsk = current;
-	int ret;
+	int was_empty;
 
 	/*
-	 * Add us to the active bdi_list
+	 * Add us to the active bdi_list. If we are adding threads beyond
+	 * the default embedded bdi_writeback, then we need to start using
+	 * proper locking. Check the list for empty first, then set the
+	 * BDI_wblist_lock flag if there's > 1 entry on the list now
 	 */
-	mutex_lock(&bdi_lock);
-	list_add(&bdi->bdi_list, &bdi_list);
-	mutex_unlock(&bdi_lock);
+	spin_lock(&bdi->wb_lock);
+
+	was_empty = list_empty(&bdi->wb_list);
+	list_add_tail_rcu(&wb->list, &bdi->wb_list);
+	if (!was_empty)
+		set_bit(BDI_wblist_lock, &bdi->state);
+
+	spin_unlock(&bdi->wb_lock);
 
 	tsk->flags |= PF_FLUSHER | PF_SWAPWRITE;
 	set_freezable();
@@ -267,6 +315,22 @@ static int bdi_start_fn(void *ptr)
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
+	/*
+	 * Add us to the active bdi_list
+	 */
+	mutex_lock(&bdi_lock);
+	list_add(&bdi->bdi_list, &bdi_list);
+	mutex_unlock(&bdi_lock);
+
+	bdi_task_init(bdi, wb);
 
 	/*
 	 * Clear pending bit and wakeup anybody waiting to tear us down
@@ -277,13 +341,44 @@ static int bdi_start_fn(void *ptr)
 
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
 
 static void bdi_flush_io(struct backing_dev_info *bdi)
@@ -340,6 +435,8 @@ static int bdi_forker_task(void *ptr)
 {
 	struct bdi_writeback *me = ptr;
 
+	bdi_task_init(me->bdi, me);
+
 	for (;;) {
 		struct backing_dev_info *bdi, *tmp;
 		struct bdi_writeback *wb;
@@ -348,8 +445,8 @@ static int bdi_forker_task(void *ptr)
 		 * Temporary measure, we want to make sure we don't see
 		 * dirty data on the default backing_dev_info
 		 */
-		if (wb_has_dirty_io(me))
-			bdi_flush_io(me->bdi);
+		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list))
+			wb_do_writeback(me);
 
 		mutex_lock(&bdi_lock);
 
@@ -417,27 +514,70 @@ readd_flush:
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
+		wake_up_process(default_backing_dev_info.wb.task);
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
 
-	wake_up_process(default_backing_dev_info.wb.task);
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
 }
 
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
+}
+EXPORT_SYMBOL(bdi_add_flusher_task);
+
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...)
 {
@@ -501,24 +641,21 @@ int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev)
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
 
 	/*
 	 * If setup is pending, wait for that to complete first
 	 */
-	wait_on_bit(&bdi->state, BDI_pending, sched_wait, TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&bdi->state, BDI_pending, bdi_sched_wait,
+			TASK_UNINTERRUPTIBLE);
 
 	/*
 	 * Make sure nobody finds us on the bdi_list anymore
@@ -528,9 +665,11 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
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
@@ -554,8 +693,12 @@ int bdi_init(struct backing_dev_info *bdi)
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
 
@@ -565,10 +708,15 @@ int bdi_init(struct backing_dev_info *bdi)
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
@@ -586,6 +734,8 @@ void bdi_destroy(struct backing_dev_info *bdi)
 
 	bdi_unregister(bdi);
 
+	cleanup_srcu_struct(&bdi->srcu);
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
 		percpu_counter_destroy(&bdi->bdi_stat[i]);
 
-- 
1.6.3.rc0.1.gf800


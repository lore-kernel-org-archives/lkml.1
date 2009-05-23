Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbZEWTPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbZEWTPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 15:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZEWTPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 15:15:01 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40788 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbZEWTPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 15:15:00 -0400
Date: Sat, 23 May 2009 21:15:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads #4
Message-ID: <20090523191500.GV11363@kernel.dk>
References: <20090520080938.GM11363@kernel.dk> <20090520085446.GN11363@kernel.dk> <1242811142.2560.33.camel@ymzhang> <20090520092528.GP11363@kernel.dk> <20090520111910.GS11363@kernel.dk> <1242887627.2560.45.camel@ymzhang> <20090521091033.GA6987@duck.suse.cz> <1242955708.2560.52.camel@ymzhang> <20090522081539.GM11363@kernel.dk> <20090522204401.GQ11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522204401.GQ11363@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22 2009, Jens Axboe wrote:
> Please try with this combined patch against what you are running now, it
> should resolve the issue. It needs a bit more work, but I'm running out
> of time today. I'l get it finalized, cleaned up, and integrated. Then
> I'll post a new revision of the patch set.
> 

This one has been tested good and has a few more tweaks. So please try
that! It should be pretty close to final now, will repost the series on
monday.

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index f80afaa..33357c3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -50,6 +50,7 @@ struct bdi_work {
 
 	unsigned long sb_data;
 	unsigned long nr_pages;
+	enum writeback_sync_modes sync_mode;
 
 	unsigned long state;
 };
@@ -65,19 +66,22 @@ static inline bool bdi_work_on_stack(struct bdi_work *work)
 }
 
 static inline void bdi_work_init(struct bdi_work *work, struct super_block *sb,
-				 unsigned long nr_pages)
+				 unsigned long nr_pages,
+				 enum writeback_sync_modes sync_mode)
 {
 	INIT_RCU_HEAD(&work->rcu_head);
 	work->sb_data = (unsigned long) sb;
 	work->nr_pages = nr_pages;
+	work->sync_mode = sync_mode;
 	work->state = 0;
 }
 
 static inline void bdi_work_init_on_stack(struct bdi_work *work,
 					  struct super_block *sb,
-					  unsigned long nr_pages)
+					  unsigned long nr_pages,
+				 	  enum writeback_sync_modes sync_mode)
 {
-	bdi_work_init(work, sb, nr_pages);
+	bdi_work_init(work, sb, nr_pages, sync_mode);
 	set_bit(0, &work->state);
 	work->sb_data |= 1UL;
 }
@@ -136,6 +140,9 @@ static void wb_start_writeback(struct bdi_writeback *wb, struct bdi_work *work)
 		wake_up(&wb->wait);
 }
 
+/*
+ * Add work to bdi work list.
+ */
 static int bdi_queue_writeback(struct backing_dev_info *bdi,
 			       struct bdi_work *work)
 {
@@ -189,17 +196,17 @@ static void bdi_wait_on_work_start(struct bdi_work *work)
 }
 
 int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
-			 long nr_pages)
+			 long nr_pages, enum writeback_sync_modes sync_mode)
 {
 	struct bdi_work work_stack, *work;
 	int ret;
 
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	if (work)
-		bdi_work_init(work, sb, nr_pages);
+		bdi_work_init(work, sb, nr_pages, sync_mode);
 	else {
 		work = &work_stack;
-		bdi_work_init_on_stack(work, sb, nr_pages);
+		bdi_work_init_on_stack(work, sb, nr_pages, sync_mode);
 	}
 
 	ret = bdi_queue_writeback(bdi, work);
@@ -273,24 +280,31 @@ static long wb_kupdated(struct bdi_writeback *wb)
 	return wrote;
 }
 
+static inline bool over_bground_thresh(void)
+{
+	unsigned long background_thresh, dirty_thresh;
+
+	get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
+
+	return (global_page_state(NR_FILE_DIRTY) +
+		global_page_state(NR_UNSTABLE_NFS) >= background_thresh);
+}
+
 static long __wb_writeback(struct bdi_writeback *wb, long nr_pages,
-			   struct super_block *sb)
+			   struct super_block *sb,
+			   enum writeback_sync_modes sync_mode)
 {
 	struct writeback_control wbc = {
 		.bdi			= wb->bdi,
-		.sync_mode		= WB_SYNC_NONE,
+		.sync_mode		= sync_mode,
 		.older_than_this	= NULL,
 		.range_cyclic		= 1,
 	};
 	long wrote = 0;
 
 	for (;;) {
-		unsigned long background_thresh, dirty_thresh;
-
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
-		if ((global_page_state(NR_FILE_DIRTY) +
-		    global_page_state(NR_UNSTABLE_NFS) < background_thresh) &&
-		    nr_pages <= 0)
+		if (sync_mode == WB_SYNC_NONE && nr_pages <= 0 &&
+		    !over_bground_thresh())
 			break;
 
 		wbc.more_io = 0;
@@ -345,9 +359,10 @@ static long wb_writeback(struct bdi_writeback *wb)
 	while ((work = get_next_work_item(bdi, wb)) != NULL) {
 		struct super_block *sb = bdi_work_sb(work);
 		long nr_pages = work->nr_pages;
+		enum writeback_sync_modes sync_mode = work->sync_mode;
 
 		wb_clear_pending(wb, work);
-		wrote += __wb_writeback(wb, nr_pages, sb);
+		wrote += __wb_writeback(wb, nr_pages, sb, sync_mode);
 	}
 
 	return wrote;
@@ -420,39 +435,36 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 	return 0;
 }
 
-void bdi_writeback_all(struct super_block *sb, long nr_pages)
+/*
+ * Do in-line writeback for all backing devices. Expensive!
+ */
+void bdi_writeback_all(struct super_block *sb, long nr_pages,
+		       enum writeback_sync_modes sync_mode)
 {
-	struct list_head *entry = &bdi_list;
+	struct backing_dev_info *bdi, *tmp;
 
-	rcu_read_lock();
-
-	list_for_each_continue_rcu(entry, &bdi_list) {
-		struct backing_dev_info *bdi;
-		struct list_head *next;
-		struct bdi_work *work;
+	mutex_lock(&bdi_lock);
 
-		bdi = list_entry(entry, struct backing_dev_info, bdi_list);
+	list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
 		if (!bdi_has_dirty_io(bdi))
 			continue;
 
-		/*
-		 * If this allocation fails, we just wakeup the thread and
-		 * let it do kupdate writeback
-		 */
-		work = kmalloc(sizeof(*work), GFP_ATOMIC);
-		if (work)
-			bdi_work_init(work, sb, nr_pages);
+		if (!bdi_wblist_needs_lock(bdi))
+			__wb_writeback(&bdi->wb, 0, sb, sync_mode);
+		else {
+			struct bdi_writeback *wb;
+			int idx;
 
-		/*
-		 * Prepare to start from previous entry if this one gets moved
-		 * to the bdi_pending list.
-		 */
-		next = entry->prev;
-		if (bdi_queue_writeback(bdi, work))
-			entry = next;
+			idx = srcu_read_lock(&bdi->srcu);
+
+			list_for_each_entry_rcu(wb, &bdi->wb_list, list)
+				__wb_writeback(&bdi->wb, 0, sb, sync_mode);
+
+			srcu_read_unlock(&bdi->srcu, idx);
+		}
 	}
 
-	rcu_read_unlock();
+	mutex_unlock(&bdi_lock);
 }
 
 /*
@@ -972,9 +984,9 @@ void generic_sync_sb_inodes(struct super_block *sb,
 				struct writeback_control *wbc)
 {
 	if (wbc->bdi)
-		bdi_start_writeback(wbc->bdi, sb, 0);
+		generic_sync_bdi_inodes(sb, wbc);
 	else
-		bdi_writeback_all(sb, 0);
+		bdi_writeback_all(sb, 0, wbc->sync_mode);
 
 	if (wbc->sync_mode == WB_SYNC_ALL) {
 		struct inode *inode, *old_inode = NULL;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 7c2874f..0b20d4b 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -15,6 +15,7 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/srcu.h>
+#include <linux/writeback.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -60,7 +61,6 @@ struct bdi_writeback {
 #define BDI_MAX_FLUSHERS	32
 
 struct backing_dev_info {
-	struct rcu_head rcu_head;
 	struct srcu_struct srcu; /* for wb_list read side protection */
 	struct list_head bdi_list;
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
@@ -105,14 +105,15 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
 int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
-			 long nr_pages);
+			 long nr_pages, enum writeback_sync_modes sync_mode);
 int bdi_writeback_task(struct bdi_writeback *wb);
-void bdi_writeback_all(struct super_block *sb, long nr_pages);
+void bdi_writeback_all(struct super_block *sb, long nr_pages,
+			enum writeback_sync_modes sync_mode);
 void bdi_add_default_flusher_task(struct backing_dev_info *bdi);
 void bdi_add_flusher_task(struct backing_dev_info *bdi);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 
-extern spinlock_t bdi_lock;
+extern struct mutex bdi_lock;
 extern struct list_head bdi_list;
 
 static inline int wb_is_default_task(struct bdi_writeback *wb)
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 60578bc..3ce3b57 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -26,7 +26,7 @@ struct backing_dev_info default_backing_dev_info = {
 EXPORT_SYMBOL_GPL(default_backing_dev_info);
 
 static struct class *bdi_class;
-DEFINE_SPINLOCK(bdi_lock);
+DEFINE_MUTEX(bdi_lock);
 LIST_HEAD(bdi_list);
 LIST_HEAD(bdi_pending_list);
 
@@ -360,14 +360,15 @@ static int bdi_start_fn(void *ptr)
 	 * Clear pending bit and wakeup anybody waiting to tear us down
 	 */
 	clear_bit(BDI_pending, &bdi->state);
+	smp_mb__after_clear_bit();
 	wake_up_bit(&bdi->state, BDI_pending);
 
 	/*
 	 * Make us discoverable on the bdi_list again
 	 */
-	spin_lock_bh(&bdi_lock);
-	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
-	spin_unlock_bh(&bdi_lock);
+	mutex_lock(&bdi_lock);
+	list_add_tail(&bdi->bdi_list, &bdi_list);
+	mutex_unlock(&bdi_lock);
 
 	ret = bdi_writeback_task(wb);
 
@@ -419,15 +420,9 @@ static int bdi_forker_task(void *ptr)
 	bdi_task_init(me->bdi, me);
 
 	for (;;) {
-		struct backing_dev_info *bdi;
+		struct backing_dev_info *bdi, *tmp;
 		struct bdi_writeback *wb;
 
-		prepare_to_wait(&me->wait, &wait, TASK_INTERRUPTIBLE);
-
-		smp_mb();
-		if (list_empty(&bdi_pending_list))
-			schedule();
-
 		/*
 		 * Ideally we'd like not to see any dirty inodes on the
 		 * default_backing_dev_info. Until these are tracked down,
@@ -438,19 +433,39 @@ static int bdi_forker_task(void *ptr)
 		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list))
 			wb_do_writeback(me);
 
+		prepare_to_wait(&me->wait, &wait, TASK_INTERRUPTIBLE);
+
+		mutex_lock(&bdi_lock);
+
+		/*
+		 * Check if any existing bdi's have dirty data without
+		 * a thread registered. If so, set that up.
+		 */
+		list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
+			if (!list_empty(&bdi->wb_list) ||
+			    !bdi_has_dirty_io(bdi))
+				continue;
+
+			bdi_add_default_flusher_task(bdi);
+		}
+
+		if (list_empty(&bdi_pending_list)) {
+			unsigned long wait;
+
+			mutex_unlock(&bdi_lock);
+			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
+			schedule_timeout(wait);
+			continue;
+		}
+
 		/*
 		 * This is our real job - check for pending entries in
 		 * bdi_pending_list, and create the tasks that got added
 		 */
-repeat:
-		bdi = NULL;
-		spin_lock_bh(&bdi_lock);
-		if (!list_empty(&bdi_pending_list)) {
-			bdi = list_entry(bdi_pending_list.next,
+		bdi = list_entry(bdi_pending_list.next,
 					 struct backing_dev_info, bdi_list);
-			list_del_init(&bdi->bdi_list);
-		}
-		spin_unlock_bh(&bdi_lock);
+		list_del_init(&bdi->bdi_list);
+		mutex_unlock(&bdi_lock);
 
 		if (!bdi)
 			continue;
@@ -475,12 +490,11 @@ readd_flush:
 			 * a chance to flush other bdi's to free
 			 * memory.
 			 */
-			spin_lock_bh(&bdi_lock);
+			mutex_lock(&bdi_lock);
 			list_add_tail(&bdi->bdi_list, &bdi_pending_list);
-			spin_unlock_bh(&bdi_lock);
+			mutex_unlock(&bdi_lock);
 
 			bdi_flush_io(bdi);
-			goto repeat;
 		}
 	}
 
@@ -489,25 +503,8 @@ readd_flush:
 }
 
 /*
- * Grace period has now ended, init bdi->bdi_list and add us to the
- * list of bdi's that are pending for task creation. Wake up
- * bdi_forker_task() to finish the job and add us back to the
- * active bdi_list.
+ * bdi_lock held on entry
  */
-static void bdi_add_to_pending(struct rcu_head *head)
-{
-	struct backing_dev_info *bdi;
-
-	bdi = container_of(head, struct backing_dev_info, rcu_head);
-	INIT_LIST_HEAD(&bdi->bdi_list);
-
-	spin_lock(&bdi_lock);
-	list_add_tail(&bdi->bdi_list, &bdi_pending_list);
-	spin_unlock(&bdi_lock);
-
-	wake_up(&default_backing_dev_info.wb.wait);
-}
-
 static void bdi_add_one_flusher_task(struct backing_dev_info *bdi,
 				     int(*func)(struct backing_dev_info *))
 {
@@ -526,24 +523,22 @@ static void bdi_add_one_flusher_task(struct backing_dev_info *bdi,
 	 * waiting for previous additions to finish.
 	 */
 	if (!func(bdi)) {
-		spin_lock_bh(&bdi_lock);
-		list_del_rcu(&bdi->bdi_list);
-		spin_unlock_bh(&bdi_lock);
+		list_move_tail(&bdi->bdi_list, &bdi_pending_list);
 
 		/*
-		 * We need to wait for the current grace period to end,
-		 * in case others were browsing the bdi_list as well.
-		 * So defer the adding and wakeup to after the RCU
-		 * grace period has ended.
+		 * We are now on the pending list, wake up bdi_forker_task()
+		 * to finish the job and add us abck to the active bdi_list
 		 */
-		call_rcu(&bdi->rcu_head, bdi_add_to_pending);
+		wake_up(&default_backing_dev_info.wb.wait);
 	}
 }
 
 static int flusher_add_helper_block(struct backing_dev_info *bdi)
 {
+	mutex_unlock(&bdi_lock);
 	wait_on_bit_lock(&bdi->state, BDI_pending, bdi_sched_wait,
 				TASK_UNINTERRUPTIBLE);
+	mutex_lock(&bdi_lock);
 	return 0;
 }
 
@@ -571,7 +566,9 @@ void bdi_add_default_flusher_task(struct backing_dev_info *bdi)
  */
 void bdi_add_flusher_task(struct backing_dev_info *bdi)
 {
+	mutex_lock(&bdi_lock);
 	bdi_add_one_flusher_task(bdi, flusher_add_helper_block);
+	mutex_unlock(&bdi_lock);
 }
 EXPORT_SYMBOL(bdi_add_flusher_task);
 
@@ -593,6 +590,14 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		goto exit;
 	}
 
+	mutex_lock(&bdi_lock);
+	list_add_tail(&bdi->bdi_list, &bdi_list);
+	mutex_unlock(&bdi_lock);
+
+	bdi->dev = dev;
+	bdi_debug_register(bdi, dev_name(dev));
+	set_bit(BDI_registered, &bdi->state);
+
 	/*
 	 * Just start the forker thread for our default backing_dev_info,
 	 * and add other bdi's to the list. They will get a thread created
@@ -616,14 +621,6 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		}
 	}
 
-	spin_lock_bh(&bdi_lock);
-	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
-	spin_unlock_bh(&bdi_lock);
-
-	bdi->dev = dev;
-	bdi_debug_register(bdi, dev_name(dev));
-	set_bit(BDI_registered, &bdi->state);
-
 exit:
 	return ret;
 }
@@ -655,15 +652,9 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	/*
 	 * Make sure nobody finds us on the bdi_list anymore
 	 */
-	spin_lock_bh(&bdi_lock);
-	list_del_rcu(&bdi->bdi_list);
-	spin_unlock_bh(&bdi_lock);
-
-	/*
-	 * Now make sure that anybody who is currently looking at us from
-	 * the bdi_list iteration have exited.
-	 */
-	synchronize_rcu();
+	mutex_lock(&bdi_lock);
+	list_del(&bdi->bdi_list);
+	mutex_unlock(&bdi_lock);
 
 	/*
 	 * Finally, kill the kernel threads. We don't need to be RCU
@@ -689,7 +680,6 @@ int bdi_init(struct backing_dev_info *bdi)
 {
 	int i, err;
 
-	INIT_RCU_HEAD(&bdi->rcu_head);
 	bdi->dev = NULL;
 
 	bdi->min_ratio = 0;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index de3178a..7dd7de7 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -313,9 +313,8 @@ static unsigned int bdi_min_ratio;
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 {
 	int ret = 0;
-	unsigned long flags;
 
-	spin_lock_irqsave(&bdi_lock, flags);
+	mutex_lock(&bdi_lock);
 	if (min_ratio > bdi->max_ratio) {
 		ret = -EINVAL;
 	} else {
@@ -327,27 +326,26 @@ int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
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
@@ -581,7 +579,7 @@ static void balance_dirty_pages(struct address_space *mapping)
 			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
 					  + global_page_state(NR_UNSTABLE_NFS)
 					  > background_thresh)))
-		bdi_start_writeback(bdi, NULL, 0);
+		bdi_start_writeback(bdi, NULL, 0, WB_SYNC_NONE);
 }
 
 void set_page_dirty_balance(struct page *page, int page_mkwrite)
@@ -674,7 +672,7 @@ void wakeup_flusher_threads(long nr_pages)
 	if (nr_pages == 0)
 		nr_pages = global_page_state(NR_FILE_DIRTY) +
 				global_page_state(NR_UNSTABLE_NFS);
-	bdi_writeback_all(NULL, nr_pages);
+	bdi_writeback_all(NULL, nr_pages, WB_SYNC_NONE);
 }
 
 static void laptop_timer_fn(unsigned long unused);

-- 
Jens Axboe


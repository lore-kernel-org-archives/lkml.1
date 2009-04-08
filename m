Return-Path: <linux-kernel-owner+w=401wt.eu-S933746AbZDHMIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746AbZDHMIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764616AbZDHMAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:00:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48923 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386AbZDHMAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:00:22 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 06/13] writeback: support > 1 flusher thread per bdi
Date: Wed,  8 Apr 2009 14:00:09 +0200
Message-Id: <1239192016-19857-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.2.446.gfbdc0
In-Reply-To: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
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
 fs/fs-writeback.c           |   47 ++++++++++-
 include/linux/backing-dev.h |   15 ++++
 include/linux/fs.h          |    3 +
 mm/backing-dev.c            |  185 +++++++++++++++++++++++++++++++++++--------
 4 files changed, 211 insertions(+), 39 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2ec8569..756714f 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -98,16 +98,30 @@ static void wb_start_writeback(struct bdi_writeback *wb, struct super_block *sb,
 int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 			 long nr_pages)
 {
+	struct bdi_writeback *wb;
+
 	/*
 	 * This only happens the first time someone kicks this bdi, so put
 	 * it out-of-line.
 	 */
-	if (unlikely(!bdi->wb.task)) {
+	if (unlikely(list_empty_careful(&bdi->wb_list))) {
 		bdi_add_default_flusher_task(bdi);
 		return 1;
 	}
 
-	wb_start_writeback(&bdi->wb, sb, nr_pages);
+	if (!bdi_wblist_needs_lock(bdi))
+		wb_start_writeback(&bdi->wb, sb, nr_pages);
+	else {
+		int idx;
+
+		idx = srcu_read_lock(&bdi->srcu);
+
+		list_for_each_entry_rcu(wb, &bdi->wb_list, list)
+			wb_start_writeback(wb, sb, nr_pages);
+
+		srcu_read_unlock(&bdi->srcu, idx);
+	}
+
 	return 0;
 }
 
@@ -261,11 +275,18 @@ restart:
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
@@ -719,8 +740,24 @@ void generic_sync_bdi_inodes(struct super_block *sb,
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
index a0c70f1..c596bf6 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -13,6 +13,7 @@
 #include <linux/proportions.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
+#include <linux/srcu.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -25,6 +26,7 @@ struct dentry;
 enum bdi_state {
 	BDI_pending,		/* On its way to being activated */
 	BDI_wb_alloc,		/* Default embedded wb allocated */
+	BDI_wblist_lock,	/* bdi->wb_list now needs locking */
 	BDI_async_congested,	/* The async (write) queue is getting full */
 	BDI_sync_congested,	/* The sync queue is getting full */
 	BDI_unused,		/* Available bits start here */
@@ -41,6 +43,8 @@ enum bdi_stat_item {
 #define BDI_STAT_BATCH (8*(1+ilog2(nr_cpu_ids)))
 
 struct bdi_writeback {
+	struct list_head list;			/* hangs off the bdi */
+
 	struct backing_dev_info *bdi;		/* our parent bdi */
 	unsigned int nr;
 
@@ -54,8 +58,11 @@ struct bdi_writeback {
 	struct super_block	*sb;
 };
 
+#define BDI_MAX_FLUSHERS	32
+
 struct backing_dev_info {
 	struct rcu_head rcu_head;
+	struct srcu_struct srcu; /* for wb_list read side protection */
 	struct list_head bdi_list;
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
 	unsigned long state;	/* Always use atomic bitops on this */
@@ -74,6 +81,8 @@ struct backing_dev_info {
 	unsigned int max_ratio, max_prop_frac;
 
 	struct bdi_writeback wb;  /* default writeback info for this bdi */
+	spinlock_t wb_lock;	  /* protects update side of wb_list */
+	struct list_head wb_list; /* the flusher threads hanging off this bdi */
 	unsigned long wb_active;  /* bitmap of active tasks */
 	unsigned long wb_mask;	  /* number of registered tasks */
 
@@ -97,11 +106,17 @@ int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 int bdi_writeback_task(struct bdi_writeback *wb);
 void bdi_writeback_all(struct super_block *sb, long nr_pages);
 void bdi_add_default_flusher_task(struct backing_dev_info *bdi);
+void bdi_add_flusher_task(struct backing_dev_info *bdi);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
 
+static inline int bdi_wblist_needs_lock(struct backing_dev_info *bdi)
+{
+	return test_bit(BDI_wblist_lock, &bdi->state);
+}
+
 static inline int wb_has_dirty_io(struct bdi_writeback *wb)
 {
 	return !list_empty(&wb->b_dirty) ||
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 99a9986..9e25cbb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1477,11 +1477,14 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
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
index 677a8c6..4ebcc49 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -225,24 +225,48 @@ static void bdi_flush_io(struct backing_dev_info *bdi)
 
 static int wb_assign_nr(struct backing_dev_info *bdi, struct bdi_writeback *wb)
 {
-	set_bit(0, &bdi->wb_mask);
-	wb->nr = 0;
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
 	return 0;
 }
 
 static void bdi_put_wb(struct backing_dev_info *bdi, struct bdi_writeback *wb)
 {
 	clear_bit(wb->nr, &bdi->wb_mask);
-	clear_bit(BDI_wb_alloc, &bdi->state);
+
+	if (wb == &bdi->wb)
+		clear_bit(BDI_wb_alloc, &bdi->state);
+	else
+		kfree(wb);
 }
 
 static struct bdi_writeback *bdi_new_wb(struct backing_dev_info *bdi)
 {
 	struct bdi_writeback *wb;
 
-	set_bit(BDI_wb_alloc, &bdi->state);
-	wb = &bdi->wb;
-	wb_assign_nr(bdi, wb);
+	if (!test_and_set_bit(BDI_wb_alloc, &bdi->state)) {
+		wb = &bdi->wb;
+		wb_assign_nr(bdi, wb);
+	} else {
+		wb = kmalloc(sizeof(struct bdi_writeback), GFP_KERNEL);
+		if (wb) {
+			bdi_wb_init(wb, bdi);
+			if (wb_assign_nr(bdi, wb)) {
+				kfree(wb);
+				wb = NULL;
+			}
+		}
+	}
+
 	return wb;
 }
 
@@ -251,7 +275,22 @@ static int bdi_start_fn(void *ptr)
 	struct bdi_writeback *wb = ptr;
 	struct backing_dev_info *bdi = wb->bdi;
 	struct task_struct *tsk = current;
-	int ret;
+	int was_empty, ret;
+
+	/*
+	 * Add us to the active bdi_list. If we are adding threads beyond
+	 * the default embedded bdi_writeback, then we need to start using
+	 * proper locking. Check the list for empty first, then set the
+	 * BDI_wblist_lock flag if there's > 1 entry on the list now
+	 */
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
@@ -269,13 +308,44 @@ static int bdi_start_fn(void *ptr)
 
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
@@ -367,33 +437,73 @@ static void bdi_add_to_pending(struct rcu_head *head)
 	wake_up(&default_backing_dev_info.wb.wait);
 }
 
-/*
- * Add a new flusher task that gets created for any bdi
- * that has dirty data pending writeout
- */
-void bdi_add_default_flusher_task(struct backing_dev_info *bdi)
+static int sched_wait(void *word)
+{
+	schedule();
+	return 0;
+}
+
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
+		spin_lock_bh(&bdi_lock);
+		list_del_rcu(&bdi->bdi_list);
+		spin_unlock_bh(&bdi_lock);
 
-	spin_lock_bh(&bdi_lock);
-	list_del_rcu(&bdi->bdi_list);
-	spin_unlock_bh(&bdi_lock);
+		/*
+		 * We need to wait for the current grace period to end,
+		 * in case others were browsing the bdi_list as well.
+		 * So defer the adding and wakeup to after the RCU
+		 * grace period has ended.
+		 */
+		call_rcu(&bdi->rcu_head, bdi_add_to_pending);
+	}
+}
 
-	/*
-	 * We need to wait for the current grace period to end,
-	 * in case others were browsing the bdi_list as well.
-	 * So defer the adding and wakeup to after the RCU
-	 * grace period has ended.
-	 */
-	call_rcu(&bdi->rcu_head, bdi_add_to_pending);
+static int flusher_add_helper_block(struct backing_dev_info *bdi)
+{
+	wait_on_bit_lock(&bdi->state, BDI_pending, sched_wait,
+				TASK_UNINTERRUPTIBLE);
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
+
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
+	bdi_add_one_flusher_task(bdi, flusher_add_helper_block);
 }
+EXPORT_SYMBOL(bdi_add_flusher_task);
 
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...)
@@ -454,17 +564,13 @@ int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev)
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
 
@@ -488,9 +594,11 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	synchronize_rcu();
 
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
@@ -515,7 +623,9 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
+	spin_lock_init(&bdi->wb_lock);
 	INIT_LIST_HEAD(&bdi->bdi_list);
+	INIT_LIST_HEAD(&bdi->wb_list);
 	bdi->wb_mask = bdi->wb_active = 0;
 
 	bdi_wb_init(&bdi->wb, bdi);
@@ -526,10 +636,15 @@ int bdi_init(struct backing_dev_info *bdi)
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
@@ -547,6 +662,8 @@ void bdi_destroy(struct backing_dev_info *bdi)
 
 	bdi_unregister(bdi);
 
+	cleanup_srcu_struct(&bdi->srcu);
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
 		percpu_counter_destroy(&bdi->bdi_stat[i]);
 
-- 
1.6.2.2.446.gfbdc0


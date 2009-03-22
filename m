Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZCVT3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZCVT3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZCVT0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:26:40 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52608 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbZCVT0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:26:11 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de,
       hch@infradead.org, akpm@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 08/12] writeback: support > 1 flusher thread per bdi
Date: Sun, 22 Mar 2009 20:26:00 +0100
Message-Id: <1237749964-8343-9-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.12.g83676
In-Reply-To: <1237749964-8343-1-git-send-email-jens.axboe@oracle.com>
References: <1237749964-8343-1-git-send-email-jens.axboe@oracle.com>
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
 fs/fs-writeback.c           |   47 ++++++++++++++++++--
 include/linux/backing-dev.h |   14 ++++++
 include/linux/fs.h          |    3 +
 mm/backing-dev.c            |  102 ++++++++++++++++++++++++++++++++++++++----
 4 files changed, 151 insertions(+), 15 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 34ee130..741e127 100644
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
+	if (unlikely(list_empty(&bdi->wb_list))) {
 		bdi_add_flusher_task(bdi);
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
 
@@ -259,11 +273,18 @@ restart:
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
@@ -698,8 +719,24 @@ void generic_sync_bdi_inodes(struct super_block *sb,
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
index e316349..279bc3f 100644
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
 	BDI_write_congested,	/* The write queue is getting full */
 	BDI_read_congested,	/* The read queue is getting full */
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
 
@@ -102,6 +111,11 @@ int bdi_has_dirty_io(struct backing_dev_info *bdi);
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
index 7d44bda..eb8fbd6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1376,11 +1376,14 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
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
index c0cfea0..21406f2 100644
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
@@ -466,6 +536,8 @@ static int sched_wait(void *word)
  */
 static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 {
+	struct bdi_writeback *wb;
+
 	if (!bdi_cap_writeback_dirty(bdi))
 		return;
 
@@ -483,9 +555,10 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	spin_unlock_bh(&bdi_lock);
 
 	/*
-	 * Tells flusher task to exit
+	 * Tells flusher tasks to exit
 	 */
-	kthread_stop(bdi->wb.task);
+	list_for_each_entry_rcu(wb, &bdi->wb_list, list)
+		kthread_stop(wb->task);
 
 	/*
 	 * In case the bdi is freed right after unregister, we need to
@@ -516,7 +589,9 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
+	spin_lock_init(&bdi->wb_lock);
 	INIT_LIST_HEAD(&bdi->bdi_list);
+	INIT_LIST_HEAD(&bdi->wb_list);
 	bdi->wb_mask = bdi->wb_active = 0;
 
 	bdi_wb_init(&bdi->wb, bdi);
@@ -527,10 +602,15 @@ int bdi_init(struct backing_dev_info *bdi)
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
@@ -550,6 +630,8 @@ void bdi_destroy(struct backing_dev_info *bdi)
 
 	bdi_unregister(bdi);
 
+	cleanup_srcu_struct(&bdi->srcu);
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
 		percpu_counter_destroy(&bdi->bdi_stat[i]);
 
-- 
1.6.2.12.g83676


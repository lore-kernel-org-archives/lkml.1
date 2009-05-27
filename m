Return-Path: <linux-kernel-owner+w=401wt.eu-S1761741AbZE0Jna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761741AbZE0Jna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761137AbZE0JmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:42:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41910 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759191AbZE0Jly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:41:54 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 04/11] writeback: switch to per-bdi threads for flushing data
Date: Wed, 27 May 2009 11:41:45 +0200
Message-Id: <1243417312-7444-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gets rid of pdflush for bdi writeout and kupdated style cleaning.
This is an experiment to see if we get better writeout behaviour with
per-bdi flushing. Some initial tests look pretty encouraging. A sample
ffsb workload that does random writes to files is about 8% faster here
on a simple SATA drive during the benchmark phase. File layout also seems
a LOT more smooth in vmstat:

 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 0  1      0 608848   2652 375372    0    0     0 71024  604    24  1 10 48 42
 0  1      0 549644   2712 433736    0    0     0 60692  505    27  1  8 48 44
 1  0      0 476928   2784 505192    0    0     4 29540  553    24  0  9 53 37
 0  1      0 457972   2808 524008    0    0     0 54876  331    16  0  4 38 58
 0  1      0 366128   2928 614284    0    0     4 92168  710    58  0 13 53 34
 0  1      0 295092   3000 684140    0    0     0 62924  572    23  0  9 53 37
 0  1      0 236592   3064 741704    0    0     4 58256  523    17  0  8 48 44
 0  1      0 165608   3132 811464    0    0     0 57460  560    21  0  8 54 38
 0  1      0 102952   3200 873164    0    0     4 74748  540    29  1 10 48 41
 0  1      0  48604   3252 926472    0    0     0 53248  469    29  0  7 47 45

where vanilla tends to fluctuate a lot in the creation phase:

 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 1  1      0 678716   5792 303380    0    0     0 74064  565    50  1 11 52 36
 1  0      0 662488   5864 319396    0    0     4   352  302   329  0  2 47 51
 0  1      0 599312   5924 381468    0    0     0 78164  516    55  0  9 51 40
 0  1      0 519952   6008 459516    0    0     4 78156  622    56  1 11 52 37
 1  1      0 436640   6092 541632    0    0     0 82244  622    54  0 11 48 41
 0  1      0 436640   6092 541660    0    0     0     8  152    39  0  0 51 49
 0  1      0 332224   6200 644252    0    0     4 102800  728    46  1 13 49 36
 1  0      0 274492   6260 701056    0    0     4 12328  459    49  0  7 50 43
 0  1      0 211220   6324 763356    0    0     0 106940  515    37  1 10 51 39
 1  0      0 160412   6376 813468    0    0     0  8224  415    43  0  6 49 45
 1  1      0  85980   6452 886556    0    0     4 113516  575    39  1 11 54 34
 0  2      0  85968   6452 886620    0    0     0  1640  158   211  0  0 46 54

So apart from seemingly behaving better for buffered writeout, this also
allows us to potentially have more than one bdi thread flushing out data.
This may be useful for NUMA type setups.

A 10 disk test with btrfs performs 26% faster with per-bdi flushing. Other
tests pending.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/buffer.c                 |    2 +-
 fs/fs-writeback.c           |  313 ++++++++++++++++++++++++++-----------------
 fs/sync.c                   |    2 +-
 include/linux/backing-dev.h |   29 ++++
 include/linux/fs.h          |    3 +-
 include/linux/writeback.h   |    2 +-
 mm/backing-dev.c            |  189 +++++++++++++++++++++++++-
 mm/page-writeback.c         |  140 +------------------
 mm/vmscan.c                 |    2 +-
 9 files changed, 415 insertions(+), 267 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index aed2977..14f0802 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -281,7 +281,7 @@ static void free_more_memory(void)
 	struct zone *zone;
 	int nid;
 
-	wakeup_pdflush(1024);
+	wakeup_flusher_threads(1024);
 	yield();
 
 	for_each_online_node(nid) {
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1137408..5d99b12 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -19,6 +19,8 @@
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
@@ -61,10 +63,190 @@ int writeback_in_progress(struct backing_dev_info *bdi)
  */
 static void writeback_release(struct backing_dev_info *bdi)
 {
-	BUG_ON(!writeback_in_progress(bdi));
+	WARN_ON_ONCE(!writeback_in_progress(bdi));
+	bdi->wb_arg.nr_pages = 0;
+	bdi->wb_arg.sb = NULL;
 	clear_bit(BDI_pdflush, &bdi->state);
 }
 
+int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
+			 long nr_pages, enum writeback_sync_modes sync_mode)
+{
+	/*
+	 * This only happens the first time someone kicks this bdi, so put
+	 * it out-of-line.
+	 */
+	if (unlikely(!bdi->task)) {
+		bdi_add_default_flusher_task(bdi);
+		return 1;
+	}
+
+	if (writeback_acquire(bdi)) {
+		bdi->wb_arg.nr_pages = nr_pages;
+		bdi->wb_arg.sb = sb;
+		bdi->wb_arg.sync_mode = sync_mode;
+		/*
+		 * make above store seen before the task is woken
+		 */
+		smp_mb();
+		wake_up(&bdi->wait);
+	}
+
+	return 0;
+}
+
+/*
+ * The maximum number of pages to writeout in a single bdi flush/kupdate
+ * operation.  We do this so we don't hold I_SYNC against an inode for
+ * enormous amounts of time, which would block a userspace task which has
+ * been forced to throttle against that inode.  Also, the code reevaluates
+ * the dirty each time it has written this many pages.
+ */
+#define MAX_WRITEBACK_PAGES     1024
+
+/*
+ * Periodic writeback of "old" data.
+ *
+ * Define "old": the first time one of an inode's pages is dirtied, we mark the
+ * dirtying-time in the inode's address_space.  So this periodic writeback code
+ * just walks the superblock inode list, writing back any inodes which are
+ * older than a specific point in time.
+ *
+ * Try to run once per dirty_writeback_interval.  But if a writeback event
+ * takes longer than a dirty_writeback_interval interval, then leave a
+ * one-second gap.
+ *
+ * older_than_this takes precedence over nr_to_write.  So we'll only write back
+ * all dirty pages if they are all attached to "old" mappings.
+ */
+static void bdi_kupdated(struct backing_dev_info *bdi)
+{
+	unsigned long oldest_jif;
+	long nr_to_write;
+	struct writeback_control wbc = {
+		.bdi			= bdi,
+		.sync_mode		= WB_SYNC_NONE,
+		.older_than_this	= &oldest_jif,
+		.nr_to_write		= 0,
+		.for_kupdate		= 1,
+		.range_cyclic		= 1,
+	};
+
+	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval * 10);
+
+	nr_to_write = global_page_state(NR_FILE_DIRTY) +
+			global_page_state(NR_UNSTABLE_NFS) +
+			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+
+	while (nr_to_write > 0) {
+		wbc.more_io = 0;
+		wbc.encountered_congestion = 0;
+		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
+		generic_sync_bdi_inodes(NULL, &wbc);
+		if (wbc.nr_to_write > 0)
+			break;	/* All the old data is written */
+		nr_to_write -= MAX_WRITEBACK_PAGES;
+	}
+}
+
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
+static void bdi_pdflush(struct backing_dev_info *bdi)
+{
+	struct writeback_control wbc = {
+		.bdi			= bdi,
+		.sync_mode		= bdi->wb_arg.sync_mode,
+		.older_than_this	= NULL,
+		.range_cyclic		= 1,
+	};
+	long nr_pages = bdi->wb_arg.nr_pages;
+
+	for (;;) {
+		if (wbc.sync_mode == WB_SYNC_NONE && nr_pages <= 0 &&
+		    !over_bground_thresh())
+			break;
+
+		wbc.more_io = 0;
+		wbc.encountered_congestion = 0;
+		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
+		wbc.pages_skipped = 0;
+		generic_sync_bdi_inodes(bdi->wb_arg.sb, &wbc);
+		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		/*
+		 * If we ran out of stuff to write, bail unless more_io got set
+		 */
+		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
+			if (wbc.more_io)
+				continue;
+			break;
+		}
+	}
+}
+
+/*
+ * Handle writeback of dirty data for the device backed by this bdi. Also
+ * wakes up periodically and does kupdated style flushing.
+ */
+int bdi_writeback_task(struct backing_dev_info *bdi)
+{
+	while (!kthread_should_stop()) {
+		unsigned long wait_jiffies;
+		DEFINE_WAIT(wait);
+
+		prepare_to_wait(&bdi->wait, &wait, TASK_INTERRUPTIBLE);
+		wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
+		schedule_timeout(wait_jiffies);
+		try_to_freeze();
+
+		/*
+		 * We get here in two cases:
+		 *
+		 *  schedule_timeout() returned because the dirty writeback
+		 *  interval has elapsed. If that happens, we will be able
+		 *  to acquire the writeback lock and will proceed to do
+		 *  kupdated style writeout.
+		 *
+		 *  Someone called bdi_start_writeback(), which will acquire
+		 *  the writeback lock. This means our writeback_acquire()
+		 *  below will fail and we call into bdi_pdflush() for
+		 *  pdflush style writeout.
+		 *
+		 */
+		if (writeback_acquire(bdi))
+			bdi_kupdated(bdi);
+		else
+			bdi_pdflush(bdi);
+
+		writeback_release(bdi);
+		finish_wait(&bdi->wait, &wait);
+	}
+
+	return 0;
+}
+
+void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc)
+{
+	struct backing_dev_info *bdi, *tmp;
+
+	mutex_lock(&bdi_lock);
+
+	list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
+		if (!bdi_has_dirty_io(bdi))
+			continue;
+		bdi_start_writeback(bdi, sb, wbc->nr_to_write, wbc->sync_mode);
+	}
+
+	mutex_unlock(&bdi_lock);
+}
+
 /**
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
@@ -263,46 +445,6 @@ static void queue_io(struct backing_dev_info *bdi,
 	move_expired_inodes(&bdi->b_dirty, &bdi->b_io, older_than_this);
 }
 
-static int sb_on_inode_list(struct super_block *sb, struct list_head *list)
-{
-	struct inode *inode;
-	int ret = 0;
-
-	spin_lock(&inode_lock);
-	list_for_each_entry(inode, list, i_list) {
-		if (inode->i_sb == sb) {
-			ret = 1;
-			break;
-		}
-	}
-	spin_unlock(&inode_lock);
-	return ret;
-}
-
-int sb_has_dirty_inodes(struct super_block *sb)
-{
-	struct backing_dev_info *bdi;
-	int ret = 0;
-
-	/*
-	 * This is REALLY expensive right now, but it'll go away
-	 * when the bdi writeback is introduced
-	 */
-	mutex_lock(&bdi_lock);
-	list_for_each_entry(bdi, &bdi_list, bdi_list) {
-		if (sb_on_inode_list(sb, &bdi->b_dirty) ||
-		    sb_on_inode_list(sb, &bdi->b_io) ||
-		    sb_on_inode_list(sb, &bdi->b_more_io)) {
-			ret = 1;
-			break;
-		}
-	}
-	mutex_unlock(&bdi_lock);
-
-	return ret;
-}
-EXPORT_SYMBOL(sb_has_dirty_inodes);
-
 /*
  * Write a single inode's dirty pages and inode data out to disk.
  * If `wait' is set, wait on the writeout.
@@ -461,11 +603,11 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	return __sync_single_inode(inode, wbc);
 }
 
-static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
-				    struct writeback_control *wbc,
-				    struct super_block *sb,
-				    int is_blkdev_sb)
+void generic_sync_bdi_inodes(struct super_block *sb,
+			     struct writeback_control *wbc)
 {
+	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
+	struct backing_dev_info *bdi = wbc->bdi;
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
 	spin_lock(&inode_lock);
@@ -516,13 +658,6 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
 			continue;		/* Skip a congested blockdev */
 		}
 
-		if (wbc->bdi && bdi != wbc->bdi) {
-			if (!is_blkdev_sb)
-				break;		/* fs has the wrong queue */
-			requeue_io(inode);
-			continue;		/* blockdev has wrong queue */
-		}
-
 		/*
 		 * Was this inode dirtied after sync_sb_inodes was called?
 		 * This keeps sync from extra jobs and livelock.
@@ -530,16 +665,10 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
 		if (inode_dirtied_after(inode, start))
 			break;
 
-		/* Is another pdflush already flushing this queue? */
-		if (current_is_pdflush() && !writeback_acquire(bdi))
-			break;
-
 		BUG_ON(inode->i_state & I_FREEING);
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
 		__writeback_single_inode(inode, wbc);
-		if (current_is_pdflush())
-			writeback_release(bdi);
 		if (wbc->pages_skipped != pages_skipped) {
 			/*
 			 * writeback is not making progress due to locked
@@ -578,11 +707,6 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
  * a variety of queues, so all inodes are searched.  For other superblocks,
  * assume that all inodes are backed by the same queue.
  *
- * FIXME: this linear search could get expensive with many fileystems.  But
- * how to fix?  We need to go from an address_space to all inodes which share
- * a queue with that address_space.  (Easy: have a global "dirty superblocks"
- * list).
- *
  * The inodes to be written are parked on bdi->b_io.  They are moved back onto
  * bdi->b_dirty as they are selected for writing.  This way, none can be missed
  * on the writer throttling path, and we get decent balancing between many
@@ -591,13 +715,10 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
 void generic_sync_sb_inodes(struct super_block *sb,
 				struct writeback_control *wbc)
 {
-	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
-	struct backing_dev_info *bdi;
-
-	mutex_lock(&bdi_lock);
-	list_for_each_entry(bdi, &bdi_list, bdi_list)
-		generic_sync_bdi_inodes(bdi, wbc, sb, is_blkdev_sb);
-	mutex_unlock(&bdi_lock);
+	if (wbc->bdi)
+		generic_sync_bdi_inodes(sb, wbc);
+	else
+		bdi_writeback_all(sb, wbc);
 
 	if (wbc->sync_mode == WB_SYNC_ALL) {
 		struct inode *inode, *old_inode = NULL;
@@ -653,58 +774,6 @@ static void sync_sb_inodes(struct super_block *sb,
 }
 
 /*
- * Start writeback of dirty pagecache data against all unlocked inodes.
- *
- * Note:
- * We don't need to grab a reference to superblock here. If it has non-empty
- * ->b_dirty it's hadn't been killed yet and kill_super() won't proceed
- * past sync_inodes_sb() until the ->b_dirty/b_io/b_more_io lists are all
- * empty. Since __sync_single_inode() regains inode_lock before it finally moves
- * inode from superblock lists we are OK.
- *
- * If `older_than_this' is non-zero then only flush inodes which have a
- * flushtime older than *older_than_this.
- *
- * If `bdi' is non-zero then we will scan the first inode against each
- * superblock until we find the matching ones.  One group will be the dirty
- * inodes against a filesystem.  Then when we hit the dummy blockdev superblock,
- * sync_sb_inodes will seekout the blockdev which matches `bdi'.  Maybe not
- * super-efficient but we're about to do a ton of I/O...
- */
-void
-writeback_inodes(struct writeback_control *wbc)
-{
-	struct super_block *sb;
-
-	might_sleep();
-	spin_lock(&sb_lock);
-restart:
-	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
-		if (sb_has_dirty_inodes(sb)) {
-			/* we're making our own get_super here */
-			sb->s_count++;
-			spin_unlock(&sb_lock);
-			/*
-			 * If we can't get the readlock, there's no sense in
-			 * waiting around, most of the time the FS is going to
-			 * be unmounted by the time it is released.
-			 */
-			if (down_read_trylock(&sb->s_umount)) {
-				if (sb->s_root)
-					sync_sb_inodes(sb, wbc);
-				up_read(&sb->s_umount);
-			}
-			spin_lock(&sb_lock);
-			if (__put_super_and_need_restart(sb))
-				goto restart;
-		}
-		if (wbc->nr_to_write <= 0)
-			break;
-	}
-	spin_unlock(&sb_lock);
-}
-
-/*
  * writeback and wait upon the filesystem's dirty inodes.  The caller will
  * do this in two passes - one to write, and one to wait.
  *
diff --git a/fs/sync.c b/fs/sync.c
index 7abc65f..3887f10 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -23,7 +23,7 @@
  */
 static void do_sync(unsigned long wait)
 {
-	wakeup_pdflush(0);
+	wakeup_flusher_threads(0);
 	sync_inodes(0);		/* All mappings, inodes and their blockdevs */
 	vfs_dq_sync(NULL);
 	sync_supers();		/* Write the superblocks */
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 8719c87..9f040a9 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -13,6 +13,7 @@
 #include <linux/proportions.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
+#include <linux/writeback.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -24,6 +25,7 @@ struct dentry;
  */
 enum bdi_state {
 	BDI_pdflush,		/* A pdflush thread is working this device */
+	BDI_pending,		/* On its way to being activated */
 	BDI_async_congested,	/* The async (write) queue is getting full */
 	BDI_sync_congested,	/* The sync queue is getting full */
 	BDI_unused,		/* Available bits start here */
@@ -39,6 +41,12 @@ enum bdi_stat_item {
 
 #define BDI_STAT_BATCH (8*(1+ilog2(nr_cpu_ids)))
 
+struct bdi_writeback_arg {
+	unsigned long nr_pages;
+	struct super_block *sb;
+	enum writeback_sync_modes sync_mode;
+};
+
 struct backing_dev_info {
 	struct list_head bdi_list;
 
@@ -60,6 +68,9 @@ struct backing_dev_info {
 
 	struct device *dev;
 
+	struct task_struct	*task;		/* writeback task */
+	wait_queue_head_t	wait;
+	struct bdi_writeback_arg wb_arg;	/* protected by BDI_pdflush */
 	struct list_head	b_dirty;	/* dirty inodes */
 	struct list_head	b_io;		/* parked for writeback */
 	struct list_head	b_more_io;	/* parked for more writeback */
@@ -77,10 +88,22 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...);
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
+int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
+			 long nr_pages, enum writeback_sync_modes sync_mode);
+int bdi_writeback_task(struct backing_dev_info *bdi);
+void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc);
+void bdi_add_default_flusher_task(struct backing_dev_info *bdi);
 
 extern struct mutex bdi_lock;
 extern struct list_head bdi_list;
 
+static inline int bdi_has_dirty_io(struct backing_dev_info *bdi)
+{
+	return !list_empty(&bdi->b_dirty) ||
+	       !list_empty(&bdi->b_io) ||
+	       !list_empty(&bdi->b_more_io);
+}
+
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item, s64 amount)
 {
@@ -196,6 +219,7 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 #define BDI_CAP_EXEC_MAP	0x00000040
 #define BDI_CAP_NO_ACCT_WB	0x00000080
 #define BDI_CAP_SWAP_BACKED	0x00000100
+#define BDI_CAP_FLUSH_FORKER	0x00000200
 
 #define BDI_CAP_VMFLAGS \
 	(BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP)
@@ -265,6 +289,11 @@ static inline bool bdi_cap_swap_backed(struct backing_dev_info *bdi)
 	return bdi->capabilities & BDI_CAP_SWAP_BACKED;
 }
 
+static inline bool bdi_cap_flush_forker(struct backing_dev_info *bdi)
+{
+	return bdi->capabilities & BDI_CAP_FLUSH_FORKER;
+}
+
 static inline bool mapping_cap_writeback_dirty(struct address_space *mapping)
 {
 	return bdi_cap_writeback_dirty(mapping->backing_dev_info);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6b475d4..ecdc544 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2063,6 +2063,8 @@ extern int invalidate_inode_pages2_range(struct address_space *mapping,
 					 pgoff_t start, pgoff_t end);
 extern void generic_sync_sb_inodes(struct super_block *sb,
 				struct writeback_control *wbc);
+extern void generic_sync_bdi_inodes(struct super_block *sb,
+				struct writeback_control *);
 extern int write_inode_now(struct inode *, int);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
@@ -2180,7 +2182,6 @@ extern int bdev_read_only(struct block_device *);
 extern int set_blocksize(struct block_device *, int);
 extern int sb_set_blocksize(struct super_block *, int);
 extern int sb_min_blocksize(struct super_block *, int);
-extern int sb_has_dirty_inodes(struct super_block *);
 
 extern int generic_file_mmap(struct file *, struct vm_area_struct *);
 extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 9344547..a8e9f78 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -99,7 +99,7 @@ static inline void inode_sync_wait(struct inode *inode)
 /*
  * mm/page-writeback.c
  */
-int wakeup_pdflush(long nr_pages);
+void wakeup_flusher_threads(long nr_pages);
 void laptop_io_completion(void);
 void laptop_sync_completion(void);
 void throttle_vm_writeout(gfp_t gfp_mask);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index de0bbfe..0df8079 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1,8 +1,11 @@
 
 #include <linux/wait.h>
 #include <linux/backing-dev.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/writeback.h>
@@ -16,7 +19,7 @@ EXPORT_SYMBOL(default_unplug_io_fn);
 struct backing_dev_info default_backing_dev_info = {
 	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
 	.state		= 0,
-	.capabilities	= BDI_CAP_MAP_COPY,
+	.capabilities	= BDI_CAP_MAP_COPY | BDI_CAP_FLUSH_FORKER,
 	.unplug_io_fn	= default_unplug_io_fn,
 };
 EXPORT_SYMBOL_GPL(default_backing_dev_info);
@@ -24,6 +27,7 @@ EXPORT_SYMBOL_GPL(default_backing_dev_info);
 static struct class *bdi_class;
 DEFINE_MUTEX(bdi_lock);
 LIST_HEAD(bdi_list);
+LIST_HEAD(bdi_pending_list);
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
@@ -195,6 +199,143 @@ static int __init default_bdi_init(void)
 }
 subsys_initcall(default_bdi_init);
 
+static int bdi_start_fn(void *ptr)
+{
+	struct backing_dev_info *bdi = ptr;
+	struct task_struct *tsk = current;
+
+	/*
+	 * Add us to the active bdi_list
+	 */
+	mutex_lock(&bdi_lock);
+	list_add(&bdi->bdi_list, &bdi_list);
+	mutex_unlock(&bdi_lock);
+
+	tsk->flags |= PF_FLUSHER | PF_SWAPWRITE;
+	set_freezable();
+
+	/*
+	 * Our parent may run at a different priority, just set us to normal
+	 */
+	set_user_nice(tsk, 0);
+
+	/*
+	 * Clear pending bit and wakeup anybody waiting to tear us down
+	 */
+	clear_bit(BDI_pending, &bdi->state);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&bdi->state, BDI_pending);
+
+	return bdi_writeback_task(bdi);
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
+static int bdi_forker_task(void *ptr)
+{
+	struct backing_dev_info *me = ptr;
+	DEFINE_WAIT(wait);
+
+	for (;;) {
+		struct backing_dev_info *bdi, *tmp;
+
+		/*
+		 * Do this periodically, like kupdated() did before.
+		 */
+		sync_supers();
+
+		/*
+		 * Temporary measure, we want to make sure we don't see
+		 * dirty data on the default backing_dev_info
+		 */
+		if (bdi_has_dirty_io(me))
+			bdi_flush_io(me);
+
+		prepare_to_wait(&me->wait, &wait, TASK_INTERRUPTIBLE);
+
+		mutex_lock(&bdi_lock);
+
+		/*
+		 * Check if any existing bdi's have dirty data without
+		 * a thread registered. If so, set that up.
+		 */
+		list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
+			if (bdi->task || !bdi_has_dirty_io(bdi))
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
+			try_to_freeze();
+			continue;
+		}
+
+		/*
+		 * This is our real job - check for pending entries in
+		 * bdi_pending_list, and create the tasks that got added
+		 */
+		bdi = list_entry(bdi_pending_list.next, struct backing_dev_info,
+				 bdi_list);
+		list_del_init(&bdi->bdi_list);
+		mutex_unlock(&bdi_lock);
+
+		BUG_ON(bdi->task);
+
+		bdi->task = kthread_run(bdi_start_fn, bdi, "bdi-%s",
+					dev_name(bdi->dev));
+		/*
+		 * If task creation fails, then readd the bdi to
+		 * the pending list and force writeout of the bdi
+		 * from this forker thread. That will free some memory
+		 * and we can try again.
+		 */
+		if (!bdi->task) {
+			/*
+			 * Add this 'bdi' to the back, so we get
+			 * a chance to flush other bdi's to free
+			 * memory.
+			 */
+			mutex_lock(&bdi_lock);
+			list_add_tail(&bdi->bdi_list, &bdi_pending_list);
+			mutex_unlock(&bdi_lock);
+
+			bdi_flush_io(bdi);
+		}
+	}
+
+	finish_wait(&me->wait, &wait);
+	return 0;
+}
+
+void bdi_add_default_flusher_task(struct backing_dev_info *bdi)
+{
+	if (test_and_set_bit(BDI_pending, &bdi->state))
+		return;
+
+	mutex_lock(&bdi_lock);
+	list_move_tail(&bdi->bdi_list, &bdi_pending_list);
+	mutex_unlock(&bdi_lock);
+
+	wake_up(&default_backing_dev_info.wait);
+}
+
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...)
 {
@@ -218,8 +359,25 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 	mutex_unlock(&bdi_lock);
 
 	bdi->dev = dev;
-	bdi_debug_register(bdi, dev_name(dev));
 
+	/*
+	 * Just start the forker thread for our default backing_dev_info,
+	 * and add other bdi's to the list. They will get a thread created
+	 * on-demand when they need it.
+	 */
+	if (bdi_cap_flush_forker(bdi)) {
+		bdi->task = kthread_run(bdi_forker_task, bdi, "bdi-%s",
+						dev_name(dev));
+		if (!bdi->task) {
+			mutex_lock(&bdi_lock);
+			list_del(&bdi->bdi_list);
+			mutex_unlock(&bdi_lock);
+			ret = -ENOMEM;
+			goto exit;
+		}
+	}
+
+	bdi_debug_register(bdi, dev_name(dev));
 exit:
 	return ret;
 }
@@ -231,8 +389,19 @@ int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev)
 }
 EXPORT_SYMBOL(bdi_register_dev);
 
-static void bdi_remove_from_list(struct backing_dev_info *bdi)
+static int sched_wait(void *word)
+{
+	schedule();
+	return 0;
+}
+
+static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 {
+	/*
+	 * If setup is pending, wait for that to complete first
+	 */
+	wait_on_bit(&bdi->state, BDI_pending, sched_wait, TASK_UNINTERRUPTIBLE);
+
 	mutex_lock(&bdi_lock);
 	list_del(&bdi->bdi_list);
 	mutex_unlock(&bdi_lock);
@@ -241,7 +410,13 @@ static void bdi_remove_from_list(struct backing_dev_info *bdi)
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
-		bdi_remove_from_list(bdi);
+		if (!bdi_cap_flush_forker(bdi)) {
+			bdi_wb_shutdown(bdi);
+			if (bdi->task) {
+				kthread_stop(bdi->task);
+				bdi->task = NULL;
+			}
+		}
 		bdi_debug_unregister(bdi);
 		device_unregister(bdi->dev);
 		bdi->dev = NULL;
@@ -251,14 +426,14 @@ EXPORT_SYMBOL(bdi_unregister);
 
 int bdi_init(struct backing_dev_info *bdi)
 {
-	int i;
-	int err;
+	int i, err;
 
 	bdi->dev = NULL;
 
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
+	init_waitqueue_head(&bdi->wait);
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->b_io);
 	INIT_LIST_HEAD(&bdi->b_dirty);
@@ -277,8 +452,6 @@ int bdi_init(struct backing_dev_info *bdi)
 err:
 		while (i--)
 			percpu_counter_destroy(&bdi->bdi_stat[i]);
-
-		bdi_remove_from_list(bdi);
 	}
 
 	return err;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7c44314..46c62b0 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -36,15 +36,6 @@
 #include <linux/pagevec.h>
 
 /*
- * The maximum number of pages to writeout in a single bdflush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
- */
-#define MAX_WRITEBACK_PAGES	1024
-
-/*
  * After a CPU has dirtied this many pages, balance_dirty_pages_ratelimited
  * will look to see if it needs to force writeback or throttling.
  */
@@ -117,8 +108,6 @@ EXPORT_SYMBOL(laptop_mode);
 /* End of sysctl-exported parameters */
 
 
-static void background_writeout(unsigned long _min_pages);
-
 /*
  * Scale the writeback cache size proportional to the relative writeout speeds.
  *
@@ -539,7 +528,7 @@ static void balance_dirty_pages(struct address_space *mapping)
 		 * been flushed to permanent storage.
 		 */
 		if (bdi_nr_reclaimable) {
-			writeback_inodes(&wbc);
+			generic_sync_bdi_inodes(NULL, &wbc);
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
 				       &bdi_thresh, bdi);
@@ -590,7 +579,7 @@ static void balance_dirty_pages(struct address_space *mapping)
 			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
 					  + global_page_state(NR_UNSTABLE_NFS)
 					  > background_thresh)))
-		pdflush_operation(background_writeout, 0);
+		bdi_start_writeback(bdi, NULL, 0, WB_SYNC_NONE);
 }
 
 void set_page_dirty_balance(struct page *page, int page_mkwrite)
@@ -675,152 +664,41 @@ void throttle_vm_writeout(gfp_t gfp_mask)
 }
 
 /*
- * writeback at least _min_pages, and keep writing until the amount of dirty
- * memory is less than the background threshold, or until we're all clean.
+ * Start writeback of `nr_pages' pages.  If `nr_pages' is zero, write back
+ * the whole world.
  */
-static void background_writeout(unsigned long _min_pages)
+void wakeup_flusher_threads(long nr_pages)
 {
-	long min_pages = _min_pages;
 	struct writeback_control wbc = {
-		.bdi		= NULL,
 		.sync_mode	= WB_SYNC_NONE,
 		.older_than_this = NULL,
-		.nr_to_write	= 0,
-		.nonblocking	= 1,
 		.range_cyclic	= 1,
 	};
 
-	for ( ; ; ) {
-		unsigned long background_thresh;
-		unsigned long dirty_thresh;
-
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
-		if (global_page_state(NR_FILE_DIRTY) +
-			global_page_state(NR_UNSTABLE_NFS) < background_thresh
-				&& min_pages <= 0)
-			break;
-		wbc.more_io = 0;
-		wbc.encountered_congestion = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
-		wbc.pages_skipped = 0;
-		writeback_inodes(&wbc);
-		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
-			/* Wrote less than expected */
-			if (wbc.encountered_congestion || wbc.more_io)
-				congestion_wait(WRITE, HZ/10);
-			else
-				break;
-		}
-	}
-}
-
-/*
- * Start writeback of `nr_pages' pages.  If `nr_pages' is zero, write back
- * the whole world.  Returns 0 if a pdflush thread was dispatched.  Returns
- * -1 if all pdflush threads were busy.
- */
-int wakeup_pdflush(long nr_pages)
-{
 	if (nr_pages == 0)
 		nr_pages = global_page_state(NR_FILE_DIRTY) +
 				global_page_state(NR_UNSTABLE_NFS);
-	return pdflush_operation(background_writeout, nr_pages);
+	wbc.nr_to_write = nr_pages;
+	bdi_writeback_all(NULL, &wbc);
 }
 
-static void wb_timer_fn(unsigned long unused);
 static void laptop_timer_fn(unsigned long unused);
 
-static DEFINE_TIMER(wb_timer, wb_timer_fn, 0, 0);
 static DEFINE_TIMER(laptop_mode_wb_timer, laptop_timer_fn, 0, 0);
 
 /*
- * Periodic writeback of "old" data.
- *
- * Define "old": the first time one of an inode's pages is dirtied, we mark the
- * dirtying-time in the inode's address_space.  So this periodic writeback code
- * just walks the superblock inode list, writing back any inodes which are
- * older than a specific point in time.
- *
- * Try to run once per dirty_writeback_interval.  But if a writeback event
- * takes longer than a dirty_writeback_interval interval, then leave a
- * one-second gap.
- *
- * older_than_this takes precedence over nr_to_write.  So we'll only write back
- * all dirty pages if they are all attached to "old" mappings.
- */
-static void wb_kupdate(unsigned long arg)
-{
-	unsigned long oldest_jif;
-	unsigned long start_jif;
-	unsigned long next_jif;
-	long nr_to_write;
-	struct writeback_control wbc = {
-		.bdi		= NULL,
-		.sync_mode	= WB_SYNC_NONE,
-		.older_than_this = &oldest_jif,
-		.nr_to_write	= 0,
-		.nonblocking	= 1,
-		.for_kupdate	= 1,
-		.range_cyclic	= 1,
-	};
-
-	sync_supers();
-
-	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval * 10);
-	start_jif = jiffies;
-	next_jif = start_jif + msecs_to_jiffies(dirty_writeback_interval * 10);
-	nr_to_write = global_page_state(NR_FILE_DIRTY) +
-			global_page_state(NR_UNSTABLE_NFS) +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
-	while (nr_to_write > 0) {
-		wbc.more_io = 0;
-		wbc.encountered_congestion = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
-		writeback_inodes(&wbc);
-		if (wbc.nr_to_write > 0) {
-			if (wbc.encountered_congestion || wbc.more_io)
-				congestion_wait(WRITE, HZ/10);
-			else
-				break;	/* All the old data is written */
-		}
-		nr_to_write -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-	}
-	if (time_before(next_jif, jiffies + HZ))
-		next_jif = jiffies + HZ;
-	if (dirty_writeback_interval)
-		mod_timer(&wb_timer, next_jif);
-}
-
-/*
  * sysctl handler for /proc/sys/vm/dirty_writeback_centisecs
  */
 int dirty_writeback_centisecs_handler(ctl_table *table, int write,
 	struct file *file, void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, file, buffer, length, ppos);
-	if (dirty_writeback_interval)
-		mod_timer(&wb_timer, jiffies +
-			msecs_to_jiffies(dirty_writeback_interval * 10));
-	else
-		del_timer(&wb_timer);
 	return 0;
 }
 
-static void wb_timer_fn(unsigned long unused)
-{
-	if (pdflush_operation(wb_kupdate, 0) < 0)
-		mod_timer(&wb_timer, jiffies + HZ); /* delay 1 second */
-}
-
-static void laptop_flush(unsigned long unused)
-{
-	sys_sync();
-}
-
 static void laptop_timer_fn(unsigned long unused)
 {
-	pdflush_operation(laptop_flush, 0);
+	wakeup_flusher_threads(0);
 }
 
 /*
@@ -903,8 +781,6 @@ void __init page_writeback_init(void)
 {
 	int shift;
 
-	mod_timer(&wb_timer,
-		  jiffies + msecs_to_jiffies(dirty_writeback_interval * 10));
 	writeback_set_ratelimit();
 	register_cpu_notifier(&ratelimit_nb);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5fa3eda..e37fd38 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1654,7 +1654,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		 */
 		if (total_scanned > sc->swap_cluster_max +
 					sc->swap_cluster_max / 2) {
-			wakeup_pdflush(laptop_mode ? 0 : total_scanned);
+			wakeup_flusher_threads(laptop_mode ? 0 : total_scanned);
 			sc->may_writepage = 1;
 		}
 
-- 
1.6.3.rc0.1.gf800


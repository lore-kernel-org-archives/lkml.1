Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbZIPN1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbZIPN1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758009AbZIPN1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:27:50 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57945 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbZIPNYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:49 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 09/16] writeback: separate starting of sync vs opportunistic writeback
Date: Wed, 16 Sep 2009 15:24:47 +0200
Message-Id: <1253107494-20160-10-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
References: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bdi_start_writeback() is currently split into two paths, one for
WB_SYNC_NONE and one for WB_SYNC_ALL. Add bdi_sync_writeback()
for WB_SYNC_ALL writeback and let bdi_start_writeback() handle
only WB_SYNC_NONE.

Push down the writeback_control allocation and only accept the
parameters that make sense for each function. This cleans up
the API considerably.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c           |  132 ++++++++++++++++++++++---------------------
 fs/ubifs/budget.c           |   20 +------
 include/linux/backing-dev.h |    2 +-
 include/linux/writeback.h   |    4 +-
 mm/page-writeback.c         |   12 +---
 5 files changed, 75 insertions(+), 95 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 59b3ee6..5887328 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -74,14 +74,10 @@ static inline bool bdi_work_on_stack(struct bdi_work *work)
 }
 
 static inline void bdi_work_init(struct bdi_work *work,
-				 struct writeback_control *wbc)
+				 struct wb_writeback_args *args)
 {
 	INIT_RCU_HEAD(&work->rcu_head);
-	work->args.sb = wbc->sb;
-	work->args.nr_pages = wbc->nr_to_write;
-	work->args.sync_mode = wbc->sync_mode;
-	work->args.range_cyclic = wbc->range_cyclic;
-	work->args.for_kupdate = 0;
+	work->args = *args;
 	work->state = WS_USED;
 }
 
@@ -194,7 +190,7 @@ static void bdi_wait_on_work_clear(struct bdi_work *work)
 }
 
 static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
-				 struct writeback_control *wbc)
+				 struct wb_writeback_args *args)
 {
 	struct bdi_work *work;
 
@@ -204,7 +200,7 @@ static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
 	 */
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	if (work) {
-		bdi_work_init(work, wbc);
+		bdi_work_init(work, args);
 		bdi_queue_work(bdi, work);
 	} else {
 		struct bdi_writeback *wb = &bdi->wb;
@@ -214,24 +210,54 @@ static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
 	}
 }
 
-void bdi_start_writeback(struct writeback_control *wbc)
+/**
+ * bdi_sync_writeback - start and wait for writeback
+ * @bdi: the backing device to write from
+ * @sb: write inodes from this super_block
+ *
+ * Description:
+ *   This does WB_SYNC_ALL data integrity writeback and waits for the
+ *   IO to complete. Callers must hold the sb s_umount semaphore for
+ *   reading, to avoid having the super disappear before we are done.
+ */
+static void bdi_sync_writeback(struct backing_dev_info *bdi,
+			       struct super_block *sb)
 {
-	/*
-	 * WB_SYNC_NONE is opportunistic writeback. If this allocation fails,
-	 * bdi_queue_work() will wake up the thread and flush old data. This
-	 * should ensure some amount of progress in freeing memory.
-	 */
-	if (wbc->sync_mode != WB_SYNC_ALL)
-		bdi_alloc_queue_work(wbc->bdi, wbc);
-	else {
-		struct bdi_work work;
+	struct wb_writeback_args args = {
+		.sb		= sb,
+		.sync_mode	= WB_SYNC_ALL,
+		.nr_pages	= LONG_MAX,
+		.range_cyclic	= 0,
+	};
+	struct bdi_work work;
 
-		bdi_work_init(&work, wbc);
-		work.state |= WS_ONSTACK;
+	bdi_work_init(&work, &args);
+	work.state |= WS_ONSTACK;
 
-		bdi_queue_work(wbc->bdi, &work);
-		bdi_wait_on_work_clear(&work);
-	}
+	bdi_queue_work(bdi, &work);
+	bdi_wait_on_work_clear(&work);
+}
+
+/**
+ * bdi_start_writeback - start writeback
+ * @bdi: the backing device to write from
+ * @nr_pages: the number of pages to write
+ *
+ * Description:
+ *   This does WB_SYNC_NONE opportunistic writeback. The IO is only
+ *   started when this function returns, we make no guarentees on
+ *   completion. Caller need not hold sb s_umount semaphore.
+ *
+ */
+void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages)
+{
+	struct wb_writeback_args args = {
+		.sync_mode	= WB_SYNC_NONE,
+		.nr_pages	= nr_pages,
+		.range_cyclic	= 1,
+	};
+
+	bdi_alloc_queue_work(bdi, &args);
 }
 
 /*
@@ -863,23 +889,25 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 }
 
 /*
- * Schedule writeback for all backing devices. Can only be used for
- * WB_SYNC_NONE writeback, WB_SYNC_ALL should use bdi_start_writeback()
- * and pass in the superblock.
+ * Schedule writeback for all backing devices. This does WB_SYNC_NONE
+ * writeback, for integrity writeback see bdi_sync_writeback().
  */
-static void bdi_writeback_all(struct writeback_control *wbc)
+static void bdi_writeback_all(struct super_block *sb, long nr_pages)
 {
+	struct wb_writeback_args args = {
+		.sb		= sb,
+		.nr_pages	= nr_pages,
+		.sync_mode	= WB_SYNC_NONE,
+	};
 	struct backing_dev_info *bdi;
 
-	WARN_ON(wbc->sync_mode == WB_SYNC_ALL);
-
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
 		if (!bdi_has_dirty_io(bdi))
 			continue;
 
-		bdi_alloc_queue_work(bdi, wbc);
+		bdi_alloc_queue_work(bdi, &args);
 	}
 
 	rcu_read_unlock();
@@ -891,17 +919,10 @@ static void bdi_writeback_all(struct writeback_control *wbc)
  */
 void wakeup_flusher_threads(long nr_pages)
 {
-	struct writeback_control wbc = {
-		.sync_mode	= WB_SYNC_NONE,
-		.older_than_this = NULL,
-		.range_cyclic	= 1,
-	};
-
 	if (nr_pages == 0)
 		nr_pages = global_page_state(NR_FILE_DIRTY) +
 				global_page_state(NR_UNSTABLE_NFS);
-	wbc.nr_to_write = nr_pages;
-	bdi_writeback_all(&wbc);
+	bdi_writeback_all(NULL, nr_pages);
 }
 
 static noinline void block_dump___mark_inode_dirty(struct inode *inode)
@@ -1048,7 +1069,7 @@ EXPORT_SYMBOL(__mark_inode_dirty);
  * on the writer throttling path, and we get decent balancing between many
  * throttled threads: we don't want them all piling up on inode_sync_wait.
  */
-static void wait_sb_inodes(struct writeback_control *wbc)
+static void wait_sb_inodes(struct super_block *sb)
 {
 	struct inode *inode, *old_inode = NULL;
 
@@ -1056,7 +1077,7 @@ static void wait_sb_inodes(struct writeback_control *wbc)
 	 * We need to be protected against the filesystem going from
 	 * r/o to r/w or vice versa.
 	 */
-	WARN_ON(!rwsem_is_locked(&wbc->sb->s_umount));
+	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_lock);
 
@@ -1067,7 +1088,7 @@ static void wait_sb_inodes(struct writeback_control *wbc)
 	 * In which case, the inode may not be on the dirty list, but
 	 * we still have to wait for that writeout.
 	 */
-	list_for_each_entry(inode, &wbc->sb->s_inodes, i_sb_list) {
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		struct address_space *mapping;
 
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
@@ -1107,14 +1128,8 @@ static void wait_sb_inodes(struct writeback_control *wbc)
  * for IO completion of submitted IO. The number of pages submitted is
  * returned.
  */
-long writeback_inodes_sb(struct super_block *sb)
+void writeback_inodes_sb(struct super_block *sb)
 {
-	struct writeback_control wbc = {
-		.sb		= sb,
-		.sync_mode	= WB_SYNC_NONE,
-		.range_start	= 0,
-		.range_end	= LLONG_MAX,
-	};
 	unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
 	unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
 	long nr_to_write;
@@ -1122,9 +1137,7 @@ long writeback_inodes_sb(struct super_block *sb)
 	nr_to_write = nr_dirty + nr_unstable +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
 
-	wbc.nr_to_write = nr_to_write;
-	bdi_writeback_all(&wbc);
-	return nr_to_write - wbc.nr_to_write;
+	bdi_writeback_all(sb, nr_to_write);
 }
 EXPORT_SYMBOL(writeback_inodes_sb);
 
@@ -1135,21 +1148,10 @@ EXPORT_SYMBOL(writeback_inodes_sb);
  * This function writes and waits on any dirty inode belonging to this
  * super_block. The number of pages synced is returned.
  */
-long sync_inodes_sb(struct super_block *sb)
+void sync_inodes_sb(struct super_block *sb)
 {
-	struct writeback_control wbc = {
-		.sb		= sb,
-		.bdi		= sb->s_bdi,
-		.sync_mode	= WB_SYNC_ALL,
-		.range_start	= 0,
-		.range_end	= LLONG_MAX,
-	};
-	long nr_to_write = LONG_MAX; /* doesn't actually matter */
-
-	wbc.nr_to_write = nr_to_write;
-	bdi_start_writeback(&wbc);
-	wait_sb_inodes(&wbc);
-	return nr_to_write - wbc.nr_to_write;
+	bdi_sync_writeback(sb->s_bdi, sb);
+	wait_sb_inodes(sb);
 }
 EXPORT_SYMBOL(sync_inodes_sb);
 
diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index 1c8991b..ee1ce68 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -54,29 +54,15 @@
  * @nr_to_write: how many dirty pages to write-back
  *
  * This function shrinks UBIFS liability by means of writing back some amount
- * of dirty inodes and their pages. Returns the amount of pages which were
- * written back. The returned value does not include dirty inodes which were
- * synchronized.
+ * of dirty inodes and their pages.
  *
  * Note, this function synchronizes even VFS inodes which are locked
  * (@i_mutex) by the caller of the budgeting function, because write-back does
  * not touch @i_mutex.
  */
-static int shrink_liability(struct ubifs_info *c, int nr_to_write)
+static void shrink_liability(struct ubifs_info *c, int nr_to_write)
 {
-	int nr_written;
-
-	nr_written = writeback_inodes_sb(c->vfs_sb);
-	if (!nr_written) {
-		/*
-		 * Re-try again but wait on pages/inodes which are being
-		 * written-back concurrently (e.g., by pdflush).
-		 */
-		nr_written = sync_inodes_sb(c->vfs_sb);
-	}
-
-	dbg_budg("%d pages were written back", nr_written);
-	return nr_written;
+	writeback_inodes_sb(c->vfs_sb);
 }
 
 /**
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 859e797..0ee33c2 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -101,7 +101,7 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...);
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
-void bdi_start_writeback(struct writeback_control *wbc);
+void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages);
 int bdi_writeback_task(struct bdi_writeback *wb);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 48a054e..75cf586 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -68,8 +68,8 @@ struct writeback_control {
  */	
 struct bdi_writeback;
 int inode_wait(void *);
-long writeback_inodes_sb(struct super_block *);
-long sync_inodes_sb(struct super_block *);
+void writeback_inodes_sb(struct super_block *);
+void sync_inodes_sb(struct super_block *);
 void writeback_inodes_wbc(struct writeback_control *wbc);
 long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
 void wakeup_flusher_threads(long nr_pages);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 12c3d84..1eea4fa 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -582,16 +582,8 @@ static void balance_dirty_pages(struct address_space *mapping)
 	if ((laptop_mode && pages_written) ||
 	    (!laptop_mode && ((nr_writeback = global_page_state(NR_FILE_DIRTY)
 					  + global_page_state(NR_UNSTABLE_NFS))
-					  > background_thresh))) {
-		struct writeback_control wbc = {
-			.bdi		= bdi,
-			.sync_mode	= WB_SYNC_NONE,
-			.nr_to_write	= nr_writeback,
-		};
-
-
-		bdi_start_writeback(&wbc);
-	}
+					  > background_thresh)))
+		bdi_start_writeback(bdi, nr_writeback);
 }
 
 void set_page_dirty_balance(struct page *page, int page_mkwrite)
-- 
1.6.4.1.207.g68ea


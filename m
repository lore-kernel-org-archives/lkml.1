Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbZIOSR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbZIOSR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbZIOSRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:17:21 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59556 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbZIOSQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:16:52 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 04/11] writeback: make wb_writeback() take an argument structure
Date: Tue, 15 Sep 2009 20:16:50 +0200
Message-Id: <1253038617-30204-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com>
References: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to be able to pass in range_cyclic as well, so instead
of growing yet another argument, split the arguments into a
struct wb_writeback_args structure that we can use internally.
Also makes it easier to just copy all members to an on-stack
struct, since we can't access work after clearing the pending
bit.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |   97 +++++++++++++++++++++++++++++++----------------------
 1 files changed, 57 insertions(+), 40 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 783ed44..1dd11d1 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -35,6 +35,17 @@
 int nr_pdflush_threads;
 
 /*
+ * Passed into wb_writeback(), essentially a subset of writeback_control
+ */
+struct wb_writeback_args {
+	long nr_pages;
+	struct super_block *sb;
+	enum writeback_sync_modes sync_mode;
+	int for_kupdate;
+	int range_cyclic;
+};
+
+/*
  * Work items for the bdi_writeback threads
  */
 struct bdi_work {
@@ -45,9 +56,7 @@ struct bdi_work {
 	unsigned long seen;
 	atomic_t pending;
 
-	struct super_block *sb;
-	unsigned long nr_pages;
-	enum writeback_sync_modes sync_mode;
+	struct wb_writeback_args args;
 
 	unsigned long state;
 };
@@ -69,9 +78,10 @@ static inline void bdi_work_init(struct bdi_work *work,
 				 struct writeback_control *wbc)
 {
 	INIT_RCU_HEAD(&work->rcu_head);
-	work->sb = wbc->sb;
-	work->nr_pages = wbc->nr_to_write;
-	work->sync_mode = wbc->sync_mode;
+	work->args.sb = wbc->sb;
+	work->args.nr_pages = wbc->nr_to_write;
+	work->args.sync_mode = wbc->sync_mode;
+	work->args.range_cyclic = wbc->range_cyclic;
 	work->state = WS_USED;
 }
 
@@ -106,7 +116,7 @@ static void bdi_work_free(struct rcu_head *head)
 
 static void wb_work_complete(struct bdi_work *work)
 {
-	const enum writeback_sync_modes sync_mode = work->sync_mode;
+	const enum writeback_sync_modes sync_mode = work->args.sync_mode;
 
 	/*
 	 * For allocated work, we can clear the done/seen bit right here.
@@ -653,17 +663,16 @@ static inline bool over_bground_thresh(void)
  * older_than_this takes precedence over nr_to_write.  So we'll only write back
  * all dirty pages if they are all attached to "old" mappings.
  */
-static long wb_writeback(struct bdi_writeback *wb, long nr_pages,
-			 struct super_block *sb,
-			 enum writeback_sync_modes sync_mode, int for_kupdate)
+static long wb_writeback(struct bdi_writeback *wb,
+			 struct wb_writeback_args *args)
 {
 	struct writeback_control wbc = {
 		.bdi			= wb->bdi,
-		.sb			= sb,
-		.sync_mode		= sync_mode,
+		.sb			= args->sb,
+		.sync_mode		= args->sync_mode,
 		.older_than_this	= NULL,
-		.for_kupdate		= for_kupdate,
-		.range_cyclic		= 1,
+		.for_kupdate		= args->for_kupdate,
+		.range_cyclic		= args->range_cyclic,
 	};
 	unsigned long oldest_jif;
 	long wrote = 0;
@@ -673,29 +682,35 @@ static long wb_writeback(struct bdi_writeback *wb, long nr_pages,
 		oldest_jif = jiffies -
 				msecs_to_jiffies(dirty_expire_interval * 10);
 	}
+	if (!wbc.range_cyclic) {
+		wbc.range_start = 0;
+		wbc.range_end = LLONG_MAX;
+	}
 
 	for (;;) {
-		/*
-		 * Don't flush anything for non-integrity writeback where
-		 * no nr_pages was given
-		 */
-		if (!for_kupdate && nr_pages <= 0 && sync_mode == WB_SYNC_NONE)
-			break;
+		if (!args->for_kupdate && args->nr_pages <= 0) {
+			/*
+			 * Don't flush anything for non-integrity writeback
+			 * where no nr_pages was given
+			 */
+			if (args->sync_mode == WB_SYNC_NONE)
+				break;
 
-		/*
-		 * If no specific pages were given and this is just a
-		 * periodic background writeout and we are below the
-		 * background dirty threshold, don't do anything
-		 */
-		if (for_kupdate && nr_pages <= 0 && !over_bground_thresh())
-			break;
+			/*
+			 * If no specific pages were given and this is just a
+			 * periodic background writeout and we are below the
+			 * background dirty threshold, don't do anything
+			 */
+			if (!over_bground_thresh())
+				break;
+		}
 
 		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
 		writeback_inodes_wb(wb, &wbc);
-		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		args->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 
 		/*
@@ -749,8 +764,14 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
 			global_page_state(NR_UNSTABLE_NFS) +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
 
-	if (nr_pages)
-		return wb_writeback(wb, nr_pages, NULL, WB_SYNC_NONE, 1);
+	if (nr_pages) {
+		struct wb_writeback_args args = {
+			.nr_pages	= nr_pages,
+			.sync_mode	= WB_SYNC_NONE,
+		};
+
+		return wb_writeback(wb, &args);
+	}
 
 	return 0;
 }
@@ -762,35 +783,31 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 {
 	struct backing_dev_info *bdi = wb->bdi;
 	struct bdi_work *work;
-	long nr_pages, wrote = 0;
+	long wrote = 0;
 
 	while ((work = get_next_work_item(bdi, wb)) != NULL) {
-		enum writeback_sync_modes sync_mode;
-
-		nr_pages = work->nr_pages;
+		struct wb_writeback_args args = work->args;
 
 		/*
 		 * Override sync mode, in case we must wait for completion
 		 */
 		if (force_wait)
-			work->sync_mode = sync_mode = WB_SYNC_ALL;
-		else
-			sync_mode = work->sync_mode;
+			work->args.sync_mode = args.sync_mode = WB_SYNC_ALL;
 
 		/*
 		 * If this isn't a data integrity operation, just notify
 		 * that we have seen this work and we are now starting it.
 		 */
-		if (sync_mode == WB_SYNC_NONE)
+		if (args.sync_mode == WB_SYNC_NONE)
 			wb_clear_pending(wb, work);
 
-		wrote += wb_writeback(wb, nr_pages, work->sb, sync_mode, 0);
+		wrote += wb_writeback(wb, &args);
 
 		/*
 		 * This is a data integrity writeback, so only do the
 		 * notification when we have completed the work.
 		 */
-		if (sync_mode == WB_SYNC_ALL)
+		if (args.sync_mode == WB_SYNC_ALL)
 			wb_clear_pending(wb, work);
 	}
 
-- 
1.6.4.1.207.g68ea


Return-Path: <linux-kernel-owner+w=401wt.eu-S933936AbZJGIBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936AbZJGIBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758724AbZJGIBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:28327 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933914AbZJGIBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971502"
Message-Id: <20091007074905.430621233@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li Shaohua" <shaohua.li@intel.com>,
       "Myklebust Trond" <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       <linux-fsdevel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 33/45] writeback: sync livelock - introduce wbc.for_sync
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-for-sync.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sync() is performed in two stages: the WB_SYNC_NONE sync and
the WB_SYNC_ALL sync. It is necessary to tag both stages with
wbc.for_sync, so as to prevent either of them being livelocked.

The next patch will utilize this flag to do the livelock prevention.

CC: Jan Kara <jack@suse.cz> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c           |   30 +++++++++---------------------
 include/linux/backing-dev.h |    2 +-
 include/linux/writeback.h   |   11 +++++++++++
 mm/page-writeback.c         |    2 +-
 4 files changed, 22 insertions(+), 23 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-10-06 23:39:32.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:39:33.000000000 +0800
@@ -42,6 +42,7 @@ struct wb_writeback_args {
 	long nr_pages;
 	struct super_block *sb;
 	enum writeback_sync_modes sync_mode;
+	int for_sync:1;
 	int for_kupdate:1;
 	int range_cyclic:1;
 	int for_background:1;
@@ -221,6 +222,7 @@ static void bdi_sync_writeback(struct ba
 	struct wb_writeback_args args = {
 		.sb		= sb,
 		.sync_mode	= WB_SYNC_ALL,
+		.for_sync	= 1,
 		.nr_pages	= LONG_MAX,
 		.range_cyclic	= 0,
 	};
@@ -236,7 +238,6 @@ static void bdi_sync_writeback(struct ba
 /**
  * bdi_start_writeback - start writeback
  * @bdi: the backing device to write from
- * @nr_pages: the number of pages to write
  *
  * Description:
  *   This does WB_SYNC_NONE opportunistic writeback. The IO is only
@@ -245,24 +246,17 @@ static void bdi_sync_writeback(struct ba
  *
  */
 void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
-			 long nr_pages)
+			 long mission)
 {
 	struct wb_writeback_args args = {
 		.sb		= sb,
 		.sync_mode	= WB_SYNC_NONE,
-		.nr_pages	= nr_pages,
+		.nr_pages	= LONG_MAX,
+		.for_background	= mission == WB_FOR_BACKGROUND,
+		.for_sync	= mission == WB_FOR_SYNC,
 		.range_cyclic	= 1,
 	};
 
-	/*
-	 * We treat @nr_pages=0 as the special case to do background writeback,
-	 * ie. to sync pages until the background dirty threshold is reached.
-	 */
-	if (!nr_pages) {
-		args.nr_pages = LONG_MAX;
-		args.for_background = 1;
-	}
-
 	bdi_alloc_queue_work(bdi, &args);
 }
 
@@ -310,7 +304,7 @@ void bdi_writeback_wait(struct backing_d
 	 * make sure we will be woke up by someone
 	 */
 	if (can_submit_background_writeback(bdi))
-		bdi_start_writeback(bdi, NULL, 0);
+		bdi_start_writeback(bdi, NULL, WB_FOR_BACKGROUND);
 
 	wait_for_completion(&tt.complete);
 }
@@ -790,6 +784,7 @@ static long wb_writeback(struct bdi_writ
 		.older_than_this	= NULL,
 		.for_kupdate		= args->for_kupdate,
 		.for_background		= args->for_background,
+		.for_sync		= args->for_sync,
 		.range_cyclic		= args->range_cyclic,
 	};
 	unsigned long oldest_jif;
@@ -1250,14 +1245,7 @@ static void wait_sb_inodes(struct super_
  */
 void writeback_inodes_sb(struct super_block *sb)
 {
-	unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
-	unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
-	long nr_to_write;
-
-	nr_to_write = nr_dirty + nr_unstable +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
-
-	bdi_start_writeback(sb->s_bdi, sb, nr_to_write);
+	bdi_start_writeback(sb->s_bdi, sb, WB_FOR_SYNC);
 }
 EXPORT_SYMBOL(writeback_inodes_sb);
 
--- linux.orig/include/linux/backing-dev.h	2009-10-06 23:39:26.000000000 +0800
+++ linux/include/linux/backing-dev.h	2009-10-06 23:39:33.000000000 +0800
@@ -123,7 +123,7 @@ int bdi_register(struct backing_dev_info
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
 void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
-				long nr_pages);
+				long mission);
 int bdi_writeback_task(struct bdi_writeback *wb);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 int bdi_writeback_wakeup(struct backing_dev_info *bdi);
--- linux.orig/include/linux/writeback.h	2009-10-06 23:39:28.000000000 +0800
+++ linux/include/linux/writeback.h	2009-10-06 23:39:33.000000000 +0800
@@ -31,6 +31,16 @@ enum writeback_sync_modes {
 	WB_SYNC_ALL,	/* Wait on every mapping */
 };
 
+enum writeback_mission {
+	WB_FOR_KUPDATE,		/* writeback expired dirty inodes */
+	WB_FOR_RECLAIM,
+	WB_FOR_BACKGROUND,	/* stop on hitting background threshold */
+	WB_FOR_SYNC,		/* write all now-dirty inodes/pages,
+				 * but take care not to live lock
+				 */
+	WB_NR_PAGES,		/* writeback # of pages if larger than this */
+};
+
 /*
  * A control structure which tells the writeback code what to do.  These are
  * always on the stack, and hence need no locking.  They are always initialised
@@ -65,6 +75,7 @@ struct writeback_control {
 	unsigned encountered_congestion:1; /* An output: a queue is full */
 	unsigned for_kupdate:1;		/* A kupdate writeback */
 	unsigned for_background:1;	/* A background writeback */
+	unsigned for_sync:1;		/* A writeback for sync */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
--- linux.orig/mm/page-writeback.c	2009-10-06 23:39:30.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-06 23:39:33.000000000 +0800
@@ -529,7 +529,7 @@ out:
 	 */
 	if (!laptop_mode && (nr_reclaimable > background_thresh) &&
 	    can_submit_background_writeback(bdi))
-		bdi_start_writeback(bdi, NULL, 0);
+		bdi_start_writeback(bdi, NULL, WB_FOR_BACKGROUND);
 }
 
 void set_page_dirty_balance(struct page *page, int page_mkwrite)



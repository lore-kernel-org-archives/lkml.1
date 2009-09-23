Return-Path: <linux-kernel-owner+w=401wt.eu-S1751851AbZIWMnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbZIWMnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZIWMnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:43:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:41517 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbZIWMni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:43:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,438,1249282800"; 
   d="scan'208";a="190735393"
Message-Id: <20090923124027.589303074@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 23 Sep 2009 20:33:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] writeback: stop background writeback when below background threshold
References: <20090923123337.990689487@intel.com>
Content-Disposition: inline; filename=writeback-background-threshold.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Treat bdi_start_writeback(0) as a special request to do background write,
and stop such work when we are below the background dirty threshold.

Also simplify the (nr_pages <= 0) checks. Since we already pass in
nr_pages=LONG_MAX for WB_SYNC_ALL and background writes, we don't
need to worry about it being decreased to zero.

Reported-by: Richard Kennedy <richard@rsk.demon.co.uk>
CC: Jan Kara <jack@suse.cz>
CC: Jens Axboe <jens.axboe@oracle.com> 
CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c   |   28 +++++++++++++++++-----------
 mm/page-writeback.c |    6 +++---
 2 files changed, 20 insertions(+), 14 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-23 17:47:23.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-23 18:13:36.000000000 +0800
@@ -41,8 +41,9 @@ struct wb_writeback_args {
 	long nr_pages;
 	struct super_block *sb;
 	enum writeback_sync_modes sync_mode;
-	int for_kupdate;
-	int range_cyclic;
+	int for_kupdate:1;
+	int range_cyclic:1;
+	int for_background:1;
 };
 
 /*
@@ -260,6 +261,15 @@ void bdi_start_writeback(struct backing_
 		.range_cyclic	= 1,
 	};
 
+	/*
+	 * We treat @nr_pages=0 as the special case to do background writeback,
+	 * ie. to sync pages until the background dirty threshold is reached.
+	 */
+	if (!nr_pages) {
+		args.nr_pages = LONG_MAX;
+		args.for_background = 1;
+	}
+
 	bdi_alloc_queue_work(bdi, &args);
 }
 
@@ -723,20 +733,16 @@ static long wb_writeback(struct bdi_writ
 
 	for (;;) {
 		/*
-		 * Don't flush anything for non-integrity writeback where
-		 * no nr_pages was given
+		 * Stop writeback when nr_pages has been consumed
 		 */
-		if (!args->for_kupdate && args->nr_pages <= 0 &&
-		     args->sync_mode == WB_SYNC_NONE)
+		if (args->nr_pages <= 0)
 			break;
 
 		/*
-		 * If no specific pages were given and this is just a
-		 * periodic background writeout and we are below the
-		 * background dirty threshold, don't do anything
+		 * For background writeout, stop when we are below the
+		 * background dirty threshold
 		 */
-		if (args->for_kupdate && args->nr_pages <= 0 &&
-		    !over_bground_thresh())
+		if (args->for_background && !over_bground_thresh())
 			break;
 
 		wbc.more_io = 0;
--- linux.orig/mm/page-writeback.c	2009-09-23 17:45:58.000000000 +0800
+++ linux/mm/page-writeback.c	2009-09-23 17:47:17.000000000 +0800
@@ -589,10 +589,10 @@ static void balance_dirty_pages(struct a
 	 * background_thresh, to keep the amount of dirty memory low.
 	 */
 	if ((laptop_mode && pages_written) ||
-	    (!laptop_mode && ((nr_writeback = global_page_state(NR_FILE_DIRTY)
-					  + global_page_state(NR_UNSTABLE_NFS))
+	    (!laptop_mode && ((global_page_state(NR_FILE_DIRTY)
+			       + global_page_state(NR_UNSTABLE_NFS))
 					  > background_thresh)))
-		bdi_start_writeback(bdi, nr_writeback);
+		bdi_start_writeback(bdi, 0);
 }
 
 void set_page_dirty_balance(struct page *page, int page_mkwrite)



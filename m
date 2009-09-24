Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZIXOkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZIXOkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZIXOki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:40:38 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44118 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbZIXOkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:40:35 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, shaohua.li@intel.com, chris.mason@oracle.com,
       jack@suse.cz, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 03/10] writeback: stop background writeback when below background threshold
Date: Thu, 24 Sep 2009 16:40:29 +0200
Message-Id: <1253803236-20760-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-Reply-To: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>

Treat bdi_start_writeback(0) as a special request to do background write,
and stop such work when we are below the background dirty threshold.

Also simplify the (nr_pages <= 0) checks. Since we already pass in
nr_pages=LONG_MAX for WB_SYNC_ALL and background writes, we don't
need to worry about it being decreased to zero.

Reported-by: Richard Kennedy <richard@rsk.demon.co.uk>
CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c   |   28 +++++++++++++++++-----------
 mm/page-writeback.c |    6 +++---
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index c59d673..476be9b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
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
@@ -257,6 +258,15 @@ void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages)
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
 
@@ -720,20 +730,16 @@ static long wb_writeback(struct bdi_writeback *wb,
 
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
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index cbd4cba..3c78fc3 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -593,10 +593,10 @@ static void balance_dirty_pages(struct address_space *mapping,
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
-- 
1.6.4.1.207.g68ea


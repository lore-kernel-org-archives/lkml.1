Return-Path: <linux-kernel-owner+w=401wt.eu-S932643AbZJGIAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbZJGIAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932454AbZJGIAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:00:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:35820 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458AbZJGIA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:00:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971232"
Message-Id: <20091007074903.560259348@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:37 +0800
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
Subject: [PATCH 19/45] writeback: remove the loop in balance_dirty_pages()
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-balance-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop is no longer necessary. Remove it without behavior change.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   81 +++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 43 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-10-06 23:38:43.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-06 23:38:43.000000000 +0800
@@ -470,60 +470,55 @@ static void balance_dirty_pages(struct a
 	int dirty_exceeded;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
-	for (;;) {
-		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
-				 global_page_state(NR_UNSTABLE_NFS);
-		nr_writeback = global_page_state(NR_WRITEBACK) +
-			       global_page_state(NR_WRITEBACK_TEMP);
+	nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
+			 global_page_state(NR_UNSTABLE_NFS);
+	nr_writeback = global_page_state(NR_WRITEBACK) +
+		       global_page_state(NR_WRITEBACK_TEMP);
 
-		global_dirty_thresh(&background_thresh, &dirty_thresh);
-
-		/*
-		 * Throttle it only when the background writeback cannot
-		 * catch-up. This avoids (excessively) small writeouts
-		 * when the bdi limits are ramping up.
-		 */
-		if (nr_reclaimable + nr_writeback <
-		    (background_thresh + dirty_thresh) / 2)
-			break;
+	global_dirty_thresh(&background_thresh, &dirty_thresh);
 
-		bdi_thresh = bdi_dirty_thresh(bdi, dirty_thresh);
+	/*
+	 * Throttle it only when the background writeback cannot
+	 * catch-up. This skips the ramp up phase of bdi limits.
+	 */
+	if (nr_reclaimable + nr_writeback <
+			(background_thresh + dirty_thresh) / 2)
+		goto out;
 
-		/*
-		 * In order to avoid the stacked BDI deadlock we need
-		 * to ensure we accurately count the 'dirty' pages when
-		 * the threshold is low.
-		 *
-		 * Otherwise it would be possible to get thresh+n pages
-		 * reported dirty, even though there are thresh-m pages
-		 * actually dirty; with m+n sitting in the percpu
-		 * deltas.
-		 */
-		if (bdi_thresh < 2*bdi_stat_error(bdi)) {
-			bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
-			bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
-		} else {
-			bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
-			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
-		}
+	bdi_thresh = bdi_dirty_thresh(bdi, dirty_thresh);
+	/*
+	 * In order to avoid the stacked BDI deadlock we need
+	 * to ensure we accurately count the 'dirty' pages when
+	 * the threshold is low.
+	 *
+	 * Otherwise it would be possible to get thresh+n pages
+	 * reported dirty, even though there are thresh-m pages
+	 * actually dirty; with m+n sitting in the percpu
+	 * deltas.
+	 */
+	if (bdi_thresh >= 2 * bdi_stat_error(bdi)) {
+		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
+		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+	} else {
+		bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
+		bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
+	}
 
-		dirty_exceeded =
-			(bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh)
+	dirty_exceeded = (bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh)
 			|| (nr_reclaimable + nr_writeback >= dirty_thresh);
 
-		if (!dirty_exceeded)
-			break;
+	if (!dirty_exceeded)
+		goto out;
 
-		if (!bdi->dirty_exceeded)
-			bdi->dirty_exceeded = 1;
+	if (!bdi->dirty_exceeded)
+		bdi->dirty_exceeded = 1;
 
-		bdi_writeback_wait(bdi, write_chunk);
-		break;
-	}
+	bdi_writeback_wait(bdi, write_chunk);
 
-	if (!dirty_exceeded && bdi->dirty_exceeded)
+	if (bdi->dirty_exceeded)
 		bdi->dirty_exceeded = 0;
 
+out:
 	/*
 	 * In laptop mode, we wait until hitting the higher threshold before
 	 * starting background writeout, and then write out all the way down



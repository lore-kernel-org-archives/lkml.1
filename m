Return-Path: <linux-kernel-owner+w=401wt.eu-S934052AbZJGIHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052AbZJGIHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933198AbZJGICS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:02:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:9396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758686AbZJGICJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:02:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971729"
Message-Id: <20091007074901.251116016@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:19 +0800
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
       <linux-fsdevel@vger.kernel.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/45] writeback: reduce calls to global_page_state in balance_dirty_pages()
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-less-balance-calc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Kennedy <richard@rsk.demon.co.uk>

Reducing the number of times balance_dirty_pages calls global_page_state
reduces the cache references and so improves write performance on a
variety of workloads.

'perf stats' of simple fio write tests shows the reduction in cache
access.
Where the test is fio 'write,mmap,600Mb,pre_read' on AMD AthlonX2 with
3Gb memory (dirty_threshold approx 600 Mb)
running each test 10 times, dropping the fasted & slowest values then
taking 
the average & standard deviation

		average (s.d.) in millions (10^6)
2.6.31-rc8	648.6 (14.6)
+patch		620.1 (16.5)

Achieving this reduction is by dropping clip_bdi_dirty_limit as it  
rereads the counters to apply the dirty_threshold and moving this check
up into balance_dirty_pages where it has already read the counters.

Also by rearrange the for loop to only contain one copy of the limit
tests allows the pdflush test after the loop to use the local copies of
the counters rather than rereading them.

In the common case with no throttling it now calls global_page_state 5
fewer times and bdi_stat 2 fewer.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
----
Thanks to everybody for the feedback & suggestions.
This patch is against 2.6.31-rc8

---
 mm/page-writeback.c |   99 ++++++++++++++----------------------------
 1 file changed, 33 insertions(+), 66 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-10-06 23:31:42.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-06 23:31:53.000000000 +0800
@@ -252,32 +252,6 @@ static void bdi_writeout_fraction(struct
 	}
 }
 
-/*
- * Clip the earned share of dirty pages to that which is actually available.
- * This avoids exceeding the total dirty_limit when the floating averages
- * fluctuate too quickly.
- */
-static void clip_bdi_dirty_limit(struct backing_dev_info *bdi,
-		unsigned long dirty, unsigned long *pbdi_dirty)
-{
-	unsigned long avail_dirty;
-
-	avail_dirty = global_page_state(NR_FILE_DIRTY) +
-		 global_page_state(NR_WRITEBACK) +
-		 global_page_state(NR_UNSTABLE_NFS) +
-		 global_page_state(NR_WRITEBACK_TEMP);
-
-	if (avail_dirty < dirty)
-		avail_dirty = dirty - avail_dirty;
-	else
-		avail_dirty = 0;
-
-	avail_dirty += bdi_stat(bdi, BDI_RECLAIMABLE) +
-		bdi_stat(bdi, BDI_WRITEBACK);
-
-	*pbdi_dirty = min(*pbdi_dirty, avail_dirty);
-}
-
 static inline void task_dirties_fraction(struct task_struct *tsk,
 		long *numerator, long *denominator)
 {
@@ -468,7 +442,6 @@ get_dirty_limits(unsigned long *pbackgro
 			bdi_dirty = dirty * bdi->max_ratio / 100;
 
 		*pbdi_dirty = bdi_dirty;
-		clip_bdi_dirty_limit(bdi, dirty, pbdi_dirty);
 		task_dirty_limit(current, pbdi_dirty);
 	}
 }
@@ -490,7 +463,7 @@ static void balance_dirty_pages(struct a
 	unsigned long bdi_thresh;
 	unsigned long pages_written = 0;
 	unsigned long pause = 1;
-
+	int dirty_exceeded;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
 	for (;;) {
@@ -503,16 +476,36 @@ static void balance_dirty_pages(struct a
 		};
 
 		get_dirty_limits(&background_thresh, &dirty_thresh,
-				&bdi_thresh, bdi);
+				 &bdi_thresh, bdi);
 
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
-					global_page_state(NR_UNSTABLE_NFS);
-		nr_writeback = global_page_state(NR_WRITEBACK);
+				 global_page_state(NR_UNSTABLE_NFS);
+		nr_writeback = global_page_state(NR_WRITEBACK) +
+			       global_page_state(NR_WRITEBACK_TEMP);
 
-		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
-		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+		/*
+		 * In order to avoid the stacked BDI deadlock we need
+		 * to ensure we accurately count the 'dirty' pages when
+		 * the threshold is low.
+		 *
+		 * Otherwise it would be possible to get thresh+n pages
+		 * reported dirty, even though there are thresh-m pages
+		 * actually dirty; with m+n sitting in the percpu
+		 * deltas.
+		 */
+		if (bdi_thresh < 2*bdi_stat_error(bdi)) {
+			bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
+			bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
+		} else {
+			bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
+			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+		}
+
+		dirty_exceeded =
+			(bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh)
+			|| (nr_reclaimable + nr_writeback >= dirty_thresh);
 
-		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
+		if (!dirty_exceeded)
 			break;
 
 		/*
@@ -521,7 +514,7 @@ static void balance_dirty_pages(struct a
 		 * when the bdi limits are ramping up.
 		 */
 		if (nr_reclaimable + nr_writeback <
-				(background_thresh + dirty_thresh) / 2)
+		    (background_thresh + dirty_thresh) / 2)
 			break;
 
 		if (!bdi->dirty_exceeded)
@@ -539,33 +532,10 @@ static void balance_dirty_pages(struct a
 		if (bdi_nr_reclaimable > bdi_thresh) {
 			writeback_inodes_wbc(&wbc);
 			pages_written += write_chunk - wbc.nr_to_write;
-			get_dirty_limits(&background_thresh, &dirty_thresh,
-				       &bdi_thresh, bdi);
-		}
-
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
-		} else if (bdi_nr_reclaimable) {
-			bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
-			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+			/* don't wait if we've done enough */
+			if (pages_written >= write_chunk)
+				break;
 		}
-
-		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
-			break;
-		if (pages_written >= write_chunk)
-			break;		/* We've done our duty */
-
 		schedule_timeout_interruptible(pause);
 
 		/*
@@ -577,8 +547,7 @@ static void balance_dirty_pages(struct a
 			pause = HZ / 10;
 	}
 
-	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
-			bdi->dirty_exceeded)
+	if (!dirty_exceeded && bdi->dirty_exceeded)
 		bdi->dirty_exceeded = 0;
 
 	if (writeback_in_progress(bdi))
@@ -593,9 +562,7 @@ static void balance_dirty_pages(struct a
 	 * background_thresh, to keep the amount of dirty memory low.
 	 */
 	if ((laptop_mode && pages_written) ||
-	    (!laptop_mode && ((global_page_state(NR_FILE_DIRTY)
-			       + global_page_state(NR_UNSTABLE_NFS))
-					  > background_thresh)))
+	    (!laptop_mode && (nr_reclaimable > background_thresh)))
 		bdi_start_writeback(bdi, NULL, 0);
 }
 



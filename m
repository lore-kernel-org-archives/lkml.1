Return-Path: <linux-kernel-owner+w=401wt.eu-S934136AbZJGIKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136AbZJGIKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933972AbZJGIJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:09:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:1895 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758725AbZJGIBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971554"
Message-Id: <20091007074901.370435654@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:20 +0800
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
Subject: [PATCH 02/45] writeback: reduce calculation of bdi dirty thresholds
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-less-bdi-calc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split get_dirty_limits() into global_dirty_thresh() and bdi_dirty_thresh(),
so that the latter can be avoided in balance_dirty_pages() when under
global dirty threshold.

CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |    2 
 include/linux/writeback.h |    5 +-
 mm/backing-dev.c          |    3 -
 mm/page-writeback.c       |   74 ++++++++++++++++++------------------
 4 files changed, 43 insertions(+), 41 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-10-06 23:31:53.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-06 23:31:54.000000000 +0800
@@ -266,10 +266,11 @@ static inline void task_dirties_fraction
  *
  *   dirty -= (dirty/8) * p_{t}
  */
-static void task_dirty_limit(struct task_struct *tsk, unsigned long *pdirty)
+static unsigned long task_dirty_thresh(struct task_struct *tsk,
+				       unsigned long bdi_dirty)
 {
 	long numerator, denominator;
-	unsigned long dirty = *pdirty;
+	unsigned long dirty = bdi_dirty;
 	u64 inv = dirty >> 3;
 
 	task_dirties_fraction(tsk, &numerator, &denominator);
@@ -277,10 +278,8 @@ static void task_dirty_limit(struct task
 	do_div(inv, denominator);
 
 	dirty -= inv;
-	if (dirty < *pdirty/2)
-		dirty = *pdirty/2;
 
-	*pdirty = dirty;
+	return max(dirty, bdi_dirty/2);
 }
 
 /*
@@ -390,9 +389,7 @@ unsigned long determine_dirtyable_memory
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
-void
-get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
-		 unsigned long *pbdi_dirty, struct backing_dev_info *bdi)
+void global_dirty_thresh(unsigned long *pbackground, unsigned long *pdirty)
 {
 	unsigned long background;
 	unsigned long dirty;
@@ -424,26 +421,28 @@ get_dirty_limits(unsigned long *pbackgro
 	}
 	*pbackground = background;
 	*pdirty = dirty;
+}
 
-	if (bdi) {
-		u64 bdi_dirty;
-		long numerator, denominator;
+unsigned long bdi_dirty_thresh(struct backing_dev_info *bdi,
+			       unsigned long dirty)
+{
+	u64 bdi_dirty;
+	long numerator, denominator;
 
-		/*
-		 * Calculate this BDI's share of the dirty ratio.
-		 */
-		bdi_writeout_fraction(bdi, &numerator, &denominator);
+	/*
+	 * Calculate this BDI's share of the dirty ratio.
+	 */
+	bdi_writeout_fraction(bdi, &numerator, &denominator);
 
-		bdi_dirty = (dirty * (100 - bdi_min_ratio)) / 100;
-		bdi_dirty *= numerator;
-		do_div(bdi_dirty, denominator);
-		bdi_dirty += (dirty * bdi->min_ratio) / 100;
-		if (bdi_dirty > (dirty * bdi->max_ratio) / 100)
-			bdi_dirty = dirty * bdi->max_ratio / 100;
+	bdi_dirty = (dirty * (100 - bdi_min_ratio)) / 100;
+	bdi_dirty *= numerator;
+	do_div(bdi_dirty, denominator);
 
-		*pbdi_dirty = bdi_dirty;
-		task_dirty_limit(current, pbdi_dirty);
-	}
+	bdi_dirty += (dirty * bdi->min_ratio) / 100;
+	if (bdi_dirty > (dirty * bdi->max_ratio) / 100)
+		bdi_dirty = dirty * bdi->max_ratio / 100;
+
+	return task_dirty_thresh(current, bdi_dirty);
 }
 
 /*
@@ -475,14 +474,24 @@ static void balance_dirty_pages(struct a
 			.range_cyclic	= 1,
 		};
 
-		get_dirty_limits(&background_thresh, &dirty_thresh,
-				 &bdi_thresh, bdi);
-
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 				 global_page_state(NR_UNSTABLE_NFS);
 		nr_writeback = global_page_state(NR_WRITEBACK) +
 			       global_page_state(NR_WRITEBACK_TEMP);
 
+		global_dirty_thresh(&background_thresh, &dirty_thresh);
+
+		/*
+		 * Throttle it only when the background writeback cannot
+		 * catch-up. This avoids (excessively) small writeouts
+		 * when the bdi limits are ramping up.
+		 */
+		if (nr_reclaimable + nr_writeback <
+		    (background_thresh + dirty_thresh) / 2)
+			break;
+
+		bdi_thresh = bdi_dirty_thresh(bdi, dirty_thresh);
+
 		/*
 		 * In order to avoid the stacked BDI deadlock we need
 		 * to ensure we accurately count the 'dirty' pages when
@@ -508,15 +517,6 @@ static void balance_dirty_pages(struct a
 		if (!dirty_exceeded)
 			break;
 
-		/*
-		 * Throttle it only when the background writeback cannot
-		 * catch-up. This avoids (excessively) small writeouts
-		 * when the bdi limits are ramping up.
-		 */
-		if (nr_reclaimable + nr_writeback <
-		    (background_thresh + dirty_thresh) / 2)
-			break;
-
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 
@@ -626,7 +626,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 	unsigned long dirty_thresh;
 
         for ( ; ; ) {
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
+		global_dirty_thresh(&background_thresh, &dirty_thresh);
 
                 /*
                  * Boost the allowable dirty threshold a bit for page
--- linux.orig/fs/fs-writeback.c	2009-10-06 23:31:52.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:31:54.000000000 +0800
@@ -729,7 +729,7 @@ static inline bool over_bground_thresh(v
 {
 	unsigned long background_thresh, dirty_thresh;
 
-	get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
+	global_dirty_thresh(&background_thresh, &dirty_thresh);
 
 	return (global_page_state(NR_FILE_DIRTY) +
 		global_page_state(NR_UNSTABLE_NFS) >= background_thresh);
--- linux.orig/mm/backing-dev.c	2009-10-06 23:31:42.000000000 +0800
+++ linux/mm/backing-dev.c	2009-10-06 23:31:54.000000000 +0800
@@ -83,7 +83,8 @@ static int bdi_debug_stats_show(struct s
 	}
 	spin_unlock(&inode_lock);
 
-	get_dirty_limits(&background_thresh, &dirty_thresh, &bdi_thresh, bdi);
+	global_dirty_thresh(&background_thresh, &dirty_thresh);
+	bdi_thresh = bdi_dirty_thresh(bdi, dirty_thresh);
 
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 	seq_printf(m,
--- linux.orig/include/linux/writeback.h	2009-10-06 23:31:52.000000000 +0800
+++ linux/include/linux/writeback.h	2009-10-06 23:31:54.000000000 +0800
@@ -126,8 +126,9 @@ struct ctl_table;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int,
 				      void __user *, size_t *, loff_t *);
 
-void get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
-		      unsigned long *pbdi_dirty, struct backing_dev_info *bdi);
+void global_dirty_thresh(unsigned long *pbackground, unsigned long *pdirty);
+unsigned long bdi_dirty_thresh(struct backing_dev_info *bdi,
+			       unsigned long dirty);
 
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,



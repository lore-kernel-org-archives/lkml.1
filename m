Return-Path: <linux-kernel-owner+w=401wt.eu-S934081AbZJGIIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081AbZJGIIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933990AbZJGIB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:58309 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933212AbZJGIB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971365"
Message-Id: <20091007074905.829888184@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:54 +0800
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
Subject: [PATCH 36/45] writeback: sync livelock - curb dirty speed for inodes to be synced
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-sync-pending-slower-writes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inodes to be synced will be dirty throttled regardless of the dirty
threshold.  This stops sync() livelock by some fast dirtier.

CC: Jan Kara <jack@suse.cz> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c           |    4 ++++
 include/linux/backing-dev.h |    1 +
 mm/page-writeback.c         |   13 +++++++++++++
 3 files changed, 18 insertions(+)

--- linux.orig/mm/page-writeback.c	2009-10-07 10:47:09.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-07 14:32:43.000000000 +0800
@@ -478,6 +478,18 @@ static void balance_dirty_pages(struct a
 	global_dirty_thresh(&background_thresh, &dirty_thresh);
 
 	/*
+	 * If sync() is in progress, curb the to-be-synced inodes regardless
+	 * of dirty limits, so that a fast dirtier won't livelock the sync.
+	 */
+	if (unlikely(bdi->sync_time &&
+		     S_ISREG(mapping->host->i_mode) &&
+		     time_after_eq(bdi->sync_time,
+				   mapping->host->dirtied_when))) {
+		write_chunk *= 2;
+		goto throttle;
+	}
+
+	/*
 	 * Throttle it only when the background writeback cannot
 	 * catch-up. This skips the ramp up phase of bdi limits.
 	 */
@@ -510,6 +522,7 @@ static void balance_dirty_pages(struct a
 	if (!dirty_exceeded)
 		goto out;
 
+throttle:
 	if (!bdi->dirty_exceeded)
 		bdi->dirty_exceeded = 1;
 
--- linux.orig/fs/fs-writeback.c	2009-10-07 10:47:09.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-07 14:31:47.000000000 +0800
@@ -796,6 +796,7 @@ static long wb_writeback(struct bdi_writ
 	if (wbc.for_sync) {
 		wbc.older_than_this = &oldest_jif;
 		oldest_jif = jiffies;
+		wbc.bdi->sync_time = oldest_jif | 1;
 	}
 	if (wbc.for_kupdate || wbc.for_background) {
 		wbc.older_than_this = &oldest_jif;
@@ -873,6 +874,9 @@ static long wb_writeback(struct bdi_writ
 		spin_unlock(&inode_lock);
 	}
 
+	if (args->for_sync)
+		wb->bdi->sync_time = 0;
+
 	if (args->for_background)
 		while (bdi_writeback_wakeup(wb->bdi))
 			;  /* unthrottle all tasks */
--- linux.orig/include/linux/backing-dev.h	2009-10-07 10:47:09.000000000 +0800
+++ linux/include/linux/backing-dev.h	2009-10-07 14:31:53.000000000 +0800
@@ -89,6 +89,7 @@ struct backing_dev_info {
 	 * to prevent livelocking the sync works
 	 */
 	unsigned int sync_works;
+	unsigned long sync_time;
 
 	struct list_head work_list;
 



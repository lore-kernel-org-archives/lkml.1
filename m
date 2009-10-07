Return-Path: <linux-kernel-owner+w=401wt.eu-S934073AbZJGIH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934073AbZJGIH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933236AbZJGIH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:07:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:1895 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758671AbZJGICJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:02:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971710"
Message-Id: <20091007074904.344738045@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:43 +0800
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
Subject: [PATCH 25/45] writeback: convert wbc.nr_to_write to per-file parameter
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-per-file-nr_to_write.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Theodore Ts'o <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Dave Chinner <david@fromorbit.com> 
CC: Christoph Hellwig <hch@infradead.org>
CC: Jan Kara <jack@suse.cz> 
CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
CC: Jens Axboe <jens.axboe@oracle.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |   24 ++++++++++++------------
 include/linux/writeback.h |    5 +++--
 mm/backing-dev.c          |    1 -
 3 files changed, 15 insertions(+), 15 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-10-06 23:38:45.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:38:56.000000000 +0800
@@ -661,12 +661,13 @@ pinned:
 	return 0;
 }
 
-static void writeback_inodes_wb(struct bdi_writeback *wb,
+static long writeback_inodes_wb(struct bdi_writeback *wb,
 				struct writeback_control *wbc)
 {
 	struct super_block *sb = wbc->sb, *pin_sb = NULL;
 	const unsigned long start = jiffies;	/* livelock avoidance */
 	unsigned long stop_time = 0;
+	unsigned long wrote = 0;
 
 	if (wbc->timeout)
 		stop_time = (start + wbc->timeout) | 1;
@@ -709,7 +710,10 @@ static void writeback_inodes_wb(struct b
 		BUG_ON(inode->i_state & (I_FREEING | I_CLEAR));
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
+		wbc->nr_to_write = bdi_writeback_chunk(wb->bdi);
+		wrote += wbc->nr_to_write;
 		writeback_single_inode(inode, wbc);
+		wrote -= wbc->nr_to_write;
 		if (wbc->pages_skipped != pages_skipped) {
 			/*
 			 * writeback is not making progress due to locked
@@ -735,6 +739,7 @@ static void writeback_inodes_wb(struct b
 
 	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
+	return wrote;
 }
 
 void writeback_inodes_wbc(struct writeback_control *wbc)
@@ -782,6 +787,7 @@ static long wb_writeback(struct bdi_writ
 	};
 	unsigned long oldest_jif;
 	long wrote = 0;
+	long nr;
 	struct inode *inode;
 
 	if (wbc.for_kupdate) {
@@ -810,26 +816,20 @@ static long wb_writeback(struct bdi_writ
 
 		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
-		writeback_inodes_wb(wb, &wbc);
-		args->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		nr = writeback_inodes_wb(wb, &wbc);
+		args->nr_pages -= nr;
+		wrote += nr;
 
 		/*
-		 * If we consumed everything, see if we have more
-		 */
-		if (wbc.nr_to_write <= 0)
-			continue;
-		/*
-		 * Didn't write everything and we don't have more IO, bail
+		 * Bail if no more IO
 		 */
 		if (!wbc.more_io)
 			break;
 		/*
 		 * Did we write something? Try for more
 		 */
-		if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
+		if (nr)
 			continue;
 		/*
 		 * Nothing written. Wait for some inode to
--- linux.orig/include/linux/writeback.h	2009-10-06 23:38:45.000000000 +0800
+++ linux/include/linux/writeback.h	2009-10-06 23:38:52.000000000 +0800
@@ -45,8 +45,9 @@ struct writeback_control {
 	int timeout;
 	unsigned long *older_than_this;	/* If !NULL, only write back inodes
 					   older than this */
-	long nr_to_write;		/* Write this many pages, and decrement
-					   this for each page written */
+	long nr_to_write;		/* Max pages to write per file, and
+					   decrement this for each page written
+					 */
 	long pages_skipped;		/* Pages which were not written */
 
 	/*
--- linux.orig/mm/backing-dev.c	2009-10-06 23:38:45.000000000 +0800
+++ linux/mm/backing-dev.c	2009-10-06 23:38:52.000000000 +0800
@@ -338,7 +338,6 @@ static void bdi_flush_io(struct backing_
 		.sync_mode		= WB_SYNC_NONE,
 		.older_than_this	= NULL,
 		.range_cyclic		= 1,
-		.nr_to_write		= 1024,
 		.timeout		= HZ,
 	};
 



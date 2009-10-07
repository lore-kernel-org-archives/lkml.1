Return-Path: <linux-kernel-owner+w=401wt.eu-S933998AbZJGIB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998AbZJGIB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933982AbZJGIB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:1895 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717AbZJGIBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971647"
Message-Id: <20091007074906.232484667@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:57 +0800
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
Subject: [PATCH 39/45] writeback: remove wbc.more_io
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-remove-more-io.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems no longer required. It was introduced mainly to deal with the
complexity from _multiple_ superblock queues. Now there are only one
queue, so infomation can be directly queried if necessary.

CC: Theodore Ts'o <tytso@mit.edu> 
CC: Dave Chinner <david@fromorbit.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c           |   13 +------------
 include/linux/writeback.h   |    1 -
 include/trace/events/ext4.h |    6 ++----
 3 files changed, 3 insertions(+), 17 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-10-07 14:32:50.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-07 14:32:51.000000000 +0800
@@ -733,12 +733,8 @@ static long writeback_inodes_wb(struct b
 		iput(inode);
 		cond_resched();
 		spin_lock(&inode_lock);
-		if (wbc->nr_to_write <= 0) {
-			wbc->more_io = 1;
+		if (wbc->nr_to_write <= 0)
 			break;
-		}
-		if (!list_empty(&wb->b_more_io))
-			wbc->more_io = 1;
 		if (stop_time && time_after(jiffies, stop_time))
 			break;
 	}
@@ -800,7 +796,6 @@ static long wb_writeback(struct bdi_writ
 	int fg_rounds = 0;
 	long wrote = 0;
 	long nr;
-	struct inode *inode;
 
 	/*
 	 * keep sync from extra jobs and livelock
@@ -840,7 +835,6 @@ static long wb_writeback(struct bdi_writ
 		if (args->for_background && !over_bground_thresh())
 			break;
 
-		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
 		wbc.pages_skipped = 0;
 		nr = writeback_inodes_wb(wb, &wbc);
@@ -863,11 +857,6 @@ static long wb_writeback(struct bdi_writ
 		}
 
 		/*
-		 * Bail if no more IO
-		 */
-		if (!wbc.more_io)
-			break;
-		/*
 		 * Did we write something? Try for more
 		 */
 		if (nr)
--- linux.orig/include/linux/writeback.h	2009-10-07 14:31:46.000000000 +0800
+++ linux/include/linux/writeback.h	2009-10-07 14:32:51.000000000 +0800
@@ -78,7 +78,6 @@ struct writeback_control {
 	unsigned for_sync:1;		/* A writeback for sync */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
-	unsigned more_io:1;		/* more io to be dispatched */
 	/*
 	 * write_cache_pages() won't update wbc->nr_to_write and
 	 * mapping->writeback_index if no_nrwrite_index_update
--- linux.orig/include/trace/events/ext4.h	2009-10-07 14:31:46.000000000 +0800
+++ linux/include/trace/events/ext4.h	2009-10-07 14:32:51.000000000 +0800
@@ -311,7 +311,6 @@ TRACE_EVENT(ext4_da_writepages_result,
 		__field(	int,	pages_written		)
 		__field(	long,	pages_skipped		)
 		__field(	char,	encountered_congestion	)
-		__field(	char,	more_io			)	
 		__field(	char,	no_nrwrite_index_update )
 		__field(       pgoff_t,	writeback_index		)
 	),
@@ -323,16 +322,15 @@ TRACE_EVENT(ext4_da_writepages_result,
 		__entry->pages_written	= pages_written;
 		__entry->pages_skipped	= wbc->pages_skipped;
 		__entry->encountered_congestion	= wbc->encountered_congestion;
-		__entry->more_io	= wbc->more_io;
 		__entry->no_nrwrite_index_update = wbc->no_nrwrite_index_update;
 		__entry->writeback_index = inode->i_mapping->writeback_index;
 	),
 
-	TP_printk("dev %s ino %lu ret %d pages_written %d pages_skipped %ld congestion %d more_io %d no_nrwrite_index_update %d writeback_index %lu",
+	TP_printk("dev %s ino %lu ret %d pages_written %d pages_skipped %ld congestion %d no_nrwrite_index_update %d writeback_index %lu",
 		  jbd2_dev_to_name(__entry->dev),
 		  (unsigned long) __entry->ino, __entry->ret,
 		  __entry->pages_written, __entry->pages_skipped,
-		  __entry->encountered_congestion, __entry->more_io,
+		  __entry->encountered_congestion,
 		  __entry->no_nrwrite_index_update,
 		  (unsigned long) __entry->writeback_index)
 );



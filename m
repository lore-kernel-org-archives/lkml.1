Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbZI3Fcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbZI3Fcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 01:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZI3Fcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 01:32:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:56971 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbZI3Fcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 01:32:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,478,1249282800"; 
   d="scan'208";a="193316214"
Date: Wed, 30 Sep 2009 13:32:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>
Subject: Re: regression in page writeback
Message-ID: <20090930053223.GA14368@localhost>
References: <20090924031508.GD6456@localhost> <20090925001117.GA9464@discord.disaster> <20090925003820.GK2662@think> <20090925050413.GC9464@discord.disaster> <20090925064503.GA30450@localhost> <20090928010700.GE9464@discord.disaster> <20090928071507.GA20068@localhost> <20090928130804.GA25880@infradead.org> <20090928140756.GC17514@mit.edu> <20090930052657.GA17268@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930052657.GA17268@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 01:26:57PM +0800, Wu Fengguang wrote:

> +#define MAX_WRITEBACK_PAGES     (128 * (20 - PAGE_CACHE_SHIFT))

Sorry for the silly mistake!

---
writeback: bump up writeback chunk size to 128MB

Adjust the writeback call stack to support larger writeback chunk size.

- make wbc.nr_to_write a per-file parameter
- init wbc.nr_to_write with MAX_WRITEBACK_PAGES=128MB
  (proposed by Ted)
- add wbc.nr_segments to limit seeks inside sparsely dirtied file
  (proposed by Chris)
- add wbc.timeout which will be used to control IO submission time
  either per-file or globally.
  
The wbc.nr_segments is now determined purely by logical page index
distance: if two pages are 1MB apart, it makes a new segment.

Filesystems could do this better with real extent knowledges.
One possible scheme is to record the previous page index in
wbc.writeback_index, and let ->writepage compare if the current and
previous pages lie in the same extent, and decrease wbc.nr_segments
accordingly. Care should taken to avoid double decreases in writepage
and write_cache_pages.

The wbc.timeout (when used per-file) is mainly a safeguard against slow
devices, which may take too long time to sync 128MB data.

The wbc.timeout (when used globally) could be useful when we decide to
do two sync scans on dirty pages and dirty metadata. XFS could say:
please return to sync dirty metadata after 10s. Would need another
b_io_metadata queue, but that's possible.

This work depends on the balance_dirty_pages() wait queue patch.

CC: Theodore Ts'o <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Dave Chinner <david@fromorbit.com> 
CC: Christoph Hellwig <hch@infradead.org>
CC: Jan Kara <jack@suse.cz> 
CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
CC: Jens Axboe <jens.axboe@oracle.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |   60 ++++++++++++++++++++++--------------
 fs/jbd2/commit.c          |    1 
 include/linux/writeback.h |   15 +++++++--
 mm/backing-dev.c          |    2 -
 mm/filemap.c              |    1 
 mm/page-writeback.c       |   13 +++++++
 6 files changed, 67 insertions(+), 25 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-30 12:17:15.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-30 13:29:24.000000000 +0800
@@ -31,6 +31,15 @@
 #define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
 
 /*
+ * The maximum number of pages to writeout in a single bdi flush/kupdate
+ * operation.  We do this so we don't hold I_SYNC against an inode for
+ * enormous amounts of time, which would block a userspace task which has
+ * been forced to throttle against that inode.  Also, the code reevaluates
+ * the dirty each time it has written this many pages.
+ */
+#define MAX_WRITEBACK_PAGES     (128 << (20 - PAGE_CACHE_SHIFT))
+
+/*
  * We don't actually have pdflush, but this one is exported though /proc...
  */
 int nr_pdflush_threads;
@@ -540,6 +549,14 @@ writeback_single_inode(struct inode *ino
 
 	spin_unlock(&inode_lock);
 
+	if (wbc->for_kupdate || wbc->for_background) {
+		wbc->nr_segments = 1;	/* TODO: test blk_queue_nonrot() */
+		wbc->timeout = HZ;
+	} else {
+		wbc->nr_segments = LONG_MAX;
+		wbc->timeout = 0;
+	}
+
 	ret = do_writepages(mapping, wbc);
 
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
@@ -564,7 +581,9 @@ writeback_single_inode(struct inode *ino
 			 * sometimes bales out without doing anything.
 			 */
 			inode->i_state |= I_DIRTY_PAGES;
-			if (wbc->nr_to_write <= 0) {
+			if (wbc->nr_to_write <= 0 ||
+			    wbc->nr_segments <= 0 ||
+			    wbc->timeout < 0) {
 				/*
 				 * slice used up: queue for next turn
 				 */
@@ -659,12 +678,17 @@ pinned:
 	return 0;
 }
 
-static void writeback_inodes_wb(struct bdi_writeback *wb,
+static long writeback_inodes_wb(struct bdi_writeback *wb,
 				struct writeback_control *wbc)
 {
 	struct super_block *sb = wbc->sb, *pin_sb = NULL;
 	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
 	const unsigned long start = jiffies;	/* livelock avoidance */
+	unsigned long stop_time = 0;
+	long wrote = 0;
+
+	if (wbc->timeout)
+		stop_time = (start + wbc->timeout) | 1;
 
 	spin_lock(&inode_lock);
 
@@ -721,7 +745,9 @@ static void writeback_inodes_wb(struct b
 		BUG_ON(inode->i_state & (I_FREEING | I_CLEAR));
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
+		wbc->nr_to_write = MAX_WRITEBACK_PAGES;
 		writeback_single_inode(inode, wbc);
+		wrote += MAX_WRITEBACK_PAGES - wbc->nr_to_write;
 		if (wbc->pages_skipped != pages_skipped) {
 			/*
 			 * writeback is not making progress due to locked
@@ -739,12 +765,15 @@ static void writeback_inodes_wb(struct b
 		}
 		if (!list_empty(&wb->b_more_io))
 			wbc->more_io = 1;
+		if (stop_time && time_after(jiffies, stop_time))
+			break;
 	}
 
 	unpin_sb_for_writeback(&pin_sb);
 
 	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
+	return wrote;
 }
 
 void writeback_inodes_wbc(struct writeback_control *wbc)
@@ -754,15 +783,6 @@ void writeback_inodes_wbc(struct writeba
 	writeback_inodes_wb(&bdi->wb, wbc);
 }
 
-/*
- * The maximum number of pages to writeout in a single bdi flush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
- */
-#define MAX_WRITEBACK_PAGES     1024
-
 static inline bool over_bground_thresh(void)
 {
 	unsigned long background_thresh, dirty_thresh;
@@ -797,10 +817,12 @@ static long wb_writeback(struct bdi_writ
 		.sync_mode		= args->sync_mode,
 		.older_than_this	= NULL,
 		.for_kupdate		= args->for_kupdate,
+		.for_background		= args->for_background,
 		.range_cyclic		= args->range_cyclic,
 	};
 	unsigned long oldest_jif;
 	long wrote = 0;
+	long nr;
 	struct inode *inode;
 
 	if (wbc.for_kupdate) {
@@ -834,26 +856,20 @@ static long wb_writeback(struct bdi_writ
 
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
--- linux.orig/include/linux/writeback.h	2009-09-30 12:13:00.000000000 +0800
+++ linux/include/linux/writeback.h	2009-09-30 12:17:17.000000000 +0800
@@ -32,10 +32,15 @@ struct writeback_control {
 	struct super_block *sb;		/* if !NULL, only write inodes from
 					   this super_block */
 	enum writeback_sync_modes sync_mode;
+	int timeout;
 	unsigned long *older_than_this;	/* If !NULL, only write back inodes
 					   older than this */
-	long nr_to_write;		/* Write this many pages, and decrement
-					   this for each page written */
+	long nr_to_write;		/* Max pages to write per file, and
+					   decrement this for each page written
+					 */
+	long nr_segments;		/* Max page segments to write per file,
+					   this is also a count down value
+					 */
 	long pages_skipped;		/* Pages which were not written */
 
 	/*
@@ -49,6 +54,7 @@ struct writeback_control {
 	unsigned nonblocking:1;		/* Don't get stuck on request queues */
 	unsigned encountered_congestion:1; /* An output: a queue is full */
 	unsigned for_kupdate:1;		/* A kupdate writeback */
+	unsigned for_background:1;	/* A background writeback */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned stop_on_wrap:1;	/* stop when write index is to wrap */
@@ -65,6 +71,11 @@ struct writeback_control {
 };
 
 /*
+ * if two page ranges are more than 1MB apart, they are taken as two segments.
+ */
+#define WB_SEGMENT_DIST		(1024 >> (PAGE_CACHE_SHIFT - 10))
+
+/*
  * fs/fs-writeback.c
  */	
 struct bdi_writeback;
--- linux.orig/mm/filemap.c	2009-09-30 12:13:00.000000000 +0800
+++ linux/mm/filemap.c	2009-09-30 12:17:17.000000000 +0800
@@ -216,6 +216,7 @@ int __filemap_fdatawrite_range(struct ad
 	struct writeback_control wbc = {
 		.sync_mode = sync_mode,
 		.nr_to_write = LONG_MAX,
+		.nr_segments = LONG_MAX,
 		.range_start = start,
 		.range_end = end,
 	};
--- linux.orig/mm/page-writeback.c	2009-09-30 12:17:15.000000000 +0800
+++ linux/mm/page-writeback.c	2009-09-30 12:17:17.000000000 +0800
@@ -765,6 +765,7 @@ int write_cache_pages(struct address_spa
 	int cycled;
 	int range_whole = 0;
 	long nr_to_write = wbc->nr_to_write;
+	unsigned long start_time = jiffies;
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
@@ -818,6 +819,12 @@ retry:
 				break;
 			}
 
+			if (done_index + WB_SEGMENT_DIST > page->index &&
+			    --wbc->nr_segments <= 0) {
+				done = 1;
+				break;
+			}
+
 			done_index = page->index + 1;
 
 			lock_page(page);
@@ -899,6 +906,12 @@ continue_unlock:
 		}
 		pagevec_release(&pvec);
 		cond_resched();
+		if (wbc->timeout &&
+		    time_after(jiffies, start_time + wbc->timeout)) {
+			wbc->timeout = -1;
+			done = 1;
+			break;
+		}
 	}
 	if (wbc->stop_on_wrap)
 		done_index = 0;
--- linux.orig/fs/jbd2/commit.c	2009-09-30 12:13:00.000000000 +0800
+++ linux/fs/jbd2/commit.c	2009-09-30 12:17:17.000000000 +0800
@@ -219,6 +219,7 @@ static int journal_submit_inode_data_buf
 	struct writeback_control wbc = {
 		.sync_mode =  WB_SYNC_ALL,
 		.nr_to_write = mapping->nrpages * 2,
+		.nr_segments = LONG_MAX,
 		.range_start = 0,
 		.range_end = i_size_read(mapping->host),
 	};
--- linux.orig/mm/backing-dev.c	2009-09-30 12:17:26.000000000 +0800
+++ linux/mm/backing-dev.c	2009-09-30 12:17:38.000000000 +0800
@@ -336,7 +336,7 @@ static void bdi_flush_io(struct backing_
 		.sync_mode		= WB_SYNC_NONE,
 		.older_than_this	= NULL,
 		.range_cyclic		= 1,
-		.nr_to_write		= 1024,
+		.timeout		= HZ,
 	};
 
 	writeback_inodes_wbc(&wbc);

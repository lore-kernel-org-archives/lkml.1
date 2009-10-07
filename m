Return-Path: <linux-kernel-owner+w=401wt.eu-S933922AbZJGILm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922AbZJGILm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbZJGILj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:11:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:9396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933841AbZJGIBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971494"
Message-Id: <20091007074904.720309585@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:46 +0800
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
Subject: [PATCH 28/45] writeback: introduce wbc.nr_segments
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-nr_segments.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbc.nr_segments serves two major purposes:

- fairness between two large files, one is continuously dirtied,
  another is sparsely dirtied. Given the same amount of dirty pages,
  it could take vastly different time to sync them to the _same_
  device. The nr_segments check helps to favor continuous data.
- avoid seeks/fragmentations. To give each file fair chance of
  writeback, we have to abort a file when some nr_to_write or timeout
  is reached. However they are both not good abort conditions.
  The best is for filesystem to abort earlier in seek boundaries,
  and treat nr_to_write/timeout as large enough bottom lines.

However a low nr_segments would be inefficient if all files are sparsely
dirtied. For example, it may be inefficient for the block device inodes,
which has lots of sparsely distributed metadata pages.

The wbc.nr_segments here is determined purely by logical page index
distance: if two pages are 1MB apart, it makes a new segment.

Filesystems could do this better with real extent knowledges.
One possible scheme is to record the previous page index in
wbc.writeback_index, and let ->writepage compare if the current and
previous pages lie in the same extent, and decrease wbc.nr_segments
accordingly. Care should taken to avoid double decreases in writepage
and write_cache_pages.

CC: Theodore Ts'o <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Dave Chinner <david@fromorbit.com> 
CC: Christoph Hellwig <hch@infradead.org>
CC: Jan Kara <jack@suse.cz> 
CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
CC: Jens Axboe <jens.axboe@oracle.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |    8 +++++++-
 fs/jbd2/commit.c          |    1 +
 include/linux/writeback.h |   10 +++++++++-
 mm/filemap.c              |    1 +
 mm/page-writeback.c       |    7 +++++++
 5 files changed, 25 insertions(+), 2 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-10-06 23:39:27.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:39:28.000000000 +0800
@@ -542,6 +542,11 @@ writeback_single_inode(struct inode *ino
 
 	spin_unlock(&inode_lock);
 
+	if (wbc->for_kupdate || wbc->for_background)
+		wbc->nr_segments = bdi_nonrot(wbc->bdi) ? 100 : 10;
+	else
+		wbc->nr_segments = LONG_MAX;
+
 	ret = do_writepages(mapping, wbc);
 
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
@@ -566,7 +571,8 @@ writeback_single_inode(struct inode *ino
 			 * sometimes bales out without doing anything.
 			 */
 			inode->i_state |= I_DIRTY_PAGES;
-			if (wbc->nr_to_write <= 0) {
+			if (wbc->nr_to_write <= 0 ||
+			    wbc->nr_segments <= 0) {
 				/*
 				 * slice used up: queue for next turn
 				 */
--- linux.orig/include/linux/writeback.h	2009-10-06 23:39:27.000000000 +0800
+++ linux/include/linux/writeback.h	2009-10-06 23:39:28.000000000 +0800
@@ -48,6 +48,9 @@ struct writeback_control {
 	long nr_to_write;		/* Max pages to write per file, and
 					   decrement this for each page written
 					 */
+	long nr_segments;		/* Max page segments to write per file,
+					   this is a count down value, too
+					 */
 	long pages_skipped;		/* Pages which were not written */
 
 	/*
@@ -77,8 +80,13 @@ struct writeback_control {
 };
 
 /*
+ * if two page ranges are more than 1MB apart, they are taken as two segments.
+ */
+#define WB_SEGMENT_DIST		(1024 >> (PAGE_CACHE_SHIFT - 10))
+
+/*
  * fs/fs-writeback.c
- */	
+ */
 struct bdi_writeback;
 int inode_wait(void *);
 void writeback_inodes_sb(struct super_block *);
--- linux.orig/mm/filemap.c	2009-10-06 23:37:43.000000000 +0800
+++ linux/mm/filemap.c	2009-10-06 23:39:28.000000000 +0800
@@ -216,6 +216,7 @@ int __filemap_fdatawrite_range(struct ad
 	struct writeback_control wbc = {
 		.sync_mode = sync_mode,
 		.nr_to_write = LONG_MAX,
+		.nr_segments = LONG_MAX,
 		.range_start = start,
 		.range_end = end,
 	};
--- linux.orig/mm/page-writeback.c	2009-10-06 23:38:43.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-06 23:39:28.000000000 +0800
@@ -805,6 +805,13 @@ int write_cache_pages(struct address_spa
 				break;
 			}
 
+			if (nr_to_write != wbc->nr_to_write &&
+			    done_index + WB_SEGMENT_DIST < page->index &&
+			    --wbc->nr_segments <= 0) {
+				done = 1;
+				break;
+			}
+
 			done_index = page->index + 1;
 
 			lock_page(page);
--- linux.orig/fs/jbd2/commit.c	2009-10-06 23:37:42.000000000 +0800
+++ linux/fs/jbd2/commit.c	2009-10-06 23:39:28.000000000 +0800
@@ -219,6 +219,7 @@ static int journal_submit_inode_data_buf
 	struct writeback_control wbc = {
 		.sync_mode =  WB_SYNC_ALL,
 		.nr_to_write = mapping->nrpages * 2,
+		.nr_segments = LONG_MAX,
 		.range_start = 0,
 		.range_end = i_size_read(mapping->host),
 	};



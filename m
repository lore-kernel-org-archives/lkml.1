Return-Path: <linux-kernel-owner+w=401wt.eu-S934011AbZJGIJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011AbZJGIJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933212AbZJGIJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:09:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:9396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933928AbZJGIBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="c'?scan'208";a="195971569"
Message-Id: <20091007074902.403846882@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:28 +0800
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
Subject: [PATCH 10/45] writeback: quit on wrap for .range_cyclic (btrfs)
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=linux_fs_btrfs_extent_io.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert wbc.range_cyclic to new behavior: when past EOF, abort writeback
of the inode, which instructs writeback_single_inode() to delay it for a
while if necessary.

It removes one inefficient .range_cyclic IO pattern when writeback_index
wraps:
	submit [10000-10100], (wrap), submit [0-100]
In which the submitted pages may be consisted of two distant ranges.

It also prevents submitting pointless IO for busy overwriters.

CC: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/btrfs/extent_io.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- linux.orig/fs/btrfs/extent_io.c	2009-10-06 23:37:49.000000000 +0800
+++ linux/fs/btrfs/extent_io.c	2009-10-06 23:38:32.000000000 +0800
@@ -2402,10 +2402,9 @@ static int extent_write_cache_pages(stru
 	int done = 0;
 	int nr_to_write_done = 0;
 	struct pagevec pvec;
-	int nr_pages;
+	int nr_pages = 1;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
-	int scanned = 0;
 	int range_whole = 0;
 
 	pagevec_init(&pvec, 0);
@@ -2417,16 +2416,14 @@ static int extent_write_cache_pages(stru
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		scanned = 1;
 	}
-retry:
+
 	while (!done && !nr_to_write_done && (index <= end) &&
 	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
 			      PAGECACHE_TAG_DIRTY, min(end - index,
 				  (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
 		unsigned i;
 
-		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
@@ -2447,7 +2444,7 @@ retry:
 				continue;
 			}
 
-			if (!wbc->range_cyclic && page->index > end) {
+			if (page->index > end) {
 				done = 1;
 				unlock_page(page);
 				continue;
@@ -2484,15 +2481,9 @@ retry:
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	if (!scanned && !done) {
-		/*
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		scanned = 1;
-		index = 0;
-		goto retry;
-	}
+	if (!nr_pages)
+		mapping->writeback_index = 0;
+
 	return ret;
 }
 



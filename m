Return-Path: <linux-kernel-owner+w=401wt.eu-S933979AbZJGIBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933979AbZJGIBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932717AbZJGIBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:28327 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933942AbZJGIBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="c'?scan'208";a="195971608"
Message-Id: <20091007074902.771858180@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:31 +0800
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
       Steven Whitehouse <swhiteho@redhat.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/45] writeback: quit on wrap for .range_cyclic (gfs2)
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=linux_fs_gfs2_aops.c
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

CC: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/gfs2/aops.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

--- linux.orig/fs/gfs2/aops.c	2009-10-06 23:37:48.000000000 +0800
+++ linux/fs/gfs2/aops.c	2009-10-06 23:38:41.000000000 +0800
@@ -287,7 +287,7 @@ static int gfs2_write_jdata_pagevec(stru
 			continue;
 		}
 
-		if (!wbc->range_cyclic && page->index > end) {
+		if (page->index > end) {
 			ret = 1;
 			unlock_page(page);
 			continue;
@@ -340,7 +340,6 @@ static int gfs2_write_cache_jdata(struct
 	int nr_pages;
 	pgoff_t index;
 	pgoff_t end;
-	int scanned = 0;
 	int range_whole = 0;
 
 	pagevec_init(&pvec, 0);
@@ -352,15 +351,12 @@ static int gfs2_write_cache_jdata(struct
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		scanned = 1;
 	}
 
-retry:
 	 while (!done && (index <= end) &&
 		(nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
 					       PAGECACHE_TAG_DIRTY,
 					       min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
-		scanned = 1;
 		ret = gfs2_write_jdata_pagevec(mapping, wbc, &pvec, nr_pages, end);
 		if (ret)
 			done = 1;
@@ -371,16 +367,8 @@ retry:
 		cond_resched();
 	}
 
-	if (!scanned && !done) {
-		/*
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		scanned = 1;
+	if (!nr_pages)
 		index = 0;
-		goto retry;
-	}
-
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 	return ret;



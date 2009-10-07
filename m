Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbZJGIAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbZJGIAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933086AbZJGIAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:00:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:9396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933076AbZJGIAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:00:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="c'?scan'208";a="195971174"
Message-Id: <20091007074902.268825252@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:27 +0800
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
       <linux-fsdevel@vger.kernel.org>, Evgeniy Polyakov <zbr@ioremap.net>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/45] writeback: quit on wrap for .range_cyclic (pohmelfs)
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=linux_drivers_staging_pohmelfs_inode.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert wbc.range_cyclic to new behavior: when past EOF, abort writeback
of the inode, which instructs writeback_single_inode() to delay it for 
a while if necessary.

It removes one inefficient .range_cyclic IO pattern when writeback_index
wraps:
	submit [10000-10100], (wrap), submit [0-100]
In which the submitted pages may be consisted of two distant ranges.

It also prevents submitting pointless IO for busy overwriters.

CC: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/staging/pohmelfs/inode.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- linux.orig/drivers/staging/pohmelfs/inode.c	2009-10-06 23:37:49.000000000 +0800
+++ linux/drivers/staging/pohmelfs/inode.c	2009-10-06 23:38:31.000000000 +0800
@@ -149,7 +149,6 @@ static int pohmelfs_writepages(struct ad
 	int nr_pages;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
-	int scanned = 0;
 	int range_whole = 0;
 
 	if (wbc->range_cyclic) {
@@ -160,17 +159,18 @@ static int pohmelfs_writepages(struct ad
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		scanned = 1;
 	}
-retry:
+
 	while (!done && (index <= end)) {
 		unsigned int i = min(end - index, (pgoff_t)psb->trans_max_pages);
 		int path_len;
 		struct netfs_trans *trans;
 
 		err = pohmelfs_inode_has_dirty_pages(mapping, index);
-		if (!err)
+		if (!err) {
+			index = 0;
 			break;
+		}
 
 		err = pohmelfs_path_length(pi);
 		if (err < 0)
@@ -197,15 +197,16 @@ retry:
 		dprintk("%s: t: %p, nr_pages: %u, end: %lu, index: %lu, max: %u.\n",
 				__func__, trans, nr_pages, end, index, trans->page_num);
 
-		if (!nr_pages)
+		if (!nr_pages) {
+			index = 0;
 			goto err_out_reset;
+		}
 
 		err = pohmelfs_write_inode_create(inode, trans);
 		if (err)
 			goto err_out_reset;
 
 		err = 0;
-		scanned = 1;
 
 		for (i = 0; i < trans->page_num; i++) {
 			struct page *page = trans->pages[i];
@@ -215,7 +216,7 @@ retry:
 			if (unlikely(page->mapping != mapping))
 				goto out_continue;
 
-			if (!wbc->range_cyclic && page->index > end) {
+			if (page->index > end) {
 				done = 1;
 				goto out_continue;
 			}
@@ -263,16 +264,6 @@ err_out_reset:
 		break;
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
-
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 



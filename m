Return-Path: <linux-kernel-owner+w=401wt.eu-S934032AbZJGICh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbZJGICh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934021AbZJGICb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:02:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:9396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758733AbZJGIC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:02:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="c'?scan'208";a="195971869"
Message-Id: <20091007074902.144336866@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:26 +0800
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
       Christoph Lameter <cl@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/45] writeback: quit on wrap for .range_cyclic (write_cache_pages)
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=linux_mm_page-writeback.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert wbc.range_cyclic to new behavior: when past EOF, abort the
writeback of the current inode, which instructs writeback_single_inode()
to delay it for a while if necessary. 

This is the right behavior for
- sync writeback (is already so with range_whole)
  we have scanned the inode address space, and don't care any more newly
  dirtied pages. So shall update its i_dirtied_when and exclude it from
  the todo list.
- periodic writeback
  any more newly dirtied pages may be delayed for a while.
  This also prevents pointless IO for busy overwriters.
- background writeback
  irrelevant because it generally don't care the dirty timestamp.

That should get rid of one inefficient IO pattern of .range_cyclic when
writeback_index wraps, in which the submitted pages may be consisted of
two distant ranges: submit [10000-10100], (wrap), submit [0-100].

CC: Christoph Lameter <cl@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Jens Axboe <jens.axboe@oracle.com>
CC: Nick Piggin <npiggin@suse.de>
CC: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-10-06 23:38:18.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-06 23:38:30.000000000 +0800
@@ -789,31 +789,23 @@ int write_cache_pages(struct address_spa
 	int done = 0;
 	struct pagevec pvec;
 	int nr_pages;
-	pgoff_t uninitialized_var(writeback_index);
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	pgoff_t done_index;
-	int cycled;
 	int range_whole = 0;
 	long nr_to_write = wbc->nr_to_write;
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
-		writeback_index = mapping->writeback_index; /* prev offset */
-		index = writeback_index;
-		if (index == 0)
-			cycled = 1;
-		else
-			cycled = 0;
+		index = mapping->writeback_index; /* prev offset */
 		end = -1;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		cycled = 1; /* ignore range_cyclic tests */
 	}
-retry:
+
 	done_index = index;
 	while (!done && (index <= end)) {
 		int i;
@@ -821,8 +813,10 @@ retry:
 		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
 			      PAGECACHE_TAG_DIRTY,
 			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
-		if (nr_pages == 0)
+		if (nr_pages == 0) {
+			done_index = 0;
 			break;
+		}
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
@@ -919,17 +913,6 @@ continue_unlock:
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	if (!cycled && !done) {
-		/*
-		 * range_cyclic:
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		cycled = 1;
-		index = 0;
-		end = writeback_index - 1;
-		goto retry;
-	}
 	if (!wbc->no_nrwrite_index_update) {
 		if (wbc->range_cyclic || (range_whole && nr_to_write > 0))
 			mapping->writeback_index = done_index;



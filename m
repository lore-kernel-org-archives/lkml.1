Return-Path: <linux-kernel-owner+w=401wt.eu-S933447AbZJGIBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbZJGIBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbZJGIBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:1895 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933279AbZJGIBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971196"
Message-Id: <20091007074905.030106774@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:48 +0800
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
Subject: [PATCH 30/45] vmscan: lumpy pageout
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-lumpy-pageout.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pageout a dirty page, try to piggy back more consecutive dirty
pages (up to 512KB) to improve IO efficiency.

Only ext3/reiserfs which don't have its own aops->writepages are
supported in this initial version.

CC: Dave Chinner <david@fromorbit.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   12 ++++++++++++
 mm/vmscan.c         |   11 +++++++++++
 2 files changed, 23 insertions(+)

--- linux.orig/mm/vmscan.c	2009-10-06 23:37:39.000000000 +0800
+++ linux/mm/vmscan.c	2009-10-06 23:39:30.000000000 +0800
@@ -344,6 +344,8 @@ typedef enum {
 	PAGE_CLEAN,
 } pageout_t;
 
+#define LUMPY_PAGEOUT_PAGES	(512 * 1024 / PAGE_CACHE_SIZE)
+
 /*
  * pageout is called by shrink_page_list() for each dirty page.
  * Calls ->writepage().
@@ -409,6 +411,15 @@ static pageout_t pageout(struct page *pa
 		}
 
 		/*
+		 * only write_cache_pages() supports for_reclaim for now
+		 */
+		if (!mapping->a_ops->writepages) {
+			wbc.range_start = (page->index + 1) << PAGE_CACHE_SHIFT;
+			wbc.nr_to_write = LUMPY_PAGEOUT_PAGES - 1;
+			generic_writepages(mapping, &wbc);
+		}
+
+		/*
 		 * Wait on writeback if requested to. This happens when
 		 * direct reclaiming a large contiguous area and the
 		 * first attempt to free a range of pages fails.
--- linux.orig/mm/page-writeback.c	2009-10-06 23:39:29.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-06 23:39:30.000000000 +0800
@@ -805,6 +805,11 @@ int write_cache_pages(struct address_spa
 				break;
 			}
 
+			if (wbc->for_reclaim && done_index != page->index) {
+				done = 1;
+				break;
+			}
+
 			if (nr_to_write != wbc->nr_to_write &&
 			    done_index + WB_SEGMENT_DIST < page->index &&
 			    --wbc->nr_segments <= 0) {
@@ -846,6 +851,13 @@ continue_unlock:
 			if (!clear_page_dirty_for_io(page))
 				goto continue_unlock;
 
+			/*
+			 * active and unevictable pages will be checked at
+			 * rotate time
+			 */
+			if (wbc->for_reclaim)
+				SetPageReclaim(page);
+
 			ret = (*writepage)(page, wbc, data);
 			if (unlikely(ret)) {
 				if (ret == AOP_WRITEPAGE_ACTIVATE) {



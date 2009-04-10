Return-Path: <linux-kernel-owner+w=401wt.eu-S937151AbZDJGSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937151AbZDJGSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935755AbZDJGQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:16:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:28520 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933598AbZDJGQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:16:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,165,1239001200"; 
   d="scan'208";a="130013423"
Message-Id: <20090410061255.041947147@intel.com>
References: <20090410060957.442203404@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 10 Apr 2009 14:10:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ying Han <yinghan@google.com>
Subject: [PATCH 9/9] readahead: record mmap read-around states in file_ra_state
Content-Disposition: inline; filename=readahead-mmap-readaround-use-ra_submit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mmap read-around now shares the same code style and data structure
with readahead code.

This also removes do_page_cache_readahead().
Its last user, mmap read-around, has been changed to call ra_submit().

The no-readahead-if-congested logic is dumped by the way.
Users will be pretty sensitive about the slow loading of executables.
So it's unfavorable to disabled mmap read-around on a congested queue.

Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/mm.h |    5 +++--
 mm/filemap.c       |   12 +++++++-----
 mm/readahead.c     |   23 ++---------------------
 3 files changed, 12 insertions(+), 28 deletions(-)

--- mm.orig/mm/filemap.c
+++ mm/mm/filemap.c
@@ -1487,13 +1487,15 @@ static void do_sync_mmap_readahead(struc
 	if (ra->mmap_miss > MMAP_LOTSAMISS)
 		return;
 
+	/*
+	 * mmap read-around
+	 */
 	ra_pages = max_sane_readahead(ra->ra_pages);
 	if (ra_pages) {
-		pgoff_t start = 0;
-
-		if (offset > ra_pages / 2)
-			start = offset - ra_pages / 2;
-		do_page_cache_readahead(mapping, file, start, ra_pages);
+		ra->start = max_t(long, 0, offset - ra_pages/2);
+		ra->size = ra_pages;
+		ra->async_size = 0;
+		ra_submit(ra, mapping, file);
 	}
 }
 
--- mm.orig/include/linux/mm.h
+++ mm/include/linux/mm.h
@@ -1181,8 +1181,6 @@ void task_dirty_inc(struct task_struct *
 #define VM_MAX_READAHEAD	128	/* kbytes */
 #define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
 
-int do_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			pgoff_t offset, unsigned long nr_to_read);
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
 
@@ -1200,6 +1198,9 @@ void page_cache_async_readahead(struct a
 				unsigned long size);
 
 unsigned long max_sane_readahead(unsigned long nr);
+unsigned long ra_submit(struct file_ra_state *ra,
+		        struct address_space *mapping,
+			struct file *filp);
 
 /* Do stack extension */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
--- mm.orig/mm/readahead.c
+++ mm/mm/readahead.c
@@ -133,15 +133,12 @@ out:
 }
 
 /*
- * do_page_cache_readahead actually reads a chunk of disk.  It allocates all
+ * __do_page_cache_readahead() actually reads a chunk of disk.  It allocates all
  * the pages first, then submits them all for I/O. This avoids the very bad
  * behaviour which would occur if page allocations are causing VM writeback.
  * We really don't want to intermingle reads and writes like that.
  *
  * Returns the number of pages requested, or the maximum amount of I/O allowed.
- *
- * do_page_cache_readahead() returns -1 if it encountered request queue
- * congestion.
  */
 static int
 __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
@@ -232,22 +229,6 @@ int force_page_cache_readahead(struct ad
 }
 
 /*
- * This version skips the IO if the queue is read-congested, and will tell the
- * block layer to abandon the readahead if request allocation would block.
- *
- * force_page_cache_readahead() will ignore queue congestion and will block on
- * request queues.
- */
-int do_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			pgoff_t offset, unsigned long nr_to_read)
-{
-	if (bdi_read_congested(mapping->backing_dev_info))
-		return -1;
-
-	return __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
-}
-
-/*
  * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
  * sensible upper limit.
  */
@@ -260,7 +241,7 @@ unsigned long max_sane_readahead(unsigne
 /*
  * Submit IO for the read-ahead request in file_ra_state.
  */
-static unsigned long ra_submit(struct file_ra_state *ra,
+unsigned long ra_submit(struct file_ra_state *ra,
 		       struct address_space *mapping, struct file *filp)
 {
 	int actual;

-- 


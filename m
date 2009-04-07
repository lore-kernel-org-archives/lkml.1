Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZDGMCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZDGMCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbZDGMA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:00:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:7786 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbZDGMAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:00:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,337,1235980800"; 
   d="scan'208";a="128748692"
Message-Id: <20090407115235.345682017@intel.com>
References: <20090407115039.780820496@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Apr 2009 19:50:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rohit Seth <rohitseth@google.com>
Cc: Edwin <edwintorok@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ying Han <yinghan@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 14/14] readahead: record mmap read-around states in file_ra_state
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
@@ -1556,13 +1556,15 @@ static void do_sync_mmap_readahead(struc
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
@@ -1183,8 +1183,6 @@ void task_dirty_inc(struct task_struct *
 #define VM_MAX_READAHEAD	128	/* kbytes */
 #define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
 
-int do_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			pgoff_t offset, unsigned long nr_to_read);
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
 
@@ -1202,6 +1200,9 @@ void page_cache_async_readahead(struct a
 				unsigned long size);
 
 unsigned long max_sane_readahead(unsigned long nr);
+unsigned long ra_submit(struct file_ra_state *ra,
+		        struct address_space *mapping,
+			struct file *filp);
 
 /* Do stack extension */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
--- mm.orig/mm/readahead.c
+++ mm/mm/readahead.c
@@ -146,15 +146,12 @@ out:
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
@@ -245,22 +242,6 @@ int force_page_cache_readahead(struct ad
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
@@ -285,7 +266,7 @@ subsys_initcall(readahead_init);
 /*
  * Submit IO for the read-ahead request in file_ra_state.
  */
-static unsigned long ra_submit(struct file_ra_state *ra,
+unsigned long ra_submit(struct file_ra_state *ra,
 		       struct address_space *mapping, struct file *filp)
 {
 	int actual;

-- 


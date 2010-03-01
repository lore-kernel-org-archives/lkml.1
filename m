Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab0CAFi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 00:38:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:11799 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab0CAFh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 00:37:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,557,1262592000"; 
   d="scan'208";a="544789719"
Message-Id: <20100301053621.518486546@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 01 Mar 2010 13:27:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Clemens Ladisch <clemens@ladisch.de>
CC: Olivier Galibert <galibert@pobox.com>
cc: Vivek Goyal <vgoyal@redhat.com>
cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
cc: Matt Mackall <mpm@selenic.com>
CC: Nick Piggin <npiggin@suse.de>
cc: Linux Memory Management List <linux-mm@kvack.org>
CC: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/16] readahead: record readahead patterns
References: <20100301052651.857984880@intel.com>
Content-Disposition: inline; filename=readahead-tracepoints.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record the readahead pattern in ra_flags. This info can be examined by
users via the readahead tracing/stats interfaces.

Currently 7 patterns are defined:

      	pattern			readahead for
-----------------------------------------------------------
	RA_PATTERN_INITIAL	start-of-file/oversize read
	RA_PATTERN_SUBSEQUENT	trivial     sequential read
	RA_PATTERN_CONTEXT	interleaved sequential read
	RA_PATTERN_THRASH	thrashed    sequential read
	RA_PATTERN_MMAP_AROUND	mmap fault
	RA_PATTERN_FADVISE	posix_fadvise()
	RA_PATTERN_RANDOM	random read

CC: Ingo Molnar <mingo@elte.hu> 
CC: Jens Axboe <jens.axboe@oracle.com> 
CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/fs.h |   32 ++++++++++++++++++++++++++++++++
 include/linux/mm.h |    4 +++-
 mm/filemap.c       |    9 +++++++--
 mm/readahead.c     |   13 +++++++++++--
 4 files changed, 53 insertions(+), 5 deletions(-)

--- linux.orig/include/linux/fs.h	2010-03-01 13:23:38.000000000 +0800
+++ linux/include/linux/fs.h	2010-03-01 13:23:42.000000000 +0800
@@ -894,8 +894,40 @@ struct file_ra_state {
 };
 
 /* ra_flags bits */
+#define READAHEAD_PATTERN_SHIFT	20
+#define READAHEAD_PATTERN	0x00f00000
 #define	READAHEAD_MMAP_MISS	0x00000fff /* cache misses for mmap access */
 #define READAHEAD_THRASHED	0x10000000
+#define	READAHEAD_MMAP		0x20000000
+
+/*
+ * Which policy makes decision to do the current read-ahead IO?
+ */
+enum readahead_pattern {
+	RA_PATTERN_INITIAL,
+	RA_PATTERN_SUBSEQUENT,
+	RA_PATTERN_CONTEXT,
+	RA_PATTERN_THRASH,
+	RA_PATTERN_MMAP_AROUND,
+	RA_PATTERN_FADVISE,
+	RA_PATTERN_RANDOM,
+	RA_PATTERN_ALL,		/* for summary stats */
+	RA_PATTERN_MAX
+};
+
+static inline int ra_pattern(int ra_flags)
+{
+	int pattern = (ra_flags & READAHEAD_PATTERN)
+			       >> READAHEAD_PATTERN_SHIFT;
+
+	return min(pattern, RA_PATTERN_ALL);
+}
+
+static inline void ra_set_pattern(struct file_ra_state *ra, int pattern)
+{
+	ra->ra_flags = (ra->ra_flags & ~READAHEAD_PATTERN) |
+			    (pattern << READAHEAD_PATTERN_SHIFT);
+}
 
 /*
  * Don't do ra_flags++ directly to avoid possible overflow:
--- linux.orig/mm/readahead.c	2010-03-01 13:23:38.000000000 +0800
+++ linux/mm/readahead.c	2010-03-01 13:23:42.000000000 +0800
@@ -337,7 +337,10 @@ unsigned long max_sane_readahead(unsigne
  * Submit IO for the read-ahead request in file_ra_state.
  */
 unsigned long ra_submit(struct file_ra_state *ra,
-		       struct address_space *mapping, struct file *filp)
+			struct address_space *mapping,
+			struct file *filp,
+			pgoff_t offset,
+			unsigned long req_size)
 {
 	int actual;
 
@@ -471,6 +474,7 @@ ondemand_readahead(struct address_space 
 	 * start of file
 	 */
 	if (!offset) {
+		ra_set_pattern(ra, RA_PATTERN_INITIAL);
 		ra->start = offset;
 		ra->size = get_init_ra_size(req_size, max);
 		ra->async_size = ra->size > req_size ?
@@ -491,6 +495,7 @@ ondemand_readahead(struct address_space 
 	 */
 	if ((offset == (ra->start + ra->size - ra->async_size) ||
 	     offset == (ra->start + ra->size))) {
+		ra_set_pattern(ra, RA_PATTERN_SUBSEQUENT);
 		ra->start += ra->size;
 		ra->size = get_next_ra_size(ra, max);
 		ra->async_size = ra->size;
@@ -501,6 +506,7 @@ ondemand_readahead(struct address_space 
 	 * oversize read, no need to query page cache
 	 */
 	if (req_size > max && !hit_readahead_marker) {
+		ra_set_pattern(ra, RA_PATTERN_INITIAL);
 		ra->start = offset;
 		ra->size = max;
 		ra->async_size = max;
@@ -546,8 +552,10 @@ context_readahead:
 	 */
 	if (!tt && !hit_readahead_marker) {
 		if (!ra_thrashed(ra, offset)) {
+			ra_set_pattern(ra, RA_PATTERN_RANDOM);
 			ra->size = min(req_size, max);
 		} else {
+			ra_set_pattern(ra, RA_PATTERN_THRASH);
 			retain_inactive_pages(mapping, offset, min(2 * max,
 						ra->start + ra->size - offset));
 			ra->size = max_t(int, ra->size/2, MIN_READAHEAD_PAGES);
@@ -569,6 +577,7 @@ context_readahead:
 	if (tt <= start - offset)
 		return 0;
 
+	ra_set_pattern(ra, RA_PATTERN_CONTEXT);
 	ra->start = start;
 	ra->size = clamp_t(unsigned int, tt - (start - offset),
 			   MIN_READAHEAD_PAGES, max);
@@ -586,7 +595,7 @@ readit:
 		ra->size += ra->async_size;
 	}
 
-	return ra_submit(ra, mapping, filp);
+	return ra_submit(ra, mapping, filp, offset, req_size);
 }
 
 /**
--- linux.orig/include/linux/mm.h	2010-03-01 13:21:44.000000000 +0800
+++ linux/include/linux/mm.h	2010-03-01 13:23:42.000000000 +0800
@@ -1208,7 +1208,9 @@ void page_cache_async_readahead(struct a
 unsigned long max_sane_readahead(unsigned long nr);
 unsigned long ra_submit(struct file_ra_state *ra,
 			struct address_space *mapping,
-			struct file *filp);
+			struct file *filp,
+			pgoff_t offset,
+			unsigned long req_size);
 
 /* Do stack extension */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
--- linux.orig/mm/filemap.c	2010-03-01 13:21:44.000000000 +0800
+++ linux/mm/filemap.c	2010-03-01 13:23:42.000000000 +0800
@@ -1413,6 +1413,7 @@ static void do_sync_mmap_readahead(struc
 
 	if (VM_SequentialReadHint(vma) ||
 			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
+		ra->ra_flags |= READAHEAD_MMAP;
 		page_cache_sync_readahead(mapping, ra, file, offset,
 					  ra->ra_pages);
 		return;
@@ -1433,10 +1434,12 @@ static void do_sync_mmap_readahead(struc
 			 ra->ra_pages,
 			 roundup_pow_of_two(totalram_pages / 1024));
 	if (ra_pages) {
+		ra->ra_flags |= READAHEAD_MMAP;
+		ra_set_pattern(ra, RA_PATTERN_MMAP_AROUND);
 		ra->start = max_t(long, 0, offset - ra_pages/2);
 		ra->size = ra_pages;
 		ra->async_size = 0;
-		ra_submit(ra, mapping, file);
+		ra_submit(ra, mapping, file, offset, 1);
 	}
 }
 
@@ -1456,9 +1459,11 @@ static void do_async_mmap_readahead(stru
 	if (VM_RandomReadHint(vma))
 		return;
 	ra_mmap_miss_dec(ra);
-	if (PageReadahead(page))
+	if (PageReadahead(page)) {
+		ra->ra_flags |= READAHEAD_MMAP;
 		page_cache_async_readahead(mapping, ra, file,
 					   page, offset, ra->ra_pages);
+	}
 }
 
 /**



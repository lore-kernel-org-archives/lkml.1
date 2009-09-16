Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbZIPK3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbZIPK3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758847AbZIPK3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:29:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:30866 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbZIPK3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:29:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,397,1249282800"; 
   d="scan'208";a="188224414"
Message-Id: <20090916100657.628953865@intel.com>
References: <20090916100119.275066569@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Sep 2009 18:01:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 6/8] page-types: make voffset local variables
Content-Disposition: inline; filename=page-types-voffset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/vm/page-types.c |   39 +++++++++++++++++---------------
 1 file changed, 21 insertions(+), 18 deletions(-)

--- linux-mm.orig/Documentation/vm/page-types.c	2009-09-16 17:25:07.000000000 +0800
+++ linux-mm/Documentation/vm/page-types.c	2009-09-16 17:53:36.000000000 +0800
@@ -159,7 +159,6 @@ static unsigned long	opt_size[MAX_ADDR_R
 static int		nr_vmas;
 static unsigned long	pg_start[MAX_VMAS];
 static unsigned long	pg_end[MAX_VMAS];
-static unsigned long	voffset;
 
 #define MAX_BIT_FILTERS	64
 static int		nr_bit_filters;
@@ -328,7 +327,8 @@ static char *page_flag_longname(uint64_t
  * page list and summary
  */
 
-static void show_page_range(unsigned long offset, uint64_t flags)
+static void show_page_range(unsigned long voffset,
+			    unsigned long offset, uint64_t flags)
 {
 	static uint64_t      flags0;
 	static unsigned long voff;
@@ -354,7 +354,8 @@ static void show_page_range(unsigned lon
 	count  = 1;
 }
 
-static void show_page(unsigned long offset, uint64_t flags)
+static void show_page(unsigned long voffset,
+		      unsigned long offset, uint64_t flags)
 {
 	if (opt_pid)
 		printf("%lx\t", voffset);
@@ -435,7 +436,6 @@ static uint64_t well_known_flags(uint64_
 	return flags;
 }
 
-
 /*
  * page frame walker
  */
@@ -467,7 +467,8 @@ static int hash_slot(uint64_t flags)
 	exit(EXIT_FAILURE);
 }
 
-static void add_page(unsigned long offset, uint64_t flags)
+static void add_page(unsigned long voffset,
+		     unsigned long offset, uint64_t flags)
 {
 	flags = expand_overloaded_flags(flags);
 
@@ -478,16 +479,18 @@ static void add_page(unsigned long offse
 		return;
 
 	if (opt_list == 1)
-		show_page_range(offset, flags);
+		show_page_range(voffset, offset, flags);
 	else if (opt_list == 2)
-		show_page(offset, flags);
+		show_page(voffset, offset, flags);
 
 	nr_pages[hash_slot(flags)]++;
 	total_pages++;
 }
 
 #define KPAGEFLAGS_BATCH	(64 << 10)	/* 64k pages */
-static void walk_pfn(unsigned long index, unsigned long count)
+static void walk_pfn(unsigned long voffset,
+		     unsigned long index,
+		     unsigned long count)
 {
 	uint64_t buf[KPAGEFLAGS_BATCH];
 	unsigned long batch;
@@ -501,7 +504,7 @@ static void walk_pfn(unsigned long index
 			break;
 
 		for (i = 0; i < pages; i++)
-			add_page(index + i, buf[i]);
+			add_page(voffset + i, index + i, buf[i]);
 
 		index += pages;
 		count -= pages;
@@ -525,9 +528,8 @@ static void walk_vma(unsigned long index
 
 		for (i = 0; i < pages; i++) {
 			pfn = pagemap_pfn(buf[i]);
-			voffset = index + i;
 			if (pfn)
-				walk_pfn(pfn, 1);
+				walk_pfn(index + i, pfn, 1);
 		}
 
 		index += pages;
@@ -537,8 +539,9 @@ static void walk_vma(unsigned long index
 
 static void walk_task(unsigned long index, unsigned long count)
 {
-	int i = 0;
 	const unsigned long end = index + count;
+	unsigned long start;
+	int i = 0;
 
 	while (index < end) {
 
@@ -548,11 +551,11 @@ static void walk_task(unsigned long inde
 		if (pg_start[i] >= end)
 			return;
 
-		voffset = max_t(unsigned long, pg_start[i], index);
-		index   = min_t(unsigned long, pg_end[i], end);
+		start = max_t(unsigned long, pg_start[i], index);
+		index = min_t(unsigned long, pg_end[i], end);
 
-		assert(voffset < index);
-		walk_vma(voffset, index - voffset);
+		assert(start < index);
+		walk_vma(start, index - start);
 	}
 }
 
@@ -577,7 +580,7 @@ static void walk_addr_ranges(void)
 
 	for (i = 0; i < nr_addr_ranges; i++)
 		if (!opt_pid)
-			walk_pfn(opt_offset[i], opt_size[i]);
+			walk_pfn(0, opt_offset[i], opt_size[i]);
 		else
 			walk_task(opt_offset[i], opt_size[i]);
 
@@ -879,7 +882,7 @@ int main(int argc, char *argv[])
 	walk_addr_ranges();
 
 	if (opt_list == 1)
-		show_page_range(0, 0);  /* drain the buffer */
+		show_page_range(0, 0, 0);  /* drain the buffer */
 
 	if (opt_no_summary)
 		return 0;

-- 


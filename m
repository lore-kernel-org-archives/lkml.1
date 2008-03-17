Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYCQI4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYCQI4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 04:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYCQI4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 04:56:10 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:25916 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbYCQI4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 04:56:09 -0400
Date: Mon, 17 Mar 2008 09:56:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, pj@sgi.com,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [11/18] Fix alignment bug in bootmem allocator
Message-ID: <20080317085604.GA12405@basil.nowhere.org>
References: <20080317258.659191058@firstfloor.org> <20080317015825.0C0171B41E0@basil.firstfloor.org> <86802c440803161919h20ed9f78k6e3798ef56668638@mail.gmail.com> <20080317070208.GC27015@one.firstfloor.org> <86802c440803170017r622114bdpede8625d1a8ff585@mail.gmail.com> <86802c440803170031u75167e5m301f65049b6d62ff@mail.gmail.com> <20080317074146.GG27015@one.firstfloor.org> <86802c440803170053n32a1c918h2ff2a32abef44050@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803170053n32a1c918h2ff2a32abef44050@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 17 Mar 2008 08:49:30.0084 (UTC) FILETIME=[D04DDA40:01C8880B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> only happen when align is large than alignment of node_boot_start.

Here's an updated version of the patch with this addressed.
Please review. The patch is somewhat more complicated, but
actually makes the code a little cleaner now.

-Andi


Fix alignment bug in bootmem allocator

Without this fix bootmem can return unaligned addresses when the start of a
node is not aligned to the align value. Needed for reliably allocating
gigabyte pages.

I removed the offset variable because all tests should align themself correctly
now. Slight drawback might be that the bootmem allocator will spend
some more time skipping bits in the bitmap initially, but that shouldn't
be a big issue.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 mm/bootmem.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

Index: linux/mm/bootmem.c
===================================================================
--- linux.orig/mm/bootmem.c
+++ linux/mm/bootmem.c
@@ -195,8 +195,9 @@ void * __init
 __alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
 	      unsigned long align, unsigned long goal, unsigned long limit)
 {
-	unsigned long offset, remaining_size, areasize, preferred;
-	unsigned long i, start = 0, incr, eidx, end_pfn;
+	unsigned long remaining_size, areasize, preferred;
+	unsigned long i, start, incr, eidx, end_pfn;
+	unsigned long pfn;
 	void *ret;
 
 	if (!size) {
@@ -218,10 +219,6 @@ __alloc_bootmem_core(struct bootmem_data
 		end_pfn = limit;
 
 	eidx = end_pfn - PFN_DOWN(bdata->node_boot_start);
-	offset = 0;
-	if (align && (bdata->node_boot_start & (align - 1UL)) != 0)
-		offset = align - (bdata->node_boot_start & (align - 1UL));
-	offset = PFN_DOWN(offset);
 
 	/*
 	 * We try to allocate bootmem pages above 'goal'
@@ -236,15 +233,18 @@ __alloc_bootmem_core(struct bootmem_data
 	} else
 		preferred = 0;
 
-	preferred = PFN_DOWN(ALIGN(preferred, align)) + offset;
+	start = bdata->node_boot_start;
+	preferred = PFN_DOWN(ALIGN(preferred + start, align) - start);
 	areasize = (size + PAGE_SIZE-1) / PAGE_SIZE;
 	incr = align >> PAGE_SHIFT ? : 1;
+	pfn = PFN_DOWN(start);
+	start = 0;
 
 restart_scan:
 	for (i = preferred; i < eidx; i += incr) {
 		unsigned long j;
 		i = find_next_zero_bit(bdata->node_bootmem_map, eidx, i);
-		i = ALIGN(i, incr);
+		i = ALIGN(pfn + i, incr) - pfn;
 		if (i >= eidx)
 			break;
 		if (test_bit(i, bdata->node_bootmem_map))
@@ -258,11 +258,11 @@ restart_scan:
 		start = i;
 		goto found;
 	fail_block:
-		i = ALIGN(j, incr);
+		i = ALIGN(j + pfn, incr) - pfn;
 	}
 
-	if (preferred > offset) {
-		preferred = offset;
+	if (preferred > 0) {
+		preferred = 0;
 		goto restart_scan;
 	}
 	return NULL;
@@ -278,7 +278,7 @@ found:
 	 */
 	if (align < PAGE_SIZE &&
 	    bdata->last_offset && bdata->last_pos+1 == start) {
-		offset = ALIGN(bdata->last_offset, align);
+		unsigned long offset = ALIGN(bdata->last_offset, align);
 		BUG_ON(offset > PAGE_SIZE);
 		remaining_size = PAGE_SIZE - offset;
 		if (size < remaining_size) {

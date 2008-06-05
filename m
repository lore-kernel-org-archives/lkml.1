Return-Path: <linux-kernel-owner+w=401wt.eu-S1763687AbYFEXLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763687AbYFEXLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 19:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763543AbYFEXIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 19:08:32 -0400
Received: from saeurebad.de ([85.214.36.134]:38641 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763533AbYFEXIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 19:08:31 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun  6 00:57:21 2008
Message-Id: <20080605225721.035329886@saeurebad.de>
References: <20080605224940.434439989@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 00:49:51 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 11/14] bootmem: respect goal more likely
Content-Disposition: inline; filename=bootmem-respect-goal-more-likely.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old node-agnostic code tried allocating on all nodes starting from
the one with the lowest range.  alloc_bootmem_core retried without the
goal if it could not satisfy it and so the goal was only respected at
all when it happened to be on the first (lowest page numbers) node (or
theoretically if allocations failed on all nodes before to the one
holding the goal).

Introduce a non-panicking helper that starts allocating from the node
holding the goal and falls back only after all thes tries failed, thus
moving the goal fallback code out of alloc_bootmem_core.

Make all other allocation functions benefit from this new helper.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>
---

 mm/bootmem.c |   92 ++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 54 insertions(+), 38 deletions(-)

--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -408,6 +408,7 @@ static void * __init alloc_bootmem_core(
 				unsigned long size, unsigned long align,
 				unsigned long goal, unsigned long limit)
 {
+	unsigned long fallback = 0;
 	unsigned long min, max, start, sidx, midx, step;
 
 	BUG_ON(!size);
@@ -443,8 +444,11 @@ static void * __init alloc_bootmem_core(
 	midx = max - PFN_DOWN(bdata->node_boot_start);
 
 	if (bdata->hint_idx > sidx) {
-		/* Make sure we retry on failure */
-		goal = 1;
+		/*
+		 * Handle the valid case of sidx being zero and still
+		 * catch the fallback below.
+		 */
+		fallback = sidx + 1;
 		sidx = ALIGN(bdata->hint_idx, step);
 	}
 
@@ -492,10 +496,39 @@ find_block:
 		return region;
 	}
 
+	if (fallback) {
+		sidx = ALIGN(fallback - 1, step);
+		fallback = 0;
+		goto find_block;
+	}
+
+	return NULL;
+}
+
+static void * __init ___alloc_bootmem_nopanic(unsigned long size,
+					unsigned long align,
+					unsigned long goal,
+					unsigned long limit)
+{
+	bootmem_data_t *bdata;
+
+restart:
+	list_for_each_entry(bdata, &bdata_list, list) {
+		void *region;
+
+		if (goal && bdata->node_low_pfn <= PFN_DOWN(goal))
+			continue;
+		if (limit && bdata->node_boot_start >= limit)
+			break;
+
+		region = alloc_bootmem_core(bdata, size, align, goal, limit);
+		if (region)
+			return region;
+	}
+
 	if (goal) {
 		goal = 0;
-		sidx = 0;
-		goto find_block;
+		goto restart;
 	}
 
 	return NULL;
@@ -515,16 +548,23 @@ find_block:
  * Returns NULL on failure.
  */
 void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
-				      unsigned long goal)
+					unsigned long goal)
 {
-	bootmem_data_t *bdata;
-	void *ptr;
+	return ___alloc_bootmem_nopanic(size, align, goal, 0);
+}
 
-	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = alloc_bootmem_core(bdata, size, align, goal, 0);
-		if (ptr)
-			return ptr;
-	}
+static void * __init ___alloc_bootmem(unsigned long size, unsigned long align,
+					unsigned long goal, unsigned long limit)
+{
+	void *mem = ___alloc_bootmem_nopanic(size, align, goal, limit);
+
+	if (mem)
+		return mem;
+	/*
+	 * Whoops, we cannot satisfy the allocation request.
+	 */
+	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
+	panic("Out of memory");
 	return NULL;
 }
 
@@ -544,16 +584,7 @@ void * __init __alloc_bootmem_nopanic(un
 void * __init __alloc_bootmem(unsigned long size, unsigned long align,
 			      unsigned long goal)
 {
-	void *mem = __alloc_bootmem_nopanic(size,align,goal);
-
-	if (mem)
-		return mem;
-	/*
-	 * Whoops, we cannot satisfy the allocation request.
-	 */
-	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
-	panic("Out of memory");
-	return NULL;
+	return ___alloc_bootmem(size, align, goal, 0);
 }
 
 #ifndef ARCH_LOW_ADDRESS_LIMIT
@@ -576,22 +607,7 @@ void * __init __alloc_bootmem(unsigned l
 void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 				  unsigned long goal)
 {
-	bootmem_data_t *bdata;
-	void *ptr;
-
-	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = alloc_bootmem_core(bdata, size, align, goal,
-					ARCH_LOW_ADDRESS_LIMIT);
-		if (ptr)
-			return ptr;
-	}
-
-	/*
-	 * Whoops, we cannot satisfy the allocation request.
-	 */
-	printk(KERN_ALERT "low bootmem alloc of %lu bytes failed!\n", size);
-	panic("Out of low memory");
-	return NULL;
+	return ___alloc_bootmem(size, align, goal, ARCH_LOW_ADDRESS_LIMIT);
 }
 
 /**

-- 


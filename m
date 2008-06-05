Return-Path: <linux-kernel-owner+w=401wt.eu-S1763887AbYFEXJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763887AbYFEXJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 19:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762401AbYFEXIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 19:08:04 -0400
Received: from saeurebad.de ([85.214.36.134]:38613 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763407AbYFEXIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 19:08:01 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun  6 00:57:20 2008
Message-Id: <20080605225720.477203227@saeurebad.de>
References: <20080605224940.434439989@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 00:49:47 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 07/14] bootmem: clean up free_all_bootmem_core
Content-Disposition: inline; filename=bootmem-cleanup-free_all_bootmem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the code in a more concise way using less variables.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>
---

 mm/bootmem.c |   83 +++++++++++++++++++++++++++--------------------------------
 1 file changed, 38 insertions(+), 45 deletions(-)

--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -144,66 +144,59 @@ unsigned long __init init_bootmem(unsign
 
 static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
+	int aligned;
 	struct page *page;
-	unsigned long pfn;
-	unsigned long i, count;
-	unsigned long idx, pages;
-	unsigned long *map;
-	int gofast = 0;
-
-	BUG_ON(!bdata->node_bootmem_map);
-
-	count = 0;
-	/* first extant page of the node */
-	pfn = PFN_DOWN(bdata->node_boot_start);
-	idx = bdata->node_low_pfn - pfn;
-	map = bdata->node_bootmem_map;
+	unsigned long start, end, pages, count = 0;
+
+	if (!bdata->node_bootmem_map)
+		return 0;
+
+	start = PFN_DOWN(bdata->node_boot_start);
+	end = bdata->node_low_pfn;
+
 	/*
-	 * Check if we are aligned to BITS_PER_LONG pages.  If so, we might
-	 * be able to free page orders of that size at once.
+	 * If the start is aligned to the machines wordsize, we might
+	 * be able to free pages in bulks of that order.
 	 */
-	if (!(pfn & (BITS_PER_LONG-1)))
-		gofast = 1;
+	aligned = !(start & (BITS_PER_LONG - 1));
+
+	bdebug("nid=%d start=%lx end=%lx aligned=%d\n",
+		bdata - bootmem_node_data, start, end, aligned);
+
+	while (start < end) {
+		unsigned long *map, idx, vec;
 
-	for (i = 0; i < idx; ) {
-		unsigned long v = ~map[i / BITS_PER_LONG];
+		map = bdata->node_bootmem_map;
+		idx = start - PFN_DOWN(bdata->node_boot_start);
+		vec = ~map[idx / BITS_PER_LONG];
 
-		if (gofast && v == ~0UL) {
-			int order;
+		if (aligned && vec == ~0UL && start + BITS_PER_LONG < end) {
+			int order = ilog2(BITS_PER_LONG);
 
-			page = pfn_to_page(pfn);
+			__free_pages_bootmem(pfn_to_page(start), order);
 			count += BITS_PER_LONG;
-			order = ffs(BITS_PER_LONG) - 1;
-			__free_pages_bootmem(page, order);
-			i += BITS_PER_LONG;
-			page += BITS_PER_LONG;
-		} else if (v) {
-			unsigned long m;
-
-			page = pfn_to_page(pfn);
-			for (m = 1; m && i < idx; m<<=1, page++, i++) {
-				if (v & m) {
-					count++;
+		} else {
+			unsigned long off = 0;
+
+			while (vec && off < BITS_PER_LONG) {
+				if (vec & 1) {
+					page = pfn_to_page(start + off);
 					__free_pages_bootmem(page, 0);
+					count++;
 				}
+				vec >>= 1;
+				off++;
 			}
-		} else {
-			i += BITS_PER_LONG;
 		}
-		pfn += BITS_PER_LONG;
+		start += BITS_PER_LONG;
 	}
 
-	/*
-	 * Now free the allocator bitmap itself, it's not
-	 * needed anymore:
-	 */
 	page = virt_to_page(bdata->node_bootmem_map);
 	pages = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
-	idx = bootmem_bootmap_pages(pages);
-	for (i = 0; i < idx; i++, page++)
-		__free_pages_bootmem(page, 0);
-	count += i;
-	bdata->node_bootmem_map = NULL;
+	pages = bootmem_bootmap_pages(pages);
+	count += pages;
+	while (pages--)
+		__free_pages_bootmem(page++, 0);
 
 	bdebug("nid=%d released=%lx\n", bdata - bootmem_node_data, count);
 

-- 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751370AbZJWBXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbZJWBXC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 21:23:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbZJWBWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 21:22:49 -0400
Received: from sous-sol.org ([216.99.217.87]:52777 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751250AbZJWBWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 21:22:44 -0400
Message-Id: <20091023012220.813626444@sequoia.sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 22 Oct 2009 18:21:59 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/3] [RFC PATCH] bootmem: refactor free_all_bootmem_core
References: <20091023012158.177308035@sequoia.sous-sol.org>
Content-Disposition: inline; filename=bootmem-break-out-free_pages_bootmem-loop.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the loop that frees all bootmem pages back to page allocator into
its own function.  This should have not functional effect and allows the
function to be reused later.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 mm/bootmem.c |   61 +++++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 555d5d2..94ef2e7 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -143,17 +143,22 @@ unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
 	return init_bootmem_core(NODE_DATA(0)->bdata, start, 0, pages);
 }
 
-static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
+/**
+ * free_bootmem_pages - frees bootmem pages to page allocator
+ * @start: start pfn
+ * @end: end pfn
+ * @map: bootmem bitmap of reserved pages
+ *
+ * This will free the pages in the range @start to @end, making them
+ * available to the page allocator.  The @map will be used to skip
+ * reserved pages.  Returns the count of pages freed.
+ */
+static unsigned long __init free_bootmem_pages(unsigned long start,
+					       unsigned long end,
+					       unsigned long *map)
 {
+	unsigned long cursor, count = 0;
 	int aligned;
-	struct page *page;
-	unsigned long start, end, pages, count = 0;
-
-	if (!bdata->node_bootmem_map)
-		return 0;
-
-	start = bdata->node_min_pfn;
-	end = bdata->node_low_pfn;
 
 	/*
 	 * If the start is aligned to the machines wordsize, we might
@@ -161,27 +166,25 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 	 */
 	aligned = !(start & (BITS_PER_LONG - 1));
 
-	bdebug("nid=%td start=%lx end=%lx aligned=%d\n",
-		bdata - bootmem_node_data, start, end, aligned);
+	for (cursor = start; cursor < end; cursor += BITS_PER_LONG) {
+		unsigned long idx, vec;
 
-	while (start < end) {
-		unsigned long *map, idx, vec;
-
-		map = bdata->node_bootmem_map;
-		idx = start - bdata->node_min_pfn;
+		idx = cursor - start;
 		vec = ~map[idx / BITS_PER_LONG];
 
-		if (aligned && vec == ~0UL && start + BITS_PER_LONG < end) {
+		if (aligned && vec == ~0UL && cursor + BITS_PER_LONG < end) {
 			int order = ilog2(BITS_PER_LONG);
 
-			__free_pages_bootmem(pfn_to_page(start), order);
+			__free_pages_bootmem(pfn_to_page(cursor), order);
 			count += BITS_PER_LONG;
 		} else {
 			unsigned long off = 0;
 
 			while (vec && off < BITS_PER_LONG) {
 				if (vec & 1) {
-					page = pfn_to_page(start + off);
+					struct page *page;
+
+					page = pfn_to_page(cursor + off);
 					__free_pages_bootmem(page, 0);
 					count++;
 				}
@@ -189,8 +192,26 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 				off++;
 			}
 		}
-		start += BITS_PER_LONG;
 	}
+	return count;
+}
+
+static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
+{
+	struct page *page;
+	unsigned long start, end, *map, pages, count = 0;
+
+	if (!bdata->node_bootmem_map)
+		return 0;
+
+	start = bdata->node_min_pfn;
+	end = bdata->node_low_pfn;
+	map = bdata->node_bootmem_map;
+
+	bdebug("nid=%td start=%lx end=%lx\n", bdata - bootmem_node_data,
+		start, end);
+
+	count = free_bootmem_pages(start, end, map);
 
 	page = virt_to_page(bdata->node_bootmem_map);
 	pages = bdata->node_low_pfn - bdata->node_min_pfn;


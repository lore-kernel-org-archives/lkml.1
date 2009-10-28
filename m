Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbZJ1Gzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbZJ1Gzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932235AbZJ1Gzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:55:35 -0400
Received: from sh.osrg.net ([192.16.179.4]:54084 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757502AbZJ1GyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:54:25 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: chrisw@sous-sol.org, dwmw2@infradead.org, joerg.roedel@amd.com,
       mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 06/10] bootmem: refactor free_all_bootmem_core
Date: Wed, 28 Oct 2009 15:47:40 +0900
Message-Id: <1256712464-21472-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 28 Oct 2009 15:53:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

Move the loop that frees all bootmem pages back to page allocator into
its own function.  This should have not functional effect and allows the
function to be reused later.

Reviewed-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
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
-- 
1.5.6.5


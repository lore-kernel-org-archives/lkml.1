Return-Path: <linux-kernel-owner+w=401wt.eu-S964825AbXCAKG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825AbXCAKG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 05:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964798AbXCAKG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 05:06:29 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:57102 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964825AbXCAKGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 05:06:12 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-Id: <20070301100610.29753.15879.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070301100229.29753.86342.sendpatchset@skynet.skynet.ie>
References: <20070301100229.29753.86342.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 11/12] Bias the placement of kernel pages at lower PFNs
Date: Thu,  1 Mar 2007 10:06:10 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch chooses blocks with lower PFNs when placing kernel allocations. This
is particularly important during fallback in low memory situations to stop
unmovable pages being placed throughout the entire address space.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---

 page_alloc.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.20-mm2-010_cluster_atomic/mm/page_alloc.c linux-2.6.20-mm2-011_biasplacement/mm/page_alloc.c
--- linux-2.6.20-mm2-010_cluster_atomic/mm/page_alloc.c	2007-02-20 18:50:00.000000000 +0000
+++ linux-2.6.20-mm2-011_biasplacement/mm/page_alloc.c	2007-02-20 18:52:18.000000000 +0000
@@ -750,6 +750,23 @@ int move_freepages_block(struct zone *zo
 	return move_freepages(zone, start_page, end_page, migratetype);
 }
 
+/* Return the page with the lowest PFN in the list */
+static struct page *min_page(struct list_head *list)
+{
+	unsigned long min_pfn = -1UL;
+	struct page *min_page = NULL, *page;;
+
+	list_for_each_entry(page, list, lru) {
+		unsigned long pfn = page_to_pfn(page);
+		if (pfn < min_pfn) {
+			min_pfn = pfn;
+			min_page = page;
+		}
+	}
+
+	return min_page;
+}
+
 /* Remove an element from the buddy allocator from the fallback list */
 static struct page *__rmqueue_fallback(struct zone *zone, int order,
 						int start_migratetype)
@@ -780,8 +797,11 @@ retry:
 			if (list_empty(&area->free_list[migratetype]))
 				continue;
 
+			/* Bias kernel allocations towards low pfns */
 			page = list_entry(area->free_list[migratetype].next,
 					struct page, lru);
+			if (unlikely(start_migratetype != MIGRATE_MOVABLE))
+				page = min_page(&area->free_list[migratetype]);
 			area->nr_free--;
 
 			/*

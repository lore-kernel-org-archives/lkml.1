Return-Path: <linux-kernel-owner+w=401wt.eu-S1761067AbZCPJy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761067AbZCPJy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 05:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZCPJop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 05:44:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35432 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbZCPJoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 05:44:38 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 30/35] Skip the PCP list search by counting the order and type of pages on list
Date: Mon, 16 Mar 2009 09:46:25 +0000
Message-Id: <1237196790-7268-31-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237196790-7268-1-git-send-email-mel@csn.ul.ie>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCP lists are searched for free pages of the right size but due to
multiple orders, the list may be searched uselessly.  This patch records how
many pages there are of each order and migratetype on the list to determine
if a list search will succeed.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/mmzone.h |    6 +++++-
 mm/page_alloc.c        |   46 +++++++++++++++++++++++++---------------------
 2 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b4fba09..5be2386 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -165,7 +165,11 @@ static inline int is_unevictable_lru(enum lru_list l)
 }
 
 struct per_cpu_pages {
-	int count;		/* number of pages in the list */
+	/* The total number of pages on the PCP lists */
+	int count;
+
+	/* Count of each migratetype and order */
+	u8 mocount[MIGRATE_PCPTYPES][PAGE_ALLOC_COSTLY_ORDER+1];
 
 	/* Lists of pages, one per migrate type stored on the pcp-lists */
 	struct list_head lists[MIGRATE_PCPTYPES];
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 77e9970..bb5bd5e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -513,8 +513,12 @@ static inline int free_pages_check(struct page *page)
 
 static inline void rmv_pcp_page(struct per_cpu_pages *pcp, struct page *page)
 {
+	int migratetype = page_private(page);
+	int basepage_count = 1 << page->index;
+
 	list_del(&page->lru);
-	pcp->count -= 1 << page->index;
+	pcp->count -= basepage_count;
+	pcp->mocount[migratetype][page->index] -= basepage_count;
 }
 
 static inline void add_pcp_page(struct per_cpu_pages *pcp,
@@ -522,17 +526,22 @@ static inline void add_pcp_page(struct per_cpu_pages *pcp,
 					int cold)
 {
 	int migratetype = page_private(page);
+	int basepage_count = 1 << page->index;
+
 	if (cold)
 		list_add_tail(&page->lru, &pcp->lists[migratetype]);
 	else
 		list_add(&page->lru, &pcp->lists[migratetype]);
-	pcp->count += 1 << page->index;
+	pcp->count += basepage_count;
+	pcp->mocount[migratetype][page->index] += basepage_count;
 }
 
 static inline void bulk_add_pcp_page(struct per_cpu_pages *pcp,
-					int order, int count)
+					int migratetype, int order, int count)
 {
-	pcp->count += count << order;
+	int basepage_count = count << order;
+	pcp->count += basepage_count;
+	pcp->mocount[migratetype][order] += basepage_count;
 }
 
 /*
@@ -1178,20 +1187,23 @@ again:
 	cpu  = get_cpu();
 	if (likely(order <= PAGE_ALLOC_COSTLY_ORDER)) {
 		struct per_cpu_pages *pcp;
-		int batch;
-		int delta;
 		struct list_head *list;
 
 		pcp = &zone_pcp(zone, cpu)->pcp;
 		list = &pcp->lists[migratetype];
-		batch = max(1, zone->pcp_batch >> order);
 		local_irq_save(flags);
-		if (list_empty(list)) {
-			delta = rmqueue_bulk(zone, order, batch,
+
+		/* Allocate more if no suitable page is in list */
+		if (!pcp->mocount[migratetype][order]) {
+			int batch = max(1, zone->pcp_batch >> order);
+			int delta = rmqueue_bulk(zone, order, batch,
 							list, migratetype);
-			bulk_add_pcp_page(pcp, order, delta);
-			if (unlikely(list_empty(list)))
+			bulk_add_pcp_page(pcp, migratetype, order, delta);
+			if (unlikely(!pcp->mocount[migratetype][order]))
 				goto failed;
+
+			page = list_entry(list->next, struct page, lru);
+			goto found;
 		}
 
 		/* Find a page of the appropriate order */
@@ -1205,16 +1217,7 @@ again:
 					break;
 		}
 
-		/* Allocate more to the pcp list if necessary */
-		if (unlikely(&page->lru == list)) {
-			delta = rmqueue_bulk(zone, order, batch,
-					list, migratetype);
-			bulk_add_pcp_page(pcp, order, delta);
-			page = list_entry(list->next, struct page, lru);
-			if (!pcp_page_suit(page, order))
-				goto failed;
-		}
-
+found:
 		rmv_pcp_page(pcp, page);
 	} else {
 		LIST_HEAD(list);
@@ -2985,6 +2988,7 @@ static void setup_pageset(struct zone *zone,
 
 	pcp = &p->pcp;
 	pcp->count = 0;
+	memset(pcp->mocount, 0, sizeof(pcp->mocount));
 	zone->pcp_high = 6 * batch;
 	zone->pcp_batch = max(1UL, 1 * batch);
 	for (migratetype = 0; migratetype < MIGRATE_TYPES; migratetype++)
-- 
1.5.6.5


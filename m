Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbZH1Ioa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbZH1Ioa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 04:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZH1Io3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 04:44:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53719 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbZH1Io2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 04:44:28 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 2/2] page-allocator: Maintain rolling count of pages to free from the PCP
Date: Fri, 28 Aug 2009 09:44:27 +0100
Message-Id: <1251449067-3109-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251449067-3109-1-git-send-email-mel@csn.ul.ie>
References: <1251449067-3109-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When round-robin freeing pages from the PCP lists, empty lists may be
encountered. In the event one of the lists has more pages than another,
there may be numerous checks for list_empty() which is undesirable. This
patch maintains a count of pages to free which is incremented when empty
lists are encountered. The intention is that more pages will then be freed
from fuller lists than the empty ones reducing the number of empty list
checks in the free path.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 65eedb5..9b86977 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -536,32 +536,37 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 					struct per_cpu_pages *pcp)
 {
 	int migratetype = 0;
+	int batch_free = 0;
 
 	spin_lock(&zone->lock);
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
 
 	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
-	while (count--) {
+	while (count) {
 		struct page *page;
 		struct list_head *list;
 
 		/*
-		 * Remove pages from lists in a round-robin fashion. This spinning
-		 * around potentially empty lists is bloody awful, alternatives that
-		 * don't suck are welcome
+		 * Remove pages from lists in a round-robin fashion. A batch_free
+		 * count is maintained that is incremented when an empty list is
+		 * encountered. This is so more pages are freed off fuller lists
+		 * instead of spinning excessively around empty lists
 		 */
 		do {
+			batch_free++;
 			if (++migratetype == MIGRATE_PCPTYPES)
 				migratetype = 0;
 			list = &pcp->lists[migratetype];
 		} while (list_empty(list));
 
-		page = list_entry(list->prev, struct page, lru);
-		/* have to delete it as __free_one_page list manipulates */
-		list_del(&page->lru);
-		trace_mm_page_pcpu_drain(page, 0, migratetype);
-		__free_one_page(page, zone, 0, migratetype);
+		do {
+			page = list_entry(list->prev, struct page, lru);
+			/* must delete as __free_one_page list manipulates */
+			list_del(&page->lru);
+			__free_one_page(page, zone, 0, migratetype);
+			trace_mm_page_pcpu_drain(page, 0, migratetype);
+		} while (--count && --batch_free && !list_empty(list));
 	}
 	spin_unlock(&zone->lock);
 }
-- 
1.6.3.3


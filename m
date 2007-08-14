Return-Path: <linux-kernel-owner+w=401wt.eu-S1764249AbXHNPkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764249AbXHNPkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762289AbXHNPfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:35:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52222 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755864AbXHNPfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:35:06 -0400
Message-Id: <20070814153502.468501385@sgi.com>
References: <20070814153021.446917377@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Aug 2007 08:30:28 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 7/9] Save flags in swap.c
Content-Disposition: inline; filename=vmscan_swap_lock_irqsave
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We need to call various LRU management functions with interrupts
disabled for atomic reclaim. Make them save flags.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/swap.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

Index: linux-2.6/mm/swap.c
===================================================================
--- linux-2.6.orig/mm/swap.c	2007-08-14 08:00:57.000000000 -0700
+++ linux-2.6/mm/swap.c	2007-08-14 08:03:50.000000000 -0700
@@ -140,15 +140,16 @@ int rotate_reclaimable_page(struct page 
 void fastcall activate_page(struct page *page)
 {
 	struct zone *zone = page_zone(page);
+	unsigned long flags;
 
-	spin_lock_irq(&zone->lru_lock);
+	spin_lock_irqsave(&zone->lru_lock, flags);
 	if (PageLRU(page) && !PageActive(page)) {
 		del_page_from_inactive_list(zone, page);
 		SetPageActive(page);
 		add_page_to_active_list(zone, page);
 		__count_vm_event(PGACTIVATE);
 	}
-	spin_unlock_irq(&zone->lru_lock);
+	spin_unlock_irqrestore(&zone->lru_lock, flags);
 }
 
 /*
@@ -258,6 +259,7 @@ void release_pages(struct page **pages, 
 	int i;
 	struct pagevec pages_to_free;
 	struct zone *zone = NULL;
+	unsigned long flags = 0;
 
 	pagevec_init(&pages_to_free, cold);
 	for (i = 0; i < nr; i++) {
@@ -281,7 +283,7 @@ void release_pages(struct page **pages, 
 				if (zone)
 					spin_unlock_irq(&zone->lru_lock);
 				zone = pagezone;
-				spin_lock_irq(&zone->lru_lock);
+				spin_lock_irqsave(&zone->lru_lock, flags);
 			}
 			VM_BUG_ON(!PageLRU(page));
 			__ClearPageLRU(page);
@@ -298,7 +300,7 @@ void release_pages(struct page **pages, 
   		}
 	}
 	if (zone)
-		spin_unlock_irq(&zone->lru_lock);
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
 	pagevec_free(&pages_to_free);
 }
@@ -352,6 +354,7 @@ void __pagevec_lru_add(struct pagevec *p
 {
 	int i;
 	struct zone *zone = NULL;
+	unsigned long flags = 0;
 
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
@@ -361,14 +364,14 @@ void __pagevec_lru_add(struct pagevec *p
 			if (zone)
 				spin_unlock_irq(&zone->lru_lock);
 			zone = pagezone;
-			spin_lock_irq(&zone->lru_lock);
+			spin_lock_irqsave(&zone->lru_lock, flags);
 		}
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 		add_page_to_inactive_list(zone, page);
 	}
 	if (zone)
-		spin_unlock_irq(&zone->lru_lock);
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
 	release_pages(pvec->pages, pvec->nr, pvec->cold);
 	pagevec_reinit(pvec);
 }
@@ -379,6 +382,7 @@ void __pagevec_lru_add_active(struct pag
 {
 	int i;
 	struct zone *zone = NULL;
+	unsigned long flags = 0;
 
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
@@ -386,9 +390,9 @@ void __pagevec_lru_add_active(struct pag
 
 		if (pagezone != zone) {
 			if (zone)
-				spin_unlock_irq(&zone->lru_lock);
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
 			zone = pagezone;
-			spin_lock_irq(&zone->lru_lock);
+			spin_lock_irqsave(&zone->lru_lock, flags);
 		}
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
@@ -397,7 +401,7 @@ void __pagevec_lru_add_active(struct pag
 		add_page_to_active_list(zone, page);
 	}
 	if (zone)
-		spin_unlock_irq(&zone->lru_lock);
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
 	release_pages(pvec->pages, pvec->nr, pvec->cold);
 	pagevec_reinit(pvec);
 }

-- 

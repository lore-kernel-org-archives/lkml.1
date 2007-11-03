Return-Path: <linux-kernel-owner+w=401wt.eu-S1761982AbXKCXJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761982AbXKCXJR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760098AbXKCXGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:06:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759885AbXKCXGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:06:41 -0400
Date: Sat, 3 Nov 2007 18:54:47 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: [RFC PATCH 2/10] free swap space entries if vm_swap_full()
Message-ID: <20071103185447.358b9c4a@bree.surriel.com>
In-Reply-To: <20071103184229.3f20e2f0@bree.surriel.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel's patch to free swap space on swap-in/activiation,
forward ported by Lee Schermerhorn.

Against:  2.6.23-rc2-mm2 atop:
+ lts' convert anon_vma list lock to reader/write lock patch
+ Nick Piggin's move and rework isolate_lru_page() patch

Patch Description:  quick attempt by lts

Free swap cache entries when swapping in pages if vm_swap_full()
[swap space > 1/2 used?].  Uses new pagevec to reduce pressure
on locks.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

 include/linux/pagevec.h |    1 +
 mm/swap.c               |   18 ++++++++++++++++++
 mm/vmscan.c             |   16 +++++++++++-----
 3 files changed, 30 insertions(+), 5 deletions(-)

Index: linux-2.6.23-rc6-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/mm/vmscan.c	2007-09-25 15:20:05.000000000 -0400
+++ linux-2.6.23-rc6-mm1/mm/vmscan.c	2007-09-25 15:25:04.000000000 -0400
@@ -613,6 +613,9 @@ free_it:
 		continue;
 
 activate_locked:
+		/* Not a candidate for swapping, so reclaim swap space. */
+		if (PageSwapCache(page) && vm_swap_full())
+			remove_exclusive_swap_page(page);
 		SetPageActive(page);
 		pgactivate++;
 keep_locked:
@@ -1142,14 +1145,13 @@ force_reclaim_mapped:
 		}
 	}
 	__mod_zone_page_state(zone, NR_INACTIVE, pgmoved);
+	spin_unlock_irq(&zone->lru_lock);
 	pgdeactivate += pgmoved;
-	if (buffer_heads_over_limit) {
-		spin_unlock_irq(&zone->lru_lock);
-		pagevec_strip(&pvec);
-		spin_lock_irq(&zone->lru_lock);
-	}
 
+	if (buffer_heads_over_limit)
+		pagevec_strip(&pvec);
 	pgmoved = 0;
+	spin_lock_irq(&zone->lru_lock);
 	while (!list_empty(&l_active)) {
 		page = lru_to_page(&l_active);
 		prefetchw_prev_lru_page(page, &l_active, flags);
@@ -1163,6 +1165,8 @@ force_reclaim_mapped:
 			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
 			pgmoved = 0;
 			spin_unlock_irq(&zone->lru_lock);
+			if (vm_swap_full())
+				pagevec_swap_free(&pvec);
 			__pagevec_release(&pvec);
 			spin_lock_irq(&zone->lru_lock);
 		}
@@ -1172,6 +1176,8 @@ force_reclaim_mapped:
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	__count_vm_events(PGDEACTIVATE, pgdeactivate);
 	spin_unlock_irq(&zone->lru_lock);
+	if (vm_swap_full())
+		pagevec_swap_free(&pvec);
 
 	pagevec_release(&pvec);
 }
Index: linux-2.6.23-rc6-mm1/mm/swap.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/mm/swap.c	2007-09-25 15:20:05.000000000 -0400
+++ linux-2.6.23-rc6-mm1/mm/swap.c	2007-09-25 15:22:51.000000000 -0400
@@ -421,6 +421,24 @@ void pagevec_strip(struct pagevec *pvec)
 	}
 }
 
+/*
+ * Try to free swap space from the pages in a pagevec
+ */
+void pagevec_swap_free(struct pagevec *pvec)
+{
+	int i;
+
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		struct page *page = pvec->pages[i];
+
+		if (PageSwapCache(page) && !TestSetPageLocked(page)) {
+			if (PageSwapCache(page))
+				remove_exclusive_swap_page(page);
+			unlock_page(page);
+		}
+	}
+}
+
 /**
  * pagevec_lookup - gang pagecache lookup
  * @pvec:	Where the resulting pages are placed
Index: linux-2.6.23-rc6-mm1/include/linux/pagevec.h
===================================================================
--- linux-2.6.23-rc6-mm1.orig/include/linux/pagevec.h	2007-09-25 15:20:02.000000000 -0400
+++ linux-2.6.23-rc6-mm1/include/linux/pagevec.h	2007-09-25 15:22:51.000000000 -0400
@@ -26,6 +26,7 @@ void __pagevec_free(struct pagevec *pvec
 void __pagevec_lru_add(struct pagevec *pvec);
 void __pagevec_lru_add_active(struct pagevec *pvec);
 void pagevec_strip(struct pagevec *pvec);
+void pagevec_swap_free(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,

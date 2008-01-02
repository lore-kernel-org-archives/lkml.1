Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbYABXW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbYABXW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYABXWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:22:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbYABXWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:22:13 -0500
Message-Id: <20080102224153.797602685@redhat.com>
References: <20080102224144.885671949@redhat.com>
User-Agent: quilt/0.46-1
Date: Wed, 02 Jan 2008 17:41:46 -0500
From: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, lee.schermerhorn@hp.com,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [patch 02/19] free swap space on swap-in/activation
Content-Disposition: inline; filename=rvr-00-linux-2.6-swapfree.patch
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ lts' convert anon_vma list lock to reader/write lock patch
+ Nick Piggin's move and rework isolate_lru_page() patch

Free swap cache entries when swapping in pages if vm_swap_full()
[swap space > 1/2 used?].  Uses new pagevec to reduce pressure
on locks.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Index: linux-2.6.24-rc6-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.24-rc6-mm1.orig/mm/vmscan.c	2008-01-02 12:37:14.000000000 -0500
+++ linux-2.6.24-rc6-mm1/mm/vmscan.c	2008-01-02 12:37:18.000000000 -0500
@@ -632,6 +632,9 @@ free_it:
 		continue;
 
 activate_locked:
+		/* Not a candidate for swapping, so reclaim swap space. */
+		if (PageSwapCache(page) && vm_swap_full())
+			remove_exclusive_swap_page(page);
 		SetPageActive(page);
 		pgactivate++;
 keep_locked:
@@ -1214,6 +1217,8 @@ static void shrink_active_list(unsigned 
 			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
 			pgmoved = 0;
 			spin_unlock_irq(&zone->lru_lock);
+			if (vm_swap_full())
+				pagevec_swap_free(&pvec);
 			__pagevec_release(&pvec);
 			spin_lock_irq(&zone->lru_lock);
 		}
@@ -1223,6 +1228,8 @@ static void shrink_active_list(unsigned 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	__count_vm_events(PGDEACTIVATE, pgdeactivate);
 	spin_unlock_irq(&zone->lru_lock);
+	if (vm_swap_full())
+		pagevec_swap_free(&pvec);
 
 	pagevec_release(&pvec);
 }
Index: linux-2.6.24-rc6-mm1/mm/swap.c
===================================================================
--- linux-2.6.24-rc6-mm1.orig/mm/swap.c	2008-01-02 12:37:12.000000000 -0500
+++ linux-2.6.24-rc6-mm1/mm/swap.c	2008-01-02 12:37:18.000000000 -0500
@@ -465,6 +465,24 @@ void pagevec_strip(struct pagevec *pvec)
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
Index: linux-2.6.24-rc6-mm1/include/linux/pagevec.h
===================================================================
--- linux-2.6.24-rc6-mm1.orig/include/linux/pagevec.h	2008-01-02 12:37:12.000000000 -0500
+++ linux-2.6.24-rc6-mm1/include/linux/pagevec.h	2008-01-02 12:37:18.000000000 -0500
@@ -26,6 +26,7 @@ void __pagevec_free(struct pagevec *pvec
 void __pagevec_lru_add(struct pagevec *pvec);
 void __pagevec_lru_add_active(struct pagevec *pvec);
 void pagevec_strip(struct pagevec *pvec);
+void pagevec_swap_free(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,

-- 
All Rights Reversed


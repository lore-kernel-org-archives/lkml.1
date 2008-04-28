Return-Path: <linux-kernel-owner+w=401wt.eu-S936449AbYD1SXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936449AbYD1SXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936419AbYD1SWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:22:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936326AbYD1SWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:22:38 -0400
Message-Id: <20080428181852.620969450@redhat.com>
References: <20080428181835.502876582@redhat.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 14:18:40 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [PATCH -mm 05/15] free swap space on swap-in/activation
Content-Disposition: inline; filename=rvr-00-linux-2.6-swapfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free swap cache entries when swapping in pages if vm_swap_full()
[swap space > 1/2 used].  Uses new pagevec to reduce pressure
on locks.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Index: linux-2.6.25-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.25-mm1.orig/mm/vmscan.c	2008-04-24 10:46:43.000000000 -0400
+++ linux-2.6.25-mm1/mm/vmscan.c	2008-04-24 11:59:56.000000000 -0400
@@ -619,6 +619,9 @@ free_it:
 		continue;
 
 activate_locked:
+		/* Not a candidate for swapping, so reclaim swap space. */
+		if (PageSwapCache(page) && vm_swap_full())
+			remove_exclusive_swap_page(page);
 		SetPageActive(page);
 		pgactivate++;
 keep_locked:
@@ -1203,6 +1206,8 @@ static void shrink_active_list(unsigned 
 			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
 			pgmoved = 0;
 			spin_unlock_irq(&zone->lru_lock);
+			if (vm_swap_full())
+				pagevec_swap_free(&pvec);
 			__pagevec_release(&pvec);
 			spin_lock_irq(&zone->lru_lock);
 		}
@@ -1212,6 +1217,8 @@ static void shrink_active_list(unsigned 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	__count_vm_events(PGDEACTIVATE, pgdeactivate);
 	spin_unlock_irq(&zone->lru_lock);
+	if (vm_swap_full())
+		pagevec_swap_free(&pvec);
 
 	pagevec_release(&pvec);
 }
Index: linux-2.6.25-mm1/mm/swap.c
===================================================================
--- linux-2.6.25-mm1.orig/mm/swap.c	2008-04-24 11:59:51.000000000 -0400
+++ linux-2.6.25-mm1/mm/swap.c	2008-04-24 11:59:56.000000000 -0400
@@ -443,6 +443,24 @@ void pagevec_strip(struct pagevec *pvec)
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
Index: linux-2.6.25-mm1/include/linux/pagevec.h
===================================================================
--- linux-2.6.25-mm1.orig/include/linux/pagevec.h	2008-04-24 11:59:51.000000000 -0400
+++ linux-2.6.25-mm1/include/linux/pagevec.h	2008-04-24 11:59:56.000000000 -0400
@@ -25,6 +25,7 @@ void __pagevec_release_nonlru(struct pag
 void __pagevec_free(struct pagevec *pvec);
 void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
 void pagevec_strip(struct pagevec *pvec);
+void pagevec_swap_free(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,

-- 
All Rights Reversed


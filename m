Return-Path: <linux-kernel-owner+w=401wt.eu-S1762922AbYEPSwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762922AbYEPSwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761016AbYEPSsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:48:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760904AbYEPSr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:47:56 -0400
Message-Id: <20080516183224.259161900@redhat.com>
References: <20080516183207.361608893@redhat.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 May 2008 14:32:11 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [patch 04/14] free swap space on swap-in/activation
Content-Disposition: inline; filename=rvr-00-linux-2.6-swapfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Free swap cache entries when swapping in pages if vm_swap_full()
[swap space > 1/2 used].  Uses new pagevec to reduce pressure
on locks.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Index: linux-2.6.26-rc2-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/vmscan.c	2008-05-15 16:08:20.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/vmscan.c	2008-05-15 16:08:31.000000000 -0400
@@ -619,6 +619,9 @@ free_it:
 		continue;
 
 activate_locked:
+		/* Not a candidate for swapping, so reclaim swap space. */
+		if (PageSwapCache(page) && vm_swap_full())
+			remove_exclusive_swap_page_ref(page);
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
Index: linux-2.6.26-rc2-mm1/mm/swap.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/swap.c	2008-05-15 16:08:27.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/swap.c	2008-05-15 16:08:31.000000000 -0400
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
+				remove_exclusive_swap_page_ref(page);
+			unlock_page(page);
+		}
+	}
+}
+
 /**
  * pagevec_lookup - gang pagecache lookup
  * @pvec:	Where the resulting pages are placed
Index: linux-2.6.26-rc2-mm1/include/linux/pagevec.h
===================================================================
--- linux-2.6.26-rc2-mm1.orig/include/linux/pagevec.h	2008-05-15 16:08:27.000000000 -0400
+++ linux-2.6.26-rc2-mm1/include/linux/pagevec.h	2008-05-15 16:08:31.000000000 -0400
@@ -25,6 +25,7 @@ void __pagevec_release_nonlru(struct pag
 void __pagevec_free(struct pagevec *pvec);
 void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
 void pagevec_strip(struct pagevec *pvec);
+void pagevec_swap_free(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,
Index: linux-2.6.26-rc2-mm1/include/linux/swap.h
===================================================================
--- linux-2.6.26-rc2-mm1.orig/include/linux/swap.h	2008-05-15 16:08:27.000000000 -0400
+++ linux-2.6.26-rc2-mm1/include/linux/swap.h	2008-05-15 16:08:31.000000000 -0400
@@ -265,6 +265,7 @@ extern sector_t swapdev_block(int, pgoff
 extern struct swap_info_struct *get_swap_info_struct(unsigned);
 extern int can_share_swap_page(struct page *);
 extern int remove_exclusive_swap_page(struct page *);
+extern int remove_exclusive_swap_page_ref(struct page *);
 struct backing_dev_info;
 
 /* linux/mm/thrash.c */
Index: linux-2.6.26-rc2-mm1/mm/swapfile.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/swapfile.c	2008-05-15 11:21:11.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/swapfile.c	2008-05-16 13:31:42.000000000 -0400
@@ -343,7 +343,7 @@ int can_share_swap_page(struct page *pag
  * Work out if there are any other processes sharing this
  * swap cache page. Free it if you can. Return success.
  */
-int remove_exclusive_swap_page(struct page *page)
+static int remove_exclusive_swap_page_count(struct page *page, int count)
 {
 	int retval;
 	struct swap_info_struct * p;
@@ -356,7 +356,7 @@ int remove_exclusive_swap_page(struct pa
 		return 0;
 	if (PageWriteback(page))
 		return 0;
-	if (page_count(page) != 2) /* 2: us + cache */
+	if (page_count(page) != count) /* us + cache + ptes */
 		return 0;
 
 	entry.val = page_private(page);
@@ -369,7 +369,7 @@ int remove_exclusive_swap_page(struct pa
 	if (p->swap_map[swp_offset(entry)] == 1) {
 		/* Recheck the page count with the swapcache lock held.. */
 		write_lock_irq(&swapper_space.tree_lock);
-		if ((page_count(page) == 2) && !PageWriteback(page)) {
+		if ((page_count(page) == count) && !PageWriteback(page)) {
 			__delete_from_swap_cache(page);
 			SetPageDirty(page);
 			retval = 1;
@@ -387,6 +387,25 @@ int remove_exclusive_swap_page(struct pa
 }
 
 /*
+ * Most of the time the page should have two references: one for the
+ * process and one for the swap cache.
+ */
+int remove_exclusive_swap_page(struct page *page)
+{
+	return remove_exclusive_swap_page_count(page, 2);
+}
+
+/*
+ * The pageout code holds an extra reference to the page.  That raises
+ * the reference count to test for to 2 for a page that is only in the
+ * swap cache plus 1 for each process that maps the page.
+ */
+int remove_exclusive_swap_page_ref(struct page *page)
+{
+	return remove_exclusive_swap_page_count(page, 2 + page_mapcount(page));
+}
+
+/*
  * Free the swap entry like above, but also try to
  * free the page cache entry if it is the last user.
  */

-- 
All Rights Reversed


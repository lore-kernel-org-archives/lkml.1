Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbYFKSw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbYFKSw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYFKSrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:47:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758016AbYFKSrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:47:33 -0400
Message-Id: <20080611184338.996300069@redhat.com>
References: <20080611184214.605110868@redhat.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Jun 2008 14:42:18 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [PATCH -mm 04/24] vmscan: free swap space on swap-in/activation
Content-Disposition: inline; filename=vmscan-free-swap-space-on-swap-in-activation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

If vm_swap_full() (swap space more than 50% full), the system
will free swap space at swapin time.  With this patch, the system
will also free the swap space in the pageout code, when we decide
that the page is not a candidate for swapout (and just wasting
swap space).

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: MinChan Kim <minchan.kim@gmail.com>

---
 include/linux/pagevec.h |    1 +
 include/linux/swap.h    |    6 ++++++
 mm/swap.c               |   24 ++++++++++++++++++++++++
 mm/swapfile.c           |   25 ++++++++++++++++++++++---
 mm/vmscan.c             |    7 +++++++
 5 files changed, 60 insertions(+), 3 deletions(-)

Index: linux-2.6.26-rc5-mm2/mm/vmscan.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/vmscan.c	2008-06-10 13:18:26.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/vmscan.c	2008-06-10 13:34:07.000000000 -0400
@@ -613,6 +613,9 @@ free_it:
 		continue;
 
 activate_locked:
+		/* Not a candidate for swapping, so reclaim swap space. */
+		if (PageSwapCache(page) && vm_swap_full())
+			remove_exclusive_swap_page_ref(page);
 		SetPageActive(page);
 		pgactivate++;
 keep_locked:
@@ -1197,6 +1200,8 @@ static void shrink_active_list(unsigned 
 			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
 			pgmoved = 0;
 			spin_unlock_irq(&zone->lru_lock);
+			if (vm_swap_full())
+				pagevec_swap_free(&pvec);
 			__pagevec_release(&pvec);
 			spin_lock_irq(&zone->lru_lock);
 		}
@@ -1206,6 +1211,8 @@ static void shrink_active_list(unsigned 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	__count_vm_events(PGDEACTIVATE, pgdeactivate);
 	spin_unlock_irq(&zone->lru_lock);
+	if (vm_swap_full())
+		pagevec_swap_free(&pvec);
 
 	pagevec_release(&pvec);
 }
Index: linux-2.6.26-rc5-mm2/mm/swap.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/swap.c	2008-06-10 13:18:58.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/swap.c	2008-06-10 13:34:07.000000000 -0400
@@ -427,6 +427,30 @@ void pagevec_strip(struct pagevec *pvec)
 }
 
 /**
+ * pagevec_swap_free - try to free swap space from the pages in a pagevec
+ * @pvec: pagevec with swapcache pages to free the swap space of
+ *
+ * The caller needs to hold an extra reference to each page and
+ * not hold the page lock on the pages.  This function uses a
+ * trylock on the page lock so it may not always free the swap
+ * space associated with a page.
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
+/**
  * pagevec_lookup - gang pagecache lookup
  * @pvec:	Where the resulting pages are placed
  * @mapping:	The address_space to search
Index: linux-2.6.26-rc5-mm2/include/linux/pagevec.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/linux/pagevec.h	2008-06-10 13:18:58.000000000 -0400
+++ linux-2.6.26-rc5-mm2/include/linux/pagevec.h	2008-06-10 13:34:07.000000000 -0400
@@ -25,6 +25,7 @@ void __pagevec_release_nonlru(struct pag
 void __pagevec_free(struct pagevec *pvec);
 void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
 void pagevec_strip(struct pagevec *pvec);
+void pagevec_swap_free(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,
Index: linux-2.6.26-rc5-mm2/include/linux/swap.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/linux/swap.h	2008-06-10 13:18:58.000000000 -0400
+++ linux-2.6.26-rc5-mm2/include/linux/swap.h	2008-06-10 13:34:07.000000000 -0400
@@ -266,6 +266,7 @@ extern sector_t swapdev_block(int, pgoff
 extern struct swap_info_struct *get_swap_info_struct(unsigned);
 extern int can_share_swap_page(struct page *);
 extern int remove_exclusive_swap_page(struct page *);
+extern int remove_exclusive_swap_page_ref(struct page *);
 struct backing_dev_info;
 
 extern spinlock_t swap_lock;
@@ -356,6 +357,11 @@ static inline int remove_exclusive_swap_
 	return 0;
 }
 
+static inline int remove_exclusive_swap_page_ref(struct page *page)
+{
+	return 0;
+}
+
 static inline swp_entry_t get_swap_page(void)
 {
 	swp_entry_t entry;
Index: linux-2.6.26-rc5-mm2/mm/swapfile.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/swapfile.c	2008-06-10 10:25:07.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/swapfile.c	2008-06-10 13:34:07.000000000 -0400
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


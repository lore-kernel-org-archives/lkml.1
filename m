Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbXLRVS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbXLRVS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbXLRVRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:17:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbXLRVRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:17:34 -0500
Message-Id: <20071218211549.082418544@redhat.com>
References: <20071218211539.250334036@redhat.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Dec 2007 16:15:44 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, lee.shermerhorn@hp.com,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: [patch 05/20] define page_file_cache() function
Content-Disposition: inline; filename=rvr-01-linux-2.6-page_file_cache.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define page_file_cache() function to answer the question:
	is page backed by a file?

Originally part of Rik van Riel's split-lru patch.  Extracted
to make available for other, independent reclaim patches.

Moved inline function to linux/mm_inline.h where it will
be needed by subsequent "split LRU" and "noreclaim" patches.  

Unfortunately this needs to use a page flag, since the
PG_swapbacked state needs to be preserved all the way
to the point where the page is last removed from the
LRU.  Trying to derive the status from other info in
the page resulted in wrong VM statistics in earlier
split VM patchsets.


Signed-off-by:  Rik van Riel <riel@redhat.com>
Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>


Index: linux-2.6.24-rc3-mm2/include/linux/mm_inline.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/linux/mm_inline.h
+++ linux-2.6.24-rc3-mm2/include/linux/mm_inline.h
@@ -1,3 +1,24 @@
+#ifndef LINUX_MM_INLINE_H
+#define LINUX_MM_INLINE_H
+
+/**
+ * page_file_cache(@page)
+ * Returns !0 if @page is page cache page backed by a regular filesystem,
+ * or 0 if @page is anonymous, tmpfs or otherwise ram or swap backed.
+ *
+ * We would like to get this info without a page flag, but the state
+ * needs to survive until the page is last deleted from the LRU, which
+ * could be as far down as __page_cache_release.
+ */
+static inline int page_file_cache(struct page *page)
+{
+	if (PageSwapBacked(page))
+		return 0;
+
+	/* The page is page cache backed by a normal filesystem. */
+	return 2;
+}
+
 static inline void
 add_page_to_active_list(struct zone *zone, struct page *page)
 {
@@ -38,3 +59,4 @@ del_page_from_lru(struct zone *zone, str
 	}
 }
 
+#endif
Index: linux-2.6.24-rc3-mm2/mm/shmem.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/mm/shmem.c
+++ linux-2.6.24-rc3-mm2/mm/shmem.c
@@ -1279,6 +1279,7 @@ repeat:
 				goto failed;
 			}
 
+			SetPageSwapBacked(filepage);
 			spin_lock(&info->lock);
 			entry = shmem_swp_alloc(info, idx, sgp);
 			if (IS_ERR(entry))
Index: linux-2.6.24-rc3-mm2/include/linux/page-flags.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/linux/page-flags.h
+++ linux-2.6.24-rc3-mm2/include/linux/page-flags.h
@@ -89,6 +89,7 @@
 #define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
 #define PG_reclaim		17	/* To be reclaimed asap */
 #define PG_buddy		19	/* Page is free, on buddy lists */
+#define PG_swapbacked		20	/* Page is backed by RAM/swap */
 
 /* PG_readahead is only used for file reads; PG_reclaim is only for writes */
 #define PG_readahead		PG_reclaim /* Reminder to do async read-ahead */
@@ -216,6 +217,10 @@ static inline void SetPageUptodate(struc
 #define ClearPageReclaim(page)	clear_bit(PG_reclaim, &(page)->flags)
 #define TestClearPageReclaim(page) test_and_clear_bit(PG_reclaim, &(page)->flags)
 
+#define PageSwapBacked(page)	test_bit(PG_swapbacked, &(page)->flags)
+#define SetPageSwapBacked(page)	set_bit(PG_swapbacked, &(page)->flags)
+#define __ClearPageSwapBacked(page)	__clear_bit(PG_swapbacked, &(page)->flags)
+
 #define PageCompound(page)	test_bit(PG_compound, &(page)->flags)
 #define __SetPageCompound(page)	__set_bit(PG_compound, &(page)->flags)
 #define __ClearPageCompound(page) __clear_bit(PG_compound, &(page)->flags)
Index: linux-2.6.24-rc3-mm2/mm/memory.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/mm/memory.c
+++ linux-2.6.24-rc3-mm2/mm/memory.c
@@ -1664,6 +1664,7 @@ gotten:
 		ptep_clear_flush(vma, address, page_table);
 		set_pte_at(mm, address, page_table, entry);
 		update_mmu_cache(vma, address, entry);
+		SetPageSwapBacked(new_page);
 		lru_cache_add_active(new_page);
 		page_add_new_anon_rmap(new_page, vma, address);
 
@@ -2132,6 +2133,7 @@ static int do_anonymous_page(struct mm_s
 	if (!pte_none(*page_table))
 		goto release;
 	inc_mm_counter(mm, anon_rss);
+	SetPageSwapBacked(page);
 	lru_cache_add_active(page);
 	page_add_new_anon_rmap(page, vma, address);
 	set_pte_at(mm, address, page_table, entry);
@@ -2285,6 +2287,7 @@ static int __do_fault(struct mm_struct *
 		set_pte_at(mm, address, page_table, entry);
 		if (anon) {
                         inc_mm_counter(mm, anon_rss);
+			SetPageSwapBacked(page);
                         lru_cache_add_active(page);
                         page_add_new_anon_rmap(page, vma, address);
 		} else {
Index: linux-2.6.24-rc3-mm2/mm/swap_state.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/mm/swap_state.c
+++ linux-2.6.24-rc3-mm2/mm/swap_state.c
@@ -86,6 +86,7 @@ static int __add_to_swap_cache(struct pa
 		if (!error) {
 			page_cache_get(page);
 			SetPageSwapCache(page);
+			SetPageSwapBacked(page);
 			set_page_private(page, entry.val);
 			total_swapcache_pages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
Index: linux-2.6.24-rc3-mm2/mm/migrate.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/mm/migrate.c
+++ linux-2.6.24-rc3-mm2/mm/migrate.c
@@ -546,6 +546,8 @@ static int move_to_new_page(struct page 
 	/* Prepare mapping for the new page.*/
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
+	if (PageSwapBacked(page))
+		SetPageSwapBacked(newpage);
 
 	mapping = page_mapping(page);
 	if (!mapping)
Index: linux-2.6.24-rc3-mm2/mm/page_alloc.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/mm/page_alloc.c
+++ linux-2.6.24-rc3-mm2/mm/page_alloc.c
@@ -253,6 +253,7 @@ static void bad_page(struct page *page)
 			1 << PG_slab    |
 			1 << PG_swapcache |
 			1 << PG_writeback |
+			1 << PG_swapbacked |
 			1 << PG_buddy );
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
@@ -486,6 +487,8 @@ static inline int free_pages_check(struc
 		bad_page(page);
 	if (PageDirty(page))
 		__ClearPageDirty(page);
+	if (PageSwapBacked(page))
+		__ClearPageSwapBacked(page);
 	/*
 	 * For now, we report if PG_reserved was found set, but do not
 	 * clear it, and do not free the page.  But we shall soon need
@@ -632,6 +635,7 @@ static int prep_new_page(struct page *pa
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
+			1 << PG_swapbacked |
 			1 << PG_buddy ))))
 		bad_page(page);
 

-- 
All Rights Reversed


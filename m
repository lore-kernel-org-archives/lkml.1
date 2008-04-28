Return-Path: <linux-kernel-owner+w=401wt.eu-S966011AbYD1S3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966011AbYD1S3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936567AbYD1SXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:23:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935600AbYD1SXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:23:03 -0400
Message-Id: <20080428181852.711040391@redhat.com>
References: <20080428181835.502876582@redhat.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 14:18:41 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH -mm 06/15] define page_file_cache() function
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


Index: linux-2.6.25-mm1/include/linux/mm_inline.h
===================================================================
--- linux-2.6.25-mm1.orig/include/linux/mm_inline.h	2008-04-24 10:46:43.000000000 -0400
+++ linux-2.6.25-mm1/include/linux/mm_inline.h	2008-04-24 12:00:01.000000000 -0400
@@ -1,3 +1,26 @@
+#ifndef LINUX_MM_INLINE_H
+#define LINUX_MM_INLINE_H
+
+/**
+ * page_file_cache - should the page be on a file LRU or anon LRU?
+ * @page: the page to test
+ *
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
 add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l)
 {
@@ -49,3 +72,4 @@ del_page_from_lru(struct zone *zone, str
 	__dec_zone_state(zone, NR_INACTIVE + l);
 }
 
+#endif
Index: linux-2.6.25-mm1/mm/shmem.c
===================================================================
--- linux-2.6.25-mm1.orig/mm/shmem.c	2008-04-22 10:33:45.000000000 -0400
+++ linux-2.6.25-mm1/mm/shmem.c	2008-04-24 12:00:01.000000000 -0400
@@ -1378,6 +1378,7 @@ repeat:
 				goto failed;
 			}
 
+			SetPageSwapBacked(filepage);
 			spin_lock(&info->lock);
 			entry = shmem_swp_alloc(info, idx, sgp);
 			if (IS_ERR(entry))
Index: linux-2.6.25-mm1/include/linux/page-flags.h
===================================================================
--- linux-2.6.25-mm1.orig/include/linux/page-flags.h	2008-04-22 10:33:44.000000000 -0400
+++ linux-2.6.25-mm1/include/linux/page-flags.h	2008-04-24 12:00:01.000000000 -0400
@@ -93,6 +93,7 @@ enum pageflags {
 	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_buddy,		/* Page is free, on buddy lists */
+	PG_swapbacked,		/* Page is backed by RAM/swap */
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
 	PG_uncached,		/* Page has been mapped as uncached */
 #endif
@@ -160,6 +161,7 @@ PAGEFLAG(Pinned, owner_priv_1) TESTSCFLA
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
 	__SETPAGEFLAG(Private, private)
+PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
 
 /*
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
Index: linux-2.6.25-mm1/mm/memory.c
===================================================================
--- linux-2.6.25-mm1.orig/mm/memory.c	2008-04-22 10:33:45.000000000 -0400
+++ linux-2.6.25-mm1/mm/memory.c	2008-04-24 12:00:01.000000000 -0400
@@ -1756,6 +1756,7 @@ gotten:
 		ptep_clear_flush(vma, address, page_table);
 		set_pte_at(mm, address, page_table, entry);
 		update_mmu_cache(vma, address, entry);
+		SetPageSwapBacked(new_page);
 		lru_cache_add_active(new_page);
 		page_add_new_anon_rmap(new_page, vma, address);
 
@@ -2224,6 +2225,7 @@ static int do_anonymous_page(struct mm_s
 	if (!pte_none(*page_table))
 		goto release;
 	inc_mm_counter(mm, anon_rss);
+	SetPageSwapBacked(page);
 	lru_cache_add_active(page);
 	page_add_new_anon_rmap(page, vma, address);
 	set_pte_at(mm, address, page_table, entry);
@@ -2367,6 +2369,7 @@ static int __do_fault(struct mm_struct *
 		set_pte_at(mm, address, page_table, entry);
 		if (anon) {
                         inc_mm_counter(mm, anon_rss);
+			SetPageSwapBacked(page);
                         lru_cache_add_active(page);
                         page_add_new_anon_rmap(page, vma, address);
 		} else {
Index: linux-2.6.25-mm1/mm/swap_state.c
===================================================================
--- linux-2.6.25-mm1.orig/mm/swap_state.c	2008-04-22 10:33:45.000000000 -0400
+++ linux-2.6.25-mm1/mm/swap_state.c	2008-04-24 12:00:01.000000000 -0400
@@ -82,6 +82,7 @@ int add_to_swap_cache(struct page *page,
 		if (!error) {
 			page_cache_get(page);
 			SetPageSwapCache(page);
+			SetPageSwapBacked(page);
 			set_page_private(page, entry.val);
 			total_swapcache_pages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
Index: linux-2.6.25-mm1/mm/migrate.c
===================================================================
--- linux-2.6.25-mm1.orig/mm/migrate.c	2008-04-24 11:59:51.000000000 -0400
+++ linux-2.6.25-mm1/mm/migrate.c	2008-04-24 12:00:01.000000000 -0400
@@ -546,6 +546,8 @@ static int move_to_new_page(struct page 
 	/* Prepare mapping for the new page.*/
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
+	if (PageSwapBacked(page))
+		SetPageSwapBacked(newpage);
 
 	mapping = page_mapping(page);
 	if (!mapping)
Index: linux-2.6.25-mm1/mm/page_alloc.c
===================================================================
--- linux-2.6.25-mm1.orig/mm/page_alloc.c	2008-04-24 10:46:43.000000000 -0400
+++ linux-2.6.25-mm1/mm/page_alloc.c	2008-04-24 12:00:01.000000000 -0400
@@ -261,6 +261,7 @@ static void bad_page(struct page *page)
 			1 << PG_slab    |
 			1 << PG_swapcache |
 			1 << PG_writeback |
+			1 << PG_swapbacked |
 			1 << PG_buddy );
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
@@ -494,6 +495,8 @@ static inline int free_pages_check(struc
 		bad_page(page);
 	if (PageDirty(page))
 		__ClearPageDirty(page);
+	if (PageSwapBacked(page))
+		__ClearPageSwapBacked(page);
 	/*
 	 * For now, we report if PG_reserved was found set, but do not
 	 * clear it, and do not free the page.  But we shall soon need
@@ -644,6 +647,7 @@ static int prep_new_page(struct page *pa
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
+			1 << PG_swapbacked |
 			1 << PG_buddy ))))
 		bad_page(page);
 

-- 
All Rights Reversed


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760436AbYFKSvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436AbYFKSvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbYFKSrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:47:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758055AbYFKSra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:47:30 -0400
Message-Id: <20080611184339.080925920@redhat.com>
References: <20080611184214.605110868@redhat.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Jun 2008 14:42:19 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       MinChan Kim <minchan.kim@gmail.com>
Subject: [PATCH -mm 05/24] define page_file_cache() function
Content-Disposition: inline; filename=vmscan-define-page_file_cache-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

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

The total number of page flags in use on a 32 bit
machine after this patch is 19.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: MinChan Kim <minchan.kim@gmail.com>

---
 include/linux/mm_inline.h  |   27 +++++++++++++++++++++++++++
 include/linux/page-flags.h |    2 ++
 mm/memory.c                |    3 +++
 mm/migrate.c               |    2 ++
 mm/page_alloc.c            |    4 ++++
 mm/shmem.c                 |    1 +
 mm/swap_state.c            |    3 +++
 7 files changed, 42 insertions(+)

Index: linux-2.6.26-rc5-mm2/include/linux/mm_inline.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/linux/mm_inline.h	2008-06-10 13:18:26.000000000 -0400
+++ linux-2.6.26-rc5-mm2/include/linux/mm_inline.h	2008-06-10 13:34:48.000000000 -0400
@@ -1,3 +1,28 @@
+#ifndef LINUX_MM_INLINE_H
+#define LINUX_MM_INLINE_H
+
+/**
+ * page_is_file_cache - should the page be on a file LRU or anon LRU?
+ * @page: the page to test
+ *
+ * Returns !0 if @page is page cache page backed by a regular filesystem,
+ * or 0 if @page is anonymous, tmpfs or otherwise ram or swap backed.
+ * Used by functions that manipulate the LRU lists, to sort a page
+ * onto the right LRU list.
+ *
+ * We would like to get this info without a page flag, but the state
+ * needs to survive until the page is last deleted from the LRU, which
+ * could be as far down as __page_cache_release.
+ */
+static inline int page_is_file_cache(struct page *page)
+{
+	if (PageSwapBacked(page))
+		return 0;
+
+	/* The page is page cache backed by a normal filesystem. */
+	return 1;
+}
+
 static inline void
 add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l)
 {
@@ -65,3 +90,5 @@ static inline enum lru_list page_lru(str
 
 	return lru;
 }
+
+#endif
Index: linux-2.6.26-rc5-mm2/mm/shmem.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/shmem.c	2008-06-10 10:46:29.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/shmem.c	2008-06-10 13:34:48.000000000 -0400
@@ -1387,6 +1387,7 @@ repeat:
 				goto failed;
 			}
 
+			SetPageSwapBacked(filepage);
 			spin_lock(&info->lock);
 			entry = shmem_swp_alloc(info, idx, sgp);
 			if (IS_ERR(entry))
Index: linux-2.6.26-rc5-mm2/include/linux/page-flags.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/linux/page-flags.h	2008-06-10 10:46:23.000000000 -0400
+++ linux-2.6.26-rc5-mm2/include/linux/page-flags.h	2008-06-10 13:34:48.000000000 -0400
@@ -93,6 +93,7 @@ enum pageflags {
 	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_buddy,		/* Page is free, on buddy lists */
+	PG_swapbacked,		/* Page is backed by RAM/swap */
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
 	PG_uncached,		/* Page has been mapped as uncached */
 #endif
@@ -176,6 +177,7 @@ PAGEFLAG(SavePinned, savepinned);			/* X
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
 	__SETPAGEFLAG(Private, private)
+PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
 
 __PAGEFLAG(SlobPage, slob_page)
 __PAGEFLAG(SlobFree, slob_free)
Index: linux-2.6.26-rc5-mm2/mm/memory.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/memory.c	2008-06-10 10:46:25.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/memory.c	2008-06-10 13:34:48.000000000 -0400
@@ -1804,6 +1804,7 @@ gotten:
 		ptep_clear_flush(vma, address, page_table);
 		set_pte_at(mm, address, page_table, entry);
 		update_mmu_cache(vma, address, entry);
+		SetPageSwapBacked(new_page);
 		lru_cache_add_active(new_page);
 		page_add_new_anon_rmap(new_page, vma, address);
 
@@ -2272,6 +2273,7 @@ static int do_anonymous_page(struct mm_s
 	if (!pte_none(*page_table))
 		goto release;
 	inc_mm_counter(mm, anon_rss);
+	SetPageSwapBacked(page);
 	lru_cache_add_active(page);
 	page_add_new_anon_rmap(page, vma, address);
 	set_pte_at(mm, address, page_table, entry);
@@ -2413,6 +2415,7 @@ static int __do_fault(struct mm_struct *
 		set_pte_at(mm, address, page_table, entry);
 		if (anon) {
                         inc_mm_counter(mm, anon_rss);
+			SetPageSwapBacked(page);
                         lru_cache_add_active(page);
                         page_add_new_anon_rmap(page, vma, address);
 		} else {
Index: linux-2.6.26-rc5-mm2/mm/swap_state.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/swap_state.c	2008-06-10 10:46:29.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/swap_state.c	2008-06-10 13:34:48.000000000 -0400
@@ -74,6 +74,7 @@ int add_to_swap_cache(struct page *page,
 	BUG_ON(!PageLocked(page));
 	BUG_ON(PageSwapCache(page));
 	BUG_ON(PagePrivate(page));
+	BUG_ON(!PageSwapBacked(page));
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
 		write_lock_irq(&swapper_space.tree_lock);
@@ -296,6 +297,7 @@ struct page *read_swap_cache_async(swp_e
 		 * May fail (-ENOMEM) if radix-tree node allocation failed.
 		 */
 		SetPageLocked(new_page);
+		SetPageSwapBacked(new_page);
 		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
 		if (!err) {
 			/*
@@ -305,6 +307,7 @@ struct page *read_swap_cache_async(swp_e
 			swap_readpage(NULL, new_page);
 			return new_page;
 		}
+		ClearPageSwapBacked(new_page);
 		ClearPageLocked(new_page);
 		swap_free(entry);
 	} while (err != -ENOMEM);
Index: linux-2.6.26-rc5-mm2/mm/migrate.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/migrate.c	2008-06-10 13:18:58.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/migrate.c	2008-06-10 13:34:48.000000000 -0400
@@ -564,6 +564,8 @@ static int move_to_new_page(struct page 
 	/* Prepare mapping for the new page.*/
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
+	if (PageSwapBacked(page))
+		SetPageSwapBacked(newpage);
 
 	mapping = page_mapping(page);
 	if (!mapping)
Index: linux-2.6.26-rc5-mm2/mm/page_alloc.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/page_alloc.c	2008-06-10 13:18:26.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/page_alloc.c	2008-06-10 13:34:48.000000000 -0400
@@ -246,6 +246,7 @@ static void bad_page(struct page *page)
 			1 << PG_slab    |
 			1 << PG_swapcache |
 			1 << PG_writeback |
+			1 << PG_swapbacked |
 			1 << PG_buddy );
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
@@ -477,6 +478,8 @@ static inline int free_pages_check(struc
 		bad_page(page);
 	if (PageDirty(page))
 		__ClearPageDirty(page);
+	if (PageSwapBacked(page))
+		__ClearPageSwapBacked(page);
 	/*
 	 * For now, we report if PG_reserved was found set, but do not
 	 * clear it, and do not free the page.  But we shall soon need
@@ -627,6 +630,7 @@ static int prep_new_page(struct page *pa
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
+			1 << PG_swapbacked |
 			1 << PG_buddy ))))
 		bad_page(page);
 

-- 
All Rights Reversed


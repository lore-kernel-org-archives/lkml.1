Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbXGWNSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbXGWNSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbXGWNSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:18:06 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:57676 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbXGWNSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:18:04 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] [PATCH 4/5] Dynamically allocated pageflags - PageSlab conversion.
Date: Mon, 23 Jul 2007 23:16:44 +1000
User-Agent: KMail/1.9.6
References: <200707232305.12364.nigel@nigel.suspend2.net>
In-Reply-To: <200707232305.12364.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707232316.44370.nigel@nigel.suspend2.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert PageSlab to use dynamically allocated page flags.

I'm not sure that we'll actually want to apply this, but it does work
(I'm using it as I type this).

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>


 include/linux/page-flags.h |    8 ++++----
 mm/dyn_pageflags.c         |    4 ++++
 mm/page_alloc.c            |    6 +++---
 mm/slub.c                  |    2 +-
 4 files changed, 12 insertions(+), 8 deletions(-)
diff -ruNp 922-page-slab-pageflag.patch-old/include/linux/page-flags.h 922-page-slab-pageflag.patch-new/include/linux/page-flags.h
--- 922-page-slab-pageflag.patch-old/include/linux/page-flags.h	2007-07-23 22:13:30.000000000 +1000
+++ 922-page-slab-pageflag.patch-new/include/linux/page-flags.h	2007-07-23 22:13:33.000000000 +1000
@@ -76,7 +76,6 @@
 #define PG_dirty	 	 4
 #define PG_lru			 5
 #define PG_active		 6
-#define PG_slab			 7	/* slab debug (Suparna wants this) */
 
 #define PG_owner_priv_1		 8	/* Owner use. If pagecache, fs may use*/
 #define PG_arch_1		 9
@@ -156,9 +155,10 @@ static inline void SetPageUptodate(struc
 #define ClearPageActive(page)	clear_bit(PG_active, &(page)->flags)
 #define __ClearPageActive(page)	__clear_bit(PG_active, &(page)->flags)
 
-#define PageSlab(page)		test_bit(PG_slab, &(page)->flags)
-#define __SetPageSlab(page)	__set_bit(PG_slab, &(page)->flags)
-#define __ClearPageSlab(page)	__clear_bit(PG_slab, &(page)->flags)
+extern struct dyn_pageflags dyn_Slab_map;
+#define PageSlab(page)	test_dynpageflag(&dyn_Slab_map, page)
+#define __SetPageSlab(page)	set_dynpageflag(&dyn_Slab_map, page)
+#define __ClearPageSlab(page)	clear_dynpageflag(&dyn_Slab_map, page)
 
 #ifdef CONFIG_HIGHMEM
 #define PageHighMem(page)	is_highmem(page_zone(page))
diff -ruNp 922-page-slab-pageflag.patch-old/mm/dyn_pageflags.c 922-page-slab-pageflag.patch-new/mm/dyn_pageflags.c
--- 922-page-slab-pageflag.patch-old/mm/dyn_pageflags.c	2007-07-23 22:13:30.000000000 +1000
+++ 922-page-slab-pageflag.patch-new/mm/dyn_pageflags.c	2007-07-23 22:13:33.000000000 +1000
@@ -114,6 +114,7 @@ static int dyn_pageflags_debug = 0;
 		for (zone_nr = 0; zone_nr < MAX_NR_ZONES; zone_nr++)
 
 DECLARE_DYN_PAGEFLAGS(dyn_MappedToDisk_map);
+DECLARE_DYN_PAGEFLAGS(dyn_Slab_map);
 #ifdef CONFIG_SWAP
 DECLARE_DYN_PAGEFLAGS(dyn_SwapCache_map);
 #endif
@@ -242,6 +243,9 @@ static void *normal_allocator(unsigned l
 void __init dyn_pageflags_init(void)
 {
 	dyn_allocator = boot_time_allocator;
+
+	/* Allocate the slab map early and not sparse. */
+	BUG_ON(allocate_dyn_pageflags(&dyn_Slab_map, 0));
 }
 
 /**
diff -ruNp 922-page-slab-pageflag.patch-old/mm/page_alloc.c 922-page-slab-pageflag.patch-new/mm/page_alloc.c
--- 922-page-slab-pageflag.patch-old/mm/page_alloc.c	2007-07-23 22:13:30.000000000 +1000
+++ 922-page-slab-pageflag.patch-new/mm/page_alloc.c	2007-07-23 22:13:33.000000000 +1000
@@ -203,10 +203,10 @@ static void bad_page(struct page *page)
 			1 << PG_active	|
 			1 << PG_dirty	|
 			1 << PG_reclaim |
-			1 << PG_slab    |
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_buddy );
+	__ClearPageSlab(page);
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
 	page->mapping = NULL;
@@ -433,12 +433,12 @@ static inline int free_pages_check(struc
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(page_count(page) != 0)  |
+		(PageSlab(page))	 |
 		(page->flags & (
 			1 << PG_lru	|
 			1 << PG_private |
 			1 << PG_locked	|
 			1 << PG_active	|
-			1 << PG_slab	|
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
@@ -587,6 +587,7 @@ static int prep_new_page(struct page *pa
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(page_count(page) != 0)  |
+		(PageSlab(page))	 |
 		(page->flags & (
 			1 << PG_lru	|
 			1 << PG_private	|
@@ -594,7 +595,6 @@ static int prep_new_page(struct page *pa
 			1 << PG_active	|
 			1 << PG_dirty	|
 			1 << PG_reclaim	|
-			1 << PG_slab    |
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
diff -ruNp 922-page-slab-pageflag.patch-old/mm/slub.c 922-page-slab-pageflag.patch-new/mm/slub.c
--- 922-page-slab-pageflag.patch-old/mm/slub.c	2007-07-11 22:19:42.000000000 +1000
+++ 922-page-slab-pageflag.patch-new/mm/slub.c	2007-07-23 19:48:40.000000000 +1000
@@ -1032,7 +1032,7 @@ static struct page *new_slab(struct kmem
 		atomic_long_inc(&n->nr_slabs);
 	page->offset = s->offset / sizeof(void *);
 	page->slab = s;
-	page->flags |= 1 << PG_slab;
+	__SetPageSlab(page);
 	if (s->flags & (SLAB_DEBUG_FREE | SLAB_RED_ZONE | SLAB_POISON |
 			SLAB_STORE_USER | SLAB_TRACE))
 		SetSlabDebug(page);

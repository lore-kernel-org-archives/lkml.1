Return-Path: <linux-kernel-owner+w=401wt.eu-S1763011AbXGWNTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763011AbXGWNTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbXGWNSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:18:10 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:57678 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbXGWNSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:18:07 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] [PATCH 5/5] Dynamically allocated pageflags - PageBuddy conversion.
Date: Mon, 23 Jul 2007 23:17:32 +1000
User-Agent: KMail/1.9.6
References: <200707232305.12364.nigel@nigel.suspend2.net>
In-Reply-To: <200707232305.12364.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Message-Id: <200707232317.32547.nigel@nigel.suspend2.net>
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert PageBuddy to dynamically allocate pageflags.

Again, not sure that we'd actually want to apply this, but it demonstrates
that the implementation is usable.

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>

 include/linux/page-flags.h |    8 ++++----
 mm/dyn_pageflags.c         |    2 ++
 mm/page_alloc.c            |   12 ++++++------
 3 files changed, 12 insertions(+), 10 deletions(-)
diff -ruNp 923-page-buddy-pageflags.patch-old/include/linux/page-flags.h 923-page-buddy-pageflags.patch-new/include/linux/page-flags.h
--- 923-page-buddy-pageflags.patch-old/include/linux/page-flags.h	2007-07-23 22:13:44.000000000 +1000
+++ 923-page-buddy-pageflags.patch-new/include/linux/page-flags.h	2007-07-23 19:48:40.000000000 +1000
@@ -87,7 +87,6 @@
 #define PG_swapcache		15	/* Swap page: swp_entry_t in private */
 
 #define PG_reclaim		17	/* To be reclaimed asap */
-#define PG_buddy		19	/* Page is free, on buddy lists */
 
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
@@ -213,9 +212,10 @@ extern struct dyn_pageflags dyn_Slab_map
 		ret;							\
 	})
 
-#define PageBuddy(page)		test_bit(PG_buddy, &(page)->flags)
-#define __SetPageBuddy(page)	__set_bit(PG_buddy, &(page)->flags)
-#define __ClearPageBuddy(page)	__clear_bit(PG_buddy, &(page)->flags)
+extern struct dyn_pageflags dyn_Buddy_map;
+#define PageBuddy(page)	test_dynpageflag(&dyn_Buddy_map, page)
+#define __SetPageBuddy(page)	set_dynpageflag(&dyn_Buddy_map, page)
+#define __ClearPageBuddy(page)	clear_dynpageflag(&dyn_Buddy_map, page)
 
 extern struct dyn_pageflags dyn_MappedToDisk_map;
 #define PageMappedToDisk(page)	test_dynpageflag(&dyn_MappedToDisk_map, page)
diff -ruNp 923-page-buddy-pageflags.patch-old/mm/dyn_pageflags.c 923-page-buddy-pageflags.patch-new/mm/dyn_pageflags.c
--- 923-page-buddy-pageflags.patch-old/mm/dyn_pageflags.c	2007-07-23 22:13:44.000000000 +1000
+++ 923-page-buddy-pageflags.patch-new/mm/dyn_pageflags.c	2007-07-23 22:11:10.000000000 +1000
@@ -115,6 +115,7 @@ static int dyn_pageflags_debug = 0;
 
 DECLARE_DYN_PAGEFLAGS(dyn_MappedToDisk_map);
 DECLARE_DYN_PAGEFLAGS(dyn_Slab_map);
+DECLARE_DYN_PAGEFLAGS(dyn_Buddy_map);
 #ifdef CONFIG_SWAP
 DECLARE_DYN_PAGEFLAGS(dyn_SwapCache_map);
 #endif
@@ -246,6 +247,7 @@ void __init dyn_pageflags_init(void)
 
 	/* Allocate the slab map early and not sparse. */
 	BUG_ON(allocate_dyn_pageflags(&dyn_Slab_map, 0));
+	BUG_ON(allocate_dyn_pageflags(&dyn_Buddy_map, 0));
 }
 
 /**
diff -ruNp 923-page-buddy-pageflags.patch-old/mm/page_alloc.c 923-page-buddy-pageflags.patch-new/mm/page_alloc.c
--- 923-page-buddy-pageflags.patch-old/mm/page_alloc.c	2007-07-23 22:13:44.000000000 +1000
+++ 923-page-buddy-pageflags.patch-new/mm/page_alloc.c	2007-07-23 19:48:40.000000000 +1000
@@ -204,9 +204,9 @@ static void bad_page(struct page *page)
 			1 << PG_dirty	|
 			1 << PG_reclaim |
 			1 << PG_swapcache |
-			1 << PG_writeback |
-			1 << PG_buddy );
+			1 << PG_writeback);
 	__ClearPageSlab(page);
+	__ClearPageBuddy(page);
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
 	page->mapping = NULL;
@@ -434,6 +434,7 @@ static inline int free_pages_check(struc
 		(page->mapping != NULL)  |
 		(page_count(page) != 0)  |
 		(PageSlab(page))	 |
+		(PageBuddy(page))	 |
 		(page->flags & (
 			1 << PG_lru	|
 			1 << PG_private |
@@ -441,8 +442,7 @@ static inline int free_pages_check(struc
 			1 << PG_active	|
 			1 << PG_swapcache |
 			1 << PG_writeback |
-			1 << PG_reserved |
-			1 << PG_buddy ))))
+			1 << PG_reserved))))
 		bad_page(page);
 	/*
 	 * PageReclaim == PageTail. It is only an error
@@ -588,6 +588,7 @@ static int prep_new_page(struct page *pa
 		(page->mapping != NULL)  |
 		(page_count(page) != 0)  |
 		(PageSlab(page))	 |
+		(PageBuddy(page))	 |
 		(page->flags & (
 			1 << PG_lru	|
 			1 << PG_private	|
@@ -597,8 +598,7 @@ static int prep_new_page(struct page *pa
 			1 << PG_reclaim	|
 			1 << PG_swapcache |
 			1 << PG_writeback |
-			1 << PG_reserved |
-			1 << PG_buddy ))))
+			1 << PG_reserved))))
 		bad_page(page);
 
 	/*

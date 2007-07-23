Return-Path: <linux-kernel-owner+w=401wt.eu-S1763090AbXGWNT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763090AbXGWNT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbXGWNSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:18:13 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:57680 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439AbXGWNSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:18:11 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] [PATCH 2/5] Dynamically allocated pageflags - PageMappedToDisk conversion.
Date: Mon, 23 Jul 2007 23:17:11 +1000
User-Agent: KMail/1.9.6
References: <200707232305.12364.nigel@nigel.suspend2.net>
In-Reply-To: <200707232305.12364.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707232317.11905.nigel@nigel.suspend2.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch the "MappedToDisk" pageflag to using dynpageflags.

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>


 include/linux/page-flags.h |    9 +++++----
 mm/dyn_pageflags.c         |    2 ++
 mm/page_alloc.c            |    3 ++-
 3 files changed, 9 insertions(+), 5 deletions(-)
diff -ruNp 920-mapped-to-disk-pageflag.patch-old/include/linux/page-flags.h 920-mapped-to-disk-pageflag.patch-new/include/linux/page-flags.h
--- 920-mapped-to-disk-pageflag.patch-old/include/linux/page-flags.h	2007-07-11 22:19:39.000000000 +1000
+++ 920-mapped-to-disk-pageflag.patch-new/include/linux/page-flags.h	2007-07-23 22:13:01.000000000 +1000
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <linux/mm_types.h>
+#include <linux/dyn_pageflags.h>
 
 /*
  * Various page->flags bits:
@@ -86,7 +87,6 @@
 #define PG_compound		14	/* Part of a compound page */
 #define PG_swapcache		15	/* Swap page: swp_entry_t in private */
 
-#define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
 #define PG_reclaim		17	/* To be reclaimed asap */
 #define PG_buddy		19	/* Page is free, on buddy lists */
 
@@ -217,9 +217,10 @@ static inline void SetPageUptodate(struc
 #define __SetPageBuddy(page)	__set_bit(PG_buddy, &(page)->flags)
 #define __ClearPageBuddy(page)	__clear_bit(PG_buddy, &(page)->flags)
 
-#define PageMappedToDisk(page)	test_bit(PG_mappedtodisk, &(page)->flags)
-#define SetPageMappedToDisk(page) set_bit(PG_mappedtodisk, &(page)->flags)
-#define ClearPageMappedToDisk(page) clear_bit(PG_mappedtodisk, &(page)->flags)
+extern struct dyn_pageflags dyn_MappedToDisk_map;
+#define PageMappedToDisk(page)	test_dynpageflag(&dyn_MappedToDisk_map, page)
+#define SetPageMappedToDisk(page)	set_dynpageflag(&dyn_MappedToDisk_map, page)
+#define ClearPageMappedToDisk(page)	clear_dynpageflag(&dyn_MappedToDisk_map, page)
 
 #define PageReclaim(page)	test_bit(PG_reclaim, &(page)->flags)
 #define SetPageReclaim(page)	set_bit(PG_reclaim, &(page)->flags)
diff -ruNp 920-mapped-to-disk-pageflag.patch-old/mm/dyn_pageflags.c 920-mapped-to-disk-pageflag.patch-new/mm/dyn_pageflags.c
--- 920-mapped-to-disk-pageflag.patch-old/mm/dyn_pageflags.c	2007-07-23 22:12:58.000000000 +1000
+++ 920-mapped-to-disk-pageflag.patch-new/mm/dyn_pageflags.c	2007-07-23 22:13:01.000000000 +1000
@@ -113,6 +113,8 @@ static int dyn_pageflags_debug = 0;
 	for_each_online_pgdat(pgdat) \
 		for (zone_nr = 0; zone_nr < MAX_NR_ZONES; zone_nr++)
 
+DECLARE_DYN_PAGEFLAGS(dyn_MappedToDisk_map);
+
 /**
  * dump_pagemap: Display the contents of a bitmap for debugging purposes.
  *
diff -ruNp 920-mapped-to-disk-pageflag.patch-old/mm/page_alloc.c 920-mapped-to-disk-pageflag.patch-new/mm/page_alloc.c
--- 920-mapped-to-disk-pageflag.patch-old/mm/page_alloc.c	2007-07-11 22:19:42.000000000 +1000
+++ 920-mapped-to-disk-pageflag.patch-new/mm/page_alloc.c	2007-07-23 22:13:01.000000000 +1000
@@ -610,7 +610,8 @@ static int prep_new_page(struct page *pa
 
 	page->flags &= ~(1 << PG_uptodate | 1 << PG_error |
 			1 << PG_referenced | 1 << PG_arch_1 |
-			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk);
+			1 << PG_owner_priv_1);
+	ClearPageMappedToDisk(page);
 	set_page_private(page, 0);
 	set_page_refcounted(page);
 

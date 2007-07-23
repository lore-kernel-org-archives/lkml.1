Return-Path: <linux-kernel-owner+w=401wt.eu-S1761885AbXGWNTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761885AbXGWNTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758847AbXGWNSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:18:12 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:57679 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbXGWNSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:18:11 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] [PATCH 3/5] Dynamically allocated pageflags - PageSwapCache conversion.
Date: Mon, 23 Jul 2007 23:15:58 +1000
User-Agent: KMail/1.9.6
References: <200707232305.12364.nigel@nigel.suspend2.net>
In-Reply-To: <200707232305.12364.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707232315.58891.nigel@nigel.suspend2.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch PageSwapCache flag to use dynamically allocated pageflags.

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>

 include/linux/page-flags.h |    7 ++++---
 mm/dyn_pageflags.c         |    3 +++
 2 files changed, 7 insertions(+), 3 deletions(-)
diff -ruNp 921-page-swap-cache-pageflag.patch-old/include/linux/page-flags.h 921-page-swap-cache-pageflag.patch-new/include/linux/page-flags.h
--- 921-page-swap-cache-pageflag.patch-old/include/linux/page-flags.h	2007-07-23 22:13:16.000000000 +1000
+++ 921-page-swap-cache-pageflag.patch-new/include/linux/page-flags.h	2007-07-23 22:13:18.000000000 +1000
@@ -260,9 +260,10 @@ static inline void __ClearPageTail(struc
 #define __ClearPageHead(page)	__ClearPageCompound(page)
 
 #ifdef CONFIG_SWAP
-#define PageSwapCache(page)	test_bit(PG_swapcache, &(page)->flags)
-#define SetPageSwapCache(page)	set_bit(PG_swapcache, &(page)->flags)
-#define ClearPageSwapCache(page) clear_bit(PG_swapcache, &(page)->flags)
+extern struct dyn_pageflags dyn_SwapCache_map;
+#define PageSwapCache(page)	test_dynpageflag(&dyn_SwapCache_map, page)
+#define SetPageSwapCache(page)	set_dynpageflag(&dyn_SwapCache_map, page)
+#define ClearPageSwapCache(page)	clear_dynpageflag(&dyn_SwapCache_map, page)
 #else
 #define PageSwapCache(page)	0
 #endif
diff -ruNp 921-page-swap-cache-pageflag.patch-old/mm/dyn_pageflags.c 921-page-swap-cache-pageflag.patch-new/mm/dyn_pageflags.c
--- 921-page-swap-cache-pageflag.patch-old/mm/dyn_pageflags.c	2007-07-23 22:13:16.000000000 +1000
+++ 921-page-swap-cache-pageflag.patch-new/mm/dyn_pageflags.c	2007-07-23 22:13:18.000000000 +1000
@@ -114,6 +114,9 @@ static int dyn_pageflags_debug = 0;
 		for (zone_nr = 0; zone_nr < MAX_NR_ZONES; zone_nr++)
 
 DECLARE_DYN_PAGEFLAGS(dyn_MappedToDisk_map);
+#ifdef CONFIG_SWAP
+DECLARE_DYN_PAGEFLAGS(dyn_SwapCache_map);
+#endif
 
 /**
  * dump_pagemap: Display the contents of a bitmap for debugging purposes.

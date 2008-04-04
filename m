Return-Path: <linux-kernel-owner+w=401wt.eu-S1761643AbYDDNCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643AbYDDNCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760500AbYDDM5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:57:22 -0400
Received: from saeurebad.de ([85.214.36.134]:44772 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760358AbYDDM5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:57:21 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:52:32 2008
Message-Id: <20080404115231.894558747@skyscraper.fehenstaub.lan>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:51:46 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Subject: [patch 09/22 -v2] m32r: Use generic show_mem()
Content-Disposition: inline; filename=m32r-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Hirokazu Takata <takata@linux-m32r.org>
---

Index: tree-linus/arch/m32r/Kconfig
===================================================================
--- tree-linus.orig/arch/m32r/Kconfig
+++ tree-linus/arch/m32r/Kconfig
@@ -10,7 +10,6 @@ config M32R
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
-	select HAVE_ARCH_SHOW_MEM
 
 config SBUS
 	bool
Index: tree-linus/arch/m32r/mm/init.c
===================================================================
--- tree-linus.orig/arch/m32r/mm/init.c
+++ tree-linus/arch/m32r/mm/init.c
@@ -36,41 +36,6 @@ pgd_t swapper_pg_dir[1024];
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-void show_mem(void)
-{
-	int total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-	int highmem = 0;
-	struct page *page;
-	pg_data_t *pgdat;
-	unsigned long i;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		unsigned long flags;
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
-			page = pgdat_page_nr(pgdat, i);
-			total++;
-			if (PageHighMem(page))
-				highmem++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (page_count(page))
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-	}
-	printk("%d pages of RAM\n", total);
-	printk("%d pages of HIGHMEM\n",highmem);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages shared\n",shared);
-	printk("%d pages swap cached\n",cached);
-}
-
 /*
  * Cache of MMU context last used.
  */

-- 


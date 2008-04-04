Return-Path: <linux-kernel-owner+w=401wt.eu-S1760510AbYDDNA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760510AbYDDNA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760284AbYDDM42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:56:28 -0400
Received: from saeurebad.de ([85.214.36.134]:44755 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760403AbYDDM42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:56:28 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:52:31 2008
Message-Id: <20080404115231.162496419@skyscraper.fehenstaub.lan>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:51:41 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [patch 04/22 -v2] avr32: Use generic show_mem()
Content-Disposition: inline; filename=avr32-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in slabs, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
---

Index: tree-linus/arch/avr32/Kconfig
===================================================================
--- tree-linus.orig/arch/avr32/Kconfig
+++ tree-linus/arch/avr32/Kconfig
@@ -13,7 +13,6 @@ config AVR32
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
-	select HAVE_ARCH_SHOW_MEM
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
Index: tree-linus/arch/avr32/mm/init.c
===================================================================
--- tree-linus.orig/arch/avr32/mm/init.c
+++ tree-linus/arch/avr32/mm/init.c
@@ -37,45 +37,6 @@ unsigned long mmu_context_cache = NO_CON
 #define START_PFN	(NODE_DATA(0)->bdata->node_boot_start >> PAGE_SHIFT)
 #define MAX_LOW_PFN	(NODE_DATA(0)->bdata->node_low_pfn)
 
-void show_mem(void)
-{
-	int total = 0, reserved = 0, cached = 0;
-	int slab = 0, free = 0, shared = 0;
-	pg_data_t *pgdat;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-
-	for_each_online_pgdat(pgdat) {
-		struct page *page, *end;
-
-		page = pgdat->node_mem_map;
-		end = page + pgdat->node_spanned_pages;
-
-		do {
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (PageSlab(page))
-				slab++;
-			else if (!page_count(page))
-				free++;
-			else
-				shared += page_count(page) - 1;
-			page++;
-		} while (page < end);
-	}
-
-	printk ("%d pages of RAM\n", total);
-	printk ("%d free pages\n", free);
-	printk ("%d reserved pages\n", reserved);
-	printk ("%d slab pages\n", slab);
-	printk ("%d pages shared\n", shared);
-	printk ("%d pages swap cached\n", cached);
-}
-
 /*
  * paging_init() sets up the page tables
  *

-- 


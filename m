Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYDGPu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYDGPu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758377AbYDGPtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:49:35 -0400
Received: from saeurebad.de ([85.214.36.134]:44731 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436AbYDGPte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:49:34 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Mon Apr  7 16:42:39 2008
Message-Id: <20080407144239.710893944@skyscraper.fehenstaub.lan>
References: <20080407144008.124362640@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Mon, 07 Apr 2008 16:40:12 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [patch 04/22 -v3] avr32: Use generic show_mem()
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
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---

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
Index: tree-linus/arch/avr32/Kconfig
===================================================================
--- tree-linus.orig/arch/avr32/Kconfig
+++ tree-linus/arch/avr32/Kconfig
@@ -13,6 +13,7 @@ config AVR32
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_GENERIC_SHOW_MEM
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular

-- 


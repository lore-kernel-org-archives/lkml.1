Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYDGPy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYDGPy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759688AbYDGPvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:51:04 -0400
Received: from saeurebad.de ([85.214.36.134]:44790 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759659AbYDGPvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:51:01 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Mon Apr  7 16:42:41 2008
Message-Id: <20080407144241.602322063@skyscraper.fehenstaub.lan>
References: <20080407144008.124362640@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Mon, 07 Apr 2008 16:40:25 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Subject: [patch 17/22 -v3] sh: Use generic show_mem()
Content-Disposition: inline; filename=sh-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in slab, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---

Index: tree-linus/arch/sh/Kconfig
===================================================================
--- tree-linus.orig/arch/sh/Kconfig
+++ tree-linus/arch/sh/Kconfig
@@ -10,6 +10,7 @@ config SUPERH
 	select EMBEDDED
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_GENERIC_SHOW_MEM
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
Index: tree-linus/arch/sh/mm/init.c
===================================================================
--- tree-linus.orig/arch/sh/mm/init.c
+++ tree-linus/arch/sh/mm/init.c
@@ -25,46 +25,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
 pgd_t swapper_pg_dir[PTRS_PER_PGD];
 unsigned long cached_to_uncached = 0;
 
-void show_mem(void)
-{
-	int total = 0, reserved = 0, free = 0;
-	int shared = 0, cached = 0, slab = 0;
-	pg_data_t *pgdat;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-
-	for_each_online_pgdat(pgdat) {
-		unsigned long flags, i;
-
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page = pgdat_page_nr(pgdat, i);
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
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-	}
-
-	printk("%d pages of RAM\n", total);
-	printk("%d free pages\n", free);
-	printk("%d reserved pages\n", reserved);
-	printk("%d slab pages\n", slab);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n", cached);
-	printk(KERN_INFO "Total of %ld pages in page table cache\n",
-	       quicklist_total_size());
-}
-
 #ifdef CONFIG_MMU
 static void set_pte_phys(unsigned long addr, unsigned long phys, pgprot_t prot)
 {

-- 


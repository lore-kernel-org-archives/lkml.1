Return-Path: <linux-kernel-owner+w=401wt.eu-S1762125AbYDDNFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbYDDNFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760647AbYDDM6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:58:20 -0400
Received: from saeurebad.de ([85.214.36.134]:44830 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760907AbYDDM6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:58:19 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:52:33 2008
Message-Id: <20080404115232.917116665@skyscraper.fehenstaub.lan>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:51:53 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 16/22 -v2] s390: Use generic show_mem()
Content-Disposition: inline; filename=s390-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- pages in swapcache, printed by show_swap_cache_info()
	- dirty pages, writeback pages, mapped pages, slab pages,
	  pagetable pages, printed by show_free_areas()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

Index: tree-linus/arch/s390/Kconfig
===================================================================
--- tree-linus.orig/arch/s390/Kconfig
+++ tree-linus/arch/s390/Kconfig
@@ -62,7 +62,6 @@ config S390
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
-	select HAVE_ARCH_SHOW_MEM
 
 source "init/Kconfig"
 
Index: tree-linus/arch/s390/mm/init.c
===================================================================
--- tree-linus.orig/arch/s390/mm/init.c
+++ tree-linus/arch/s390/mm/init.c
@@ -42,41 +42,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__((__aligned__(PAGE_SIZE)));
 char  empty_zero_page[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
 
-void show_mem(void)
-{
-	int i, total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-	struct page *page;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		if (!pfn_valid(i))
-			continue;
-		page = pfn_to_page(i);
-		total++;
-		if (PageReserved(page))
-			reserved++;
-		else if (PageSwapCache(page))
-			cached++;
-		else if (page_count(page))
-			shared += page_count(page) - 1;
-	}
-	printk("%d pages of RAM\n", total);
-	printk("%d reserved pages\n", reserved);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n", cached);
-
-	printk("%lu pages dirty\n", global_page_state(NR_FILE_DIRTY));
-	printk("%lu pages writeback\n", global_page_state(NR_WRITEBACK));
-	printk("%lu pages mapped\n", global_page_state(NR_FILE_MAPPED));
-	printk("%lu pages slab\n",
-	       global_page_state(NR_SLAB_RECLAIMABLE) +
-	       global_page_state(NR_SLAB_UNRECLAIMABLE));
-	printk("%lu pages pagetables\n", global_page_state(NR_PAGETABLE));
-}
-
 static void __init setup_ro_region(void)
 {
 	pgd_t *pgd;

-- 


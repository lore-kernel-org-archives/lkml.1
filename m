Return-Path: <linux-kernel-owner+w=401wt.eu-S1762303AbYF0MRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762303AbYF0MRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760512AbYF0MGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:06:32 -0400
Received: from saeurebad.de ([85.214.36.134]:39043 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760154AbYF0MGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:06:31 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun 27 14:00:50 2008
Message-Id: <20080627120050.037687440@saeurebad.de>
References: <20080627115349.743368154@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:54:04 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 15/20] s390: use generic show_mem()
Content-Disposition: inline; filename=0017-s390-use-generic-show_mem.patch
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
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/Kconfig   |    1 +
 arch/s390/mm/init.c |   32 --------------------------------
 2 files changed, 1 insertion(+), 32 deletions(-)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -73,6 +73,7 @@ config S390
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_GENERIC_SHOW_MEM
 	select HAVE_KVM if 64BIT
 
 source "init/Kconfig"
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -42,38 +42,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__((__aligned__(PAGE_SIZE)));
 char  empty_zero_page[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
 
-void show_mem(void)
-{
-	unsigned long i, total = 0, reserved = 0;
-	unsigned long shared = 0, cached = 0;
-	unsigned long flags;
-	struct page *page;
-	pg_data_t *pgdat;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			if (!pfn_valid(pgdat->node_start_pfn + i))
-				continue;
-			page = pfn_to_page(pgdat->node_start_pfn + i);
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (page_count(page))
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-	}
-	printk("%ld pages of RAM\n", total);
-	printk("%ld reserved pages\n", reserved);
-	printk("%ld pages shared\n", shared);
-	printk("%ld pages swap cached\n", cached);
-}
-
 /*
  * paging_init() sets up the page tables
  */

-- 


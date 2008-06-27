Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbYF0MSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbYF0MSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758306AbYF0MG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:06:57 -0400
Received: from saeurebad.de ([85.214.36.134]:39060 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760694AbYF0MGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:06:55 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun 27 14:00:50 2008
Message-Id: <20080627120050.655627923@saeurebad.de>
References: <20080627115349.743368154@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:54:08 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 19/20] x86: use generic show_mem()
Content-Disposition: inline; filename=0022-x86-use-generic-show_mem.patch
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
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig         |    1 +
 arch/x86/mm/init_64.c    |   37 -------------------------------------
 arch/x86/mm/pgtable_32.c |   47 -----------------------------------------------
 3 files changed, 1 insertion(+), 84 deletions(-)

--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -20,53 +20,6 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
-void show_mem(void)
-{
-	int total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-	int highmem = 0;
-	struct page *page;
-	pg_data_t *pgdat;
-	unsigned long i;
-	unsigned long flags;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
-			if (unlikely(i % MAX_ORDER_NR_PAGES == 0))
-				touch_nmi_watchdog();
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
-	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d pages of HIGHMEM\n", highmem);
-	printk(KERN_INFO "%d reserved pages\n", reserved);
-	printk(KERN_INFO "%d pages shared\n", shared);
-	printk(KERN_INFO "%d pages swap cached\n", cached);
-
-	printk(KERN_INFO "%lu pages dirty\n", global_page_state(NR_FILE_DIRTY));
-	printk(KERN_INFO "%lu pages writeback\n",
-					global_page_state(NR_WRITEBACK));
-	printk(KERN_INFO "%lu pages mapped\n", global_page_state(NR_FILE_MAPPED));
-	printk(KERN_INFO "%lu pages slab\n",
-		global_page_state(NR_SLAB_RECLAIMABLE) +
-		global_page_state(NR_SLAB_UNRECLAIMABLE));
-	printk(KERN_INFO "%lu pages pagetables\n",
-					global_page_state(NR_PAGETABLE));
-}
-
 /*
  * Associate a virtual page frame with a given physical page frame 
  * and protection flags for that frame.
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -78,43 +78,6 @@ early_param("gbpages", parse_direct_gbpa
  * around without checking the pgd every time.
  */
 
-void show_mem(void)
-{
-	long i, total = 0, reserved = 0;
-	long shared = 0, cached = 0;
-	struct page *page;
-	pg_data_t *pgdat;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
-			/*
-			 * This loop can take a while with 256 GB and
-			 * 4k pages so defer the NMI watchdog:
-			 */
-			if (unlikely(i % MAX_ORDER_NR_PAGES == 0))
-				touch_nmi_watchdog();
-
-			if (!pfn_valid(pgdat->node_start_pfn + i))
-				continue;
-
-			page = pfn_to_page(pgdat->node_start_pfn + i);
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (page_count(page))
-				shared += page_count(page) - 1;
-		}
-	}
-	printk(KERN_INFO "%lu pages of RAM\n",		total);
-	printk(KERN_INFO "%lu reserved pages\n",	reserved);
-	printk(KERN_INFO "%lu pages shared\n",		shared);
-	printk(KERN_INFO "%lu pages swap cached\n",	cached);
-}
-
 int after_bootmem;
 
 static __init void *spp_getpage(void)
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -28,6 +28,7 @@ config X86
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
+	select HAVE_GENERIC_SHOW_MEM
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 

-- 


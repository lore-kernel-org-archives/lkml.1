Return-Path: <linux-kernel-owner+w=401wt.eu-S1761016AbYF0MQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016AbYF0MQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758991AbYF0MG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:06:27 -0400
Received: from saeurebad.de ([85.214.36.134]:39041 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259AbYF0MGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:06:25 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun 27 14:00:50 2008
Message-Id: <20080627120049.883374735@saeurebad.de>
References: <20080627115349.743368154@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:54:03 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 14/20] powerpc: use generic show_mem()
Content-Disposition: inline; filename=0015-powerpc-use-generic-show_mem.patch
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
CC: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/Kconfig  |    1 +
 arch/powerpc/mm/mem.c |   39 ---------------------------------------
 2 files changed, 1 insertion(+), 39 deletions(-)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -114,6 +114,7 @@ config PPC
 	select HAVE_KRETPROBES
 	select HAVE_LMB
 	select HAVE_OPROFILE
+	select HAVE_GENERIC_SHOW_MEM
 	select USE_GENERIC_SMP_HELPERS if SMP
 
 config EARLY_PRINTK
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -185,45 +185,6 @@ walk_memory_resource(unsigned long start
 }
 EXPORT_SYMBOL_GPL(walk_memory_resource);
 
-void show_mem(void)
-{
-	unsigned long total = 0, reserved = 0;
-	unsigned long shared = 0, cached = 0;
-	unsigned long highmem = 0;
-	struct page *page;
-	pg_data_t *pgdat;
-	unsigned long i;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		unsigned long flags;
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			if (!pfn_valid(pgdat->node_start_pfn + i))
-				continue;
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
-	printk("%ld pages of RAM\n", total);
-#ifdef CONFIG_HIGHMEM
-	printk("%ld pages of HIGHMEM\n", highmem);
-#endif
-	printk("%ld reserved pages\n", reserved);
-	printk("%ld pages shared\n", shared);
-	printk("%ld pages swap cached\n", cached);
-}
-
 /*
  * Initialize the bootmem system and give it all the memory we
  * have available.  If we are using highmem, we only put the

-- 


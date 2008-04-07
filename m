Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbYDGPxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbYDGPxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759521AbYDGPun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:50:43 -0400
Received: from saeurebad.de ([85.214.36.134]:44779 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759515AbYDGPum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:50:42 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Mon Apr  7 16:42:41 2008
Message-Id: <20080407144241.165554254@skyscraper.fehenstaub.lan>
References: <20080407144008.124362640@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Mon, 07 Apr 2008 16:40:22 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Subject: [patch 14/22 -v3] powerpc: Use generic show_mem()
Content-Disposition: inline; filename=powerpc-use-generic-show_mem.patch
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

Index: tree-linus/arch/powerpc/Kconfig
===================================================================
--- tree-linus.orig/arch/powerpc/Kconfig
+++ tree-linus/arch/powerpc/Kconfig
@@ -91,6 +91,7 @@ config PPC
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_GENERIC_SHOW_MEM
 
 config EARLY_PRINTK
 	bool
Index: tree-linus/arch/powerpc/mm/mem.c
===================================================================
--- tree-linus.orig/arch/powerpc/mm/mem.c
+++ tree-linus/arch/powerpc/mm/mem.c
@@ -164,45 +164,6 @@ walk_memory_resource(unsigned long start
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
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


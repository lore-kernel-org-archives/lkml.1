Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbYF0MMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbYF0MMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758489AbYF0MFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:05:25 -0400
Received: from saeurebad.de ([85.214.36.134]:38996 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758925AbYF0MFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:05:22 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun 27 14:00:48 2008
Message-Id: <20080627120048.210681257@saeurebad.de>
References: <20080627115349.743368154@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:53:52 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>
Subject: [PATCH 03/20] alpha: use generic show_mem()
Content-Disposition: inline; filename=0004-alpha-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- free swap pages, printed by show_swap_cache_info()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/Kconfig   |    1 +
 arch/alpha/mm/init.c |   30 ------------------------------
 arch/alpha/mm/numa.c |   35 -----------------------------------
 3 files changed, 1 insertion(+), 65 deletions(-)

--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -7,6 +7,7 @@ config ALPHA
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_GENERIC_SHOW_MEM
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -94,36 +94,6 @@ __bad_page(void)
 	return pte_mkdirty(mk_pte(virt_to_page(EMPTY_PGE), PAGE_SHARED));
 }
 
-#ifndef CONFIG_DISCONTIGMEM
-void
-show_mem(void)
-{
-	long i,free = 0,total = 0,reserved = 0;
-	long shared = 0, cached = 0;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(mem_map+i))
-			free++;
-		else
-			shared += page_count(mem_map + i) - 1;
-	}
-	printk("%ld pages of RAM\n",total);
-	printk("%ld free pages\n",free);
-	printk("%ld reserved pages\n",reserved);
-	printk("%ld pages shared\n",shared);
-	printk("%ld pages swap cached\n",cached);
-}
-#endif
-
 static inline unsigned long
 load_PCB(struct pcb_struct *pcb)
 {
--- a/arch/alpha/mm/numa.c
+++ b/arch/alpha/mm/numa.c
@@ -359,38 +359,3 @@ void __init mem_init(void)
 	mem_stress();
 #endif
 }
-
-void
-show_mem(void)
-{
-	long i,free = 0,total = 0,reserved = 0;
-	long shared = 0, cached = 0;
-	int nid;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-	for_each_online_node(nid) {
-		unsigned long flags;
-		pgdat_resize_lock(NODE_DATA(nid), &flags);
-		i = node_spanned_pages(nid);
-		while (i-- > 0) {
-			struct page *page = nid_page_nr(nid, i);
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (!page_count(page))
-				free++;
-			else
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(NODE_DATA(nid), &flags);
-	}
-	printk("%ld pages of RAM\n",total);
-	printk("%ld free pages\n",free);
-	printk("%ld reserved pages\n",reserved);
-	printk("%ld pages shared\n",shared);
-	printk("%ld pages swap cached\n",cached);
-}

-- 


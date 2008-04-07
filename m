Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbYDGPuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbYDGPuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbYDGPta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:49:30 -0400
Received: from saeurebad.de ([85.214.36.134]:44729 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758778AbYDGPt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:49:28 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Mon Apr  7 16:42:39 2008
Message-Id: <20080407144239.565546337@skyscraper.fehenstaub.lan>
References: <20080407144008.124362640@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Mon, 07 Apr 2008 16:40:11 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Richard Henderson <rth@twiddle.net>
Subject: [patch 03/22 -v3] alpha: Use generic show_mem()
Content-Disposition: inline; filename=alpha-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Richard Henderson <rth@twiddle.net>
---

Index: tree-linus/arch/alpha/Kconfig
===================================================================
--- tree-linus.orig/arch/alpha/Kconfig
+++ tree-linus/arch/alpha/Kconfig
@@ -7,6 +7,7 @@ config ALPHA
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_GENERIC_SHOW_MEM
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
Index: tree-linus/arch/alpha/mm/init.c
===================================================================
--- tree-linus.orig/arch/alpha/mm/init.c
+++ tree-linus/arch/alpha/mm/init.c
@@ -94,35 +94,6 @@ __bad_page(void)
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
Index: tree-linus/arch/alpha/mm/numa.c
===================================================================
--- tree-linus.orig/arch/alpha/mm/numa.c
+++ tree-linus/arch/alpha/mm/numa.c
@@ -359,37 +359,3 @@ void __init mem_init(void)
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


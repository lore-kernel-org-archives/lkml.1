Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbYDGP41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbYDGP41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbYDGPvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:51:37 -0400
Received: from saeurebad.de ([85.214.36.134]:44808 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758784AbYDGPvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:51:35 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Mon Apr  7 16:42:42 2008
Message-Id: <20080407144242.328903153@skyscraper.fehenstaub.lan>
References: <20080407144008.124362640@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Mon, 07 Apr 2008 16:40:30 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Zankel <chris@zankel.net>
Subject: [patch 22/22 -v3] xtensa: Use generic show_mem()
Content-Disposition: inline; filename=xtensa-use-generic-show_mem.patch
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
CC: Chris Zankel <chris@zankel.net>
---

Index: tree-linus/arch/xtensa/mm/init.c
===================================================================
--- tree-linus.orig/arch/xtensa/mm/init.c
+++ tree-linus/arch/xtensa/mm/init.c
@@ -280,32 +280,6 @@ void free_initmem(void)
 	       (&__init_end - &__init_begin) >> 10);
 }
 
-void show_mem(void)
-{
-	int i, free = 0, total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(mem_map + i))
-			free++;
-		else
-			shared += page_count(mem_map + i) - 1;
-	}
-	printk("%d pages of RAM\n", total);
-	printk("%d reserved pages\n", reserved);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n",cached);
-	printk("%d free pages\n", free);
-}
-
 struct kmem_cache *pgtable_cache __read_mostly;
 
 static void pgd_ctor(struct kmem_cache *cache, void* addr)
Index: tree-linus/arch/xtensa/Kconfig
===================================================================
--- tree-linus.orig/arch/xtensa/Kconfig
+++ tree-linus/arch/xtensa/Kconfig
@@ -15,6 +15,7 @@ config XTENSA
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_GENERIC_SHOW_MEM
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both

-- 


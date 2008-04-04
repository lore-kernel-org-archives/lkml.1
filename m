Return-Path: <linux-kernel-owner+w=401wt.eu-S1762601AbYDDNII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762601AbYDDNII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760307AbYDDM7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:59:31 -0400
Received: from saeurebad.de ([85.214.36.134]:44863 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760348AbYDDM73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:59:29 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:52:33 2008
Message-Id: <20080404115233.795244074@skyscraper.fehenstaub.lan>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:51:59 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Zankel <chris@zankel.net>
Subject: [patch 22/22 -v2] xtensa: Use generic show_mem()
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

Index: tree-linus/arch/xtensa/Kconfig
===================================================================
--- tree-linus.orig/arch/xtensa/Kconfig
+++ tree-linus/arch/xtensa/Kconfig
@@ -15,7 +15,6 @@ config XTENSA
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_ARCH_SHOW_MEM
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
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

-- 


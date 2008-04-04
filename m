Return-Path: <linux-kernel-owner+w=401wt.eu-S1761397AbYDDNF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397AbYDDNF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760899AbYDDM6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:58:15 -0400
Received: from saeurebad.de ([85.214.36.134]:44826 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760080AbYDDM6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:58:13 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:52:32 2008
Message-Id: <20080404115232.771494735@skyscraper.fehenstaub.lan>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:51:52 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Subject: [patch 15/22 -v2] ppc: Use generic show_mem()
Content-Disposition: inline; filename=ppc-use-generic-show_mem.patch
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
CC: Paul Mackerras <paulus@samba.org>
---

Index: tree-linus/arch/ppc/Kconfig
===================================================================
--- tree-linus.orig/arch/ppc/Kconfig
+++ tree-linus/arch/ppc/Kconfig
@@ -45,7 +45,6 @@ config PPC
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
-	select HAVE_ARCH_SHOW_MEM
 
 config PPC32
 	bool
Index: tree-linus/arch/ppc/mm/init.c
===================================================================
--- tree-linus.orig/arch/ppc/mm/init.c
+++ tree-linus/arch/ppc/mm/init.c
@@ -101,36 +101,6 @@ unsigned long __max_memory;
 /* max amount of low RAM to map in */
 unsigned long __max_low_memory = MAX_LOW_MEM;
 
-void show_mem(void)
-{
-	int i,free = 0,total = 0,reserved = 0;
-	int shared = 0, cached = 0;
-	int highmem = 0;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageHighMem(mem_map+i))
-			highmem++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(mem_map+i))
-			free++;
-		else
-			shared += page_count(mem_map+i) - 1;
-	}
-	printk("%d pages of RAM\n",total);
-	printk("%d pages of HIGHMEM\n", highmem);
-	printk("%d free pages\n",free);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages shared\n",shared);
-	printk("%d pages swap cached\n",cached);
-}
-
 /* Free up now-unused memory */
 static void free_sec(unsigned long start, unsigned long end, const char *name)
 {

-- 


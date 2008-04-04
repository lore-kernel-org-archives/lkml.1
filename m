Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbYDDNDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbYDDNDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760633AbYDDM5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:57:46 -0400
Received: from saeurebad.de ([85.214.36.134]:44786 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760622AbYDDM5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:57:45 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:52:32 2008
Message-Id: <20080404115232.333370239@skyscraper.fehenstaub.lan>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:51:49 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 12/22 -v2] mips: Use generic show_mem()
Content-Disposition: inline; filename=mips-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version. 

This also removes the following redundant information display:

	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info(). 

And show_mem() does now actually print something on configurations
with multiple nodes. 

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
---

Index: tree-linus/arch/mips/Kconfig
===================================================================
--- tree-linus.orig/arch/mips/Kconfig
+++ tree-linus/arch/mips/Kconfig
@@ -6,7 +6,6 @@ config MIPS
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB
-	select HAVE_ARCH_SHOW_MEM
 
 mainmenu "Linux/MIPS Kernel Configuration"
 
Index: tree-linus/arch/mips/mm/Makefile
===================================================================
--- tree-linus.orig/arch/mips/mm/Makefile
+++ tree-linus/arch/mips/mm/Makefile
@@ -3,8 +3,7 @@
 #
 
 obj-y				+= cache.o dma-default.o extable.o fault.o \
-				   init.o pgtable.o tlbex.o tlbex-fault.o \
-				   uasm.o
+				   init.o tlbex.o tlbex-fault.o uasm.o
 
 obj-$(CONFIG_32BIT)		+= ioremap.o pgtable-32.o
 obj-$(CONFIG_64BIT)		+= pgtable-64.o
Index: tree-linus/arch/mips/mm/pgtable.c
===================================================================
--- tree-linus.orig/arch/mips/mm/pgtable.c
+++ /dev/null
@@ -1,36 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/swap.h>
-
-void show_mem(void)
-{
-#ifndef CONFIG_NEED_MULTIPLE_NODES  /* XXX(hch): later.. */
-	int pfn, total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-	int highmem = 0;
-	struct page *page;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	pfn = max_mapnr;
-	while (pfn-- > 0) {
-		if (!pfn_valid(pfn))
-			continue;
-		page = pfn_to_page(pfn);
-		total++;
-		if (PageHighMem(page))
-			highmem++;
-		if (PageReserved(page))
-			reserved++;
-		else if (PageSwapCache(page))
-			cached++;
-		else if (page_count(page))
-			shared += page_count(page) - 1;
-	}
-	printk("%d pages of RAM\n", total);
-	printk("%d pages of HIGHMEM\n", highmem);
-	printk("%d reserved pages\n", reserved);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n", cached);
-#endif
-}

-- 


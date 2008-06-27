Return-Path: <linux-kernel-owner+w=401wt.eu-S1762183AbYF0MPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762183AbYF0MPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbYF0MGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:06:12 -0400
Received: from saeurebad.de ([85.214.36.134]:39025 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759840AbYF0MGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:06:10 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun 27 14:00:49 2008
Message-Id: <20080627120049.421752993@saeurebad.de>
References: <20080627115349.743368154@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:54:00 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 11/20] mips: use generic show_mem()
Content-Disposition: inline; filename=0012-mips-use-generic-show_mem.patch
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
 arch/mips/Kconfig      |    1 +
 arch/mips/mm/Makefile  |    3 +--
 arch/mips/mm/pgtable.c |   36 ------------------------------------
 3 files changed, 2 insertions(+), 38 deletions(-)

--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -3,6 +3,7 @@ config MIPS
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_GENERIC_SHOW_MEM
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB
--- a/arch/mips/mm/Makefile
+++ b/arch/mips/mm/Makefile
@@ -3,8 +3,7 @@
 #
 
 obj-y				+= cache.o dma-default.o extable.o fault.o \
-				   init.o pgtable.o tlbex.o tlbex-fault.o \
-				   uasm.o page.o
+				   init.o tlbex.o tlbex-fault.o uasm.o page.o
 
 obj-$(CONFIG_32BIT)		+= ioremap.o pgtable-32.o
 obj-$(CONFIG_64BIT)		+= pgtable-64.o
--- a/arch/mips/mm/pgtable.c
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


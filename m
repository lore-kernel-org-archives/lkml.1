Return-Path: <linux-kernel-owner+w=401wt.eu-S1761973AbYF0MTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761973AbYF0MTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbYF0MHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:07:05 -0400
Received: from saeurebad.de ([85.214.36.134]:39065 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760741AbYF0MHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:07:03 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun 27 14:00:50 2008
Message-Id: <20080627120050.812615008@saeurebad.de>
References: <20080627115349.743368154@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:54:09 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Chris Zankel <chris@zankel.net>
Subject: [PATCH 20/20] xtensa: use generic show_mem()
Content-Disposition: inline; filename=0023-xtensa-use-generic-show_mem.patch
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
 arch/xtensa/Kconfig   |    1 +
 arch/xtensa/mm/init.c |   26 --------------------------
 2 files changed, 1 insertion(+), 26 deletions(-)

--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -15,6 +15,7 @@ config XTENSA
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_GENERIC_SHOW_MEM
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -272,32 +272,6 @@ void free_initmem(void)
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


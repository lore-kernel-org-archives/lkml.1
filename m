Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbYDGPwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbYDGPwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYDGPuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:50:10 -0400
Received: from saeurebad.de ([85.214.36.134]:44753 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758293AbYDGPuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:50:06 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Mon Apr  7 16:42:40 2008
Message-Id: <20080407144240.437444901@skyscraper.fehenstaub.lan>
References: <20080407144008.124362640@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Mon, 07 Apr 2008 16:40:17 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Subject: [patch 09/22 -v3] m32r: Use generic show_mem()
Content-Disposition: inline; filename=m32r-use-generic-show_mem.patch
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
CC: Hirokazu Takata <takata@linux-m32r.org>
---

Index: tree-linus/arch/m32r/Kconfig
===================================================================
--- tree-linus.orig/arch/m32r/Kconfig
+++ tree-linus/arch/m32r/Kconfig
@@ -10,6 +10,7 @@ config M32R
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_GENERIC_SHOW_MEM
 
 config SBUS
 	bool
Index: tree-linus/arch/m32r/mm/init.c
===================================================================
--- tree-linus.orig/arch/m32r/mm/init.c
+++ tree-linus/arch/m32r/mm/init.c
@@ -36,41 +36,6 @@ pgd_t swapper_pg_dir[1024];
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-void show_mem(void)
-{
-	int total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-	int highmem = 0;
-	struct page *page;
-	pg_data_t *pgdat;
-	unsigned long i;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		unsigned long flags;
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
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
-	printk("%d pages of RAM\n", total);
-	printk("%d pages of HIGHMEM\n",highmem);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages shared\n",shared);
-	printk("%d pages swap cached\n",cached);
-}
-
 /*
  * Cache of MMU context last used.
  */

-- 


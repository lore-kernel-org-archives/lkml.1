Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbYGDQ6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbYGDQ6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759900AbYGDQwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:52:16 -0400
Received: from saeurebad.de ([85.214.36.134]:38579 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759885AbYGDQwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:52:13 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jul  4 18:14:57 2008
Message-Id: <20080704161457.649814200@saeurebad.de>
References: <20080704160737.750988999@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 18:07:55 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH 18/20] m32r: use generic show_mem()
Content-Disposition: inline; filename=m32r-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free swap pages, printed by show_swap_cache_info()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/mm/init.c |   36 ------------------------------------
 1 file changed, 36 deletions(-)

--- a/arch/m32r/mm/init.c
+++ b/arch/m32r/mm/init.c
@@ -36,42 +36,6 @@ pgd_t swapper_pg_dir[1024];
 
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
-	printk("Free swap:       %6ldkB\n",nr_swap_pages<<(PAGE_SHIFT-10));
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


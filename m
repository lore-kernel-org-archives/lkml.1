Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbYDGPyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbYDGPyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759712AbYDGPvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:51:09 -0400
Received: from saeurebad.de ([85.214.36.134]:44794 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759695AbYDGPvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:51:07 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Mon Apr  7 16:42:41 2008
Message-Id: <20080407144241.747563885@skyscraper.fehenstaub.lan>
References: <20080407144008.124362640@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Mon, 07 Apr 2008 16:40:26 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Subject: [patch 18/22 -v3] sparc64: Use generic show_mem()
Content-Disposition: inline; filename=sparc64-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- pages in swapcache, printed by show_swap_cache_info()
	- dirty pages, writeback pages, mapped pages, slab pages,
	  pagetables pages, printed by show_free_areas()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: David S. Miller <davem@davemloft.net>
---

Index: tree-linus/arch/sparc64/Kconfig
===================================================================
--- tree-linus.orig/arch/sparc64/Kconfig
+++ tree-linus/arch/sparc64/Kconfig
@@ -11,6 +11,7 @@ config SPARC
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_GENERIC_SHOW_MEM
 
 config SPARC64
 	bool
Index: tree-linus/arch/sparc64/mm/init.c
===================================================================
--- tree-linus.orig/arch/sparc64/mm/init.c
+++ tree-linus/arch/sparc64/mm/init.c
@@ -391,49 +391,6 @@ void __kprobes flush_icache_range(unsign
 	}
 }
 
-void show_mem(void)
-{
-	unsigned long total = 0, reserved = 0;
-	unsigned long shared = 0, cached = 0;
-	pg_data_t *pgdat;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		unsigned long i, flags;
-
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page = pgdat_page_nr(pgdat, i);
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (page_count(page))
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-	}
-
-	printk(KERN_INFO "%lu pages of RAM\n", total);
-	printk(KERN_INFO "%lu reserved pages\n", reserved);
-	printk(KERN_INFO "%lu pages shared\n", shared);
-	printk(KERN_INFO "%lu pages swap cached\n", cached);
-
-	printk(KERN_INFO "%lu pages dirty\n",
-	       global_page_state(NR_FILE_DIRTY));
-	printk(KERN_INFO "%lu pages writeback\n",
-	       global_page_state(NR_WRITEBACK));
-	printk(KERN_INFO "%lu pages mapped\n",
-	       global_page_state(NR_FILE_MAPPED));
-	printk(KERN_INFO "%lu pages slab\n",
-		global_page_state(NR_SLAB_RECLAIMABLE) +
-		global_page_state(NR_SLAB_UNRECLAIMABLE));
-	printk(KERN_INFO "%lu pages pagetables\n",
-	       global_page_state(NR_PAGETABLE));
-}
-
 void mmu_info(struct seq_file *m)
 {
 	if (tlb_type == cheetah)

-- 


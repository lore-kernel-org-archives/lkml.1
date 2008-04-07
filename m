Return-Path: <linux-kernel-owner+w=401wt.eu-S1760162AbYDGPzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162AbYDGPzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759738AbYDGPvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:51:14 -0400
Received: from saeurebad.de ([85.214.36.134]:44798 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759745AbYDGPvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:51:13 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Mon Apr  7 16:42:42 2008
Message-Id: <20080407144241.892717222@skyscraper.fehenstaub.lan>
References: <20080407144008.124362640@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Mon, 07 Apr 2008 16:40:27 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>
Subject: [patch 19/22 -v3] um: Use generic show_mem()
Content-Disposition: inline; filename=um-use-generic-show_mem.patch
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
Acked-by: Jeff Dike <jdike@addtoit.com>
---

Index: tree-linus/arch/um/Kconfig
===================================================================
--- tree-linus.orig/arch/um/Kconfig
+++ tree-linus/arch/um/Kconfig
@@ -11,6 +11,7 @@ config GENERIC_HARDIRQS
 config UML
 	bool
 	default y
+	select HAVE_GENERIC_SHOW_MEM
 
 config MMU
 	bool
Index: tree-linus/arch/um/kernel/mem.c
===================================================================
--- tree-linus.orig/arch/um/kernel/mem.c
+++ tree-linus/arch/um/kernel/mem.c
@@ -295,35 +295,6 @@ void free_initrd_mem(unsigned long start
 }
 #endif
 
-void show_mem(void)
-{
-	int pfn, total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-	int high_mem = 0;
-	struct page *page;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	pfn = max_mapnr;
-	while (pfn-- > 0) {
-		page = pfn_to_page(pfn);
-		total++;
-		if (PageHighMem(page))
-			high_mem++;
-		if (PageReserved(page))
-			reserved++;
-		else if (PageSwapCache(page))
-			cached++;
-		else if (page_count(page))
-			shared += page_count(page) - 1;
-	}
-	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d pages of HIGHMEM\n", high_mem);
-	printk(KERN_INFO "%d reserved pages\n", reserved);
-	printk(KERN_INFO "%d pages shared\n", shared);
-	printk(KERN_INFO "%d pages swap cached\n", cached);
-}
-
 /* Allocate and free page tables. */
 
 pgd_t *pgd_alloc(struct mm_struct *mm)

-- 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762529AbYF0MSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762529AbYF0MSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760669AbYF0MGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:06:50 -0400
Received: from saeurebad.de ([85.214.36.134]:39057 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760658AbYF0MGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:06:49 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun 27 14:00:50 2008
Message-Id: <20080627120050.500232841@saeurebad.de>
References: <20080627115349.743368154@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:54:07 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 18/20] um: use generic show_mem()
Content-Disposition: inline; filename=0020-um-use-generic-show_mem.patch
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
Acked-by: Jeff Dike <jdike@addtoit.com>
---
 arch/um/Kconfig      |    1 +
 arch/um/kernel/mem.c |   31 -------------------------------
 2 files changed, 1 insertion(+), 31 deletions(-)

--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -11,6 +11,7 @@ config GENERIC_HARDIRQS
 config UML
 	bool
 	default y
+	select HAVE_GENERIC_SHOW_MEM
 
 config MMU
 	bool
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -264,37 +264,6 @@ void free_initrd_mem(unsigned long start
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
-	printk(KERN_INFO "Free swap:       %6ldkB\n",
-	       nr_swap_pages<<(PAGE_SHIFT-10));
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


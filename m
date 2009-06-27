Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZF0OJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZF0OJa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 10:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbZF0OI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 10:08:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58820 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbZF0OIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 10:08:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/6] score: clean up mm/init.c
Date: Sat, 27 Jun 2009 16:08:18 +0200
Message-Id: <fbd85b0e26bab0a13dcf860f2c20e86cb0507b61.1246111364.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1246111364.git.arnd@arndb.de>
References: <cover.1246111364.git.arnd@arndb.de>
In-Reply-To: <cover.1246111364.git.arnd@arndb.de>
References: <cover.1246111364.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19VuIClYO2gMHlvSxogl2Cm61togPud7f69Fj+
 hyctiWRZZk9lZhboO3kqAIMWxs9PFhDyZAWvOyFIfUZJqVpOCw
 4/z5iNyNCoN2Ku3EUyfYg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

score does not need multiple zero pages, because it does not
suffer from cache aliasing problems, so simplify that code.
Also make some functions static and include the appropriate
header files.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/score/mm/init.c |   34 ++++++++++------------------------
 1 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/arch/score/mm/init.c b/arch/score/mm/init.c
index 7780eec..d496e9f 100644
--- a/arch/score/mm/init.c
+++ b/arch/score/mm/init.c
@@ -32,44 +32,30 @@
 #include <linux/pagemap.h>
 #include <linux/proc_fs.h>
 #include <linux/sched.h>
-#include <asm-generic/sections.h>
+#include <linux/initrd.h>
 
+#include <asm/sections.h>
 #include <asm/tlb.h>
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-/*
- * We have up to 8 empty zeroed pages so we can map one of the right colour
- * when needed.
- */
-unsigned long zero_page_mask;
 unsigned long empty_zero_page;
 EXPORT_SYMBOL_GPL(empty_zero_page);
 
 static struct kcore_list kcore_mem, kcore_vmalloc;
 
-unsigned long setup_zero_pages(void)
+static unsigned long setup_zero_page(void)
 {
-	unsigned int order = 0;
-	unsigned long size;
 	struct page *page;
 
-	empty_zero_page = __get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
+	empty_zero_page = __get_free_pages(GFP_KERNEL | __GFP_ZERO, 0);
 	if (!empty_zero_page)
 		panic("Oh boy, that early out of memory?");
 
 	page = virt_to_page((void *) empty_zero_page);
-	split_page(page, order);
-	while (page < virt_to_page((void *) (empty_zero_page +
-					     (PAGE_SIZE << order)))) {
-		SetPageReserved(page);
-		page++;
-	}
-
-	size = PAGE_SIZE << order;
-	zero_page_mask = (size - 1) & PAGE_MASK;
+	SetPageReserved(page);
 
-	return 1UL << order;
+	return 1UL;
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -100,7 +86,7 @@ void __init mem_init(void)
 	max_mapnr = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
 	totalram_pages += free_all_bootmem();
-	totalram_pages -= setup_zero_pages();	/* Setup zeroed pages. */
+	totalram_pages -= setup_zero_page();	/* Setup zeroed pages. */
 	reservedpages = 0;
 
 	for (tmp = 0; tmp < max_low_pfn; tmp++)
@@ -129,7 +115,7 @@ void __init mem_init(void)
 }
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
-void free_init_pages(const char *what, unsigned long begin, unsigned long end)
+static void free_init_pages(const char *what, unsigned long begin, unsigned long end)
 {
 	unsigned long pfn;
 
@@ -150,8 +136,8 @@ void free_init_pages(const char *what, unsigned long begin, unsigned long end)
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
 	free_init_pages("initrd memory",
-	virt_to_phys((void *) start),
-	virt_to_phys((void *) end));
+		virt_to_phys((void *) start),
+		virt_to_phys((void *) end));
 }
 #endif
 
-- 
1.6.3.1


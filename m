Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbYDGPto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbYDGPto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758508AbYDGPtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:49:23 -0400
Received: from saeurebad.de ([85.214.36.134]:44724 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758261AbYDGPtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:49:22 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Mon Apr  7 16:42:39 2008
Message-Id: <20080407144239.420152477@skyscraper.fehenstaub.lan>
References: <20080407144008.124362640@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Mon, 07 Apr 2008 16:40:10 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 02/22 -v3] Generic show_mem() implementation
Content-Disposition: inline; filename=generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements a platform-independent version of show_mem().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

Note: I added the quicklist_total_size() as `pagetable cache' because
it was the only use case I have found for quicklists, anyway. 

Index: tree-linus/mm/Kconfig
===================================================================
--- tree-linus.orig/mm/Kconfig
+++ tree-linus/mm/Kconfig
@@ -193,3 +193,6 @@ config NR_QUICK
 config VIRT_TO_BUS
 	def_bool y
 	depends on !ARCH_NO_VIRT_TO_BUS
+
+config HAVE_GENERIC_SHOW_MEM
+	def_bool n
Index: tree-linus/mm/page_alloc.c
===================================================================
--- tree-linus.orig/mm/page_alloc.c
+++ tree-linus/mm/page_alloc.c
@@ -45,6 +45,7 @@
 #include <linux/fault-inject.h>
 #include <linux/page-isolation.h>
 #include <linux/memcontrol.h>
+#include <linux/nmi.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -1889,6 +1890,60 @@ void show_free_areas(void)
 	show_swap_cache_info();
 }
 
+#ifdef CONFIG_HAVE_GENERIC_SHOW_MEM
+void show_mem(void)
+{
+	pg_data_t *pgdat;
+	int total = 0, reserved = 0, shared = 0, nonshared = 0, highmem = 0;
+
+	printk(KERN_INFO "Mem-Info:\n");
+	show_free_areas();
+
+	for_each_online_pgdat(pgdat) {
+		unsigned long i, flags;
+
+		pgdat_resize_lock(pgdat, &flags);
+		for (i = 0; i < pgdat->node_spanned_pages; i++) {
+			struct page *page;
+			unsigned long pfn = pgdat->node_start_pfn + i;
+
+			if (unlikely((i % MAX_ORDER_NR_PAGES) == 0))
+				touch_nmi_watchdog();
+
+			if (!pfn_valid(pfn))
+				continue;
+
+			page = pfn_to_page(pfn);
+
+			if (PageHighMem(page))
+				highmem++;
+
+			if (PageReserved(page))
+				reserved++;
+			else if (page_count(page) == 1)
+				nonshared++;
+			else if (page_count(page) > 1)
+				shared += page_count(page) - 1;
+
+			total++;
+		}
+		pgdat_resize_unlock(pgdat, &flags);
+	}
+
+	printk(KERN_INFO "%d pages RAM\n", total);
+#ifdef CONFIG_HIGHMEM
+	printk(KERN_INFO "%d pages HighMem\n", highmem);
+#endif
+	printk(KERN_INFO "%d pages reserved\n", reserved);
+	printk(KERN_INFO "%d pages shared\n", shared);
+	printk(KERN_INFO "%d pages non-shared\n", nonshared);
+#ifdef CONFIG_QUICKLIST
+	printk(KERN_INFO "%d pages in pagetable cache\n",
+		quicklist_total_size());
+#endif
+}
+#endif /* CONFIG_HAVE_GENERIC_SHOW_MEM */
+
 /*
  * Builds allocation fallback zone lists.
  *

-- 


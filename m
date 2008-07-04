Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbYGDQwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbYGDQwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759598AbYGDQvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:51:07 -0400
Received: from saeurebad.de ([85.214.36.134]:38515 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758604AbYGDQvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:51:05 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jul  4 18:14:52 2008
Message-Id: <20080704161452.730548249@saeurebad.de>
References: <20080704160737.750988999@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 18:07:39 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 02/20] lib: generic show_mem()
Content-Disposition: inline; filename=lib-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements a platform-independent version of show_mem().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 lib/Makefile   |    2 -
 lib/show_mem.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 1 deletion(-)

--- a/lib/Makefile
+++ b/lib/Makefile
@@ -6,7 +6,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o ratelimit.o
+	 proportions.o prio_heap.o ratelimit.o show_mem.o
 
 ifdef CONFIG_FTRACE
 # Do not profile string.o, since it may be used in early boot or vdso
--- /dev/null
+++ b/lib/show_mem.c
@@ -0,0 +1,63 @@
+/*
+ * Generic show_mem() implementation
+ *
+ * Copyright (C) 2008 Johannes Weiner <hannes@saeurebad.de>
+ * All code subject to the GPL version 2.
+ */
+
+#include <linux/mm.h>
+#include <linux/nmi.h>
+#include <linux/quicklist.h>
+
+void show_mem(void)
+{
+	pg_data_t *pgdat;
+	unsigned long total = 0, reserved = 0, shared = 0,
+		nonshared = 0, highmem = 0;
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
+			if (unlikely(!(i % MAX_ORDER_NR_PAGES)))
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
+	printk(KERN_INFO "%lu pages RAM\n", total);
+#ifdef CONFIG_HIGHMEM
+	printk(KERN_INFO "%lu pages HighMem\n", highmem);
+#endif
+	printk(KERN_INFO "%lu pages reserved\n", reserved);
+	printk(KERN_INFO "%lu pages shared\n", shared);
+	printk(KERN_INFO "%lu pages non-shared\n", nonshared);
+#ifdef CONFIG_QUICKLIST
+	printk(KERN_INFO "%lu pages in pagetable cache\n",
+		quicklist_total_size());
+#endif
+}

-- 


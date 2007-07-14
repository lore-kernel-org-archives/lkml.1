Return-Path: <linux-kernel-owner+w=401wt.eu-S1764775AbXGNBYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764775AbXGNBYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763059AbXGNBYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:24:17 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38065 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761489AbXGNBYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:24:16 -0400
Message-Id: <20070714012412.380213021@polymtl.ca>
References: <20070714012133.612727310@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jul 2007 21:21:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 3/8] Text Edit Lock - i386
Content-Disposition: inline; filename=text-edit-lock-i386.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat, 14 Jul 2007 01:24:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Interface to use for code patching : makes sure the page is writable
between calls to kernel_text_mark_rw() and kernel_text_unmark().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/i386/mm/init.c           |   60 ++++++++++++++++++++++++++++++++----------
 include/asm-i386/cacheflush.h |    9 ++++++
 2 files changed, 56 insertions(+), 13 deletions(-)

Index: linux-2.6-lttng/arch/i386/mm/init.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/mm/init.c	2007-07-13 17:01:24.000000000 -0400
+++ linux-2.6-lttng/arch/i386/mm/init.c	2007-07-13 17:02:31.000000000 -0400
@@ -31,6 +31,7 @@
 #include <linux/memory_hotplug.h>
 #include <linux/initrd.h>
 #include <linux/cpumask.h>
+#include <linux/kprobes.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -53,6 +54,10 @@
 
 static int noinline do_test_wp_bit(void);
 
+#ifdef CONFIG_DEBUG_RODATA
+static int rodata_marked;
+#endif
+
 /*
  * Creates a middle page table and puts a pointer to it in the
  * given global directory entry. This only returns the gd entry
@@ -796,24 +801,16 @@
 }
 
 #ifdef CONFIG_DEBUG_RODATA
-
 void mark_rodata_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
-#ifndef CONFIG_KPROBES
-#ifdef CONFIG_HOTPLUG_CPU
-	/* It must still be possible to apply SMP alternatives. */
-	if (num_possible_cpus() <= 1)
-#endif
-	{
-		change_page_attr(virt_to_page(start),
-		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
-		printk("Write protecting the kernel text: %luk\n", size >> 10);
-		kernel_text_is_ro = 1;
-	}
-#endif
+	change_page_attr(virt_to_page(start),
+	                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
+	printk("Write protecting the kernel text: %luk\n", size >> 10);
+	kernel_text_is_ro = 1;
+
 	start += size;
 	size = (unsigned long)__end_rodata - start;
 	change_page_attr(virt_to_page(start),
@@ -828,9 +825,46 @@
 	 * of who is the culprit.
 	 */
 	global_flush_tlb();
+	rodata_marked = 1;
+}
+
+/*
+ * Lock the kernel text for mutual write exclusion.
+ * Make sure the pages are writable.
+ */
+void __kprobes kernel_text_mark_rw(unsigned long address, size_t len)
+{
+	if (rodata_marked && address >= PFN_ALIGN(_text)
+			&& (address + len) <= PFN_ALIGN(_etext)) {
+		unsigned long nr_pages;
+		nr_pages = ((address + len) >> PAGE_SHIFT)
+				- (address >> PAGE_SHIFT) + 1;
+		change_page_attr(virt_to_page(address), nr_pages,
+				PAGE_KERNEL_EXEC);
+		mb();
+		global_flush_tlb();
+		mb();
+	}
 }
+EXPORT_SYMBOL_GPL(kernel_text_mark_rw);
 #endif
 
+void __kprobes kernel_text_unmark(unsigned long address, size_t len)
+{
+	if (rodata_marked && address >= PFN_ALIGN(_text)
+			&& (address + len) <= PFN_ALIGN(_etext)) {
+		unsigned long nr_pages;
+		nr_pages = ((address + len) >> PAGE_SHIFT)
+				- (address >> PAGE_SHIFT) + 1;
+		change_page_attr(virt_to_page(address), nr_pages,
+				PAGE_KERNEL_RX);
+		mb();
+		global_flush_tlb();
+		mb();
+	}
+}
+EXPORT_SYMBOL_GPL(kernel_text_unmark);
+
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
 	unsigned long addr;
Index: linux-2.6-lttng/include/asm-i386/cacheflush.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/cacheflush.h	2007-07-13 17:01:24.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/cacheflush.h	2007-07-13 17:01:26.000000000 -0400
@@ -36,4 +36,13 @@
 void mark_rodata_ro(void);
 #endif
 
+#if defined(CONFIG_DEBUG_RODATA)
+/* mark kernel text pages writable */
+extern void kernel_text_mark_rw(unsigned long address, size_t len);
+extern void kernel_text_unmark(unsigned long address, size_t len);
+#else
+void kernel_text_mark_rw(unsigned long address, size_t len) { }
+void kernel_text_unmark(unsigned long address, size_t len) { }
+#endif
+
 #endif /* _I386_CACHEFLUSH_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

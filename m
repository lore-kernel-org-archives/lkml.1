Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbXGCQk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbXGCQk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbXGCQkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:40:37 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:44449 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871AbXGCQke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:40:34 -0400
Message-Id: <20070703164029.686191662@polymtl.ca>
References: <20070703163818.785635235@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:38:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/3] Text Edit Lock - i386
Content-Disposition: inline; filename=text-edit-lock-i386.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 16:40:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Interface to use for code patching : uses a mutex to insure mutual edit
exclusion and makes sure the page is writable.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/i386/mm/init.c           |   69 ++++++++++++++++++++++++++++++++++--------
 include/asm-i386/cacheflush.h |    4 ++
 2 files changed, 61 insertions(+), 12 deletions(-)

Index: linux-2.6-lttng/arch/i386/mm/init.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/mm/init.c	2007-06-29 14:15:39.000000000 -0400
+++ linux-2.6-lttng/arch/i386/mm/init.c	2007-06-29 14:22:02.000000000 -0400
@@ -31,6 +31,7 @@
 #include <linux/memory_hotplug.h>
 #include <linux/initrd.h>
 #include <linux/cpumask.h>
+#include <linux/mutex.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -53,6 +54,13 @@
 
 static int noinline do_test_wp_bit(void);
 
+/* spin lock protecting text section modification (dynamic code patching) */
+static DEFINE_SPINLOCK(text_lock);
+
+#ifdef CONFIG_DEBUG_RODATA
+static int rodata_marked;
+#endif
+
 /*
  * Creates a middle page table and puts a pointer to it in the
  * given global directory entry. This only returns the gd entry
@@ -802,18 +810,11 @@
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
@@ -828,8 +829,52 @@
 	 * of who is the culprit.
 	 */
 	global_flush_tlb();
+	rodata_marked = 1;
+}
+#endif
+
+/*
+ * Lock the kernel text for mutual write exclusion.
+ * Make sure the pages are writable.
+ */
+void kernel_text_lock(unsigned long address, size_t len)
+{
+	spin_lock(&text_lock);
+#if defined(CONFIG_DEBUG_RODATA)
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
+#endif
 }
+EXPORT_SYMBOL_GPL(kernel_text_lock);
+
+void kernel_text_unlock(unsigned long address, size_t len)
+{
+#if defined(CONFIG_DEBUG_RODATA)
+	if (rodata_marked && address >= PFN_ALIGN(_text)
+			&& (address + len) <= PFN_ALIGN(_etext)) {
+		unsigned long nr_pages;
+		wmb();
+		nr_pages = ((address + len) >> PAGE_SHIFT)
+				- (address >> PAGE_SHIFT) + 1;
+		mb();
+		change_page_attr(virt_to_page(address), nr_pages,
+				PAGE_KERNEL_RX);
+		mb();
+		global_flush_tlb();
+	}
 #endif
+	spin_unlock(&text_lock);
+}
+EXPORT_SYMBOL_GPL(kernel_text_unlock);
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
Index: linux-2.6-lttng/include/asm-i386/cacheflush.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/cacheflush.h	2007-06-29 10:21:47.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/cacheflush.h	2007-06-29 14:20:29.000000000 -0400
@@ -36,4 +36,8 @@
 void mark_rodata_ro(void);
 #endif
 
+/* lock kernel text and mark pages writable */
+extern void kernel_text_lock(unsigned long address, size_t len);
+extern void kernel_text_unlock(unsigned long address, size_t len);
+
 #endif /* _I386_CACHEFLUSH_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

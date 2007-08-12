Return-Path: <linux-kernel-owner+w=401wt.eu-S936338AbXHLPiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936338AbXHLPiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935651AbXHLPhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:37:32 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:50227 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935536AbXHLPhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:37:16 -0400
Message-Id: <20070812150639.907604276@polymtl.ca>
References: <20070812150402.148764478@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:04:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>
Subject: [patch 5/9] Text Edit Lock - i386
Content-Disposition: inline; filename=text-edit-lock-i386.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:37:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Interface to use for code patching : makes sure the page is writable
between calls to kernel_text_mark_rw() and kernel_text_unmark().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
---
 arch/i386/mm/init.c           |   65 ++++++++++++++++++++++++++++++++++--------
 include/asm-i386/cacheflush.h |    7 ++++
 2 files changed, 60 insertions(+), 12 deletions(-)

Index: linux-2.6-lttng/arch/i386/mm/init.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/mm/init.c	2007-08-10 16:44:23.000000000 -0400
+++ linux-2.6-lttng/arch/i386/mm/init.c	2007-08-10 16:47:14.000000000 -0400
@@ -31,6 +31,7 @@
 #include <linux/memory_hotplug.h>
 #include <linux/initrd.h>
 #include <linux/cpumask.h>
+#include <linux/kprobes.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -794,23 +795,15 @@ static int noinline do_test_wp_bit(void)
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
-	}
-#endif
+	change_page_attr(virt_to_page(start),
+	                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
+	printk("Write protecting the kernel text: %luk\n", size >> 10);
+
 	start += size;
 	size = (unsigned long)__end_rodata - start;
 	change_page_attr(virt_to_page(start),
@@ -826,6 +819,54 @@ void mark_rodata_ro(void)
 	 */
 	global_flush_tlb();
 }
+
+/**
+ * kernel_text_mark_rw   -  Change kernel core text flags to RW
+ * @address:                location of the code
+ * @len:                    size of code to mark
+ *
+ * Change kernel text flags to RW. Useful for code patching.
+ */
+
+void __kprobes kernel_text_mark_rw(unsigned long address, size_t len)
+{
+	if (address >= PFN_ALIGN(_text)
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
+}
+EXPORT_SYMBOL_GPL(kernel_text_mark_rw);
+
+/**
+ * kernel_text_unmark    -   Unmap a kernel text rw mapping.
+ * @address:                 location of the mapping
+ * @len:                    size of code to mark
+ *
+ * Remove RW flag from kernel text.
+ */
+
+void __kprobes kernel_text_unmark(unsigned long address, size_t len)
+{
+	if (address >= PFN_ALIGN(_text)
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
 #endif
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
Index: linux-2.6-lttng/include/asm-i386/cacheflush.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/cacheflush.h	2007-08-10 16:44:23.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/cacheflush.h	2007-08-10 16:44:46.000000000 -0400
@@ -34,6 +34,13 @@ void kernel_map_pages(struct page *page,
 
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
+
+/* mark kernel text pages writable */
+extern void kernel_text_mark_rw(unsigned long address, size_t len);
+extern void kernel_text_unmark(unsigned long address, size_t len);
+#else
+void kernel_text_mark_rw(unsigned long address, size_t len) { }
+void kernel_text_unmark(unsigned long address, size_t len) { }
 #endif
 
 #endif /* _I386_CACHEFLUSH_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

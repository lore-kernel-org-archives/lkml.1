Return-Path: <linux-kernel-owner+w=401wt.eu-S1764896AbXGNB0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764896AbXGNB0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764717AbXGNBYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:24:49 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38157 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763888AbXGNBYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:24:48 -0400
Message-Id: <20070714012412.960272115@polymtl.ca>
References: <20070714012133.612727310@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jul 2007 21:21:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>
Subject: [patch 4/8] Text Edit Lock - x86_64
Content-Disposition: inline; filename=text-edit-lock-x86_64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat, 14 Jul 2007 01:24:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Interface to use for code patching : makes sure the page is writable
between calls to kernel_text_mark_rw() and kernel_text_unmark().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
---
 arch/x86_64/mm/init.c           |   64 +++++++++++++++++++++++++++-------------
 include/asm-x86_64/cacheflush.h |    9 +++++
 2 files changed, 53 insertions(+), 20 deletions(-)

Index: linux-2.6-lttng/arch/x86_64/mm/init.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/mm/init.c	2007-07-13 16:08:14.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/mm/init.c	2007-07-13 16:36:40.000000000 -0400
@@ -56,6 +56,10 @@
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
+#ifdef CONFIG_DEBUG_RODATA
+static int rodata_marked;
+#endif
+
 /*
  * NOTE: pagetable_init alloc all the fixmap pagetables contiguous on the
  * physical space so we can cache the place of the first one and move
@@ -596,31 +600,15 @@
 }
 
 #ifdef CONFIG_DEBUG_RODATA
-
 void mark_rodata_ro(void)
 {
-	unsigned long start = (unsigned long)_stext, end;
+	unsigned long start = PFN_ALIGN(_stext);
+	unsigned long end = PFN_ALIGN(__end_rodata);
 
 	kernel_text_is_ro = 1;
-#ifdef CONFIG_HOTPLUG_CPU
-	/* It must still be possible to apply SMP alternatives. */
-	if (num_possible_cpus() > 1) {
-		start = (unsigned long)_etext;
-		kernel_text_is_ro = 0;
-	}
-#endif
 
-#ifdef CONFIG_KPROBES
-	start = (unsigned long)__start_rodata;
-#endif
-	
-	end = (unsigned long)__end_rodata;
-	start = (start + PAGE_SIZE - 1) & PAGE_MASK;
-	end &= PAGE_MASK;
-	if (end <= start)
-		return;
-
-	change_page_attr_addr(start, (end - start) >> PAGE_SHIFT, PAGE_KERNEL_RO);
+	change_page_attr_addr(start, (end - start) >> PAGE_SHIFT,
+				PAGE_KERNEL_RO);
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -632,7 +620,43 @@
 	 * of who is the culprit.
 	 */
 	global_flush_tlb();
+	rodata_marked = 1;
+}
+
+/*
+ * Mark kernel text pages writable.
+ */
+void kernel_text_mark_rw(unsigned long address, size_t len)
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
+}
+EXPORT_SYMBOL_GPL(kernel_text_mark_rw);
+
+void kernel_text_unmark(unsigned long address, size_t len)
+{
+	if (rodata_marked && address >= PFN_ALIGN(_text)
+			&& (address + len) <= PFN_ALIGN(_etext)) {
+		unsigned long nr_pages;
+		nr_pages = ((address + len) >> PAGE_SHIFT)
+				- (address >> PAGE_SHIFT) + 1;
+		mb();
+		change_page_attr(virt_to_page(address), nr_pages,
+				PAGE_KERNEL_RO);
+		mb();
+		global_flush_tlb();
+	}
 }
+EXPORT_SYMBOL_GPL(kernel_text_unmark);
 #endif
 
 #ifdef CONFIG_BLK_DEV_INITRD
Index: linux-2.6-lttng/include/asm-x86_64/cacheflush.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86_64/cacheflush.h	2007-07-13 16:08:14.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86_64/cacheflush.h	2007-07-13 16:34:32.000000000 -0400
@@ -33,4 +33,13 @@
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
 #endif /* _X8664_CACHEFLUSH_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

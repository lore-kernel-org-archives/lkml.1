Return-Path: <linux-kernel-owner+w=401wt.eu-S964822AbXHLPH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822AbXHLPH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935700AbXHLPHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:07:17 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47426 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935294AbXHLPHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:07:14 -0400
Message-Id: <20070812150640.343635195@polymtl.ca>
References: <20070812150402.148764478@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:04:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>
Subject: [patch 6/9] Text Edit Lock - x86_64
Content-Disposition: inline; filename=text-edit-lock-x86_64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:06:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Interface to use for code patching : makes sure the page is writable
between calls to kernel_text_mark_rw() and kernel_text_unmark().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
---
 arch/x86_64/mm/init.c           |   72 +++++++++++++++++++++++++++++-----------
 include/asm-x86_64/cacheflush.h |    7 +++
 2 files changed, 60 insertions(+), 19 deletions(-)

Index: linux-2.6-lttng/arch/x86_64/mm/init.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/mm/init.c	2007-08-12 09:33:55.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/mm/init.c	2007-08-12 10:04:13.000000000 -0400
@@ -103,7 +103,7 @@ static __init void *spp_getpage(void)
 { 
 	void *ptr;
 	if (after_bootmem)
-		ptr = (void *) get_zeroed_page(GFP_ATOMIC); 
+		ptr = (void *) get_zeroed_page(GFP_KERNEL);
 	else
 		ptr = alloc_bootmem_pages(PAGE_SIZE);
 	if (!ptr || ((unsigned long)ptr & ~PAGE_MASK))
@@ -598,25 +598,11 @@ void free_initmem(void)
 
 void mark_rodata_ro(void)
 {
-	unsigned long start = (unsigned long)_stext, end;
+	unsigned long start = PFN_ALIGN(_stext);
+	unsigned long end = PFN_ALIGN(__end_rodata);
 
-#ifdef CONFIG_HOTPLUG_CPU
-	/* It must still be possible to apply SMP alternatives. */
-	if (num_possible_cpus() > 1)
-		start = (unsigned long)_etext;
-#endif
-
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
@@ -629,6 +615,54 @@ void mark_rodata_ro(void)
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
+void kernel_text_mark_rw(unsigned long address, size_t len)
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
+ * @len:                     size of code to mark
+ *
+ * Remove RW flag from kernel text.
+ */
+
+void kernel_text_unmark(unsigned long address, size_t len)
+{
+	if (address >= PFN_ALIGN(_text)
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
+}
+EXPORT_SYMBOL_GPL(kernel_text_unmark);
 #endif
 
 #ifdef CONFIG_BLK_DEV_INITRD
Index: linux-2.6-lttng/include/asm-x86_64/cacheflush.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86_64/cacheflush.h	2007-08-12 09:33:55.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86_64/cacheflush.h	2007-08-12 09:34:07.000000000 -0400
@@ -31,6 +31,13 @@ void clflush_cache_range(void *addr, int
 
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
 
 #endif /* _X8664_CACHEFLUSH_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

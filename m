Return-Path: <linux-kernel-owner+w=401wt.eu-S933450AbXFRWG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbXFRWG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933397AbXFRWFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:05:38 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:49639 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933383AbXFRWFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:05:37 -0400
Message-Id: <20070618220458.888939232@polymtl.ca>
References: <20070618215846.247539382@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 17:58:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Chuck Ebbert <cebbert@redhat.com>, prasanna@in.ibm.com, ananth@in.ibm.com,
       jkenisto@us.ibm.com, ak@suse.de,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/3] Text Edit Lock - i386
Content-Disposition: inline; filename=text-edit-lock-i386.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 18 Jun 2007 22:04:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Interface to use for code patching : uses a mutex to insure mutual edit
exclusion and makes sure the page is writable.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/i386/mm/init.c           |   52 ++++++++++++++++++++++++++++++++++--------
 include/asm-i386/cacheflush.h |    4 +++
 2 files changed, 47 insertions(+), 9 deletions(-)

Index: linux-2.6-lttng/arch/i386/mm/init.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/mm/init.c	2007-06-18 17:42:42.000000000 -0400
+++ linux-2.6-lttng/arch/i386/mm/init.c	2007-06-18 17:56:31.000000000 -0400
@@ -31,6 +31,7 @@
 #include <linux/memory_hotplug.h>
 #include <linux/initrd.h>
 #include <linux/cpumask.h>
+#include <linux/mutex.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -52,6 +53,9 @@
 
 static int noinline do_test_wp_bit(void);
 
+/* Mutex protecting text section modification (dynamic code patching) */
+static DEFINE_MUTEX(text_mutex);
+
 /*
  * Creates a middle page table and puts a pointer to it in the
  * given global directory entry. This only returns the gd entry
@@ -800,15 +804,9 @@
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
-#ifdef CONFIG_HOTPLUG_CPU
-	/* It must still be possible to apply SMP alternatives. */
-	if (num_possible_cpus() <= 1)
-#endif
-	{
-		change_page_attr(virt_to_page(start),
-		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
-		printk("Write protecting the kernel text: %luk\n", size >> 10);
-	}
+	change_page_attr(virt_to_page(start),
+			 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
+	printk("Write protecting the kernel text: %luk\n", size >> 10);
 
 	start += size;
 	size = (unsigned long)__end_rodata - start;
@@ -827,6 +825,42 @@
 }
 #endif
 
+/*
+ * Lock the kernel text for mutual write exclusion.
+ * Make sure the pages are writable.
+ */
+void kernel_text_lock(unsigned long address, size_t len)
+{
+	mutex_lock(&text_mutex);
+#if defined(CONFIG_DEBUG_RODATA)
+	if (is_kernel_text(address) && is_kernel_text(address + len)) {
+		unsigned long nr_pages;
+		nr_pages = ((address + len) >> PAGE_SHIFT)
+				- (address >> PAGE_SHIFT) + 1;
+		change_page_attr(virt_to_page(address), nr_pages,
+				PAGE_KERNEL_EXEC);
+		global_flush_tlb();
+	}
+#endif
+}
+EXPORT_SYMBOL_GPL(kernel_text_lock);
+
+void kernel_text_unlock(unsigned long address, size_t len)
+{
+#if defined(CONFIG_DEBUG_RODATA)
+	if (is_kernel_text(address) && is_kernel_text(address + len)) {
+		unsigned long nr_pages;
+		nr_pages = ((address + len) >> PAGE_SHIFT)
+				- (address >> PAGE_SHIFT) + 1;
+		change_page_attr(virt_to_page(address), nr_pages,
+				PAGE_KERNEL_RX);
+		global_flush_tlb();
+	}
+#endif
+	mutex_unlock(&text_mutex);
+}
+EXPORT_SYMBOL_GPL(kernel_text_unlock);
+
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
 	unsigned long addr;
Index: linux-2.6-lttng/include/asm-i386/cacheflush.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/cacheflush.h	2007-06-18 17:42:42.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/cacheflush.h	2007-06-18 17:42:44.000000000 -0400
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

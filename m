Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbYAPClo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbYAPClo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757256AbYAPClT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:41:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:20057 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657AbYAPClO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:41:14 -0500
X-ExtLoop1: 1
Message-Id: <20080116024112.291093000@intel.com>
References: <20080116023955.597433000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 18:39:59 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/4] x86: PAT followup - use ioremap for devmem read of reserved regions
Content-Disposition: inline; filename=devmem_read.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

map and unmap reserved regions, before accessing through /dev/mem read
interface. This is for full compatibility with existing /dev/mem
usages.
For regions that are mapped in identity map, we use __va().

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6.git/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/ioremap.c	2008-01-15 10:05:13.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/ioremap.c	2008-01-15 10:39:18.000000000 -0800
@@ -32,6 +32,39 @@
 }
 EXPORT_SYMBOL(ioremap_wc);
 
+/*
+ * Convert a physical pointer to a virtual kernel pointer for /dev/mem
+ * access
+ */
+void *xlate_dev_mem_ptr(unsigned long phys)
+{
+	void *addr;
+	unsigned long start = phys & PAGE_MASK;
+
+	/*
+	 * If any memory in PAGE_SIZE is valid, then we can use __va. Otherwise
+	 * ioremap and unmap the memory.
+	 */
+	if (is_memory_any_valid(start, start + PAGE_SIZE))
+		return __va(phys);
+
+	addr = (void *)ioremap(start, PAGE_SIZE);
+	if (addr)
+		addr = (void *)((unsigned long)addr | (phys & ~PAGE_MASK));
+
+	return addr;
+}
+
+void unxlate_dev_mem_ptr(unsigned long phys, void *addr)
+{
+	unsigned long start = phys & PAGE_MASK;
+	if (is_memory_any_valid(start, start + PAGE_SIZE))
+		return;
+
+	iounmap((void __iomem *)((unsigned long)addr & PAGE_MASK));
+	return;
+}
+
 int valid_phys_addr_range(unsigned long addr, size_t count)
 {
 	if (addr + count > __pa(high_memory))
Index: linux-2.6.git/drivers/char/mem.c
===================================================================
--- linux-2.6.git.orig/drivers/char/mem.c	2008-01-15 10:05:13.000000000 -0800
+++ linux-2.6.git/drivers/char/mem.c	2008-01-15 10:05:51.000000000 -0800
@@ -127,9 +127,14 @@
 		 * by the kernel or data corruption may occur
 		 */
 		ptr = xlate_dev_mem_ptr(p);
+		if (!ptr)
+			return -EFAULT;
 
 		if (copy_to_user(buf, ptr, sz))
 			return -EFAULT;
+
+		unxlate_dev_mem_ptr(p, ptr);
+
 		buf += sz;
 		p += sz;
 		count -= sz;
@@ -184,6 +189,11 @@
 		 * by the kernel or data corruption may occur
 		 */
 		ptr = xlate_dev_mem_ptr(p);
+		if (!ptr) {
+			if (written)
+				break;
+			return -EFAULT;
+		}
 
 		copied = copy_from_user(ptr, buf, sz);
 		if (copied) {
@@ -192,6 +202,9 @@
 				break;
 			return -EFAULT;
 		}
+
+		unxlate_dev_mem_ptr(p, ptr);
+
 		buf += sz;
 		p += sz;
 		count -= sz;
Index: linux-2.6.git/include/asm-generic/iomap.h
===================================================================
--- linux-2.6.git.orig/include/asm-generic/iomap.h	2008-01-15 10:05:13.000000000 -0800
+++ linux-2.6.git/include/asm-generic/iomap.h	2008-01-15 10:23:24.000000000 -0800
@@ -69,4 +69,8 @@
 #define ioremap_wc ioremap_nocache
 #endif
 
+#ifndef unxlate_dev_mem_ptr
+static inline void unxlate_dev_mem_ptr(unsigned long phys, void *addr) {}
+#endif
+
 #endif
Index: linux-2.6.git/include/asm-x86/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/io.h	2008-01-15 10:05:13.000000000 -0800
+++ linux-2.6.git/include/asm-x86/io.h	2008-01-15 10:21:42.000000000 -0800
@@ -2,6 +2,7 @@
 #define _ASM_X86_IO_H
 
 #define ioremap_wc ioremap_wc
+#define unxlate_dev_mem_ptr unxlate_dev_mem_ptr
 
 #ifdef CONFIG_X86_32
 # include "io_32.h"
@@ -10,6 +11,8 @@
 #endif
 
 extern void __iomem * ioremap_wc(unsigned long offset, unsigned long size);
+extern void *xlate_dev_mem_ptr(unsigned long phys);
+extern void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
 
 #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
 
Index: linux-2.6.git/include/asm-x86/io_32.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/io_32.h	2008-01-15 10:05:13.000000000 -0800
+++ linux-2.6.git/include/asm-x86/io_32.h	2008-01-15 10:05:51.000000000 -0800
@@ -49,12 +49,6 @@
 #include <linux/vmalloc.h>
 
 /*
- * Convert a physical pointer to a virtual kernel pointer for /dev/mem
- * access
- */
-#define xlate_dev_mem_ptr(p)	__va(p)
-
-/*
  * Convert a virtual cached pointer to an uncached pointer
  */
 #define xlate_dev_kmem_ptr(p)	p
Index: linux-2.6.git/include/asm-x86/io_64.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/io_64.h	2008-01-15 10:05:13.000000000 -0800
+++ linux-2.6.git/include/asm-x86/io_64.h	2008-01-15 10:05:51.000000000 -0800
@@ -278,12 +278,6 @@
 #define BIO_VMERGE_BOUNDARY iommu_bio_merge
 
 /*
- * Convert a physical pointer to a virtual kernel pointer for /dev/mem
- * access
- */
-#define xlate_dev_mem_ptr(p)	__va(p)
-
-/*
  * Convert a virtual cached pointer to an uncached pointer
  */
 #define xlate_dev_kmem_ptr(p)	p

-- 

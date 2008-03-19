Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYCSUEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYCSUEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757062AbYCSTiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:16668 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbYCSTiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,520,1199692800"; 
   d="scan'208";a="356900587"
Message-Id: <20080319000058.762921000@intel.com>
References: <20080319000012.439150000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Mar 2008 17:00:15 -0700
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 03/13] x86: PAT Avoid aliasing in /dev/mem read/write
Content-Disposition: inline; filename=x86_xlate_dev_mem_ptr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add xlate and unxlate around /dev/mem read/write. This sets up the mapping
that can be used for /dev/mem read and write without aliasing worries.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6-x86.git/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/mm/ioremap.c	2008-03-18 02:16:08.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/mm/ioremap.c	2008-03-18 09:20:38.000000000 -0700
@@ -284,6 +284,35 @@
 }
 EXPORT_SYMBOL(iounmap);
 
+/*
+ * Convert a physical pointer to a virtual kernel pointer for /dev/mem
+ * access
+ */
+void *xlate_dev_mem_ptr(unsigned long phys)
+{
+	void *addr;
+	unsigned long start = phys & PAGE_MASK;
+
+	/* If page is RAM, we can use __va. Otherwise ioremap and unmap. */
+	if (page_is_ram(start >> PAGE_SHIFT))
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
+	if (page_is_ram(phys >> PAGE_SHIFT))
+		return;
+
+	iounmap((void __iomem *)((unsigned long)addr & PAGE_MASK));
+	return;
+}
+
 #ifdef CONFIG_X86_32
 
 int __initdata early_ioremap_debug;
Index: linux-2.6-x86.git/drivers/char/mem.c
===================================================================
--- linux-2.6-x86.git.orig/drivers/char/mem.c	2008-03-18 02:16:08.000000000 -0700
+++ linux-2.6-x86.git/drivers/char/mem.c	2008-03-18 09:20:34.000000000 -0700
@@ -134,6 +134,10 @@
 }
 #endif
 
+void __attribute__((weak)) unxlate_dev_mem_ptr(unsigned long phys, void *addr)
+{
+}
+
 /*
  * This funcion reads the *physical* memory. The f_pos points directly to the 
  * memory location. 
@@ -176,17 +180,25 @@
 
 		sz = min_t(unsigned long, sz, count);
 
+		if (!range_is_allowed(p >> PAGE_SHIFT, count))
+			return -EPERM;
+
 		/*
 		 * On ia64 if a page has been mapped somewhere as
 		 * uncached, then it must also be accessed uncached
 		 * by the kernel or data corruption may occur
 		 */
 		ptr = xlate_dev_mem_ptr(p);
+		if (!ptr)
+			return -EFAULT;
 
-		if (!range_is_allowed(p >> PAGE_SHIFT, count))
-			return -EPERM;
-		if (copy_to_user(buf, ptr, sz))
+		if (copy_to_user(buf, ptr, sz)) {
+			unxlate_dev_mem_ptr(p, ptr);
 			return -EFAULT;
+		}
+
+		unxlate_dev_mem_ptr(p, ptr);
+
 		buf += sz;
 		p += sz;
 		count -= sz;
@@ -235,22 +247,32 @@
 
 		sz = min_t(unsigned long, sz, count);
 
+		if (!range_is_allowed(p >> PAGE_SHIFT, sz))
+			return -EPERM;
+
 		/*
 		 * On ia64 if a page has been mapped somewhere as
 		 * uncached, then it must also be accessed uncached
 		 * by the kernel or data corruption may occur
 		 */
 		ptr = xlate_dev_mem_ptr(p);
+		if (!ptr) {
+			if (written)
+				break;
+			return -EFAULT;
+		}
 
-		if (!range_is_allowed(p >> PAGE_SHIFT, sz))
-			return -EPERM;
 		copied = copy_from_user(ptr, buf, sz);
 		if (copied) {
 			written += sz - copied;
+			unxlate_dev_mem_ptr(p, ptr);
 			if (written)
 				break;
 			return -EFAULT;
 		}
+
+		unxlate_dev_mem_ptr(p, ptr);
+
 		buf += sz;
 		p += sz;
 		count -= sz;
Index: linux-2.6-x86.git/include/asm-x86/io_32.h
===================================================================
--- linux-2.6-x86.git.orig/include/asm-x86/io_32.h	2008-03-18 02:16:08.000000000 -0700
+++ linux-2.6-x86.git/include/asm-x86/io_32.h	2008-03-18 03:11:12.000000000 -0700
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
Index: linux-2.6-x86.git/include/asm-x86/io_64.h
===================================================================
--- linux-2.6-x86.git.orig/include/asm-x86/io_64.h	2008-03-18 02:16:08.000000000 -0700
+++ linux-2.6-x86.git/include/asm-x86/io_64.h	2008-03-18 03:11:12.000000000 -0700
@@ -282,12 +282,6 @@
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
Index: linux-2.6-x86.git/include/asm-x86/io.h
===================================================================
--- linux-2.6-x86.git.orig/include/asm-x86/io.h	2008-03-18 02:16:08.000000000 -0700
+++ linux-2.6-x86.git/include/asm-x86/io.h	2008-03-18 09:20:38.000000000 -0700
@@ -1,5 +1,13 @@
+#ifndef _ASM_X86_IO_H
+#define _ASM_X86_IO_H
+
 #ifdef CONFIG_X86_32
 # include "io_32.h"
 #else
 # include "io_64.h"
 #endif
+
+extern void *xlate_dev_mem_ptr(unsigned long phys);
+extern void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
+
+#endif /* _ASM_X86_IO_H */

-- 

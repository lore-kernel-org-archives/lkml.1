Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbYAJS40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbYAJS40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759404AbYAJSzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:55:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:4606 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757616AbYAJSzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:55:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="320739381"
Message-Id: <20080110184856.379082000@intel.com>
References: <20080110184840.927409000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jan 2008 10:48:49 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 09/11] PAT x86: Add ioremap_wc support
Content-Disposition: inline; filename=ioremap_wc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward port of ioremap.patch to x86 tree.
Shared code across i386 and x86_64 are in shared files ioremap.c and io.h.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Index: linux-2.6.git/arch/x86/mm/ioremap_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/ioremap_64.c	2008-01-08 05:12:14.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/ioremap_64.c	2008-01-08 05:15:56.000000000 -0800
@@ -127,7 +127,7 @@
 EXPORT_SYMBOL(__ioremap);
 
 /**
- * ioremap_nocache     -   map bus memory into CPU space
+ * ioremap_nocache     -   map bus memory into CPU space uncached
  * @offset:    bus address of the memory
  * @size:      size of the resource to map
  *
@@ -154,6 +154,7 @@
 }
 EXPORT_SYMBOL(ioremap_nocache);
 
+
 /**
  * iounmap - Free a IO remapping
  * @addr: virtual address from ioremap_*
Index: linux-2.6.git/include/asm-x86/io_64.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/io_64.h	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/include/asm-x86/io_64.h	2008-01-08 05:15:56.000000000 -0800
@@ -165,7 +165,7 @@
  * it's useful if some control registers are in such an area and write combining
  * or read caching is not desirable:
  */
-extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
+extern void __iomem * ioremap_nocache(unsigned long offset, unsigned long size);
 extern void iounmap(volatile void __iomem *addr);
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
Index: linux-2.6.git/include/asm-generic/iomap.h
===================================================================
--- linux-2.6.git.orig/include/asm-generic/iomap.h	2008-01-08 03:31:37.000000000 -0800
+++ linux-2.6.git/include/asm-generic/iomap.h	2008-01-08 05:15:56.000000000 -0800
@@ -65,4 +65,8 @@
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 
+#ifndef ioremap_wc
+#define ioremap_wc ioremap_nocache
+#endif
+
 #endif
Index: linux-2.6.git/arch/x86/mm/Makefile_32
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/Makefile_32	2008-01-08 04:43:09.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/Makefile_32	2008-01-08 05:16:50.000000000 -0800
@@ -2,7 +2,7 @@
 # Makefile for the linux i386-specific parts of the memory manager.
 #
 
-obj-y	:= init_32.o pgtable_32.o fault_32.o ioremap_32.o extable.o pageattr_32.o mmap.o pat.o
+obj-y	:= init_32.o pgtable_32.o fault_32.o ioremap_32.o extable.o pageattr_32.o mmap.o pat.o ioremap.o
 
 obj-$(CONFIG_NUMA) += discontig_32.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
Index: linux-2.6.git/arch/x86/mm/Makefile_64
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/Makefile_64	2008-01-08 04:32:05.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/Makefile_64	2008-01-08 05:16:32.000000000 -0800
@@ -2,7 +2,7 @@
 # Makefile for the linux x86_64-specific parts of the memory manager.
 #
 
-obj-y	 := init_64.o fault_64.o ioremap_64.o extable.o pageattr_64.o mmap.o pat.o
+obj-y	 := init_64.o fault_64.o ioremap_64.o extable.o pageattr_64.o mmap.o pat.o ioremap.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_NUMA) += numa_64.o
 obj-$(CONFIG_K8_NUMA) += k8topology_64.o
Index: linux-2.6.git/arch/x86/mm/ioremap.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.git/arch/x86/mm/ioremap.c	2008-01-08 05:15:56.000000000 -0800
@@ -0,0 +1,31 @@
+#include <linux/module.h>
+
+#include <asm/io.h>
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+
+/**
+ * ioremap_wc    -   map bus memory into CPU space write combined
+ * @offset:    bus address of the memory
+ * @size:      size of the resource to map
+ *
+ * ioremap_wc performs a platform specific sequence of operations to
+ * make bus memory CPU accessible via the readb/readw/readl/writeb/
+ * writew/writel functions and the other mmio helpers. The returned
+ * address is not guaranteed to be usable directly as a virtual
+ * address.
+ *
+ * This version of ioremap ensures that the memory is marked write combining.
+ * Write combining allows faster writes to some hardware devices.
+ * See also iounmap_nocache for more details.
+ *
+ * Must be freed with iounmap.
+ */
+void __iomem *ioremap_wc(unsigned long phys_addr, unsigned long size)
+{
+	if (pat_wc_enabled)
+		return __ioremap(phys_addr, size, _PAGE_WC);
+	else
+		return ioremap_nocache(phys_addr, size);
+}
+EXPORT_SYMBOL(ioremap_wc);
Index: linux-2.6.git/include/asm-x86/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/io.h	2008-01-08 03:31:38.000000000 -0800
+++ linux-2.6.git/include/asm-x86/io.h	2008-01-08 05:15:56.000000000 -0800
@@ -1,5 +1,14 @@
+#ifndef _ASM_X86_IO_H
+#define _ASM_X86_IO_H
+
+#define ioremap_wc ioremap_wc
+
 #ifdef CONFIG_X86_32
 # include "io_32.h"
 #else
 # include "io_64.h"
 #endif
+
+extern void __iomem * ioremap_wc(unsigned long offset, unsigned long size);
+
+#endif

-- 

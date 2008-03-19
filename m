Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbYCSU2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbYCSU2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbYCSTjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:16659 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756993AbYCSTiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,520,1199692800"; 
   d="scan'208";a="263474521"
Message-Id: <20080319000100.773690000@intel.com>
References: <20080319000012.439150000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Mar 2008 17:00:24 -0700
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 12/13] x86: PAT Add ioremap_wc() interface
Content-Disposition: inline; filename=ioremap_wc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce ioremap_wc for wc remap. There is also a generic ioremap_wc
aliased to ioremap_uc so that drivers can use this interface transparently.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6-x86.git/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/mm/ioremap.c	2008-03-18 03:21:25.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/mm/ioremap.c	2008-03-18 09:20:21.000000000 -0700
@@ -98,6 +98,9 @@
 	default:
 		err = _set_memory_uc(vaddr, nrpages);
 		break;
+	case _PAGE_CACHE_WC:
+		err = _set_memory_wc(vaddr, nrpages);
+		break;
 	case _PAGE_CACHE_WB:
 		err = _set_memory_wb(vaddr, nrpages);
 		break;
@@ -168,8 +171,13 @@
 		 * Do not fallback to certain memory types with certain
 		 * requested type:
 		 * - request is uncached, return cannot be write-back
+		 * - request is uncached, return cannot be write-combine
+		 * - request is write-combine, return cannot be write-back
 		 */
 		if ((prot_val == _PAGE_CACHE_UC &&
+		     (new_prot_val == _PAGE_CACHE_WB ||
+		      new_prot_val == _PAGE_CACHE_WC)) ||
+		    (prot_val == _PAGE_CACHE_WC &&
 		     new_prot_val == _PAGE_CACHE_WB)) {
 			free_memtype(phys_addr, phys_addr + size);
 			return NULL;
@@ -182,6 +190,9 @@
 	default:
 		prot = PAGE_KERNEL_NOCACHE;
 		break;
+	case _PAGE_CACHE_WC:
+		prot = PAGE_KERNEL_WC;
+		break;
 	case _PAGE_CACHE_WB:
 		prot = PAGE_KERNEL;
 		break;
@@ -240,6 +251,25 @@
 }
 EXPORT_SYMBOL(ioremap_nocache);
 
+/**
+ * ioremap_wc	-	map memory into CPU space write combined
+ * @offset:	bus address of the memory
+ * @size:	size of the resource to map
+ *
+ * This version of ioremap ensures that the memory is marked write combining.
+ * Write combining allows faster writes to some hardware devices.
+ *
+ * Must be freed with iounmap.
+ */
+void __iomem *ioremap_wc(unsigned long phys_addr, unsigned long size)
+{
+	if (pat_wc_enabled)
+		return __ioremap(phys_addr, size, _PAGE_CACHE_WC);
+	else
+		return ioremap_nocache(phys_addr, size);
+}
+EXPORT_SYMBOL(ioremap_wc);
+
 void __iomem *ioremap_cache(unsigned long phys_addr, unsigned long size)
 {
 	return __ioremap(phys_addr, size, _PAGE_CACHE_WB);
Index: linux-2.6-x86.git/include/asm-generic/iomap.h
===================================================================
--- linux-2.6-x86.git.orig/include/asm-generic/iomap.h	2008-03-18 02:16:03.000000000 -0700
+++ linux-2.6-x86.git/include/asm-generic/iomap.h	2008-03-18 03:54:39.000000000 -0700
@@ -60,6 +60,10 @@
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *);
 
+#ifndef ARCH_HAS_IOREMAP_WC
+#define ioremap_wc ioremap_nocache
+#endif
+
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
Index: linux-2.6-x86.git/include/asm-x86/io.h
===================================================================
--- linux-2.6-x86.git.orig/include/asm-x86/io.h	2008-03-18 03:14:09.000000000 -0700
+++ linux-2.6-x86.git/include/asm-x86/io.h	2008-03-18 03:54:39.000000000 -0700
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_IO_H
 #define _ASM_X86_IO_H
 
+#define ARCH_HAS_IOREMAP_WC
+
 #ifdef CONFIG_X86_32
 # include "io_32.h"
 #else
@@ -9,6 +11,7 @@
 
 extern int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 				unsigned long prot_val);
+extern void __iomem * ioremap_wc(unsigned long offset, unsigned long size);
 
 extern void *xlate_dev_mem_ptr(unsigned long phys);
 extern void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
Index: linux-2.6-x86.git/include/asm-x86/pgtable.h
===================================================================
--- linux-2.6-x86.git.orig/include/asm-x86/pgtable.h	2008-03-18 03:33:01.000000000 -0700
+++ linux-2.6-x86.git/include/asm-x86/pgtable.h	2008-03-18 03:54:39.000000000 -0700
@@ -90,6 +90,7 @@
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
 #define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_WC		(__PAGE_KERNEL | _PAGE_CACHE_WC)
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
 #define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
@@ -106,6 +107,7 @@
 #define PAGE_KERNEL_RO			MAKE_GLOBAL(__PAGE_KERNEL_RO)
 #define PAGE_KERNEL_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_EXEC)
 #define PAGE_KERNEL_RX			MAKE_GLOBAL(__PAGE_KERNEL_RX)
+#define PAGE_KERNEL_WC			MAKE_GLOBAL(__PAGE_KERNEL_WC)
 #define PAGE_KERNEL_NOCACHE		MAKE_GLOBAL(__PAGE_KERNEL_NOCACHE)
 #define PAGE_KERNEL_EXEC_NOCACHE	MAKE_GLOBAL(__PAGE_KERNEL_EXEC_NOCACHE)
 #define PAGE_KERNEL_LARGE		MAKE_GLOBAL(__PAGE_KERNEL_LARGE)

-- 

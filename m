Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbYCSUoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbYCSUoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbYCSTlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:41:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:13573 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757791AbYCSTlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,520,1199692800"; 
   d="scan'208";a="536061932"
Message-Id: <20080319000058.977770000@intel.com>
References: <20080319000012.439150000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Mar 2008 17:00:16 -0700
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 04/13] x86: PAT make ioremap_change_attr non-static
Content-Disposition: inline; filename=make_ioremap_change_attr_nonstatic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ioremap_change_attr() non-static and use prot_val in place of ioremap_mode.
This interface is used in subsequent PAT patches.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6-x86.git/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/mm/ioremap.c	2008-03-18 03:11:12.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/mm/ioremap.c	2008-03-18 09:20:37.000000000 -0700
@@ -21,11 +21,6 @@
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
 
-enum ioremap_mode {
-	IOR_MODE_UNCACHED,
-	IOR_MODE_CACHED,
-};
-
 #ifdef CONFIG_X86_64
 
 unsigned long __phys_addr(unsigned long x)
@@ -91,18 +86,18 @@
  * Fix up the linear direct mapping of the kernel to avoid cache attribute
  * conflicts.
  */
-static int ioremap_change_attr(unsigned long vaddr, unsigned long size,
-			       enum ioremap_mode mode)
+int ioremap_change_attr(unsigned long vaddr, unsigned long size,
+			       unsigned long prot_val)
 {
 	unsigned long nrpages = size >> PAGE_SHIFT;
 	int err;
 
-	switch (mode) {
-	case IOR_MODE_UNCACHED:
+	switch (prot_val) {
+	case _PAGE_CACHE_UC:
 	default:
 		err = set_memory_uc(vaddr, nrpages);
 		break;
-	case IOR_MODE_CACHED:
+	case _PAGE_CACHE_WB:
 		err = set_memory_wb(vaddr, nrpages);
 		break;
 	}
@@ -120,7 +115,7 @@
  * caller shouldn't need to know that small detail.
  */
 static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
-			       enum ioremap_mode mode)
+			       unsigned long prot_val)
 {
 	unsigned long pfn, offset, last_addr, vaddr;
 	struct vm_struct *area;
@@ -158,12 +153,12 @@
 		WARN_ON_ONCE(is_ram);
 	}
 
-	switch (mode) {
-	case IOR_MODE_UNCACHED:
+	switch (prot_val) {
+	case _PAGE_CACHE_UC:
 	default:
 		prot = PAGE_KERNEL_NOCACHE;
 		break;
-	case IOR_MODE_CACHED:
+	case _PAGE_CACHE_WB:
 		prot = PAGE_KERNEL;
 		break;
 	}
@@ -188,7 +183,7 @@
 		return NULL;
 	}
 
-	if (ioremap_change_attr(vaddr, size, mode) < 0) {
+	if (ioremap_change_attr(vaddr, size, prot_val) < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
@@ -222,13 +217,13 @@
  */
 void __iomem *ioremap_nocache(unsigned long phys_addr, unsigned long size)
 {
-	return __ioremap(phys_addr, size, IOR_MODE_UNCACHED);
+	return __ioremap(phys_addr, size, _PAGE_CACHE_UC);
 }
 EXPORT_SYMBOL(ioremap_nocache);
 
 void __iomem *ioremap_cache(unsigned long phys_addr, unsigned long size)
 {
-	return __ioremap(phys_addr, size, IOR_MODE_CACHED);
+	return __ioremap(phys_addr, size, _PAGE_CACHE_WB);
 }
 EXPORT_SYMBOL(ioremap_cache);
 
Index: linux-2.6-x86.git/include/asm-x86/io.h
===================================================================
--- linux-2.6-x86.git.orig/include/asm-x86/io.h	2008-03-18 03:11:12.000000000 -0700
+++ linux-2.6-x86.git/include/asm-x86/io.h	2008-03-18 09:20:25.000000000 -0700
@@ -7,6 +7,9 @@
 # include "io_64.h"
 #endif
 
+extern int ioremap_change_attr(unsigned long vaddr, unsigned long size,
+				unsigned long prot_val);
+
 extern void *xlate_dev_mem_ptr(unsigned long phys);
 extern void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
 

-- 

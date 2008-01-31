Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbYAaHgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbYAaHgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYAaHfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:35:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:63648 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbYAaHfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:35:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,283,1199692800"; 
   d="scan'208";a="294571495"
Subject: [PATCH 4/5] x86: add executable mapping support to ioremap
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 31 Jan 2008 15:36:07 +0800
Message-Id: <1201764967.12950.25.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 31 Jan 2008 07:35:04.0464 (UTC) FILETIME=[CB95D100:01C863DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes ioremap() can be used to map pages as executable,
this is needed by EFI support.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/mm/ioremap.c   |   35 +++++++++++++++++++++++------------
 include/asm-x86/io_32.h |   14 ++++++++++++++
 include/asm-x86/io_64.h |   14 ++++++++++++++
 3 files changed, 51 insertions(+), 12 deletions(-)

--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -20,11 +20,6 @@
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
 
-enum ioremap_mode {
-	IOR_MODE_UNCACHED,
-	IOR_MODE_CACHED,
-};
-
 #ifdef CONFIG_X86_64
 
 unsigned long __phys_addr(unsigned long x)
@@ -71,7 +66,8 @@ int page_is_ram(unsigned long pagenr)
  * conflicts.
  */
 static int ioremap_change_attr(unsigned long paddr, unsigned long size,
-			       enum ioremap_mode mode)
+			       enum ioremap_mode mode,
+			       enum ioremap_xmode xmode)
 {
 	unsigned long vaddr = (unsigned long)__va(paddr);
 	unsigned long nrpages = size >> PAGE_SHIFT;
@@ -98,6 +94,16 @@ static int ioremap_change_attr(unsigned 
 		break;
 	}
 
+	if (err)
+		return err;
+
+	if (__supported_pte_mask & _PAGE_NX) {
+		if (xmode == IOR_XMODE_EXEC)
+			err = set_memory_x(vaddr, nrpages);
+		else
+			err = set_memory_nx(vaddr, nrpages);
+	}
+
 	return err;
 }
 
@@ -110,8 +116,9 @@ static int ioremap_change_attr(unsigned 
  * have to convert them into an offset in a page-aligned mapping, but the
  * caller shouldn't need to know that small detail.
  */
-static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
-			       enum ioremap_mode mode)
+void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
+			enum ioremap_mode mode,
+			enum ioremap_xmode xmode)
 {
 	void __iomem *addr;
 	struct vm_struct *area;
@@ -148,6 +155,9 @@ static void __iomem *__ioremap(unsigned 
 		break;
 	}
 
+	if ((__supported_pte_mask & _PAGE_NX) && xmode == IOR_XMODE_EXEC)
+		prot = __pgprot(pgprot_val(prot) & ~_PAGE_NX);
+
 	/*
 	 * Mappings have to be page-aligned
 	 */
@@ -169,7 +179,7 @@ static void __iomem *__ioremap(unsigned 
 		return NULL;
 	}
 
-	if (ioremap_change_attr(phys_addr, size, mode) < 0) {
+	if (ioremap_change_attr(phys_addr, size, mode, xmode) < 0) {
 		vunmap(addr);
 		return NULL;
 	}
@@ -200,13 +210,13 @@ static void __iomem *__ioremap(unsigned 
  */
 void __iomem *ioremap_nocache(unsigned long phys_addr, unsigned long size)
 {
-	return __ioremap(phys_addr, size, IOR_MODE_UNCACHED);
+	return __ioremap(phys_addr, size, IOR_MODE_UNCACHED, IOR_XMODE_UNEXEC);
 }
 EXPORT_SYMBOL(ioremap_nocache);
 
 void __iomem *ioremap_cache(unsigned long phys_addr, unsigned long size)
 {
-	return __ioremap(phys_addr, size, IOR_MODE_CACHED);
+	return __ioremap(phys_addr, size, IOR_MODE_CACHED, IOR_XMODE_UNEXEC);
 }
 EXPORT_SYMBOL(ioremap_cache);
 
@@ -254,7 +264,8 @@ void iounmap(volatile void __iomem *addr
 	}
 
 	/* Reset the direct mapping. Can block */
-	ioremap_change_attr(p->phys_addr, p->size, IOR_MODE_CACHED);
+	ioremap_change_attr(p->phys_addr, p->size,
+			    IOR_MODE_CACHED, IOR_XMODE_UNEXEC);
 
 	/* Finally remove it */
 	o = remove_vm_area((void *)addr);
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -153,6 +153,20 @@ static inline void * phys_to_virt(unsign
 extern void *early_ioremap(unsigned long addr, unsigned long size);
 extern void early_iounmap(void *addr, unsigned long size);
 
+enum ioremap_mode {
+	IOR_MODE_UNCACHED,
+	IOR_MODE_CACHED,
+};
+
+enum ioremap_xmode {
+	IOR_XMODE_EXEC,
+	IOR_XMODE_UNEXEC,
+};
+
+extern void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
+			       enum ioremap_mode mode,
+			       enum ioremap_xmode xmode);
+
 /*
  * This one maps high address device memory and turns off caching for that area.
  * it's useful if some control registers are in such an area and write combining
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -100,6 +100,20 @@ static inline void * phys_to_virt(unsign
  */
 #define page_to_phys(page)    ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)
 
+enum ioremap_mode {
+	IOR_MODE_UNCACHED,
+	IOR_MODE_CACHED,
+};
+
+enum ioremap_xmode {
+	IOR_XMODE_EXEC,
+	IOR_XMODE_UNEXEC,
+};
+
+extern void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
+			       enum ioremap_mode mode,
+			       enum ioremap_xmode xmode);
+
 /**
  * ioremap     -   map bus memory into CPU space
  * @offset:    bus address of the memory


Return-Path: <linux-kernel-owner+w=401wt.eu-S1764532AbXLMX5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764532AbXLMX5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763295AbXLMX5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:57:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:62004 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762780AbXLMX5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:57:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="295508612"
Message-Id: <20071213235713.977409000@intel.com>
References: <20071213235543.568682000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 13 Dec 2007 15:55:55 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [RFC PATCH 12/12] PAT 64b: skip attr tracking for RAM
Content-Disposition: inline; filename=skip-ram-attr-tracking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now, track the page attribute only for reserved regions (specified as
reserved in e820 or not present in e820 at all). As we don't have the kernel
identity mappings for these regions, existing simple infrastructure of memattr
list is enough. Otherwise we need to keep track of the actual reference
count, to do cpa for kernel identity mappings.

We don't track RAM pages using memattr infrastructure. This is because,
memattr infrastructure is not enough. i.e., while the page is getting
tracked using memattr infrastructure, potentially the page can get
freed(a bug that we need to catch, to avoid attribute aliasing).
For example, a driver does ioremap_uc and an application mapped the
same page using /dev/mem. When the driver does iounamp and free the page,
/dev/mem mapping is still live and we run into aliasing issue.

for now, we allow only UC for RAM pages (with out any tracking). Why?
This is what the current mainline kernel anyhow does.

TBD:

1. Do we need to allow RAM pages to be mapped as WC? If not, then
we don't need to follow the TLB flush mechanism (make pte not present,
flush, and set pte with new mapping) mentioned in section 10.12.4 of SDM Vol3a.

2. For a complete solution, handle RAM pages with UC and /dev/mem mapping
conflicts.  Can we use the existing page struct to keep track of the /dev/mem
mappings (through the page ref count) and not allow to free the page while
the /dev/mem mappings are active. And allow /dev/mem to map only those pages
which are marked reserved (which the driver does before doing iomap).

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6.24-rc4/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.24-rc4.orig/arch/x86/kernel/e820_64.c	2007-12-12 16:54:34.000000000 -0800
+++ linux-2.6.24-rc4/arch/x86/kernel/e820_64.c	2007-12-12 16:54:34.000000000 -0800
@@ -156,7 +156,7 @@
  * Note: this function only works correct if the e820 table is sorted and
  * not-overlapping, which is the case
  */
-int __init e820_all_mapped(unsigned long start, unsigned long end, unsigned type)
+int e820_all_mapped(unsigned long start, unsigned long end, unsigned type)
 {
 	int i;
 	for (i = 0; i < e820.nr_map; i++) {
@@ -220,6 +220,15 @@
 }
 EXPORT_SYMBOL_GPL(is_memory_all_valid);
 
+int is_memory_all_reserved(unsigned long start, unsigned long end)
+{
+	/* Switch to efi or e820 in future here */
+	if (e820_all_mapped(start, end, E820_RESERVED) == 1)
+		return 1;
+	return !is_memory_any_valid(start, end);
+}
+EXPORT_SYMBOL_GPL(is_memory_all_reserved);
+
 int valid_phys_addr_range(unsigned long addr, size_t count)
 {
 	return is_memory_all_valid(addr, addr + count);
Index: linux-2.6.24-rc4/arch/x86/mm/ioremap_64.c
===================================================================
--- linux-2.6.24-rc4.orig/arch/x86/mm/ioremap_64.c	2007-12-12 16:54:34.000000000 -0800
+++ linux-2.6.24-rc4/arch/x86/mm/ioremap_64.c	2007-12-12 16:54:34.000000000 -0800
@@ -20,6 +20,7 @@
 #include <asm/cacheflush.h>
 #include <asm/proto.h>
 #include <asm/pat.h>
+#include <asm/e820.h>
 
 unsigned long __phys_addr(unsigned long x)
 {
@@ -72,12 +73,21 @@
 	struct vm_struct * area;
 	unsigned long offset, last_addr;
 	pgprot_t pgprot;
+	int all_memory = 0, all_reserved = 0;
 
 	/* Don't allow wraparound or zero size */
 	last_addr = phys_addr + size - 1;
 	if (!size || last_addr < phys_addr)
 		return NULL;
 
+	/* Don't allow overlapping attributes */
+	all_memory = is_memory_all_valid(phys_addr, last_addr);
+
+	all_reserved = is_memory_all_reserved(phys_addr, last_addr);
+
+	if (!all_memory && !all_reserved)
+		return NULL;
+
 	/*
 	 * Don't remap the low PCI/ISA area, it's always mapped..
 	 */
@@ -126,12 +136,19 @@
 
 	/* For plain ioremap() get the existing attributes. Otherwise
 	   check against the existing ones */
-	if (reserve_mattr(phys_addr, phys_addr + size, flags,
+	/* For now, we track the attributes for the reserved pages only.
+	 * For memory pages, this is TBD. While, we can track the page
+	 * attrib using struct page, enforcing the role is some
+	 * what tricky!
+	 */
+	if (all_reserved &&
+	    reserve_mattr(phys_addr, phys_addr + size, flags,
 			  flags ? NULL : &flags) < 0)
 		goto out;
 
 	if (flags && ioremap_change_attr(phys_addr, size, flags) < 0) {
-		free_mattr(phys_addr, phys_addr + size, flags);
+		if (all_reserved)
+			free_mattr(phys_addr, phys_addr + size, flags);
 		goto out;
 	}
 	return (__force void __iomem *) (offset + (char *)addr);
@@ -190,7 +207,10 @@
  */
 void __iomem *ioremap_wc(unsigned long phys_addr, unsigned long size)
 {
-	return __ioremap(phys_addr, size, _PAGE_WC);
+	if (!is_memory_any_valid(phys_addr, phys_addr + size - 1))
+		return __ioremap(phys_addr, size, _PAGE_WC);
+	else
+		return NULL;
 }
 EXPORT_SYMBOL(ioremap_wc);
 
@@ -232,7 +252,8 @@
 
 	/* Reset the direct mapping. Can block */
 	if (p->flags >> 20) {
-		free_mattr(p->phys_addr, p->phys_addr + p->size, p->flags>>20);
+		if (is_memory_all_reserved(p->phys_addr, p->phys_addr + p->size))
+			free_mattr(p->phys_addr, p->phys_addr + p->size, p->flags>>20);
 		ioremap_change_attr(p->phys_addr, p->size, 0);
 	}
 
Index: linux-2.6.24-rc4/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.24-rc4.orig/include/asm-x86/e820_64.h	2007-12-12 16:54:34.000000000 -0800
+++ linux-2.6.24-rc4/include/asm-x86/e820_64.h	2007-12-12 16:54:34.000000000 -0800
@@ -28,6 +28,7 @@
 extern int is_memory_any_valid(unsigned long start, unsigned long end);
 extern int e820_all_non_reserved(unsigned long start, unsigned long end);
 extern int is_memory_all_valid(unsigned long start, unsigned long end);
+extern int is_memory_all_reserved(unsigned long start, unsigned long end);
 extern unsigned long e820_hole_size(unsigned long start, unsigned long end);
 
 extern void e820_setup_gap(void);
Index: linux-2.6.24-rc4/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.24-rc4.orig/arch/x86/mm/pat.c	2007-12-12 16:53:39.000000000 -0800
+++ linux-2.6.24-rc4/arch/x86/mm/pat.c	2007-12-12 16:54:34.000000000 -0800
@@ -11,6 +11,7 @@
 #include <asm/pat.h>
 #include <asm/cacheflush.h>
 #include <asm/fcntl.h>
+#include <asm/e820.h>
 
 static u64 boot_pat_state;
 
@@ -176,8 +177,15 @@
 	if ((file->f_flags & O_SYNC) || (offset >= __pa(high_memory)))
 		want_flags = _PAGE_PCD;
 
-	/* ignore error because we can't handle it here */
-	reserve_mattr(offset, offset+size, want_flags, &flags);
+	if (is_memory_all_reserved(offset, offset + size - 1))
+		/* ignore error because we can't handle it here */
+		reserve_mattr(offset, offset+size, want_flags, &flags);
+	else
+		/* for memory pages, we will allow what the requestor wants
+		 * except for WC for now.
+		 */
+		flags = want_flags & ~_PAGE_PWT;
+
 	if (flags != want_flags) {
 		printk(KERN_INFO
 	"%s:%d /dev/mem expected mapping type %s for %Lx-%Lx, got %s\n",
@@ -200,7 +208,8 @@
 void unmap_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
 {
 	u64 addr = (u64)pfn << PAGE_SHIFT;
-	free_mattr(addr, size, 0);
+	if (is_memory_all_reserved(addr, addr + size - 1))
+		free_mattr(addr, size, 0);
 	if (addr < __pa(high_memory) &&
 	   (pgprot_val(vma_prot) & _PAGE_CACHE_MASK))
 		change_page_attr_addr(addr, size >> PAGE_SHIFT, PAGE_KERNEL);

-- 

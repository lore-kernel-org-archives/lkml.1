Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbYAZQHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbYAZQHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757490AbYAZP45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:56:57 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757467AbYAZP4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:56:55 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 30/52] [microblaze] consistent allocation & page.h, ...
Date: Thu, 24 Jan 2008 16:03:05 +0100
Message-Id: <2f3db7ba4fe41cb9888adabf0e4e052d4da5c37c.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
 <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
 <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
 <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/mm/consistent.c    |  176 ++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/page.h      |  117 ++++++++++++++++++++++++
 include/asm-microblaze/segment.h   |   42 +++++++++
 include/asm-microblaze/unaligned.h |   16 ++++
 4 files changed, 351 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/mm/consistent.c
 create mode 100644 include/asm-microblaze/page.h
 create mode 100644 include/asm-microblaze/segment.h
 create mode 100644 include/asm-microblaze/unaligned.h

diff --git a/arch/microblaze/mm/consistent.c b/arch/microblaze/mm/consistent.c
new file mode 100644
index 0000000..fe7057b
--- /dev/null
+++ b/arch/microblaze/mm/consistent.c
@@ -0,0 +1,176 @@
+/*
+ *  Microblaze support for cache consistent memory.
+ *  Copyright (C) 2005 John Williams <jwilliams@itee.uq.edu.au>
+ *
+ *  based on
+ *
+ *  PowerPC version derived from arch/arm/mm/consistent.c
+ *    Copyright (C) 2001 Dan Malek (dmalek@jlc.net)
+ *
+ *  linux/arch/arm/mm/consistent.c
+ *
+ *  Copyright (C) 2000 Russell King
+ *
+ * Consistent memory allocators.  Used for DMA devices that want to
+ * share uncached memory with the processor core.
+ * My crufty no-MMU approach is simple.   In the HW platform we can optionally
+ * mirror the DDR up above the processor cacheable region.  So, memory accessed
+ * in this mirror region will not be cached.  It's alloced from the same
+ * pool as normal memory, but the handle we return is shifted up into the
+ * uncached region.  This will no doubt cause big problems if memory allocated
+ * here is not also freed properly. --JW
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/autoconf.h>
+#include <linux/module.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/stddef.h>
+#include <linux/vmalloc.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/bootmem.h>
+#include <linux/highmem.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+
+#include <asm/pgalloc.h>
+#include <asm/io.h>
+#include <asm/hardirq.h>
+#include <asm/mmu_context.h>
+#include <asm/mmu.h>
+#include <asm/uaccess.h>
+#include <asm/pgtable.h>
+#include <asm/dma-mapping.h>
+
+#include "../../../mm/internal.h"	/* set_page_count */
+
+void *consistent_alloc(gfp_t gfp, size_t size, dma_addr_t *dma_handle)
+{
+	struct page *page, *end, *free;
+	unsigned long order;
+	void *ret, *virt;
+
+	if (in_interrupt())
+		BUG();
+
+	size = PAGE_ALIGN(size);
+	order = get_order(size);
+
+	page = alloc_pages(gfp, order);
+	if (!page)
+		goto no_page;
+
+	/*
+	 * We could do with a page_to_phys and page_to_bus here.
+	 */
+	virt = page_address(page);
+	/* *dma_handle = virt_to_bus(virt); */
+	ret = ioremap(virt_to_phys(virt), size);
+	if (!ret)
+		goto no_remap;
+
+	/* Here's the magic!  Note if the uncached shadow is not implemented,
+	   it's up to the calling code to also test that condition and make
+	   other arranegments, such as manually flushing the cache and so on.
+	*/
+#ifdef CONFIG_XILINX_UNCACHED_SHADOW
+	ret = (void *)((unsigned) ret | UNCACHED_SHADOW_MASK);
+#endif
+	/* For !MMU, dma_handle is same as physical (shadowed) address */
+	*dma_handle = (dma_addr_t)ret;
+
+	/*
+	 * free wasted pages.  We skip the first page since we know
+	 * that it will have count = 1 and won't require freeing.
+	 * We also mark the pages in use as reserved so that
+	 * remap_page_range works.
+	 */
+	page = virt_to_page(virt);
+	free = page + (size >> PAGE_SHIFT);
+	end  = page + (1 << order);
+
+	for (; page < end; page++) {
+		set_page_count(page, 1);
+		if (page >= free)
+			__free_page(page);
+		else
+			SetPageReserved(page);
+	}
+
+	return ret;
+no_remap:
+	__free_pages(page, order);
+no_page:
+	return NULL;
+}
+
+/*
+ * free page(s) as defined by the above mapping.
+ */
+void consistent_free(void *vaddr)
+{
+	if (in_interrupt())
+		BUG();
+
+	/* Clear SHADOW_MASK bit in address, and free as per usual */
+#ifdef CONFIG_XILINX_UNCACHED_SHADOW
+	vaddr = (void *)((unsigned)vaddr & ~UNCACHED_SHADOW_MASK);
+#endif
+	vfree(vaddr);
+}
+
+/*
+ * make an area consistent.
+ */
+void consistent_sync(void *vaddr, size_t size, int direction)
+{
+	unsigned long start;
+	unsigned long end;
+
+	start = (unsigned long)vaddr;
+
+	/* Convert start address back down to unshadowed memory region */
+#ifdef CONFIG_XILINX_UNCACHED_SHADOW
+	start &= UNCACHED_SHADOW_MASK;
+#endif
+	end = start+size;
+
+	switch (direction) {
+	case PCI_DMA_NONE:
+		BUG();
+	case PCI_DMA_FROMDEVICE:	/* invalidate only */
+		flush_dcache_range(start, end);
+		break;
+	case PCI_DMA_TODEVICE:		/* writeback only */
+		flush_dcache_range(start, end);
+		break;
+	case PCI_DMA_BIDIRECTIONAL:	/* writeback and invalidate */
+		flush_dcache_range(start, end);
+		break;
+	}
+}
+
+/*
+ * consistent_sync_page makes memory consistent. identical
+ * to consistent_sync, but takes a struct page instead of a
+ * virtual address
+ */
+void consistent_sync_page(struct page *page, unsigned long offset,
+	size_t size, int direction)
+{
+	unsigned long start = (unsigned long)page_address(page) + offset;
+	consistent_sync((void *)start, size, direction);
+}
diff --git a/include/asm-microblaze/page.h b/include/asm-microblaze/page.h
new file mode 100644
index 0000000..b3c891f
--- /dev/null
+++ b/include/asm-microblaze/page.h
@@ -0,0 +1,117 @@
+/*
+ * include/asm-microblaze/page.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_PAGE_H
+#define _ASM_PAGE_H
+
+#include <linux/autoconf.h>
+#include <linux/pfn.h>
+
+/* PAGE_SHIFT determines the page size */
+
+#define PAGE_SHIFT	(12)
+#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#define PAGE_MASK	(~(PAGE_SIZE-1))
+
+#ifdef __KERNEL__
+
+#include <asm/setup.h>
+
+#ifndef __ASSEMBLY__
+
+#define get_user_page(vaddr)			__get_free_page(GFP_KERNEL)
+#define free_user_page(page, addr)		free_page(addr)
+
+#define clear_page(pgaddr)			memset((pgaddr), 0, PAGE_SIZE)
+#define copy_page(to, from)			memcpy((to), (from), PAGE_SIZE)
+
+#define clear_user_page(pgaddr, vaddr, page)	memset((pgaddr), 0, PAGE_SIZE)
+#define copy_user_page(vto, vfrom, vaddr, topg) \
+			memcpy((vto), (vfrom), PAGE_SIZE)
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct { unsigned long	pte; }		pte_t;
+typedef struct { unsigned long	ste[64]; }	pmd_t;
+typedef struct { pmd_t		pue[1]; }	pud_t;
+typedef struct { pud_t		pge[1]; }	pgd_t;
+typedef struct { unsigned long	pgprot; }	pgprot_t;
+
+#define pte_val(x)	((x).pte)
+#define pmd_val(x)	((x).ste[0])
+#define pud_val(x)	((x).pue[0])
+#define pgd_val(x)	((x).pge[0])
+#define pgprot_val(x)	((x).pgprot)
+
+#define __pte(x)	((pte_t) { (x) })
+#define __pmd(x)	((pmd_t) { (x) })
+#define __pgd(x)	((pgd_t) { (x) })
+#define __pgprot(x)	((pgprot_t) { (x) })
+
+/* align addr on a size boundary - adjust address up/down if needed */
+#define _ALIGN_UP(addr, size)	(((addr)+((size)-1))&(~((size)-1)))
+#define _ALIGN_DOWN(addr, size)	((addr)&(~((size)-1)))
+
+/* align addr on a size boundary - adjust address up if needed */
+#define _ALIGN(addr, size)	_ALIGN_UP(addr, size)
+
+/* to align the pointer to the (next) page boundary */
+#define PAGE_ALIGN(addr)	(((addr) + PAGE_SIZE - 1) & PAGE_MASK)
+
+extern unsigned int PAGE_OFFSET;
+
+/**
+ * Conversions for virtual address, physical address, pfn, and struct
+ * page are defined in the following files.
+ *
+ * virt -+
+ *	 | asm-microblaze/page.h
+ * phys -+
+ *	 | linux/pfn.h
+ *  pfn -+
+ *	 | asm-generic/memory_model.h
+ * page -+
+ *
+ */
+
+extern unsigned long max_low_pfn;
+extern unsigned long min_low_pfn;
+extern unsigned long max_pfn;
+
+#define __pa(vaddr)		((unsigned long) (vaddr))
+#define __va(paddr)		((void *) (paddr))
+
+#define phys_to_pfn(phys)	(PFN_DOWN(phys))
+#define pfn_to_phys(pfn)	(PFN_PHYS(pfn))
+
+#define virt_to_pfn(vaddr)	(phys_to_pfn((__pa(vaddr))))
+#define pfn_to_virt(pfn)	__va(pfn_to_phys((pfn)))
+
+#define virt_to_page(vaddr)	(pfn_to_page(virt_to_pfn(vaddr)))
+#define page_to_virt(page)	(pfn_to_virt(page_to_pfn(page)))
+
+#define page_to_phys(page)	(pfn_to_phys(page_to_pfn(page)))
+#define page_to_bus(page)	(page_to_phys(page))
+#define phys_to_page(paddr)	(pfn_to_page(phys_to_pfn(paddr)))
+
+#define pfn_valid(pfn)		((pfn) >= min_low_pfn && (pfn) < max_mapnr)
+#define	virt_addr_valid(vaddr)	(pfn_valid(virt_to_pfn(vaddr)))
+
+#define ARCH_PFN_OFFSET		(PAGE_OFFSET >> PAGE_SHIFT)
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#include <asm-generic/memory_model.h>
+#include <asm-generic/page.h>
+
+#endif /* _ASM_PAGE_H */
diff --git a/include/asm-microblaze/segment.h b/include/asm-microblaze/segment.h
new file mode 100644
index 0000000..bd8b633
--- /dev/null
+++ b/include/asm-microblaze/segment.h
@@ -0,0 +1,42 @@
+/*
+ * include/asm-microblaze/segment.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ */
+
+#ifndef _ASM_SEGMENT_H
+#define _ASM_SEGMENT_H
+
+#ifndef __ASSEMBLY__
+
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+/*
+ * The fs value determines whether argument validity checking should be
+ * performed or not. If get_fs() == USER_DS, checking is performed, with
+ * get_fs() == KERNEL_DS, checking is bypassed.
+ *
+ * For historical reasons, these macros are grossly misnamed.
+ *
+ * For non-MMU arch like Microblaze, KERNEL_DS and USER_DS is equal.
+ */
+#define KERNEL_DS	((mm_segment_t){0})
+#define USER_DS		KERNEL_DS
+
+#define get_ds()	(KERNEL_DS)
+#define get_fs()	(current_thread_info()->addr_limit)
+#define set_fs(x) \
+		do { current_thread_info()->addr_limit = (x); } while (0)
+
+#define segment_eq(a, b)		((a).seg == (b).seg)
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_SEGMENT_H */
diff --git a/include/asm-microblaze/unaligned.h b/include/asm-microblaze/unaligned.h
new file mode 100644
index 0000000..edf79c2
--- /dev/null
+++ b/include/asm-microblaze/unaligned.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/unaligned.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_UNALIGNED_H
+#define _ASM_UNALIGNED_H
+
+#include <asm-generic/unaligned.h>
+
+#endif /* _ASM_UNALIGNED_H */
-- 
1.5.4.rc4.14.g6fc74


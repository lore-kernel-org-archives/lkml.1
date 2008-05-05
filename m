Return-Path: <linux-kernel-owner+w=401wt.eu-S1763245AbYEEWkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763245AbYEEWkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbYEEWjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:39:54 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:64285 "EHLO
	outbound5-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754886AbYEEWjx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:39:53 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Microblaze: implement dma-coherent API and refactor cache flush code.
Date: Mon, 5 May 2008 15:37:07 -0700
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Microblaze: implement dma-coherent API and refactor cache flush code.
Thread-Index: AcivABsrYBm8msD7RQu2VwBZn0WA7AAAFM3g
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
       "John Linn" <linnj@xilinx.com>, <john.williams@petalogix.com>,
       <matthew@wil.cx>, <will.newton@gmail.com>, <drepper@redhat.com>,
       <microblaze-uclinux@itee.uq.edu.au>, <grant.likely@secretlab.ca>,
       "Michal Simek" <monstr@monstr.eu>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 May 2008 22:37:05.0266 (UTC) FILETIME=[8B571520:01C8AF00]
Message-Id: <20080505223706.1236C1C8004E@mail131-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Primarily, this patch implements the dma-coherent API.  In addition,
it cleans up some of the code that deals with caches, in order to
match the usage in dma-coherent.

In particular, the dcache in the microblaze is write through, so the
existing code is more easily thought of as 'invalidation' than
'flushing'.  In addition, some of the flush_* methods were old, and
some shouldn't need to be implemented (since currently no mmu is
supported).

I'd appreciate if someone would ACK my interpretation of
Documentation/cachetlb.txt.  In particular:

flush_cache_mm(mm) (NOOP because nommu)
flush_cache_range(mm, start, end) (Does this need to be implemented
since nommu?)
flush_cache_page(vma, vmaddr) (NOOP because nommu)
flush_dcache_page(page) (NOOP because write through cache.)
flush_dcache_range(start, end) (NOOP because write through cache.)
flush_dcache_mmap_lock(mapping) (NOOP because nommu)
flush_dcache_mmap_unlock(mapping) (NOOP because nommu)

flush_icache_page(vma,pg) (Does this need to be implemented? Doc is
unclear, but I assume it is used as flush_icache_range)
flush_icache_range(start, end) (Must be implemented because icache
doesn't snoop dcache on code loads)

Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
---
 arch/microblaze/kernel/cpu/cache.c  |   37 +---------
 arch/microblaze/kernel/setup.c      |    4 +-
 arch/microblaze/mm/dma-coherent.c   |  122
+++++++++++++++++++++++++++++++++++
 include/asm-microblaze/cacheflush.h |   71 +++++++++------------
 4 files changed, 158 insertions(+), 76 deletions(-)
 create mode 100644 arch/microblaze/mm/dma-coherent.c

diff --git a/arch/microblaze/kernel/cpu/cache.c
b/arch/microblaze/kernel/cpu/cache.c
index d6a1eab..1247b9e 100644
--- a/arch/microblaze/kernel/cpu/cache.c
+++ b/arch/microblaze/kernel/cpu/cache.c
@@ -129,7 +129,7 @@ void _invalidate_dcache(unsigned int addr)
 				: "r" (addr));
 }
 
-void __flush_icache_all(void)
+void __invalidate_icache_all(void)
 {
 	unsigned int i;
 	unsigned flags;
@@ -149,7 +149,7 @@ void __flush_icache_all(void)
 	}
 }
 
-void __flush_icache_range(unsigned long start, unsigned long end)
+void __invalidate_icache_range(unsigned long start, unsigned long end)
 {
 	unsigned int i;
 	unsigned flags;
@@ -177,24 +177,7 @@ void __flush_icache_range(unsigned long start,
unsigned long end)
 	}
 }
 
-void __flush_icache_page(struct vm_area_struct *vma, struct page *page)
-{
-	__flush_icache_all();
-}
-
-void __flush_icache_user_range(struct vm_area_struct *vma,
-				struct page *page, unsigned long adr,
-				int len)
-{
-	__flush_icache_all();
-}
-
-void __flush_cache_sigtramp(unsigned long addr)
-{
-	__flush_icache_range(addr, addr + 8);
-}
-
-void __flush_dcache_all(void)
+void __invalidate_dcache_all(void)
 {
 	unsigned int i;
 	unsigned flags;
@@ -216,7 +199,7 @@ void __flush_dcache_all(void)
 	}
 }
 
-void __flush_dcache_range(unsigned long start, unsigned long end)
+void __invalidate_dcache_range(unsigned long start, unsigned long end)
 {
 	unsigned int i;
 	unsigned flags;
@@ -242,15 +225,3 @@ void __flush_dcache_range(unsigned long start,
unsigned long end)
 		local_irq_restore(flags);
 	}
 }
-
-void __flush_dcache_page(struct vm_area_struct *vma, struct page *page)
-{
-	__flush_dcache_all();
-}
-
-void __flush_dcache_user_range(struct vm_area_struct *vma,
-				struct page *page, unsigned long adr,
-				int len)
-{
-	__flush_dcache_all();
-}
diff --git a/arch/microblaze/kernel/setup.c
b/arch/microblaze/kernel/setup.c
index 43d53d9..241fb21 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -51,10 +51,10 @@ void __init setup_arch(char **cmdline_p)
 	/* irq_early_init(); */
 	setup_cpuinfo();
 
-	__flush_icache_all();
+	__invalidate_icache_all();
 	__enable_icache();
 
-	__flush_dcache_all();
+	__invalidate_icache_all();
 	__enable_dcache();
 
 	panic_timeout = 120;
diff --git a/arch/microblaze/mm/dma-coherent.c
b/arch/microblaze/mm/dma-coherent.c
new file mode 100644
index 0000000..308654f
--- /dev/null
+++ b/arch/microblaze/mm/dma-coherent.c
@@ -0,0 +1,122 @@
+/*
+ *  Microblaze support for cache consistent memory.
+ *
+ *  Copyright (C) 2007 Xilinx, Inc.
+ *
+ *  Based on arch/microblaze/mm/consistent.c
+ *  Copyright (C) 2005 John Williams <jwilliams@itee.uq.edu.au>
+ *  Based on arch/avr32/mm/dma-coherent.c
+ *  Copyright (C) 2004-2006 Atmel Corporation
+ *
+ * Consistent memory allocators.  Used for DMA devices that want to
+ * share memory with the processor core.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/dma-mapping.h>
+
+#include <asm/cacheflush.h>
+
+void dma_cache_sync(struct device *dev, void *vaddr, size_t size, int
direction)
+{
+	switch (direction) {
+	case DMA_FROM_DEVICE:		/* invalidate only */
+		invalidate_dcache_range(vaddr, vaddr + size);
+		break;
+	case DMA_TO_DEVICE:		/* writeback only */
+		flush_dcache_range(vaddr, vaddr + size);
+		break;
+	case DMA_BIDIRECTIONAL:		/* writeback and invalidate */
+		invalidate_dcache_range(vaddr, vaddr + size);
+		flush_dcache_range(vaddr, vaddr + size);
+		break;
+	default:
+		BUG();
+	}
+}
+EXPORT_SYMBOL(dma_cache_sync);
+
+static struct page *__dma_alloc(struct device *dev, size_t size,
+				dma_addr_t *handle, gfp_t gfp)
+{
+	struct page *page, *free, *end;
+	int order;
+
+	if (in_interrupt())
+		BUG();
+
+	size = PAGE_ALIGN(size);
+	order = get_order(size);
+
+	page = alloc_pages(gfp, order);
+	if (!page)
+		return NULL;
+
+	split_page(page, order);
+
+	/*
+	 * When accessing physical memory with valid cache data, we
+	 * get a cache hit even if the virtual memory region is marked
+	 * as uncached.
+	 *
+	 * Since the memory is newly allocated, there is no point in
+	 * doing a writeback. If the previous owner cares, he should
+	 * have flushed the cache before releasing the memory.
+	 */
+	invalidate_dcache_range(phys_to_virt(page_to_phys(page)), size);
+
+	*handle = page_to_bus(page);
+	free = page + (size >> PAGE_SHIFT);
+	end = page + (1 << order);
+
+	/*
+	 * Free any unused pages
+	 */
+	while (free < end) {
+		__free_page(free);
+		free++;
+	}
+
+	return page;
+}
+
+static void __dma_free(struct device *dev, size_t size,
+		       struct page *page, dma_addr_t handle)
+{
+	struct page *end = page + (PAGE_ALIGN(size) >> PAGE_SHIFT);
+
+	while (page < end)
+		__free_page(page++);
+}
+
+void *dma_alloc_coherent(struct device *dev, size_t size,
+			 dma_addr_t *handle, gfp_t gfp)
+{
+	struct page *page;
+	void *ret = NULL;
+
+	page = __dma_alloc(dev, size, handle, gfp);
+	if (page) {
+		ret = (void *)page_to_phys(page);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(dma_alloc_coherent);
+
+void dma_free_coherent(struct device *dev, size_t size,
+		       void *cpu_addr, dma_addr_t handle)
+{
+	void *addr;
+	struct page *page;
+
+	pr_debug("dma_free_coherent addr %p (phys %08lx) size %u\n",
+		 cpu_addr, (unsigned long)handle, (unsigned)size);
+	BUG_ON(!virt_addr_valid(addr));
+	page = virt_to_page(addr);
+	__dma_free(dev, size, page, handle);
+}
+EXPORT_SYMBOL(dma_free_coherent);
diff --git a/include/asm-microblaze/cacheflush.h
b/include/asm-microblaze/cacheflush.h
index ba7339d..782f01b 100644
--- a/include/asm-microblaze/cacheflush.h
+++ b/include/asm-microblaze/cacheflush.h
@@ -1,6 +1,7 @@
 /*
  * include/asm-microblaze/cacheflush.h
  *
+ * Copyright (C) 2008 Xilinx, Inc.
  * Copyright (C) 2007 PetaLogix
  * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
  * based on v850 version which was
@@ -15,58 +16,46 @@
 
 #ifndef _ASM_MICROBLAZE_CACHEFLUSH_H
 #define _ASM_MICROBLAZE_CACHEFLUSH_H
+#include <linux/kernel.h>	/* For min/max macros */
+#include <linux/mm.h>	/* For min/max macros */
+#include <asm/setup.h>
+#include <asm/page.h>
+#include <asm/cache.h>
 
-/* Somebody depends on this; sigh... */
-#include <linux/mm.h>
-
-#define flush_cache_all()			__flush_cache_all()
-#define flush_cache_mm(mm)			do { } while (0)
-#define flush_cache_range(vma, start, end)	__flush_cache_all()
-#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
-
-#define flush_dcache_range(start, end)	__flush_dcache_range(start, end)
-#define flush_dcache_page(page)		do { } while (0)
-#define flush_dcache_mmap_lock(mapping)		do { } while (0)
-#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
+/*
+ * Cache handling functions.
+ * Microblaze has a write-through data cache, and no icache snooping of
dcache.
+ */
+#define flush_cache_mm(mm)			do { } while(0)
+#define flush_cache_range(mm, start, end)	invalidate_cache_all()
+#define flush_cache_page(vma, vmaddr)		do { } while(0)
 
-#define flush_icache_range(start, len)	__flush_icache_range(start, len)
-#define flush_icache_page(vma, pg)		do { } while (0)
-#define flush_icache_user_range(start, len)	do { } while (0)
+#define flush_dcache_page(page)			do { } while(0)
+#define flush_dcache_range(start, end)		do { } while(0)
+#define flush_dcache_mmap_lock(mapping)		do { } while(0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while(0)
 
-#define flush_cache_vmap(start, end)		do { } while (0)
-#define flush_cache_vunmap(start, end)		do { } while (0)
+#define flush_icache_page(vma,pg)
__invalidate_icache_all()
+#define flush_icache_range(start, end)
__invalidate_icache_range(start, end)
 
-struct page;
-struct mm_struct;
-struct vm_area_struct;
 
 /* see arch/microblaze/kernel/cache.c */
-extern void __flush_icache_all(void);
-extern void __flush_icache_range(unsigned long start, unsigned long
end);
-extern void __flush_icache_page(struct vm_area_struct *vma, struct page
*page);
-extern void __flush_icache_user_range(struct vm_area_struct *vma,
-				struct page *page,
-				unsigned long adr, int len);
-extern void __flush_cache_sigtramp(unsigned long addr);
-
-extern void __flush_dcache_all(void);
-extern void __flush_dcache_range(unsigned long start, unsigned long
end);
-extern void __flush_dcache_page(struct vm_area_struct *vma, struct page
*page);
-extern void __flush_dcache_user_range(struct vm_area_struct *vma,
-				struct page *page,
-				unsigned long adr, int len);
+void __invalidate_icache_all(void);
+void __invalidate_icache_range(unsigned long start, unsigned long end);
+void __invalidate_dcache_all(void);
+void __invalidate_dcache_range(unsigned long start, unsigned long end);
 
-extern inline void __flush_cache_all(void)
-{
-	__flush_icache_all();
-	__flush_dcache_all();
-}
+#define invalidate_cache_all()
__invalidate_icache_all(); __invalidate_dcache_all()
+#define invalidate_dcache()
__invalidate_dcache_all()
+#define invalidate_icache()
__invalidate_icache_all()
+#define invalidate_dcache_range(start, end)
__invalidate_dcache_range(start,end)
+#define invalidate_icache_range(start, end)
__invalidate_icache_range(start,end)
 
 #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
 do { memcpy(dst, src, len); \
-	flush_icache_user_range(vma, page, vaddr, len); \
+	flush_icache_range ((unsigned) (dst), (unsigned) (dst) + (len));
\
 } while (0)
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
-	memcpy(dst, src, len)
+	memcpy((dst), (src), (len))
 
 #endif /* _ASM_MICROBLAZE_CACHEFLUSH_H */
-- 
1.5.3.4



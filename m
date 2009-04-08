Return-Path: <linux-kernel-owner+w=401wt.eu-S1751435AbZDHHgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbZDHHgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761022AbZDHHgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:36:01 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:36596 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758278AbZDHHf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:35:56 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Kyle McMartin <kyle@mcmartin.ca>
MIME-Version: 1.0
Subject: [PATCH 13/14] score - New architecure port to SunplusCT S+CORE
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFE096868D.D9DDAF2A-ON48257592.00293847-48257592.00297A79@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 8 Apr 2009 15:30:54 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/04/08 ?? 03:30:55,
	Serialize complete at 2009/04/08 ?? 03:30:55
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Liqin <liqin.chen@sunplusct.com>

mm/cache.c, mm/dma-default.c, mm/extable.c, mm/fault.c,
mm/init.c, mm/ioremap.c, mm/Makefile, mm/pgtable.c,
mm/tlb-miss.S and mm/tlb-score.c for the score architecture.

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
Signed off by: Lennox Wu <lennox.wu@sunplusct.com>
--

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/cache.c 
linux-2.6-git.new/arch/score/mm/cache.c
--- linux-2.6-git.ori/arch/score/mm/cache.c     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/cache.c     2009-04-08 
10:27:56.000000000 +0800
@@ -0,0 +1,307 @@
+/*
+ * arch/score/mm/cache.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/linkage.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <asm/cache.h>
+#include <asm/cacheflush.h>
+#include <asm/mmu_context.h>
+
+/* Cache operations. */
+void (*flush_cache_all)(void);
+void (*__flush_cache_all)(void);
+void (*flush_cache_mm)(struct mm_struct *mm);
+void (*flush_cache_range)(struct vm_area_struct *vma,
+                               unsigned long start, unsigned long end);
+void (*flush_cache_page)(struct vm_area_struct *vma,
+                               unsigned long page, unsigned long pfn);
+void (*flush_icache_range)(unsigned long start, unsigned long end);
+void (*__flush_cache_vmap)(void);
+void (*__flush_cache_vunmap)(void);
+void (*flush_cache_sigtramp)(unsigned long addr);
+void (*flush_data_cache_page)(unsigned long addr);
+EXPORT_SYMBOL(flush_data_cache_page);
+void (*flush_icache_all)(void);
+
+/*Score 7 cache operations*/
+static inline void s7___flush_cache_all(void);
+static void s7_flush_cache_mm(struct mm_struct *mm);
+static void s7_flush_cache_range(struct vm_area_struct *vma,
+                                unsigned long start, unsigned long end);
+static void s7_flush_cache_page(struct vm_area_struct *vma,
+                                unsigned long page, unsigned long pfn);
+static void s7_flush_icache_range(unsigned long start, unsigned long 
end);
+static void s7_flush_cache_sigtramp(unsigned long addr);
+static void s7_flush_data_cache_page(unsigned long addr);
+static void s7_flush_dcache_range(unsigned long start, unsigned long 
end);
+
+void __update_cache(struct vm_area_struct *vma, unsigned long address,
+       pte_t pte)
+{
+       struct page *page;
+       unsigned long pfn, addr;
+       int exec = (vma->vm_flags & VM_EXEC);
+
+       pfn = pte_pfn(pte);
+       if (unlikely(!pfn_valid(pfn)))
+               return;
+       page = pfn_to_page(pfn);
+       if (page_mapping(page) && Page_dcache_dirty(page)) {
+               addr = (unsigned long) page_address(page);
+               if (exec)
+                       s7_flush_data_cache_page(addr);
+               ClearPageDcacheDirty(page);
+       }
+}
+
+static inline void setup_protection_map(void)
+{
+       protection_map[0] = PAGE_NONE;
+       protection_map[1] = PAGE_READONLY;
+       protection_map[2] = PAGE_COPY;
+       protection_map[3] = PAGE_COPY;
+       protection_map[4] = PAGE_READONLY;
+       protection_map[5] = PAGE_READONLY;
+       protection_map[6] = PAGE_COPY;
+       protection_map[7] = PAGE_COPY;
+       protection_map[8] = PAGE_NONE;
+       protection_map[9] = PAGE_READONLY;
+       protection_map[10] = PAGE_SHARED;
+       protection_map[11] = PAGE_SHARED;
+       protection_map[12] = PAGE_READONLY;
+       protection_map[13] = PAGE_READONLY;
+       protection_map[14] = PAGE_SHARED;
+       protection_map[15] = PAGE_SHARED;
+}
+
+void __devinit cpu_cache_init(void)
+{
+       flush_cache_all = s7_flush_cache_all;
+       __flush_cache_all = s7___flush_cache_all;
+       flush_cache_mm = s7_flush_cache_mm;
+       flush_cache_range = s7_flush_cache_range;
+       flush_cache_page = s7_flush_cache_page;
+       flush_icache_range = s7_flush_icache_range;
+       flush_cache_sigtramp = s7_flush_cache_sigtramp;
+       flush_data_cache_page = s7_flush_data_cache_page;
+
+       setup_protection_map();
+}
+
+void s7_flush_icache_all(void)
+{
+       __asm__ __volatile__(
+       "la r8, s7_flush_icache_all\n"
+       "cache 0x10, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       : : : "r8");
+}
+
+void s7_flush_dcache_all(void)
+{
+       __asm__ __volatile__(
+       "la r8, s7_flush_dcache_all\n"
+       "cache 0x1f, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1a, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       : : : "r8");
+}
+
+void s7_flush_cache_all(void)
+{
+       __asm__ __volatile__(
+       "la r8, s7_flush_cache_all\n"
+       "cache 0x10, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1f, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1a, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       : : : "r8");
+}
+
+void s7___flush_cache_all(void)
+{
+       __asm__ __volatile__(
+       "la r8, s7_flush_cache_all\n"
+       "cache 0x10, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1f, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1a, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       : : : "r8");
+}
+
+static void s7_flush_cache_mm(struct mm_struct *mm)
+{
+       if (!cpu_context(0, mm))
+               return;
+       s7_flush_cache_all();
+}
+
+/*if we flush a range precisely , the processing may be very long.
+We must check each page in the range whether present. If the page is 
present,
+we can flush the range in the page. Be careful, the range may be cross 
two
+page, a page is present and another is not present.
+*/
+/*
+The interface is provided in hopes that the port can find
+a suitably efficient method for removing multiple page
+sized regions from the cache.
+*/
+static void s7_flush_cache_range(struct vm_area_struct *vma, unsigned 
long start,
+                                unsigned long end)
+{
+       struct mm_struct *mm = vma->vm_mm;
+       int exec = vma->vm_flags & VM_EXEC;
+       pgd_t *pgdp;
+       pud_t *pudp;
+       pmd_t *pmdp;
+       pte_t *ptep;
+
+       if (!cpu_context(0, mm))
+               return;
+
+       pgdp = pgd_offset(mm, start);
+       pudp = pud_offset(pgdp, start);
+       pmdp = pmd_offset(pudp, start);
+       ptep = pte_offset(pmdp, start);
+
+       while (start <= end) {
+               unsigned long tmpend;
+               pgdp = pgd_offset(mm, start);
+               pudp = pud_offset(pgdp, start);
+               pmdp = pmd_offset(pudp, start);
+               ptep = pte_offset(pmdp, start);
+
+               if (!(pte_val(*ptep) & _PAGE_PRESENT)) {
+                       start = (start + PAGE_SIZE) & ~(PAGE_SIZE - 1);
+                       continue;
+               }
+               tmpend = (start | (PAGE_SIZE-1)) > end ?
+                                end : (start | (PAGE_SIZE-1));
+
+               s7_flush_dcache_range(start, tmpend);
+               if (exec)
+                       s7_flush_icache_range(start, tmpend);
+               start = (start + PAGE_SIZE) & ~(PAGE_SIZE - 1);
+       }
+}
+
+static void s7_flush_cache_page(struct vm_area_struct *vma, unsigned long 
addr,
+                               unsigned long pfn)
+{
+       int exec = vma->vm_flags & VM_EXEC;
+       unsigned long kaddr = 0xa0000000 | (pfn << PAGE_SHIFT);
+
+       s7_flush_dcache_range(kaddr, kaddr + PAGE_SIZE);
+
+       if (exec)
+               s7_flush_icache_range(kaddr, kaddr + PAGE_SIZE);
+}
+
+static void s7_flush_cache_sigtramp(unsigned long addr)
+{
+       __asm__ __volatile__(
+       "cache 0x02, [%0, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+       "cache 0x02, [%0, 0x4]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+
+       "cache 0x0d, [%0, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+       "cache 0x0d, [%0, 0x4]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+
+       "cache 0x1a, [%0, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+       : : "r" (addr));
+}
+
+/*
+Just flush entire Dcache!!
+You must ensure the page doesn't include instructions, because
+the function will not flush the Icache.
+The addr must be cache aligned.
+*/
+static void s7_flush_data_cache_page(unsigned long addr)
+{
+       unsigned int i;
+       for (i = 0; i < PAGE_SIZE / DCACHE_LSIZE; i += DCACHE_LSIZE) {
+               __asm__ __volatile__(
+               "cache 0x0e, [%0, 0]\n"
+               "cache 0x1a, [%0, 0]\n"
+               "nop\n"
+               : : "r" (addr));
+               addr += DCACHE_LSIZE;
+       }
+}
+
+/*
+1. WB and invalid a cache line of Dcache
+2. Drain Write Buffer
+the range must be smaller than PAGE_SIZE
+*/
+static void s7_flush_dcache_range(unsigned long start, unsigned long end)
+{
+       int size, i;
+
+       start = start & ~(ICACHE_LSIZE - 1);
+       end = end & ~(ICACHE_LSIZE - 1);
+       size = end - start;
+       /* flush dcache to ram, and invalidate dcache lines. */
+       for (i = 0; i < size; i += DCACHE_LSIZE) {
+               __asm__ __volatile__(
+               "cache 0x0e, [%0, 0]\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+               "cache 0x1a, [%0, 0]\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+               : : "r" (start));
+               start += DCACHE_LSIZE;
+       }
+}
+
+static void s7_flush_icache_range(unsigned long start, unsigned long end)
+{
+       int size, i;
+       start = start & ~(ICACHE_LSIZE - 1);
+       end = end & ~(ICACHE_LSIZE - 1);
+
+       size = end - start;
+       /* invalidate icache lines. */
+       for (i = 0; i < size; i += ICACHE_LSIZE) {
+               __asm__ __volatile__(
+               "cache 0x02, [%0, 0]\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+               : : "r" (start));
+               start += ICACHE_LSIZE;
+       }
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/dma-default.c 
linux-2.6-git.new/arch/score/mm/dma-default.c
--- linux-2.6-git.ori/arch/score/mm/dma-default.c       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/dma-default.c       2009-04-07 
21:32:51.000000000 +0800
@@ -0,0 +1,158 @@
+/*
+ * arch/score/mm/dma-default.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/string.h>
+#include <asm/cache.h>
+#include <asm/io.h>
+
+void *dma_alloc_noncoherent(struct device *dev, size_t size,
+       dma_addr_t *dma_handle, gfp_t gfp)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_alloc_noncoherent);
+
+void *dma_alloc_coherent(struct device *dev, size_t size,
+       dma_addr_t *dma_handle, gfp_t gfp)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_alloc_coherent);
+
+void dma_free_noncoherent(struct device *dev, size_t size, void *vaddr,
+       dma_addr_t dma_handle)
+{
+}
+EXPORT_SYMBOL(dma_free_noncoherent);
+
+void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
+       dma_addr_t dma_handle)
+{
+}
+EXPORT_SYMBOL(dma_free_coherent);
+
+dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
+       enum dma_data_direction direction)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_map_single);
+
+void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t 
size,
+       enum dma_data_direction direction)
+{
+}
+EXPORT_SYMBOL(dma_unmap_single);
+
+int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+       enum dma_data_direction direction)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_map_sg);
+
+dma_addr_t dma_map_page(struct device *dev, struct page *page,
+       unsigned long offset, size_t size, enum dma_data_direction 
direction)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_map_page);
+
+void dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t 
size,
+       enum dma_data_direction direction)
+{
+}
+EXPORT_SYMBOL(dma_unmap_page);
+
+void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int 
nhwentries,
+       enum dma_data_direction direction)
+{
+}
+EXPORT_SYMBOL(dma_unmap_sg);
+
+void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+       size_t size, enum dma_data_direction direction)
+{
+}
+EXPORT_SYMBOL(dma_sync_single_for_cpu);
+
+void dma_sync_single_for_device(struct device *dev, dma_addr_t 
dma_handle,
+       size_t size, enum dma_data_direction direction)
+{
+}
+EXPORT_SYMBOL(dma_sync_single_for_device);
+
+void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t 
dma_handle,
+       unsigned long offset, size_t size, enum dma_data_direction 
direction)
+{
+}
+EXPORT_SYMBOL(dma_sync_single_range_for_cpu);
+
+void dma_sync_single_range_for_device(struct device *dev, dma_addr_t 
dma_handle,
+       unsigned long offset, size_t size, enum dma_data_direction 
direction)
+{
+}
+EXPORT_SYMBOL(dma_sync_single_range_for_device);
+
+void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int 
nelems,
+       enum dma_data_direction direction)
+{
+}
+EXPORT_SYMBOL(dma_sync_sg_for_cpu);
+
+void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, 
int nelems,
+       enum dma_data_direction direction)
+{
+}
+EXPORT_SYMBOL(dma_sync_sg_for_device);
+
+int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_mapping_error);
+
+int dma_supported(struct device *dev, u64 mask)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_supported);
+
+int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_is_consistent);
+
+void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+       enum dma_data_direction direction)
+{
+}
+EXPORT_SYMBOL(dma_cache_sync);
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/extable.c 
linux-2.6-git.new/arch/score/mm/extable.c
--- linux-2.6-git.ori/arch/score/mm/extable.c   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/extable.c   2009-03-23 
14:27:37.000000000 +0800
@@ -0,0 +1,41 @@
+/*
+ * arch/score/mm/extable.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <asm/uaccess.h>
+#include <asm/ptrace.h>
+
+int fixup_exception(struct pt_regs *regs)
+{
+       const struct exception_table_entry *fixup;
+
+       fixup = search_exception_tables(regs->cp0_epc);
+       if (fixup) {
+               regs->cp0_epc = fixup->nextinsn;
+               return 1;
+       }
+       return 0;
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/fault.c 
linux-2.6-git.new/arch/score/mm/fault.c
--- linux-2.6-git.ori/arch/score/mm/fault.c     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/fault.c     2009-03-31 
18:12:32.000000000 +0800
@@ -0,0 +1,240 @@
+/*
+ * arch/score/mm/fault.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/vt_kern.h>             /* For unblank_screen() */
+#include <linux/module.h>
+#include <asm/mmu_context.h>
+#include <asm/ptrace.h>
+#include <asm/system.h>
+#include <asm/uaccess.h>
+
+/*
+ * This routine handles page faults.  It determines the address,
+ * and the problem, and then passes it off to one of the appropriate
+ * routines.
+ */
+asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long write,
+                               unsigned long address)
+{
+       struct vm_area_struct *vma = NULL;
+       struct task_struct *tsk = current;
+       struct mm_struct *mm = tsk->mm;
+       const int field = sizeof(unsigned long) * 2;
+       siginfo_t info;
+       int fault;
+
+       info.si_code = SEGV_MAPERR;
+
+       /*
+       * We fault-in kernel-space virtual memory on-demand. The
+       * 'reference' page table is init_mm.pgd.
+       *
+       * NOTE! We MUST NOT take any locks for this case. We may
+       * be in an interrupt or a critical region, and should
+       * only copy the information from the master page table,
+       * nothing more.
+       */
+       if (unlikely(address >= VMALLOC_START && address <= VMALLOC_END))
+               goto vmalloc_fault;
+#ifdef MODULE_START
+       if (unlikely(address >= MODULE_START && address < MODULE_END))
+               goto vmalloc_fault;
+#endif
+
+       /*
+       * If we're in an interrupt or have no user
+       * context, we must not take the fault..
+       */
+       if (in_atomic() || !mm)
+               goto bad_area_nosemaphore;
+
+       down_read(&mm->mmap_sem);
+       vma = find_vma(mm, address);
+       if (!vma)
+               goto bad_area;
+       if (vma->vm_start <= address)
+               goto good_area;
+       if (!(vma->vm_flags & VM_GROWSDOWN))
+               goto bad_area;
+       if (expand_stack(vma, address))
+               goto bad_area;
+       /*
+       * Ok, we have a good vm_area for this memory access, so
+       * we can handle it..
+        */
+good_area:
+       info.si_code = SEGV_ACCERR;
+
+       if (write) {
+               if (!(vma->vm_flags & VM_WRITE))
+                       goto bad_area;
+       } else {
+               if (!(vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC)))
+                       goto bad_area;
+       }
+
+survive:
+       /*
+       * If for any reason at all we couldn't handle the fault,
+       * make sure we exit gracefully rather than endlessly redo
+       * the fault.
+       */
+       fault = handle_mm_fault(mm, vma, address, write);
+       if (unlikely(fault & VM_FAULT_ERROR)) {
+               if (fault & VM_FAULT_OOM)
+                       goto out_of_memory;
+               else if (fault & VM_FAULT_SIGBUS)
+                       goto do_sigbus;
+               BUG();
+       }
+       if (fault & VM_FAULT_MAJOR)
+               tsk->maj_flt++;
+       else
+               tsk->min_flt++;
+
+       up_read(&mm->mmap_sem);
+       return;
+
+       /*
+       * Something tried to access memory that isn't in our memory map..
+       * Fix it, but check if it's kernel or user first..
+        */
+bad_area:
+       up_read(&mm->mmap_sem);
+
+bad_area_nosemaphore:
+       /* User mode accesses just cause a SIGSEGV */
+       if (user_mode(regs)) {
+               tsk->thread.cp0_badvaddr = address;
+               tsk->thread.error_code = write;
+               info.si_signo = SIGSEGV;
+               info.si_errno = 0;
+               /* info.si_code has been set above */
+               info.si_addr = (void __user *) address;
+               force_sig_info(SIGSEGV, &info, tsk);
+               return;
+       }
+
+no_context:
+       /* Are we prepared to handle this kernel fault? */
+       if (fixup_exception(regs)) {
+               current->thread.cp0_baduaddr = address;
+               return;
+       }
+
+       /*
+       * Oops. The kernel tried to access some bad page. We'll have to
+       * terminate things with extreme prejudice.
+       */
+       bust_spinlocks(1);
+
+       printk(KERN_ALERT "CPU %d Unable to handle kernel paging request 
at "
+                       "virtual address %0*lx, epc == %0*lx, ra == 
%0*lx\n",
+                       0, field, address, field, regs->cp0_epc,
+                       field, regs->regs[3]);
+       die("Oops", regs);
+
+       /*
+       * We ran out of memory, or some other thing happened to us that 
made
+       * us unable to handle the page fault gracefully.
+       */
+out_of_memory:
+       up_read(&mm->mmap_sem);
+       if (is_global_init(tsk)) {
+               yield();
+               down_read(&mm->mmap_sem);
+               goto survive;
+       }
+       printk("VM: killing process %s\n", tsk->comm);
+       if (user_mode(regs))
+               do_group_exit(SIGKILL);
+       goto no_context;
+
+do_sigbus:
+       up_read(&mm->mmap_sem);
+       /* Kernel mode? Handle exceptions or die */
+       if (!user_mode(regs))
+               goto no_context;
+       else
+       /*
+       * Send a sigbus, regardless of whether we were in kernel
+       * or user mode.
+       */
+       tsk->thread.cp0_badvaddr = address;
+       info.si_signo = SIGBUS;
+       info.si_errno = 0;
+       info.si_code = BUS_ADRERR;
+       info.si_addr = (void __user *) address;
+       force_sig_info(SIGBUS, &info, tsk);
+       return;
+vmalloc_fault:
+       {
+               /*
+               * Synchronize this task's top level page-table
+               * with the 'reference' page table.
+               *
+               * Do _not_ use "tsk" here. We might be inside
+               * an interrupt in the middle of a task switch..
+               */
+               int offset = __pgd_offset(address);
+               pgd_t *pgd, *pgd_k;
+               pud_t *pud, *pud_k;
+               pmd_t *pmd, *pmd_k;
+               pte_t *pte_k;
+
+               pgd = (pgd_t *) pgd_current + offset;
+               pgd_k = init_mm.pgd + offset;
+
+               if (!pgd_present(*pgd_k))
+                       goto no_context;
+               set_pgd(pgd, *pgd_k);
+
+               pud = pud_offset(pgd, address);
+               pud_k = pud_offset(pgd_k, address);
+               if (!pud_present(*pud_k))
+                       goto no_context;
+
+               pmd = pmd_offset(pud, address);
+               pmd_k = pmd_offset(pud_k, address);
+               if (!pmd_present(*pmd_k))
+                       goto no_context;
+               set_pmd(pmd, *pmd_k);
+
+               pte_k = pte_offset_kernel(pmd_k, address);
+               if (!pte_present(*pte_k))
+                       goto no_context;
+               return;
+       }
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/init.c 
linux-2.6-git.new/arch/score/mm/init.c
--- linux-2.6-git.ori/arch/score/mm/init.c      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/init.c      2009-04-08 
10:31:13.000000000 +0800
@@ -0,0 +1,177 @@
+/*
+ * arch/score/mm/init.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/pagemap.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/bootmem.h>
+#include <linux/proc_fs.h>
+#include <linux/pfn.h>
+#include <asm/asm-offsets.h>
+#include <asm/sections.h>
+#include <asm/pgtable.h>
+#include <asm/tlb.h>
+
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
+
+/*
+ * We have up to 8 empty zeroed pages so we can map one of the right 
colour
+ * when needed.
+ */
+unsigned long zero_page_mask;
+unsigned long empty_zero_page;
+EXPORT_SYMBOL_GPL(empty_zero_page);
+
+static struct kcore_list kcore_mem, kcore_vmalloc;
+
+unsigned long setup_zero_pages(void)
+{
+       unsigned int order = 0;
+       unsigned long size;
+       struct page *page;
+
+       empty_zero_page = __get_free_pages(GFP_KERNEL | __GFP_ZERO, 
order);
+       if (!empty_zero_page)
+               panic("Oh boy, that early out of memory?");
+
+       page = virt_to_page((void *) empty_zero_page);
+       split_page(page, order);
+       while (page < virt_to_page((void *) (empty_zero_page +
+                                            (PAGE_SIZE << order)))) {
+               SetPageReserved(page);
+               page++;
+       }
+
+       size = PAGE_SIZE << order;
+       zero_page_mask = (size - 1) & PAGE_MASK;
+
+       return 1UL << order;
+}
+
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+static int __init page_is_ram(unsigned long pagenr)
+{
+       if (pagenr >= min_low_pfn && pagenr < max_low_pfn)
+               return 1;
+       else
+               return 0;
+}
+
+void __init paging_init(void)
+{
+       unsigned long max_zone_pfns[MAX_NR_ZONES];
+       unsigned long lastpfn;
+
+       pagetable_init();
+       max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+       lastpfn = max_low_pfn;
+       free_area_init_nodes(max_zone_pfns);
+}
+
+void __init mem_init(void)
+{
+       unsigned long codesize, reservedpages, datasize, initsize;
+       unsigned long tmp, ram;
+
+       max_mapnr = max_low_pfn;
+       high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
+       totalram_pages += free_all_bootmem();
+       totalram_pages -= setup_zero_pages();   /* Setup zeroed pages. */
+       reservedpages = ram = 0;
+
+       for (tmp = 0; tmp < max_low_pfn; tmp++)
+               if (page_is_ram(tmp)) {
+                       ram++;
+                       if (PageReserved(pfn_to_page(tmp)))
+                               reservedpages++;
+               }
+
+       num_physpages = ram;
+       codesize = (unsigned long) &_etext - (unsigned long) &_text;
+       datasize = (unsigned long) &_edata - (unsigned long) &_etext;
+       initsize = (unsigned long) &__init_end - (unsigned long) 
&__init_begin;
+
+       kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT);
+       kclist_add(&kcore_vmalloc, (void *) VMALLOC_START,
+                       VMALLOC_END - VMALLOC_START);
+
+       printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
+                       "%ldk reserved, %ldk data, %ldk init, %ldk 
highmem)\n",
+                       (unsigned long) nr_free_pages() << 
(PAGE_SHIFT-10),
+                       ram << (PAGE_SHIFT-10), codesize >> 10,
+                       reservedpages << (PAGE_SHIFT-10), datasize >> 10,
+                       initsize >> 10,
+                       (unsigned long) (totalhigh_pages << 
(PAGE_SHIFT-10)));
+}
+#endif /* !CONFIG_NEED_MULTIPLE_NODES */
+
+void free_init_pages(const char *what, unsigned long begin, unsigned long 
end)
+{
+       unsigned long pfn;
+
+       for (pfn = PFN_UP(begin); pfn < PFN_DOWN(end); pfn++) {
+               struct page *page = pfn_to_page(pfn);
+               void *addr = phys_to_virt(PFN_PHYS(pfn));
+
+               ClearPageReserved(page);
+               init_page_count(page);
+               memset(addr, POISON_FREE_INITMEM, PAGE_SIZE);
+               __free_page(page);
+               totalram_pages++;
+       }
+       printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) 
>> 10);
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+       free_init_pages("initrd memory",
+       virt_to_phys((void *) start),
+       virt_to_phys((void *) end));
+}
+#endif
+
+void __init_refok free_initmem(void)
+{
+       free_init_pages("unused kernel memory",
+       __pa_symbol(&__init_begin),
+       __pa_symbol(&__init_end));
+}
+
+unsigned long pgd_current;
+
+#define __page_aligned(order) 
__attribute__((__aligned__(PAGE_SIZE<<order)))
+
+/*
+ * gcc 3.3 and older have trouble determining that PTRS_PER_PGD and 
PGD_ORDER
+ * are constants.  So we use the variants from asm-offset.h until that 
gcc
+ * will officially be retired.
+ */
+pgd_t swapper_pg_dir[_PTRS_PER_PGD] __page_aligned(_PGD_ORDER);
+pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned(PTE_ORDER);
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/ioremap.c 
linux-2.6-git.new/arch/score/mm/ioremap.c
--- linux-2.6-git.ori/arch/score/mm/ioremap.c   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/ioremap.c   2009-04-03 
09:57:10.000000000 +0800
@@ -0,0 +1,55 @@
+/*
+ * arch/score/mm/ioremap.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/vmalloc.h>
+#include <asm/io.h>
+#include <asm/fixmap.h>
+
+/*
+ * Remap an arbitrary physical address space into the kernel virtual
+ * address space. Needed when the kernel wants to access high addresses
+ * directly.
+ *
+ * NOTE! We need to allow non-page-aligned mappings too: we will 
obviously
+ * have to convert them into an offset in a page-aligned mapping, but the
+ * caller shouldn't need to know that small detail.
+ */
+void __iomem *__ioremap(unsigned long phys_addr, unsigned long size, 
unsigned long flags)
+{
+       if ((phys_addr > PHY_IO_BASE) &&
+           (phys_addr < (PHY_IO_BASE + IO_SPACE_SIZE)))
+               return (void *) (VIRTUAL_IO_BASE + phys_addr - 
PHY_IO_BASE);
+       else
+               return NULL;
+}
+EXPORT_SYMBOL(__ioremap);
+
+void __iounmap(const volatile void __iomem *addr)
+{
+       return;
+}
+EXPORT_SYMBOL(__iounmap);
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/Makefile 
linux-2.6-git.new/arch/score/mm/Makefile
--- linux-2.6-git.ori/arch/score/mm/Makefile    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/Makefile    2009-03-24 
08:59:19.000000000 +0800
@@ -0,0 +1,10 @@
+#
+# Makefile for the Linux/SCORE-specific parts of the memory manager.
+#
+
+obj-y  += cache.o dma-default.o extable.o fault.o init.o \
+           tlb-miss.o tlb-score.o ioremap.o pgtable.o
+
+obj-$(CONFIG_HIGHMEM)  += highmem.o
+
+EXTRA_CFLAGS +=
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/pgtable.c 
linux-2.6-git.new/arch/score/mm/pgtable.c
--- linux-2.6-git.ori/arch/score/mm/pgtable.c   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/pgtable.c   2009-03-23 
14:31:51.000000000 +0800
@@ -0,0 +1,61 @@
+/*
+ * arch/score/mm/pgtable-32.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/bootmem.h>
+#include <asm/fixmap.h>
+#include <asm/pgtable.h>
+
+void pgd_init(unsigned long page)
+{
+       unsigned long *p = (unsigned long *) page;
+       int i;
+
+       for (i = 0; i < USER_PTRS_PER_PGD; i += 8) {
+               p[i + 0] = (unsigned long) invalid_pte_table;
+               p[i + 1] = (unsigned long) invalid_pte_table;
+               p[i + 2] = (unsigned long) invalid_pte_table;
+               p[i + 3] = (unsigned long) invalid_pte_table;
+               p[i + 4] = (unsigned long) invalid_pte_table;
+               p[i + 5] = (unsigned long) invalid_pte_table;
+               p[i + 6] = (unsigned long) invalid_pte_table;
+               p[i + 7] = (unsigned long) invalid_pte_table;
+       }
+}
+
+void __init pagetable_init(void)
+{
+       unsigned long vaddr;
+       pgd_t *pgd_base;
+
+       /* Initialize the entire pgd. */
+       pgd_init((unsigned long) swapper_pg_dir);
+       pgd_init((unsigned long) swapper_pg_dir
+               + sizeof(pgd_t) * USER_PTRS_PER_PGD);
+
+       pgd_base = swapper_pg_dir;
+       vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/tlb-miss.S 
linux-2.6-git.new/arch/score/mm/tlb-miss.S
--- linux-2.6-git.ori/arch/score/mm/tlb-miss.S  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/tlb-miss.S  2009-04-07 
21:34:54.000000000 +0800
@@ -0,0 +1,205 @@
+/*
+ * arch/score/mm/tlbex.S
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <asm/scoreregs.h>
+#include <asm/page.h>
+#include <asm/pgtable-bits.h>
+#include <asm/asm.h>
+
+/*
+* After this macro runs, the pte faulted on is
+* in register PTE, a ptr into the table in which
+* the pte belongs is in PTR.
+*/
+       .macro  load_pte, pte, ptr
+       la      \ptr, pgd_current
+       lw      \ptr, [\ptr, 0]
+       mfcr    \pte, cr6
+       srli    \pte, \pte, 22
+       slli    \pte, \pte, 2
+       add     \ptr, \ptr, \pte
+       lw      \ptr, [\ptr, 0]
+       mfcr    \pte, cr6
+       srli    \pte, \pte, 10
+       andi    \pte, 0xffc
+       add     \ptr, \ptr, \pte
+       lw      \pte, [\ptr, 0]
+       .endm
+
+       .macro  pte_reload, ptr
+       lw      \ptr, [\ptr, 0]
+       mtcr    \ptr, cr12
+       nop
+       nop
+       nop
+       nop
+       nop
+       .endm
+
+       .macro do_fault, write
+       SAVE_ALL
+       mfcr    r6, cr6
+       mv      r4, r0
+       ldi     r5, \write
+       la      r8, do_page_fault
+       brl     r8
+       j       ret_from_exception
+       .endm
+
+       .macro  pte_writable, pte, ptr, label
+       andi    \pte, 0x280
+       cmpi.c  \pte, 0x280
+       bne     \label
+       lw      \pte, [\ptr, 0]         /*reload PTE*/
+       .endm
+
+/*
+ * Make PTE writable, update software status bits as well,
+ * then store at PTR.
+ */
+       .macro  pte_makewrite, pte, ptr
+       ori     \pte, 0x426
+       sw      \pte, [\ptr, 0]
+       .endm
+
+       .text
+       .globl  score7_FTLB_refill_Handler
+score7_FTLB_refill_Handler:
+       la      r31, pgd_current        /* get pgd pointer */
+       lw      r31, [r31, 0]           /* get the address of PGD */
+       mfcr    r30, cr6
+       srli    r30, r30, 22            /* PGDIR_SHIFT = 22*/
+       slli    r30, r30, 2
+       add     r31, r31, r30
+       lw      r31, [r31, 0]           /* get the address of the start 
address of PTE table */
+
+       mfcr    r30, cr9
+       andi    r30, 0xfff              /* equivalent to get PET index and 
right shift 2 bits */
+       add     r31, r31, r30
+       lw      r30, [r31, 0]           /* load pte entry */
+       mtcr    r30, cr12
+       nop
+       nop
+       nop
+       nop
+       nop
+       mtrtlb
+       nop
+       nop
+       nop
+       nop
+       nop
+       rte                             /* 6 cycles to make sure tlb entry 
works */
+
+       .globl  score7_KSEG_refill_Handler
+score7_KSEG_refill_Handler:
+       la      r31, pgd_current        /* get pgd pointer */
+       lw      r31, [r31, 0]           /* get the address of PGD */
+       mfcr    r30, cr6
+       srli    r30, r30, 22            /* PGDIR_SHIFT = 22 */
+       slli    r30, r30, 2
+       add     r31, r31, r30
+       lw      r31, [r31, 0]           /* get the address of the start 
address of PTE table */
+
+       mfcr    r30, cr6                /* get Bad VPN */
+       srli    r30, r30, 10
+       andi    r30, 0xffc              /* PTE VPN mask (bit 11~2) */
+
+       add     r31, r31, r30
+       lw      r30, [r31, 0]           /* load pte entry */
+       mtcr    r30, cr12
+       nop
+       nop
+       nop
+       nop
+       nop
+       mtrtlb
+       nop
+       nop
+       nop
+       nop
+       nop
+       rte                             /* 6 cycles to make sure tlb entry 
works */
+
+nopage_tlbl:
+       do_fault        0               /* Read */
+
+       .globl  handle_tlb_refill
+handle_tlb_refill:
+       load_pte        r30, r31
+       pte_writable    r30, r31, handle_tlb_refill_nopage
+       pte_makewrite   r30, r31        /* Access|Modify|Dirty|Valid */
+       pte_reload      r31
+       mtrtlb
+       nop
+       nop
+       nop
+       nop
+       nop
+       rte
+handle_tlb_refill_nopage:
+       do_fault        0               /* Read */
+
+       .globl  handle_tlb_invaild
+handle_tlb_invaild:
+       load_pte        r30, r31
+       stlb                            /* find faulting entry */
+       pte_writable    r30, r31, handle_tlb_invaild_nopage
+       pte_makewrite   r30, r31        /* Access|Modify|Dirty|Valid */
+       pte_reload      r31
+       mtptlb
+       nop
+       nop
+       nop
+       nop
+       nop
+       rte
+handle_tlb_invaild_nopage:
+       do_fault        0               /* Read */
+
+       .globl  handle_mod
+handle_mod:
+       load_pte        r30, r31
+       stlb                            /* find faulting entry */
+       andi    r30, _PAGE_WRITE        /* Writable? */
+       cmpz.c  r30
+       beq     nowrite_mod
+       lw      r30, [r31, 0]           /* reload into r30 */
+
+       /* Present and writable bits set, set accessed and dirty bits. */
+       pte_makewrite   r30, r31
+
+       /* Now reload the entry into the tlb. */
+       pte_reload      r31
+       mtptlb
+       nop
+       nop
+       nop
+       nop
+       nop
+       rte
+
+nowrite_mod:
+       do_fault        1       /* Write */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/tlb-score.c 
linux-2.6-git.new/arch/score/mm/tlb-score.c
--- linux-2.6-git.ori/arch/score/mm/tlb-score.c 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/tlb-score.c 2009-04-07 
21:50:37.000000000 +0800
@@ -0,0 +1,249 @@
+/*
+ * arch/score/mm/tlb-score.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/highmem.h>
+#include <asm/irq.h>
+#include <asm/mmu_context.h>
+#include <asm/pgtable.h>
+#include <asm/tlb.h>
+
+#define TLBSIZE 32
+
+unsigned long asid_cache = ASID_FIRST_VERSION;
+EXPORT_SYMBOL(asid_cache);
+
+void local_flush_tlb_all(void)
+{
+       unsigned long flags;
+       unsigned long old_ASID;
+       int entry;
+
+       local_irq_save(flags);
+       old_ASID = (get_PEVN() & ASID_MASK);
+       set_PECTX(0);                   /* invalid */
+       entry = get_TLBLOCK();          /* skip locked entries*/
+
+       for (; entry < TLBSIZE; entry++) {
+               set_TLBPT(entry);
+               set_PEVN(KSEG1);
+               barrier();
+               tlb_write_indexed();
+       }
+       set_PEVN(old_ASID);
+       local_irq_restore(flags);
+}
+
+/*
+ * If mm is currently active_mm, we can't really drop it. Instead,
+ * we will get a new one for it.
+ */
+static inline void
+drop_mmu_context(struct mm_struct *mm, unsigned cpu)
+{
+       unsigned long flags;
+
+       local_irq_save(flags);
+       get_new_mmu_context(mm, 0);
+       set_PEVN(cpu_asid(0, mm));
+       local_irq_restore(flags);
+}
+
+void local_flush_tlb_mm(struct mm_struct *mm)
+{
+       if (cpu_context(0, mm) != 0)
+               drop_mmu_context(mm, 0);
+}
+
+void local_flush_tlb_range(struct vm_area_struct *vma, unsigned long 
start,
+       unsigned long end)
+{
+       struct mm_struct *mm = vma->vm_mm;
+       unsigned long vma_mm_context = mm->context[0];
+       if (mm->context != 0) {
+               unsigned long flags;
+               int size;
+
+               local_irq_save(flags);
+               size = (end - start + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
+               if (size <= TLBSIZE) {
+                       int oldpid = (get_PEVN() & ASID_MASK);
+                       int newpid = vma_mm_context & ASID_MASK;
+
+                       start &= PAGE_MASK;
+                       end += (PAGE_SIZE - 1);
+                       end &= PAGE_MASK;
+                       while (start < end) {
+                               int idx;
+
+                               set_PEVN(start | newpid);
+                               start += PAGE_SIZE;
+                               barrier();
+                               tlb_probe();
+                               idx = get_TLBPT();
+                               set_PECTX(0);
+                               set_PEVN(KSEG1);
+                               if (idx < 0)
+                                       continue;
+                               tlb_write_indexed();
+                       }
+                       set_PEVN(oldpid);
+               } else {
+                       /* Bigger than TLBSIZE, get new ASID directly */
+                       get_new_mmu_context(mm, 0);
+                       if (mm == current->active_mm)
+                               set_PEVN(vma_mm_context & ASID_MASK);
+               }
+               local_irq_restore(flags);
+       }
+}
+
+void local_flush_tlb_kernel_range(unsigned long start, unsigned long end)
+{
+       unsigned long flags;
+       int size;
+
+       local_irq_save(flags);
+       size = (end - start + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
+       if (size <= TLBSIZE) {
+               int pid = get_PEVN();
+
+               start &= PAGE_MASK;
+               end += PAGE_SIZE - 1;
+               end &= PAGE_MASK;
+
+               while (start < end) {
+                       long idx;
+
+                       set_PEVN(start);
+                       start += PAGE_SIZE;
+                       tlb_probe();
+                       idx = get_TLBPT();
+                       if (idx < 0)
+                               continue;
+                       set_PECTX(0);
+                       set_PEVN(KSEG1);
+                       barrier();
+                       tlb_write_indexed();
+               }
+               set_PEVN(pid);
+       } else {
+               local_flush_tlb_all();
+       }
+
+       local_irq_restore(flags);
+}
+
+void local_flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
+{
+       if (!vma || vma->vm_mm->context != 0) {
+               unsigned long flags;
+               int oldpid, newpid, idx;
+               unsigned long vma_ASID = vma->vm_mm->context[0];
+
+               newpid = (vma_ASID & ASID_MASK);
+               page &= PAGE_MASK;
+               local_irq_save(flags);
+               oldpid = (get_PEVN() & ASID_MASK);
+               set_PEVN(page | newpid);
+               barrier();
+               tlb_probe();
+               idx = get_TLBPT();
+               set_PECTX(0);
+               set_PEVN(KSEG1);
+               if (idx < 0)            /* p_bit(31) - 1: miss, 0: hit*/
+                       goto finish;
+               barrier();
+               tlb_write_indexed();
+finish:
+               set_PEVN(oldpid);
+               local_irq_restore(flags);
+       }
+}
+
+/*
+ * This one is only used for pages with the global bit set so we don't 
care
+ * much about the ASID.
+ */
+void local_flush_tlb_one(unsigned long page)
+{
+       unsigned long flags;
+       int oldpid, idx;
+
+       local_irq_save(flags);
+       oldpid = get_PEVN();
+       page &= (PAGE_MASK << 1);
+       set_PEVN(page);
+       barrier();
+       tlb_probe();
+       idx = get_TLBPT();
+       set_PECTX(0);
+       if (idx >= 0) {
+               /* Make sure all entries differ. */
+               set_PEVN(KSEG1);
+               barrier();
+               tlb_write_indexed();
+       }
+       set_PEVN(oldpid);
+       local_irq_restore(flags);
+}
+
+void __update_tlb(struct vm_area_struct *vma, unsigned long address, 
pte_t pte)
+{
+       unsigned long flags;
+       int idx, pid;
+
+       /*
+        * Handle debugger faulting in for debugee.
+        */
+       if (current->active_mm != vma->vm_mm)
+               return;
+
+       pid = get_PEVN() & ASID_MASK;
+
+       local_irq_save(flags);
+       address &= PAGE_MASK;
+       set_PEVN(address | pid);
+       barrier();
+       tlb_probe();
+       idx = get_TLBPT();
+       set_PECTX(pte_val(pte));
+       set_PEVN(address | pid);
+       if (idx < 0)
+               tlb_write_random();
+       else
+               tlb_write_indexed();
+
+       set_PEVN(pid);
+       local_irq_restore(flags);
+}
+
+void __cpuinit tlb_init(void)
+{
+       set_TLBLOCK(0);
+       local_flush_tlb_all();
+       memcpy((void *)(EXCEPTION_VECTOR_BASE_ADDR + 0x100), 
&score7_FTLB_refill_Handler, 0xFC);
+       flush_icache_range(EXCEPTION_VECTOR_BASE_ADDR + 0x100, 
EXCEPTION_VECTOR_BASE_ADDR + 0x1FC);
+}

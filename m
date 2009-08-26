Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbZHZGso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbZHZGso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756900AbZHZGsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:48:43 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:38707
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756820AbZHZGsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:48:41 -0400
Subject: Subject: [PATCH 31/33] score: create mm/ files init.c cache.c
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:37:59 +0800
Message-Id: <1251268679.3293.2.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 75ba37513ce4b842c11c1d67dd8b32dd61ef240d Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:12 +0800
Subject: [PATCH 31/33] score: create mm/ files init.c cache.c


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/mm/cache.c |  257 +++++++++++++++++++++++++++++++++++++++++++++++++
 arch/score/mm/init.c  |  161 +++++++++++++++++++++++++++++++
 2 files changed, 418 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/mm/cache.c
 create mode 100644 arch/score/mm/init.c

diff --git a/arch/score/mm/cache.c b/arch/score/mm/cache.c
new file mode 100644
index 0000000..dbac9d9
--- /dev/null
+++ b/arch/score/mm/cache.c
@@ -0,0 +1,257 @@
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
+#include <linux/linkage.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+
+#include <asm/mmu_context.h>
+
+/*
+Just flush entire Dcache!!
+You must ensure the page doesn't include instructions, because
+the function will not flush the Icache.
+The addr must be cache aligned.
+*/
+static void flush_data_cache_page(unsigned long addr)
+{
+	unsigned int i;
+	for (i = 0; i < (PAGE_SIZE / L1_CACHE_BYTES); i += L1_CACHE_BYTES) {
+		__asm__ __volatile__(
+		"cache 0x0e, [%0, 0]\n"
+		"cache 0x1a, [%0, 0]\n"
+		"nop\n"
+		: : "r" (addr));
+		addr += L1_CACHE_BYTES;
+	}
+}
+
+/* called by update_mmu_cache. */
+void __update_cache(struct vm_area_struct *vma, unsigned long address,
+		pte_t pte)
+{
+	struct page *page;
+	unsigned long pfn, addr;
+	int exec = (vma->vm_flags & VM_EXEC);
+
+	pfn = pte_pfn(pte);
+	if (unlikely(!pfn_valid(pfn)))
+		return;
+	page = pfn_to_page(pfn);
+	if (page_mapping(page) && test_bit(PG_arch_1, &page->flags)) {
+		addr = (unsigned long) page_address(page);
+		if (exec)
+			flush_data_cache_page(addr);
+		clear_bit(PG_arch_1, &page->flags);
+	}
+}
+
+static inline void setup_protection_map(void)
+{
+	protection_map[0] = PAGE_NONE;
+	protection_map[1] = PAGE_READONLY;
+	protection_map[2] = PAGE_COPY;
+	protection_map[3] = PAGE_COPY;
+	protection_map[4] = PAGE_READONLY;
+	protection_map[5] = PAGE_READONLY;
+	protection_map[6] = PAGE_COPY;
+	protection_map[7] = PAGE_COPY;
+	protection_map[8] = PAGE_NONE;
+	protection_map[9] = PAGE_READONLY;
+	protection_map[10] = PAGE_SHARED;
+	protection_map[11] = PAGE_SHARED;
+	protection_map[12] = PAGE_READONLY;
+	protection_map[13] = PAGE_READONLY;
+	protection_map[14] = PAGE_SHARED;
+	protection_map[15] = PAGE_SHARED;
+}
+
+void __devinit cpu_cache_init(void)
+{
+	setup_protection_map();
+}
+
+void flush_icache_all(void)
+{
+	__asm__ __volatile__(
+	"la r8, flush_icache_all\n"
+	"cache 0x10, [r8, 0]\n"
+	"nop\nnop\nnop\nnop\nnop\nnop\n"
+	: : : "r8");
+}
+
+void flush_dcache_all(void)
+{
+	__asm__ __volatile__(
+	"la r8, flush_dcache_all\n"
+	"cache 0x1f, [r8, 0]\n"
+	"nop\nnop\nnop\nnop\nnop\nnop\n"
+	"cache 0x1a, [r8, 0]\n"
+	"nop\nnop\nnop\nnop\nnop\nnop\n"
+	: : : "r8");
+}
+
+void flush_cache_all(void)
+{
+	__asm__ __volatile__(
+	"la r8, flush_cache_all\n"
+	"cache 0x10, [r8, 0]\n"
+	"nop\nnop\nnop\nnop\nnop\nnop\n"
+	"cache 0x1f, [r8, 0]\n"
+	"nop\nnop\nnop\nnop\nnop\nnop\n"
+	"cache 0x1a, [r8, 0]\n"
+	"nop\nnop\nnop\nnop\nnop\nnop\n"
+	: : : "r8");
+}
+
+void flush_cache_mm(struct mm_struct *mm)
+{
+	if (!(mm->context))
+		return;
+	flush_cache_all();
+}
+
+/*if we flush a range precisely , the processing may be very long.
+We must check each page in the range whether present. If the page is present,
+we can flush the range in the page. Be careful, the range may be cross two
+page, a page is present and another is not present.
+*/
+/*
+The interface is provided in hopes that the port can find
+a suitably efficient method for removing multiple page
+sized regions from the cache.
+*/
+void flush_cache_range(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int exec = vma->vm_flags & VM_EXEC;
+	pgd_t *pgdp;
+	pud_t *pudp;
+	pmd_t *pmdp;
+	pte_t *ptep;
+
+	if (!(mm->context))
+		return;
+
+	pgdp = pgd_offset(mm, start);
+	pudp = pud_offset(pgdp, start);
+	pmdp = pmd_offset(pudp, start);
+	ptep = pte_offset(pmdp, start);
+
+	while (start <= end) {
+		unsigned long tmpend;
+		pgdp = pgd_offset(mm, start);
+		pudp = pud_offset(pgdp, start);
+		pmdp = pmd_offset(pudp, start);
+		ptep = pte_offset(pmdp, start);
+
+		if (!(pte_val(*ptep) & _PAGE_PRESENT)) {
+			start = (start + PAGE_SIZE) & ~(PAGE_SIZE - 1);
+			continue;
+		}
+		tmpend = (start | (PAGE_SIZE-1)) > end ?
+				 end : (start | (PAGE_SIZE-1));
+
+		flush_dcache_range(start, tmpend);
+		if (exec)
+			flush_icache_range(start, tmpend);
+		start = (start + PAGE_SIZE) & ~(PAGE_SIZE - 1);
+	}
+}
+
+void flush_cache_page(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn)
+{
+	int exec = vma->vm_flags & VM_EXEC;
+	unsigned long kaddr = 0xa0000000 | (pfn << PAGE_SHIFT);
+
+	flush_dcache_range(kaddr, kaddr + PAGE_SIZE);
+
+	if (exec)
+		flush_icache_range(kaddr, kaddr + PAGE_SIZE);
+}
+
+void flush_cache_sigtramp(unsigned long addr)
+{
+	__asm__ __volatile__(
+	"cache 0x02, [%0, 0]\n"
+	"nop\nnop\nnop\nnop\nnop\n"
+	"cache 0x02, [%0, 0x4]\n"
+	"nop\nnop\nnop\nnop\nnop\n"
+
+	"cache 0x0d, [%0, 0]\n"
+	"nop\nnop\nnop\nnop\nnop\n"
+	"cache 0x0d, [%0, 0x4]\n"
+	"nop\nnop\nnop\nnop\nnop\n"
+
+	"cache 0x1a, [%0, 0]\n"
+	"nop\nnop\nnop\nnop\nnop\n"
+	: : "r" (addr));
+}
+
+/*
+1. WB and invalid a cache line of Dcache
+2. Drain Write Buffer
+the range must be smaller than PAGE_SIZE
+*/
+void flush_dcache_range(unsigned long start, unsigned long end)
+{
+	int size, i;
+
+	start = start & ~(L1_CACHE_BYTES - 1);
+	end = end & ~(L1_CACHE_BYTES - 1);
+	size = end - start;
+	/* flush dcache to ram, and invalidate dcache lines. */
+	for (i = 0; i < size; i += L1_CACHE_BYTES) {
+		__asm__ __volatile__(
+		"cache 0x0e, [%0, 0]\n"
+		"nop\nnop\nnop\nnop\nnop\n"
+		"cache 0x1a, [%0, 0]\n"
+		"nop\nnop\nnop\nnop\nnop\n"
+		: : "r" (start));
+		start += L1_CACHE_BYTES;
+	}
+}
+
+void flush_icache_range(unsigned long start, unsigned long end)
+{
+	int size, i;
+	start = start & ~(L1_CACHE_BYTES - 1);
+	end = end & ~(L1_CACHE_BYTES - 1);
+
+	size = end - start;
+	/* invalidate icache lines. */
+	for (i = 0; i < size; i += L1_CACHE_BYTES) {
+		__asm__ __volatile__(
+		"cache 0x02, [%0, 0]\n"
+		"nop\nnop\nnop\nnop\nnop\n"
+		: : "r" (start));
+		start += L1_CACHE_BYTES;
+	}
+}
diff --git a/arch/score/mm/init.c b/arch/score/mm/init.c
new file mode 100644
index 0000000..4e3dcd0
--- /dev/null
+++ b/arch/score/mm/init.c
@@ -0,0 +1,161 @@
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
+#include <linux/errno.h>
+#include <linux/bootmem.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/pagemap.h>
+#include <linux/proc_fs.h>
+#include <linux/sched.h>
+#include <linux/initrd.h>
+
+#include <asm/sections.h>
+#include <asm/tlb.h>
+
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
+
+unsigned long empty_zero_page;
+EXPORT_SYMBOL_GPL(empty_zero_page);
+
+static struct kcore_list kcore_mem, kcore_vmalloc;
+
+static unsigned long setup_zero_page(void)
+{
+	struct page *page;
+
+	empty_zero_page = __get_free_pages(GFP_KERNEL | __GFP_ZERO, 0);
+	if (!empty_zero_page)
+		panic("Oh boy, that early out of memory?");
+
+	page = virt_to_page((void *) empty_zero_page);
+	SetPageReserved(page);
+
+	return 1UL;
+}
+
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+static int __init page_is_ram(unsigned long pagenr)
+{
+	if (pagenr >= min_low_pfn && pagenr < max_low_pfn)
+		return 1;
+	else
+		return 0;
+}
+
+void __init paging_init(void)
+{
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
+	unsigned long lastpfn;
+
+	pagetable_init();
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+	lastpfn = max_low_pfn;
+	free_area_init_nodes(max_zone_pfns);
+}
+
+void __init mem_init(void)
+{
+	unsigned long codesize, reservedpages, datasize, initsize;
+	unsigned long tmp, ram = 0;
+
+	max_mapnr = max_low_pfn;
+	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
+	totalram_pages += free_all_bootmem();
+	totalram_pages -= setup_zero_page();	/* Setup zeroed pages. */
+	reservedpages = 0;
+
+	for (tmp = 0; tmp < max_low_pfn; tmp++)
+		if (page_is_ram(tmp)) {
+			ram++;
+			if (PageReserved(pfn_to_page(tmp)))
+				reservedpages++;
+		}
+
+	num_physpages = ram;
+	codesize = (unsigned long) &_etext - (unsigned long) &_text;
+	datasize = (unsigned long) &_edata - (unsigned long) &_etext;
+	initsize = (unsigned long) &__init_end - (unsigned long) &__init_begin;
+
+	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT);
+	kclist_add(&kcore_vmalloc, (void *) VMALLOC_START,
+			VMALLOC_END - VMALLOC_START);
+
+	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
+			"%ldk reserved, %ldk data, %ldk init, %ldk highmem)\n",
+			(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+			ram << (PAGE_SHIFT-10), codesize >> 10,
+			reservedpages << (PAGE_SHIFT-10), datasize >> 10,
+			initsize >> 10,
+			(unsigned long) (totalhigh_pages << (PAGE_SHIFT-10)));
+}
+#endif /* !CONFIG_NEED_MULTIPLE_NODES */
+
+static void free_init_pages(const char *what, unsigned long begin, unsigned long end)
+{
+	unsigned long pfn;
+
+	for (pfn = PFN_UP(begin); pfn < PFN_DOWN(end); pfn++) {
+		struct page *page = pfn_to_page(pfn);
+		void *addr = phys_to_virt(PFN_PHYS(pfn));
+
+		ClearPageReserved(page);
+		init_page_count(page);
+		memset(addr, POISON_FREE_INITMEM, PAGE_SIZE);
+		__free_page(page);
+		totalram_pages++;
+	}
+	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+	free_init_pages("initrd memory",
+		virt_to_phys((void *) start),
+		virt_to_phys((void *) end));
+}
+#endif
+
+void __init_refok free_initmem(void)
+{
+	free_init_pages("unused kernel memory",
+	__pa(&__init_begin),
+	__pa(&__init_end));
+}
+
+unsigned long pgd_current;
+
+#define __page_aligned(order) __attribute__((__aligned__(PAGE_SIZE<<order)))
+
+/*
+ * gcc 3.3 and older have trouble determining that PTRS_PER_PGD and PGD_ORDER
+ * are constants.  So we use the variants from asm-offset.h until that gcc
+ * will officially be retired.
+ */
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned(PTE_ORDER);
+pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned(PTE_ORDER);
-- 
1.6.2




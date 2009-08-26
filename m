Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZHZGaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZHZGaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZHZGaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:30:23 -0400
Received: from 60-248-182-106.HINET-IP.hinet.net ([60.248.182.106]:52747 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZHZGaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:30:21 -0400
X-Greylist: delayed 683 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 02:30:21 EDT
Subject: Subject: [PATCH 13/33] score: create head files page.h pgalloc.h
	pgtable-bits.h pgtable.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:19:55 +0800
Message-Id: <1251267595.3073.18.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 08e5eb7111fb447cbb65044e116825e53391848d Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:02 +0800
Subject: [PATCH 13/33] score: create head files page.h pgalloc.h pgtable-bits.h pgtable.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/page.h         |   92 +++++++++++
 arch/score/include/asm/pgalloc.h      |   83 ++++++++++
 arch/score/include/asm/pgtable-bits.h |   25 +++
 arch/score/include/asm/pgtable.h      |  287 +++++++++++++++++++++++++++++++++
 4 files changed, 487 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/page.h
 create mode 100644 arch/score/include/asm/pgalloc.h
 create mode 100644 arch/score/include/asm/pgtable-bits.h
 create mode 100644 arch/score/include/asm/pgtable.h

diff --git a/arch/score/include/asm/page.h b/arch/score/include/asm/page.h
new file mode 100644
index 0000000..ee58210
--- /dev/null
+++ b/arch/score/include/asm/page.h
@@ -0,0 +1,92 @@
+#ifndef _ASM_SCORE_PAGE_H
+#define _ASM_SCORE_PAGE_H
+
+#include <linux/pfn.h>
+
+/* PAGE_SHIFT determines the page size */
+#define PAGE_SHIFT	(12)
+#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#define PAGE_MASK	(~(PAGE_SIZE-1))
+
+#ifdef __KERNEL__
+
+#ifndef __ASSEMBLY__
+
+#define PAGE_UP(addr)	(((addr)+((PAGE_SIZE)-1))&(~((PAGE_SIZE)-1)))
+#define PAGE_DOWN(addr)	((addr)&(~((PAGE_SIZE)-1)))
+
+/* align addr on a size boundary - adjust address up/down if needed */
+#define _ALIGN_UP(addr, size)	(((addr)+((size)-1))&(~((size)-1)))
+#define _ALIGN_DOWN(addr, size)	((addr)&(~((size)-1)))
+
+/* align addr on a size boundary - adjust address up if needed */
+#define _ALIGN(addr, size)	_ALIGN_UP(addr, size)
+
+/*
+ * PAGE_OFFSET -- the first address of the first page of memory. When not
+ * using MMU this corresponds to the first free page in physical memory (aligned
+ * on a page boundary).
+ */
+#define PAGE_OFFSET		(0xA0000000UL)
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
+
+typedef struct { unsigned long pte; } pte_t;		/* page table entry */
+typedef struct { unsigned long pgd; } pgd_t;		/* PGD table entry */
+typedef struct { unsigned long pgprot; } pgprot_t;
+typedef struct page *pgtable_t;
+
+#define pte_val(x)	((x).pte)
+#define pgd_val(x)	((x).pgd)
+#define pgprot_val(x)	((x).pgprot)
+
+#define __pte(x)	((pte_t) { (x) })
+#define __pgd(x)	((pgd_t) { (x) })
+#define __pgprot(x)	((pgprot_t) { (x) })
+
+extern unsigned long max_low_pfn;
+extern unsigned long min_low_pfn;
+extern unsigned long max_pfn;
+
+#define __pa(x)		((unsigned long)(x) - PAGE_OFFSET)
+#define __va(x)		((void *)((unsigned long) (x) + PAGE_OFFSET))
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
+
+#define ARCH_PFN_OFFSET		(PAGE_OFFSET >> PAGE_SHIFT)
+
+#endif /* __ASSEMBLY__ */
+
+#define virt_addr_valid(vaddr)	(pfn_valid(virt_to_pfn(vaddr)))
+
+#endif /* __KERNEL__ */
+
+#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
+				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+#include <asm-generic/memory_model.h>
+#include <asm-generic/getorder.h>
+
+#endif /* _ASM_SCORE_PAGE_H */
diff --git a/arch/score/include/asm/pgalloc.h b/arch/score/include/asm/pgalloc.h
new file mode 100644
index 0000000..059a61b
--- /dev/null
+++ b/arch/score/include/asm/pgalloc.h
@@ -0,0 +1,83 @@
+#ifndef _ASM_SCORE_PGALLOC_H
+#define _ASM_SCORE_PGALLOC_H
+
+#include <linux/mm.h>
+
+static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
+	pte_t *pte)
+{
+	set_pmd(pmd, __pmd((unsigned long)pte));
+}
+
+static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
+	pgtable_t pte)
+{
+	set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
+}
+
+#define pmd_pgtable(pmd)	pmd_page(pmd)
+
+static inline pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+	pgd_t *ret, *init;
+
+	ret = (pgd_t *) __get_free_pages(GFP_KERNEL, PGD_ORDER);
+	if (ret) {
+		init = pgd_offset(&init_mm, 0UL);
+		pgd_init((unsigned long)ret);
+		memcpy(ret + USER_PTRS_PER_PGD, init + USER_PTRS_PER_PGD,
+		(PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
+	}
+
+	return ret;
+}
+
+static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	free_pages((unsigned long)pgd, PGD_ORDER);
+}
+
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
+	unsigned long address)
+{
+	pte_t *pte;
+
+	pte = (pte_t *) __get_free_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO,
+					PTE_ORDER);
+
+	return pte;
+}
+
+static inline struct page *pte_alloc_one(struct mm_struct *mm,
+	unsigned long address)
+{
+	struct page *pte;
+
+	pte = alloc_pages(GFP_KERNEL | __GFP_REPEAT, PTE_ORDER);
+	if (pte) {
+		clear_highpage(pte);
+		pgtable_page_ctor(pte);
+	}
+	return pte;
+}
+
+static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	free_pages((unsigned long)pte, PTE_ORDER);
+}
+
+static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
+{
+	pgtable_page_dtor(pte);
+	__free_pages(pte, PTE_ORDER);
+}
+
+#define __pte_free_tlb(tlb, pte, buf)			\
+do {							\
+	pgtable_page_dtor(pte);				\
+	tlb_remove_page((tlb), pte);			\
+} while (0)
+
+#define check_pgt_cache()		do {} while (0)
+
+#endif /* _ASM_SCORE_PGALLOC_H */
diff --git a/arch/score/include/asm/pgtable-bits.h b/arch/score/include/asm/pgtable-bits.h
new file mode 100644
index 0000000..7d65a96
--- /dev/null
+++ b/arch/score/include/asm/pgtable-bits.h
@@ -0,0 +1,25 @@
+#ifndef _ASM_SCORE_PGTABLE_BITS_H
+#define _ASM_SCORE_PGTABLE_BITS_H
+
+#define _PAGE_ACCESSED			(1<<5)	/* implemented in software */
+#define _PAGE_READ			(1<<6)	/* implemented in software */
+#define _PAGE_WRITE			(1<<7)	/* implemented in software */
+#define _PAGE_PRESENT			(1<<9)	/* implemented in software */
+#define _PAGE_MODIFIED			(1<<10)	/* implemented in software */
+#define _PAGE_FILE			(1<<10)
+
+#define _PAGE_GLOBAL			(1<<0)
+#define _PAGE_VALID			(1<<1)
+#define _PAGE_SILENT_READ		(1<<1)	/* synonym */
+#define _PAGE_DIRTY			(1<<2)	/* Write bit */
+#define _PAGE_SILENT_WRITE		(1<<2)
+#define _PAGE_CACHE			(1<<3)	/* cache */
+#define _CACHE_MASK			(1<<3)
+#define _PAGE_BUFFERABLE		(1<<4)	/*Fallow Spec. */
+
+#define __READABLE	(_PAGE_READ | _PAGE_SILENT_READ | _PAGE_ACCESSED)
+#define __WRITEABLE	(_PAGE_WRITE | _PAGE_SILENT_WRITE | _PAGE_MODIFIED)
+#define _PAGE_CHG_MASK			\
+	(PAGE_MASK | _PAGE_ACCESSED | _PAGE_MODIFIED | _PAGE_CACHE)
+
+#endif /* _ASM_SCORE_PGTABLE_BITS_H */
diff --git a/arch/score/include/asm/pgtable.h b/arch/score/include/asm/pgtable.h
new file mode 100644
index 0000000..674934b
--- /dev/null
+++ b/arch/score/include/asm/pgtable.h
@@ -0,0 +1,287 @@
+#ifndef _ASM_SCORE_PGTABLE_H
+#define _ASM_SCORE_PGTABLE_H
+
+#include <linux/const.h>
+#include <asm-generic/pgtable-nopmd.h>
+
+#include <asm/fixmap.h>
+#include <asm/setup.h>
+#include <asm/pgtable-bits.h>
+
+extern void load_pgd(unsigned long pg_dir);
+extern pte_t invalid_pte_table[PAGE_SIZE/sizeof(pte_t)];
+
+/* PGDIR_SHIFT determines what a third-level page table entry can map */
+#define PGDIR_SHIFT	22
+#define PGDIR_SIZE	(_AC(1, UL) << PGDIR_SHIFT)
+#define PGDIR_MASK	(~(PGDIR_SIZE - 1))
+
+/*
+ * Entries per page directory level: we use two-level, so
+ * we don't really have any PUD/PMD directory physically.
+ */
+#define PGD_ORDER	0
+#define PTE_ORDER	0
+
+#define PTRS_PER_PGD	1024
+#define PTRS_PER_PTE	1024
+
+#define USER_PTRS_PER_PGD	(0x80000000UL/PGDIR_SIZE)
+#define FIRST_USER_ADDRESS	0
+
+#define VMALLOC_START		(0xc0000000UL)
+
+#define PKMAP_BASE		(0xfd000000UL)
+
+#define VMALLOC_END		(FIXADDR_START - 2*PAGE_SIZE)
+
+#define pte_ERROR(e) \
+	printk(KERN_ERR "%s:%d: bad pte %08lx.\n", \
+		__FILE__, __LINE__, pte_val(e))
+#define pgd_ERROR(e) \
+	printk(KERN_ERR "%s:%d: bad pgd %08lx.\n", \
+		__FILE__, __LINE__, pgd_val(e))
+
+/*
+ * Empty pgd/pmd entries point to the invalid_pte_table.
+ */
+static inline int pmd_none(pmd_t pmd)
+{
+	return pmd_val(pmd) == (unsigned long) invalid_pte_table;
+}
+
+#define pmd_bad(pmd)		(pmd_val(pmd) & ~PAGE_MASK)
+
+static inline int pmd_present(pmd_t pmd)
+{
+	return pmd_val(pmd) != (unsigned long) invalid_pte_table;
+}
+
+static inline void pmd_clear(pmd_t *pmdp)
+{
+	pmd_val(*pmdp) = ((unsigned long) invalid_pte_table);
+}
+
+#define pte_page(x)		pfn_to_page(pte_pfn(x))
+#define pte_pfn(x)		((unsigned long)((x).pte >> PAGE_SHIFT))
+#define pfn_pte(pfn, prot)	\
+	__pte(((unsigned long long)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
+
+#define __pgd_offset(address)	pgd_index(address)
+#define __pud_offset(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
+#define __pmd_offset(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
+
+/* to find an entry in a kernel page-table-directory */
+#define pgd_offset_k(address)	pgd_offset(&init_mm, address)
+#define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
+
+/* to find an entry in a page-table-directory */
+#define pgd_offset(mm, addr)	((mm)->pgd + pgd_index(addr))
+
+/* Find an entry in the third-level page table.. */
+#define __pte_offset(address)		\
+	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+#define pte_offset(dir, address)	\
+	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
+#define pte_offset_kernel(dir, address)	\
+	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
+
+#define pte_offset_map(dir, address)	\
+	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_offset_map_nested(dir, address)	\
+	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_unmap(pte) ((void)(pte))
+#define pte_unmap_nested(pte) ((void)(pte))
+
+/*
+ * Bits 9(_PAGE_PRESENT) and 10(_PAGE_FILE)are taken,
+ * split up 30 bits of offset into this range:
+ */
+#define PTE_FILE_MAX_BITS	30
+#define pte_to_pgoff(_pte)		\
+	(((_pte).pte & 0x1ff) | (((_pte).pte >> 11) << 9))
+#define pgoff_to_pte(off)		\
+	((pte_t) {((off) & 0x1ff) | (((off) >> 9) << 11) | _PAGE_FILE})
+#define __pte_to_swp_entry(pte)		\
+	((swp_entry_t) { pte_val(pte)})
+#define __swp_entry_to_pte(x)	((pte_t) {(x).val})
+
+#define pmd_phys(pmd)		__pa((void *)pmd_val(pmd))
+#define pmd_page(pmd)		(pfn_to_page(pmd_phys(pmd) >> PAGE_SHIFT))
+#define mk_pte(page, prot)	pfn_pte(page_to_pfn(page), prot)
+static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
+
+#define set_pte(pteptr, pteval) (*(pteptr) = pteval)
+#define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
+#define pte_clear(mm, addr, xp)		\
+	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
+
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
+		remap_pfn_range(vma, vaddr, pfn, size, prot)
+
+/*
+ * The "pgd_xxx()" functions here are trivial for a folded two-level
+ * setup: the pgd is never bad, and a pmd always exists (as it's folded
+ * into the pgd entry)
+ */
+#define pgd_present(pgd)	(1)
+#define pgd_none(pgd)		(0)
+#define pgd_bad(pgd)		(0)
+#define pgd_clear(pgdp)		do { } while (0)
+
+#define kern_addr_valid(addr)	(1)
+#define pmd_page_vaddr(pmd)	pmd_val(pmd)
+
+#define pte_none(pte)		(!(pte_val(pte) & ~_PAGE_GLOBAL))
+#define pte_present(pte)	(pte_val(pte) & _PAGE_PRESENT)
+
+#define PAGE_NONE	__pgprot(_PAGE_PRESENT | _PAGE_CACHE)
+#define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_READ | _PAGE_WRITE | \
+				_PAGE_CACHE)
+#define PAGE_COPY	__pgprot(_PAGE_PRESENT | _PAGE_READ | _PAGE_CACHE)
+#define PAGE_READONLY	__pgprot(_PAGE_PRESENT | _PAGE_READ | _PAGE_CACHE)
+#define PAGE_KERNEL	__pgprot(_PAGE_PRESENT | __READABLE | __WRITEABLE | \
+				_PAGE_GLOBAL | _PAGE_CACHE)
+#define PAGE_KERNEL_UNCACHED __pgprot(_PAGE_PRESENT | __READABLE | \
+				__WRITEABLE | _PAGE_GLOBAL & ~_PAGE_CACHE)
+
+#define __P000	PAGE_NONE
+#define __P001	PAGE_READONLY
+#define __P010	PAGE_COPY
+#define __P011	PAGE_COPY
+#define __P100	PAGE_READONLY
+#define __P101	PAGE_READONLY
+#define __P110	PAGE_COPY
+#define __P111	PAGE_COPY
+
+#define __S000	PAGE_NONE
+#define __S001	PAGE_READONLY
+#define __S010	PAGE_SHARED
+#define __S011	PAGE_SHARED
+#define __S100	PAGE_READONLY
+#define __S101	PAGE_READONLY
+#define __S110	PAGE_SHARED
+#define __S111	PAGE_SHARED
+
+#define pgprot_noncached pgprot_noncached
+
+static inline pgprot_t pgprot_noncached(pgprot_t _prot)
+{
+	unsigned long prot = pgprot_val(_prot);
+
+	prot = (prot & ~_CACHE_MASK);
+
+	return __pgprot(prot);
+}
+
+#define __swp_type(x)		((x).val & 0x1f)
+#define __swp_offset(x) 	((x).val >> 11)
+#define __swp_entry(type, offset) ((swp_entry_t){(type) | ((offset) << 11)})
+
+extern unsigned long empty_zero_page;
+extern unsigned long zero_page_mask;
+
+#define ZERO_PAGE(vaddr) \
+	(virt_to_page((void *)(empty_zero_page + \
+	 (((unsigned long)(vaddr)) & zero_page_mask))))
+
+#define pgtable_cache_init()	do {} while (0)
+
+#define arch_enter_lazy_cpu_mode()	do {} while (0)
+
+static inline int pte_write(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_WRITE;
+}
+
+static inline int pte_dirty(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_MODIFIED;
+}
+
+static inline int pte_young(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_ACCESSED;
+}
+
+static inline int pte_file(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_FILE;
+}
+
+#define pte_special(pte)	(0)
+
+static inline pte_t pte_wrprotect(pte_t pte)
+{
+	pte_val(pte) &= ~(_PAGE_WRITE | _PAGE_SILENT_WRITE);
+	return pte;
+}
+
+static inline pte_t pte_mkclean(pte_t pte)
+{
+	pte_val(pte) &= ~(_PAGE_MODIFIED|_PAGE_SILENT_WRITE);
+	return pte;
+}
+
+static inline pte_t pte_mkold(pte_t pte)
+{
+	pte_val(pte) &= ~(_PAGE_ACCESSED|_PAGE_SILENT_READ);
+	return pte;
+}
+
+static inline pte_t pte_mkwrite(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_WRITE;
+	if (pte_val(pte) & _PAGE_MODIFIED)
+		pte_val(pte) |= _PAGE_SILENT_WRITE;
+	return pte;
+}
+
+static inline pte_t pte_mkdirty(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_MODIFIED;
+	if (pte_val(pte) & _PAGE_WRITE)
+		pte_val(pte) |= _PAGE_SILENT_WRITE;
+	return pte;
+}
+
+static inline pte_t pte_mkyoung(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_ACCESSED;
+	if (pte_val(pte) & _PAGE_READ)
+		pte_val(pte) |= _PAGE_SILENT_READ;
+	return pte;
+}
+
+#define set_pmd(pmdptr, pmdval)		\
+	 do { *(pmdptr) = (pmdval); } while (0)
+#define pte_present(pte)	(pte_val(pte) & _PAGE_PRESENT)
+
+extern unsigned long pgd_current;
+extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
+extern void paging_init(void);
+
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+{
+	return __pte((pte_val(pte) & _PAGE_CHG_MASK) | pgprot_val(newprot));
+}
+
+extern void __update_tlb(struct vm_area_struct *vma,
+	unsigned long address,	pte_t pte);
+extern void __update_cache(struct vm_area_struct *vma,
+	unsigned long address,	pte_t pte);
+
+static inline void update_mmu_cache(struct vm_area_struct *vma,
+	unsigned long address, pte_t pte)
+{
+	__update_tlb(vma, address, pte);
+	__update_cache(vma, address, pte);
+}
+
+#ifndef __ASSEMBLY__
+#include <asm-generic/pgtable.h>
+
+void setup_memory(void);
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_SCORE_PGTABLE_H */
-- 
1.6.2




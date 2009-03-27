Return-Path: <linux-kernel-owner+w=401wt.eu-S933575AbZC0Bi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbZC0Bi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762828AbZC0BiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:38:12 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:37200 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762269AbZC0BiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:38:08 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2009 21:38:07 EDT
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 4/13] score - New architecure port to SunplusCT S+CORE
  processor
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF7C8E38E6.732D64E1-ON48257586.0008A8A3-48257586.0008F44B@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Fri, 27 Mar 2009 09:36:03 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/03/27 ?? 09:36:04,
	Serialize complete at 2009/03/27 ?? 09:36:04
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/score lastest patch place at 
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/percpu.h 
linux-2.6-git.new/arch/score/include/asm/percpu.h
--- linux-2.6-git.ori/arch/score/include/asm/percpu.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/percpu.h   2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __ASM_PERCPU_H
+#define __ASM_PERCPU_H
+
+#include <asm-generic/percpu.h>
+
+#endif /* __ASM_PERCPU_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/pgalloc.h 
linux-2.6-git.new/arch/score/include/asm/pgalloc.h
--- linux-2.6-git.ori/arch/score/include/asm/pgalloc.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/pgalloc.h  2009-03-23 
15:20:37.000000000 +0800
@@ -0,0 +1,103 @@
+#ifndef _ASM_PGALLOC_H
+#define _ASM_PGALLOC_H
+
+#include <linux/mm.h>
+#include <linux/sched.h>
+
+static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
+       pte_t *pte)
+{
+       set_pmd(pmd, __pmd((unsigned long)pte));
+}
+
+static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
+       pgtable_t pte)
+{
+       set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
+}
+
+#define pmd_pgtable(pmd)       pmd_page(pmd)
+
+/*
+ * Initialize a new pmd table with invalid pointers.
+ */
+extern void pmd_init(unsigned long page, unsigned long pagetable);
+
+
+/*
+ * Initialize a new pgd / pmd table with invalid pointers.
+ */
+extern void pgd_init(unsigned long page);
+
+static inline pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+       pgd_t *ret, *init;
+
+       ret = (pgd_t *) __get_free_pages(GFP_KERNEL, PGD_ORDER);
+       if (ret) {
+               init = pgd_offset(&init_mm, 0UL);
+               pgd_init((unsigned long)ret);
+               memcpy(ret + USER_PTRS_PER_PGD, init + USER_PTRS_PER_PGD,
+                      (PTRS_PER_PGD - USER_PTRS_PER_PGD) * 
sizeof(pgd_t));
+       }
+
+       return ret;
+}
+
+static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+       free_pages((unsigned long)pgd, PGD_ORDER);
+}
+
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
+       unsigned long address)
+{
+       pte_t *pte;
+
+       pte = (pte_t *) 
__get_free_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, PTE_ORDER);
+
+       return pte;
+}
+
+static inline struct page *pte_alloc_one(struct mm_struct *mm,
+       unsigned long address)
+{
+       struct page *pte;
+
+       pte = alloc_pages(GFP_KERNEL | __GFP_REPEAT, PTE_ORDER);
+       if (pte) {
+               clear_highpage(pte);
+               pgtable_page_ctor(pte);
+       }
+       return pte;
+}
+
+static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+       free_pages((unsigned long)pte, PTE_ORDER);
+}
+
+static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
+{
+       pgtable_page_dtor(pte);
+       __free_pages(pte, PTE_ORDER);
+}
+
+#define __pte_free_tlb(tlb,pte)                                \
+do {                                                   \
+       pgtable_page_dtor(pte);                         \
+       tlb_remove_page((tlb), pte);                    \
+} while (0)
+
+/*
+ * allocating and freeing a pmd is trivial: the 1-entry pmd is
+ * inside the pgd, so has no extra memory associated with it.
+ */
+#define pmd_free(mm, x)                        do { } while (0)
+#define __pmd_free_tlb(tlb, x)         do { } while (0)
+
+#define check_pgt_cache()              do { } while (0)
+
+extern void pagetable_init(void);
+
+#endif /* _ASM_PGALLOC_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/pgtable-32.h 
linux-2.6-git.new/arch/score/include/asm/pgtable-32.h
--- linux-2.6-git.ori/arch/score/include/asm/pgtable-32.h       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/pgtable-32.h       2009-03-23 
17:47:05.000000000 +0800
@@ -0,0 +1,122 @@
+#ifndef _ASM_PGTABLE_32_H
+#define _ASM_PGTABLE_32_H
+
+#include <linux/linkage.h>
+#include <asm-generic/pgtable-nopmd.h>
+#include <asm/page.h>
+#include <asm/fixmap.h>
+
+/* PGDIR_SHIFT determines what a third-level page table entry can map */
+#define PGDIR_SHIFT    22
+#define PGDIR_SIZE     (1UL << PGDIR_SHIFT)
+#define PGDIR_MASK     (~(PGDIR_SIZE-1))
+
+/*
+ * Entries per page directory level: we use two-level, so
+ * we don't really have any PUD/PMD directory physically.
+ */
+#define PGD_ORDER      0
+#define PTE_ORDER      0
+
+#define PTRS_PER_PGD   1024
+#define PTRS_PER_PTE   1024
+
+#define USER_PTRS_PER_PGD      (0x80000000UL/PGDIR_SIZE)
+#define FIRST_USER_ADDRESS     0
+
+#define VMALLOC_START          (0xc0000000UL)
+
+#define PKMAP_BASE             (0xfd000000UL)
+
+#define VMALLOC_END            (FIXADDR_START-2 * PAGE_SIZE)
+
+#define pte_ERROR(e) \
+       printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
+#define pgd_ERROR(e) \
+       printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pgd_val(e))
+
+extern void load_pgd(unsigned long pg_dir);
+
+extern pte_t invalid_pte_table[PAGE_SIZE/sizeof(pte_t)];
+
+/*
+ * Empty pgd/pmd entries point to the invalid_pte_table.
+ */
+static inline int pmd_none(pmd_t pmd)
+{
+       return pmd_val(pmd) == (unsigned long) invalid_pte_table;
+}
+
+#define pmd_bad(pmd)           (pmd_val(pmd) & ~PAGE_MASK)
+
+static inline int pmd_present(pmd_t pmd)
+{
+       return pmd_val(pmd) != (unsigned long) invalid_pte_table;
+}
+
+static inline void pmd_clear(pmd_t *pmdp)
+{
+       pmd_val(*pmdp) = ((unsigned long) invalid_pte_table);
+}
+
+#define pte_page(x)            pfn_to_page(pte_pfn(x))
+#define pte_pfn(x)             ((unsigned long)((x).pte >> PAGE_SHIFT))
+#define pfn_pte(pfn, prot)     __pte(((unsigned long long)(pfn) << 
PAGE_SHIFT) | pgprot_val(prot))
+
+#define __pgd_offset(address)  pgd_index(address)
+#define __pud_offset(address)  (((address) >> PUD_SHIFT) & 
(PTRS_PER_PUD-1))
+#define __pmd_offset(address)  (((address) >> PMD_SHIFT) & 
(PTRS_PER_PMD-1))
+
+/* to find an entry in a kernel page-table-directory */
+#define pgd_offset_k(address)  pgd_offset(&init_mm, address)
+#define pgd_index(address)     (((address) >> PGDIR_SHIFT) & 
(PTRS_PER_PGD-1))
+
+/* to find an entry in a page-table-directory */
+#define pgd_offset(mm, addr)   ((mm)->pgd + pgd_index(addr))
+
+/* Find an entry in the third-level page table.. */
+#define __pte_offset(address)                                          \
+       (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+#define pte_offset(dir, address)                                       \
+       ((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
+#define pte_offset_kernel(dir, address) \
+       ((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
+
+#define pte_offset_map(dir, address)                                   \
+       ((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_offset_map_nested(dir, address)                            \
+       ((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_unmap(pte) ((void)(pte))
+#define pte_unmap_nested(pte) ((void)(pte))
+
+
+/* Swap entries must have VALID and GLOBAL bits cleared.
+   I don't sure blow is correct......Lennox
+   _PAGE_PRESENT is bit 9
+   _PAGE_FILE is bit 10
+   These bits must be 0.
+               31                                   0
+   swp_entry_t  |-----|---------------- - - ---- -----|
+                type           offset(27 bits)
+       convert to
+   PTE         |----- ----------------|F|P|????|-----|   ?:free bit
+                 offset(22bits)          9      type
+ */
+#define __swp_type(x)          ((x).val & 0x1f)
+#define __swp_offset(x)        ((x).val >> 11)
+#define __swp_entry(type,offset) ((swp_entry_t)        {(type) | 
((offset) << 11)})
+
+/*
+ * Bits 9(_PAGE_PRESENT) and 10(_PAGE_FILE)are taken, split up 30 bits of 
offset into this range:
+ */
+#define PTE_FILE_MAX_BITS      30
+
+#define pte_to_pgoff(_pte)     (((_pte).pte & 0x1ff) | (((_pte).pte >> 
11) << 9))
+
+#define pgoff_to_pte(off)      ((pte_t) {((off) & 0x1ff) | \
+                                (((off) >> 9) << 11) | _PAGE_FILE})
+
+#define __pte_to_swp_entry(pte)        ((swp_entry_t) { pte_val(pte)})
+#define __swp_entry_to_pte(x)  ((pte_t) {(x).val})
+
+#endif /* _ASM_PGTABLE_32_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/pgtable-bits.h 
linux-2.6-git.new/arch/score/include/asm/pgtable-bits.h
--- linux-2.6-git.ori/arch/score/include/asm/pgtable-bits.h     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/pgtable-bits.h     2009-03-23 
17:25:03.000000000 +0800
@@ -0,0 +1,28 @@
+#ifndef _ASM_PGTABLE_BITS_H
+#define _ASM_PGTABLE_BITS_H
+
+#define _PAGE_ACCESSED                 (1<<5)  /* implemented in software 
*/
+#define _PAGE_READ                     (1<<6)  /* implemented in software 
*/
+#define _PAGE_WRITE                    (1<<7)  /* implemented in software 
*/
+#define _PAGE_PRESENT                  (1<<9)  /* implemented in software 
*/
+#define _PAGE_MODIFIED                 (1<<10) /* implemented in software 
*/
+#define _PAGE_FILE                     (1<<10)
+
+#define _PAGE_GLOBAL                   (1<<0)
+#define _PAGE_VALID                    (1<<1)
+#define _PAGE_SILENT_READ              (1<<1)  /* synonym */
+#define _PAGE_DIRTY                    (1<<2)  /* Write bit */
+#define _PAGE_SILENT_WRITE             (1<<2)
+#define _PAGE_CACHE                    (1<<3)  /* cache */
+#define _CACHE_MASK                    (1<<3)
+#define _PAGE_BUFFERABLE               (1<<4)  /*Fallow Spec. */
+#define _PAGE_BIG                      (1<<8)  /* Big page (64KB) */
+
+#define _CACHE_UNCACHED                        (1<<11) /*implemented in 
software*/
+
+#define __READABLE     (_PAGE_READ | _PAGE_SILENT_READ | _PAGE_ACCESSED)
+#define __WRITEABLE    (_PAGE_WRITE | _PAGE_SILENT_WRITE | 
_PAGE_MODIFIED)
+#define _PAGE_CHG_MASK (PAGE_MASK | _PAGE_ACCESSED | _PAGE_MODIFIED | 
_PAGE_CACHE)
+#define PAGE_CACHABLE_DEFAULT  _PAGE_CACHE
+
+#endif /* _ASM_PGTABLE_BITS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/pgtable.h 
linux-2.6-git.new/arch/score/include/asm/pgtable.h
--- linux-2.6-git.ori/arch/score/include/asm/pgtable.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/pgtable.h  2009-03-23 
17:34:50.000000000 +0800
@@ -0,0 +1,214 @@
+#ifndef _ASM_PGTABLE_H
+#define _ASM_PGTABLE_H
+
+#include <asm/pgtable-bits.h>
+#include <asm/pgtable-32.h>
+#include <asm/io.h>
+
+struct mm_struct;
+struct vm_area_struct;
+
+#define PAGE_NONE      __pgprot(_PAGE_PRESENT | _PAGE_CACHE)
+#define PAGE_SHARED    __pgprot(_PAGE_PRESENT | _PAGE_READ | _PAGE_WRITE 
| \
+                               _PAGE_CACHE)
+#define PAGE_COPY      __pgprot(_PAGE_PRESENT | _PAGE_READ | _PAGE_CACHE)
+#define PAGE_READONLY  __pgprot(_PAGE_PRESENT | _PAGE_READ | _PAGE_CACHE)
+#define PAGE_KERNEL    __pgprot(_PAGE_PRESENT | __READABLE | __WRITEABLE 
| \
+                                _PAGE_GLOBAL | _PAGE_CACHE)
+#define PAGE_KERNEL_UNCACHED __pgprot(_PAGE_PRESENT | __READABLE | \
+                       __WRITEABLE | _PAGE_GLOBAL & ~_PAGE_CACHE)
+
+/*
+ * Dummy values to fill the table in mmap.c
+ * The real values will be generated at runtime
+ */
+#define __P000 __pgprot(0)
+#define __P001 __pgprot(0)
+#define __P010 __pgprot(0)
+#define __P011 __pgprot(0)
+#define __P100 __pgprot(0)
+#define __P101 __pgprot(0)
+#define __P110 __pgprot(0)
+#define __P111 __pgprot(0)
+
+#define __S000 __pgprot(0)
+#define __S001 __pgprot(0)
+#define __S010 __pgprot(0)
+#define __S011 __pgprot(0)
+#define __S100 __pgprot(0)
+#define __S101 __pgprot(0)
+#define __S110 __pgprot(0)
+#define __S111 __pgprot(0)
+
+/*
+ * ZERO_PAGE is a global shared page that is always zero; used
+ * for zero-mapped memory areas etc..
+ */
+
+extern unsigned long empty_zero_page;
+extern unsigned long zero_page_mask;
+extern unsigned long pgd_current;
+
+#define ZERO_PAGE(vaddr) \
+       (virt_to_page((void *)(empty_zero_page + \
+        (((unsigned long)(vaddr)) & zero_page_mask))))
+
+extern void paging_init(void);
+
+/*
+ * Conversion functions: convert a page and protection to a page entry,
+ * and a page entry and page directory to the page they refer to.
+ */
+#define pmd_phys(pmd)          virt_to_phys((void *)pmd_val(pmd))
+#define pmd_page(pmd)          (pfn_to_page(pmd_phys(pmd) >> PAGE_SHIFT))
+#define pmd_page_vaddr(pmd)    pmd_val(pmd)
+
+#define pte_none(pte)          (!(pte_val(pte) & ~_PAGE_GLOBAL))
+#define pte_present(pte)       (pte_val(pte) & _PAGE_PRESENT)
+
+/*
+ * Certain architectures need to do special things when pte's
+ * within a page table are directly modified.  Thus, the following
+ * hook is made available.
+ */
+static inline void set_pte(pte_t *ptep, pte_t pteval)
+{
+       *ptep = pteval;
+}
+
+#define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
+
+static inline void pte_clear(struct mm_struct *mm, unsigned long addr, 
pte_t *ptep)
+{
+       set_pte_at(mm, addr, ptep, __pte(0));
+}
+
+/*
+ * (pmds are folded into puds so this doesn't get actually called,
+ * but the define is needed for a generic inline function.)
+ */
+#define set_pmd(pmdptr, pmdval) do { *(pmdptr) = (pmdval); } while(0)
+
+#define PGD_T_LOG2     (__builtin_ffs(sizeof(pgd_t)) - 1)
+#define PMD_T_LOG2     (__builtin_ffs(sizeof(pmd_t)) - 1)
+#define PTE_T_LOG2     (__builtin_ffs(sizeof(pte_t)) - 1)
+
+/*
+ * We used to declare this array with size but gcc 3.3 and older are not 
able
+ * to find that this expression is a constant, so the size is dropped.
+ */
+extern pgd_t swapper_pg_dir[];
+
+/*
+ * The following only work if pte_present() is true.
+ * Undefined behaviour if not..
+ */
+static inline int pte_write(pte_t pte) { return pte_val(pte) & 
_PAGE_WRITE; }
+static inline int pte_dirty(pte_t pte) { return pte_val(pte) & 
_PAGE_MODIFIED; }
+static inline int pte_young(pte_t pte) { return pte_val(pte) & 
_PAGE_ACCESSED; }
+static inline int pte_file(pte_t pte)  { return pte_val(pte) & 
_PAGE_FILE; }
+
+static inline pte_t pte_wrprotect(pte_t pte)
+{
+       pte_val(pte) &= ~(_PAGE_WRITE | _PAGE_SILENT_WRITE);
+       return pte;
+}
+
+static inline pte_t pte_mkclean(pte_t pte)
+{
+       pte_val(pte) &= ~(_PAGE_MODIFIED|_PAGE_SILENT_WRITE);
+       return pte;
+}
+
+static inline pte_t pte_mkold(pte_t pte)
+{
+       pte_val(pte) &= ~(_PAGE_ACCESSED|_PAGE_SILENT_READ);
+       return pte;
+}
+
+static inline pte_t pte_mkwrite(pte_t pte)
+{
+       pte_val(pte) |= _PAGE_WRITE;
+       if (pte_val(pte) & _PAGE_MODIFIED)
+               pte_val(pte) |= _PAGE_SILENT_WRITE;
+       return pte;
+}
+
+static inline pte_t pte_mkdirty(pte_t pte)
+{
+       pte_val(pte) |= _PAGE_MODIFIED;
+       if (pte_val(pte) & _PAGE_WRITE)
+               pte_val(pte) |= _PAGE_SILENT_WRITE;
+       return pte;
+}
+
+static inline pte_t pte_mkyoung(pte_t pte)
+{
+       pte_val(pte) |= _PAGE_ACCESSED;
+       if (pte_val(pte) & _PAGE_READ)
+               pte_val(pte) |= _PAGE_SILENT_READ;
+       return pte;
+}
+
+static inline int pte_special(pte_t pte)       { return 0;}
+static inline pte_t pte_mkspecial(pte_t pte)   { return pte;}
+
+/*
+ * Macro to make mark a page protection value as "uncacheable".  Note
+ * that "protection" is really a misnomer here as the protection value
+ * contains the memory attribute bits, dirty bits, and various other
+ * bits as well.
+ */
+#define pgprot_noncached pgprot_noncached
+
+static inline pgprot_t pgprot_noncached(pgprot_t _prot)
+{
+       unsigned long prot = pgprot_val(_prot);
+
+       prot = (prot & ~_CACHE_MASK) ;
+
+       return __pgprot(prot);
+}
+
+/*
+ * Conversion functions: convert a page and protection to a page entry,
+ * and a page entry and page directory to the page they refer to.
+ */
+#define mk_pte(page, pgprot)   pfn_pte(page_to_pfn(page), (pgprot))
+
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+{
+       return __pte((pte_val(pte) & _PAGE_CHG_MASK) | 
pgprot_val(newprot));
+}
+
+extern void __update_tlb(struct vm_area_struct *vma, unsigned long 
address,
+       pte_t pte);
+extern void __update_cache(struct vm_area_struct *vma, unsigned long 
address,
+       pte_t pte);
+
+static inline void update_mmu_cache(struct vm_area_struct *vma,
+       unsigned long address, pte_t pte)
+{
+       __update_tlb(vma, address, pte);
+       __update_cache(vma, address, pte);
+}
+
+#define kern_addr_valid(addr)  (1)
+
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)                \
+               remap_pfn_range(vma, vaddr, pfn, size, prot)
+
+#include <asm-generic/pgtable.h>
+
+/*
+ * We provide our own get_unmapped area to cope with the virtual aliasing
+ * constraints placed on us by the cache architecture.
+ */
+#define HAVE_ARCH_UNMAPPED_AREA
+
+/*
+ * No page table caches to initialise
+ */
+#define pgtable_cache_init()   do { } while (0)
+
+#endif /* _ASM_PGTABLE_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/poll.h 
linux-2.6-git.new/arch/score/include/asm/poll.h
--- linux-2.6-git.ori/arch/score/include/asm/poll.h     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/poll.h     2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,9 @@
+#ifndef __ASM_POLL_H
+#define __ASM_POLL_H
+
+#define POLLWRNORM     POLLOUT
+#define POLLWRBAND     0x0100
+
+#include <asm-generic/poll.h>
+
+#endif /* __ASM_POLL_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/posix_types.h 
linux-2.6-git.new/arch/score/include/asm/posix_types.h
--- linux-2.6-git.ori/arch/score/include/asm/posix_types.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/posix_types.h      2009-03-23 
14:56:30.000000000 +0800
@@ -0,0 +1,117 @@
+#ifndef _ASM_POSIX_TYPES_H
+#define _ASM_POSIX_TYPES_H
+
+/*
+ * This file is generally used by user-level software, so you need to
+ * be a little careful about namespace pollution etc.  Also, we cannot
+ * assume GCC is being used.
+ */
+
+typedef unsigned long  __kernel_ino_t;
+typedef unsigned int   __kernel_mode_t;
+typedef unsigned long  __kernel_nlink_t;
+typedef long           __kernel_off_t;
+typedef int            __kernel_pid_t;
+typedef int            __kernel_ipc_pid_t;
+typedef unsigned int   __kernel_uid_t;
+typedef unsigned int   __kernel_gid_t;
+typedef unsigned int   __kernel_size_t;
+typedef int            __kernel_ssize_t;
+typedef int            __kernel_ptrdiff_t;
+typedef long           __kernel_time_t;
+typedef long           __kernel_suseconds_t;
+typedef long           __kernel_clock_t;
+typedef int            __kernel_timer_t;
+typedef int            __kernel_clockid_t;
+typedef long           __kernel_daddr_t;
+typedef char *         __kernel_caddr_t;
+
+typedef unsigned short __kernel_uid16_t;
+typedef unsigned short __kernel_gid16_t;
+typedef unsigned int   __kernel_uid32_t;
+typedef unsigned int   __kernel_gid32_t;
+typedef __kernel_uid_t __kernel_old_uid_t;
+typedef __kernel_gid_t __kernel_old_gid_t;
+typedef unsigned int   __kernel_old_dev_t;
+
+#ifdef __GNUC__
+typedef long long      __kernel_loff_t;
+#endif
+
+typedef struct {
+       long    val[2];
+} __kernel_fsid_t;
+
+#if defined(__KERNEL__)
+
+#undef __FD_SET
+static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set 
*__fdsetp)
+{
+       unsigned long __tmp = __fd / __NFDBITS;
+       unsigned long __rem = __fd % __NFDBITS;
+       __fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
+}
+
+#undef __FD_CLR
+static __inline__ void __FD_CLR(unsigned long __fd, __kernel_fd_set 
*__fdsetp)
+{
+       unsigned long __tmp = __fd / __NFDBITS;
+       unsigned long __rem = __fd % __NFDBITS;
+       __fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
+}
+
+#undef __FD_ISSET
+static __inline__ int __FD_ISSET(unsigned long __fd, const 
__kernel_fd_set *__p)
+{
+       unsigned long __tmp = __fd / __NFDBITS;
+       unsigned long __rem = __fd % __NFDBITS;
+       return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
+}
+
+/*
+ * This will unroll the loop for the normal constant case (8 ints,
+ * for a 256-bit fd_set)
+ */
+#undef __FD_ZERO
+static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
+{
+       unsigned long *__tmp = __p->fds_bits;
+       int __i;
+
+       if (__builtin_constant_p(__FDSET_LONGS)) {
+               switch (__FDSET_LONGS) {
+               case 16:
+                       __tmp[ 0] = 0; __tmp[ 1] = 0;
+                       __tmp[ 2] = 0; __tmp[ 3] = 0;
+                       __tmp[ 4] = 0; __tmp[ 5] = 0;
+                       __tmp[ 6] = 0; __tmp[ 7] = 0;
+                       __tmp[ 8] = 0; __tmp[ 9] = 0;
+                       __tmp[10] = 0; __tmp[11] = 0;
+                       __tmp[12] = 0; __tmp[13] = 0;
+                       __tmp[14] = 0; __tmp[15] = 0;
+                       return;
+
+               case 8:
+                       __tmp[ 0] = 0; __tmp[ 1] = 0;
+                       __tmp[ 2] = 0; __tmp[ 3] = 0;
+                       __tmp[ 4] = 0; __tmp[ 5] = 0;
+                       __tmp[ 6] = 0; __tmp[ 7] = 0;
+                       return;
+
+               case 4:
+                       __tmp[ 0] = 0; __tmp[ 1] = 0;
+                       __tmp[ 2] = 0; __tmp[ 3] = 0;
+                       return;
+               }
+       }
+       __i = __FDSET_LONGS;
+       while (__i) {
+               __i--;
+               *__tmp = 0;
+               __tmp++;
+       }
+}
+
+#endif /* defined(__KERNEL__) */
+
+#endif /* _ASM_POSIX_TYPES_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/processor.h 
linux-2.6-git.new/arch/score/include/asm/processor.h
--- linux-2.6-git.ori/arch/score/include/asm/processor.h        1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/processor.h        2009-03-23 
17:25:21.000000000 +0800
@@ -0,0 +1,118 @@
+#ifndef _ASM_PROCESSOR_H
+#define _ASM_PROCESSOR_H
+
+#include <linux/cpumask.h>
+#include <linux/threads.h>
+
+#define SZREG  4
+
+/*
+ * Return current * instruction pointer ("program counter").
+ */
+#define current_text_addr() ({ __label__ _l; _l: &&_l;})
+
+/*
+ * System setup and hardware flags..
+ */
+extern void (*cpu_wait)(void);
+
+/*
+ * User space process size: 2GB. This is hardcoded into a few places,
+ * so don't change it unless you know what you are doing.
+ */
+#define TASK_SIZE      0x7fff8000UL
+#define STACK_TOP      TASK_SIZE
+
+/*
+ * This decides where the kernel will search for a free chunk of vm
+ * space during mmap's.
+ */
+#define TASK_UNMAPPED_BASE     ((TASK_SIZE / 3) & ~(PAGE_SIZE))
+
+#ifdef __KERNEL__
+#define STACK_TOP_MAX  TASK_SIZE
+#endif
+
+#define INIT_CPUMASK {{0,}}
+
+typedef struct {
+       unsigned long seg;
+} mm_segment_t;
+
+#define ARCH_MIN_TASKALIGN     8
+
+/*
+ * If you change thread_struct remember to change the #defines below too!
+ */
+struct thread_struct {
+       unsigned long reg0, reg2, reg3;
+       unsigned long reg12, reg13, reg14, reg15, reg16;
+       unsigned long reg17, reg18, reg19, reg20, reg21;
+
+       unsigned long cp0_psr;
+
+       unsigned long cp0_ema;          /* Last user fault */
+       unsigned long cp0_badvaddr;     /* Last user fault */
+       unsigned long cp0_baduaddr;     /* Last kernel fault accessing 
USEG */
+       unsigned long error_code;
+       unsigned long trap_no;
+
+       unsigned long mflags;
+       unsigned long reg29;
+
+       unsigned long single_step;
+       unsigned long ss_nextcnt;
+
+       unsigned long insn1_type;
+       unsigned long addr1;
+       unsigned long insn1;
+
+       unsigned long insn2_type;
+       unsigned long addr2;
+       unsigned long insn2;
+ 
+       mm_segment_t current_ds;
+};
+
+#define INIT_THREAD {                                          \
+       .reg0                   = 0,                            \
+       .reg2                   = 0,                            \
+       .reg3                   = 0,                            \
+       .reg12                  = 0,                            \
+       .reg13                  = 0,                            \
+       .reg14                  = 0,                            \
+       .reg15                  = 0,                            \
+       .reg16                  = 0,                            \
+       .reg17                  = 0,                            \
+       .reg18                  = 0,                            \
+       .reg19                  = 0,                            \
+       .reg20                  = 0,                            \
+       .reg21                  = 0,                            \
+       /*                                                      \
+        * Saved cp0 stuff                                      \
+        */                                                     \
+       .cp0_psr                = 0,                            \
+       .error_code             = 0,                            \
+       .trap_no                = 0,                            \
+}
+
+struct task_struct;
+
+#define release_thread(thread) do {} while(0)
+#define prepare_to_copy(tsk)   do {} while (0)
+
+extern long kernel_thread(int (*fn)(void *), void *arg, unsigned long 
flags);
+extern unsigned long thread_saved_pc(struct task_struct *tsk);
+extern void start_thread(struct pt_regs *regs, unsigned long pc, unsigned 
long sp);
+extern unsigned long get_wchan(struct task_struct *p);
+
+#define __KSTK_TOS(tsk)                ((unsigned 
long)task_stack_page(tsk) + THREAD_SIZE - 32)
+#define task_pt_regs(tsk)      ((struct pt_regs *)__KSTK_TOS(tsk) - 1)
+
+#define KSTK_EIP(tsk)          (task_pt_regs(tsk)->cp0_epc)
+#define KSTK_ESP(tsk)          (task_pt_regs(tsk)->regs[29])
+
+#define cpu_relax()            barrier()
+#define return_address() ({__asm__ 
__volatile__("":::"r3");__builtin_return_address(0);})
+
+#endif /* _ASM_PROCESSOR_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/ptrace.h 
linux-2.6-git.new/arch/score/include/asm/ptrace.h
--- linux-2.6-git.ori/arch/score/include/asm/ptrace.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/ptrace.h   2009-03-23 
14:57:59.000000000 +0800
@@ -0,0 +1,89 @@
+#ifndef _ASM_PTRACE_H
+#define _ASM_PTRACE_H
+
+#define PC             32
+#define CONDITION      33
+#define ECR            34
+#define EMA            35
+#define CEH            36
+#define CEL            37
+#define COUNTER                38
+#define LDCR           39
+#define STCR           40
+#define PSR            41
+
+#define SINGLESTEP16_INSN      0x7006
+#define SINGLESTEP32_INSN      0x840C8000
+#define BREAKPOINT16_INSN      0x7002          /* work on SPG300 */
+#define BREAKPOINT32_INSN      0x84048000      /* work on SPG300 */
+
+/* Define instruction mask */
+#define INSN32_MASK    0x80008000
+
+#define J32    0x88008000      /* 1_00010_0000000000_1_000000000000000 */
+#define J32M   0xFC008000      /* 1_11111_0000000000_1_000000000000000 */
+
+#define B32    0x90008000      /* 1_00100_0000000000_1_000000000000000 */
+#define B32M   0xFC008000
+#define BL32   0x90008001      /* 1_00100_0000000000_1_000000000000001 */
+#define BL32M  B32
+#define BR32   0x80008008      /* 1_00000_0000000000_1_00000000_000100_0 
*/
+#define BR32M  0xFFE0807E
+#define BRL32  0x80008009      /* 1_00000_0000000000_1_00000000_000100_1 
*/
+#define BRL32M BR32M
+
+#define B32_SET        (J32 | B32 | BL32 | BR32 | BRL32)
+
+#define J16    0x3000          /* 0_011_....... */
+#define J16M   0xF000
+#define B16    0x4000          /* 0_100_....... */
+#define B16M   0xF000
+#define BR16   0x0004          /* 0_000.......0100 */
+#define BR16M  0xF00F
+#define B16_SET J16 | B16 | BR16
+
+
+/*
+ * This struct defines the way the registers are stored on the stack 
during a
+ * system call/exception. As usual the registers k0/k1 aren't being 
saved.
+ */
+struct pt_regs {
+       unsigned long pad0[6];
+       unsigned long orig_r4;
+       unsigned long orig_r7;
+       unsigned long regs[32];
+
+       unsigned long cel;
+       unsigned long ceh;
+
+       unsigned long sr0;      /* cnt */
+       unsigned long sr1;      /* lcr */
+       unsigned long sr2;      /* scr */
+
+       unsigned long cp0_epc;
+       unsigned long cp0_ema;
+       unsigned long cp0_psr;
+       unsigned long cp0_ecr;
+       unsigned long cp0_condition;
+ 
+       long is_syscall;
+};
+
+#ifdef __KERNEL__
+
+#include <linux/linkage.h>
+
+/*
+ * Does the process account for user or for system time?
+ */
+#define user_mode(regs)        ((regs->cp0_psr & 8) == 8)
+
+#define instruction_pointer(regs) (0)
+#define profile_pc(regs) instruction_pointer(regs)
+
+extern asmlinkage void do_syscall_trace(struct pt_regs *regs, int 
entryexit);
+extern int read_tsk_long(struct task_struct *, unsigned long, unsigned 
long *);
+extern void clear_single_step(struct task_struct *);
+#endif
+
+#endif /* _ASM_PTRACE_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/resource.h 
linux-2.6-git.new/arch/score/include/asm/resource.h
--- linux-2.6-git.ori/arch/score/include/asm/resource.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/resource.h 2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,17 @@
+#ifndef _ASM_RESOURCE_H
+#define _ASM_RESOURCE_H
+
+/*
+ * These five resource limit IDs have a SCORE/Linux-specific ordering,
+ * the rest comes from the generic header:
+ */
+#define RLIMIT_NOFILE          5       /* max number of open files */
+#define RLIMIT_AS              6       /* address space limit */
+#define RLIMIT_RSS             7       /* max resident set size */
+#define RLIMIT_NPROC           8       /* max number of processes */
+#define RLIMIT_MEMLOCK         9       /* max locked-in-memory address 
space */
+#define RLIM_INFINITY          0x7fffffffUL
+
+#include <asm-generic/resource.h>
+
+#endif /* _ASM_RESOURCE_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/scatterlist.h 
linux-2.6-git.new/arch/score/include/asm/scatterlist.h
--- linux-2.6-git.ori/arch/score/include/asm/scatterlist.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/scatterlist.h      2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,26 @@
+#ifndef __ASM_SCATTERLIST_H
+#define __ASM_SCATTERLIST_H
+
+#include <asm/types.h>
+
+struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+       unsigned long   sg_magic;
+#endif
+       unsigned long   page_link;
+       unsigned int    offset;
+       dma_addr_t      dma_address;
+       unsigned int    length;
+};
+
+/*
+ * These macros should be used after a pci_map_sg call has been done
+ * to get bus addresses of each of the SG entries and their lengths.
+ * You should only work with the number of sg entries pci_map_sg
+ * returns, or alternatively stop on the first sg_dma_len(sg) which
+ * is 0.
+ */
+#define sg_dma_address(sg)     ((sg)->dma_address)
+#define sg_dma_len(sg)         ((sg)->length)
+
+#endif /* __ASM_SCATTERLIST_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/scoreregs.h 
linux-2.6-git.new/arch/score/include/asm/scoreregs.h
--- linux-2.6-git.ori/arch/score/include/asm/scoreregs.h        1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/scoreregs.h        2009-03-20 
10:43:48.000000000 +0800
@@ -0,0 +1,65 @@
+#include <linux/linkage.h>
+
+#define IRQ_TIMER (7)  /* IRQ  number of SPG300 */
+
+/* TIMER register */
+#define TIME0Base      0x96080000
+#define rTIMER0C       (*(volatile unsigned *)(TIME0Base+0x00))
+#define rTIMER0CPPC    (*(volatile unsigned *)(TIME0Base+0x04))
+#define rTIMER0CPR     (*(volatile unsigned *)(TIME0Base+0x08))
+#define rTIMER0CPPR    (*(volatile unsigned *)(TIME0Base+0x0C))
+#define rTIMER0UC      (*(volatile unsigned *)(TIME0Base+0x10))
+
+/* Timer Controller Register */
+/* bit 0 Timer enable */
+#define TMR_ENABLE     0x0001
+#define TMR_DISABLE    0x0000
+
+/* bit 1 Interrupt enable */
+#define TMR_IE_Disable 0x0000
+#define TMR_IE_Enable  0x0002
+
+/* bit 2 Output enable */
+#define TMR_OE_Enable  0x0000
+#define TMR_OE_Disable 0x0004
+
+/* bit4 Up/Down counting selection */
+#define TMR_UD_Down    0x0000
+#define TMR_UD_Up      0x0010
+
+/* bit5 Up/Down counting control selection */
+#define TMR_UDS_UD     0x0000
+#define TMR_UDS_EXTUD  0x0020
+
+/* bit6 Time output mode */
+#define TMR_OM_Toggle  0x0000
+#define TMR_OM_Pilse   0x0040
+
+/* bit 8..9 External input active edge selection */
+#define TMR_ES_PE      0x0000
+#define TMR_ES_NE      0x0100
+#define TMR_ES_BOTH    0x0200
+
+/* bit 10..11 Operating mode */
+#define TMR_M_Free     0x0000 /* free running timer mode */
+#define TMR_M_Periodic 0x0400 /* periodic timer mode */
+#define TMR_M_FC       0x0800 /* free running counter mode */
+#define TMR_M_PC       0x0c00 /* periodic counter mode */
+
+#define mSEC_1         1000
+#define mSEC_5         (mSEC_1 * 5)
+#define mSEC_10                (mSEC_1 * 10)
+#define mSEC_25                (mSEC_1 * 25)
+#define SEC_1          (mSEC_1 * 1000)
+
+#define SYSTEM_CLOCK           (27*1000000)            /* 27 MHz */
+#define PRESCALER_uSEC_1       ((SYSTEM_CLOCK / 1000000) - 1)
+#define TICKS_PER_uSEC         (SYSTEM_CLOCK / (PRESCALER_uSEC_1+1) / 
1000000)
+
+#define PRESCALER_VALUE                PRESCALER_uSEC_1
+#define TIMER_INTERVAL         ((TICKS_PER_uSEC * mSEC_10) -1)
+#define TICKS2USECS(x)         ( (x) / TICKS_PER_uSEC)
+
+#ifndef __ASSEMBLY__
+
+#endif
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/sections.h 
linux-2.6-git.new/arch/score/include/asm/sections.h
--- linux-2.6-git.ori/arch/score/include/asm/sections.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/sections.h 2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef _ASM_SECTIONS_H
+#define _ASM_SECTIONS_H
+
+#include <asm-generic/sections.h>
+
+#endif /* _ASM_SECTIONS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/sembuf.h 
linux-2.6-git.new/arch/score/include/asm/sembuf.h
--- linux-2.6-git.ori/arch/score/include/asm/sembuf.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/sembuf.h   2009-03-26 
10:46:00.000000000 +0800
@@ -0,0 +1,25 @@
+#ifndef __ASM_SCORE_SEMBUF_H
+#define __ASM_SCORE_SEMBUF_H
+
+/*
+* The semid64_ds structure for SCORE architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct semid64_ds {
+        struct ipc64_perm sem_perm;             /* permissions .. see 
ipc.h */
+        __kernel_time_t sem_otime;              /* last semop time */
+        unsigned long   __unused1;
+        __kernel_time_t sem_ctime;              /* last change time */
+        unsigned long   __unused2;
+        unsigned long   sem_nsems;              /* no. of semaphores in 
array */
+        unsigned long   __unused3;
+        unsigned long   __unused4;
+};
+
+#endif /* __ASM_SCORE_SEMBUF_H */

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>

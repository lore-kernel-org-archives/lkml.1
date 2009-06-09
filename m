Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbZFIGgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbZFIGgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757145AbZFIGf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:35:58 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:36883 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZFIGf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:35:56 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 14/27] score: create head files pages.h param.h pci.h percpu.h
 pgalloc.h pgtable-bits.h pgtable.h poll.h posix_types.h processor.h
 ptrace.s
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF90BA357E.92B7BCA1-ON482575D0.0023C2B7-482575D0.002437B0@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:31:18 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:31:18,
	Serialize complete at 2009/06/09 ?? 02:31:18
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ee611421c236c26ea7182901f271dc4da079f89b Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:12 +0800


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/page.h         |   92 +++++++++++
 arch/score/include/asm/param.h        |    6 +
 arch/score/include/asm/pci.h          |    4 +
 arch/score/include/asm/percpu.h       |    6 +
 arch/score/include/asm/pgalloc.h      |   83 ++++++++++
 arch/score/include/asm/pgtable-bits.h |   23 +++
 arch/score/include/asm/pgtable.h      |  267 
+++++++++++++++++++++++++++++++++
 arch/score/include/asm/poll.h         |    6 +
 arch/score/include/asm/posix_types.h  |    6 +
 arch/score/include/asm/processor.h    |  106 +++++++++++++
 arch/score/include/asm/ptrace.h       |   87 +++++++++++
 11 files changed, 686 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/page.h
 create mode 100644 arch/score/include/asm/param.h
 create mode 100644 arch/score/include/asm/pci.h
 create mode 100644 arch/score/include/asm/percpu.h
 create mode 100644 arch/score/include/asm/pgalloc.h
 create mode 100644 arch/score/include/asm/pgtable-bits.h
 create mode 100644 arch/score/include/asm/pgtable.h
 create mode 100644 arch/score/include/asm/poll.h
 create mode 100644 arch/score/include/asm/posix_types.h
 create mode 100644 arch/score/include/asm/processor.h
 create mode 100644 arch/score/include/asm/ptrace.h

diff --git a/arch/score/include/asm/page.h b/arch/score/include/asm/page.h
new file mode 100644
index 0000000..67e9820
--- /dev/null
+++ b/arch/score/include/asm/page.h
@@ -0,0 +1,92 @@
+#ifndef _ASM_SCORE_PAGE_H
+#define _ASM_SCORE_PAGE_H
+
+#include <linux/pfn.h>
+
+/* PAGE_SHIFT determines the page size */
+#define PAGE_SHIFT     (12)
+#define PAGE_SIZE      (1UL << PAGE_SHIFT)
+#define PAGE_MASK      (~(PAGE_SIZE-1))
+
+#ifdef __KERNEL__
+
+#ifndef __ASSEMBLY__
+
+#define PAGE_UP(addr)  (((addr)+((PAGE_SIZE)-1))&(~((PAGE_SIZE)-1)))
+#define PAGE_DOWN(addr)        ((addr)&(~((PAGE_SIZE)-1)))
+
+/* align addr on a size boundary - adjust address up/down if needed */
+#define _ALIGN_UP(addr, size)  (((addr)+((size)-1))&(~((size)-1)))
+#define _ALIGN_DOWN(addr, size)        ((addr)&(~((size)-1)))
+
+/* align addr on a size boundary - adjust address up if needed */
+#define _ALIGN(addr, size)     _ALIGN_UP(addr, size)
+
+/*
+ * PAGE_OFFSET -- the first address of the first page of memory. When not
+ * using MMU this corresponds to the first free page in physical memory 
(aligned
+ * on a page boundary).
+ */
+#define PAGE_OFFSET            (0xA0000000UL)
+
+#define clear_page(pgaddr)                     memset((pgaddr), 0, 
PAGE_SIZE)
+#define copy_page(to, from)                    memcpy((to), (from), 
PAGE_SIZE)
+
+#define clear_user_page(pgaddr, vaddr, page)   memset((pgaddr), 0, 
PAGE_SIZE)
+#define copy_user_page(vto, vfrom, vaddr, topg) \
+                       memcpy((vto), (vfrom), PAGE_SIZE)
+
+/*
+ * These are used to make use of C type-checking..
+ */
+
+typedef struct { unsigned long pte; } pte_t;           /* page table 
entry */
+typedef struct { unsigned long pgd; } pgd_t;           /* PGD table entry 
*/
+typedef struct { unsigned long pgprot; } pgprot_t;
+typedef struct page *pgtable_t;
+
+#define pte_val(x)     ((x).pte)
+#define pgd_val(x)     ((x).pgd)
+#define pgprot_val(x)  ((x).pgprot)
+
+#define __pte(x)       ((pte_t) { (x) })
+#define __pgd(x)       ((pgd_t) { (x) })
+#define __pgprot(x)    ((pgprot_t) { (x) })
+
+extern unsigned long max_low_pfn;
+extern unsigned long min_low_pfn;
+extern unsigned long max_pfn;
+
+#define __pa(vaddr)            ((unsigned long) (vaddr))
+#define __va(paddr)            ((void *) (paddr))
+
+#define phys_to_pfn(phys)      (PFN_DOWN(phys))
+#define pfn_to_phys(pfn)       (PFN_PHYS(pfn))
+
+#define virt_to_pfn(vaddr)     (phys_to_pfn((__pa(vaddr))))
+#define pfn_to_virt(pfn)       __va(pfn_to_phys((pfn)))
+
+#define virt_to_page(vaddr)    (pfn_to_page(virt_to_pfn(vaddr)))
+#define page_to_virt(page)     (pfn_to_virt(page_to_pfn(page)))
+
+#define page_to_phys(page)     (pfn_to_phys(page_to_pfn(page)))
+#define page_to_bus(page)      (page_to_phys(page))
+#define phys_to_page(paddr)    (pfn_to_page(phys_to_pfn(paddr)))
+
+#define pfn_valid(pfn)         ((pfn) >= min_low_pfn && (pfn) < 
max_mapnr)
+
+#define ARCH_PFN_OFFSET                (PAGE_OFFSET >> PAGE_SHIFT)
+
+#endif /* __ASSEMBLY__ */
+
+#define virt_addr_valid(vaddr) (pfn_valid(virt_to_pfn(vaddr)))
+
+#endif /* __KERNEL__ */
+
+#define VM_DATA_DEFAULT_FLAGS  (VM_READ | VM_WRITE | VM_EXEC | \
+                                VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+#include <asm-generic/memory_model.h>
+#include <asm-generic/getorder.h>
+
+#endif /* _ASM_SCORE_PAGE_H */
diff --git a/arch/score/include/asm/param.h 
b/arch/score/include/asm/param.h
new file mode 100644
index 0000000..916b869
--- /dev/null
+++ b/arch/score/include/asm/param.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_PARAM_H
+#define _ASM_SCORE_PARAM_H
+
+#include <asm-generic/param.h>
+
+#endif /* _ASM_SCORE_PARAM_H */
diff --git a/arch/score/include/asm/pci.h b/arch/score/include/asm/pci.h
new file mode 100644
index 0000000..3f3cfd8
--- /dev/null
+++ b/arch/score/include/asm/pci.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_SCORE_PCI_H
+#define _ASM_SCORE_PCI_H
+
+#endif /* _ASM_SCORE_PCI_H */
diff --git a/arch/score/include/asm/percpu.h 
b/arch/score/include/asm/percpu.h
new file mode 100644
index 0000000..e7bd4e0
--- /dev/null
+++ b/arch/score/include/asm/percpu.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_PERCPU_H
+#define _ASM_SCORE_PERCPU_H
+
+#include <asm-generic/percpu.h>
+
+#endif /* _ASM_SCORE_PERCPU_H */
diff --git a/arch/score/include/asm/pgalloc.h 
b/arch/score/include/asm/pgalloc.h
new file mode 100644
index 0000000..28dacc1
--- /dev/null
+++ b/arch/score/include/asm/pgalloc.h
@@ -0,0 +1,83 @@
+#ifndef _ASM_SCORE_PGALLOC_H
+#define _ASM_SCORE_PGALLOC_H
+
+#include <linux/mm.h>
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
+static inline pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+       pgd_t *ret, *init;
+
+       ret = (pgd_t *) __get_free_pages(GFP_KERNEL, PGD_ORDER);
+       if (ret) {
+               init = pgd_offset(&init_mm, 0UL);
+               pgd_init((unsigned long)ret);
+               memcpy(ret + USER_PTRS_PER_PGD, init + USER_PTRS_PER_PGD,
+               (PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
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
__get_free_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO,
+                                       PTE_ORDER);
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
+#define __pte_free_tlb(tlb, pte)                       \
+do {                                                   \
+       pgtable_page_dtor(pte);                         \
+       tlb_remove_page((tlb), pte);                    \
+} while (0)
+
+#define check_pgt_cache()              do {} while (0)
+
+#endif /* _ASM_SCORE_PGALLOC_H */
diff --git a/arch/score/include/asm/pgtable-bits.h 
b/arch/score/include/asm/pgtable-bits.h
new file mode 100644
index 0000000..ca16d35
--- /dev/null
+++ b/arch/score/include/asm/pgtable-bits.h
@@ -0,0 +1,23 @@
+#ifndef _ASM_SCORE_PGTABLE_BITS_H
+#define _ASM_SCORE_PGTABLE_BITS_H
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
+
+#define _PAGE_CHG_MASK                 \
+       (PAGE_MASK | _PAGE_ACCESSED | _PAGE_MODIFIED | _PAGE_CACHE)
+
+#endif /* _ASM_SCORE_PGTABLE_BITS_H */
diff --git a/arch/score/include/asm/pgtable.h 
b/arch/score/include/asm/pgtable.h
new file mode 100644
index 0000000..0f7177a
--- /dev/null
+++ b/arch/score/include/asm/pgtable.h
@@ -0,0 +1,267 @@
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
+#define PGDIR_SHIFT    22
+#define PGDIR_SIZE     (_AC(1, UL) << PGDIR_SHIFT)
+#define PGDIR_MASK     (~(PGDIR_SIZE - 1))
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
+#define VMALLOC_END            (FIXADDR_START - 2*PAGE_SIZE)
+
+#define pte_ERROR(e) \
+       printk(KERN_ERR "%s:%d: bad pte %08lx.\n", \
+               __FILE__, __LINE__, pte_val(e))
+#define pgd_ERROR(e) \
+       printk(KERN_ERR "%s:%d: bad pgd %08lx.\n", \
+               __FILE__, __LINE__, pgd_val(e))
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
+#define pfn_pte(pfn, prot)     \
+       __pte(((unsigned long long)(pfn) << PAGE_SHIFT) | 
pgprot_val(prot))
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
+#define __pte_offset(address)          \
+       (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+#define pte_offset(dir, address)       \
+       ((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
+#define pte_offset_kernel(dir, address)        \
+       ((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
+
+#define pte_offset_map(dir, address)   \
+       ((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_offset_map_nested(dir, address)    \
+       ((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_unmap(pte) ((void)(pte))
+#define pte_unmap_nested(pte) ((void)(pte))
+
+/*
+ * Bits 9(_PAGE_PRESENT) and 10(_PAGE_FILE)are taken,
+ * split up 30 bits of offset into this range:
+ */
+#define PTE_FILE_MAX_BITS      30
+#define pte_to_pgoff(_pte)             \
+       (((_pte).pte & 0x1ff) | (((_pte).pte >> 11) << 9))
+#define pgoff_to_pte(off)              \
+       ((pte_t) {((off) & 0x1ff) | (((off) >> 9) << 11) | _PAGE_FILE})
+#define __pte_to_swp_entry(pte)                \
+       ((swp_entry_t) { pte_val(pte)})
+#define __swp_entry_to_pte(x)  ((pte_t) {(x).val})
+
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
+#define pmd_page(pmd) virt_to_page(__va(pmd_val(pmd)))
+#define mk_pte(page, prot)     pfn_pte(page_to_pfn(page), prot)
+static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
+
+#define set_pte(pteptr, pteval) (*(pteptr) = pteval)
+#define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
+#define pte_clear(mm, addr, xp)                \
+       do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
+
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)                \
+               remap_pfn_range(vma, vaddr, pfn, size, prot)
+
+#define pgd_present(pgd)       (1) /* pages are always present on non MMU 
*/
+#define pgd_none(pgd)          (0)
+#define pgd_bad(pgd)           (0)
+#define pgd_clear(pgdp)
+
+#define kern_addr_valid(addr)  (1)
+#define        pmd_offset(a, b)        ((void *) 0)
+#define pmd_page_vaddr(pmd)    pmd_val(pmd)
+
+#define pte_none(pte)          (!(pte_val(pte) & ~_PAGE_GLOBAL))
+#define pte_present(pte)       (pte_val(pte) & _PAGE_PRESENT)
+
+#define pud_offset(pgd, address) ((pud_t *) pgd)
+
+#define PAGE_NONE              __pgprot(0) /* these mean nothing to non 
MMU */
+#define PAGE_SHARED            __pgprot(0) /* these mean nothing to non 
MMU */
+#define PAGE_COPY              __pgprot(0) /* these mean nothing to non 
MMU */
+#define PAGE_READONLY          __pgprot(0) /* these mean nothing to non 
MMU */
+#define PAGE_KERNEL            __pgprot(0) /* these mean nothing to non 
MMU */
+
+#define pgprot_noncached(x)    (x)
+
+#define __swp_type(x)          (0)
+#define __swp_offset(x)                (0)
+#define __swp_entry(typ, off)  ((swp_entry_t) { ((typ) | ((off) << 7)) })
+
+#define ZERO_PAGE(vaddr)       ({ BUG(); NULL; })
+
+#define swapper_pg_dir ((pgd_t *) NULL)
+
+#define pgtable_cache_init()   do {} while (0)
+
+#define arch_enter_lazy_cpu_mode()     do {} while (0)
+
+static inline int pte_write(pte_t pte)
+{
+       return pte_val(pte) & _PAGE_WRITE;
+}
+
+static inline int pte_dirty(pte_t pte)
+{
+       return pte_val(pte) & _PAGE_MODIFIED;
+}
+
+static inline int pte_young(pte_t pte)
+{
+       return pte_val(pte) & _PAGE_ACCESSED;
+}
+
+static inline int pte_file(pte_t pte)
+{
+       return pte_val(pte) & _PAGE_FILE;
+}
+
+#define pte_special(pte)       (0)
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
+#define set_pmd(pmdptr, pmdval)                \
+        do { *(pmdptr) = (pmdval); } while (0)
+#define pte_present(pte)       (pte_val(pte) & _PAGE_PRESENT)
+
+extern unsigned long pgd_current;
+extern void paging_init(void);
+
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+{
+       return __pte((pte_val(pte) & _PAGE_CHG_MASK) | 
pgprot_val(newprot));
+}
+
+extern void __update_tlb(struct vm_area_struct *vma,
+       unsigned long address,  pte_t pte);
+extern void __update_cache(struct vm_area_struct *vma,
+       unsigned long address,  pte_t pte);
+
+static inline void update_mmu_cache(struct vm_area_struct *vma,
+       unsigned long address, pte_t pte)
+{
+       __update_tlb(vma, address, pte);
+       __update_cache(vma, address, pte);
+}
+
+#ifndef __ASSEMBLY__
+#include <asm-generic/pgtable.h>
+
+void setup_memory(void);
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_SCORE_PGTABLE_H */
diff --git a/arch/score/include/asm/poll.h b/arch/score/include/asm/poll.h
new file mode 100644
index 0000000..18532db
--- /dev/null
+++ b/arch/score/include/asm/poll.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_POLL_H
+#define _ASM_SCORE_POLL_H
+
+#include <asm-generic/poll.h>
+
+#endif /* _ASM_SCORE_POLL_H */
diff --git a/arch/score/include/asm/posix_types.h 
b/arch/score/include/asm/posix_types.h
new file mode 100644
index 0000000..b88acf8
--- /dev/null
+++ b/arch/score/include/asm/posix_types.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_POSIX_TYPES_H
+#define _ASM_SCORE_POSIX_TYPES_H
+
+#include <asm-generic/posix_types.h>
+
+#endif /* _ASM_SCORE_POSIX_TYPES_H */
diff --git a/arch/score/include/asm/processor.h 
b/arch/score/include/asm/processor.h
new file mode 100644
index 0000000..7e22f21
--- /dev/null
+++ b/arch/score/include/asm/processor.h
@@ -0,0 +1,106 @@
+#ifndef _ASM_SCORE_PROCESSOR_H
+#define _ASM_SCORE_PROCESSOR_H
+
+#include <linux/cpumask.h>
+#include <linux/threads.h>
+
+#include <asm/segment.h>
+
+struct task_struct;
+
+/*
+ * System setup and hardware flags..
+ */
+extern void (*cpu_wait)(void);
+
+extern long kernel_thread(int (*fn)(void *), void *arg, unsigned long 
flags);
+extern unsigned long thread_saved_pc(struct task_struct *tsk);
+extern void start_thread(struct pt_regs *regs,
+                       unsigned long pc, unsigned long sp);
+extern unsigned long get_wchan(struct task_struct *p);
+
+/*
+ * Return current * instruction pointer ("program counter").
+ */
+#define current_text_addr() ({ __label__ _l; _l: &&_l; })
+
+#define cpu_relax()            barrier()
+#define release_thread(thread) do {} while (0)
+#define prepare_to_copy(tsk)   do {} while (0)
+
+/*
+ * User space process size: 2GB. This is hardcoded into a few places,
+ * so don't change it unless you know what you are doing.
+ */
+#define TASK_SIZE      0x7fff8000UL
+
+/*
+ * This decides where the kernel will search for a free chunk of vm
+ * space during mmap's.
+ */
+#define TASK_UNMAPPED_BASE     ((TASK_SIZE / 3) & ~(PAGE_SIZE))
+
+#ifdef __KERNEL__
+#define STACK_TOP      TASK_SIZE
+#define STACK_TOP_MAX  TASK_SIZE
+#endif
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
+       .cp0_psr                = 0,                            \
+       .error_code             = 0,                            \
+       .trap_no                = 0,                            \
+}
+
+#define kstk_tos(tsk)          \
+       ((unsigned long)task_stack_page(tsk) + THREAD_SIZE - 32)
+#define task_pt_regs(tsk)      ((struct pt_regs *)kstk_tos(tsk) - 1)
+
+#define KSTK_EIP(tsk)          (task_pt_regs(tsk)->cp0_epc)
+#define KSTK_ESP(tsk)          (task_pt_regs(tsk)->regs[29])
+
+#endif /* _ASM_SCORE_PROCESSOR_H */
diff --git a/arch/score/include/asm/ptrace.h 
b/arch/score/include/asm/ptrace.h
new file mode 100644
index 0000000..1a4900a
--- /dev/null
+++ b/arch/score/include/asm/ptrace.h
@@ -0,0 +1,87 @@
+#ifndef _ASM_SCORE_PTRACE_H
+#define _ASM_SCORE_PTRACE_H
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
+#define B16_SET (J16 | B16 | BR16)
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
+#endif /* _ASM_SCORE_PTRACE_H */
-- 
1.6.2


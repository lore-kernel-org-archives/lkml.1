Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbXLTBSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbXLTBSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbXLTBS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:18:26 -0500
Received: from 225.sub-75-208-182.myvzw.com ([75.208.182.225]:46374 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752944AbXLTBSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:18:24 -0500
Message-Id: <20071219223604.441332404@goop.org>
References: <20071219223534.129042140@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 19 Dec 2007 14:35:35 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: [PATCH 1/5] x86: clean up asm-x86/page*.h
Content-Disposition: inline; filename=x86-unify-page_h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify common definitions in page*.h.  To simplify other code, I added
typedefs for the value of pte/pmd/pud/pgd values, so they can be used
symbolically elsewhere without needing to have lots of 32/64/PAE
tests.

Also, add PAGETABLE_LEVELS define so that other definitions can test
for it directly rather than using indirect 32/64/PAE tests.

Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>

---
 arch/x86/mm/init_32.c        |    2 
 include/asm-x86/Kbuild       |    3 
 include/asm-x86/page.h       |  347 ++++++++++++++++++++++++++++++++++++++++--
 include/asm-x86/page_32.h    |  233 ----------------------------
 include/asm-x86/page_64.h    |  158 -------------------
 include/asm-x86/pgtable_64.h |   31 +--
 6 files changed, 355 insertions(+), 419 deletions(-)

===================================================================
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -44,7 +44,7 @@
 #include <asm/sections.h>
 #include <asm/paravirt.h>
 
-unsigned int __VMALLOC_RESERVE = 128 << 20;
+unsigned long __VMALLOC_RESERVE = 128 << 20;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 unsigned long highstart_pfn, highend_pfn;
===================================================================
--- a/include/asm-x86/Kbuild
+++ b/include/asm-x86/Kbuild
@@ -15,8 +15,7 @@ unifdef-y += mce.h
 unifdef-y += mce.h
 unifdef-y += msr.h
 unifdef-y += mtrr.h
-unifdef-y += page_32.h
-unifdef-y += page_64.h
+unifdef-y += page.h
 unifdef-y += posix_types_32.h
 unifdef-y += posix_types_64.h
 unifdef-y += ptrace.h
===================================================================
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -1,13 +1,340 @@
+#ifndef _ASM_X86_PAGE_H
+#define _ASM_X86_PAGE_H
+
+#include <linux/const.h>
+#include <linux/compiler.h>
+
+/* PAGE_SHIFT determines the page size */
+#define PAGE_SHIFT	12
+#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
+#define PAGE_MASK	(~(PAGE_SIZE-1))
+#define PHYSICAL_PAGE_MASK	(~(PAGE_SIZE-1) & __PHYSICAL_MASK)
+
+#define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
+#define LARGE_PAGE_SIZE (_AC(1,UL) << PMD_SHIFT)
+
+#define HPAGE_SIZE	(_AC(1,UL) << HPAGE_SHIFT)
+#define HPAGE_MASK	(~(HPAGE_SIZE - 1))
+#define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
+
 #ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "page_32.h"
-# else
-#  include "page_64.h"
-# endif
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#endif /* !__ASSEMBLY__ */
+
+#ifdef CONFIG_X86_32
+#ifndef __ASSEMBLY__
+#ifdef CONFIG_X86_USE_3DNOW
+
+#include <asm/mmx.h>
+
+static inline void clear_page(void *page)
+{
+	mmx_clear_page(page);
+}
+
+static inline void copy_page(void *to, void *from)
+{
+	mmx_copy_page(to, from);
+}
+
+#else  /* !CONFIG_X86_USE_3DNOW */
+
+/*
+ *	On older X86 processors it's not a win to use MMX here it seems.
+ *	Maybe the K6-III ?
+ */
+
+#define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
+#define copy_page(to,from)	memcpy((void *)(to), (void *)(from), PAGE_SIZE)
+
+#endif	/* CONFIG_X86_USE_3DNOW */
+
+extern unsigned long __VMALLOC_RESERVE;
+extern int nx_enabled;
+#define __phys_addr(x)		((unsigned long)(x)-PAGE_OFFSET)
+
+#endif /* !__ASSEMBLY__ */
+
+#define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
+
+#define VMALLOC_RESERVE		(__VMALLOC_RESERVE)
+#define MAXMEM			(-__PAGE_OFFSET-__VMALLOC_RESERVE)
+
+#ifdef CONFIG_HUGETLB_PAGE
+#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
+#endif
+
+#ifndef CONFIG_X86_PAE
+/*
+ * 32 bit mode.  2 level pagetable, 32 bit physical, 32 bit virtual
+ */
+#define PAGETABLE_LEVELS	2
+#define __PHYSICAL_MASK_SHIFT	32
+#define __VIRTUAL_MASK_SHIFT	32
+#define HPAGE_SHIFT		PGDIR_SHIFT
+
+#ifndef __ASSEMBLY__
+typedef u32	pteval_t;
+typedef u32	pmdval_t;
+typedef u32	pudval_t;
+typedef u32	pgdval_t;
+typedef u32	pgprotval_t;
+
+typedef struct { unsigned long pte_low; } pte_t, boot_pte_t;
+
+static inline pteval_t native_pte_val(pte_t pte)
+{
+	return pte.pte_low;
+}
+
+static inline pte_t native_make_pte(pteval_t val)
+{
+	return (pte_t) { val };
+}
+#endif	/* __ASSEMBLY__ */
+
+#else	/* CONFIG_X86_PAE */
+/*
+ * 32 bit PAE mode.  3 level pagetable, 36 bit physical, 32 bit virtual
+ */
+#define PAGETABLE_LEVELS	3
+#define __PHYSICAL_MASK_SHIFT	36
+#define __VIRTUAL_MASK_SHIFT	32
+#define HPAGE_SHIFT		PMD_SHIFT
+
+#ifndef __ASSEMBLY__
+typedef u64	pteval_t;
+typedef u64	pmdval_t;
+typedef u64	pudval_t;
+typedef u64	pgdval_t;
+typedef u64	pgprotval_t;
+
+typedef struct { unsigned long pte_low, pte_high; } pte_t;
+
+static inline pteval_t native_pte_val(pte_t pte)
+{
+	return pte.pte_low | ((unsigned long long)pte.pte_high << 32);
+}
+
+static inline pte_t native_make_pte(pteval_t val)
+{
+	return (pte_t) { .pte_low = val, .pte_high = (val >> 32) } ;
+}
+#endif	/* __ASSEMBLY__ */
+
+#endif	 /* CONFIG_X86_PAE */
+
+#else  /* !CONFIG_X86_32 */
+/*
+ *  64 bit mode.  4 level pagetable, 46 bit physical, 48 bit virtual
+ */
+#define PAGETABLE_LEVELS	4
+#define __PHYSICAL_MASK_SHIFT	46
+#define __VIRTUAL_MASK_SHIFT	48
+#define HPAGE_SHIFT		PMD_SHIFT
+
+#ifndef __ASSEMBLY__
+typedef u64	pteval_t;
+typedef u64	pmdval_t;
+typedef u64	pudval_t;
+typedef u64	pgdval_t;
+typedef u64	pgprotval_t;
+
+typedef struct { pteval_t pte; } pte_t;
+
+static inline pteval_t native_pte_val(pte_t pte)
+{
+	return pte.pte;
+}
+
+static inline pte_t native_make_pte(pteval_t pte)
+{
+	return (pte_t){ pte };
+}
+
+extern unsigned long phys_base;
+extern unsigned long end_pfn;
+extern unsigned long end_pfn_map;
+
+void clear_page(void *);
+void copy_page(void *, void *);
+unsigned long __phys_addr(unsigned long);
+
+struct page;
+
+static inline void clear_user_page(void *page, unsigned long vaddr, struct page *pg)
+{
+	clear_page(page);
+}
+
+static inline void copy_user_page(void *to, void *from, unsigned long vaddr, struct page *topg)
+{
+	copy_page(to, from);
+}
+
+#endif	/* __ASSEMBLY__ */
+#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
+	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
+#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
+
+#ifdef CONFIG_THREAD_ORDER
+# define THREAD_ORDER  CONFIG_THREAD_ORDER
 #else
-# ifdef __i386__
-#  include "page_32.h"
-# else
-#  include "page_64.h"
-# endif
+# define THREAD_ORDER  1
 #endif
+#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
+#define CURRENT_MASK (~(THREAD_SIZE-1))
+
+#define EXCEPTION_STACK_ORDER 0
+#define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
+
+#define DEBUG_STACK_ORDER (EXCEPTION_STACK_ORDER + 1)
+#define DEBUG_STKSZ (PAGE_SIZE << DEBUG_STACK_ORDER)
+
+#define IRQSTACK_ORDER 2
+#define IRQSTACKSIZE (PAGE_SIZE << IRQSTACK_ORDER)
+
+#define STACKFAULT_STACK 1
+#define DOUBLEFAULT_STACK 2
+#define NMI_STACK 3
+#define DEBUG_STACK 4
+#define MCE_STACK 5
+#define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
+
+#define __PHYSICAL_START	CONFIG_PHYSICAL_START
+#define __KERNEL_ALIGN		0x200000
+
+#define KERNEL_TEXT_SIZE  (40*1024*1024)
+#define KERNEL_TEXT_START _AC(0xffffffff80000000, UL)
+
+/*
+ * Make sure kernel is aligned to 2MB address. Catching it at compile
+ * time is better. Change your config file and compile the kernel
+ * for a 2MB aligned address (CONFIG_PHYSICAL_START)
+ */
+#if (CONFIG_PHYSICAL_START % __KERNEL_ALIGN) != 0
+#error "CONFIG_PHYSICAL_START must be a multiple of 2MB"
+#endif
+
+#define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
+#define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
+#define __PAGE_OFFSET           _AC(0xffff810000000000, UL)
+
+#define vmemmap ((struct page *)VMEMMAP_START)
+
+#endif	/* CONFIG_X86_32 */
+
+#ifndef __ASSEMBLY__
+typedef struct { pgprotval_t pgprot; } pgprot_t;
+typedef struct { pgdval_t pgd; } pgd_t;
+
+/* Macro so it can be used as lvalue */
+#define pgprot_val(prot)	((prot).pgprot)
+
+/* Must be macro so it can be used in initializers */
+#define __pgprot(x) ((pgprot_t) { (x) })
+
+static inline pgdval_t native_pgd_val(pgd_t pgd)
+{
+	return pgd.pgd;
+}
+
+static inline pgd_t native_make_pgd(pgdval_t val)
+{
+	return (pgd_t) { val };
+}
+
+#if PAGETABLE_LEVELS >= 3
+
+typedef struct { pmdval_t pmd; } pmd_t;
+
+static inline pmdval_t native_pmd_val(pmd_t pmd)
+{
+	return pmd.pmd;
+}
+
+static inline pmd_t native_make_pmd(unsigned long long pmd)
+{
+	return (pmd_t){ pmd };
+}
+
+#if PAGETABLE_LEVELS == 4
+
+typedef struct { pudval_t pud; } pud_t;
+
+static inline pud_t native_make_pud(unsigned long long pud)
+{
+	return (pud_t){ pud };
+}
+
+static inline pudval_t native_pud_val(pud_t pud)
+{
+	return pud.pud;
+}
+#else  /* PAGETABLE_LEVELS == 3 */
+#include <asm-generic/pgtable-nopud.h>
+#endif	/* PAGETABLE_LEVELS == 4 */
+#else  /* PAGETABLE_LEVELS == 2 */
+#include <asm-generic/pgtable-nopmd.h>
+#endif	/* PAGETABLE_LEVELS >= 3 */
+#endif	/* __ASSEMBLY__ */
+
+#ifndef CONFIG_PARAVIRT
+#define pgd_val(x)	native_pgd_val(x)
+#define __pgd(x)	native_make_pgd(x)
+
+#ifndef __PAGETABLE_PUD_FOLDED
+# define pud_val(x)	native_pud_val(x)
+# define __pud(x)	native_make_pud(x)
+#endif
+
+#ifndef __PAGETABLE_PMD_FOLDED
+# define pmd_val(x)	native_pmd_val(x)
+# define __pmd(x)	native_make_pmd(x)
+#endif
+
+#define pte_val(x)	native_pte_val(x)
+#define __pte(x)	native_make_pte(x)
+#endif	/* CONFIG_PARAVIRT */
+
+#define PTE_MASK	PHYSICAL_PAGE_MASK
+
+#define __PHYSICAL_MASK		((_AC(1,ULL) << __PHYSICAL_MASK_SHIFT) - 1)
+#define __VIRTUAL_MASK		((_AC(1,ULL) << __VIRTUAL_MASK_SHIFT) - 1)
+
+#define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
+
+/* to align the pointer to the (next) page boundary */
+#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
+
+#define __pa(x)		__phys_addr((unsigned long)(x))
+#define __pa_symbol(x)	__phys_addr(RELOC_HIDE((unsigned long)(x), 0))
+#define __va(x)		((void *)((unsigned long)(x)+PAGE_OFFSET))
+
+#ifdef CONFIG_FLATMEM
+#define pfn_valid(pfn)		((pfn) < max_mapnr)
+#endif /* CONFIG_FLATMEM */
+#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
+#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
+#define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
+
+#define VM_DATA_DEFAULT_FLAGS \
+	(((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
+	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+#define clear_user_page(page, vaddr, pg)	clear_page(page)
+#define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
+
+#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
+	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
+#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
+
+#define __HAVE_ARCH_GATE_AREA 1
+
+#include <asm-generic/memory_model.h>
+#include <asm-generic/page.h>
+
+#endif	/* __KERNEL__ */
+#endif	/* _ASM_X86_PAGE_H */
===================================================================
--- a/include/asm-x86/page_32.h
+++ /dev/null
@@ -1,233 +0,0 @@
-#ifndef _I386_PAGE_H
-#define _I386_PAGE_H
-
-/* PAGE_SHIFT determines the page size */
-#define PAGE_SHIFT	12
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
-#define PAGE_MASK	(~(PAGE_SIZE-1))
-
-#define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
-#define LARGE_PAGE_SIZE (1UL << PMD_SHIFT)
-
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-
-#include <linux/string.h>
-
-#ifdef CONFIG_X86_USE_3DNOW
-
-#include <asm/mmx.h>
-
-static inline void clear_page(void *page)
-{
-	mmx_clear_page(page);
-}
-
-static inline void copy_page(void *to, void *from)
-{
-	mmx_copy_page(to, from);
-}
-
-#else
-
-/*
- *	On older X86 processors it's not a win to use MMX here it seems.
- *	Maybe the K6-III ?
- */
- 
-static inline void clear_page(void *page)
-{
-	memset(page, 0, PAGE_SIZE);
-}
-
-static inline void copy_page(void *to, void *from)
-{
-	memcpy(to, from, PAGE_SIZE);
-}
-
-#endif
-
-struct page;
-
-static void inline clear_user_page(void *page, unsigned long vaddr,
-				struct page *pg)
-{
-	clear_page(page);
-}
-
-static void inline copy_user_page(void *to, void *from, unsigned long vaddr,
-				struct page *topage)
-{
-	copy_page(to, from);
-}
-
-#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
-
-/*
- * These are used to make use of C type-checking..
- */
-extern int nx_enabled;
-
-#ifdef CONFIG_X86_PAE
-typedef struct { unsigned long pte_low, pte_high; } pte_t;
-typedef struct { unsigned long long pmd; } pmd_t;
-typedef struct { unsigned long long pgd; } pgd_t;
-typedef struct { unsigned long long pgprot; } pgprot_t;
-
-static inline unsigned long long native_pgd_val(pgd_t pgd)
-{
-	return pgd.pgd;
-}
-
-static inline unsigned long long native_pmd_val(pmd_t pmd)
-{
-	return pmd.pmd;
-}
-
-static inline unsigned long long native_pte_val(pte_t pte)
-{
-	return pte.pte_low | ((unsigned long long)pte.pte_high << 32);
-}
-
-static inline pgd_t native_make_pgd(unsigned long long val)
-{
-	return (pgd_t) { val };
-}
-
-static inline pmd_t native_make_pmd(unsigned long long val)
-{
-	return (pmd_t) { val };
-}
-
-static inline pte_t native_make_pte(unsigned long long val)
-{
-	return (pte_t) { .pte_low = val, .pte_high = (val >> 32) } ;
-}
-
-#ifndef CONFIG_PARAVIRT
-#define pmd_val(x)	native_pmd_val(x)
-#define __pmd(x)	native_make_pmd(x)
-#endif
-
-#define HPAGE_SHIFT	21
-#include <asm-generic/pgtable-nopud.h>
-#else  /* !CONFIG_X86_PAE */
-typedef struct { unsigned long pte_low; } pte_t;
-typedef struct { unsigned long pgd; } pgd_t;
-typedef struct { unsigned long pgprot; } pgprot_t;
-#define boot_pte_t pte_t /* or would you rather have a typedef */
-
-static inline unsigned long native_pgd_val(pgd_t pgd)
-{
-	return pgd.pgd;
-}
-
-static inline unsigned long native_pte_val(pte_t pte)
-{
-	return pte.pte_low;
-}
-
-static inline pgd_t native_make_pgd(unsigned long val)
-{
-	return (pgd_t) { val };
-}
-
-static inline pte_t native_make_pte(unsigned long val)
-{
-	return (pte_t) { .pte_low = val };
-}
-
-#define HPAGE_SHIFT	22
-#include <asm-generic/pgtable-nopmd.h>
-#endif	/* CONFIG_X86_PAE */
-
-#define PTE_MASK	PAGE_MASK
-
-#ifdef CONFIG_HUGETLB_PAGE
-#define HPAGE_SIZE	((1UL) << HPAGE_SHIFT)
-#define HPAGE_MASK	(~(HPAGE_SIZE - 1))
-#define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
-#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
-#endif
-
-#define pgprot_val(x)	((x).pgprot)
-#define __pgprot(x)	((pgprot_t) { (x) } )
-
-#ifndef CONFIG_PARAVIRT
-#define pgd_val(x)	native_pgd_val(x)
-#define __pgd(x)	native_make_pgd(x)
-#define pte_val(x)	native_pte_val(x)
-#define __pte(x)	native_make_pte(x)
-#endif
-
-#endif /* !__ASSEMBLY__ */
-
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
-/*
- * This handles the memory map.. We could make this a config
- * option, but too many people screw it up, and too few need
- * it.
- *
- * A __PAGE_OFFSET of 0xC0000000 means that the kernel has
- * a virtual address space of one gigabyte, which limits the
- * amount of physical memory you can use to about 950MB. 
- *
- * If you want more physical memory than this then see the CONFIG_HIGHMEM4G
- * and CONFIG_HIGHMEM64G options in the kernel configuration.
- */
-
-#ifndef __ASSEMBLY__
-
-struct vm_area_struct;
-
-/*
- * This much address space is reserved for vmalloc() and iomap()
- * as well as fixmap mappings.
- */
-extern unsigned int __VMALLOC_RESERVE;
-
-extern int sysctl_legacy_va_layout;
-
-extern int page_is_ram(unsigned long pagenr);
-
-#endif /* __ASSEMBLY__ */
-
-#ifdef __ASSEMBLY__
-#define __PAGE_OFFSET		CONFIG_PAGE_OFFSET
-#else
-#define __PAGE_OFFSET		((unsigned long)CONFIG_PAGE_OFFSET)
-#endif
-
-
-#define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
-#define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
-#define MAXMEM			(-__PAGE_OFFSET-__VMALLOC_RESERVE)
-#define __pa(x)			((unsigned long)(x)-PAGE_OFFSET)
-/* __pa_symbol should be used for C visible symbols.
-   This seems to be the official gcc blessed way to do such arithmetic. */
-#define __pa_symbol(x)          __pa(RELOC_HIDE((unsigned long)(x),0))
-#define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
-#define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
-#ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn)		((pfn) < max_mapnr)
-#endif /* CONFIG_FLATMEM */
-#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
-
-#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
-
-#define VM_DATA_DEFAULT_FLAGS \
-	(VM_READ | VM_WRITE | \
-	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
-		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
-#include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
-
-#define __HAVE_ARCH_GATE_AREA 1
-#endif /* __KERNEL__ */
-
-#endif /* _I386_PAGE_H */
===================================================================
--- a/include/asm-x86/page_64.h
+++ /dev/null
@@ -1,158 +0,0 @@
-#ifndef _X86_64_PAGE_H
-#define _X86_64_PAGE_H
-
-#include <linux/const.h>
-
-/* PAGE_SHIFT determines the page size */
-#define PAGE_SHIFT	12
-#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
-#define PAGE_MASK	(~(PAGE_SIZE-1))
-#define PHYSICAL_PAGE_MASK	(~(PAGE_SIZE-1) & __PHYSICAL_MASK)
-
-#ifdef CONFIG_THREAD_ORDER
-# define THREAD_ORDER	CONFIG_THREAD_ORDER
-#else
-# define THREAD_ORDER	1
-#endif
-
-#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
-#define CURRENT_MASK (~(THREAD_SIZE-1))
-
-#define EXCEPTION_STACK_ORDER 0
-#define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
-
-#define DEBUG_STACK_ORDER (EXCEPTION_STACK_ORDER + 1)
-#define DEBUG_STKSZ (PAGE_SIZE << DEBUG_STACK_ORDER)
-
-#define IRQSTACK_ORDER 2
-#define IRQSTACKSIZE (PAGE_SIZE << IRQSTACK_ORDER)
-
-#define STACKFAULT_STACK 1
-#define DOUBLEFAULT_STACK 2
-#define NMI_STACK 3
-#define DEBUG_STACK 4
-#define MCE_STACK 5
-#define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
-
-#define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
-#define LARGE_PAGE_SIZE (_AC(1,UL) << PMD_SHIFT)
-
-#define HPAGE_SHIFT PMD_SHIFT
-#define HPAGE_SIZE	(_AC(1,UL) << HPAGE_SHIFT)
-#define HPAGE_MASK	(~(HPAGE_SIZE - 1))
-#define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
-
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-
-extern unsigned long end_pfn;
-extern unsigned long end_pfn_map;
-
-void clear_page(void *page);
-void copy_page(void *to, void *from);
-
-struct page;
-
-static void inline clear_user_page(void *page, unsigned long vaddr,
-				struct page *pg)
-{
-	clear_page(page);
-}
-
-static void inline copy_user_page(void *to, void *from, unsigned long vaddr,
-				struct page *topage)
-{
-	copy_page(to, from);
-}
-
-#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
-/*
- * These are used to make use of C type-checking..
- */
-typedef struct { unsigned long pte; } pte_t;
-typedef struct { unsigned long pmd; } pmd_t;
-typedef struct { unsigned long pud; } pud_t;
-typedef struct { unsigned long pgd; } pgd_t;
-#define PTE_MASK	PHYSICAL_PAGE_MASK
-
-typedef struct { unsigned long pgprot; } pgprot_t;
-
-extern unsigned long phys_base;
-
-#define pte_val(x)	((x).pte)
-#define pmd_val(x)	((x).pmd)
-#define pud_val(x)	((x).pud)
-#define pgd_val(x)	((x).pgd)
-#define pgprot_val(x)	((x).pgprot)
-
-#define __pte(x) ((pte_t) { (x) } )
-#define __pmd(x) ((pmd_t) { (x) } )
-#define __pud(x) ((pud_t) { (x) } )
-#define __pgd(x) ((pgd_t) { (x) } )
-#define __pgprot(x)	((pgprot_t) { (x) } )
-
-#endif /* !__ASSEMBLY__ */
-
-#define __PHYSICAL_START	CONFIG_PHYSICAL_START
-#define __KERNEL_ALIGN		0x200000
-
-/*
- * Make sure kernel is aligned to 2MB address. Catching it at compile
- * time is better. Change your config file and compile the kernel
- * for a 2MB aligned address (CONFIG_PHYSICAL_START)
- */
-#if (CONFIG_PHYSICAL_START % __KERNEL_ALIGN) != 0
-#error "CONFIG_PHYSICAL_START must be a multiple of 2MB"
-#endif
-
-#define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
-#define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
-#define __PAGE_OFFSET           _AC(0xffff810000000000, UL)
-
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
-/* See Documentation/x86_64/mm.txt for a description of the memory map. */
-#define __PHYSICAL_MASK_SHIFT	46
-#define __PHYSICAL_MASK		((_AC(1,UL) << __PHYSICAL_MASK_SHIFT) - 1)
-#define __VIRTUAL_MASK_SHIFT	48
-#define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
-
-#define KERNEL_TEXT_SIZE  (40*1024*1024)
-#define KERNEL_TEXT_START _AC(0xffffffff80000000, UL)
-#define PAGE_OFFSET		__PAGE_OFFSET
-
-#ifndef __ASSEMBLY__
-
-#include <asm/bug.h>
-
-extern unsigned long __phys_addr(unsigned long);
-
-#endif /* __ASSEMBLY__ */
-
-#define __pa(x)		__phys_addr((unsigned long)(x))
-#define __pa_symbol(x)	__phys_addr((unsigned long)(x))
-
-#define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
-#define __boot_va(x)		__va(x)
-#define __boot_pa(x)		__pa(x)
-
-#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
-#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
-#define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
-
-#define VM_DATA_DEFAULT_FLAGS \
-	(((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
-	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
-#define __HAVE_ARCH_GATE_AREA 1	
-#define vmemmap ((struct page *)VMEMMAP_START)
-
-#include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* _X86_64_PAGE_H */
===================================================================
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -73,18 +73,18 @@ extern unsigned long empty_zero_page[PAG
 
 static inline void set_pte(pte_t *dst, pte_t val)
 {
-	pte_val(*dst) = pte_val(val);
+	*dst = val;
 } 
 #define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
 
 static inline void set_pmd(pmd_t *dst, pmd_t val)
 {
-        pmd_val(*dst) = pmd_val(val); 
+        *dst = val;
 } 
 
 static inline void set_pud(pud_t *dst, pud_t val)
 {
-	pud_val(*dst) = pud_val(val);
+	*dst = val;
 }
 
 static inline void pud_clear (pud_t *pud)
@@ -94,7 +94,7 @@ static inline void pud_clear (pud_t *pud
 
 static inline void set_pgd(pgd_t *dst, pgd_t val)
 {
-	pgd_val(*dst) = pgd_val(val); 
+	*dst = val;
 } 
 
 static inline void pgd_clear (pgd_t * pgd)
@@ -258,11 +258,11 @@ static inline unsigned long pmd_bad(pmd_
 
 static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
 {
-	pte_t pte;
-	pte_val(pte) = (page_nr << PAGE_SHIFT);
-	pte_val(pte) |= pgprot_val(pgprot);
-	pte_val(pte) &= __supported_pte_mask;
-	return pte;
+	pteval_t pte;
+	pte = (page_nr << PAGE_SHIFT);
+	pte |= pgprot_val(pgprot);
+	pte &= __supported_pte_mask;
+	return __pte(pte);
 }
 
 /*
@@ -292,12 +292,12 @@ static inline int ptep_test_and_clear_yo
 {
 	if (!pte_young(*ptep))
 		return 0;
-	return test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte);
+	return test_and_clear_bit(_PAGE_BIT_ACCESSED, (unsigned long *)&ptep->pte);
 }
 
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	clear_bit(_PAGE_BIT_RW, &ptep->pte);
+	clear_bit(_PAGE_BIT_RW, (unsigned long *)&ptep->pte);
 }
 
 /*
@@ -359,10 +359,11 @@ static inline int pmd_large(pmd_t pte) {
 /* Change flags of a PTE */
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 { 
-	pte_val(pte) &= _PAGE_CHG_MASK;
-	pte_val(pte) |= pgprot_val(newprot);
-	pte_val(pte) &= __supported_pte_mask;
-       return pte; 
+	pteval_t val = pte_val(pte);
+	val &= _PAGE_CHG_MASK;
+	val |= pgprot_val(newprot);
+	val &= __supported_pte_mask;
+	return __pte(val);
 }
 
 #define pte_index(address) \

-- 


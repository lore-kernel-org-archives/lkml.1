Return-Path: <linux-kernel-owner+w=401wt.eu-S1763473AbZE0Hek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763473AbZE0Hek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762471AbZE0H12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:27:28 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46942 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762455AbZE0H10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:27:26 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 11/29] microblaze_mmu_v2: pgalloc.h and page.h
Date: Wed, 27 May 2009 08:47:36 +0200
Message-Id: <1243406874-3917-12-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-11-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
 <1243406874-3917-6-git-send-email-monstr@monstr.eu>
 <1243406874-3917-7-git-send-email-monstr@monstr.eu>
 <1243406874-3917-8-git-send-email-monstr@monstr.eu>
 <1243406874-3917-9-git-send-email-monstr@monstr.eu>
 <1243406874-3917-10-git-send-email-monstr@monstr.eu>
 <1243406874-3917-11-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/page.h    |  166 +++++++++++++++++++++--------
 arch/microblaze/include/asm/pgalloc.h |  191 +++++++++++++++++++++++++++++++++
 2 files changed, 314 insertions(+), 43 deletions(-)

diff --git a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
index 7238dcf..210e584 100644
--- a/arch/microblaze/include/asm/page.h
+++ b/arch/microblaze/include/asm/page.h
@@ -1,6 +1,8 @@
 /*
- * Copyright (C) 2008 Michal Simek
- * Copyright (C) 2008 PetaLogix
+ * VM ops
+ *
+ * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2008-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  * Changes for MMU support:
  *    Copyright (C) 2007 Xilinx, Inc.  All rights reserved.
@@ -15,14 +17,15 @@
 
 #include <linux/pfn.h>
 #include <asm/setup.h>
+#include <linux/const.h>
+
+#ifdef __KERNEL__
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	(12)
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
-#ifdef __KERNEL__
-
 #ifndef __ASSEMBLY__
 
 #define PAGE_UP(addr)	(((addr)+((PAGE_SIZE)-1))&(~((PAGE_SIZE)-1)))
@@ -35,6 +38,7 @@
 /* align addr on a size boundary - adjust address up if needed */
 #define _ALIGN(addr, size)	_ALIGN_UP(addr, size)
 
+#ifndef CONFIG_MMU
 /*
  * PAGE_OFFSET -- the first address of the first page of memory. When not
  * using MMU this corresponds to the first free page in physical memory (aligned
@@ -43,15 +47,44 @@
 extern unsigned int __page_offset;
 #define PAGE_OFFSET __page_offset
 
-#define copy_page(to, from)			memcpy((to), (from), PAGE_SIZE)
-#define get_user_page(vaddr)			__get_free_page(GFP_KERNEL)
-#define free_user_page(page, addr)		free_page(addr)
+#else /* CONFIG_MMU */
 
-#define clear_page(pgaddr)			memset((pgaddr), 0, PAGE_SIZE)
+/*
+ * PAGE_OFFSET -- the first address of the first page of memory. With MMU
+ * it is set to the kernel start address (aligned on a page boundary).
+ *
+ * CONFIG_KERNEL_START is defined in arch/microblaze/config.in and used
+ * in arch/microblaze/Makefile.
+ */
+#define PAGE_OFFSET	CONFIG_KERNEL_START
 
+/*
+ * MAP_NR -- given an address, calculate the index of the page struct which
+ * points to the address's page.
+ */
+#define MAP_NR(addr) (((unsigned long)(addr) - PAGE_OFFSET) >> PAGE_SHIFT)
 
-#define clear_user_page(pgaddr, vaddr, page)	memset((pgaddr), 0, PAGE_SIZE)
-#define copy_user_page(vto, vfrom, vaddr, topg) \
+/*
+ * The basic type of a PTE - 32 bit physical addressing.
+ */
+typedef unsigned long pte_basic_t;
+#define PTE_SHIFT	(PAGE_SHIFT - 2)	/* 1024 ptes per page */
+#define PTE_FMT		"%.8lx"
+
+#endif /* CONFIG_MMU */
+
+#  ifndef CONFIG_MMU
+#  define copy_page(to, from)			memcpy((to), (from), PAGE_SIZE)
+#  define get_user_page(vaddr)			__get_free_page(GFP_KERNEL)
+#  define free_user_page(page, addr)		free_page(addr)
+#  else /* CONFIG_MMU */
+extern void copy_page(void *to, void *from);
+#  endif /* CONFIG_MMU */
+
+# define clear_page(pgaddr)			memset((pgaddr), 0, PAGE_SIZE)
+
+# define clear_user_page(pgaddr, vaddr, page)	memset((pgaddr), 0, PAGE_SIZE)
+# define copy_user_page(vto, vfrom, vaddr, topg) \
 			memcpy((vto), (vfrom), PAGE_SIZE)
 
 /*
@@ -60,21 +93,32 @@ extern unsigned int __page_offset;
 typedef struct page *pgtable_t;
 typedef struct { unsigned long	pte; }		pte_t;
 typedef struct { unsigned long	pgprot; }	pgprot_t;
+/* FIXME this can depend on linux kernel version */
+#   ifdef CONFIG_MMU
+typedef struct { unsigned long pmd; } pmd_t;
+typedef struct { unsigned long pgd; } pgd_t;
+#   else /* CONFIG_MMU */
 typedef struct { unsigned long	ste[64]; }	pmd_t;
 typedef struct { pmd_t		pue[1]; }	pud_t;
 typedef struct { pud_t		pge[1]; }	pgd_t;
+#   endif /* CONFIG_MMU */
 
+# define pte_val(x)	((x).pte)
+# define pgprot_val(x)	((x).pgprot)
 
-#define pte_val(x)	((x).pte)
-#define pgprot_val(x)	((x).pgprot)
-#define pmd_val(x)	((x).ste[0])
-#define pud_val(x)	((x).pue[0])
-#define pgd_val(x)	((x).pge[0])
+#   ifdef CONFIG_MMU
+#   define pmd_val(x)      ((x).pmd)
+#   define pgd_val(x)      ((x).pgd)
+#   else  /* CONFIG_MMU */
+#   define pmd_val(x)	((x).ste[0])
+#   define pud_val(x)	((x).pue[0])
+#   define pgd_val(x)	((x).pge[0])
+#   endif  /* CONFIG_MMU */
 
-#define __pte(x)	((pte_t) { (x) })
-#define __pmd(x)	((pmd_t) { (x) })
-#define __pgd(x)	((pgd_t) { (x) })
-#define __pgprot(x)	((pgprot_t) { (x) })
+# define __pte(x)	((pte_t) { (x) })
+# define __pmd(x)	((pmd_t) { (x) })
+# define __pgd(x)	((pgd_t) { (x) })
+# define __pgprot(x)	((pgprot_t) { (x) })
 
 /**
  * Conversions for virtual address, physical address, pfn, and struct
@@ -94,44 +138,80 @@ extern unsigned long max_low_pfn;
 extern unsigned long min_low_pfn;
 extern unsigned long max_pfn;
 
-#define __pa(vaddr)		((unsigned long) (vaddr))
-#define __va(paddr)		((void *) (paddr))
+extern unsigned long memory_start;
+extern unsigned long memory_end;
+extern unsigned long memory_size;
 
-#define phys_to_pfn(phys)	(PFN_DOWN(phys))
-#define pfn_to_phys(pfn)	(PFN_PHYS(pfn))
+extern int page_is_ram(unsigned long pfn);
 
-#define virt_to_pfn(vaddr)	(phys_to_pfn((__pa(vaddr))))
-#define pfn_to_virt(pfn)	__va(pfn_to_phys((pfn)))
+# define phys_to_pfn(phys)	(PFN_DOWN(phys))
+# define pfn_to_phys(pfn)	(PFN_PHYS(pfn))
 
-#define virt_to_page(vaddr)	(pfn_to_page(virt_to_pfn(vaddr)))
-#define page_to_virt(page)	(pfn_to_virt(page_to_pfn(page)))
+# define virt_to_pfn(vaddr)	(phys_to_pfn((__pa(vaddr))))
+# define pfn_to_virt(pfn)	__va(pfn_to_phys((pfn)))
 
-#define page_to_phys(page)	(pfn_to_phys(page_to_pfn(page)))
-#define page_to_bus(page)	(page_to_phys(page))
-#define phys_to_page(paddr)	(pfn_to_page(phys_to_pfn(paddr)))
+#  ifdef CONFIG_MMU
+#  define virt_to_page(kaddr) 	(mem_map +  MAP_NR(kaddr))
+#  else /* CONFIG_MMU */
+#  define virt_to_page(vaddr)	(pfn_to_page(virt_to_pfn(vaddr)))
+#  define page_to_virt(page)	(pfn_to_virt(page_to_pfn(page)))
+#  define page_to_phys(page)	(pfn_to_phys(page_to_pfn(page)))
+#  define page_to_bus(page)	(page_to_phys(page))
+#  define phys_to_page(paddr)	(pfn_to_page(phys_to_pfn(paddr)))
+#  endif /* CONFIG_MMU */
 
-extern unsigned int memory_start;
-extern unsigned int memory_end;
-extern unsigned int memory_size;
+#  ifndef CONFIG_MMU
+#  define pfn_valid(pfn)	((pfn) >= min_low_pfn && (pfn) <= max_mapnr)
+#  define ARCH_PFN_OFFSET	(PAGE_OFFSET >> PAGE_SHIFT)
+#  else /* CONFIG_MMU */
+#  define ARCH_PFN_OFFSET	(memory_start >> PAGE_SHIFT)
+#  define pfn_valid(pfn)	((pfn) < (max_mapnr + ARCH_PFN_OFFSET))
+#  define VALID_PAGE(page) 	((page - mem_map) < max_mapnr)
+#  endif /* CONFIG_MMU */
 
-#define pfn_valid(pfn)		((pfn) >= min_low_pfn && (pfn) < max_mapnr)
+# endif /* __ASSEMBLY__ */
 
-#define ARCH_PFN_OFFSET		(PAGE_OFFSET >> PAGE_SHIFT)
+#define	virt_addr_valid(vaddr)	(pfn_valid(virt_to_pfn(vaddr)))
 
-#else
-#define tophys(rd, rs)	(addik rd, rs, 0)
-#define tovirt(rd, rs)	(addik rd, rs, 0)
-#endif /* __ASSEMBLY__ */
 
-#define virt_addr_valid(vaddr)	(pfn_valid(virt_to_pfn(vaddr)))
+#  ifndef CONFIG_MMU
+#  define __pa(vaddr)	((unsigned long) (vaddr))
+#  define __va(paddr)	((void *) (paddr))
+#  else /* CONFIG_MMU */
+#  define __pa(x)	__virt_to_phys((unsigned long)(x))
+#  define __va(x)	((void *)__phys_to_virt((unsigned long)(x)))
+#  endif /* CONFIG_MMU */
+
 
-/* Convert between virtual and physical address for MMU.  */
-/* Handle MicroBlaze processor with virtual memory.  */
+/* Convert between virtual and physical address for MMU. */
+/* Handle MicroBlaze processor with virtual memory. */
+#ifndef CONFIG_MMU
 #define __virt_to_phys(addr)	addr
 #define __phys_to_virt(addr)	addr
+#define tophys(rd, rs)	addik rd, rs, 0
+#define tovirt(rd, rs)	addik rd, rs, 0
+#else
+#define __virt_to_phys(addr) \
+	((addr) + CONFIG_KERNEL_BASE_ADDR - CONFIG_KERNEL_START)
+#define __phys_to_virt(addr) \
+	((addr) + CONFIG_KERNEL_START - CONFIG_KERNEL_BASE_ADDR)
+#define tophys(rd, rs) \
+	addik rd, rs, (CONFIG_KERNEL_BASE_ADDR - CONFIG_KERNEL_START)
+#define tovirt(rd, rs) \
+	addik rd, rs, (CONFIG_KERNEL_START - CONFIG_KERNEL_BASE_ADDR)
+#endif /* CONFIG_MMU */
 
 #define TOPHYS(addr)  __virt_to_phys(addr)
 
+#ifdef CONFIG_MMU
+#ifdef CONFIG_CONTIGUOUS_PAGE_ALLOC
+#define WANT_PAGE_VIRTUAL 1 /* page alloc 2 relies on this */
+#endif
+
+#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
+				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#endif /* CONFIG_MMU */
+
 #endif /* __KERNEL__ */
 
 #include <asm-generic/memory_model.h>
diff --git a/arch/microblaze/include/asm/pgalloc.h b/arch/microblaze/include/asm/pgalloc.h
index 2a4b354..59a757e 100644
--- a/arch/microblaze/include/asm/pgalloc.h
+++ b/arch/microblaze/include/asm/pgalloc.h
@@ -1,4 +1,6 @@
 /*
+ * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2008-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -9,6 +11,195 @@
 #ifndef _ASM_MICROBLAZE_PGALLOC_H
 #define _ASM_MICROBLAZE_PGALLOC_H
 
+#ifdef CONFIG_MMU
+
+#include <linux/kernel.h>	/* For min/max macros */
+#include <linux/highmem.h>
+#include <asm/setup.h>
+#include <asm/io.h>
+#include <asm/page.h>
+#include <asm/cache.h>
+
+#define PGDIR_ORDER	0
+
+/*
+ * This is handled very differently on MicroBlaze since out page tables
+ * are all 0's and I want to be able to use these zero'd pages elsewhere
+ * as well - it gives us quite a speedup.
+ * -- Cort
+ */
+extern struct pgtable_cache_struct {
+	unsigned long *pgd_cache;
+	unsigned long *pte_cache;
+	unsigned long pgtable_cache_sz;
+} quicklists;
+
+#define pgd_quicklist		(quicklists.pgd_cache)
+#define pmd_quicklist		((unsigned long *)0)
+#define pte_quicklist		(quicklists.pte_cache)
+#define pgtable_cache_size	(quicklists.pgtable_cache_sz)
+
+extern unsigned long *zero_cache; /* head linked list of pre-zero'd pages */
+extern atomic_t zero_sz; /* # currently pre-zero'd pages */
+extern atomic_t zeropage_hits; /* # zero'd pages request that we've done */
+extern atomic_t zeropage_calls; /* # zero'd pages request that've been made */
+extern atomic_t zerototal; /* # pages zero'd over time */
+
+#define zero_quicklist		(zero_cache)
+#define zero_cache_sz	 	(zero_sz)
+#define zero_cache_calls	(zeropage_calls)
+#define zero_cache_hits		(zeropage_hits)
+#define zero_cache_total	(zerototal)
+
+/*
+ * return a pre-zero'd page from the list,
+ * return NULL if none available -- Cort
+ */
+extern unsigned long get_zero_page_fast(void);
+
+extern void __bad_pte(pmd_t *pmd);
+
+extern inline pgd_t *get_pgd_slow(void)
+{
+	pgd_t *ret;
+
+	ret = (pgd_t *)__get_free_pages(GFP_KERNEL, PGDIR_ORDER);
+	if (ret != NULL)
+		clear_page(ret);
+	return ret;
+}
+
+extern inline pgd_t *get_pgd_fast(void)
+{
+	unsigned long *ret;
+
+	ret = pgd_quicklist;
+	if (ret != NULL) {
+		pgd_quicklist = (unsigned long *)(*ret);
+		ret[0] = 0;
+		pgtable_cache_size--;
+	} else
+		ret = (unsigned long *)get_pgd_slow();
+	return (pgd_t *)ret;
+}
+
+extern inline void free_pgd_fast(pgd_t *pgd)
+{
+	*(unsigned long **)pgd = pgd_quicklist;
+	pgd_quicklist = (unsigned long *) pgd;
+	pgtable_cache_size++;
+}
+
+extern inline void free_pgd_slow(pgd_t *pgd)
+{
+	free_page((unsigned long)pgd);
+}
+
+#define pgd_free(mm, pgd)        free_pgd_fast(pgd)
+#define pgd_alloc(mm)		get_pgd_fast()
+
+#define pmd_pgtable(pmd)	pmd_page(pmd)
+
+/*
+ * We don't have any real pmd's, and this code never triggers because
+ * the pgd will always be present..
+ */
+#define pmd_alloc_one_fast(mm, address)	({ BUG(); ((pmd_t *)1); })
+#define pmd_alloc_one(mm, address)	({ BUG(); ((pmd_t *)2); })
+/* FIXME two definition - look below */
+#define pmd_free(mm, x)			do { } while (0)
+#define pgd_populate(mm, pmd, pte)	BUG()
+
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
+		unsigned long address)
+{
+	pte_t *pte;
+	extern int mem_init_done;
+	extern void *early_get_page(void);
+	if (mem_init_done) {
+		pte = (pte_t *)__get_free_page(GFP_KERNEL |
+					__GFP_REPEAT | __GFP_ZERO);
+	} else {
+		pte = (pte_t *)early_get_page();
+		if (pte)
+			clear_page(pte);
+	}
+	return pte;
+}
+
+static inline struct page *pte_alloc_one(struct mm_struct *mm,
+		unsigned long address)
+{
+	struct page *ptepage;
+
+#ifdef CONFIG_HIGHPTE
+	int flags = GFP_KERNEL | __GFP_HIGHMEM | __GFP_REPEAT;
+#else
+	int flags = GFP_KERNEL | __GFP_REPEAT;
+#endif
+
+	ptepage = alloc_pages(flags, 0);
+	if (ptepage)
+		clear_highpage(ptepage);
+	return ptepage;
+}
+
+static inline pte_t *pte_alloc_one_fast(struct mm_struct *mm,
+		unsigned long address)
+{
+	unsigned long *ret;
+
+	ret = pte_quicklist;
+	if (ret != NULL) {
+		pte_quicklist = (unsigned long *)(*ret);
+		ret[0] = 0;
+		pgtable_cache_size--;
+	}
+	return (pte_t *)ret;
+}
+
+extern inline void pte_free_fast(pte_t *pte)
+{
+	*(unsigned long **)pte = pte_quicklist;
+	pte_quicklist = (unsigned long *) pte;
+	pgtable_cache_size++;
+}
+
+extern inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	free_page((unsigned long)pte);
+}
+
+extern inline void pte_free_slow(struct page *ptepage)
+{
+	__free_page(ptepage);
+}
+
+extern inline void pte_free(struct mm_struct *mm, struct page *ptepage)
+{
+	__free_page(ptepage);
+}
+
+#define __pte_free_tlb(tlb, pte)	pte_free((tlb)->mm, (pte))
+
+#define pmd_populate(mm, pmd, pte)	(pmd_val(*(pmd)) = page_address(pte))
+
+#define pmd_populate_kernel(mm, pmd, pte) \
+		(pmd_val(*(pmd)) = (unsigned long) (pte))
+
+/*
+ * We don't have any real pmd's, and this code never triggers because
+ * the pgd will always be present..
+ */
+#define pmd_alloc_one(mm, address)	({ BUG(); ((pmd_t *)2); })
+/*#define pmd_free(mm, x)			do { } while (0)*/
+#define __pmd_free_tlb(tlb, x)		do { } while (0)
+#define pgd_populate(mm, pmd, pte)	BUG()
+
+extern int do_check_pgt_cache(int, int);
+
+#endif /* CONFIG_MMU */
+
 #define check_pgt_cache()	do {} while (0)
 
 #endif /* _ASM_MICROBLAZE_PGALLOC_H */
-- 
1.5.5.1


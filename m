Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZCJNDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZCJNDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbZCJNDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:03:11 -0400
Received: from cmpxchg.org ([85.214.51.133]:38753 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbZCJNDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:03:08 -0400
Message-Id: <20090310120630.994745392@emlix.com>
References: <20090310115643.653120649@emlix.com>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 12:56:44 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: Oskar Schirmer <os@emlix.com>, Daniel Gloeckner <dg@emlix.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 1/8] xtensa: nommu support
Content-Disposition: inline; filename=0001-xtensa-nommu-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for CONFIG_MMU=n configurations.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/include/asm/cacheflush.h    |   10 +++-
 arch/xtensa/include/asm/dma.h           |    3 -
 arch/xtensa/include/asm/io.h            |    9 +++-
 arch/xtensa/include/asm/mmu.h           |    5 ++
 arch/xtensa/include/asm/mmu_context.h   |    5 ++
 arch/xtensa/include/asm/nommu.h         |    3 +
 arch/xtensa/include/asm/nommu_context.h |   25 +++++++++++
 arch/xtensa/include/asm/page.h          |    9 +++-
 arch/xtensa/include/asm/pgtable.h       |   13 +++--
 arch/xtensa/include/asm/processor.h     |    6 ++
 arch/xtensa/kernel/entry.S              |    3 -
 arch/xtensa/kernel/head.S               |    3 -
 arch/xtensa/kernel/setup.c              |    7 +++
 arch/xtensa/kernel/traps.c              |    2 
 arch/xtensa/kernel/vectors.S            |    4 +
 arch/xtensa/mm/Makefile                 |    3 -
 arch/xtensa/mm/init.c                   |   62 ----------------------------
 arch/xtensa/mm/misc.S                   |    2 
 arch/xtensa/mm/mmu.c                    |   70 ++++++++++++++++++++++++++++++++
 19 files changed, 169 insertions(+), 75 deletions(-)
 create mode 100644 arch/xtensa/include/asm/nommu.h
 create mode 100644 arch/xtensa/include/asm/nommu_context.h
 create mode 100644 arch/xtensa/mm/mmu.c

--- a/arch/xtensa/include/asm/cacheflush.h
+++ b/arch/xtensa/include/asm/cacheflush.h
@@ -65,13 +65,17 @@ extern void __flush_invalidate_dcache_ra
 # define __flush_invalidate_dcache_range(p,s)	__invalidate_dcache_range(p,s)
 #endif
 
-#if (DCACHE_WAY_SIZE > PAGE_SIZE)
+#if defined(CONFIG_MMU) && (DCACHE_WAY_SIZE > PAGE_SIZE)
 extern void __flush_invalidate_dcache_page_alias(unsigned long, unsigned long);
+#else
+static inline void __flush_invalidate_dcache_page_alias(unsigned long virt,
+							unsigned long phys) { }
 #endif
-#if (ICACHE_WAY_SIZE > PAGE_SIZE)
+#if defined(CONFIG_MMU) && (ICACHE_WAY_SIZE > PAGE_SIZE)
 extern void __invalidate_icache_page_alias(unsigned long, unsigned long);
 #else
-# define __invalidate_icache_page_alias(v,p)	do { } while(0)
+static inline void __invalidate_icache_page_alias(unsigned long virt,
+						unsigned long phys) { }
 #endif
 
 /*
--- a/arch/xtensa/include/asm/dma.h
+++ b/arch/xtensa/include/asm/dma.h
@@ -44,8 +44,9 @@
  *	the value desired).
  */
 
+#ifndef MAX_DMA_ADDRESS
 #define MAX_DMA_ADDRESS		(PAGE_OFFSET + XCHAL_KIO_SIZE - 1)
-
+#endif
 
 /* Reserve and release a DMA channel */
 extern int request_dma(unsigned int dmanr, const char * device_id);
--- a/arch/xtensa/include/asm/io.h
+++ b/arch/xtensa/include/asm/io.h
@@ -69,21 +69,28 @@ static inline void * phys_to_virt(unsign
 
 static inline void *ioremap(unsigned long offset, unsigned long size)
 {
+#ifdef CONFIG_MMU
 	if (offset >= XCHAL_KIO_PADDR
 	    && offset < XCHAL_KIO_PADDR + XCHAL_KIO_SIZE)
 		return (void*)(offset-XCHAL_KIO_PADDR+XCHAL_KIO_BYPASS_VADDR);
-
 	else
 		BUG();
+#else
+	return (void *)offset;
+#endif
 }
 
 static inline void *ioremap_nocache(unsigned long offset, unsigned long size)
 {
+#ifdef CONFIG_MMU
 	if (offset >= XCHAL_KIO_PADDR
 	    && offset < XCHAL_KIO_PADDR + XCHAL_KIO_SIZE)
 		return (void*)(offset-XCHAL_KIO_PADDR+XCHAL_KIO_CACHED_VADDR);
 	else
 		BUG();
+#else
+	return (void *)offset;
+#endif
 }
 
 static inline void iounmap(void *addr)
--- a/arch/xtensa/include/asm/mmu.h
+++ b/arch/xtensa/include/asm/mmu.h
@@ -11,7 +11,12 @@
 #ifndef _XTENSA_MMU_H
 #define _XTENSA_MMU_H
 
+#ifndef CONFIG_MMU
+#include <asm/nommu.h>
+#else
+
 /* Default "unsigned long" context */
 typedef unsigned long mm_context_t;
 
+#endif /* CONFIG_MMU */
 #endif	/* _XTENSA_MMU_H */
--- a/arch/xtensa/include/asm/mmu_context.h
+++ b/arch/xtensa/include/asm/mmu_context.h
@@ -13,6 +13,10 @@
 #ifndef _XTENSA_MMU_CONTEXT_H
 #define _XTENSA_MMU_CONTEXT_H
 
+#ifndef CONFIG_MMU
+#include <asm/nommu_context.h>
+#else
+
 #include <linux/stringify.h>
 #include <linux/sched.h>
 
@@ -133,4 +137,5 @@ static inline void enter_lazy_tlb(struct
 
 }
 
+#endif /* CONFIG_MMU */
 #endif /* _XTENSA_MMU_CONTEXT_H */
--- /dev/null
+++ b/arch/xtensa/include/asm/nommu.h
@@ -0,0 +1,3 @@
+typedef struct {
+	unsigned long end_brk;
+} mm_context_t;
--- /dev/null
+++ b/arch/xtensa/include/asm/nommu_context.h
@@ -0,0 +1,25 @@
+static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
+{
+}
+
+static inline int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
+{
+	return 0;
+}
+
+static inline void destroy_context(struct mm_struct *mm)
+{
+}
+
+static inline void activate_mm(struct mm_struct *prev, struct mm_struct *next)
+{
+}
+
+static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
+				struct task_struct *tsk)
+{
+}
+
+static inline void deactivate_mm(struct task_struct *tsk, struct mm_struct *mm)
+{
+}
--- a/arch/xtensa/include/asm/page.h
+++ b/arch/xtensa/include/asm/page.h
@@ -33,8 +33,14 @@
 #define PAGE_SIZE		(__XTENSA_UL_CONST(1) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
 
+#ifdef CONFIG_MMU
 #define PAGE_OFFSET		XCHAL_KSEG_CACHED_VADDR
 #define MAX_MEM_PFN		XCHAL_KSEG_SIZE
+#else
+#define PAGE_OFFSET		0
+#define MAX_MEM_PFN		(PLATFORM_DEFAULT_MEM_START + PLATFORM_DEFAULT_MEM_SIZE)
+#endif
+
 #define PGTABLE_START		0x80000000
 
 /*
@@ -165,8 +171,9 @@ extern void copy_user_page(void*, void*,
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
 
+#ifdef CONFIG_MMU
 #define WANT_PAGE_VIRTUAL
-
+#endif
 
 #endif /* __ASSEMBLY__ */
 
--- a/arch/xtensa/include/asm/pgtable.h
+++ b/arch/xtensa/include/asm/pgtable.h
@@ -183,7 +183,15 @@ extern unsigned long empty_zero_page[102
 
 #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
 
+#ifdef CONFIG_MMU
 extern pgd_t swapper_pg_dir[PAGE_SIZE/sizeof(pgd_t)];
+extern void paging_init(void);
+extern void pgtable_cache_init(void);
+#else
+# define swapper_pg_dir NULL
+static inline void paging_init(void) { }
+static inline void pgtable_cache_init(void) { }
+#endif
 
 /*
  * The pmd contains the kernel virtual address of the pte page.
@@ -383,8 +391,6 @@ ptep_set_wrprotect(struct mm_struct *mm,
 
 #else
 
-extern void paging_init(void);
-
 #define kern_addr_valid(addr)	(1)
 
 extern  void update_mmu_cache(struct vm_area_struct * vma,
@@ -398,9 +404,6 @@ extern  void update_mmu_cache(struct vm_
 #define io_remap_pfn_range(vma,from,pfn,size,prot) \
                 remap_pfn_range(vma, from, pfn, size, prot)
 
-
-extern void pgtable_cache_init(void);
-
 typedef pte_t *pte_addr_t;
 
 #endif /* !defined (__ASSEMBLY__) */
--- a/arch/xtensa/include/asm/processor.h
+++ b/arch/xtensa/include/asm/processor.h
@@ -13,6 +13,7 @@
 
 #include <variant/core.h>
 #include <asm/coprocessor.h>
+#include <platform/hardware.h>
 
 #include <linux/compiler.h>
 #include <asm/ptrace.h>
@@ -35,7 +36,12 @@
  * the 1 GB requirement applies to the stack as well.
  */
 
+#ifdef CONFIG_MMU
 #define TASK_SIZE	__XTENSA_UL_CONST(0x40000000)
+#else
+#define TASK_SIZE	(PLATFORM_DEFAULT_MEM_START + PLATFORM_DEFAULT_MEM_SIZE)
+#endif
+
 #define STACK_TOP	TASK_SIZE
 #define STACK_TOP_MAX	STACK_TOP
 
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -1463,6 +1463,7 @@ ENTRY(_spill_registers)
 	callx0	a0		# should not return
 1:	j	1b
 
+#ifdef CONFIG_MMU
 /*
  * We should never get here. Bail out!
  */
@@ -1775,7 +1776,7 @@ ENTRY(fast_store_prohibited)
 	bbsi.l	a2, PS_UM_BIT, 1f
 	j	_kernel_exception
 1:	j	_user_exception
-
+#endif /* CONFIG_MMU */
 
 /*
  * System Calls.
--- a/arch/xtensa/kernel/head.S
+++ b/arch/xtensa/kernel/head.S
@@ -235,8 +235,9 @@ should_never_return:
  */
 	
 .section ".bss.page_aligned", "w"
+#ifdef CONFIG_MMU
 ENTRY(swapper_pg_dir)
 	.fill	PAGE_SIZE, 1, 0
+#endif
 ENTRY(empty_zero_page)
 	.fill	PAGE_SIZE, 1, 0
-
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -82,7 +82,13 @@ sysmem_info_t __initdata sysmem;
 int initrd_is_mapped;
 #endif
 
+#ifdef CONFIG_MMU
 extern void init_mmu(void);
+#else
+static inline void init_mmu(void) { }
+#endif
+
+extern void zones_init(void);
 
 /*
  * Boot parameter parsing.
@@ -284,6 +290,7 @@ void __init setup_arch(char **cmdline_p)
 
 
 	paging_init();
+	zones_init();
 
 #ifdef CONFIG_VT
 # if defined(CONFIG_VGA_CONSOLE)
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -104,6 +104,7 @@ static dispatch_init_table_t __initdata 
 #endif
 { EXCCAUSE_UNALIGNED,		KRNL,	   fast_unaligned },
 #endif
+#ifdef CONFIG_MMU
 { EXCCAUSE_ITLB_MISS,		0,	   do_page_fault },
 { EXCCAUSE_ITLB_MISS,		USER|KRNL, fast_second_level_miss},
 { EXCCAUSE_ITLB_MULTIHIT,		0,	   do_multihit },
@@ -118,6 +119,7 @@ static dispatch_init_table_t __initdata 
 { EXCCAUSE_STORE_CACHE_ATTRIBUTE,	USER|KRNL, fast_store_prohibited },
 { EXCCAUSE_STORE_CACHE_ATTRIBUTE,	0,	   do_page_fault },
 { EXCCAUSE_LOAD_CACHE_ATTRIBUTE,	0,	   do_page_fault },
+#endif /* CONFIG_MMU */
 /* XCCHAL_EXCCAUSE_FLOATING_POINT unhandled */
 #if XTENSA_HAVE_COPROCESSOR(0)
 COPROCESSOR(0),
--- a/arch/xtensa/kernel/vectors.S
+++ b/arch/xtensa/kernel/vectors.S
@@ -309,6 +309,7 @@ ENTRY(_DoubleExceptionVector)
 	 * All other exceptions are unexpected and thus unrecoverable!
 	 */
 
+#ifdef CONFIG_MMU
 	.extern fast_second_level_miss_double_kernel
 
 .Lksp:	/* a0: a0, a1: a1, a2: a2, a3: trashed, depc: depc, excsave: a3 */
@@ -319,6 +320,9 @@ ENTRY(_DoubleExceptionVector)
 	bnez	a3, .Lunrecoverable
 1:	movi	a3, fast_second_level_miss_double_kernel
 	jx	a3
+#else
+.equ	.Lksp,	.Lunrecoverable
+#endif
 
 	/* Critical! We can't handle this situation. PANIC! */
 
--- a/arch/xtensa/mm/Makefile
+++ b/arch/xtensa/mm/Makefile
@@ -2,4 +2,5 @@
 # Makefile for the Linux/Xtensa-specific parts of the memory manager.
 #
 
-obj-y	 := init.o fault.o tlb.o misc.o cache.o
+obj-y			:= init.o cache.o misc.o
+obj-$(CONFIG_MMU)	+= fault.o mmu.o tlb.o
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -24,15 +24,8 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 
-#include <asm/pgtable.h>
 #include <asm/bootparam.h>
-#include <asm/mmu_context.h>
-#include <asm/tlb.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
-
-
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
 /* References to section boundaries */
 
@@ -160,7 +153,7 @@ void __init bootmem_init(void)
 }
 
 
-void __init paging_init(void)
+void __init zones_init(void)
 {
 	unsigned long zones_size[MAX_NR_ZONES];
 	int i;
@@ -175,43 +168,10 @@ void __init paging_init(void)
 	zones_size[ZONE_HIGHMEM] = max_pfn - max_low_pfn;
 #endif
 
-	/* Initialize the kernel's page tables. */
-
-	memset(swapper_pg_dir, 0, PAGE_SIZE);
-
 	free_area_init_node(0, zones_size, ARCH_PFN_OFFSET, NULL);
 }
 
 /*
- * Flush the mmu and reset associated register to default values.
- */
-
-void __init init_mmu (void)
-{
-	/* Writing zeros to the <t>TLBCFG special registers ensure
-	 * that valid values exist in the register.  For existing
-	 * PGSZID<w> fields, zero selects the first element of the
-	 * page-size array.  For nonexistent PGSZID<w> fields, zero is
-	 * the best value to write.  Also, when changing PGSZID<w>
-	 * fields, the corresponding TLB must be flushed.
-	 */
-	set_itlbcfg_register (0);
-	set_dtlbcfg_register (0);
-	flush_tlb_all ();
-
-	/* Set rasid register to a known value. */
-
-	set_rasid_register (ASID_USER_FIRST);
-
-	/* Set PTEVADDR special register to the start of the page
-	 * table, which is in kernel mappable space (ie. not
-	 * statically mapped).  This register's value is undefined on
-	 * reset.
-	 */
-	set_ptevaddr_register (PGTABLE_START);
-}
-
-/*
  * Initialize memory pages.
  */
 
@@ -281,23 +241,3 @@ void free_initmem(void)
 	printk("Freeing unused kernel memory: %dk freed\n",
 	       (&__init_end - &__init_begin) >> 10);
 }
-
-struct kmem_cache *pgtable_cache __read_mostly;
-
-static void pgd_ctor(void* addr)
-{
-	pte_t* ptep = (pte_t*)addr;
-	int i;
-
-	for (i = 0; i < 1024; i++, ptep++)
-		pte_clear(NULL, 0, ptep);
-
-}
-
-void __init pgtable_cache_init(void)
-{
-	pgtable_cache = kmem_cache_create("pgd",
-			PAGE_SIZE, PAGE_SIZE,
-			SLAB_HWCACHE_ALIGN,
-			pgd_ctor);
-}
--- a/arch/xtensa/mm/misc.S
+++ b/arch/xtensa/mm/misc.S
@@ -84,6 +84,7 @@ ENTRY(copy_page)
 
 	retw
 
+#ifdef CONFIG_MMU
 /*
  * If we have to deal with cache aliasing, we use temporary memory mappings
  * to ensure that the source and destination pages have the same color as
@@ -311,6 +312,7 @@ ENTRY(__invalidate_icache_page_alias)
 /* End of special treatment in tlb miss exception */
 
 ENTRY(__tlbtemp_mapping_end)
+#endif /* CONFIG_MMU
 
 /*
  * void __invalidate_icache_page(ulong start)
--- /dev/null
+++ b/arch/xtensa/mm/mmu.c
@@ -0,0 +1,70 @@
+/*
+ * xtensa mmu stuff
+ *
+ * Extracted from init.c
+ */
+#include <linux/percpu.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/cache.h>
+
+#include <asm/tlb.h>
+#include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
+#include <asm/page.h>
+
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
+
+void __init paging_init(void)
+{
+	memset(swapper_pg_dir, 0, PAGE_SIZE);
+}
+
+/*
+ * Flush the mmu and reset associated register to default values.
+ */
+void __init init_mmu(void)
+{
+	/* Writing zeros to the <t>TLBCFG special registers ensure
+	 * that valid values exist in the register.  For existing
+	 * PGSZID<w> fields, zero selects the first element of the
+	 * page-size array.  For nonexistent PGSZID<w> fields, zero is
+	 * the best value to write.  Also, when changing PGSZID<w>
+	 * fields, the corresponding TLB must be flushed.
+	 */
+	set_itlbcfg_register(0);
+	set_dtlbcfg_register(0);
+	flush_tlb_all();
+
+	/* Set rasid register to a known value. */
+
+	set_rasid_register(ASID_USER_FIRST);
+
+	/* Set PTEVADDR special register to the start of the page
+	 * table, which is in kernel mappable space (ie. not
+	 * statically mapped).  This register's value is undefined on
+	 * reset.
+	 */
+	set_ptevaddr_register(PGTABLE_START);
+}
+
+struct kmem_cache *pgtable_cache __read_mostly;
+
+static void pgd_ctor(void *addr)
+{
+	pte_t *ptep = (pte_t *)addr;
+	int i;
+
+	for (i = 0; i < 1024; i++, ptep++)
+		pte_clear(NULL, 0, ptep);
+
+}
+
+void __init pgtable_cache_init(void)
+{
+	pgtable_cache = kmem_cache_create("pgd",
+			PAGE_SIZE, PAGE_SIZE,
+			SLAB_HWCACHE_ALIGN,
+			pgd_ctor);
+}

-- 


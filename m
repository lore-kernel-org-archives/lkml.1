Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbYF0P6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbYF0P6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbYF0P55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:57:57 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:43664 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbYF0P5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:57:53 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 3/6] avr32: Store virtual addresses in the PGD
Date: Fri, 27 Jun 2008 17:57:53 +0200
Message-Id: <1214582276-10889-3-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214582276-10889-2-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214582276-10889-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214582276-10889-2-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 27 Jun 2008 15:57:42.0169 (UTC) FILETIME=[881D6890:01C8D86E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of storing physical addresses along with page flags in the
PGD, store virtual addresses and use NULL to indicate a not present
second-level page table. A non-page-aligned page table indicates a bad
PMD.

This simplifies the TLB miss handler since it no longer has to check
the Present bit and no longer has to convert the PGD entry from
physical to virtual address. Instead, it has to check for a NULL
entry, which is slightly cheaper than either.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 arch/avr32/kernel/entry-avr32b.S |   45 ++++++++++++++++---------------------
 arch/avr32/kernel/vmlinux.lds.S  |    4 +++
 arch/avr32/mm/init.c             |    4 ++-
 include/asm-avr32/pgalloc.h      |   18 ++++++++------
 include/asm-avr32/pgtable.h      |   34 +++++++++++----------------
 5 files changed, 51 insertions(+), 54 deletions(-)

diff --git a/arch/avr32/kernel/entry-avr32b.S b/arch/avr32/kernel/entry-avr32b.S
index 050c006..3cdd707 100644
--- a/arch/avr32/kernel/entry-avr32b.S
+++ b/arch/avr32/kernel/entry-avr32b.S
@@ -74,12 +74,6 @@ exception_vectors:
 	.align	2
 	bral	do_dtlb_modified
 
-	/*
-	 * r0 :	PGD/PT/PTE
-	 * r1 : Offending address
-	 * r2 : Scratch register
-	 * r3 : Cause (5, 12 or 13)
-	 */
 #define	tlbmiss_save	pushm	r0-r3
 #define tlbmiss_restore	popm	r0-r3
 
@@ -108,17 +102,17 @@ tlb_miss_common:
 	bld	r0, 31
 	brcs	handle_vmalloc_miss
 
-	/* First level lookup */
+	/*
+	 * First level lookup: The PGD contains virtual pointers to
+	 * the second-level page tables, but they may be NULL if not
+	 * present.
+	 */
 pgtbl_lookup:
 	lsr	r2, r0, PGDIR_SHIFT
 	ld.w	r3, r1[r2 << 2]
 	bfextu	r1, r0, PAGE_SHIFT, PGDIR_SHIFT - PAGE_SHIFT
-	bld	r3, _PAGE_BIT_PRESENT
-	brcc	page_table_not_present
-
-	/* Translate to virtual address in P1. */
-	andl	r3, 0xf000
-	sbr	r3, 31
+	cp.w	r3, 0
+	breq	page_table_not_present
 
 	/* Second level lookup */
 	ld.w	r2, r3[r1 << 2]
@@ -155,6 +149,19 @@ handle_vmalloc_miss:
 	orh	r1, hi(swapper_pg_dir)
 	rjmp	pgtbl_lookup
 
+	/* The slow path of the TLB miss handler */
+	.align	2
+page_table_not_present:
+page_not_present:
+	tlbmiss_restore
+	sub	sp, 4
+	stmts	--sp, r0-lr
+	rcall	save_full_context_ex
+	mfsr	r12, SYSREG_ECR
+	mov	r11, sp
+	rcall	do_page_fault
+	rjmp	ret_from_exception
+
 
 	/* ---                    System Call                    --- */
 
@@ -267,18 +274,6 @@ syscall_exit_work:
 	brcc	syscall_exit_cont
 	rjmp	enter_monitor_mode
 
-	/* The slow path of the TLB miss handler */
-page_table_not_present:
-page_not_present:
-	tlbmiss_restore
-	sub	sp, 4
-	stmts	--sp, r0-lr
-	rcall	save_full_context_ex
-	mfsr	r12, SYSREG_ECR
-	mov	r11, sp
-	rcall	do_page_fault
-	rjmp	ret_from_exception
-
 	/* This function expects to find offending PC in SYSREG_RAR_EX */
 	.type	save_full_context_ex, @function
 	.align	2
diff --git a/arch/avr32/kernel/vmlinux.lds.S b/arch/avr32/kernel/vmlinux.lds.S
index 033dd46..5d25d8e 100644
--- a/arch/avr32/kernel/vmlinux.lds.S
+++ b/arch/avr32/kernel/vmlinux.lds.S
@@ -99,6 +99,10 @@ SECTIONS
 		 */
 		*(.data.init_task)
 
+		/* Then, the page-aligned data */
+		. = ALIGN(PAGE_SIZE);
+		*(.data.page_aligned)
+
 		/* Then, the cacheline aligned data */
 		. = ALIGN(L1_CACHE_BYTES);
 		*(.data.cacheline_aligned)
diff --git a/arch/avr32/mm/init.c b/arch/avr32/mm/init.c
index 0e77578..3f90a87 100644
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -24,9 +24,11 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 
+#define __page_aligned	__attribute__((section(".data.page_aligned")))
+
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-pgd_t swapper_pg_dir[PTRS_PER_PGD];
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned;
 
 struct page *empty_zero_page;
 EXPORT_SYMBOL(empty_zero_page);
diff --git a/include/asm-avr32/pgalloc.h b/include/asm-avr32/pgalloc.h
index 51fc1f6..5b768fc 100644
--- a/include/asm-avr32/pgalloc.h
+++ b/include/asm-avr32/pgalloc.h
@@ -8,25 +8,27 @@
 #ifndef __ASM_AVR32_PGALLOC_H
 #define __ASM_AVR32_PGALLOC_H
 
-#include <asm/processor.h>
-#include <linux/threads.h>
-#include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
 
-#define pmd_populate_kernel(mm, pmd, pte) \
-	set_pmd(pmd, __pmd(_PAGE_TABLE + __pa(pte)))
+static inline void pmd_populate_kernel(struct mm_struct *mm,
+				       pmd_t *pmd, pte_t *pte)
+{
+	set_pmd(pmd, __pmd((unsigned long)pte));
+}
 
-static __inline__ void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
+static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 				    pgtable_t pte)
 {
-	set_pmd(pmd, __pmd(_PAGE_TABLE + page_to_phys(pte)));
+	set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
 }
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
 /*
  * Allocate and free page tables
  */
-static __inline__ pgd_t *pgd_alloc(struct mm_struct *mm)
+static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	return kcalloc(USER_PTRS_PER_PGD, sizeof(pgd_t), GFP_KERNEL);
 }
diff --git a/include/asm-avr32/pgtable.h b/include/asm-avr32/pgtable.h
index c0e5e29..fecdda1 100644
--- a/include/asm-avr32/pgtable.h
+++ b/include/asm-avr32/pgtable.h
@@ -129,13 +129,6 @@ extern struct page *empty_zero_page;
 
 #define _PAGE_FLAGS_CACHE_MASK	(_PAGE_CACHABLE | _PAGE_BUFFER | _PAGE_WT)
 
-/* TODO: Check for saneness */
-/* User-mode page table flags (to be set in a pgd or pmd entry) */
-#define _PAGE_TABLE		(_PAGE_PRESENT | _PAGE_TYPE_SMALL | _PAGE_RW \
-				 | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
-/* Kernel-mode page table flags */
-#define _KERNPG_TABLE		(_PAGE_PRESENT | _PAGE_TYPE_SMALL | _PAGE_RW \
-				 | _PAGE_ACCESSED | _PAGE_DIRTY)
 /* Flags that may be modified by software */
 #define _PAGE_CHG_MASK		(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY \
 				 | _PAGE_FLAGS_CACHE_MASK)
@@ -262,10 +255,14 @@ static inline pte_t pte_mkspecial(pte_t pte)
 }
 
 #define pmd_none(x)	(!pmd_val(x))
-#define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
-#define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
-#define	pmd_bad(x)	((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER))	\
-			 != _KERNPG_TABLE)
+#define pmd_present(x)	(pmd_val(x))
+
+static inline void pmd_clear(pmd_t *pmdp)
+{
+	set_pmd(pmdp, __pmd(0));
+}
+
+#define	pmd_bad(x)	(pmd_val(x) & ~PAGE_MASK)
 
 /*
  * Permanent address of a page. We don't support highmem, so this is
@@ -303,19 +300,16 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 
 #define page_pte(page)	page_pte_prot(page, __pgprot(0))
 
-#define pmd_page_vaddr(pmd)					\
-	((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
-
-#define pmd_page(pmd)	(phys_to_page(pmd_val(pmd)))
+#define pmd_page_vaddr(pmd)	pmd_val(pmd)
+#define pmd_page(pmd)		(virt_to_page(pmd_val(pmd)))
 
 /* to find an entry in a page-table-directory. */
-#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-#define pgd_offset(mm, address) ((mm)->pgd+pgd_index(address))
-#define pgd_offset_current(address)				\
-	((pgd_t *)__mfsr(SYSREG_PTBR) + pgd_index(address))
+#define pgd_index(address)	(((address) >> PGDIR_SHIFT)	\
+				 & (PTRS_PER_PGD - 1))
+#define pgd_offset(mm, address)	((mm)->pgd + pgd_index(address))
 
 /* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
+#define pgd_offset_k(address)	pgd_offset(&init_mm, address)
 
 /* Find an entry in the third-level page table.. */
 #define pte_index(address)				\
-- 
1.5.5.4


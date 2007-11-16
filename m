Return-Path: <linux-kernel-owner+w=401wt.eu-S935141AbXKPVqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935141AbXKPVqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933696AbXKPVnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:43:31 -0500
Received: from [198.99.130.12] ([198.99.130.12]:59883 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S935066AbXKPVn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:43:28 -0500
Date: Fri, 16 Nov 2007 16:42:28 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 8/8] UML - Cover stubs with a VMA
Message-ID: <20071116214228.GA13882@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give the stubs a VMA.  This allows the removal of a truly nasty kludge
to make sure that mm->nr_ptes was correct in exit_mmap.  The
underlying problem was always that the stubs, which have ptes, and
thus allocated a page table, weren't covered by a VMA.

This patch fixes that by using install_special_mapping in
arch_dup_mmap and activate_context to create the VMA.  The stubs have
to be moved, since shift_arg_pages seems to assume that the stack is
the only VMA present at that point during exec, and uses vma_adjust to
fiddle its VMA.  However, that extends the stub VMA by the amount
removed from the stack VMA.

To avoid this problem, the stubs were moved to a different fixed
location at the start of the address space.

arch_exit_mmap is used to clear the stub ptes at exit time.

The STUB_* constants in as-layout.h no longer depend on UM_TASK_SIZE,
so that definition is removed, along with the comments complaining
about gcc.

Because the stubs are no longer at the top of the address space, some
care is needed while flushing TLBs.  update_pte_range checks for
addresses in the stub range and skips them.  flush_thread now issues
two unmaps, one for the range before STUB_START and one for the range
after STUB_END.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/as-layout.h      |   19 +-------
 arch/um/include/common-offsets.h |    3 -
 arch/um/kernel/exec.c            |    5 +-
 arch/um/kernel/skas/mmu.c        |   86 ++++++++++++++++++++++-----------------
 arch/um/kernel/tlb.c             |   11 +---
 include/asm-um/mmu_context.h     |    7 ++-
 6 files changed, 66 insertions(+), 65 deletions(-)

Index: linux-2.6.22/arch/um/kernel/skas/mmu.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/skas/mmu.c	2007-11-16 15:16:54.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/skas/mmu.c	2007-11-16 15:41:07.000000000 -0500
@@ -34,25 +34,6 @@ static int init_stub_pte(struct mm_struc
 	if (!pte)
 		goto out_pte;
 
-	/*
-	 * There's an interaction between the skas0 stub pages, stack
-	 * randomization, and the BUG at the end of exit_mmap.  exit_mmap
-	 * checks that the number of page tables freed is the same as had
-	 * been allocated.  If the stack is on the last page table page,
-	 * then the stack pte page will be freed, and if not, it won't.  To
-	 * avoid having to know where the stack is, or if the process mapped
-	 * something at the top of its address space for some other reason,
-	 * we set TASK_SIZE to end at the start of the last page table.
-	 * This keeps exit_mmap off the last page, but introduces a leak
-	 * of that page.  So, we hang onto it here and free it in
-	 * destroy_context_skas.
-	 */
-
-	mm->context.last_page_table = pmd_page_vaddr(*pmd);
-#ifdef CONFIG_3_LEVEL_PGTABLES
-	mm->context.last_pmd = (unsigned long) __va(pud_val(*pud));
-#endif
-
 	*pte = mk_pte(virt_to_page(kernel), __pgprot(_PAGE_PRESENT));
 	*pte = pte_mkread(*pte);
 	return 0;
@@ -77,13 +58,6 @@ int init_new_context(struct task_struct 
 		if (stack == 0)
 			goto out;
 
-		/*
-		 * This zeros the entry that pgd_alloc didn't, needed since
-		 * we are about to reinitialize it, and want mm.nr_ptes to
-		 * be accurate.
-		 */
-		mm->pgd[USER_PTRS_PER_PGD] = __pgd(0);
-
 		ret = init_stub_pte(mm, STUB_CODE,
 				    (unsigned long) &__syscall_stub_start);
 		if (ret)
@@ -92,8 +66,6 @@ int init_new_context(struct task_struct 
 		ret = init_stub_pte(mm, STUB_DATA, stack);
 		if (ret)
 			goto out_free;
-
-		mm->nr_ptes--;
 	}
 
 	to_mm->id.stack = stack;
@@ -132,6 +104,55 @@ int init_new_context(struct task_struct 
 	return ret;
 }
 
+void arch_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
+{
+	struct page **pages;
+	int err;
+
+	if (!skas_needs_stub)
+		return;
+
+	pages = kmalloc(2 * sizeof(struct page *), GFP_KERNEL);
+	if (pages == NULL) {
+		printk(KERN_ERR "arch_dup_mmap failed to allocate 2 page "
+		       "pointers\n");
+		goto out;
+	}
+
+	pages[0] = virt_to_page(&__syscall_stub_start);
+	pages[1] = virt_to_page(mm->context.id.stack);
+
+	/* dup_mmap already holds mmap_sem */
+	err = install_special_mapping(mm, STUB_START, STUB_END - STUB_START,
+				      VM_READ | VM_MAYREAD | VM_EXEC |
+				      VM_MAYEXEC | VM_DONTCOPY, pages);
+	if (err) {
+		printk(KERN_ERR "install_special_mapping returned %d\n", err);
+		goto out_free;
+	}
+	return;
+
+out_free:
+	kfree(pages);
+out:
+	force_sigsegv(SIGSEGV, current);
+}
+
+void arch_exit_mmap(struct mm_struct *mm)
+{
+	pte_t *pte;
+
+	pte = virt_to_pte(mm, STUB_CODE);
+	if (pte != NULL)
+		pte_clear(mm, STUB_CODE, pte);
+
+	pte = virt_to_pte(mm, STUB_DATA);
+	if (pte == NULL)
+		return;
+
+	pte_clear(mm, STUB_DATA, pte);
+}
+
 void destroy_context(struct mm_struct *mm)
 {
 	struct mm_context *mmu = &mm->context;
@@ -141,15 +162,8 @@ void destroy_context(struct mm_struct *m
 	else
 		os_kill_ptraced_process(mmu->id.u.pid, 1);
 
-	if (!proc_mm || !ptrace_faultinfo) {
+	if (skas_needs_stub)
 		free_page(mmu->id.stack);
-		pte_lock_deinit(virt_to_page(mmu->last_page_table));
-		pte_free_kernel(mm, (pte_t *) mmu->last_page_table);
-		dec_zone_page_state(virt_to_page(mmu->last_page_table), NR_PAGETABLE);
-#ifdef CONFIG_3_LEVEL_PGTABLES
-		pmd_free(mm, (pmd_t *) mmu->last_pmd);
-#endif
-	}
 
 	free_ldt(mmu);
 }
Index: linux-2.6.22/include/asm-um/mmu_context.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/mmu_context.h	2007-11-16 15:16:54.000000000 -0500
+++ linux-2.6.22/include/asm-um/mmu_context.h	2007-11-16 15:40:36.000000000 -0500
@@ -6,11 +6,12 @@
 #ifndef __UM_MMU_CONTEXT_H
 #define __UM_MMU_CONTEXT_H
 
-#include <asm-generic/mm_hooks.h>
-
 #include "linux/sched.h"
 #include "um_mmu.h"
 
+extern void arch_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm);
+extern void arch_exit_mmap(struct mm_struct *mm);
+
 #define get_mmu_context(task) do ; while(0)
 #define activate_context(tsk) do ; while(0)
 
@@ -30,6 +31,8 @@ static inline void activate_mm(struct mm
 	 */
 	if (old != new && (current->flags & PF_BORROWED_MM))
 		__switch_mm(&new->context.id);
+
+	arch_dup_mmap(old, new);
 }
 
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next, 
Index: linux-2.6.22/arch/um/include/as-layout.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/as-layout.h	2007-11-16 15:39:36.000000000 -0500
+++ linux-2.6.22/arch/um/include/as-layout.h	2007-11-16 15:40:36.000000000 -0500
@@ -29,21 +29,10 @@
 #define _AC(X, Y)	__AC(X, Y)
 #endif
 
-/*
- * The "- 1"'s are to avoid gcc complaining about integer overflows
- * and unrepresentable decimal constants.  With 3-level page tables,
- * TASK_SIZE is 0x80000000, which gets turned into its signed decimal
- * equivalent in asm-offsets.s.  gcc then complains about that being
- * unsigned only in C90.  To avoid that, UM_TASK_SIZE is defined as
- * TASK_SIZE - 1.  To compensate, we need to add the 1 back here.
- * However, adding it back to UM_TASK_SIZE produces more gcc
- * complaints.  So, I adjust the thing being subtracted from
- * UM_TASK_SIZE instead.  Bah.
- */
-#define STUB_CODE _AC((unsigned long), \
-		      UM_TASK_SIZE - (2 * UM_KERN_PAGE_SIZE - 1))
-#define STUB_DATA _AC((unsigned long), UM_TASK_SIZE - (UM_KERN_PAGE_SIZE - 1))
-#define STUB_START _AC(, STUB_CODE)
+#define STUB_START _AC(, 0x100000)
+#define STUB_CODE _AC((unsigned long), STUB_START)
+#define STUB_DATA _AC((unsigned long), STUB_CODE + UM_KERN_PAGE_SIZE)
+#define STUB_END _AC((unsigned long), STUB_DATA + UM_KERN_PAGE_SIZE)
 
 #ifndef __ASSEMBLY__
 
Index: linux-2.6.22/arch/um/kernel/exec.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/exec.c	2007-11-16 15:39:36.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/exec.c	2007-11-16 15:40:36.000000000 -0500
@@ -19,12 +19,13 @@
 void flush_thread(void)
 {
 	void *data = NULL;
-	unsigned long end = proc_mm ? TASK_SIZE : STUB_START;
 	int ret;
 
 	arch_flush_thread(&current->thread.arch);
 
-	ret = unmap(&current->mm->context.id, 0, end, 1, &data);
+	ret = unmap(&current->mm->context.id, 0, STUB_START, 0, &data);
+	ret = ret || unmap(&current->mm->context.id, STUB_END,
+			   TASK_SIZE - STUB_END, 1, &data);
 	if (ret) {
 		printk(KERN_ERR "flush_thread - clearing address space failed, "
 		       "err = %d\n", ret);
Index: linux-2.6.22/arch/um/kernel/tlb.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/tlb.c	2007-11-16 15:39:36.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/tlb.c	2007-11-16 15:40:36.000000000 -0500
@@ -184,6 +184,9 @@ static inline int update_pte_range(pmd_t
 
 	pte = pte_offset_kernel(pmd, addr);
 	do {
+		if ((addr >= STUB_START) && (addr < STUB_END))
+			continue;
+
 		r = pte_read(*pte);
 		w = pte_write(*pte);
 		x = pte_exec(*pte);
@@ -486,9 +489,6 @@ void __flush_tlb_one(unsigned long addr)
 static void fix_range(struct mm_struct *mm, unsigned long start_addr,
 		      unsigned long end_addr, int force)
 {
-	if (!proc_mm && (end_addr > STUB_START))
-		end_addr = STUB_START;
-
 	fix_range_common(mm, start_addr, end_addr, force);
 }
 
@@ -502,8 +502,6 @@ void flush_tlb_range(struct vm_area_stru
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	unsigned long end;
-
 	/*
 	 * Don't bother flushing if this address space is about to be
 	 * destroyed.
@@ -511,8 +509,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 	if (atomic_read(&mm->mm_users) == 0)
 		return;
 
-	end = proc_mm ? TASK_SIZE : STUB_START;
-	fix_range(mm, 0, end, 0);
+	fix_range(mm, 0, TASK_SIZE, 0);
 }
 
 void force_flush_all(void)
Index: linux-2.6.22/arch/um/include/common-offsets.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/common-offsets.h	2007-11-16 15:39:36.000000000 -0500
+++ linux-2.6.22/arch/um/include/common-offsets.h	2007-11-16 15:40:36.000000000 -0500
@@ -39,6 +39,3 @@ DEFINE(UM_HZ, HZ);
 DEFINE(UM_USEC_PER_SEC, USEC_PER_SEC);
 DEFINE(UM_NSEC_PER_SEC, NSEC_PER_SEC);
 DEFINE(UM_NSEC_PER_USEC, NSEC_PER_USEC);
-
-/* See as-layout.h for an explanation of the "- 1".  Bah. */
-DEFINE(UM_TASK_SIZE, TASK_SIZE - 1);

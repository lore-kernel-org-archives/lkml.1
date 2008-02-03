Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbYBCVDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbYBCVDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYBCVDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:03:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41414 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYBCVDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:03:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/4] x86 PM: Rename 32-bit files in arch/x86/power
Date: Sun, 3 Feb 2008 21:58:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
References: <200802032141.56887.rjw@sisk.pl>
In-Reply-To: <200802032141.56887.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802032158.37201.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Rename cpu.c, suspend.c and swsusp.S in arch/x86/power to cpu_32.c,
hibernate_32.c and hibernate_asm_32.S, respectively, and update the
purpose and copyright information in these files.

Update the Makefile in arch/x86/power to reflect the above changes.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/power/Makefile           |    4 
 arch/x86/power/cpu.c              |  133 -----------------------------
 arch/x86/power/cpu_32.c           |  133 +++++++++++++++++++++++++++++
 arch/x86/power/hibernate_32.c     |  172 ++++++++++++++++++++++++++++++++++++++
 arch/x86/power/hibernate_asm_32.S |   77 +++++++++++++++++
 arch/x86/power/suspend.c          |  172 --------------------------------------
 arch/x86/power/swsusp.S           |   78 -----------------
 7 files changed, 384 insertions(+), 385 deletions(-)

Index: linux-2.6/arch/x86/power/cpu.c
===================================================================
--- linux-2.6.orig/arch/x86/power/cpu.c
+++ /dev/null
@@ -1,133 +0,0 @@
-/*
- * Suspend support specific for i386.
- *
- * Distribute under GPLv2
- *
- * Copyright (c) 2002 Pavel Machek <pavel@suse.cz>
- * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
- */
-
-#include <linux/module.h>
-#include <linux/suspend.h>
-#include <asm/mtrr.h>
-#include <asm/mce.h>
-
-static struct saved_context saved_context;
-
-unsigned long saved_context_ebx;
-unsigned long saved_context_esp, saved_context_ebp;
-unsigned long saved_context_esi, saved_context_edi;
-unsigned long saved_context_eflags;
-
-static void __save_processor_state(struct saved_context *ctxt)
-{
-	mtrr_save_fixed_ranges(NULL);
-	kernel_fpu_begin();
-
-	/*
-	 * descriptor tables
-	 */
- 	store_gdt(&ctxt->gdt);
- 	store_idt(&ctxt->idt);
- 	store_tr(ctxt->tr);
-
-	/*
-	 * segment registers
-	 */
- 	savesegment(es, ctxt->es);
- 	savesegment(fs, ctxt->fs);
- 	savesegment(gs, ctxt->gs);
- 	savesegment(ss, ctxt->ss);
-
-	/*
-	 * control registers 
-	 */
-	ctxt->cr0 = read_cr0();
-	ctxt->cr2 = read_cr2();
-	ctxt->cr3 = read_cr3();
-	ctxt->cr4 = read_cr4();
-}
-
-void save_processor_state(void)
-{
-	__save_processor_state(&saved_context);
-}
-
-static void do_fpu_end(void)
-{
-	/*
-	 * Restore FPU regs if necessary.
-	 */
-	kernel_fpu_end();
-}
-
-static void fix_processor_context(void)
-{
-	int cpu = smp_processor_id();
-	struct tss_struct * t = &per_cpu(init_tss, cpu);
-
-	set_tss_desc(cpu,t);	/* This just modifies memory; should not be necessary. But... This is necessary, because 386 hardware has concept of busy TSS or some similar stupidity. */
-
-	load_TR_desc();				/* This does ltr */
-	load_LDT(&current->active_mm->context);	/* This does lldt */
-
-	/*
-	 * Now maybe reload the debug registers
-	 */
-	if (current->thread.debugreg7) {
-		set_debugreg(current->thread.debugreg0, 0);
-		set_debugreg(current->thread.debugreg1, 1);
-		set_debugreg(current->thread.debugreg2, 2);
-		set_debugreg(current->thread.debugreg3, 3);
-		/* no 4 and 5 */
-		set_debugreg(current->thread.debugreg6, 6);
-		set_debugreg(current->thread.debugreg7, 7);
-	}
-
-}
-
-static void __restore_processor_state(struct saved_context *ctxt)
-{
-	/*
-	 * control registers
-	 */
-	write_cr4(ctxt->cr4);
-	write_cr3(ctxt->cr3);
-	write_cr2(ctxt->cr2);
-	write_cr0(ctxt->cr0);
-
-	/*
-	 * now restore the descriptor tables to their proper values
-	 * ltr is done i fix_processor_context().
-	 */
- 	load_gdt(&ctxt->gdt);
- 	load_idt(&ctxt->idt);
-
-	/*
-	 * segment registers
-	 */
- 	loadsegment(es, ctxt->es);
- 	loadsegment(fs, ctxt->fs);
- 	loadsegment(gs, ctxt->gs);
- 	loadsegment(ss, ctxt->ss);
-
-	/*
-	 * sysenter MSRs
-	 */
-	if (boot_cpu_has(X86_FEATURE_SEP))
-		enable_sep_cpu();
-
-	fix_processor_context();
-	do_fpu_end();
-	mtrr_ap_init();
-	mcheck_init(&boot_cpu_data);
-}
-
-void restore_processor_state(void)
-{
-	__restore_processor_state(&saved_context);
-}
-
-/* Needed by apm.c */
-EXPORT_SYMBOL(save_processor_state);
-EXPORT_SYMBOL(restore_processor_state);
Index: linux-2.6/arch/x86/power/cpu_32.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/power/cpu_32.c
@@ -0,0 +1,133 @@
+/*
+ * Suspend support specific for i386.
+ *
+ * Distribute under GPLv2
+ *
+ * Copyright (c) 2002 Pavel Machek <pavel@suse.cz>
+ * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
+ */
+
+#include <linux/module.h>
+#include <linux/suspend.h>
+#include <asm/mtrr.h>
+#include <asm/mce.h>
+
+static struct saved_context saved_context;
+
+unsigned long saved_context_ebx;
+unsigned long saved_context_esp, saved_context_ebp;
+unsigned long saved_context_esi, saved_context_edi;
+unsigned long saved_context_eflags;
+
+static void __save_processor_state(struct saved_context *ctxt)
+{
+	mtrr_save_fixed_ranges(NULL);
+	kernel_fpu_begin();
+
+	/*
+	 * descriptor tables
+	 */
+ 	store_gdt(&ctxt->gdt);
+ 	store_idt(&ctxt->idt);
+ 	store_tr(ctxt->tr);
+
+	/*
+	 * segment registers
+	 */
+ 	savesegment(es, ctxt->es);
+ 	savesegment(fs, ctxt->fs);
+ 	savesegment(gs, ctxt->gs);
+ 	savesegment(ss, ctxt->ss);
+
+	/*
+	 * control registers
+	 */
+	ctxt->cr0 = read_cr0();
+	ctxt->cr2 = read_cr2();
+	ctxt->cr3 = read_cr3();
+	ctxt->cr4 = read_cr4();
+}
+
+void save_processor_state(void)
+{
+	__save_processor_state(&saved_context);
+}
+
+static void do_fpu_end(void)
+{
+	/*
+	 * Restore FPU regs if necessary.
+	 */
+	kernel_fpu_end();
+}
+
+static void fix_processor_context(void)
+{
+	int cpu = smp_processor_id();
+	struct tss_struct * t = &per_cpu(init_tss, cpu);
+
+	set_tss_desc(cpu,t);	/* This just modifies memory; should not be necessary. But... This is necessary, because 386 hardware has concept of busy TSS or some similar stupidity. */
+
+	load_TR_desc();				/* This does ltr */
+	load_LDT(&current->active_mm->context);	/* This does lldt */
+
+	/*
+	 * Now maybe reload the debug registers
+	 */
+	if (current->thread.debugreg7) {
+		set_debugreg(current->thread.debugreg0, 0);
+		set_debugreg(current->thread.debugreg1, 1);
+		set_debugreg(current->thread.debugreg2, 2);
+		set_debugreg(current->thread.debugreg3, 3);
+		/* no 4 and 5 */
+		set_debugreg(current->thread.debugreg6, 6);
+		set_debugreg(current->thread.debugreg7, 7);
+	}
+
+}
+
+static void __restore_processor_state(struct saved_context *ctxt)
+{
+	/*
+	 * control registers
+	 */
+	write_cr4(ctxt->cr4);
+	write_cr3(ctxt->cr3);
+	write_cr2(ctxt->cr2);
+	write_cr0(ctxt->cr0);
+
+	/*
+	 * now restore the descriptor tables to their proper values
+	 * ltr is done i fix_processor_context().
+	 */
+ 	load_gdt(&ctxt->gdt);
+ 	load_idt(&ctxt->idt);
+
+	/*
+	 * segment registers
+	 */
+ 	loadsegment(es, ctxt->es);
+ 	loadsegment(fs, ctxt->fs);
+ 	loadsegment(gs, ctxt->gs);
+ 	loadsegment(ss, ctxt->ss);
+
+	/*
+	 * sysenter MSRs
+	 */
+	if (boot_cpu_has(X86_FEATURE_SEP))
+		enable_sep_cpu();
+
+	fix_processor_context();
+	do_fpu_end();
+	mtrr_ap_init();
+	mcheck_init(&boot_cpu_data);
+}
+
+void restore_processor_state(void)
+{
+	__restore_processor_state(&saved_context);
+}
+
+/* Needed by apm.c */
+EXPORT_SYMBOL(save_processor_state);
+EXPORT_SYMBOL(restore_processor_state);
Index: linux-2.6/arch/x86/power/hibernate_32.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/power/hibernate_32.c
@@ -0,0 +1,172 @@
+/*
+ * Hibernation support specific for i386 - temporary page tables
+ *
+ * Distribute under GPLv2
+ *
+ * Copyright (c) 2006 Rafael J. Wysocki <rjw@sisk.pl>
+ */
+
+#include <linux/suspend.h>
+#include <linux/bootmem.h>
+
+#include <asm/system.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+/* Defined in arch/i386/power/swsusp.S */
+extern int restore_image(void);
+
+/* References to section boundaries */
+extern const void __nosave_begin, __nosave_end;
+
+/* Pointer to the temporary resume page tables */
+pgd_t *resume_pg_dir;
+
+/* The following three functions are based on the analogous code in
+ * arch/i386/mm/init.c
+ */
+
+/*
+ * Create a middle page table on a resume-safe page and put a pointer to it in
+ * the given global directory entry.  This only returns the gd entry
+ * in non-PAE compilation mode, since the middle layer is folded.
+ */
+static pmd_t *resume_one_md_table_init(pgd_t *pgd)
+{
+	pud_t *pud;
+	pmd_t *pmd_table;
+
+#ifdef CONFIG_X86_PAE
+	pmd_table = (pmd_t *)get_safe_page(GFP_ATOMIC);
+	if (!pmd_table)
+		return NULL;
+
+	set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
+	pud = pud_offset(pgd, 0);
+
+	BUG_ON(pmd_table != pmd_offset(pud, 0));
+#else
+	pud = pud_offset(pgd, 0);
+	pmd_table = pmd_offset(pud, 0);
+#endif
+
+	return pmd_table;
+}
+
+/*
+ * Create a page table on a resume-safe page and place a pointer to it in
+ * a middle page directory entry.
+ */
+static pte_t *resume_one_page_table_init(pmd_t *pmd)
+{
+	if (pmd_none(*pmd)) {
+		pte_t *page_table = (pte_t *)get_safe_page(GFP_ATOMIC);
+		if (!page_table)
+			return NULL;
+
+		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
+
+		BUG_ON(page_table != pte_offset_kernel(pmd, 0));
+
+		return page_table;
+	}
+
+	return pte_offset_kernel(pmd, 0);
+}
+
+/*
+ * This maps the physical memory to kernel virtual address space, a total
+ * of max_low_pfn pages, by creating page tables starting from address
+ * PAGE_OFFSET.  The page tables are allocated out of resume-safe pages.
+ */
+static int resume_physical_mapping_init(pgd_t *pgd_base)
+{
+	unsigned long pfn;
+	pgd_t *pgd;
+	pmd_t *pmd;
+	pte_t *pte;
+	int pgd_idx, pmd_idx;
+
+	pgd_idx = pgd_index(PAGE_OFFSET);
+	pgd = pgd_base + pgd_idx;
+	pfn = 0;
+
+	for (; pgd_idx < PTRS_PER_PGD; pgd++, pgd_idx++) {
+		pmd = resume_one_md_table_init(pgd);
+		if (!pmd)
+			return -ENOMEM;
+
+		if (pfn >= max_low_pfn)
+			continue;
+
+		for (pmd_idx = 0; pmd_idx < PTRS_PER_PMD; pmd++, pmd_idx++) {
+			if (pfn >= max_low_pfn)
+				break;
+
+			/* Map with big pages if possible, otherwise create
+			 * normal page tables.
+			 * NOTE: We can mark everything as executable here
+			 */
+			if (cpu_has_pse) {
+				set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE_EXEC));
+				pfn += PTRS_PER_PTE;
+			} else {
+				pte_t *max_pte;
+
+				pte = resume_one_page_table_init(pmd);
+				if (!pte)
+					return -ENOMEM;
+
+				max_pte = pte + PTRS_PER_PTE;
+				for (; pte < max_pte; pte++, pfn++) {
+					if (pfn >= max_low_pfn)
+						break;
+
+					set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
+				}
+			}
+		}
+	}
+	return 0;
+}
+
+static inline void resume_init_first_level_page_table(pgd_t *pg_dir)
+{
+#ifdef CONFIG_X86_PAE
+	int i;
+
+	/* Init entries of the first-level page table to the zero page */
+	for (i = 0; i < PTRS_PER_PGD; i++)
+		set_pgd(pg_dir + i,
+			__pgd(__pa(empty_zero_page) | _PAGE_PRESENT));
+#endif
+}
+
+int swsusp_arch_resume(void)
+{
+	int error;
+
+	resume_pg_dir = (pgd_t *)get_safe_page(GFP_ATOMIC);
+	if (!resume_pg_dir)
+		return -ENOMEM;
+
+	resume_init_first_level_page_table(resume_pg_dir);
+	error = resume_physical_mapping_init(resume_pg_dir);
+	if (error)
+		return error;
+
+	/* We have got enough memory and from now on we cannot recover */
+	restore_image();
+	return 0;
+}
+
+/*
+ *	pfn_is_nosave - check if given pfn is in the 'nosave' section
+ */
+
+int pfn_is_nosave(unsigned long pfn)
+{
+	unsigned long nosave_begin_pfn = __pa_symbol(&__nosave_begin) >> PAGE_SHIFT;
+	unsigned long nosave_end_pfn = PAGE_ALIGN(__pa_symbol(&__nosave_end)) >> PAGE_SHIFT;
+	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
+}
Index: linux-2.6/arch/x86/power/hibernate_asm_32.S
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/power/hibernate_asm_32.S
@@ -0,0 +1,77 @@
+.text
+
+/*
+ * This may not use any stack, nor any variable that is not "NoSave":
+ *
+ * Its rewriting one kernel image with another. What is stack in "old"
+ * image could very well be data page in "new" image, and overwriting
+ * your own stack under you is bad idea.
+ */
+
+#include <linux/linkage.h>
+#include <asm/segment.h>
+#include <asm/page.h>
+#include <asm/asm-offsets.h>
+
+	.text
+
+ENTRY(swsusp_arch_suspend)
+
+	movl %esp, saved_context_esp
+	movl %ebx, saved_context_ebx
+	movl %ebp, saved_context_ebp
+	movl %esi, saved_context_esi
+	movl %edi, saved_context_edi
+	pushfl ; popl saved_context_eflags
+
+	call swsusp_save
+	ret
+
+ENTRY(restore_image)
+	movl	resume_pg_dir, %ecx
+	subl	$__PAGE_OFFSET, %ecx
+	movl	%ecx, %cr3
+
+	movl	restore_pblist, %edx
+	.p2align 4,,7
+
+copy_loop:
+	testl	%edx, %edx
+	jz	done
+
+	movl	pbe_address(%edx), %esi
+	movl	pbe_orig_address(%edx), %edi
+
+	movl	$1024, %ecx
+	rep
+	movsl
+
+	movl	pbe_next(%edx), %edx
+	jmp	copy_loop
+	.p2align 4,,7
+
+done:
+	/* go back to the original page tables */
+	movl	$swapper_pg_dir, %ecx
+	subl	$__PAGE_OFFSET, %ecx
+	movl	%ecx, %cr3
+	/* Flush TLB, including "global" things (vmalloc) */
+	movl	mmu_cr4_features, %eax
+	movl	%eax, %edx
+	andl	$~(1<<7), %edx;  # PGE
+	movl	%edx, %cr4;  # turn off PGE
+	movl	%cr3, %ecx;  # flush TLB
+	movl	%ecx, %cr3
+	movl	%eax, %cr4;  # turn PGE back on
+
+	movl saved_context_esp, %esp
+	movl saved_context_ebp, %ebp
+	movl saved_context_ebx, %ebx
+	movl saved_context_esi, %esi
+	movl saved_context_edi, %edi
+
+	pushl saved_context_eflags ; popfl
+
+	xorl	%eax, %eax
+
+	ret
Index: linux-2.6/arch/x86/power/suspend.c
===================================================================
--- linux-2.6.orig/arch/x86/power/suspend.c
+++ /dev/null
@@ -1,172 +0,0 @@
-/*
- * Suspend support specific for i386 - temporary page tables
- *
- * Distribute under GPLv2
- *
- * Copyright (c) 2006 Rafael J. Wysocki <rjw@sisk.pl>
- */
-
-#include <linux/suspend.h>
-#include <linux/bootmem.h>
-
-#include <asm/system.h>
-#include <asm/page.h>
-#include <asm/pgtable.h>
-
-/* Defined in arch/i386/power/swsusp.S */
-extern int restore_image(void);
-
-/* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
-
-/* Pointer to the temporary resume page tables */
-pgd_t *resume_pg_dir;
-
-/* The following three functions are based on the analogous code in
- * arch/i386/mm/init.c
- */
-
-/*
- * Create a middle page table on a resume-safe page and put a pointer to it in
- * the given global directory entry.  This only returns the gd entry
- * in non-PAE compilation mode, since the middle layer is folded.
- */
-static pmd_t *resume_one_md_table_init(pgd_t *pgd)
-{
-	pud_t *pud;
-	pmd_t *pmd_table;
-
-#ifdef CONFIG_X86_PAE
-	pmd_table = (pmd_t *)get_safe_page(GFP_ATOMIC);
-	if (!pmd_table)
-		return NULL;
-
-	set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
-	pud = pud_offset(pgd, 0);
-
-	BUG_ON(pmd_table != pmd_offset(pud, 0));
-#else
-	pud = pud_offset(pgd, 0);
-	pmd_table = pmd_offset(pud, 0);
-#endif
-
-	return pmd_table;
-}
-
-/*
- * Create a page table on a resume-safe page and place a pointer to it in
- * a middle page directory entry.
- */
-static pte_t *resume_one_page_table_init(pmd_t *pmd)
-{
-	if (pmd_none(*pmd)) {
-		pte_t *page_table = (pte_t *)get_safe_page(GFP_ATOMIC);
-		if (!page_table)
-			return NULL;
-
-		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
-
-		BUG_ON(page_table != pte_offset_kernel(pmd, 0));
-
-		return page_table;
-	}
-
-	return pte_offset_kernel(pmd, 0);
-}
-
-/*
- * This maps the physical memory to kernel virtual address space, a total
- * of max_low_pfn pages, by creating page tables starting from address
- * PAGE_OFFSET.  The page tables are allocated out of resume-safe pages.
- */
-static int resume_physical_mapping_init(pgd_t *pgd_base)
-{
-	unsigned long pfn;
-	pgd_t *pgd;
-	pmd_t *pmd;
-	pte_t *pte;
-	int pgd_idx, pmd_idx;
-
-	pgd_idx = pgd_index(PAGE_OFFSET);
-	pgd = pgd_base + pgd_idx;
-	pfn = 0;
-
-	for (; pgd_idx < PTRS_PER_PGD; pgd++, pgd_idx++) {
-		pmd = resume_one_md_table_init(pgd);
-		if (!pmd)
-			return -ENOMEM;
-
-		if (pfn >= max_low_pfn)
-			continue;
-
-		for (pmd_idx = 0; pmd_idx < PTRS_PER_PMD; pmd++, pmd_idx++) {
-			if (pfn >= max_low_pfn)
-				break;
-
-			/* Map with big pages if possible, otherwise create
-			 * normal page tables.
-			 * NOTE: We can mark everything as executable here
-			 */
-			if (cpu_has_pse) {
-				set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE_EXEC));
-				pfn += PTRS_PER_PTE;
-			} else {
-				pte_t *max_pte;
-
-				pte = resume_one_page_table_init(pmd);
-				if (!pte)
-					return -ENOMEM;
-
-				max_pte = pte + PTRS_PER_PTE;
-				for (; pte < max_pte; pte++, pfn++) {
-					if (pfn >= max_low_pfn)
-						break;
-
-					set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
-				}
-			}
-		}
-	}
-	return 0;
-}
-
-static inline void resume_init_first_level_page_table(pgd_t *pg_dir)
-{
-#ifdef CONFIG_X86_PAE
-	int i;
-
-	/* Init entries of the first-level page table to the zero page */
-	for (i = 0; i < PTRS_PER_PGD; i++)
-		set_pgd(pg_dir + i,
-			__pgd(__pa(empty_zero_page) | _PAGE_PRESENT));
-#endif
-}
-
-int swsusp_arch_resume(void)
-{
-	int error;
-
-	resume_pg_dir = (pgd_t *)get_safe_page(GFP_ATOMIC);
-	if (!resume_pg_dir)
-		return -ENOMEM;
-
-	resume_init_first_level_page_table(resume_pg_dir);
-	error = resume_physical_mapping_init(resume_pg_dir);
-	if (error)
-		return error;
-
-	/* We have got enough memory and from now on we cannot recover */
-	restore_image();
-	return 0;
-}
-
-/*
- *	pfn_is_nosave - check if given pfn is in the 'nosave' section
- */
-
-int pfn_is_nosave(unsigned long pfn)
-{
-	unsigned long nosave_begin_pfn = __pa_symbol(&__nosave_begin) >> PAGE_SHIFT;
-	unsigned long nosave_end_pfn = PAGE_ALIGN(__pa_symbol(&__nosave_end)) >> PAGE_SHIFT;
-	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
-}
Index: linux-2.6/arch/x86/power/swsusp.S
===================================================================
--- linux-2.6.orig/arch/x86/power/swsusp.S
+++ /dev/null
@@ -1,78 +0,0 @@
-.text
-
-/* Originally gcc generated, modified by hand
- *
- * This may not use any stack, nor any variable that is not "NoSave":
- *
- * Its rewriting one kernel image with another. What is stack in "old"
- * image could very well be data page in "new" image, and overwriting
- * your own stack under you is bad idea.
- */
-
-#include <linux/linkage.h>
-#include <asm/segment.h>
-#include <asm/page.h>
-#include <asm/asm-offsets.h>
-
-	.text
-
-ENTRY(swsusp_arch_suspend)
-
-	movl %esp, saved_context_esp
-	movl %ebx, saved_context_ebx
-	movl %ebp, saved_context_ebp
-	movl %esi, saved_context_esi
-	movl %edi, saved_context_edi
-	pushfl ; popl saved_context_eflags
-
-	call swsusp_save
-	ret
-
-ENTRY(restore_image)
-	movl	resume_pg_dir, %ecx
-	subl	$__PAGE_OFFSET, %ecx
-	movl	%ecx, %cr3
-
-	movl	restore_pblist, %edx
-	.p2align 4,,7
-
-copy_loop:
-	testl	%edx, %edx
-	jz	done
-
-	movl	pbe_address(%edx), %esi
-	movl	pbe_orig_address(%edx), %edi
-
-	movl	$1024, %ecx
-	rep
-	movsl
-
-	movl	pbe_next(%edx), %edx
-	jmp	copy_loop
-	.p2align 4,,7
-
-done:
-	/* go back to the original page tables */
-	movl	$swapper_pg_dir, %ecx
-	subl	$__PAGE_OFFSET, %ecx
-	movl	%ecx, %cr3
-	/* Flush TLB, including "global" things (vmalloc) */
-	movl	mmu_cr4_features, %eax
-	movl	%eax, %edx
-	andl	$~(1<<7), %edx;  # PGE
-	movl	%edx, %cr4;  # turn off PGE
-	movl	%cr3, %ecx;  # flush TLB
-	movl	%ecx, %cr3
-	movl	%eax, %cr4;  # turn PGE back on
-
-	movl saved_context_esp, %esp
-	movl saved_context_ebp, %ebp
-	movl saved_context_ebx, %ebx
-	movl saved_context_esi, %esi
-	movl saved_context_edi, %edi
-
-	pushl saved_context_eflags ; popfl
-
-	xorl	%eax, %eax
-
-	ret
Index: linux-2.6/arch/x86/power/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/power/Makefile
+++ linux-2.6/arch/x86/power/Makefile
@@ -2,6 +2,6 @@ ifeq ($(CONFIG_X86_64),y)
         obj-$(CONFIG_PM)		+= suspend_64.o
         obj-$(CONFIG_HIBERNATION)	+= hibernate_asm_64.o
 else
-	obj-$(CONFIG_PM)		+= cpu.o
-	obj-$(CONFIG_HIBERNATION)	+= swsusp.o suspend.o
+	obj-$(CONFIG_PM)		+= cpu_32.o
+	obj-$(CONFIG_HIBERNATION)	+= hibernate_32.o hibernate_asm_32.o
 endif

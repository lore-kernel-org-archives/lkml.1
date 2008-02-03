Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYBCVEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYBCVEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYBCVDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:03:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41424 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbYBCVDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:03:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/4] x86 PM: Move 64-bit hibernation files to arch/x86/power
Date: Sun, 3 Feb 2008 21:57:45 +0100
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
Message-Id: <200802032157.46464.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Move arch/x86/kernel/suspend_64.c to arch/x86/power .

Move arch/x86/kernel/suspend_asm_64.S to arch/x86/power
as hibernate_asm_64.S .

Update purpose and copyright information in
arch/x86/power/suspend_64.c and
arch/x86/power/hibernate_asm_64.S .

Update the Makefiles in arch/x86, arch/x86/kernel and
arch/x86/power to reflect the above changes.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/Makefile                 |    4 
 arch/x86/kernel/Makefile          |    2 
 arch/x86/kernel/suspend_64.c      |  320 -------------------------------------
 arch/x86/kernel/suspend_asm_64.S  |  141 ----------------
 arch/x86/power/Makefile           |    9 -
 arch/x86/power/hibernate_asm_64.S |  146 +++++++++++++++++
 arch/x86/power/suspend_64.c       |  321 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 477 insertions(+), 466 deletions(-)

Index: linux-2.6/arch/x86/kernel/suspend_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/suspend_64.c
+++ /dev/null
@@ -1,320 +0,0 @@
-/*
- * Suspend support specific for i386.
- *
- * Distribute under GPLv2
- *
- * Copyright (c) 2002 Pavel Machek <pavel@suse.cz>
- * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
- */
-
-#include <linux/smp.h>
-#include <linux/suspend.h>
-#include <asm/proto.h>
-#include <asm/page.h>
-#include <asm/pgtable.h>
-#include <asm/mtrr.h>
-
-/* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
-
-static void fix_processor_context(void);
-
-struct saved_context saved_context;
-
-/**
- *	__save_processor_state - save CPU registers before creating a
- *		hibernation image and before restoring the memory state from it
- *	@ctxt - structure to store the registers contents in
- *
- *	NOTE: If there is a CPU register the modification of which by the
- *	boot kernel (ie. the kernel used for loading the hibernation image)
- *	might affect the operations of the restored target kernel (ie. the one
- *	saved in the hibernation image), then its contents must be saved by this
- *	function.  In other words, if kernel A is hibernated and different
- *	kernel B is used for loading the hibernation image into memory, the
- *	kernel A's __save_processor_state() function must save all registers
- *	needed by kernel A, so that it can operate correctly after the resume
- *	regardless of what kernel B does in the meantime.
- */
-static void __save_processor_state(struct saved_context *ctxt)
-{
-	kernel_fpu_begin();
-
-	/*
-	 * descriptor tables
-	 */
-	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
-	store_idt((struct desc_ptr *)&ctxt->idt_limit);
-	store_tr(ctxt->tr);
-
-	/* XMM0..XMM15 should be handled by kernel_fpu_begin(). */
-	/*
-	 * segment registers
-	 */
-	asm volatile ("movw %%ds, %0" : "=m" (ctxt->ds));
-	asm volatile ("movw %%es, %0" : "=m" (ctxt->es));
-	asm volatile ("movw %%fs, %0" : "=m" (ctxt->fs));
-	asm volatile ("movw %%gs, %0" : "=m" (ctxt->gs));
-	asm volatile ("movw %%ss, %0" : "=m" (ctxt->ss));
-
-	rdmsrl(MSR_FS_BASE, ctxt->fs_base);
-	rdmsrl(MSR_GS_BASE, ctxt->gs_base);
-	rdmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
-	mtrr_save_fixed_ranges(NULL);
-
-	/*
-	 * control registers 
-	 */
-	rdmsrl(MSR_EFER, ctxt->efer);
-	ctxt->cr0 = read_cr0();
-	ctxt->cr2 = read_cr2();
-	ctxt->cr3 = read_cr3();
-	ctxt->cr4 = read_cr4();
-	ctxt->cr8 = read_cr8();
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
-	 * Restore FPU regs if necessary
-	 */
-	kernel_fpu_end();
-}
-
-/**
- *	__restore_processor_state - restore the contents of CPU registers saved
- *		by __save_processor_state()
- *	@ctxt - structure to load the registers contents from
- */
-static void __restore_processor_state(struct saved_context *ctxt)
-{
-	/*
-	 * control registers
-	 */
-	wrmsrl(MSR_EFER, ctxt->efer);
-	write_cr8(ctxt->cr8);
-	write_cr4(ctxt->cr4);
-	write_cr3(ctxt->cr3);
-	write_cr2(ctxt->cr2);
-	write_cr0(ctxt->cr0);
-
-	/*
-	 * now restore the descriptor tables to their proper values
-	 * ltr is done i fix_processor_context().
-	 */
-	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
-	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
-
-
-	/*
-	 * segment registers
-	 */
-	asm volatile ("movw %0, %%ds" :: "r" (ctxt->ds));
-	asm volatile ("movw %0, %%es" :: "r" (ctxt->es));
-	asm volatile ("movw %0, %%fs" :: "r" (ctxt->fs));
-	load_gs_index(ctxt->gs);
-	asm volatile ("movw %0, %%ss" :: "r" (ctxt->ss));
-
-	wrmsrl(MSR_FS_BASE, ctxt->fs_base);
-	wrmsrl(MSR_GS_BASE, ctxt->gs_base);
-	wrmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
-
-	fix_processor_context();
-
-	do_fpu_end();
-	mtrr_ap_init();
-}
-
-void restore_processor_state(void)
-{
-	__restore_processor_state(&saved_context);
-}
-
-static void fix_processor_context(void)
-{
-	int cpu = smp_processor_id();
-	struct tss_struct *t = &per_cpu(init_tss, cpu);
-
-	/*
-	 * This just modifies memory; should not be necessary. But... This
-	 * is necessary, because 386 hardware has concept of busy TSS or some
-	 * similar stupidity.
-	 */
-	set_tss_desc(cpu, t);
-
-	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
-
-	syscall_init();                         /* This sets MSR_*STAR and related */
-	load_TR_desc();				/* This does ltr */
-	load_LDT(&current->active_mm->context);	/* This does lldt */
-
-	/*
-	 * Now maybe reload the debug registers
-	 */
-	if (current->thread.debugreg7){
-                loaddebug(&current->thread, 0);
-                loaddebug(&current->thread, 1);
-                loaddebug(&current->thread, 2);
-                loaddebug(&current->thread, 3);
-                /* no 4 and 5 */
-                loaddebug(&current->thread, 6);
-                loaddebug(&current->thread, 7);
-	}
-}
-
-#ifdef CONFIG_HIBERNATION
-/* Defined in arch/x86_64/kernel/suspend_asm.S */
-extern int restore_image(void);
-
-/*
- * Address to jump to in the last phase of restore in order to get to the image
- * kernel's text (this value is passed in the image header).
- */
-unsigned long restore_jump_address;
-
-/*
- * Value of the cr3 register from before the hibernation (this value is passed
- * in the image header).
- */
-unsigned long restore_cr3;
-
-pgd_t *temp_level4_pgt;
-
-void *relocated_restore_code;
-
-static int res_phys_pud_init(pud_t *pud, unsigned long address, unsigned long end)
-{
-	long i, j;
-
-	i = pud_index(address);
-	pud = pud + i;
-	for (; i < PTRS_PER_PUD; pud++, i++) {
-		unsigned long paddr;
-		pmd_t *pmd;
-
-		paddr = address + i*PUD_SIZE;
-		if (paddr >= end)
-			break;
-
-		pmd = (pmd_t *)get_safe_page(GFP_ATOMIC);
-		if (!pmd)
-			return -ENOMEM;
-		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
-		for (j = 0; j < PTRS_PER_PMD; pmd++, j++, paddr += PMD_SIZE) {
-			unsigned long pe;
-
-			if (paddr >= end)
-				break;
-			pe = __PAGE_KERNEL_LARGE_EXEC | paddr;
-			pe &= __supported_pte_mask;
-			set_pmd(pmd, __pmd(pe));
-		}
-	}
-	return 0;
-}
-
-static int set_up_temporary_mappings(void)
-{
-	unsigned long start, end, next;
-	int error;
-
-	temp_level4_pgt = (pgd_t *)get_safe_page(GFP_ATOMIC);
-	if (!temp_level4_pgt)
-		return -ENOMEM;
-
-	/* It is safe to reuse the original kernel mapping */
-	set_pgd(temp_level4_pgt + pgd_index(__START_KERNEL_map),
-		init_level4_pgt[pgd_index(__START_KERNEL_map)]);
-
-	/* Set up the direct mapping from scratch */
-	start = (unsigned long)pfn_to_kaddr(0);
-	end = (unsigned long)pfn_to_kaddr(end_pfn);
-
-	for (; start < end; start = next) {
-		pud_t *pud = (pud_t *)get_safe_page(GFP_ATOMIC);
-		if (!pud)
-			return -ENOMEM;
-		next = start + PGDIR_SIZE;
-		if (next > end)
-			next = end;
-		if ((error = res_phys_pud_init(pud, __pa(start), __pa(next))))
-			return error;
-		set_pgd(temp_level4_pgt + pgd_index(start),
-			mk_kernel_pgd(__pa(pud)));
-	}
-	return 0;
-}
-
-int swsusp_arch_resume(void)
-{
-	int error;
-
-	/* We have got enough memory and from now on we cannot recover */
-	if ((error = set_up_temporary_mappings()))
-		return error;
-
-	relocated_restore_code = (void *)get_safe_page(GFP_ATOMIC);
-	if (!relocated_restore_code)
-		return -ENOMEM;
-	memcpy(relocated_restore_code, &core_restore_code,
-	       &restore_registers - &core_restore_code);
-
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
-
-struct restore_data_record {
-	unsigned long jump_address;
-	unsigned long cr3;
-	unsigned long magic;
-};
-
-#define RESTORE_MAGIC	0x0123456789ABCDEFUL
-
-/**
- *	arch_hibernation_header_save - populate the architecture specific part
- *		of a hibernation image header
- *	@addr: address to save the data at
- */
-int arch_hibernation_header_save(void *addr, unsigned int max_size)
-{
-	struct restore_data_record *rdr = addr;
-
-	if (max_size < sizeof(struct restore_data_record))
-		return -EOVERFLOW;
-	rdr->jump_address = restore_jump_address;
-	rdr->cr3 = restore_cr3;
-	rdr->magic = RESTORE_MAGIC;
-	return 0;
-}
-
-/**
- *	arch_hibernation_header_restore - read the architecture specific data
- *		from the hibernation image header
- *	@addr: address to read the data from
- */
-int arch_hibernation_header_restore(void *addr)
-{
-	struct restore_data_record *rdr = addr;
-
-	restore_jump_address = rdr->jump_address;
-	restore_cr3 = rdr->cr3;
-	return (rdr->magic == RESTORE_MAGIC) ? 0 : -EINVAL;
-}
-#endif /* CONFIG_HIBERNATION */
Index: linux-2.6/arch/x86/kernel/suspend_asm_64.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/suspend_asm_64.S
+++ /dev/null
@@ -1,141 +0,0 @@
-/* Copyright 2004,2005 Pavel Machek <pavel@suse.cz>, Andi Kleen <ak@suse.de>, Rafael J. Wysocki <rjw@sisk.pl>
- *
- * Distribute under GPLv2.
- *
- * swsusp_arch_resume must not use any stack or any nonlocal variables while
- * copying pages:
- *
- * Its rewriting one kernel image with another. What is stack in "old"
- * image could very well be data page in "new" image, and overwriting
- * your own stack under you is bad idea.
- */
-	
-	.text
-#include <linux/linkage.h>
-#include <asm/segment.h>
-#include <asm/page.h>
-#include <asm/asm-offsets.h>
-
-ENTRY(swsusp_arch_suspend)
-	movq	$saved_context, %rax
-	movq	%rsp, pt_regs_sp(%rax)
-	movq	%rbp, pt_regs_bp(%rax)
-	movq	%rsi, pt_regs_si(%rax)
-	movq	%rdi, pt_regs_di(%rax)
-	movq	%rbx, pt_regs_bx(%rax)
-	movq	%rcx, pt_regs_cx(%rax)
-	movq	%rdx, pt_regs_dx(%rax)
-	movq	%r8, pt_regs_r8(%rax)
-	movq	%r9, pt_regs_r9(%rax)
-	movq	%r10, pt_regs_r10(%rax)
-	movq	%r11, pt_regs_r11(%rax)
-	movq	%r12, pt_regs_r12(%rax)
-	movq	%r13, pt_regs_r13(%rax)
-	movq	%r14, pt_regs_r14(%rax)
-	movq	%r15, pt_regs_r15(%rax)
-	pushfq
-	popq	pt_regs_flags(%rax)
-
-	/* save the address of restore_registers */
-	movq	$restore_registers, %rax
-	movq	%rax, restore_jump_address(%rip)
-	/* save cr3 */
-	movq	%cr3, %rax
-	movq	%rax, restore_cr3(%rip)
-
-	call swsusp_save
-	ret
-
-ENTRY(restore_image)
-	/* switch to temporary page tables */
-	movq	$__PAGE_OFFSET, %rdx
-	movq	temp_level4_pgt(%rip), %rax
-	subq	%rdx, %rax
-	movq	%rax, %cr3
-	/* Flush TLB */
-	movq	mmu_cr4_features(%rip), %rax
-	movq	%rax, %rdx
-	andq	$~(1<<7), %rdx	# PGE
-	movq	%rdx, %cr4;  # turn off PGE
-	movq	%cr3, %rcx;  # flush TLB
-	movq	%rcx, %cr3;
-	movq	%rax, %cr4;  # turn PGE back on
-
-	/* prepare to jump to the image kernel */
-	movq	restore_jump_address(%rip), %rax
-	movq	restore_cr3(%rip), %rbx
-
-	/* prepare to copy image data to their original locations */
-	movq	restore_pblist(%rip), %rdx
-	movq	relocated_restore_code(%rip), %rcx
-	jmpq	*%rcx
-
-	/* code below has been relocated to a safe page */
-ENTRY(core_restore_code)
-loop:
-	testq	%rdx, %rdx
-	jz	done
-
-	/* get addresses from the pbe and copy the page */
-	movq	pbe_address(%rdx), %rsi
-	movq	pbe_orig_address(%rdx), %rdi
-	movq	$(PAGE_SIZE >> 3), %rcx
-	rep
-	movsq
-
-	/* progress to the next pbe */
-	movq	pbe_next(%rdx), %rdx
-	jmp	loop
-done:
-	/* jump to the restore_registers address from the image header */
-	jmpq	*%rax
-	/*
-	 * NOTE: This assumes that the boot kernel's text mapping covers the
-	 * image kernel's page containing restore_registers and the address of
-	 * this page is the same as in the image kernel's text mapping (it
-	 * should always be true, because the text mapping is linear, starting
-	 * from 0, and is supposed to cover the entire kernel text for every
-	 * kernel).
-	 *
-	 * code below belongs to the image kernel
-	 */
-
-ENTRY(restore_registers)
-	/* go back to the original page tables */
-	movq    %rbx, %cr3
-
-	/* Flush TLB, including "global" things (vmalloc) */
-	movq	mmu_cr4_features(%rip), %rax
-	movq	%rax, %rdx
-	andq	$~(1<<7), %rdx;  # PGE
-	movq	%rdx, %cr4;  # turn off PGE
-	movq	%cr3, %rcx;  # flush TLB
-	movq	%rcx, %cr3
-	movq	%rax, %cr4;  # turn PGE back on
-
-	/* We don't restore %rax, it must be 0 anyway */
-	movq	$saved_context, %rax
-	movq	pt_regs_sp(%rax), %rsp
-	movq	pt_regs_bp(%rax), %rbp
-	movq	pt_regs_si(%rax), %rsi
-	movq	pt_regs_di(%rax), %rdi
-	movq	pt_regs_bx(%rax), %rbx
-	movq	pt_regs_cx(%rax), %rcx
-	movq	pt_regs_dx(%rax), %rdx
-	movq	pt_regs_r8(%rax), %r8
-	movq	pt_regs_r9(%rax), %r9
-	movq	pt_regs_r10(%rax), %r10
-	movq	pt_regs_r11(%rax), %r11
-	movq	pt_regs_r12(%rax), %r12
-	movq	pt_regs_r13(%rax), %r13
-	movq	pt_regs_r14(%rax), %r14
-	movq	pt_regs_r15(%rax), %r15
-	pushq	pt_regs_flags(%rax)
-	popfq
-
-	xorq	%rax, %rax
-
-	/* tell the hibernation core that we've just restored the memory */
-	movq	%rax, in_suspend(%rip)
-
-	ret
Index: linux-2.6/arch/x86/power/hibernate_asm_64.S
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/power/hibernate_asm_64.S
@@ -0,0 +1,146 @@
+/*
+ * Hibernation support for x86-64
+ *
+ * Distribute under GPLv2.
+ *
+ * Copyright 2007 Rafael J. Wysocki <rjw@sisk.pl>
+ * Copyright 2005 Andi Kleen <ak@suse.de>
+ * Copyright 2004 Pavel Machek <pavel@suse.cz>
+ *
+ * swsusp_arch_resume must not use any stack or any nonlocal variables while
+ * copying pages:
+ *
+ * Its rewriting one kernel image with another. What is stack in "old"
+ * image could very well be data page in "new" image, and overwriting
+ * your own stack under you is bad idea.
+ */
+
+	.text
+#include <linux/linkage.h>
+#include <asm/segment.h>
+#include <asm/page.h>
+#include <asm/asm-offsets.h>
+
+ENTRY(swsusp_arch_suspend)
+	movq	$saved_context, %rax
+	movq	%rsp, pt_regs_sp(%rax)
+	movq	%rbp, pt_regs_bp(%rax)
+	movq	%rsi, pt_regs_si(%rax)
+	movq	%rdi, pt_regs_di(%rax)
+	movq	%rbx, pt_regs_bx(%rax)
+	movq	%rcx, pt_regs_cx(%rax)
+	movq	%rdx, pt_regs_dx(%rax)
+	movq	%r8, pt_regs_r8(%rax)
+	movq	%r9, pt_regs_r9(%rax)
+	movq	%r10, pt_regs_r10(%rax)
+	movq	%r11, pt_regs_r11(%rax)
+	movq	%r12, pt_regs_r12(%rax)
+	movq	%r13, pt_regs_r13(%rax)
+	movq	%r14, pt_regs_r14(%rax)
+	movq	%r15, pt_regs_r15(%rax)
+	pushfq
+	popq	pt_regs_flags(%rax)
+
+	/* save the address of restore_registers */
+	movq	$restore_registers, %rax
+	movq	%rax, restore_jump_address(%rip)
+	/* save cr3 */
+	movq	%cr3, %rax
+	movq	%rax, restore_cr3(%rip)
+
+	call swsusp_save
+	ret
+
+ENTRY(restore_image)
+	/* switch to temporary page tables */
+	movq	$__PAGE_OFFSET, %rdx
+	movq	temp_level4_pgt(%rip), %rax
+	subq	%rdx, %rax
+	movq	%rax, %cr3
+	/* Flush TLB */
+	movq	mmu_cr4_features(%rip), %rax
+	movq	%rax, %rdx
+	andq	$~(1<<7), %rdx	# PGE
+	movq	%rdx, %cr4;  # turn off PGE
+	movq	%cr3, %rcx;  # flush TLB
+	movq	%rcx, %cr3;
+	movq	%rax, %cr4;  # turn PGE back on
+
+	/* prepare to jump to the image kernel */
+	movq	restore_jump_address(%rip), %rax
+	movq	restore_cr3(%rip), %rbx
+
+	/* prepare to copy image data to their original locations */
+	movq	restore_pblist(%rip), %rdx
+	movq	relocated_restore_code(%rip), %rcx
+	jmpq	*%rcx
+
+	/* code below has been relocated to a safe page */
+ENTRY(core_restore_code)
+loop:
+	testq	%rdx, %rdx
+	jz	done
+
+	/* get addresses from the pbe and copy the page */
+	movq	pbe_address(%rdx), %rsi
+	movq	pbe_orig_address(%rdx), %rdi
+	movq	$(PAGE_SIZE >> 3), %rcx
+	rep
+	movsq
+
+	/* progress to the next pbe */
+	movq	pbe_next(%rdx), %rdx
+	jmp	loop
+done:
+	/* jump to the restore_registers address from the image header */
+	jmpq	*%rax
+	/*
+	 * NOTE: This assumes that the boot kernel's text mapping covers the
+	 * image kernel's page containing restore_registers and the address of
+	 * this page is the same as in the image kernel's text mapping (it
+	 * should always be true, because the text mapping is linear, starting
+	 * from 0, and is supposed to cover the entire kernel text for every
+	 * kernel).
+	 *
+	 * code below belongs to the image kernel
+	 */
+
+ENTRY(restore_registers)
+	/* go back to the original page tables */
+	movq    %rbx, %cr3
+
+	/* Flush TLB, including "global" things (vmalloc) */
+	movq	mmu_cr4_features(%rip), %rax
+	movq	%rax, %rdx
+	andq	$~(1<<7), %rdx;  # PGE
+	movq	%rdx, %cr4;  # turn off PGE
+	movq	%cr3, %rcx;  # flush TLB
+	movq	%rcx, %cr3
+	movq	%rax, %cr4;  # turn PGE back on
+
+	/* We don't restore %rax, it must be 0 anyway */
+	movq	$saved_context, %rax
+	movq	pt_regs_sp(%rax), %rsp
+	movq	pt_regs_bp(%rax), %rbp
+	movq	pt_regs_si(%rax), %rsi
+	movq	pt_regs_di(%rax), %rdi
+	movq	pt_regs_bx(%rax), %rbx
+	movq	pt_regs_cx(%rax), %rcx
+	movq	pt_regs_dx(%rax), %rdx
+	movq	pt_regs_r8(%rax), %r8
+	movq	pt_regs_r9(%rax), %r9
+	movq	pt_regs_r10(%rax), %r10
+	movq	pt_regs_r11(%rax), %r11
+	movq	pt_regs_r12(%rax), %r12
+	movq	pt_regs_r13(%rax), %r13
+	movq	pt_regs_r14(%rax), %r14
+	movq	pt_regs_r15(%rax), %r15
+	pushq	pt_regs_flags(%rax)
+	popfq
+
+	xorq	%rax, %rax
+
+	/* tell the hibernation core that we've just restored the memory */
+	movq	%rax, in_suspend(%rip)
+
+	ret
Index: linux-2.6/arch/x86/power/suspend_64.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/power/suspend_64.c
@@ -0,0 +1,321 @@
+/*
+ * Suspend and hibernation support for x86-64
+ *
+ * Distribute under GPLv2
+ *
+ * Copyright (c) 2007 Rafael J. Wysocki <rjw@sisk.pl>
+ * Copyright (c) 2002 Pavel Machek <pavel@suse.cz>
+ * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
+ */
+
+#include <linux/smp.h>
+#include <linux/suspend.h>
+#include <asm/proto.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/mtrr.h>
+
+/* References to section boundaries */
+extern const void __nosave_begin, __nosave_end;
+
+static void fix_processor_context(void);
+
+struct saved_context saved_context;
+
+/**
+ *	__save_processor_state - save CPU registers before creating a
+ *		hibernation image and before restoring the memory state from it
+ *	@ctxt - structure to store the registers contents in
+ *
+ *	NOTE: If there is a CPU register the modification of which by the
+ *	boot kernel (ie. the kernel used for loading the hibernation image)
+ *	might affect the operations of the restored target kernel (ie. the one
+ *	saved in the hibernation image), then its contents must be saved by this
+ *	function.  In other words, if kernel A is hibernated and different
+ *	kernel B is used for loading the hibernation image into memory, the
+ *	kernel A's __save_processor_state() function must save all registers
+ *	needed by kernel A, so that it can operate correctly after the resume
+ *	regardless of what kernel B does in the meantime.
+ */
+static void __save_processor_state(struct saved_context *ctxt)
+{
+	kernel_fpu_begin();
+
+	/*
+	 * descriptor tables
+	 */
+	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
+	store_idt((struct desc_ptr *)&ctxt->idt_limit);
+	store_tr(ctxt->tr);
+
+	/* XMM0..XMM15 should be handled by kernel_fpu_begin(). */
+	/*
+	 * segment registers
+	 */
+	asm volatile ("movw %%ds, %0" : "=m" (ctxt->ds));
+	asm volatile ("movw %%es, %0" : "=m" (ctxt->es));
+	asm volatile ("movw %%fs, %0" : "=m" (ctxt->fs));
+	asm volatile ("movw %%gs, %0" : "=m" (ctxt->gs));
+	asm volatile ("movw %%ss, %0" : "=m" (ctxt->ss));
+
+	rdmsrl(MSR_FS_BASE, ctxt->fs_base);
+	rdmsrl(MSR_GS_BASE, ctxt->gs_base);
+	rdmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
+	mtrr_save_fixed_ranges(NULL);
+
+	/*
+	 * control registers
+	 */
+	rdmsrl(MSR_EFER, ctxt->efer);
+	ctxt->cr0 = read_cr0();
+	ctxt->cr2 = read_cr2();
+	ctxt->cr3 = read_cr3();
+	ctxt->cr4 = read_cr4();
+	ctxt->cr8 = read_cr8();
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
+	 * Restore FPU regs if necessary
+	 */
+	kernel_fpu_end();
+}
+
+/**
+ *	__restore_processor_state - restore the contents of CPU registers saved
+ *		by __save_processor_state()
+ *	@ctxt - structure to load the registers contents from
+ */
+static void __restore_processor_state(struct saved_context *ctxt)
+{
+	/*
+	 * control registers
+	 */
+	wrmsrl(MSR_EFER, ctxt->efer);
+	write_cr8(ctxt->cr8);
+	write_cr4(ctxt->cr4);
+	write_cr3(ctxt->cr3);
+	write_cr2(ctxt->cr2);
+	write_cr0(ctxt->cr0);
+
+	/*
+	 * now restore the descriptor tables to their proper values
+	 * ltr is done i fix_processor_context().
+	 */
+	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
+	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
+
+
+	/*
+	 * segment registers
+	 */
+	asm volatile ("movw %0, %%ds" :: "r" (ctxt->ds));
+	asm volatile ("movw %0, %%es" :: "r" (ctxt->es));
+	asm volatile ("movw %0, %%fs" :: "r" (ctxt->fs));
+	load_gs_index(ctxt->gs);
+	asm volatile ("movw %0, %%ss" :: "r" (ctxt->ss));
+
+	wrmsrl(MSR_FS_BASE, ctxt->fs_base);
+	wrmsrl(MSR_GS_BASE, ctxt->gs_base);
+	wrmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
+
+	fix_processor_context();
+
+	do_fpu_end();
+	mtrr_ap_init();
+}
+
+void restore_processor_state(void)
+{
+	__restore_processor_state(&saved_context);
+}
+
+static void fix_processor_context(void)
+{
+	int cpu = smp_processor_id();
+	struct tss_struct *t = &per_cpu(init_tss, cpu);
+
+	/*
+	 * This just modifies memory; should not be necessary. But... This
+	 * is necessary, because 386 hardware has concept of busy TSS or some
+	 * similar stupidity.
+	 */
+	set_tss_desc(cpu, t);
+
+	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
+
+	syscall_init();                         /* This sets MSR_*STAR and related */
+	load_TR_desc();				/* This does ltr */
+	load_LDT(&current->active_mm->context);	/* This does lldt */
+
+	/*
+	 * Now maybe reload the debug registers
+	 */
+	if (current->thread.debugreg7){
+                loaddebug(&current->thread, 0);
+                loaddebug(&current->thread, 1);
+                loaddebug(&current->thread, 2);
+                loaddebug(&current->thread, 3);
+                /* no 4 and 5 */
+                loaddebug(&current->thread, 6);
+                loaddebug(&current->thread, 7);
+	}
+}
+
+#ifdef CONFIG_HIBERNATION
+/* Defined in arch/x86_64/kernel/suspend_asm.S */
+extern int restore_image(void);
+
+/*
+ * Address to jump to in the last phase of restore in order to get to the image
+ * kernel's text (this value is passed in the image header).
+ */
+unsigned long restore_jump_address;
+
+/*
+ * Value of the cr3 register from before the hibernation (this value is passed
+ * in the image header).
+ */
+unsigned long restore_cr3;
+
+pgd_t *temp_level4_pgt;
+
+void *relocated_restore_code;
+
+static int res_phys_pud_init(pud_t *pud, unsigned long address, unsigned long end)
+{
+	long i, j;
+
+	i = pud_index(address);
+	pud = pud + i;
+	for (; i < PTRS_PER_PUD; pud++, i++) {
+		unsigned long paddr;
+		pmd_t *pmd;
+
+		paddr = address + i*PUD_SIZE;
+		if (paddr >= end)
+			break;
+
+		pmd = (pmd_t *)get_safe_page(GFP_ATOMIC);
+		if (!pmd)
+			return -ENOMEM;
+		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+		for (j = 0; j < PTRS_PER_PMD; pmd++, j++, paddr += PMD_SIZE) {
+			unsigned long pe;
+
+			if (paddr >= end)
+				break;
+			pe = __PAGE_KERNEL_LARGE_EXEC | paddr;
+			pe &= __supported_pte_mask;
+			set_pmd(pmd, __pmd(pe));
+		}
+	}
+	return 0;
+}
+
+static int set_up_temporary_mappings(void)
+{
+	unsigned long start, end, next;
+	int error;
+
+	temp_level4_pgt = (pgd_t *)get_safe_page(GFP_ATOMIC);
+	if (!temp_level4_pgt)
+		return -ENOMEM;
+
+	/* It is safe to reuse the original kernel mapping */
+	set_pgd(temp_level4_pgt + pgd_index(__START_KERNEL_map),
+		init_level4_pgt[pgd_index(__START_KERNEL_map)]);
+
+	/* Set up the direct mapping from scratch */
+	start = (unsigned long)pfn_to_kaddr(0);
+	end = (unsigned long)pfn_to_kaddr(end_pfn);
+
+	for (; start < end; start = next) {
+		pud_t *pud = (pud_t *)get_safe_page(GFP_ATOMIC);
+		if (!pud)
+			return -ENOMEM;
+		next = start + PGDIR_SIZE;
+		if (next > end)
+			next = end;
+		if ((error = res_phys_pud_init(pud, __pa(start), __pa(next))))
+			return error;
+		set_pgd(temp_level4_pgt + pgd_index(start),
+			mk_kernel_pgd(__pa(pud)));
+	}
+	return 0;
+}
+
+int swsusp_arch_resume(void)
+{
+	int error;
+
+	/* We have got enough memory and from now on we cannot recover */
+	if ((error = set_up_temporary_mappings()))
+		return error;
+
+	relocated_restore_code = (void *)get_safe_page(GFP_ATOMIC);
+	if (!relocated_restore_code)
+		return -ENOMEM;
+	memcpy(relocated_restore_code, &core_restore_code,
+	       &restore_registers - &core_restore_code);
+
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
+
+struct restore_data_record {
+	unsigned long jump_address;
+	unsigned long cr3;
+	unsigned long magic;
+};
+
+#define RESTORE_MAGIC	0x0123456789ABCDEFUL
+
+/**
+ *	arch_hibernation_header_save - populate the architecture specific part
+ *		of a hibernation image header
+ *	@addr: address to save the data at
+ */
+int arch_hibernation_header_save(void *addr, unsigned int max_size)
+{
+	struct restore_data_record *rdr = addr;
+
+	if (max_size < sizeof(struct restore_data_record))
+		return -EOVERFLOW;
+	rdr->jump_address = restore_jump_address;
+	rdr->cr3 = restore_cr3;
+	rdr->magic = RESTORE_MAGIC;
+	return 0;
+}
+
+/**
+ *	arch_hibernation_header_restore - read the architecture specific data
+ *		from the hibernation image header
+ *	@addr: address to read the data from
+ */
+int arch_hibernation_header_restore(void *addr)
+{
+	struct restore_data_record *rdr = addr;
+
+	restore_jump_address = rdr->jump_address;
+	restore_cr3 = rdr->cr3;
+	return (rdr->magic == RESTORE_MAGIC) ? 0 : -EINVAL;
+}
+#endif /* CONFIG_HIBERNATION */
Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -82,8 +82,6 @@ ifeq ($(CONFIG_X86_64),y)
         obj-y				+= genapic_64.o genapic_flat_64.o
         obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
         obj-$(CONFIG_AUDIT)		+= audit_64.o
-        obj-$(CONFIG_PM)		+= suspend_64.o
-        obj-$(CONFIG_HIBERNATION)	+= suspend_asm_64.o
 
         obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
         obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
Index: linux-2.6/arch/x86/power/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/power/Makefile
+++ linux-2.6/arch/x86/power/Makefile
@@ -1,2 +1,7 @@
-obj-$(CONFIG_PM)		+= cpu.o
-obj-$(CONFIG_HIBERNATION)	+= swsusp.o suspend.o
+ifeq ($(CONFIG_X86_64),y)
+        obj-$(CONFIG_PM)		+= suspend_64.o
+        obj-$(CONFIG_HIBERNATION)	+= hibernate_asm_64.o
+else
+	obj-$(CONFIG_PM)		+= cpu.o
+	obj-$(CONFIG_HIBERNATION)	+= swsusp.o suspend.o
+endif
Index: linux-2.6/arch/x86/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/Makefile
+++ linux-2.6/arch/x86/Makefile
@@ -192,8 +192,10 @@ drivers-$(CONFIG_PCI)            += arch
 # must be linked after kernel/
 drivers-$(CONFIG_OPROFILE) += arch/x86/oprofile/
 
-ifeq ($(CONFIG_X86_32),y)
+# suspend and hibernation support
 drivers-$(CONFIG_PM) += arch/x86/power/
+
+ifeq ($(CONFIG_X86_32),y)
 drivers-$(CONFIG_FB) += arch/x86/video/
 endif
 

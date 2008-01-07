Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYAGNwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYAGNwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYAGNwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:52:46 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39592 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753187AbYAGNwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:52:44 -0500
Date: Mon, 7 Jan 2008 14:52:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Rename suspend/hibernation stuff for clarity
Message-ID: <20080107135236.GA17140@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/suspend_64.c and power/cpu.c were equivalent. Move them into
power/cpu_*.c for consistency.

power/swsusp.S and kernel/suspend_asm_64.S were both misnamed and
equivalent. Merge then minto power/hibernation_*.S.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 2a4fbaecebafff5b3114d0e87ecf73c45bc57f7b
tree a13462c0ae1fa640a9b9d08cfea0bf6056b26385
parent eafb847ccc4f73c2737157b510dcf7b040f53147
author Pavel <pavel@amd.ucw.cz> Mon, 07 Jan 2008 14:50:25 +0100
committer Pavel <pavel@amd.ucw.cz> Mon, 07 Jan 2008 14:50:25 +0100

 arch/x86/Makefile_64             |    1 
 arch/x86/kernel/Makefile_64      |    2 
 arch/x86/kernel/suspend_64.c     |  294 --------------------------------------
 arch/x86/kernel/suspend_asm_64.S |  141 ------------------
 arch/x86/power/Makefile          |   10 +
 arch/x86/power/cpu.c             |  133 -----------------
 arch/x86/power/cpu_32.c          |  133 +++++++++++++++++
 arch/x86/power/cpu_64.c          |  294 ++++++++++++++++++++++++++++++++++++++
 arch/x86/power/hibernation_32.S  |   78 ++++++++++
 arch/x86/power/hibernation_64.S  |  141 ++++++++++++++++++
 arch/x86/power/swsusp.S          |   78 ----------
 11 files changed, 655 insertions(+), 650 deletions(-)

diff --git a/arch/x86/Makefile_64 b/arch/x86/Makefile_64
index a804860..4938b6b 100644
--- a/arch/x86/Makefile_64
+++ b/arch/x86/Makefile_64
@@ -87,6 +87,7 @@ core-y					+= arch/x86/kernel/ \
 core-$(CONFIG_IA32_EMULATION)		+= arch/x86/ia32/
 drivers-$(CONFIG_PCI)			+= arch/x86/pci/
 drivers-$(CONFIG_OPROFILE)		+= arch/x86/oprofile/
+drivers-$(CONFIG_PM)			+= arch/x86/power/
 
 boot := arch/x86/boot
 
diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index 5a88890..cc79834 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -24,8 +24,6 @@ obj-y				+= apic_64.o  nmi_64.o
 obj-y				+= io_apic_64.o mpparse_64.o genapic_64.o genapic_flat_64.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_64.o relocate_kernel_64.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_64.o
-obj-$(CONFIG_PM)		+= suspend_64.o
-obj-$(CONFIG_HIBERNATION)	+= suspend_asm_64.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
 obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
diff --git a/arch/x86/kernel/suspend_64.c b/arch/x86/kernel/suspend_64.c
deleted file mode 100644
index 2e5efaa..0000000
--- a/arch/x86/kernel/suspend_64.c
+++ /dev/null
@@ -1,294 +0,0 @@
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
-struct saved_context saved_context;
-
-void __save_processor_state(struct saved_context *ctxt)
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
-void __restore_processor_state(struct saved_context *ctxt)
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
-void fix_processor_context(void)
-{
-	int cpu = smp_processor_id();
-	struct tss_struct *t = &per_cpu(init_tss, cpu);
-
-	set_tss_desc(cpu,t);	/* This just modifies memory; should not be necessary. But... This is necessary, because 386 hardware has concept of busy TSS or some similar stupidity. */
-
-	cpu_gdt(cpu)[GDT_ENTRY_TSS].type = 9;
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
-
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
diff --git a/arch/x86/kernel/suspend_asm_64.S b/arch/x86/kernel/suspend_asm_64.S
deleted file mode 100644
index 72f9521..0000000
--- a/arch/x86/kernel/suspend_asm_64.S
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
-	movq	%rsp, pt_regs_rsp(%rax)
-	movq	%rbp, pt_regs_rbp(%rax)
-	movq	%rsi, pt_regs_rsi(%rax)
-	movq	%rdi, pt_regs_rdi(%rax)
-	movq	%rbx, pt_regs_rbx(%rax)
-	movq	%rcx, pt_regs_rcx(%rax)
-	movq	%rdx, pt_regs_rdx(%rax)
-	movq	%r8, pt_regs_r8(%rax)
-	movq	%r9, pt_regs_r9(%rax)
-	movq	%r10, pt_regs_r10(%rax)
-	movq	%r11, pt_regs_r11(%rax)
-	movq	%r12, pt_regs_r12(%rax)
-	movq	%r13, pt_regs_r13(%rax)
-	movq	%r14, pt_regs_r14(%rax)
-	movq	%r15, pt_regs_r15(%rax)
-	pushfq
-	popq	pt_regs_eflags(%rax)
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
-	movq	pt_regs_rsp(%rax), %rsp
-	movq	pt_regs_rbp(%rax), %rbp
-	movq	pt_regs_rsi(%rax), %rsi
-	movq	pt_regs_rdi(%rax), %rdi
-	movq	pt_regs_rbx(%rax), %rbx
-	movq	pt_regs_rcx(%rax), %rcx
-	movq	pt_regs_rdx(%rax), %rdx
-	movq	pt_regs_r8(%rax), %r8
-	movq	pt_regs_r9(%rax), %r9
-	movq	pt_regs_r10(%rax), %r10
-	movq	pt_regs_r11(%rax), %r11
-	movq	pt_regs_r12(%rax), %r12
-	movq	pt_regs_r13(%rax), %r13
-	movq	pt_regs_r14(%rax), %r14
-	movq	pt_regs_r15(%rax), %r15
-	pushq	pt_regs_eflags(%rax)
-	popfq
-
-	xorq	%rax, %rax
-
-	/* tell the hibernation core that we've just restored the memory */
-	movq	%rax, in_suspend(%rip)
-
-	ret
diff --git a/arch/x86/power/Makefile b/arch/x86/power/Makefile
index d764ec9..dd99371 100644
--- a/arch/x86/power/Makefile
+++ b/arch/x86/power/Makefile
@@ -1,2 +1,8 @@
-obj-$(CONFIG_PM)		+= cpu.o
-obj-$(CONFIG_HIBERNATION)	+= swsusp.o suspend.o
+ifeq ($(CONFIG_X86_32),y)
+obj-$(CONFIG_PM)		+= cpu_32.o
+obj-$(CONFIG_HIBERNATION)	+= hibernation_32.o suspend.o
+else
+obj-$(CONFIG_PM)		+= cpu_64.o
+obj-$(CONFIG_HIBERNATION)	+= hibernation_64.o
+endif
+
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
deleted file mode 100644
index 998fd3e..0000000
--- a/arch/x86/power/cpu.c
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
-void __save_processor_state(struct saved_context *ctxt)
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
-	if (current->thread.debugreg[7]){
-		set_debugreg(current->thread.debugreg[0], 0);
-		set_debugreg(current->thread.debugreg[1], 1);
-		set_debugreg(current->thread.debugreg[2], 2);
-		set_debugreg(current->thread.debugreg[3], 3);
-		/* no 4 and 5 */
-		set_debugreg(current->thread.debugreg[6], 6);
-		set_debugreg(current->thread.debugreg[7], 7);
-	}
-
-}
-
-void __restore_processor_state(struct saved_context *ctxt)
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
diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
new file mode 100644
index 0000000..998fd3e
--- /dev/null
+++ b/arch/x86/power/cpu_32.c
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
+void __save_processor_state(struct saved_context *ctxt)
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
+	if (current->thread.debugreg[7]){
+		set_debugreg(current->thread.debugreg[0], 0);
+		set_debugreg(current->thread.debugreg[1], 1);
+		set_debugreg(current->thread.debugreg[2], 2);
+		set_debugreg(current->thread.debugreg[3], 3);
+		/* no 4 and 5 */
+		set_debugreg(current->thread.debugreg[6], 6);
+		set_debugreg(current->thread.debugreg[7], 7);
+	}
+
+}
+
+void __restore_processor_state(struct saved_context *ctxt)
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
diff --git a/arch/x86/power/cpu_64.c b/arch/x86/power/cpu_64.c
new file mode 100644
index 0000000..2e5efaa
--- /dev/null
+++ b/arch/x86/power/cpu_64.c
@@ -0,0 +1,294 @@
+/*
+ * Suspend support specific for i386.
+ *
+ * Distribute under GPLv2
+ *
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
+struct saved_context saved_context;
+
+void __save_processor_state(struct saved_context *ctxt)
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
+void __restore_processor_state(struct saved_context *ctxt)
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
+void fix_processor_context(void)
+{
+	int cpu = smp_processor_id();
+	struct tss_struct *t = &per_cpu(init_tss, cpu);
+
+	set_tss_desc(cpu,t);	/* This just modifies memory; should not be necessary. But... This is necessary, because 386 hardware has concept of busy TSS or some similar stupidity. */
+
+	cpu_gdt(cpu)[GDT_ENTRY_TSS].type = 9;
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
+
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
diff --git a/arch/x86/power/hibernation_32.S b/arch/x86/power/hibernation_32.S
new file mode 100644
index 0000000..53662e0
--- /dev/null
+++ b/arch/x86/power/hibernation_32.S
@@ -0,0 +1,78 @@
+.text
+
+/* Originally gcc generated, modified by hand
+ *
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
diff --git a/arch/x86/power/hibernation_64.S b/arch/x86/power/hibernation_64.S
new file mode 100644
index 0000000..72f9521
--- /dev/null
+++ b/arch/x86/power/hibernation_64.S
@@ -0,0 +1,141 @@
+/* Copyright 2004,2005 Pavel Machek <pavel@suse.cz>, Andi Kleen <ak@suse.de>, Rafael J. Wysocki <rjw@sisk.pl>
+ *
+ * Distribute under GPLv2.
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
+	movq	%rsp, pt_regs_rsp(%rax)
+	movq	%rbp, pt_regs_rbp(%rax)
+	movq	%rsi, pt_regs_rsi(%rax)
+	movq	%rdi, pt_regs_rdi(%rax)
+	movq	%rbx, pt_regs_rbx(%rax)
+	movq	%rcx, pt_regs_rcx(%rax)
+	movq	%rdx, pt_regs_rdx(%rax)
+	movq	%r8, pt_regs_r8(%rax)
+	movq	%r9, pt_regs_r9(%rax)
+	movq	%r10, pt_regs_r10(%rax)
+	movq	%r11, pt_regs_r11(%rax)
+	movq	%r12, pt_regs_r12(%rax)
+	movq	%r13, pt_regs_r13(%rax)
+	movq	%r14, pt_regs_r14(%rax)
+	movq	%r15, pt_regs_r15(%rax)
+	pushfq
+	popq	pt_regs_eflags(%rax)
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
+	movq	pt_regs_rsp(%rax), %rsp
+	movq	pt_regs_rbp(%rax), %rbp
+	movq	pt_regs_rsi(%rax), %rsi
+	movq	pt_regs_rdi(%rax), %rdi
+	movq	pt_regs_rbx(%rax), %rbx
+	movq	pt_regs_rcx(%rax), %rcx
+	movq	pt_regs_rdx(%rax), %rdx
+	movq	pt_regs_r8(%rax), %r8
+	movq	pt_regs_r9(%rax), %r9
+	movq	pt_regs_r10(%rax), %r10
+	movq	pt_regs_r11(%rax), %r11
+	movq	pt_regs_r12(%rax), %r12
+	movq	pt_regs_r13(%rax), %r13
+	movq	pt_regs_r14(%rax), %r14
+	movq	pt_regs_r15(%rax), %r15
+	pushq	pt_regs_eflags(%rax)
+	popfq
+
+	xorq	%rax, %rax
+
+	/* tell the hibernation core that we've just restored the memory */
+	movq	%rax, in_suspend(%rip)
+
+	ret
diff --git a/arch/x86/power/swsusp.S b/arch/x86/power/swsusp.S
deleted file mode 100644
index 53662e0..0000000
--- a/arch/x86/power/swsusp.S
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

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbYFUXYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbYFUXYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 19:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYFUXYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 19:24:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:23681 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYFUXY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 19:24:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=bw68s73IhaMPIoFHh9uEnghfFVU3QbUqZ01yDt0ZBD3+zyxtI0koeogF6dLdDE07MF
         VupYyP2yV88rMvv9OGPIgK9zC7AfeYEO5GT4/+YdbqnI6/whN1Or2ldHxjWidpiJqXj+
         EDBfEK8+Xmc9mVHBJ3KJXSscUZq8mfQaDhWqk=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: merge setup64.c into common_64.c
Date: Sat, 21 Jun 2008 16:25:37 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806191530.32354.yhlu.kernel@gmail.com> <200806210324.20059.yhlu.kernel@gmail.com>
In-Reply-To: <200806210324.20059.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806211625.37576.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/Makefile        |    2 
 arch/x86/kernel/cpu/common_64.c |  277 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup64.c       |  287 ----------------------------------------
 3 files changed, 277 insertions(+), 289 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup64.c
+++ /dev/null
@@ -1,287 +0,0 @@
-/* 
- * X86-64 specific CPU setup.
- * Copyright (C) 1995  Linus Torvalds
- * Copyright 2001, 2002, 2003 SuSE Labs / Andi Kleen.
- * See setup.c for older changelog.
- */ 
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/string.h>
-#include <linux/bootmem.h>
-#include <linux/bitops.h>
-#include <linux/module.h>
-#include <linux/kgdb.h>
-#include <linux/topology.h>
-#include <asm/pda.h>
-#include <asm/pgtable.h>
-#include <asm/processor.h>
-#include <asm/desc.h>
-#include <asm/atomic.h>
-#include <asm/mmu_context.h>
-#include <asm/smp.h>
-#include <asm/i387.h>
-#include <asm/percpu.h>
-#include <asm/proto.h>
-#include <asm/sections.h>
-#include <asm/setup.h>
-#include <asm/genapic.h>
-
-#ifndef CONFIG_DEBUG_BOOT_PARAMS
-struct boot_params __initdata boot_params;
-#else
-struct boot_params boot_params;
-#endif
-
-cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
-
-struct x8664_pda **_cpu_pda __read_mostly;
-EXPORT_SYMBOL(_cpu_pda);
-
-struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
-
-char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
-
-unsigned long __supported_pte_mask __read_mostly = ~0UL;
-EXPORT_SYMBOL_GPL(__supported_pte_mask);
-
-static int do_not_nx __cpuinitdata = 0;
-
-/* noexec=on|off
-Control non executable mappings for 64bit processes.
-
-on	Enable(default)
-off	Disable
-*/ 
-static int __init nonx_setup(char *str)
-{
-	if (!str)
-		return -EINVAL;
-	if (!strncmp(str, "on", 2)) {
-                __supported_pte_mask |= _PAGE_NX; 
- 		do_not_nx = 0; 
-	} else if (!strncmp(str, "off", 3)) {
-		do_not_nx = 1;
-		__supported_pte_mask &= ~_PAGE_NX;
-        }
-	return 0;
-} 
-early_param("noexec", nonx_setup);
-
-int force_personality32 = 0; 
-
-/* noexec32=on|off
-Control non executable heap for 32bit processes.
-To control the stack too use noexec=off
-
-on	PROT_READ does not imply PROT_EXEC for 32bit processes (default)
-off	PROT_READ implies PROT_EXEC
-*/
-static int __init nonx32_setup(char *str)
-{
-	if (!strcmp(str, "on"))
-		force_personality32 &= ~READ_IMPLIES_EXEC;
-	else if (!strcmp(str, "off"))
-		force_personality32 |= READ_IMPLIES_EXEC;
-	return 1;
-}
-__setup("noexec32=", nonx32_setup);
-
-void pda_init(int cpu)
-{ 
-	struct x8664_pda *pda = cpu_pda(cpu);
-
-	/* Setup up data that may be needed in __get_free_pages early */
-	asm volatile("movl %0,%%fs ; movl %0,%%gs" :: "r" (0)); 
-	/* Memory clobbers used to order PDA accessed */
-	mb();
-	wrmsrl(MSR_GS_BASE, pda);
-	mb();
-
-	pda->cpunumber = cpu; 
-	pda->irqcount = -1;
-	pda->kernelstack = 
-		(unsigned long)stack_thread_info() - PDA_STACKOFFSET + THREAD_SIZE; 
-	pda->active_mm = &init_mm;
-	pda->mmu_state = 0;
-
-	if (cpu == 0) {
-		/* others are initialized in smpboot.c */
-		pda->pcurrent = &init_task;
-		pda->irqstackptr = boot_cpu_stack; 
-	} else {
-		pda->irqstackptr = (char *)
-			__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
-		if (!pda->irqstackptr)
-			panic("cannot allocate irqstack for cpu %d", cpu); 
-
-		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
-			pda->nodenumber = cpu_to_node(cpu);
-	}
-
-	pda->irqstackptr += IRQSTACKSIZE-64;
-} 
-
-char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ]
-__attribute__((section(".bss.page_aligned")));
-
-extern asmlinkage void ignore_sysret(void);
-
-/* May not be marked __init: used by software suspend */
-void syscall_init(void)
-{
-	/* 
-	 * LSTAR and STAR live in a bit strange symbiosis.
-	 * They both write to the same internal register. STAR allows to set CS/DS
-	 * but only a 32bit target. LSTAR sets the 64bit rip. 	 
-	 */ 
-	wrmsrl(MSR_STAR,  ((u64)__USER32_CS)<<48  | ((u64)__KERNEL_CS)<<32); 
-	wrmsrl(MSR_LSTAR, system_call); 
-	wrmsrl(MSR_CSTAR, ignore_sysret);
-
-#ifdef CONFIG_IA32_EMULATION   		
-	syscall32_cpu_init ();
-#endif
-
-	/* Flags to clear on syscall */
-	wrmsrl(MSR_SYSCALL_MASK,
-	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
-}
-
-void __cpuinit check_efer(void)
-{
-	unsigned long efer;
-
-	rdmsrl(MSR_EFER, efer); 
-        if (!(efer & EFER_NX) || do_not_nx) { 
-                __supported_pte_mask &= ~_PAGE_NX; 
-        }       
-}
-
-unsigned long kernel_eflags;
-
-/*
- * Copies of the original ist values from the tss are only accessed during
- * debugging, no special alignment required.
- */
-DEFINE_PER_CPU(struct orig_ist, orig_ist);
-
-/*
- * cpu_init() initializes state that is per-CPU. Some data is already
- * initialized (naturally) in the bootstrap process, such as the GDT
- * and IDT. We reload them nevertheless, this function acts as a
- * 'CPU state barrier', nothing should get across.
- * A lot of state is already set up in PDA init.
- */
-void __cpuinit cpu_init (void)
-{
-	int cpu = stack_smp_processor_id();
-	struct tss_struct *t = &per_cpu(init_tss, cpu);
-	struct orig_ist *orig_ist = &per_cpu(orig_ist, cpu);
-	unsigned long v; 
-	char *estacks = NULL; 
-	struct task_struct *me;
-	int i;
-
-	/* CPU 0 is initialised in head64.c */
-	if (cpu != 0) {
-		pda_init(cpu);
-	} else 
-		estacks = boot_exception_stacks; 
-
-	me = current;
-
-	if (cpu_test_and_set(cpu, cpu_initialized))
-		panic("CPU#%d already initialized!\n", cpu);
-
-	printk("Initializing CPU#%d\n", cpu);
-
-	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
-
-	/*
-	 * Initialize the per-CPU GDT with the boot GDT,
-	 * and set up the GDT descriptor:
-	 */
-
-	switch_to_new_gdt();
-	load_idt((const struct desc_ptr *)&idt_descr);
-
-	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
-	syscall_init();
-
-	wrmsrl(MSR_FS_BASE, 0);
-	wrmsrl(MSR_KERNEL_GS_BASE, 0);
-	barrier(); 
-
-	check_efer();
-
-	/*
-	 * set up and load the per-CPU TSS
-	 */
-	for (v = 0; v < N_EXCEPTION_STACKS; v++) {
-		static const unsigned int order[N_EXCEPTION_STACKS] = {
-			[0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
-			[DEBUG_STACK - 1] = DEBUG_STACK_ORDER
-		};
-		if (cpu) {
-			estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
-			if (!estacks)
-				panic("Cannot allocate exception stack %ld %d\n",
-				      v, cpu); 
-		}
-		estacks += PAGE_SIZE << order[v];
-		orig_ist->ist[v] = t->x86_tss.ist[v] = (unsigned long)estacks;
-	}
-
-	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
-	/*
-	 * <= is required because the CPU will access up to
-	 * 8 bits beyond the end of the IO permission bitmap.
-	 */
-	for (i = 0; i <= IO_BITMAP_LONGS; i++)
-		t->io_bitmap[i] = ~0UL;
-
-	atomic_inc(&init_mm.mm_count);
-	me->active_mm = &init_mm;
-	if (me->mm)
-		BUG();
-	enter_lazy_tlb(&init_mm, me);
-
-	load_sp0(t, &current->thread);
-	set_tss_desc(cpu, t);
-	load_TR_desc();
-	load_LDT(&init_mm.context);
-
-#ifdef CONFIG_KGDB
-	/*
-	 * If the kgdb is connected no debug regs should be altered.  This
-	 * is only applicable when KGDB and a KGDB I/O module are built
-	 * into the kernel and you are using early debugging with
-	 * kgdbwait. KGDB will control the kernel HW breakpoint registers.
-	 */
-	if (kgdb_connected && arch_kgdb_ops.correct_hw_break)
-		arch_kgdb_ops.correct_hw_break();
-	else {
-#endif
-	/*
-	 * Clear all 6 debug registers:
-	 */
-
-	set_debugreg(0UL, 0);
-	set_debugreg(0UL, 1);
-	set_debugreg(0UL, 2);
-	set_debugreg(0UL, 3);
-	set_debugreg(0UL, 6);
-	set_debugreg(0UL, 7);
-#ifdef CONFIG_KGDB
-	/* If the kgdb is connected no debug regs should be altered. */
-	}
-#endif
-
-	fpu_init(); 
-
-	raw_local_save_flags(kernel_eflags);
-
-	if (is_uv_system())
-		uv_cpu_init();
-}
Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -30,7 +30,7 @@ obj-y			+= setup_$(BITS).o i8259.o irqin
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
-obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o setup64.o
+obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
Index: linux-2.6/arch/x86/kernel/cpu/common_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common_64.c
+++ linux-2.6/arch/x86/kernel/cpu/common_64.c
@@ -1,10 +1,17 @@
 #include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/string.h>
+#include <linux/bootmem.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/kgdb.h>
+#include <linux/topology.h>
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/smp.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
-#include <linux/bootmem.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/msr.h>
@@ -19,6 +26,15 @@
 #include <asm/apic.h>
 #include <mach_apic.h>
 #endif
+#include <asm/pda.h>
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+#include <asm/desc.h>
+#include <asm/atomic.h>
+#include <asm/proto.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+#include <asm/genapic.h>
 
 #include "cpu.h"
 
@@ -404,3 +420,262 @@ static __init int setup_disablecpuid(cha
 	return 1;
 }
 __setup("clearcpuid=", setup_disablecpuid);
+
+#ifndef CONFIG_DEBUG_BOOT_PARAMS
+struct boot_params __initdata boot_params;
+#else
+struct boot_params boot_params;
+#endif
+
+cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
+
+struct x8664_pda **_cpu_pda __read_mostly;
+EXPORT_SYMBOL(_cpu_pda);
+
+struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
+
+char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
+
+unsigned long __supported_pte_mask __read_mostly = ~0UL;
+EXPORT_SYMBOL_GPL(__supported_pte_mask);
+
+static int do_not_nx __cpuinitdata;
+
+/* noexec=on|off
+Control non executable mappings for 64bit processes.
+
+on	Enable(default)
+off	Disable
+*/
+static int __init nonx_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+	if (!strncmp(str, "on", 2)) {
+		__supported_pte_mask |= _PAGE_NX;
+		do_not_nx = 0;
+	} else if (!strncmp(str, "off", 3)) {
+		do_not_nx = 1;
+		__supported_pte_mask &= ~_PAGE_NX;
+	}
+	return 0;
+}
+early_param("noexec", nonx_setup);
+
+int force_personality32;
+
+/* noexec32=on|off
+Control non executable heap for 32bit processes.
+To control the stack too use noexec=off
+
+on	PROT_READ does not imply PROT_EXEC for 32bit processes (default)
+off	PROT_READ implies PROT_EXEC
+*/
+static int __init nonx32_setup(char *str)
+{
+	if (!strcmp(str, "on"))
+		force_personality32 &= ~READ_IMPLIES_EXEC;
+	else if (!strcmp(str, "off"))
+		force_personality32 |= READ_IMPLIES_EXEC;
+	return 1;
+}
+__setup("noexec32=", nonx32_setup);
+
+void pda_init(int cpu)
+{
+	struct x8664_pda *pda = cpu_pda(cpu);
+
+	/* Setup up data that may be needed in __get_free_pages early */
+	asm volatile("movl %0,%%fs ; movl %0,%%gs" :: "r" (0));
+	/* Memory clobbers used to order PDA accessed */
+	mb();
+	wrmsrl(MSR_GS_BASE, pda);
+	mb();
+
+	pda->cpunumber = cpu;
+	pda->irqcount = -1;
+	pda->kernelstack = (unsigned long)stack_thread_info() -
+				 PDA_STACKOFFSET + THREAD_SIZE;
+	pda->active_mm = &init_mm;
+	pda->mmu_state = 0;
+
+	if (cpu == 0) {
+		/* others are initialized in smpboot.c */
+		pda->pcurrent = &init_task;
+		pda->irqstackptr = boot_cpu_stack;
+	} else {
+		pda->irqstackptr = (char *)
+			__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
+		if (!pda->irqstackptr)
+			panic("cannot allocate irqstack for cpu %d", cpu);
+
+		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
+			pda->nodenumber = cpu_to_node(cpu);
+	}
+
+	pda->irqstackptr += IRQSTACKSIZE-64;
+}
+
+char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
+			   DEBUG_STKSZ]
+__attribute__((section(".bss.page_aligned")));
+
+extern asmlinkage void ignore_sysret(void);
+
+/* May not be marked __init: used by software suspend */
+void syscall_init(void)
+{
+	/*
+	 * LSTAR and STAR live in a bit strange symbiosis.
+	 * They both write to the same internal register. STAR allows to
+	 * set CS/DS but only a 32bit target. LSTAR sets the 64bit rip.
+	 */
+	wrmsrl(MSR_STAR,  ((u64)__USER32_CS)<<48  | ((u64)__KERNEL_CS)<<32);
+	wrmsrl(MSR_LSTAR, system_call);
+	wrmsrl(MSR_CSTAR, ignore_sysret);
+
+#ifdef CONFIG_IA32_EMULATION
+	syscall32_cpu_init();
+#endif
+
+	/* Flags to clear on syscall */
+	wrmsrl(MSR_SYSCALL_MASK,
+	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
+}
+
+void __cpuinit check_efer(void)
+{
+	unsigned long efer;
+
+	rdmsrl(MSR_EFER, efer);
+	if (!(efer & EFER_NX) || do_not_nx)
+		__supported_pte_mask &= ~_PAGE_NX;
+}
+
+unsigned long kernel_eflags;
+
+/*
+ * Copies of the original ist values from the tss are only accessed during
+ * debugging, no special alignment required.
+ */
+DEFINE_PER_CPU(struct orig_ist, orig_ist);
+
+/*
+ * cpu_init() initializes state that is per-CPU. Some data is already
+ * initialized (naturally) in the bootstrap process, such as the GDT
+ * and IDT. We reload them nevertheless, this function acts as a
+ * 'CPU state barrier', nothing should get across.
+ * A lot of state is already set up in PDA init.
+ */
+void __cpuinit cpu_init(void)
+{
+	int cpu = stack_smp_processor_id();
+	struct tss_struct *t = &per_cpu(init_tss, cpu);
+	struct orig_ist *orig_ist = &per_cpu(orig_ist, cpu);
+	unsigned long v;
+	char *estacks = NULL;
+	struct task_struct *me;
+	int i;
+
+	/* CPU 0 is initialised in head64.c */
+	if (cpu != 0)
+		pda_init(cpu);
+	else
+		estacks = boot_exception_stacks;
+
+	me = current;
+
+	if (cpu_test_and_set(cpu, cpu_initialized))
+		panic("CPU#%d already initialized!\n", cpu);
+
+	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
+
+	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
+
+	/*
+	 * Initialize the per-CPU GDT with the boot GDT,
+	 * and set up the GDT descriptor:
+	 */
+
+	switch_to_new_gdt();
+	load_idt((const struct desc_ptr *)&idt_descr);
+
+	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
+	syscall_init();
+
+	wrmsrl(MSR_FS_BASE, 0);
+	wrmsrl(MSR_KERNEL_GS_BASE, 0);
+	barrier();
+
+	check_efer();
+
+	/*
+	 * set up and load the per-CPU TSS
+	 */
+	for (v = 0; v < N_EXCEPTION_STACKS; v++) {
+		static const unsigned int order[N_EXCEPTION_STACKS] = {
+			[0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
+			[DEBUG_STACK - 1] = DEBUG_STACK_ORDER
+		};
+		if (cpu) {
+			estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
+			if (!estacks)
+				panic("Cannot allocate exception stack %ld %d\n",
+				      v, cpu);
+		}
+		estacks += PAGE_SIZE << order[v];
+		orig_ist->ist[v] = t->x86_tss.ist[v] = (unsigned long)estacks;
+	}
+
+	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
+	/*
+	 * <= is required because the CPU will access up to
+	 * 8 bits beyond the end of the IO permission bitmap.
+	 */
+	for (i = 0; i <= IO_BITMAP_LONGS; i++)
+		t->io_bitmap[i] = ~0UL;
+
+	atomic_inc(&init_mm.mm_count);
+	me->active_mm = &init_mm;
+	if (me->mm)
+		BUG();
+	enter_lazy_tlb(&init_mm, me);
+
+	load_sp0(t, &current->thread);
+	set_tss_desc(cpu, t);
+	load_TR_desc();
+	load_LDT(&init_mm.context);
+
+#ifdef CONFIG_KGDB
+	/*
+	 * If the kgdb is connected no debug regs should be altered.  This
+	 * is only applicable when KGDB and a KGDB I/O module are built
+	 * into the kernel and you are using early debugging with
+	 * kgdbwait. KGDB will control the kernel HW breakpoint registers.
+	 */
+	if (kgdb_connected && arch_kgdb_ops.correct_hw_break)
+		arch_kgdb_ops.correct_hw_break();
+	else {
+#endif
+	/*
+	 * Clear all 6 debug registers:
+	 */
+
+	set_debugreg(0UL, 0);
+	set_debugreg(0UL, 1);
+	set_debugreg(0UL, 2);
+	set_debugreg(0UL, 3);
+	set_debugreg(0UL, 6);
+	set_debugreg(0UL, 7);
+#ifdef CONFIG_KGDB
+	/* If the kgdb is connected no debug regs should be altered. */
+	}
+#endif
+
+	fpu_init();
+
+	raw_local_save_flags(kernel_eflags);
+
+	if (is_uv_system())
+		uv_cpu_init();
+}

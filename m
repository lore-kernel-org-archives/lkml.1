Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbYIEDLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbYIEDLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYIEDJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:52408 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYIEDJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H0PBcNPRuj86w/FA0lCzyiSY0p9rUM8cg3keJEEJOQMxaHa62Jo8b+vuhDQYSy6nS4
         ICwYooUNd8nKBDfpzND00HkHVHrP1cq7KgNrD6O0cfo441oqCzd6XVMJ8zmJDv76w2ui
         qE4YRjZUOsSld4Yczy7nCTyTrdKeAw7i5DKgM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 06/16] x86: cpu commont have same cpu_init with copying and macro
Date: Thu,  4 Sep 2008 20:09:04 -0700
Message-Id: <1220584154-32497-6-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hard to merge by lines... will try do it later

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |  124 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/common_64.c |   88 +++++++++++++++++++++++++++-
 2 files changed, 211 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index dcd3ebd..f44678d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -901,7 +901,129 @@ struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
  * initialized (naturally) in the bootstrap process, such as the GDT
  * and IDT. We reload them nevertheless, this function acts as a
  * 'CPU state barrier', nothing should get across.
+ * A lot of state is already set up in PDA init for 64 bit
  */
+#ifdef CONFIG_X86_64
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
+	if (cpu != 0 && x2apic)
+		enable_x2apic();
+
+	/*
+	 * set up and load the per-CPU TSS
+	 */
+	if (!orig_ist->ist[0]) {
+		static const unsigned int order[N_EXCEPTION_STACKS] = {
+		  [0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
+		  [DEBUG_STACK - 1] = DEBUG_STACK_ORDER
+		};
+		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
+			if (cpu) {
+				estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
+				if (!estacks)
+					panic("Cannot allocate exception "
+					      "stack %ld %d\n", v, cpu);
+			}
+			estacks += PAGE_SIZE << order[v];
+			orig_ist->ist[v] = t->x86_tss.ist[v] =
+					(unsigned long)estacks;
+		}
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
+
+#else
+
 void __cpuinit cpu_init(void)
 {
 	int cpu = smp_processor_id();
@@ -982,3 +1104,5 @@ void __cpuinit cpu_uninit(void)
 	per_cpu(cpu_tlbstate, cpu).active_mm = &init_mm;
 }
 #endif
+
+#endif
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 9f2a6ec..2bd0ed5 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -855,8 +855,9 @@ struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
  * initialized (naturally) in the bootstrap process, such as the GDT
  * and IDT. We reload them nevertheless, this function acts as a
  * 'CPU state barrier', nothing should get across.
- * A lot of state is already set up in PDA init.
+ * A lot of state is already set up in PDA init for 64 bit
  */
+#ifdef CONFIG_X86_64
 void __cpuinit cpu_init(void)
 {
 	int cpu = stack_smp_processor_id();
@@ -974,3 +975,88 @@ void __cpuinit cpu_init(void)
 	if (is_uv_system())
 		uv_cpu_init();
 }
+
+#else
+
+void __cpuinit cpu_init(void)
+{
+	int cpu = smp_processor_id();
+	struct task_struct *curr = current;
+	struct tss_struct *t = &per_cpu(init_tss, cpu);
+	struct thread_struct *thread = &curr->thread;
+
+	if (cpu_test_and_set(cpu, cpu_initialized)) {
+		printk(KERN_WARNING "CPU#%d already initialized!\n", cpu);
+		for (;;) local_irq_enable();
+	}
+
+	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
+
+	if (cpu_has_vme || cpu_has_tsc || cpu_has_de)
+		clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
+
+	load_idt(&idt_descr);
+	switch_to_new_gdt();
+
+	/*
+	 * Set up and load the per-CPU TSS and LDT
+	 */
+	atomic_inc(&init_mm.mm_count);
+	curr->active_mm = &init_mm;
+	if (curr->mm)
+		BUG();
+	enter_lazy_tlb(&init_mm, curr);
+
+	load_sp0(t, thread);
+	set_tss_desc(cpu, t);
+	load_TR_desc();
+	load_LDT(&init_mm.context);
+
+#ifdef CONFIG_DOUBLEFAULT
+	/* Set up doublefault TSS pointer in the GDT */
+	__set_tss_desc(cpu, GDT_ENTRY_DOUBLEFAULT_TSS, &doublefault_tss);
+#endif
+
+	/* Clear %gs. */
+	asm volatile ("mov %0, %%gs" : : "r" (0));
+
+	/* Clear all 6 debug registers: */
+	set_debugreg(0, 0);
+	set_debugreg(0, 1);
+	set_debugreg(0, 2);
+	set_debugreg(0, 3);
+	set_debugreg(0, 6);
+	set_debugreg(0, 7);
+
+	/*
+	 * Force FPU initialization:
+	 */
+	if (cpu_has_xsave)
+		current_thread_info()->status = TS_XSAVE;
+	else
+		current_thread_info()->status = 0;
+	clear_used_math();
+	mxcsr_feature_mask_init();
+
+	/*
+	 * Boot processor to setup the FP and extended state context info.
+	 */
+	if (!smp_processor_id())
+		init_thread_xstate();
+
+	xsave_init();
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+void __cpuinit cpu_uninit(void)
+{
+	int cpu = raw_smp_processor_id();
+	cpu_clear(cpu, cpu_initialized);
+
+	/* lazy TLB state */
+	per_cpu(cpu_tlbstate, cpu).state = 0;
+	per_cpu(cpu_tlbstate, cpu).active_mm = &init_mm;
+}
+#endif
+
+#endif
-- 
1.5.4.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbYIEDKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbYIEDKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYIEDJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:58345 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbYIEDJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nLikkPI2sCL8DdVpGmBVLtJxvyHMF5QhkxzTFJK4IQ/yP0YwN9V7ZxpxiXp3oVy13t
         /2EYZtJ2z3PX01m3khX8gOt7Mc9YECz9Age4XBIvjYxKOwtZs/sFerKBtPB/SXDtpoPY
         IjRtDmSYBXfJq8ixL0eHghp4Z0VVQhH/GWhm0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 05/16] x86: cpu common make 32bit have 64bit only funcs
Date: Thu,  4 Sep 2008 20:09:03 -0700
Message-Id: <1220584154-32497-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |  138 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/common_64.c |   12 ++++
 2 files changed, 150 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9128ba0..dcd3ebd 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -750,6 +750,143 @@ __setup("clearcpuid=", setup_disablecpuid);
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
+#ifdef CONFIG_X86_64
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
+	loadsegment(fs, 0);
+	loadsegment(gs, 0);
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
+		pda->irqstackptr += IRQSTACKSIZE - 64;
+	} else {
+		if (!pda->irqstackptr) {
+			pda->irqstackptr = (char *)
+				__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
+			if (!pda->irqstackptr)
+				panic("cannot allocate irqstack for cpu %d",
+				      cpu);
+			pda->irqstackptr += IRQSTACKSIZE - 64;
+		}
+
+		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
+			pda->nodenumber = cpu_to_node(cpu);
+	}
+}
+
+char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
+			   DEBUG_STKSZ] __page_aligned_bss;
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
+#else
+
 /* Make sure %fs is initialized properly in idle threads */
 struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 {
@@ -757,6 +894,7 @@ struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 	regs->fs = __KERNEL_PERCPU;
 	return regs;
 }
+#endif
 
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 40c9d89..9f2a6ec 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -704,6 +704,7 @@ __setup("clearcpuid=", setup_disablecpuid);
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
+#ifdef CONFIG_X86_64
 struct x8664_pda **_cpu_pda __read_mostly;
 EXPORT_SYMBOL(_cpu_pda);
 
@@ -838,6 +839,17 @@ unsigned long kernel_eflags;
  */
 DEFINE_PER_CPU(struct orig_ist, orig_ist);
 
+#else
+
+/* Make sure %fs is initialized properly in idle threads */
+struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
+{
+	memset(regs, 0, sizeof(struct pt_regs));
+	regs->fs = __KERNEL_PERCPU;
+	return regs;
+}
+#endif
+
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
-- 
1.5.4.5


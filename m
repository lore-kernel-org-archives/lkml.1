Return-Path: <linux-kernel-owner+w=401wt.eu-S934591AbZARQoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591AbZARQoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933790AbZARQjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:39:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:37549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933118AbZARQjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:39:46 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/12] x86-64: Move kernelstack from PDA to per-cpu.
Date: Mon, 19 Jan 2009 01:39:14 +0900
Message-Id: <1232296759-2253-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232296759-2253-1-git-send-email-tj@kernel.org>
References: <1232296759-2253-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 16:39:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

Also clean up PER_CPU_VAR usage in xen-asm_64.S

tj: * remove now unused stack_thread_info()
    * s/kernelstack/kernel_stack/
    * added FIXME comment in xen-asm_64.S

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/ia32/ia32entry.S          |    8 ++++----
 arch/x86/include/asm/pda.h         |    4 +---
 arch/x86/include/asm/thread_info.h |   20 ++++++++------------
 arch/x86/kernel/asm-offsets_64.c   |    1 -
 arch/x86/kernel/cpu/common.c       |    6 ++++--
 arch/x86/kernel/entry_64.S         |    4 ++--
 arch/x86/kernel/process_64.c       |    4 ++--
 arch/x86/kernel/smpboot.c          |    3 +++
 arch/x86/xen/xen-asm_64.S          |   23 +++++++++++------------
 9 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 256b00b..9c79b24 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -112,8 +112,8 @@ ENTRY(ia32_sysenter_target)
 	CFI_DEF_CFA	rsp,0
 	CFI_REGISTER	rsp,rbp
 	SWAPGS_UNSAFE_STACK
-	movq	%gs:pda_kernelstack, %rsp
-	addq	$(PDA_STACKOFFSET),%rsp	
+	movq	PER_CPU_VAR(kernel_stack), %rsp
+	addq	$(KERNEL_STACK_OFFSET),%rsp
 	/*
 	 * No need to follow this irqs on/off section: the syscall
 	 * disabled irqs, here we enable it straight after entry:
@@ -273,13 +273,13 @@ ENDPROC(ia32_sysenter_target)
 ENTRY(ia32_cstar_target)
 	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA	rsp,PDA_STACKOFFSET
+	CFI_DEF_CFA	rsp,KERNEL_STACK_OFFSET
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
 	SWAPGS_UNSAFE_STACK
 	movl	%esp,%r8d
 	CFI_REGISTER	rsp,r8
-	movq	%gs:pda_kernelstack,%rsp
+	movq	PER_CPU_VAR(kernel_stack),%rsp
 	/*
 	 * No need to follow this irqs on/off section: the syscall
 	 * disabled irqs and here we enable it straight after entry:
diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 7209302..4d28ffb 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -13,7 +13,7 @@
 struct x8664_pda {
 	unsigned long unused1;
 	unsigned long unused2;
-	unsigned long kernelstack;	/* 16 top of kernel stack for current */
+	unsigned long unused3;
 	unsigned long oldrsp;		/* 24 user rsp for system call */
 	int irqcount;			/* 32 Irq nesting counter. Starts -1 */
 	unsigned int unused6;		/* 36 was cpunumber */
@@ -44,6 +44,4 @@ extern void pda_init(int);
 
 #endif
 
-#define PDA_STACKOFFSET (5*8)
-
 #endif /* _ASM_X86_PDA_H */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 9878964..b46f8ca 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -194,25 +194,21 @@ static inline struct thread_info *current_thread_info(void)
 
 #else /* X86_32 */
 
-#include <asm/pda.h>
+#include <asm/percpu.h>
+#define KERNEL_STACK_OFFSET (5*8)
 
 /*
  * macros/functions for gaining access to the thread information structure
  * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #ifndef __ASSEMBLY__
-static inline struct thread_info *current_thread_info(void)
-{
-	struct thread_info *ti;
-	ti = (void *)(read_pda(kernelstack) + PDA_STACKOFFSET - THREAD_SIZE);
-	return ti;
-}
+DECLARE_PER_CPU(unsigned long, kernel_stack);
 
-/* do not use in interrupt context */
-static inline struct thread_info *stack_thread_info(void)
+static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	asm("andq %%rsp,%0; " : "=r" (ti) : "0" (~(THREAD_SIZE - 1)));
+	ti = (void *)(percpu_read(kernel_stack) +
+		      KERNEL_STACK_OFFSET - THREAD_SIZE);
 	return ti;
 }
 
@@ -220,8 +216,8 @@ static inline struct thread_info *stack_thread_info(void)
 
 /* how to get the thread information struct from ASM */
 #define GET_THREAD_INFO(reg) \
-	movq %gs:pda_kernelstack,reg ; \
-	subq $(THREAD_SIZE-PDA_STACKOFFSET),reg
+	movq PER_CPU_VAR(kernel_stack),reg ; \
+	subq $(THREAD_SIZE-KERNEL_STACK_OFFSET),reg
 
 #endif
 
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 4f7a210..cafff5f 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -49,7 +49,6 @@ int main(void)
 	BLANK();
 #undef ENTRY
 #define ENTRY(entry) DEFINE(pda_ ## entry, offsetof(struct x8664_pda, entry))
-	ENTRY(kernelstack); 
 	ENTRY(oldrsp); 
 	ENTRY(irqcount);
 	DEFINE(pda_size, sizeof(struct x8664_pda));
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b50e38d..06b6290 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -889,6 +889,10 @@ DEFINE_PER_CPU(char *, irq_stack_ptr) =
 	per_cpu_var(irq_stack) + IRQ_STACK_SIZE - 64;
 #endif
 
+DEFINE_PER_CPU(unsigned long, kernel_stack) =
+	(unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
+EXPORT_PER_CPU_SYMBOL(kernel_stack);
+
 void __cpuinit pda_init(int cpu)
 {
 	struct x8664_pda *pda = cpu_pda(cpu);
@@ -900,8 +904,6 @@ void __cpuinit pda_init(int cpu)
 	load_pda_offset(cpu);
 
 	pda->irqcount = -1;
-	pda->kernelstack = (unsigned long)stack_thread_info() -
-				 PDA_STACKOFFSET + THREAD_SIZE;
 
 	if (cpu != 0) {
 		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index d22677a..0dd4585 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -468,7 +468,7 @@ END(ret_from_fork)
 ENTRY(system_call)
 	CFI_STARTPROC	simple
 	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA	rsp,PDA_STACKOFFSET
+	CFI_DEF_CFA	rsp,KERNEL_STACK_OFFSET
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
 	SWAPGS_UNSAFE_STACK
@@ -480,7 +480,7 @@ ENTRY(system_call)
 ENTRY(system_call_after_swapgs)
 
 	movq	%rsp,%gs:pda_oldrsp
-	movq	%gs:pda_kernelstack,%rsp
+	movq	PER_CPU_VAR(kernel_stack),%rsp
 	/*
 	 * No need to follow this irqs off/on section - it's straight
 	 * and short:
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index e00c31a..6c5f576 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -620,9 +620,9 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	write_pda(oldrsp, next->usersp);
 	percpu_write(current_task, next_p);
 
-	write_pda(kernelstack,
+	percpu_write(kernel_stack,
 		  (unsigned long)task_stack_page(next_p) +
-		  THREAD_SIZE - PDA_STACKOFFSET);
+		  THREAD_SIZE - KERNEL_STACK_OFFSET);
 #ifdef CONFIG_CC_STACKPROTECTOR
 	write_pda(stack_canary, next_p->stack_canary);
 	/*
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5854be0..869b988 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -798,6 +798,9 @@ do_rest:
 #else
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 	initial_gs = per_cpu_offset(cpu);
+	per_cpu(kernel_stack, cpu) =
+		(unsigned long)task_stack_page(c_idle.idle) -
+		KERNEL_STACK_OFFSET + THREAD_SIZE;
 #endif
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
index 05794c5..5a23e89 100644
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -17,6 +17,7 @@
 #include <asm/processor-flags.h>
 #include <asm/errno.h>
 #include <asm/segment.h>
+#include <asm/percpu.h>
 
 #include <xen/interface/xen.h>
 
@@ -28,12 +29,10 @@
 
 #if 1
 /*
-	x86-64 does not yet support direct access to percpu variables
-	via a segment override, so we just need to make sure this code
-	never gets used
+	FIXME: x86_64 now can support direct access to percpu variables
+	via a segment override.  Update xen accordingly.
  */
 #define BUG			ud2a
-#define PER_CPU_VAR(var, off)	0xdeadbeef
 #endif
 
 /*
@@ -45,14 +44,14 @@ ENTRY(xen_irq_enable_direct)
 	BUG
 
 	/* Unmask events */
-	movb $0, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
+	movb $0, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 
 	/* Preempt here doesn't matter because that will deal with
 	   any pending interrupts.  The pending check may end up being
 	   run on the wrong CPU, but that doesn't hurt. */
 
 	/* Test for pending */
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_pending)
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
 	jz 1f
 
 2:	call check_events
@@ -69,7 +68,7 @@ ENDPATCH(xen_irq_enable_direct)
 ENTRY(xen_irq_disable_direct)
 	BUG
 
-	movb $1, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
+	movb $1, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 ENDPATCH(xen_irq_disable_direct)
 	ret
 	ENDPROC(xen_irq_disable_direct)
@@ -87,7 +86,7 @@ ENDPATCH(xen_irq_disable_direct)
 ENTRY(xen_save_fl_direct)
 	BUG
 
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 	setz %ah
 	addb %ah,%ah
 ENDPATCH(xen_save_fl_direct)
@@ -107,13 +106,13 @@ ENTRY(xen_restore_fl_direct)
 	BUG
 
 	testb $X86_EFLAGS_IF>>8, %ah
-	setz PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
+	setz PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 	/* Preempt here doesn't matter because that will deal with
 	   any pending interrupts.  The pending check may end up being
 	   run on the wrong CPU, but that doesn't hurt. */
 
 	/* check for unmasked and pending */
-	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_pending)
+	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
 	jz 1f
 2:	call check_events
 1:
@@ -196,7 +195,7 @@ ENTRY(xen_sysret64)
 	/* We're already on the usermode stack at this point, but still
 	   with the kernel gs, so we can easily switch back */
 	movq %rsp, %gs:pda_oldrsp
-	movq %gs:pda_kernelstack,%rsp
+	movq PER_CPU_VAR(kernel_stack),%rsp
 
 	pushq $__USER_DS
 	pushq %gs:pda_oldrsp
@@ -213,7 +212,7 @@ ENTRY(xen_sysret32)
 	/* We're already on the usermode stack at this point, but still
 	   with the kernel gs, so we can easily switch back */
 	movq %rsp, %gs:pda_oldrsp
-	movq %gs:pda_kernelstack, %rsp
+	movq PER_CPU_VAR(kernel_stack), %rsp
 
 	pushq $__USER32_DS
 	pushq %gs:pda_oldrsp
-- 
1.6.0.2


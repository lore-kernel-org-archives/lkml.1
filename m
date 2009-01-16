Return-Path: <linux-kernel-owner+w=401wt.eu-S935443AbZAPOSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935443AbZAPOSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:18:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934105AbZAPOQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:16:49 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:51829 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933803AbZAPOQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:16:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rSDzD11sqTZZIpVaB0B+EQQVmCXBibMf1XSomocx/oDTHtUguqXYaK27a1QG7IqJ5H
         d13NlfJecNoF2Stmf8nkj6nTZz6haHdmG/L0AvKxmLsLdhPNwyqBfLvUnRPuB1Th9yuT
         HL7lDjF1JrEKnpLt55k7Kxe4y/778mG2zKCWA=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 07/17] x86-64: Move kernelstack from PDA to per-cpu.
Date: Fri, 16 Jan 2009 09:16:26 -0500
Message-Id: <1232115396-26367-7-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232115396-26367-6-git-send-email-brgerst@gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
 <1232115396-26367-4-git-send-email-brgerst@gmail.com>
 <1232115396-26367-5-git-send-email-brgerst@gmail.com>
 <1232115396-26367-6-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also clean up PER_CPU_VAR usage in xen-asm_64.S

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/ia32/ia32entry.S          |    8 ++++----
 arch/x86/include/asm/pda.h         |    4 +---
 arch/x86/include/asm/thread_info.h |   11 +++++++----
 arch/x86/kernel/asm-offsets_64.c   |    1 -
 arch/x86/kernel/cpu/common.c       |    6 ++++--
 arch/x86/kernel/entry_64.S         |    4 ++--
 arch/x86/kernel/process_64.c       |    4 ++--
 arch/x86/kernel/smpboot.c          |    2 ++
 arch/x86/xen/xen-asm_64.S          |   18 +++++++++---------
 9 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 256b00b..16e1524 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -112,8 +112,8 @@ ENTRY(ia32_sysenter_target)
 	CFI_DEF_CFA	rsp,0
 	CFI_REGISTER	rsp,rbp
 	SWAPGS_UNSAFE_STACK
-	movq	%gs:pda_kernelstack, %rsp
-	addq	$(PDA_STACKOFFSET),%rsp	
+	movq	PER_CPU_VAR(kernelstack), %rsp
+	addq	$(KERNELSTACK_OFFSET),%rsp	
 	/*
 	 * No need to follow this irqs on/off section: the syscall
 	 * disabled irqs, here we enable it straight after entry:
@@ -273,13 +273,13 @@ ENDPROC(ia32_sysenter_target)
 ENTRY(ia32_cstar_target)
 	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA	rsp,PDA_STACKOFFSET
+	CFI_DEF_CFA	rsp,KERNELSTACK_OFFSET
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
 	SWAPGS_UNSAFE_STACK
 	movl	%esp,%r8d
 	CFI_REGISTER	rsp,r8
-	movq	%gs:pda_kernelstack,%rsp
+	movq	PER_CPU_VAR(kernelstack),%rsp
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
index 9878964..8f33a3d 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -194,17 +194,20 @@ static inline struct thread_info *current_thread_info(void)
 
 #else /* X86_32 */
 
-#include <asm/pda.h>
+#include <asm/percpu.h>
+#define KERNELSTACK_OFFSET (5*8)
 
 /*
  * macros/functions for gaining access to the thread information structure
  * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #ifndef __ASSEMBLY__
+DECLARE_PER_CPU(unsigned long, kernelstack);
+
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	ti = (void *)(read_pda(kernelstack) + PDA_STACKOFFSET - THREAD_SIZE);
+	ti = (void *)(percpu_read(kernelstack) + KERNELSTACK_OFFSET - THREAD_SIZE);
 	return ti;
 }
 
@@ -220,8 +223,8 @@ static inline struct thread_info *stack_thread_info(void)
 
 /* how to get the thread information struct from ASM */
 #define GET_THREAD_INFO(reg) \
-	movq %gs:pda_kernelstack,reg ; \
-	subq $(THREAD_SIZE-PDA_STACKOFFSET),reg
+	movq PER_CPU_VAR(kernelstack),reg ; \
+	subq $(THREAD_SIZE-KERNELSTACK_OFFSET),reg
 
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
index fbc8468..f653860 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -884,6 +884,10 @@ struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 DEFINE_PER_CPU_PAGE_ALIGNED(char, irqstack[IRQSTACKSIZE]) __aligned(PAGE_SIZE);
 DEFINE_PER_CPU(char *, irqstackptr) = per_cpu_var(irqstack) + IRQSTACKSIZE - 64;
 
+DEFINE_PER_CPU(unsigned long, kernelstack) = (unsigned long)&init_thread_union -
+					      KERNELSTACK_OFFSET + THREAD_SIZE;
+EXPORT_PER_CPU_SYMBOL(kernelstack);
+
 void __cpuinit pda_init(int cpu)
 {
 	struct x8664_pda *pda = cpu_pda(cpu);
@@ -895,8 +899,6 @@ void __cpuinit pda_init(int cpu)
 	load_pda_offset(cpu);
 
 	pda->irqcount = -1;
-	pda->kernelstack = (unsigned long)stack_thread_info() -
-				 PDA_STACKOFFSET + THREAD_SIZE;
 
 	if (cpu != 0) {
 		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 5cd892f..8f35796 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -468,7 +468,7 @@ END(ret_from_fork)
 ENTRY(system_call)
 	CFI_STARTPROC	simple
 	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA	rsp,PDA_STACKOFFSET
+	CFI_DEF_CFA	rsp,KERNELSTACK_OFFSET
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
 	SWAPGS_UNSAFE_STACK
@@ -480,7 +480,7 @@ ENTRY(system_call)
 ENTRY(system_call_after_swapgs)
 
 	movq	%rsp,%gs:pda_oldrsp
-	movq	%gs:pda_kernelstack,%rsp
+	movq	PER_CPU_VAR(kernelstack),%rsp
 	/*
 	 * No need to follow this irqs off/on section - it's straight
 	 * and short:
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index e00c31a..2f5bb4d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -620,9 +620,9 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	write_pda(oldrsp, next->usersp);
 	percpu_write(current_task, next_p);
 
-	write_pda(kernelstack,
+	percpu_write(kernelstack,
 		  (unsigned long)task_stack_page(next_p) +
-		  THREAD_SIZE - PDA_STACKOFFSET);
+		  THREAD_SIZE - KERNELSTACK_OFFSET);
 #ifdef CONFIG_CC_STACKPROTECTOR
 	write_pda(stack_canary, next_p->stack_canary);
 	/*
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ecc2fc5..8bf1a43 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -800,6 +800,8 @@ do_rest:
 #else
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 	initial_gs = per_cpu_offset(cpu);
+	per_cpu(kernelstack, cpu) = (unsigned long)task_stack_page(c_idle.idle) -
+				    KERNELSTACK_OFFSET + THREAD_SIZE;
 #endif
 	is_boot_cpu = 0;
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
index 05794c5..eac2794 100644
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -17,6 +17,7 @@
 #include <asm/processor-flags.h>
 #include <asm/errno.h>
 #include <asm/segment.h>
+#include <asm/percpu.h>
 
 #include <xen/interface/xen.h>
 
@@ -33,7 +34,6 @@
 	never gets used
  */
 #define BUG			ud2a
-#define PER_CPU_VAR(var, off)	0xdeadbeef
 #endif
 
 /*
@@ -45,14 +45,14 @@ ENTRY(xen_irq_enable_direct)
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
@@ -69,7 +69,7 @@ ENDPATCH(xen_irq_enable_direct)
 ENTRY(xen_irq_disable_direct)
 	BUG
 
-	movb $1, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
+	movb $1, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 ENDPATCH(xen_irq_disable_direct)
 	ret
 	ENDPROC(xen_irq_disable_direct)
@@ -87,7 +87,7 @@ ENDPATCH(xen_irq_disable_direct)
 ENTRY(xen_save_fl_direct)
 	BUG
 
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 	setz %ah
 	addb %ah,%ah
 ENDPATCH(xen_save_fl_direct)
@@ -107,13 +107,13 @@ ENTRY(xen_restore_fl_direct)
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
@@ -196,7 +196,7 @@ ENTRY(xen_sysret64)
 	/* We're already on the usermode stack at this point, but still
 	   with the kernel gs, so we can easily switch back */
 	movq %rsp, %gs:pda_oldrsp
-	movq %gs:pda_kernelstack,%rsp
+	movq PER_CPU_VAR(kernelstack),%rsp
 
 	pushq $__USER_DS
 	pushq %gs:pda_oldrsp
@@ -213,7 +213,7 @@ ENTRY(xen_sysret32)
 	/* We're already on the usermode stack at this point, but still
 	   with the kernel gs, so we can easily switch back */
 	movq %rsp, %gs:pda_oldrsp
-	movq %gs:pda_kernelstack, %rsp
+	movq PER_CPU_VAR(kernelstack), %rsp
 
 	pushq $__USER32_DS
 	pushq %gs:pda_oldrsp
-- 
1.6.1.rc1


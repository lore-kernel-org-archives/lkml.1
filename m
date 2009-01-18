Return-Path: <linux-kernel-owner+w=401wt.eu-S934344AbZARQo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344AbZARQo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933795AbZARQju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:39:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:37551 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933674AbZARQjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:39:47 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/12] x86-64: Move irqcount from PDA to per-cpu.
Date: Mon, 19 Jan 2009 01:39:16 +0900
Message-Id: <1232296759-2253-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232296759-2253-1-git-send-email-tj@kernel.org>
References: <1232296759-2253-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 16:39:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

tj: s/irqcount/irq_count/

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/pda.h       |    2 +-
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/cpu/common.c     |    4 ++--
 arch/x86/kernel/entry_64.S       |   14 +++++++-------
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index ae23deb..4527d70 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -15,7 +15,7 @@ struct x8664_pda {
 	unsigned long unused2;
 	unsigned long unused3;
 	unsigned long unused4;
-	int irqcount;			/* 32 Irq nesting counter. Starts -1 */
+	int unused5;
 	unsigned int unused6;		/* 36 was cpunumber */
 #ifdef CONFIG_CC_STACKPROTECTOR
 	unsigned long stack_canary;	/* 40 stack canary value */
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index afda6de..64c834a 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -49,7 +49,6 @@ int main(void)
 	BLANK();
 #undef ENTRY
 #define ENTRY(entry) DEFINE(pda_ ## entry, offsetof(struct x8664_pda, entry))
-	ENTRY(irqcount);
 	DEFINE(pda_size, sizeof(struct x8664_pda));
 	BLANK();
 #undef ENTRY
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 06b6290..e2323ec 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -893,6 +893,8 @@ DEFINE_PER_CPU(unsigned long, kernel_stack) =
 	(unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
 EXPORT_PER_CPU_SYMBOL(kernel_stack);
 
+DEFINE_PER_CPU(unsigned int, irq_count) = -1;
+
 void __cpuinit pda_init(int cpu)
 {
 	struct x8664_pda *pda = cpu_pda(cpu);
@@ -903,8 +905,6 @@ void __cpuinit pda_init(int cpu)
 
 	load_pda_offset(cpu);
 
-	pda->irqcount = -1;
-
 	if (cpu != 0) {
 		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
 			pda->nodenumber = cpu_to_node(cpu);
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 7c27da4..c52b609 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -337,12 +337,12 @@ ENTRY(save_args)
 	je 1f
 	SWAPGS
 	/*
-	 * irqcount is used to check if a CPU is already on an interrupt stack
+	 * irq_count is used to check if a CPU is already on an interrupt stack
 	 * or not. While this is essentially redundant with preempt_count it is
 	 * a little cheaper to use a separate counter in the PDA (short of
 	 * moving irq_enter into assembly, which would be too much work)
 	 */
-1:	incl %gs:pda_irqcount
+1:	incl PER_CPU_VAR(irq_count)
 	jne 2f
 	popq_cfi %rax			/* move return address... */
 	mov PER_CPU_VAR(irq_stack_ptr),%rsp
@@ -837,7 +837,7 @@ common_interrupt:
 ret_from_intr:
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	decl %gs:pda_irqcount
+	decl PER_CPU_VAR(irq_count)
 	leaveq
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET	-8
@@ -1260,14 +1260,14 @@ ENTRY(call_softirq)
 	CFI_REL_OFFSET rbp,0
 	mov  %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
-	incl %gs:pda_irqcount
+	incl PER_CPU_VAR(irq_count)
 	cmove PER_CPU_VAR(irq_stack_ptr),%rsp
 	push  %rbp			# backlink for old unwinder
 	call __do_softirq
 	leaveq
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET   -8
-	decl %gs:pda_irqcount
+	decl PER_CPU_VAR(irq_count)
 	ret
 	CFI_ENDPROC
 END(call_softirq)
@@ -1297,7 +1297,7 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	movq %rdi, %rsp            # we don't return, adjust the stack frame
 	CFI_ENDPROC
 	DEFAULT_FRAME
-11:	incl %gs:pda_irqcount
+11:	incl PER_CPU_VAR(irq_count)
 	movq %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
 	cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
@@ -1305,7 +1305,7 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	call xen_evtchn_do_upcall
 	popq %rsp
 	CFI_DEF_CFA_REGISTER rsp
-	decl %gs:pda_irqcount
+	decl PER_CPU_VAR(irq_count)
 	jmp  error_exit
 	CFI_ENDPROC
 END(do_hypervisor_callback)
-- 
1.6.0.2


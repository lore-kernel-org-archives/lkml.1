Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbYLYU71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYLYU71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 15:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYLYU64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 15:58:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51748 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbYLYU6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 15:58:54 -0500
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: Remove pda.irqcount
Date: Thu, 25 Dec 2008 22:58:45 +0200
Message-Id: <1230238726-17506-3-git-send-email-avi@redhat.com>
In-Reply-To: <1230238726-17506-1-git-send-email-avi@redhat.com>
References: <1230238726-17506-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pda.irqcount is used to test whether we need to switch to an irqstack or not.
We can do without it, however, by testing %rsp directly: if it's already
within the irqstack range we don't need to stacks.

This makes switching the nmi handler to use the irqstack easier.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/pda.h       |    2 +-
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/cpu/common.c     |    1 -
 arch/x86/kernel/entry_64.S       |   29 +++++++++++++----------------
 4 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 2fbfff8..2099610 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -14,7 +14,7 @@ struct x8664_pda {
 					   address */
 	unsigned long kernelstack;	/* 16 top of kernel stack for current */
 	unsigned long oldrsp;		/* 24 user rsp for system call */
-	int irqcount;			/* 32 Irq nesting counter. Starts -1 */
+	int unused;			/* 32 for rent */
 	unsigned int cpunumber;		/* 36 Logical CPU number */
 #ifdef CONFIG_CC_STACKPROTECTOR
 	unsigned long stack_canary;	/* 40 stack canary value */
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 7fcf63d..779d010 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -50,7 +50,6 @@ int main(void)
 	ENTRY(kernelstack); 
 	ENTRY(oldrsp); 
 	ENTRY(pcurrent); 
-	ENTRY(irqcount);
 	ENTRY(cpunumber);
 	ENTRY(irqstackptr);
 	ENTRY(data_offset);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8563c51..6313d03 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -877,7 +877,6 @@ void __cpuinit pda_init(int cpu)
 	mb();
 
 	pda->cpunumber = cpu;
-	pda->irqcount = -1;
 	pda->kernelstack = (unsigned long)stack_thread_info() -
 				 PDA_STACKOFFSET + THREAD_SIZE;
 	pda->active_mm = &init_mm;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8c882e1..245fecd 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -627,6 +627,15 @@ END(stub_rt_sigreturn)
    vector already pushed) */
 #define XCPT_FRAME _frame ORIG_RAX
 
+	.macro enter_irqstack scratch
+	mov %gs:pda_irqstackptr, \scratch
+	sub %rsp, \scratch
+	cmp $IRQSTACKSIZE-64, \scratch
+	jbe 1234f
+	mov %gs:pda_irqstackptr, %rsp
+1234:
+	.endm
+
 /* 
  * Interrupt entry/exit.
  *
@@ -655,14 +664,7 @@ END(stub_rt_sigreturn)
 	testl $3,CS(%rdi)
 	je 1f
 	SWAPGS
-	/* irqcount is used to check if a CPU is already on an interrupt
-	   stack or not. While this is essentially redundant with preempt_count
-	   it is a little cheaper to use a separate counter in the PDA
-	   (short of moving irq_enter into assembly, which would be too
-	    much work) */
-1:	incl	%gs:pda_irqcount
-	cmoveq %gs:pda_irqstackptr,%rsp
-	push    %rbp			# backlink for old unwinder
+1:	enter_irqstack %rax
 	/*
 	 * We entered an interrupt context - irqs are off:
 	 */
@@ -677,7 +679,6 @@ ENTRY(common_interrupt)
 ret_from_intr:
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	decl %gs:pda_irqcount
 	leaveq
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET	-8
@@ -1325,14 +1326,12 @@ ENTRY(call_softirq)
 	CFI_REL_OFFSET rbp,0
 	mov  %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
-	incl %gs:pda_irqcount
-	cmove %gs:pda_irqstackptr,%rsp
+	enter_irqstack %rax
 	push  %rbp			# backlink for old unwinder
 	call __do_softirq
 	leaveq
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET   -8
-	decl %gs:pda_irqcount
 	ret
 	CFI_ENDPROC
 ENDPROC(call_softirq)
@@ -1369,15 +1368,13 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	movq %rdi, %rsp            # we don't return, adjust the stack frame
 	CFI_ENDPROC
 	CFI_DEFAULT_STACK
-11:	incl %gs:pda_irqcount
-	movq %rsp,%rbp
+11:	movq %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
-	cmovzq %gs:pda_irqstackptr,%rsp
+	enter_irqstack %rax
 	pushq %rbp			# backlink for old unwinder
 	call xen_evtchn_do_upcall
 	popq %rsp
 	CFI_DEF_CFA_REGISTER rsp
-	decl %gs:pda_irqcount
 	jmp  error_exit
 	CFI_ENDPROC
 END(do_hypervisor_callback)
-- 
1.6.0.6


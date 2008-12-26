Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbYLZOXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbYLZOXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 09:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYLZOWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 09:22:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47356 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbYLZOW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 09:22:29 -0500
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: jeremy@goop.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 2/4] x86: Consolidate irq stack switching to a single macro
Date: Fri, 26 Dec 2008 16:22:22 +0200
Message-Id: <1230301344-570-3-git-send-email-avi@redhat.com>
In-Reply-To: <1230301344-570-1-git-send-email-avi@redhat.com>
References: <1230301344-570-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of scattering the logic around, move all stack switching logic
into a single macro which calls a caller-supplied logic.

This makes changing the logic easier and improves readability.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/entry_64.S |   59 +++++++++++++++----------------------------
 1 files changed, 21 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 4d47cb8..4f1a38f 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -315,6 +315,22 @@ ENTRY(native_usergs_sysret64)
 	CFI_REL_OFFSET r15, R15+\offset
 	.endm
 
+	.macro call_in_irqstack func
+	/* Switch to the irq stack, unless already on it, then call func */
+	push %rbp
+	CFI_ADJUST_CFA_OFFSET 8
+	mov %rsp,%rbp
+	CFI_DEF_CFA_REGISTER rbp
+	incl %gs:pda_irqcount
+	cmovz %gs:pda_irqstackptr,%rsp
+	EMPTY_FRAME 0
+	call \func
+	leaveq
+	CFI_DEF_CFA_REGISTER rsp
+	CFI_ADJUST_CFA_OFFSET -8
+	decl %gs:pda_irqcount
+	.endm
+
 /* save partial stack frame */
 ENTRY(save_args)
 	XCPT_FRAME
@@ -336,18 +352,6 @@ ENTRY(save_args)
 	je 1f
 	SWAPGS
 	/*
-	 * irqcount is used to check if a CPU is already on an interrupt stack
-	 * or not. While this is essentially redundant with preempt_count it is
-	 * a little cheaper to use a separate counter in the PDA (short of
-	 * moving irq_enter into assembly, which would be too much work)
-	 */
-1:	incl %gs:pda_irqcount
-	jne 2f
-	popq_cfi %rax			/* move return address... */
-	mov %gs:pda_irqstackptr,%rsp
-	EMPTY_FRAME 0
-	pushq_cfi %rax			/* ... to the new stack */
-	/*
 	 * We entered an interrupt context - irqs are off:
 	 */
 2:	TRACE_IRQS_OFF
@@ -819,8 +823,7 @@ END(interrupt)
 	subq $10*8, %rsp
 	CFI_ADJUST_CFA_OFFSET 10*8
 	call save_args
-	PARTIAL_FRAME 0
-	call \func
+	call_in_irqstack \func
 	.endm
 
 	/*
@@ -836,7 +839,6 @@ common_interrupt:
 ret_from_intr:
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	decl %gs:pda_irqcount
 	leaveq
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET	-8
@@ -1060,7 +1062,7 @@ ENTRY(\sym)
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
-	call \do_sym
+	call_in_irqstack \do_sym
 	jmp paranoid_exit	/* %ebx: no swapgs flag */
 	CFI_ENDPROC
 END(\sym)
@@ -1096,7 +1098,7 @@ ENTRY(\sym)
 	movq %rsp,%rdi			/* pt_regs pointer */
 	movq ORIG_RAX(%rsp),%rsi	/* get error code */
 	movq $-1,ORIG_RAX(%rsp)		/* no syscall to restart */
-	call \do_sym
+	call_in_irqstack \do_sym
 	jmp paranoid_exit		/* %ebx: no swapgs flag */
 	CFI_ENDPROC
 END(\sym)
@@ -1239,19 +1241,7 @@ END(kernel_execve)
 /* Call softirq on interrupt stack. Interrupts are off. */
 ENTRY(call_softirq)
 	CFI_STARTPROC
-	push %rbp
-	CFI_ADJUST_CFA_OFFSET	8
-	CFI_REL_OFFSET rbp,0
-	mov  %rsp,%rbp
-	CFI_DEF_CFA_REGISTER rbp
-	incl %gs:pda_irqcount
-	cmove %gs:pda_irqstackptr,%rsp
-	push  %rbp			# backlink for old unwinder
-	call __do_softirq
-	leaveq
-	CFI_DEF_CFA_REGISTER	rsp
-	CFI_ADJUST_CFA_OFFSET   -8
-	decl %gs:pda_irqcount
+	call_in_irqstack __do_softirq
 	ret
 	CFI_ENDPROC
 END(call_softirq)
@@ -1281,15 +1271,8 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	movq %rdi, %rsp            # we don't return, adjust the stack frame
 	CFI_ENDPROC
 	DEFAULT_FRAME
-11:	incl %gs:pda_irqcount
-	movq %rsp,%rbp
-	CFI_DEF_CFA_REGISTER rbp
-	cmovzq %gs:pda_irqstackptr,%rsp
-	pushq %rbp			# backlink for old unwinder
-	call xen_evtchn_do_upcall
-	popq %rsp
+	call_in_irqstack xen_evtchn_do_upcall
 	CFI_DEF_CFA_REGISTER rsp
-	decl %gs:pda_irqcount
 	jmp  error_exit
 	CFI_ENDPROC
 END(do_hypervisor_callback)
-- 
1.6.0.6


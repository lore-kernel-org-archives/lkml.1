Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbYKPO3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbYKPO3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 09:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYKPO2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 09:28:53 -0500
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:2584 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYKPO2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 09:28:52 -0500
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@lusi.uni-sb.de>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Glauber Costa <gcosta@redhat.com>
Subject: [RFC] x86: save_args out of line
Date: Sun, 16 Nov 2008 15:29:01 +0100
Message-Id: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1226845741-12470-1-git-send-email-heukelum@fastmail.fm>
References: <1226845741-12470-1-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Sun, 16 Nov 2008 15:27:47 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.31; VDF: 7.1.0.88; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@sleipnir.lusi.uni-sb.de>

The macro "interrupt" in entry_64.S generates a lot of code. This
patch moves most of its contents into an external function. It
saves anywhere between 500 and 2500 bytes of text depending on the
configuration.

The function returns with an altered stackpointer.

Dwarf2-annotations are most probably wrong or missing.

There is a comment in the original code about saving rbp twice, but
I don't understand what the code tries to do. First of all, the
second copy of rbp is written below the stack. Second, if the current
stack is already the irqstack, this second copy is overwritten. Third,
as far as I can tell, ebp should not be saved in pt_regs at all at
this stage as it is 'preserved' due to the C calling conventions. So
I left this second copy out and everything seems to work fine. If it
wouldn't, all exceptions and NMIs would be dangerous anyhow, as far
as I can see.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Glauber Costa <gcosta@redhat.com>

---
 arch/x86/kernel/entry_64.S |  123 ++++++++++++++++++++++++++------------------
 1 files changed, 73 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index a3a7fb2..eb57c23 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -247,6 +247,78 @@ ENTRY(native_usergs_sysret64)
 	CFI_REL_OFFSET	rsp,RSP
 	/*CFI_REL_OFFSET	ss,SS*/
 	.endm
+
+/*
+ * initial frame state for interrupts and exceptions
+ */
+	.macro _frame ref
+	CFI_STARTPROC simple
+	CFI_SIGNAL_FRAME
+	CFI_DEF_CFA rsp,SS+8-\ref
+	/*CFI_REL_OFFSET ss,SS-\ref*/
+	CFI_REL_OFFSET rsp,RSP-\ref
+	/*CFI_REL_OFFSET rflags,EFLAGS-\ref*/
+	/*CFI_REL_OFFSET cs,CS-\ref*/
+	CFI_REL_OFFSET rip,RIP-\ref
+	.endm
+
+/* initial frame state for interrupts (and exceptions without error code) */
+#define INTR_FRAME _frame RIP
+/* initial frame state for exceptions with error code (and interrupts with
+   vector already pushed) */
+#define XCPT_FRAME _frame ORIG_RAX
+
+/* save_args changes the stack */
+ENTRY(save_args)
+	XCPT_FRAME
+	cld
+	subq $9*8, %rsp
+	CFI_ADJUST_CFA_OFFSET 9*8
+	push 9*8(%rsp)		/* copy return address */
+	CFI_ADJUST_CFA_OFFSET 8
+	movq  %rdi, 8*8+16(%rsp)
+	CFI_REL_OFFSET rdi, 8*8+16
+	movq  %rsi, 7*8+16(%rsp)
+	CFI_REL_OFFSET rsi, 7*8+16
+	movq  %rdx, 6*8+16(%rsp)
+	CFI_REL_OFFSET rdx, 6*8+16
+	movq  %rcx, 5*8+16(%rsp)
+	CFI_REL_OFFSET rcx, 5*8+16
+	movq  %rax, 4*8+16(%rsp)
+	CFI_REL_OFFSET rax, 4*8+16
+	movq  %r8, 3*8+16(%rsp)
+	CFI_REL_OFFSET r8, 3*8+16
+	movq  %r9, 2*8+16(%rsp)
+	CFI_REL_OFFSET r9, 2*8+16
+	movq  %r10, 1*8+16(%rsp)
+	CFI_REL_OFFSET r10, 1*8+16
+	movq  %r11, 0*8+16(%rsp)
+	CFI_REL_OFFSET r11, 0*8+16
+	leaq -ARGOFFSET+16(%rsp),%rdi	/* arg1 for handler */
+	movq %rbp, 8(%rsp)		/* push %rbp */
+	leaq 8(%rsp), %rbp		/* mov %rsp, %ebp */
+	testl $3, CS(%rdi)
+	je 1f
+	SWAPGS
+	/*
+	 * irqcount is used to check if a CPU is already on an interrupt stack
+	 * or not. While this is essentially redundant with preempt_count it is
+	 * a little cheaper to use a separate counter in the PDA (short of
+	 * moving irq_enter into assembly, which would be too much work)
+	 */
+1:	incl %gs:pda_irqcount
+	jne 2f
+	pop %rax			/* move return address... */
+	mov %gs:pda_irqstackptr,%rsp
+	push %rax			/* ... to the new stack */
+	/*
+	 * We entered an interrupt context - irqs are off:
+	 */
+2:	TRACE_IRQS_OFF
+	ret
+	CFI_ENDPROC
+END(save_args)
+
 /*
  * A newly forked process directly context switches into this.
  */
@@ -615,26 +687,6 @@ ENTRY(stub_rt_sigreturn)
 END(stub_rt_sigreturn)
 
 /*
- * initial frame state for interrupts and exceptions
- */
-	.macro _frame ref
-	CFI_STARTPROC simple
-	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA rsp,SS+8-\ref
-	/*CFI_REL_OFFSET ss,SS-\ref*/
-	CFI_REL_OFFSET rsp,RSP-\ref
-	/*CFI_REL_OFFSET rflags,EFLAGS-\ref*/
-	/*CFI_REL_OFFSET cs,CS-\ref*/
-	CFI_REL_OFFSET rip,RIP-\ref
-	.endm
-
-/* initial frame state for interrupts (and exceptions without error code) */
-#define INTR_FRAME _frame RIP
-/* initial frame state for exceptions with error code (and interrupts with
-   vector already pushed) */
-#define XCPT_FRAME _frame ORIG_RAX
-
-/*
  * Interrupt entry/exit.
  *
  * Interrupt entry points save only callee clobbered registers in fast path.
@@ -644,36 +696,7 @@ END(stub_rt_sigreturn)
 
 /* 0(%rsp): interrupt number */
 	.macro interrupt func
-	cld
-	SAVE_ARGS
-	leaq -ARGOFFSET(%rsp),%rdi	# arg1 for handler
-	pushq %rbp
-	/*
-	 * Save rbp twice: One is for marking the stack frame, as usual, and the
-	 * other, to fill pt_regs properly. This is because bx comes right
-	 * before the last saved register in that structure, and not bp. If the
-	 * base pointer were in the place bx is today, this would not be needed.
-	 */
-	movq %rbp, -8(%rsp)
-	CFI_ADJUST_CFA_OFFSET	8
-	CFI_REL_OFFSET		rbp, 0
-	movq %rsp,%rbp
-	CFI_DEF_CFA_REGISTER	rbp
-	testl $3,CS(%rdi)
-	je 1f
-	SWAPGS
-	/* irqcount is used to check if a CPU is already on an interrupt
-	   stack or not. While this is essentially redundant with preempt_count
-	   it is a little cheaper to use a separate counter in the PDA
-	   (short of moving irq_enter into assembly, which would be too
-	    much work) */
-1:	incl	%gs:pda_irqcount
-	cmoveq %gs:pda_irqstackptr,%rsp
-	push    %rbp			# backlink for old unwinder
-	/*
-	 * We entered an interrupt context - irqs are off:
-	 */
-	TRACE_IRQS_OFF
+	call save_args
 	call \func
 	.endm
 
-- 
1.5.4.3


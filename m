Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYKQRxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYKQRxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYKQRxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:53:38 -0500
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:10327 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYKQRxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:53:37 -0500
Date: Mon, 17 Nov 2008 18:52:32 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Glauber Costa <gcosta@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [RFC,v2] x86_64: save_args out of line
Message-ID: <20081117175232.GA13766@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Mon, 17 Nov 2008 18:53:02 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.31; VDF: 7.1.0.97; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro "interrupt" in entry_64.S generates a lot of code and it
is used more and more often. This patch moves most of its contents
into an external function. This saves anywhere between 500 and 2500
bytes of text depending on the configuration.

Dwarf2-annotations are most probably wrong or missing at all.

v2 moves adjusting the stack to the caller. This avoids the ugly
shuffle to handle the position of the return address on the stack.

After this patch, a typical handler looks like this:

<thermal_interrupt>:
68 05 ff ff ff  pushq  $0xffffffffffffff05
48 83 ec 50     sub    $0x50,%rsp
e8 72 f4 ff ff  callq  ffffffff80211260 <save_args>
e8 ec 08 00 00  callq  ffffffff802126df <smp_thermal_inter_interrupt>
e9 16 fd ff ff  jmpq   ffffffff80211b0e <ret_from_intr>
0f 1f 84 00 00  nopl   0x0(%rax,%rax,1)
00 00 00 

I think this approach (v2) is much cleaner than using the same
strategy as for the exception handlers, where the address of
the C-handler is passed to a common entry point which makes
an indirect call to the handler.

<coprocessor_error>:
ff 15 f2 71 1c  callq  *0x1c71f2(%rip)     # <pv_irq_ops+0x38>
00
6a 00           pushq  $0x0
50              push   %rax
48 8d 05 d9 11  lea    0x11d9(%rip),%rax   # <do_coprocessor_error>
00 00 
e9 4b 99 0f 00  jmpq   ffffffff8030bbb0 <error_entry>
66 66 2e 0f 1f  nopw   %cs:0x0(%rax,%rax,1)
84 00 00 00 00 00 

The advantage of _this_ way of doing things is that the stubs can
probably be made to fit in 16 bytes, but it comes at the cost of
doing an unnecessary indirect call.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Thomas Gleixner <tglx@linutronix.de>

 arch/x86/kernel/entry_64.S |  135 ++++++++++++++++++++++++++------------------
 1 files changed, 81 insertions(+), 54 deletions(-)

---

Hi all,

I just want to give this one more shot ;). Comments?

This patch is on top of tip/x86/cleanups and contains some left-over
whitespace changes.

Greetings,
    Alexander

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 5492778..d483e07 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -242,6 +242,78 @@ ENTRY(native_usergs_sysret64)
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
+/*
+ * initial frame state for interrupts (and exceptions without error code)
+ */
+#define INTR_FRAME _frame RIP
+/*
+ * initial frame state for exceptions with error code (and interrupts
+ * with vector already pushed)
+ */
+#define XCPT_FRAME _frame ORIG_RAX
+
+/* save partial stack frame */
+ENTRY(save_args)
+	XCPT_FRAME
+	cld
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
@@ -608,65 +680,18 @@ ENTRY(stub_rt_sigreturn)
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
- *	
- * Entry runs with interrupts off.	
- */ 
+ *
+ * Entry runs with interrupts off.
+ */
 
-/* 0(%rsp): interrupt number */ 
+/* 0(%rsp): interrupt number */
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
+	subq $10*8, %rsp
+	CFI_ADJUST_CFA_OFFSET 10*8
+	call save_args
 	call \func
 	.endm
 
@@ -806,6 +831,8 @@ END(common_interrupt)
 /*
  * APIC interrupts.
  */
+	.p2align 5
+
 	.macro apicinterrupt num,func
 	INTR_FRAME
 	pushq $~(\num)

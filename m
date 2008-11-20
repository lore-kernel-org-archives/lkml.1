Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbYKTPGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbYKTPGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbYKTPEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:04:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57479 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759455AbYKTPEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:04:45 -0500
Date: Thu, 20 Nov 2008 16:04:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@novell.com>,
       Glauber Costa <gcosta@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: clean up after: move entry_64.S register saving
	out of the macros
Message-ID: <20081120150412.GC13550@elte.hu>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <20081119001811.GA23237@mailshack.com> <20081120134011.GA3627@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120134011.GA3627@mailshack.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> This add-on patch to x86: move entry_64.S register saving out of the 
> macros visually cleans up the appearance of the code by introducing 
> some basic helper macro's. It also adds some cfi annotations which 
> were missing.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> ---
>  arch/x86/kernel/entry_64.S |  220 ++++++++++++++++++++++----------------------
>  1 files changed, 112 insertions(+), 108 deletions(-)
> 
> Hello Ingo,
> 
> This patch improves the CFI-situation in entry_64.S, but restricted 
> mostly to the areas touched by "x86: move entry_64.S register saving 
> out of the macros". I'm sure there will be some small errors 
> somewhere, but it compiles and runs fine.

very nice cleanup! This is exactly what should be done. Applied to 
tip/x86/irq.

Note, i did a small rename:

    cfi_pushq  =>  pushq_cfi
    cfi_popq   =>  popq_cfi
    cfi_store  =>  movq_cfi

as the goal is to have the actual source code read mostly as regular 
assembly code. The fact that the macro is equivalent to a 
default-annotated pushq/popq/movq instruction is much more important 
than the fact that it also does CFI annotations.

Also, while cfi_store is correct as well, the usual x86 assembly term 
(and instruction used here) is movq.

Find below how the commit ended up looking like.

Thanks,

	Ingo

----------------->
>From 250f351f57022f125c19178af1b0335503f1a02d Mon Sep 17 00:00:00 2001
From: Alexander van Heukelum <heukelum@mailshack.com>
Date: Thu, 20 Nov 2008 14:40:11 +0100
Subject: [PATCH] x86: clean up after: move entry_64.S register saving out of the macros

This add-on patch to x86: move entry_64.S register saving out
of the macros visually cleans up the appearance of the code by
introducing some basic helper macro's. It also adds some cfi
annotations which were missing.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_64.S |  220 ++++++++++++++++++++++----------------------
 1 files changed, 112 insertions(+), 108 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 5a12432..6df9d31 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -60,6 +60,23 @@
 #define __AUDIT_ARCH_LE	   0x40000000
 
 	.code64
+/*
+ * Some macro's to hide the most frequently occuring CFI annotations.
+ */
+	.macro pushq_cfi reg
+	pushq \reg
+	CFI_ADJUST_CFA_OFFSET 8
+	.endm
+
+	.macro popq_cfi reg
+	popq \reg
+	CFI_ADJUST_CFA_OFFSET -8
+	.endm
+
+	.macro movq_cfi reg offset=0
+	movq %\reg, \offset(%rsp)
+	CFI_REL_OFFSET \reg, \offset
+	.endm
 
 #ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -213,84 +230,84 @@ ENTRY(native_usergs_sysret64)
 	CFI_ADJUST_CFA_OFFSET	-(6*8)
 	.endm
 
-	.macro	CFI_DEFAULT_STACK start=1
+/*
+ * initial frame state for interrupts (and exceptions without error code)
+ */
+	.macro EMPTY_FRAME start=1 offset=0
 	.if \start
-	CFI_STARTPROC	simple
+	CFI_STARTPROC simple
 	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA	rsp,SS+8
+	CFI_DEF_CFA rsp,8+\offset
 	.else
-	CFI_DEF_CFA_OFFSET SS+8
+	CFI_DEF_CFA_OFFSET 8+\offset
 	.endif
-	CFI_REL_OFFSET	r15,R15
-	CFI_REL_OFFSET	r14,R14
-	CFI_REL_OFFSET	r13,R13
-	CFI_REL_OFFSET	r12,R12
-	CFI_REL_OFFSET	rbp,RBP
-	CFI_REL_OFFSET	rbx,RBX
-	CFI_REL_OFFSET	r11,R11
-	CFI_REL_OFFSET	r10,R10
-	CFI_REL_OFFSET	r9,R9
-	CFI_REL_OFFSET	r8,R8
-	CFI_REL_OFFSET	rax,RAX
-	CFI_REL_OFFSET	rcx,RCX
-	CFI_REL_OFFSET	rdx,RDX
-	CFI_REL_OFFSET	rsi,RSI
-	CFI_REL_OFFSET	rdi,RDI
-	CFI_REL_OFFSET	rip,RIP
-	/*CFI_REL_OFFSET	cs,CS*/
-	/*CFI_REL_OFFSET	rflags,EFLAGS*/
-	CFI_REL_OFFSET	rsp,RSP
-	/*CFI_REL_OFFSET	ss,SS*/
 	.endm
 
 /*
- * initial frame state for interrupts and exceptions
+ * initial frame state for interrupts (and exceptions without error code)
  */
-	.macro _frame ref
-	CFI_STARTPROC simple
-	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA rsp,SS+8-\ref
-	/*CFI_REL_OFFSET ss,SS-\ref*/
-	CFI_REL_OFFSET rsp,RSP-\ref
-	/*CFI_REL_OFFSET rflags,EFLAGS-\ref*/
-	/*CFI_REL_OFFSET cs,CS-\ref*/
-	CFI_REL_OFFSET rip,RIP-\ref
+	.macro INTR_FRAME start=1 offset=0
+	EMPTY_FRAME \start, (SS+8-RIP)+\offset
+	/*CFI_REL_OFFSET ss, SS-RIP+\offset*/
+	CFI_REL_OFFSET rsp, RSP-RIP+\offset
+	/*CFI_REL_OFFSET rflags, EFLAGS-RIP+\offset*/
+	/*CFI_REL_OFFSET cs, CS-RIP+\offset*/
+	CFI_REL_OFFSET rip, RIP-RIP+\offset
 	.endm
 
 /*
- * initial frame state for interrupts (and exceptions without error code)
- */
-#define INTR_FRAME _frame RIP
-/*
  * initial frame state for exceptions with error code (and interrupts
  * with vector already pushed)
  */
-#define XCPT_FRAME _frame ORIG_RAX
+	.macro XCPT_FRAME start=1 offset=0
+	INTR_FRAME \start, (RIP-ORIG_RAX)+\offset
+	/*CFI_REL_OFFSET orig_rax, ORIG_RAX-ORIG_RAX*/
+	.endm
+
+/*
+ * frame that enables calling into C.
+ */
+	.macro PARTIAL_FRAME start=1 offset=0
+	XCPT_FRAME \start, (ORIG_RAX-ARGOFFSET)+\offset
+	CFI_REL_OFFSET rdi, (RDI-ARGOFFSET)+\offset
+	CFI_REL_OFFSET rsi, (RSI-ARGOFFSET)+\offset
+	CFI_REL_OFFSET rdx, (RDX-ARGOFFSET)+\offset
+	CFI_REL_OFFSET rcx, (RCX-ARGOFFSET)+\offset
+	CFI_REL_OFFSET rax, (RAX-ARGOFFSET)+\offset
+	CFI_REL_OFFSET r8, (R8-ARGOFFSET)+\offset
+	CFI_REL_OFFSET r9, (R9-ARGOFFSET)+\offset
+	CFI_REL_OFFSET r10, (R10-ARGOFFSET)+\offset
+	CFI_REL_OFFSET r11, (R11-ARGOFFSET)+\offset
+	.endm
+
+/*
+ * frame that enables passing a complete pt_regs to a C function.
+ */
+	.macro DEFAULT_FRAME start=1 offset=0
+	PARTIAL_FRAME \start, (R11-R15)+\offset
+	CFI_REL_OFFSET rbx, RBX+\offset
+	CFI_REL_OFFSET rbp, RBP+\offset
+	CFI_REL_OFFSET r12, R12+\offset
+	CFI_REL_OFFSET r13, R13+\offset
+	CFI_REL_OFFSET r14, R14+\offset
+	CFI_REL_OFFSET r15, R15+\offset
+	.endm
 
 /* save partial stack frame */
 ENTRY(save_args)
 	XCPT_FRAME
 	cld
-	movq  %rdi, 8*8+16(%rsp)
-	CFI_REL_OFFSET rdi, 8*8+16
-	movq  %rsi, 7*8+16(%rsp)
-	CFI_REL_OFFSET rsi, 7*8+16
-	movq  %rdx, 6*8+16(%rsp)
-	CFI_REL_OFFSET rdx, 6*8+16
-	movq  %rcx, 5*8+16(%rsp)
-	CFI_REL_OFFSET rcx, 5*8+16
-	movq  %rax, 4*8+16(%rsp)
-	CFI_REL_OFFSET rax, 4*8+16
-	movq  %r8, 3*8+16(%rsp)
-	CFI_REL_OFFSET r8, 3*8+16
-	movq  %r9, 2*8+16(%rsp)
-	CFI_REL_OFFSET r9, 2*8+16
-	movq  %r10, 1*8+16(%rsp)
-	CFI_REL_OFFSET r10, 1*8+16
-	movq  %r11, 0*8+16(%rsp)
-	CFI_REL_OFFSET r11, 0*8+16
+	movq_cfi rdi, (RDI-ARGOFFSET)+16
+	movq_cfi rsi, (RSI-ARGOFFSET)+16
+	movq_cfi rdx, (RDX-ARGOFFSET)+16
+	movq_cfi rcx, (RCX-ARGOFFSET)+16
+	movq_cfi rax, (RAX-ARGOFFSET)+16
+	movq_cfi r8, (R8-ARGOFFSET)+16
+	movq_cfi r9, (R9-ARGOFFSET)+16
+	movq_cfi r10, (R10-ARGOFFSET)+16
+	movq_cfi r11, (R11-ARGOFFSET)+16
 	leaq -ARGOFFSET+16(%rsp),%rdi	/* arg1 for handler */
-	movq %rbp, 8(%rsp)		/* push %rbp */
+	movq_cfi rbp, 8		/* push %rbp */
 	leaq 8(%rsp), %rbp		/* mov %rsp, %ebp */
 	testl $3, CS(%rdi)
 	je 1f
@@ -303,9 +320,10 @@ ENTRY(save_args)
 	 */
 1:	incl %gs:pda_irqcount
 	jne 2f
-	pop %rax			/* move return address... */
+	popq_cfi %rax			/* move return address... */
 	mov %gs:pda_irqstackptr,%rsp
-	push %rax			/* ... to the new stack */
+	EMPTY_FRAME 0
+	pushq_cfi %rax			/* ... to the new stack */
 	/*
 	 * We entered an interrupt context - irqs are off:
 	 */
@@ -319,7 +337,7 @@ END(save_args)
  */
 /* rdi:	prev */
 ENTRY(ret_from_fork)
-	CFI_DEFAULT_STACK
+	DEFAULT_FRAME
 	push kernel_eflags(%rip)
 	CFI_ADJUST_CFA_OFFSET 8
 	popf				# reset kernel eflags
@@ -732,6 +750,7 @@ END(interrupt)
 	subq $10*8, %rsp
 	CFI_ADJUST_CFA_OFFSET 10*8
 	call save_args
+	PARTIAL_FRAME 0
 	call \func
 	.endm
 
@@ -949,11 +968,11 @@ END(spurious_interrupt)
 	.macro zeroentry sym
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $-1		/* ORIG_RAX: no syscall to restart */
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $15*8,%rsp
 	CFI_ADJUST_CFA_OFFSET 15*8
 	call error_entry
+	DEFAULT_FRAME 0
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
 	call \sym
@@ -967,6 +986,7 @@ END(spurious_interrupt)
 	subq $15*8,%rsp
 	CFI_ADJUST_CFA_OFFSET 15*8
 	call error_entry
+	DEFAULT_FRAME 0
 	movq %rsp,%rdi			/* pt_regs pointer */
 	movq ORIG_RAX(%rsp),%rsi	/* get error code */
 	movq $-1,ORIG_RAX(%rsp)		/* no syscall to restart */
@@ -1079,40 +1099,25 @@ paranoid_schedule\trace:
  * returns in "no swapgs flag" in %ebx.
  */
 KPROBE_ENTRY(error_entry)
-	_frame RDI
+	XCPT_FRAME
 	CFI_ADJUST_CFA_OFFSET 15*8
 	/* oldrax contains error code */
 	cld
-	movq %rdi,14*8+8(%rsp)
-	CFI_REL_OFFSET rdi,RDI+8
-	movq %rsi,13*8+8(%rsp)
-	CFI_REL_OFFSET rsi,RSI+8
-	movq %rdx,12*8+8(%rsp)
-	CFI_REL_OFFSET rdx,RDX+8
-	movq %rcx,11*8+8(%rsp)
-	CFI_REL_OFFSET rcx,RCX+8
-	movq %rax,10*8+8(%rsp)
-	CFI_REL_OFFSET rax,RAX+8
-	movq %r8, 9*8+8(%rsp)
-	CFI_REL_OFFSET r8,R8+8
-	movq %r9, 8*8+8(%rsp)
-	CFI_REL_OFFSET r9,R9+8
-	movq %r10,7*8+8(%rsp)
-	CFI_REL_OFFSET r10,R10+8
-	movq %r11,6*8+8(%rsp)
-	CFI_REL_OFFSET r11,R11+8
-	movq %rbx,5*8+8(%rsp)
-	CFI_REL_OFFSET rbx,RBX+8
-	movq %rbp,4*8+8(%rsp)
-	CFI_REL_OFFSET rbp,RBP+8
-	movq %r12,3*8+8(%rsp)
-	CFI_REL_OFFSET r12,R12+8
-	movq %r13,2*8+8(%rsp)
-	CFI_REL_OFFSET r13,R13+8
-	movq %r14,1*8+8(%rsp)
-	CFI_REL_OFFSET r14,R14+8
-	movq %r15,0*8+8(%rsp)
-	CFI_REL_OFFSET r15,R15+8
+	movq_cfi rdi, RDI+8
+	movq_cfi rsi, RSI+8
+	movq_cfi rdx, RDX+8
+	movq_cfi rcx, RCX+8
+	movq_cfi rax, RAX+8
+	movq_cfi r8, R8+8
+	movq_cfi r9, R9+8
+	movq_cfi r10, R10+8
+	movq_cfi r11, R11+8
+	movq_cfi rbx, RBX+8
+	movq_cfi rbp, RBP+8
+	movq_cfi r12, R12+8
+	movq_cfi r13, R13+8
+	movq_cfi r14, R14+8
+	movq_cfi r15, R15+8
 	xorl %ebx,%ebx
 	testl $3,CS+8(%rsp)
 	je error_kernelspace
@@ -1146,7 +1151,7 @@ KPROBE_END(error_entry)
 
 /* ebx:	no swapgs flag (1: don't need swapgs, 0: need it) */
 KPROBE_ENTRY(error_exit)
-	_frame R15
+	DEFAULT_FRAME
 	movl %ebx,%eax
 	RESTORE_REST
 	DISABLE_INTERRUPTS(CLBR_NONE)
@@ -1455,7 +1460,7 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
    see the correct pointer to the pt_regs */
 	movq %rdi, %rsp            # we don't return, adjust the stack frame
 	CFI_ENDPROC
-	CFI_DEFAULT_STACK
+	DEFAULT_FRAME
 11:	incl %gs:pda_irqcount
 	movq %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
@@ -1483,10 +1488,13 @@ END(do_hypervisor_callback)
 # with its current contents: any discrepancy means we in category 1.
 */
 ENTRY(xen_failsafe_callback)
-	framesz = (RIP-0x30)	/* workaround buggy gas */
-	_frame framesz
-	CFI_REL_OFFSET rcx, 0
-	CFI_REL_OFFSET r11, 8
+	INTR_FRAME 1 (6*8)
+	/*CFI_REL_OFFSET gs,GS*/
+	/*CFI_REL_OFFSET fs,FS*/
+	/*CFI_REL_OFFSET es,ES*/
+	/*CFI_REL_OFFSET ds,DS*/
+	CFI_REL_OFFSET r11,8
+	CFI_REL_OFFSET rcx,0
 	movw %ds,%cx
 	cmpw %cx,0x10(%rsp)
 	CFI_REMEMBER_STATE
@@ -1507,12 +1515,9 @@ ENTRY(xen_failsafe_callback)
 	CFI_RESTORE r11
 	addq $0x30,%rsp
 	CFI_ADJUST_CFA_OFFSET -0x30
-	pushq $0
-	CFI_ADJUST_CFA_OFFSET 8
-	pushq %r11
-	CFI_ADJUST_CFA_OFFSET 8
-	pushq %rcx
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi $0	/* RIP */
+	pushq_cfi %r11
+	pushq_cfi %rcx
 	jmp general_protection
 	CFI_RESTORE_STATE
 1:	/* Segment mismatch => Category 1 (Bad segment). Retry the IRET. */
@@ -1522,8 +1527,7 @@ ENTRY(xen_failsafe_callback)
 	CFI_RESTORE r11
 	addq $0x30,%rsp
 	CFI_ADJUST_CFA_OFFSET -0x30
-	pushq $0
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi $0
 	SAVE_ALL
 	jmp error_exit
 	CFI_ENDPROC

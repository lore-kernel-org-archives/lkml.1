Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbYKSAUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbYKSAUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 19:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYKSAUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 19:20:24 -0500
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:6039 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbYKSAUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 19:20:21 -0500
Date: Wed, 19 Nov 2008 01:18:11 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Glauber Costa <gcosta@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH/RFC] Move entry_64.S register saving out of the macros
Message-ID: <20081119001811.GA23237@mailshack.com>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20081117175232.GA13766@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Wed, 19 Nov 2008 01:19:38 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.34; VDF: 7.1.0.104; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

Here is a combined patch that moves "save_args" out-of-line for
the interrupt macro and moves "error_entry" mostly out-of-line
for the zeroentry and errorentry macros.

The save_args function becomes really straightforward and easy
to understand, with the possible exception of the stack switch
code, which now needs to copy the return address of to the
calling function. Normal interrupts arrive with ((~vector)-0x80)
on the stack, which gets adjusted in common_interrupt:

<common_interrupt>:
(5)  addq   $0xffffffffffffff80,(%rsp)		/* -> ~(vector) */
(4)  sub    $0x50,%rsp				/* space for registers */
(5)  callq  ffffffff80211290 <save_args>
(5)  callq  ffffffff80214290 <do_IRQ>
<ret_from_intr>:
     ...

An apic interrupt stub now look like this:

<thermal_interrupt>:
(5)  pushq  $0xffffffffffffff05			/* ~(vector) */
(4)  sub    $0x50,%rsp				/* space for registers */
(5)  callq  ffffffff80211290 <save_args>
(5)  callq  ffffffff80212b8f <smp_thermal_interrupt>
(5)  jmpq   ffffffff80211f93 <ret_from_intr>

Similarly the exception handler register saving function becomes
simpler, without the need of any parameter shuffling. The stub
for an exception without errorcode looks like this:

<overflow>:
(6)  callq  *0x1cad12(%rip)        # ffffffff803dd448 <pv_irq_ops+0x38>
(2)  pushq  $0xffffffffffffffff			/* no syscall */
(4)  sub    $0x78,%rsp				/* space for registers */
(5)  callq  ffffffff8030e3b0 <error_entry>
(3)  mov    %rsp,%rdi				/* pt_regs pointer */
(2)  xor    %esi,%esi				/* no error code */
(5)  callq  ffffffff80213446 <do_overflow>
(5)  jmpq   ffffffff8030e460 <error_exit>

And one for an exception with errorcode like this:

<segment_not_present>:
(6)  callq  *0x1cab92(%rip)        # ffffffff803dd448 <pv_irq_ops+0x38>
(4)  sub    $0x78,%rsp				/* space for registers */
(5)  callq  ffffffff8030e3b0 <error_entry>
(3)  mov    %rsp,%rdi				/* pt_regs pointer */
(5)  mov    0x78(%rsp),%rsi			/* load error code */
(9)  movq   $0xffffffffffffffff,0x78(%rsp)	/* no syscall */
(5)  callq  ffffffff80213209 <do_segment_not_present>
(5)  jmpq   ffffffff8030e460 <error_exit>

Unfortunately, this last type is more than 32 bytes. But the total space
savings due to this patch is about 2500 bytes on an smp-configuration,
and I think the code is clearer than it was before. The tested kernels
were non-paravirt ones (i.e., without the indirect call at the top of
the exception handlers).

Anyhow, I tested this patch on top of a recent -tip. The machine
was an 2x4-core Xeon at 2333MHz. Measured where the delays between
(almost-)adjacent rdtsc instructions. The graphs show how much
time is spent outside of the program as a function of the measured
delay. The area under the graph represents the total time spent
outside the program. Eight instances of the rdtsctest were
started, each pinned to a single cpu. The histogams are added.
For each kernel two measurements were done: one in mostly idle
condition, the other while running "bonnie++ -f", bound to cpu 0.
Each measurement took 40 minutes runtime. See the attached graphs
for the results. The graphs overlap almost everywhere, but there
are small differences.

CFI_-annotations are missing or wrong. I intend to try to fix
that, but I'ld like comments on the approach first.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

 arch/x86/kernel/entry_64.S |  300 ++++++++++++++++++++++++--------------------
 1 files changed, 166 insertions(+), 134 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 936d296..e22502a 100644
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
  * Build the entry stubs and pointer table with some assembler magic.
  * We pack 7 stubs into a single 32-byte chunk, which will fit in a
  * single cache line on all modern x86 implementations.
@@ -674,46 +726,19 @@ END(irq_entries_start)
 END(interrupt)
 .previous
 
-/* 
+/*
  * Interrupt entry/exit.
  *
  * Interrupt entry points save only callee clobbered registers in fast path.
- *	
- * Entry runs with interrupts off.	
- */ 
+ *
+ * Entry runs with interrupts off.
+ */
 
 /* 0(%rsp): ~(interrupt number) */
 	.macro interrupt func
-	cld
-	SAVE_ARGS
-	leaq -ARGOFFSET(%rsp),%rdi	/* arg1 for handler */
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
 
@@ -859,6 +884,8 @@ END(common_interrupt)
 /*
  * APIC interrupts.
  */
+	.p2align 5
+
 	.macro apicinterrupt num,func
 	INTR_FRAME
 	pushq $~(\num)
@@ -929,24 +956,29 @@ END(spurious_interrupt)
 	.macro zeroentry sym
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $0	/* push error code/oldrax */
+	pushq $-1		/* ORIG_RAX: no syscall to restart */
 	CFI_ADJUST_CFA_OFFSET 8
-	pushq %rax	/* push real oldrax to the rdi slot */
-	CFI_ADJUST_CFA_OFFSET 8
-	CFI_REL_OFFSET rax,0
-	leaq  \sym(%rip),%rax
-	jmp error_entry
+	subq $15*8,%rsp
+	CFI_ADJUST_CFA_OFFSET 15*8
+	call error_entry
+	movq %rsp,%rdi		/* pt_regs pointer */
+	xorl %esi,%esi		/* no error code */
+	call \sym
+	jmp error_exit		/* %ebx: no swapgs flag */
 	CFI_ENDPROC
 	.endm
 
 	.macro errorentry sym
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq %rax
-	CFI_ADJUST_CFA_OFFSET 8
-	CFI_REL_OFFSET rax,0
-	leaq  \sym(%rip),%rax
-	jmp error_entry
+	subq $15*8,%rsp
+	CFI_ADJUST_CFA_OFFSET 15*8
+	call error_entry
+	movq %rsp,%rdi			/* pt_regs pointer */
+	movq ORIG_RAX(%rsp),%rsi	/* get error code */
+	movq $-1,ORIG_RAX(%rsp)		/* no syscall to restart */
+	call \sym
+	jmp error_exit			/* %ebx: no swapgs flag */
 	CFI_ENDPROC
 	.endm
 
@@ -1050,93 +1082,93 @@ paranoid_schedule\trace:
 	.endm
 
 /*
- * Exception entry point. This expects an error code/orig_rax on the stack
- * and the exception handler in %rax.
+ * Exception entry point. This expects an error code/orig_rax on the stack.
+ * returns in "no swapgs flag" in %ebx.
  */
 KPROBE_ENTRY(error_entry)
 	_frame RDI
-	CFI_REL_OFFSET rax,0
-	/* rdi slot contains rax, oldrax contains error code */
+	CFI_ADJUST_CFA_OFFSET 15*8
+	/* oldrax contains error code */
 	cld
-	subq  $14*8,%rsp
-	CFI_ADJUST_CFA_OFFSET	(14*8)
-	movq %rsi,13*8(%rsp)
-	CFI_REL_OFFSET	rsi,RSI
-	movq 14*8(%rsp),%rsi	/* load rax from rdi slot */
-	CFI_REGISTER	rax,rsi
-	movq %rdx,12*8(%rsp)
-	CFI_REL_OFFSET	rdx,RDX
-	movq %rcx,11*8(%rsp)
-	CFI_REL_OFFSET	rcx,RCX
-	movq %rsi,10*8(%rsp)	/* store rax */
-	CFI_REL_OFFSET	rax,RAX
-	movq %r8, 9*8(%rsp)
-	CFI_REL_OFFSET	r8,R8
-	movq %r9, 8*8(%rsp)
-	CFI_REL_OFFSET	r9,R9
-	movq %r10,7*8(%rsp)
-	CFI_REL_OFFSET	r10,R10
-	movq %r11,6*8(%rsp)
-	CFI_REL_OFFSET	r11,R11
-	movq %rbx,5*8(%rsp)
-	CFI_REL_OFFSET	rbx,RBX
-	movq %rbp,4*8(%rsp)
-	CFI_REL_OFFSET	rbp,RBP
-	movq %r12,3*8(%rsp)
-	CFI_REL_OFFSET	r12,R12
-	movq %r13,2*8(%rsp)
-	CFI_REL_OFFSET	r13,R13
-	movq %r14,1*8(%rsp)
-	CFI_REL_OFFSET	r14,R14
-	movq %r15,(%rsp)
-	CFI_REL_OFFSET	r15,R15
+	movq %rdi,14*8+8(%rsp)
+	CFI_REL_OFFSET rdi,RDI+8
+	movq %rsi,13*8+8(%rsp)
+	CFI_REL_OFFSET rsi,RSI+8
+	movq %rdx,12*8+8(%rsp)
+	CFI_REL_OFFSET rdx,RDX+8
+	movq %rcx,11*8+8(%rsp)
+	CFI_REL_OFFSET rcx,RCX+8
+	movq %rax,10*8+8(%rsp)
+	CFI_REL_OFFSET rax,RAX+8
+	movq %r8, 9*8+8(%rsp)
+	CFI_REL_OFFSET r8,R8+8
+	movq %r9, 8*8+8(%rsp)
+	CFI_REL_OFFSET r9,R9+8
+	movq %r10,7*8+8(%rsp)
+	CFI_REL_OFFSET r10,R10+8
+	movq %r11,6*8+8(%rsp)
+	CFI_REL_OFFSET r11,R11+8
+	movq %rbx,5*8+8(%rsp)
+	CFI_REL_OFFSET rbx,RBX+8
+	movq %rbp,4*8+8(%rsp)
+	CFI_REL_OFFSET rbp,RBP+8
+	movq %r12,3*8+8(%rsp)
+	CFI_REL_OFFSET r12,R12+8
+	movq %r13,2*8+8(%rsp)
+	CFI_REL_OFFSET r13,R13+8
+	movq %r14,1*8+8(%rsp)
+	CFI_REL_OFFSET r14,R14+8
+	movq %r15,0*8+8(%rsp)
+	CFI_REL_OFFSET r15,R15+8
 	xorl %ebx,%ebx
-	testl $3,CS(%rsp)
-	je  error_kernelspace
+	testl $3,CS+8(%rsp)
+	je error_kernelspace
 error_swapgs:
 	SWAPGS
 error_sti:
 	TRACE_IRQS_OFF
-	movq %rdi,RDI(%rsp)
-	CFI_REL_OFFSET	rdi,RDI
-	movq %rsp,%rdi
-	movq ORIG_RAX(%rsp),%rsi	/* get error code */
-	movq $-1,ORIG_RAX(%rsp)
-	call *%rax
-	/* ebx:	no swapgs flag (1: don't need swapgs, 0: need it) */
-error_exit:
+	ret
+	CFI_ENDPROC
+
+/*
+ * There are two places in the kernel that can potentially fault with
+ * usergs. Handle them here. The exception handlers after iret run with
+ * kernel gs again, so don't set the user space flag. B stepping K8s
+ * sometimes report an truncated RIP for IRET exceptions returning to
+ * compat mode. Check for these here too.
+ */
+error_kernelspace:
+	incl %ebx
+	leaq irq_return(%rip),%rcx
+	cmpq %rcx,RIP+8(%rsp)
+	je error_swapgs
+	movl %ecx,%ecx	/* zero extend */
+	cmpq %rcx,RIP+8(%rsp)
+	je error_swapgs
+	cmpq $gs_change,RIP+8(%rsp)
+        je error_swapgs
+	jmp error_sti
+KPROBE_END(error_entry)
+
+
+/* ebx:	no swapgs flag (1: don't need swapgs, 0: need it) */
+KPROBE_ENTRY(error_exit)
+	_frame R15
 	movl %ebx,%eax
 	RESTORE_REST
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	GET_THREAD_INFO(%rcx)
 	testl %eax,%eax
-	jne  retint_kernel
+	jne retint_kernel
 	LOCKDEP_SYS_EXIT_IRQ
-	movl  TI_flags(%rcx),%edx
-	movl  $_TIF_WORK_MASK,%edi
-	andl  %edi,%edx
-	jnz  retint_careful
+	movl TI_flags(%rcx),%edx
+	movl $_TIF_WORK_MASK,%edi
+	andl %edi,%edx
+	jnz retint_careful
 	jmp retint_swapgs
 	CFI_ENDPROC
-
-error_kernelspace:
-	incl %ebx
-       /* There are two places in the kernel that can potentially fault with
-          usergs. Handle them here. The exception handlers after
-	   iret run with kernel gs again, so don't set the user space flag.
-	   B stepping K8s sometimes report an truncated RIP for IRET
-	   exceptions returning to compat mode. Check for these here too. */
-	leaq irq_return(%rip),%rcx
-	cmpq %rcx,RIP(%rsp)
-	je   error_swapgs
-	movl %ecx,%ecx	/* zero extend */
-	cmpq %rcx,RIP(%rsp)
-	je   error_swapgs
-	cmpq $gs_change,RIP(%rsp)
-        je   error_swapgs
-	jmp  error_sti
-KPROBE_END(error_entry)
+KPROBE_END(error_exit)
 
        /* Reload gs selector with exception handling */
        /* edi:  new selector */

--3V7upXqbjpZ4EhLz
Content-Type: image/png
Content-Disposition: attachment; filename="load.png"
Content-Transfer-Encoding: base64

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

--3V7upXqbjpZ4EhLz
Content-Type: image/png
Content-Disposition: attachment; filename="idle.png"
Content-Transfer-Encoding: base64

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
FWQAAAAASUVORK5CYII=

--3V7upXqbjpZ4EhLz--

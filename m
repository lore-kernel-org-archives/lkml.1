Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbYKUPsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbYKUPsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756540AbYKUPom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:44:42 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:25233 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbYKUPoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:44:39 -0500
Date: Fri, 21 Nov 2008 16:43:18 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@novell.com>,
       Glauber Costa <gcosta@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] x86: entry_64.S: Factor out save_paranoid and paranoid_exit.
Message-ID: <20081121154318.GA13014@mailshack.com>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <20081119001811.GA23237@mailshack.com> <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu> <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu> <20081121154155.GA12999@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121154155.GA12999@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Fri, 21 Nov 2008 16:43:54 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.35; VDF: 7.1.0.120; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also expand the paranoid_exit0 macro into nmi_exit inside the
nmi stub in the case of enabled irq-tracing.

This gives a few hundred bytes code size reduction.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_64.S |  151 +++++++++++++++++++++++++++++--------------
 1 files changed, 102 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index ef95c45..fad777b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -353,6 +353,36 @@ ENTRY(save_rest)
 	CFI_ENDPROC
 END(save_rest)
 
+/* save complete stack frame */
+ENTRY(save_paranoid)
+	XCPT_FRAME 1 RDI+8
+	cld
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
+	movl $1,%ebx
+	movl $MSR_GS_BASE,%ecx
+	rdmsr
+	testl %edx,%edx
+	js 1f	/* negative -> in kernel */
+	SWAPGS
+	xorl %ebx,%ebx
+1:	ret
+	CFI_ENDPROC
+END(save_paranoid)
+
 /*
  * A newly forked process directly context switches into this.
  */
@@ -1012,24 +1042,15 @@ END(spurious_interrupt)
 	.endm
 
 	/* error code is on the stack already */
-	/* handle NMI like exceptions that can happen everywhere */
-	.macro paranoidentry sym, ist=0, irqtrace=1
-	SAVE_ALL
-	cld
-	movl $1,%ebx
-	movl  $MSR_GS_BASE,%ecx
-	rdmsr
-	testl %edx,%edx
-	js    1f
-	SWAPGS
-	xorl  %ebx,%ebx
-1:
+	.macro paranoidentry sym ist=0
+	subq $15*8, %rsp
+	CFI_ADJUST_CFA_OFFSET 15*8
+	call save_paranoid
+	DEFAULT_FRAME 0
 	.if \ist
 	movq	%gs:pda_data_offset, %rbp
 	.endif
-	.if \irqtrace
 	TRACE_IRQS_OFF
-	.endif
 	movq %rsp,%rdi
 	movq ORIG_RAX(%rsp),%rsi
 	movq $-1,ORIG_RAX(%rsp)
@@ -1041,9 +1062,7 @@ END(spurious_interrupt)
 	addq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
 	.endif
 	DISABLE_INTERRUPTS(CLBR_NONE)
-	.if \irqtrace
 	TRACE_IRQS_OFF
-	.endif
 	.endm
 
 	/*
@@ -1058,57 +1077,48 @@ END(spurious_interrupt)
 	 * is fundamentally NMI-unsafe. (we cannot change the soft and
 	 * hard flags at once, atomically)
 	 */
-	.macro paranoidexit trace=1
+
 	/* ebx:	no swapgs flag */
-paranoid_exit\trace:
+KPROBE_ENTRY(paranoid_exit)
+	INTR_FRAME
 	testl %ebx,%ebx				/* swapgs needed? */
-	jnz paranoid_restore\trace
+	jnz paranoid_restore
 	testl $3,CS(%rsp)
-	jnz   paranoid_userspace\trace
-paranoid_swapgs\trace:
-	.if \trace
+	jnz   paranoid_userspace
+paranoid_swapgs:
 	TRACE_IRQS_IRETQ 0
-	.endif
 	SWAPGS_UNSAFE_STACK
-paranoid_restore\trace:
+paranoid_restore:
 	RESTORE_ALL 8
 	jmp irq_return
-paranoid_userspace\trace:
+paranoid_userspace:
 	GET_THREAD_INFO(%rcx)
 	movl TI_flags(%rcx),%ebx
 	andl $_TIF_WORK_MASK,%ebx
-	jz paranoid_swapgs\trace
+	jz paranoid_swapgs
 	movq %rsp,%rdi			/* &pt_regs */
 	call sync_regs
 	movq %rax,%rsp			/* switch stack for scheduling */
 	testl $_TIF_NEED_RESCHED,%ebx
-	jnz paranoid_schedule\trace
+	jnz paranoid_schedule
 	movl %ebx,%edx			/* arg3: thread flags */
-	.if \trace
 	TRACE_IRQS_ON
-	.endif
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	xorl %esi,%esi 			/* arg2: oldset */
 	movq %rsp,%rdi 			/* arg1: &pt_regs */
 	call do_notify_resume
 	DISABLE_INTERRUPTS(CLBR_NONE)
-	.if \trace
 	TRACE_IRQS_OFF
-	.endif
-	jmp paranoid_userspace\trace
-paranoid_schedule\trace:
-	.if \trace
+	jmp paranoid_userspace
+paranoid_schedule:
 	TRACE_IRQS_ON
-	.endif
 	ENABLE_INTERRUPTS(CLBR_ANY)
 	call schedule
 	DISABLE_INTERRUPTS(CLBR_ANY)
-	.if \trace
 	TRACE_IRQS_OFF
-	.endif
-	jmp paranoid_userspace\trace
+	jmp paranoid_userspace
 	CFI_ENDPROC
-	.endm
+END(paranoid_exit)
 
 /*
  * Exception entry point. This expects an error code/orig_rax on the stack.
@@ -1326,20 +1336,63 @@ KPROBE_ENTRY(debug)
 	pushq $0
 	CFI_ADJUST_CFA_OFFSET 8
 	paranoidentry do_debug, DEBUG_STACK
-	paranoidexit
+	jmp paranoid_exit
+ 	CFI_ENDPROC
 KPROBE_END(debug)
 
 	/* runs on exception stack */
 KPROBE_ENTRY(nmi)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $-1
-	CFI_ADJUST_CFA_OFFSET 8
-	paranoidentry do_nmi, 0, 0
+	pushq_cfi $-1
+	subq $15*8, %rsp
+	CFI_ADJUST_CFA_OFFSET 15*8
+	call save_paranoid
+	DEFAULT_FRAME 0
+	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
+	movq %rsp,%rdi
+	movq ORIG_RAX(%rsp),%rsi
+	movq $-1,ORIG_RAX(%rsp)
+	call do_nmi
+	DISABLE_INTERRUPTS(CLBR_NONE)
 #ifdef CONFIG_TRACE_IRQFLAGS
-	paranoidexit 0
+	/* paranoidexit; without TRACE_IRQS_OFF */
+	/* ebx:	no swapgs flag */
+nmi_exit:
+	testl %ebx,%ebx				/* swapgs needed? */
+	jnz nmi_restore
+	testl $3,CS(%rsp)
+	jnz nmi_userspace
+nmi_swapgs:
+	SWAPGS_UNSAFE_STACK
+nmi_restore:
+	RESTORE_ALL 8
+	jmp irq_return
+nmi_userspace:
+	GET_THREAD_INFO(%rcx)
+	movl TI_flags(%rcx),%ebx
+	andl $_TIF_WORK_MASK,%ebx
+	jz nmi_swapgs
+	movq %rsp,%rdi			/* &pt_regs */
+	call sync_regs
+	movq %rax,%rsp			/* switch stack for scheduling */
+	testl $_TIF_NEED_RESCHED,%ebx
+	jnz nmi_schedule
+	movl %ebx,%edx			/* arg3: thread flags */
+	ENABLE_INTERRUPTS(CLBR_NONE)
+	xorl %esi,%esi 			/* arg2: oldset */
+	movq %rsp,%rdi 			/* arg1: &pt_regs */
+	call do_notify_resume
+	DISABLE_INTERRUPTS(CLBR_NONE)
+	jmp nmi_userspace
+nmi_schedule:
+	ENABLE_INTERRUPTS(CLBR_ANY)
+	call schedule
+	DISABLE_INTERRUPTS(CLBR_ANY)
+	jmp nmi_userspace
+	CFI_ENDPROC
 #else
-	jmp paranoid_exit1
+	jmp paranoid_exit
  	CFI_ENDPROC
 #endif
 KPROBE_END(nmi)
@@ -1350,7 +1403,7 @@ KPROBE_ENTRY(int3)
  	pushq $0
  	CFI_ADJUST_CFA_OFFSET 8
  	paranoidentry do_int3, DEBUG_STACK
- 	jmp paranoid_exit1
+ 	jmp paranoid_exit
  	CFI_ENDPROC
 KPROBE_END(int3)
 
@@ -1375,7 +1428,7 @@ ENTRY(double_fault)
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	paranoidentry do_double_fault
-	jmp paranoid_exit1
+	jmp paranoid_exit
 	CFI_ENDPROC
 END(double_fault)
 
@@ -1392,7 +1445,7 @@ ENTRY(stack_segment)
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	paranoidentry do_stack_segment
-	jmp paranoid_exit1
+	jmp paranoid_exit
 	CFI_ENDPROC
 END(stack_segment)
 
@@ -1420,7 +1473,7 @@ ENTRY(machine_check)
 	pushq $0
 	CFI_ADJUST_CFA_OFFSET 8
 	paranoidentry do_machine_check
-	jmp paranoid_exit1
+	jmp paranoid_exit
 	CFI_ENDPROC
 END(machine_check)
 #endif
-- 
1.5.4.3


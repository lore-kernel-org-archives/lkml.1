Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbYKUPs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbYKUPs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYKUPrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:47:40 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:25339 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462AbYKUPri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:47:38 -0500
Date: Fri, 21 Nov 2008 16:44:28 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@novell.com>,
       Glauber Costa <gcosta@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] Split out some macro's and move common code to paranoid_exit
Message-ID: <20081121154428.GB13014@mailshack.com>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <20081119001811.GA23237@mailshack.com> <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu> <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu> <20081121154155.GA12999@mailshack.com> <20081121154318.GA13014@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121154318.GA13014@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Fri, 21 Nov 2008 16:46:48 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.35; VDF: 7.1.0.120; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DISABLE_INTERRUPTS(CLBR_NONE)/TRACE_IRQS_OFF is now always
executed just before paranoid_exit. Move it there.

Split out paranoidzeroentry, paranoiderrorentry, and
paranoidzeroentry_ist to get more readable macro's.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_64.S |  102 ++++++++++++++++++++++----------------------
 1 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index fad777b..692c1da 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1026,6 +1026,39 @@ END(spurious_interrupt)
 	CFI_ENDPROC
 	.endm
 
+	.macro paranoidzeroentry sym
+	INTR_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
+	pushq $-1		/* ORIG_RAX: no syscall to restart */
+	CFI_ADJUST_CFA_OFFSET 8
+	subq $15*8, %rsp
+	call save_paranoid
+	TRACE_IRQS_OFF
+	movq %rsp,%rdi		/* pt_regs pointer */
+	xorl %esi,%esi		/* no error code */
+	call \sym
+	jmp paranoid_exit	/* %ebx: no swapgs flag */
+	CFI_ENDPROC
+	.endm
+
+	.macro paranoidzeroentry_ist sym ist
+ 	INTR_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
+	pushq $-1		/* ORIG_RAX: no syscall to restart */
+	CFI_ADJUST_CFA_OFFSET 8
+	subq $15*8, %rsp
+	call save_paranoid
+	TRACE_IRQS_OFF
+	movq %rsp,%rdi		/* pt_regs pointer */
+	xorl %esi,%esi		/* no error code */
+	movq %gs:pda_data_offset, %rbp
+	subq $EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
+	call \sym
+	addq $EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
+	jmp paranoid_exit	/* %ebx: no swapgs flag */
+	CFI_ENDPROC
+	.endm
+
 	.macro errorentry sym
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
@@ -1042,27 +1075,20 @@ END(spurious_interrupt)
 	.endm
 
 	/* error code is on the stack already */
-	.macro paranoidentry sym ist=0
-	subq $15*8, %rsp
+	.macro paranoiderrorentry sym
+	XCPT_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
+	subq $15*8,%rsp
 	CFI_ADJUST_CFA_OFFSET 15*8
 	call save_paranoid
 	DEFAULT_FRAME 0
-	.if \ist
-	movq	%gs:pda_data_offset, %rbp
-	.endif
 	TRACE_IRQS_OFF
-	movq %rsp,%rdi
-	movq ORIG_RAX(%rsp),%rsi
-	movq $-1,ORIG_RAX(%rsp)
-	.if \ist
-	subq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
-	.endif
+	movq %rsp,%rdi			/* pt_regs pointer */
+	movq ORIG_RAX(%rsp),%rsi	/* get error code */
+	movq $-1,ORIG_RAX(%rsp)		/* no syscall to restart */
 	call \sym
-	.if \ist
-	addq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
-	.endif
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	TRACE_IRQS_OFF
+	jmp paranoid_exit		/* %ebx: no swapgs flag */
+	CFI_ENDPROC
 	.endm
 
 	/*
@@ -1081,6 +1107,8 @@ END(spurious_interrupt)
 	/* ebx:	no swapgs flag */
 KPROBE_ENTRY(paranoid_exit)
 	INTR_FRAME
+	DISABLE_INTERRUPTS(CLBR_NONE)
+	TRACE_IRQS_OFF
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz paranoid_restore
 	testl $3,CS(%rsp)
@@ -1331,13 +1359,7 @@ END(device_not_available)
 
 	/* runs on exception stack */
 KPROBE_ENTRY(debug)
- 	INTR_FRAME
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $0
-	CFI_ADJUST_CFA_OFFSET 8
-	paranoidentry do_debug, DEBUG_STACK
-	jmp paranoid_exit
- 	CFI_ENDPROC
+	paranoidzeroentry_ist do_debug, DEBUG_STACK
 KPROBE_END(debug)
 
 	/* runs on exception stack */
@@ -1351,14 +1373,12 @@ KPROBE_ENTRY(nmi)
 	DEFAULT_FRAME 0
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
 	movq %rsp,%rdi
-	movq ORIG_RAX(%rsp),%rsi
-	movq $-1,ORIG_RAX(%rsp)
+	movq $-1,%rsi
 	call do_nmi
-	DISABLE_INTERRUPTS(CLBR_NONE)
 #ifdef CONFIG_TRACE_IRQFLAGS
 	/* paranoidexit; without TRACE_IRQS_OFF */
 	/* ebx:	no swapgs flag */
-nmi_exit:
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz nmi_restore
 	testl $3,CS(%rsp)
@@ -1398,13 +1418,7 @@ nmi_schedule:
 KPROBE_END(nmi)
 
 KPROBE_ENTRY(int3)
- 	INTR_FRAME
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
- 	pushq $0
- 	CFI_ADJUST_CFA_OFFSET 8
- 	paranoidentry do_int3, DEBUG_STACK
- 	jmp paranoid_exit
- 	CFI_ENDPROC
+	paranoidzeroentry_ist do_int3, DEBUG_STACK
 KPROBE_END(int3)
 
 ENTRY(overflow)
@@ -1425,11 +1439,7 @@ END(coprocessor_segment_overrun)
 
 	/* runs on exception stack */
 ENTRY(double_fault)
-	XCPT_FRAME
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	paranoidentry do_double_fault
-	jmp paranoid_exit
-	CFI_ENDPROC
+	paranoiderrorentry do_double_fault
 END(double_fault)
 
 ENTRY(invalid_TSS)
@@ -1442,11 +1452,7 @@ END(segment_not_present)
 
 	/* runs on exception stack */
 ENTRY(stack_segment)
-	XCPT_FRAME
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	paranoidentry do_stack_segment
-	jmp paranoid_exit
-	CFI_ENDPROC
+	paranoiderrorentry do_stack_segment
 END(stack_segment)
 
 KPROBE_ENTRY(general_protection)
@@ -1468,13 +1474,7 @@ END(spurious_interrupt_bug)
 #ifdef CONFIG_X86_MCE
 	/* runs on exception stack */
 ENTRY(machine_check)
-	INTR_FRAME
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $0
-	CFI_ADJUST_CFA_OFFSET 8
-	paranoidentry do_machine_check
-	jmp paranoid_exit
-	CFI_ENDPROC
+	paranoidzeroentry do_machine_check
 END(machine_check)
 #endif
 
-- 
1.5.4.3


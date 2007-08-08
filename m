Return-Path: <linux-kernel-owner+w=401wt.eu-S1761162AbXHHHMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761162AbXHHHMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758408AbXHHHIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:08:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759405AbXHHHIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:08:15 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 18/25] [PATCH] turn priviled operations into macros in entry.S
Date: Wed,  8 Aug 2007 01:19:05 -0300
Message-Id: <11865468243612-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1186546820708-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com> <1186546785346-git-send-email-gcosta@redhat.com> <1186546789356-git-send-email-gcosta@redhat.com> <11865467931543-git-send-email-gcosta@redhat.com> <11865467973510-git-send-email-gcosta@redhat.com> <11865468003673-git-send-email-gcosta@redhat.com> <11865468043920-git-send-email-gcosta@redhat.com> <118654680831-git-send-email-gcosta@redhat.com> <11865468122642-git-send-email-gcosta@redhat.com> <11865468162812-git-send-email-gcosta@redhat.com> <1186546820708-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With paravirt on, we cannot issue operations like swapgs, sysretq,
iretq, cli, sti. So they have to be changed into macros, that will
be later properly replaced for the paravirt case.

The sysretq is a little bit more complicated, and is replaced
by a sequence of three instructions. It is basically because if
we had already issued an swapgs, we would be with a user stack
at this point. So we do all-in-one.

The clobber list follows the idea of the i386 version closely,
and represents which registers are safe to modify at the
point the function is called.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/kernel/entry.S |  125 ++++++++++++++++++++++++++++---------------
 1 files changed, 81 insertions(+), 44 deletions(-)

diff --git a/arch/x86_64/kernel/entry.S b/arch/x86_64/kernel/entry.S
index 1d232e5..48e953b 100644
--- a/arch/x86_64/kernel/entry.S
+++ b/arch/x86_64/kernel/entry.S
@@ -51,8 +51,31 @@
 #include <asm/page.h>
 #include <asm/irqflags.h>
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define ENABLE_INTERRUPTS(x)	sti
+#define DISABLE_INTERRUPTS(x)	cli
+#define INTERRUPT_RETURN	iretq
+#define SWAPGS			swapgs
+#define SYSRETQ						\
+			movq	%gs:pda_oldrsp,%rsp;	\
+			swapgs;				\
+			sysretq;
+#endif
+
 	.code64
 
+/* Currently paravirt can't handle swapgs nicely when we
+ * don't have a stack.  So we either find a way around these
+ * or just fault and emulate if a guest tries to call swapgs
+ * directly.
+ *
+ * Either way, this is a good way to document that we don't
+ * have a reliable stack.
+ */
+#define SWAPGS_NOSTACK		swapgs
+
 #ifndef CONFIG_PREEMPT
 #define retint_kernel retint_restore_args
 #endif	
@@ -216,14 +239,14 @@ ENTRY(system_call)
 	CFI_DEF_CFA	rsp,PDA_STACKOFFSET
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
-	swapgs
+	SWAPGS_NOSTACK
 	movq	%rsp,%gs:pda_oldrsp 
 	movq	%gs:pda_kernelstack,%rsp
 	/*
 	 * No need to follow this irqs off/on section - it's straight
 	 * and short:
 	 */
-	sti					
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	SAVE_ARGS 8,1
 	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp) 
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
@@ -245,7 +268,7 @@ ret_from_sys_call:
 	/* edi:	flagmask */
 sysret_check:		
 	GET_THREAD_INFO(%rcx)
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	movl threadinfo_flags(%rcx),%edx
 	andl %edi,%edx
@@ -259,9 +282,7 @@ sysret_check:
 	CFI_REGISTER	rip,rcx
 	RESTORE_ARGS 0,-ARG_SKIP,1
 	/*CFI_REGISTER	rflags,r11*/
-	movq	%gs:pda_oldrsp,%rsp
-	swapgs
-	sysretq
+	SYSRETQ
 
 	CFI_RESTORE_STATE
 	/* Handle reschedules */
@@ -270,7 +291,7 @@ sysret_careful:
 	bt $TIF_NEED_RESCHED,%edx
 	jnc sysret_signal
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq %rdi
 	CFI_ADJUST_CFA_OFFSET 8
 	call schedule
@@ -281,7 +302,7 @@ sysret_careful:
 	/* Handle a signal */ 
 sysret_signal:
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY),%edx
 	jz    1f
 
@@ -294,7 +315,7 @@ sysret_signal:
 1:	movl $_TIF_NEED_RESCHED,%edi
 	/* Use IRET because user could have changed frame. This
 	   works because ptregscall_common has called FIXUP_TOP_OF_STACK. */
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp int_with_check
 	
@@ -326,7 +347,7 @@ tracesys:
  */
 	.globl int_ret_from_sys_call
 int_ret_from_sys_call:
-	cli
+	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
 	testl $3,CS-ARGOFFSET(%rsp)
 	je retint_restore_args
@@ -347,20 +368,20 @@ int_careful:
 	bt $TIF_NEED_RESCHED,%edx
 	jnc  int_very_careful
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq %rdi
 	CFI_ADJUST_CFA_OFFSET 8
 	call schedule
 	popq %rdi
 	CFI_ADJUST_CFA_OFFSET -8
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp int_with_check
 
 	/* handle signals and tracing -- both require a full stack frame */
 int_very_careful:
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	SAVE_REST
 	/* Check for syscall exit trace */	
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP),%edx
@@ -383,7 +404,7 @@ int_signal:
 1:	movl $_TIF_NEED_RESCHED,%edi	
 int_restore_rest:
 	RESTORE_REST
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp int_with_check
 	CFI_ENDPROC
@@ -504,7 +525,7 @@ END(stub_rt_sigreturn)
 	CFI_DEF_CFA_REGISTER	rbp
 	testl $3,CS(%rdi)
 	je 1f
-	swapgs	
+	SWAPGS
 	/* irqcount is used to check if a CPU is already on an interrupt
 	   stack or not. While this is essentially redundant with preempt_count
 	   it is a little cheaper to use a separate counter in the PDA
@@ -525,7 +546,7 @@ ENTRY(common_interrupt)
 	interrupt do_IRQ
 	/* 0(%rsp): oldrsp-ARGOFFSET */
 ret_from_intr:
-	cli	
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	decl %gs:pda_irqcount
 	leaveq
@@ -552,13 +573,13 @@ retint_swapgs:
 	/*
 	 * The iretq could re-enable interrupts:
 	 */
-	cli
+	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_IRETQ
-	swapgs 
+	SWAPGS
 	jmp restore_args
 
 retint_restore_args:				
-	cli
+	DISABLE_INTERRUPTS(CLBR_ANY)
 	/*
 	 * The iretq could re-enable interrupts:
 	 */
@@ -566,10 +587,14 @@ retint_restore_args:
 restore_args:
 	RESTORE_ARGS 0,8,0						
 iret_label:	
-	iretq
+#ifdef CONFIG_PARAVIRT
+	INTERRUPT_RETURN
+ENTRY(native_iret)
+#endif
+1:	iretq
 
 	.section __ex_table,"a"
-	.quad iret_label,bad_iret	
+	.quad 1b, bad_iret
 	.previous
 	.section .fixup,"ax"
 	/* force a signal here? this matches i386 behaviour */
@@ -577,24 +602,27 @@ iret_label:
 bad_iret:
 	movq $11,%rdi	/* SIGSEGV */
 	TRACE_IRQS_ON
-	sti
-	jmp do_exit			
-	.previous	
-	
+	ENABLE_INTERRUPTS(CLBR_ANY | ~(CLBR_RDI))
+	jmp do_exit
+	.previous
+#ifdef CONFIG_PARAVIRT
+ENDPROC(native_iret)
+#endif
+
 	/* edi: workmask, edx: work */
 retint_careful:
 	CFI_RESTORE_STATE
 	bt    $TIF_NEED_RESCHED,%edx
 	jnc   retint_signal
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq %rdi
 	CFI_ADJUST_CFA_OFFSET	8
 	call  schedule
 	popq %rdi		
 	CFI_ADJUST_CFA_OFFSET	-8
 	GET_THREAD_INFO(%rcx)
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp retint_check
 	
@@ -602,14 +630,14 @@ retint_signal:
 	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY),%edx
 	jz    retint_swapgs
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	SAVE_REST
 	movq $-1,ORIG_RAX(%rsp) 			
 	xorl %esi,%esi		# oldset
 	movq %rsp,%rdi		# &pt_regs
 	call do_notify_resume
 	RESTORE_REST
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	movl $_TIF_NEED_RESCHED,%edi
 	GET_THREAD_INFO(%rcx)
@@ -727,7 +755,7 @@ END(spurious_interrupt)
 	rdmsr
 	testl %edx,%edx
 	js    1f
-	swapgs
+	SWAPGS
 	xorl  %ebx,%ebx
 1:
 	.if \ist
@@ -743,7 +771,7 @@ END(spurious_interrupt)
 	.if \ist
 	addq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
 	.endif
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	.if \irqtrace
 	TRACE_IRQS_OFF
 	.endif
@@ -772,10 +800,10 @@ paranoid_swapgs\trace:
 	.if \trace
 	TRACE_IRQS_IRETQ 0
 	.endif
-	swapgs
+	SWAPGS_NOSTACK
 paranoid_restore\trace:
 	RESTORE_ALL 8
-	iretq
+	INTERRUPT_RETURN
 paranoid_userspace\trace:
 	GET_THREAD_INFO(%rcx)
 	movl threadinfo_flags(%rcx),%ebx
@@ -790,11 +818,11 @@ paranoid_userspace\trace:
 	.if \trace
 	TRACE_IRQS_ON
 	.endif
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	xorl %esi,%esi 			/* arg2: oldset */
 	movq %rsp,%rdi 			/* arg1: &pt_regs */
 	call do_notify_resume
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	.if \trace
 	TRACE_IRQS_OFF
 	.endif
@@ -803,9 +831,9 @@ paranoid_schedule\trace:
 	.if \trace
 	TRACE_IRQS_ON
 	.endif
-	sti
+	ENABLE_INTERRUPTS(CLBR_ANY)
 	call schedule
-	cli
+	DISABLE_INTERRUPTS(CLBR_ANY)
 	.if \trace
 	TRACE_IRQS_OFF
 	.endif
@@ -858,7 +886,7 @@ KPROBE_ENTRY(error_entry)
 	testl $3,CS(%rsp)
 	je  error_kernelspace
 error_swapgs:	
-	swapgs
+	SWAPGS
 error_sti:	
 	movq %rdi,RDI(%rsp) 	
 	CFI_REL_OFFSET	rdi,RDI
@@ -870,7 +898,7 @@ error_sti:
 error_exit:		
 	movl %ebx,%eax		
 	RESTORE_REST
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	GET_THREAD_INFO(%rcx)	
 	testl %eax,%eax
@@ -883,7 +911,7 @@ error_exit:
 	 * The iret might restore flags:
 	 */
 	TRACE_IRQS_IRETQ
-	swapgs 
+	SWAPGS
 	RESTORE_ARGS 0,8,0						
 	jmp iret_label
 	CFI_ENDPROC
@@ -912,12 +940,12 @@ ENTRY(load_gs_index)
 	CFI_STARTPROC
 	pushf
 	CFI_ADJUST_CFA_OFFSET 8
-	cli
-        swapgs
+	DISABLE_INTERRUPTS(CLBR_ANY | ~(CLBR_RDI))
+        SWAPGS
 gs_change:     
         movl %edi,%gs   
 2:	mfence		/* workaround */
-	swapgs
+	SWAPGS
         popf
 	CFI_ADJUST_CFA_OFFSET -8
         ret
@@ -931,7 +959,7 @@ ENDPROC(load_gs_index)
         .section .fixup,"ax"
 	/* running with kernelgs */
 bad_gs: 
-	swapgs			/* switch back to user gs */
+	SWAPGS			/* switch back to user gs */
 	xorl %eax,%eax
         movl %eax,%gs
         jmp  2b
@@ -1072,6 +1100,15 @@ KPROBE_ENTRY(int3)
  	CFI_ENDPROC
 KPROBE_END(int3)
 
+#ifdef CONFIG_PARAVIRT
+ENTRY(native_sysret)
+	movq	%gs:pda_oldrsp,%rsp
+	swapgs
+	sysretq
+ENDPROC(native_sysret)
+
+#endif /* CONFIG_PARAVIRT */
+
 ENTRY(overflow)
 	zeroentry do_overflow
 END(overflow)
-- 
1.4.4.2


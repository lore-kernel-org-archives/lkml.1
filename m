Return-Path: <linux-kernel-owner+w=401wt.eu-S1765696AbXHJWGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765696AbXHJWGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759441AbXHJWBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:01:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbXHJWBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:01:08 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 18/25 -v2] turn priviled operations into macros in entry.S
Date: Fri, 10 Aug 2007 16:12:30 -0300
Message-Id: <11867732461037-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11867732424024-git-send-email-gcosta@redhat.com>
References: <1186773157329-git-send-email-gcosta@redhat.com> <11867731633002-git-send-email-gcosta@redhat.com> <11867731681763-git-send-email-gcosta@redhat.com> <11867731732274-git-send-email-gcosta@redhat.com> <11867731781610-git-send-email-gcosta@redhat.com> <11867731831138-git-send-email-gcosta@redhat.com> <11867731882768-git-send-email-gcosta@redhat.com> <11867731932688-git-send-email-gcosta@redhat.com> <11867731981891-git-send-email-gcosta@redhat.com> <1186773203887-git-send-email-gcosta@redhat.com> <11867732082735-git-send-email-gcosta@redhat.com> <11867732121974-git-send-email-gcosta@redhat.com> <1186773217875-git-send-email-gcosta@redhat.com> <11867732221652-git-send-email-gcosta@redhat.com> <11867732273108-git-send-email-gcosta@redhat.com> <11867732323106-git-send-email-gcosta@redhat.com> <11867732373232-git-send-email-gcosta@redhat.com> <11867732424024-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With paravirt on, we cannot issue operations like swapgs, sysretq,
iretq, cli, sti. So they have to be changed into macros, that will
be later properly replaced for the paravirt case.

The sysretq is a little bit more complicated, and is replaced
by a sequence of three instructions. It is basically because if
we had already issued an swapgs, we would be with a user stack
at this point. So we do it all-in-one.

The clobber list follows the idea of the i386 version closely,
and represents which caller-saved registers are safe to modify
at the point the function is called. So for example, CLBR_ANY
says we can clobber rax, rdi, rsi, rdx, rcx, r8-r11, while
CLBR_NONE says we cannot touch annything.

[  updates from v1
   * renamed SYSRETQ to SYSCALL_RETURN
   * don't use ENTRY/ENDPROC for native_{syscall_return,iret}
   * fix one use of the clobber list
   * rename SWAPGS_NOSTACK to SWAPGS_UNSAFE_STACK
   * change the unexpressive 1b label to do_iret
   All suggested by Andi Kleen
]

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/kernel/entry.S |  130 +++++++++++++++++++++++++++++---------------
 1 files changed, 87 insertions(+), 43 deletions(-)

diff --git a/arch/x86_64/kernel/entry.S b/arch/x86_64/kernel/entry.S
index 1d232e5..db8707a 100644
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
+#define SYSCALL_RETURN					\
+			movq	%gs:pda_oldrsp,%rsp;	\
+			swapgs;				\
+			sysretq;
+#endif
+
 	.code64
 
+/* Currently paravirt can't handle swapgs nicely when we
+ * don't have a stack we can rely on (such as a user space
+ * stack).  So we either find a way around these or just fault
+ * and emulate if a guest tries to call swapgs directly.
+ *
+ * Either way, this is a good way to document that we don't
+ * have a reliable stack.
+ */
+#define SWAPGS_UNSAFE_STACK	swapgs
+
 #ifndef CONFIG_PREEMPT
 #define retint_kernel retint_restore_args
 #endif	
@@ -216,14 +239,23 @@ ENTRY(system_call)
 	CFI_DEF_CFA	rsp,PDA_STACKOFFSET
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
-	swapgs
+	SWAPGS_UNSAFE_STACK
+#ifdef CONFIG_PARAVIRT
+	/*
+	 * A hypervisor implementation might want to use a label
+	 * after the swapgs, so that it can do the swapgs
+	 * for the guest and jump here on syscall.
+	 */
+	.globl system_call_after_swapgs
+system_call_after_swapgs:
+#endif
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
@@ -245,7 +277,7 @@ ret_from_sys_call:
 	/* edi:	flagmask */
 sysret_check:		
 	GET_THREAD_INFO(%rcx)
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	movl threadinfo_flags(%rcx),%edx
 	andl %edi,%edx
@@ -259,9 +291,7 @@ sysret_check:
 	CFI_REGISTER	rip,rcx
 	RESTORE_ARGS 0,-ARG_SKIP,1
 	/*CFI_REGISTER	rflags,r11*/
-	movq	%gs:pda_oldrsp,%rsp
-	swapgs
-	sysretq
+	SYSCALL_RETURN
 
 	CFI_RESTORE_STATE
 	/* Handle reschedules */
@@ -270,7 +300,7 @@ sysret_careful:
 	bt $TIF_NEED_RESCHED,%edx
 	jnc sysret_signal
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq %rdi
 	CFI_ADJUST_CFA_OFFSET 8
 	call schedule
@@ -281,7 +311,7 @@ sysret_careful:
 	/* Handle a signal */ 
 sysret_signal:
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY),%edx
 	jz    1f
 
@@ -294,7 +324,7 @@ sysret_signal:
 1:	movl $_TIF_NEED_RESCHED,%edi
 	/* Use IRET because user could have changed frame. This
 	   works because ptregscall_common has called FIXUP_TOP_OF_STACK. */
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp int_with_check
 	
@@ -326,7 +356,7 @@ tracesys:
  */
 	.globl int_ret_from_sys_call
 int_ret_from_sys_call:
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl $3,CS-ARGOFFSET(%rsp)
 	je retint_restore_args
@@ -347,20 +377,20 @@ int_careful:
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
@@ -383,7 +413,7 @@ int_signal:
 1:	movl $_TIF_NEED_RESCHED,%edi	
 int_restore_rest:
 	RESTORE_REST
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp int_with_check
 	CFI_ENDPROC
@@ -504,7 +534,7 @@ END(stub_rt_sigreturn)
 	CFI_DEF_CFA_REGISTER	rbp
 	testl $3,CS(%rdi)
 	je 1f
-	swapgs	
+	SWAPGS
 	/* irqcount is used to check if a CPU is already on an interrupt
 	   stack or not. While this is essentially redundant with preempt_count
 	   it is a little cheaper to use a separate counter in the PDA
@@ -525,7 +555,7 @@ ENTRY(common_interrupt)
 	interrupt do_IRQ
 	/* 0(%rsp): oldrsp-ARGOFFSET */
 ret_from_intr:
-	cli	
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	decl %gs:pda_irqcount
 	leaveq
@@ -552,13 +582,13 @@ retint_swapgs:
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
@@ -566,10 +596,15 @@ retint_restore_args:
 restore_args:
 	RESTORE_ARGS 0,8,0						
 iret_label:	
+#ifdef CONFIG_PARAVIRT
+	INTERRUPT_RETURN
+#endif
+.globl do_iretq;
+do_iretq:
 	iretq
 
 	.section __ex_table,"a"
-	.quad iret_label,bad_iret	
+	.quad do_iretq, bad_iret
 	.previous
 	.section .fixup,"ax"
 	/* force a signal here? this matches i386 behaviour */
@@ -577,24 +612,24 @@ iret_label:
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
 	
@@ -602,14 +637,14 @@ retint_signal:
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
@@ -727,7 +762,7 @@ END(spurious_interrupt)
 	rdmsr
 	testl %edx,%edx
 	js    1f
-	swapgs
+	SWAPGS
 	xorl  %ebx,%ebx
 1:
 	.if \ist
@@ -743,7 +778,7 @@ END(spurious_interrupt)
 	.if \ist
 	addq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
 	.endif
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	.if \irqtrace
 	TRACE_IRQS_OFF
 	.endif
@@ -772,10 +807,10 @@ paranoid_swapgs\trace:
 	.if \trace
 	TRACE_IRQS_IRETQ 0
 	.endif
-	swapgs
+	SWAPGS_UNSAFE_STACK
 paranoid_restore\trace:
 	RESTORE_ALL 8
-	iretq
+	INTERRUPT_RETURN
 paranoid_userspace\trace:
 	GET_THREAD_INFO(%rcx)
 	movl threadinfo_flags(%rcx),%ebx
@@ -790,11 +825,11 @@ paranoid_userspace\trace:
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
@@ -803,9 +838,9 @@ paranoid_schedule\trace:
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
@@ -858,7 +893,7 @@ KPROBE_ENTRY(error_entry)
 	testl $3,CS(%rsp)
 	je  error_kernelspace
 error_swapgs:	
-	swapgs
+	SWAPGS
 error_sti:	
 	movq %rdi,RDI(%rsp) 	
 	CFI_REL_OFFSET	rdi,RDI
@@ -870,7 +905,7 @@ error_sti:
 error_exit:		
 	movl %ebx,%eax		
 	RESTORE_REST
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	GET_THREAD_INFO(%rcx)	
 	testl %eax,%eax
@@ -883,7 +918,7 @@ error_exit:
 	 * The iret might restore flags:
 	 */
 	TRACE_IRQS_IRETQ
-	swapgs 
+	SWAPGS
 	RESTORE_ARGS 0,8,0						
 	jmp iret_label
 	CFI_ENDPROC
@@ -912,12 +947,12 @@ ENTRY(load_gs_index)
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
@@ -931,7 +966,7 @@ ENDPROC(load_gs_index)
         .section .fixup,"ax"
 	/* running with kernelgs */
 bad_gs: 
-	swapgs			/* switch back to user gs */
+	SWAPGS			/* switch back to user gs */
 	xorl %eax,%eax
         movl %eax,%gs
         jmp  2b
@@ -1072,6 +1107,15 @@ KPROBE_ENTRY(int3)
  	CFI_ENDPROC
 KPROBE_END(int3)
 
+#ifdef CONFIG_PARAVIRT
+.globl native_syscall_return;
+native_syscall_return:
+	movq	%gs:pda_oldrsp,%rsp
+	swapgs
+	sysretq
+
+#endif /* CONFIG_PARAVIRT */
+
 ENTRY(overflow)
 	zeroentry do_overflow
 END(overflow)
-- 
1.4.4.2


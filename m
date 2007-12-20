Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbXLTULf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbXLTULf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758704AbXLTUKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:10:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758474AbXLTUKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:10:53 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 10/15] replace privileged instructions with paravirt macros
Date: Thu, 20 Dec 2007 18:04:05 -0200
Message-Id: <11981813292926-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981813192341-git-send-email-gcosta@redhat.com>
References: <11981810504172-git-send-email-gcosta@redhat.com> <11981811293763-git-send-email-gcosta@redhat.com> <11981811852758-git-send-email-gcosta@redhat.com> <11981812041672-git-send-email-gcosta@redhat.com> <1198181215625-git-send-email-gcosta@redhat.com> <1198181224677-git-send-email-gcosta@redhat.com> <11981812412879-git-send-email-gcosta@redhat.com> <11981812771615-git-send-email-gcosta@redhat.com> <1198181309285-git-send-email-gcosta@redhat.com> <11981813192341-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The assembly code in entry_64.S issues a bunch of privileged instructions,
like cli, sti, swapgs, and others. Paravirt guests are forbidden to do so,
and we then replace them with macros that will do the right thing.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/entry_64.S |  101 +++++++++++++++++++++++++------------------
 1 files changed, 59 insertions(+), 42 deletions(-)

Index: linux-2.6-x86/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/entry_64.S	2007-12-20 19:06:59.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/entry_64.S	2007-12-20 19:08:08.000000000 -0800
@@ -50,6 +50,7 @@
 #include <asm/hw_irq.h>
 #include <asm/page.h>
 #include <asm/irqflags.h>
+#include <asm/paravirt.h>
 
 	.code64
 
@@ -57,6 +58,13 @@
 #define retint_kernel retint_restore_args
 #endif	
 
+#ifdef CONFIG_PARAVIRT
+ENTRY(native_irq_enable_syscall_ret)
+	movq	%gs:pda_oldrsp,%rsp
+	swapgs
+	sysretq
+#endif /* CONFIG_PARAVIRT */
+
 
 .macro TRACE_IRQS_IRETQ offset=ARGOFFSET
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -216,14 +224,21 @@
 	CFI_DEF_CFA	rsp,PDA_STACKOFFSET
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
-	swapgs
+	SWAPGS_UNSAFE_STACK
+	/*
+	 * A hypervisor implementation might want to use a label
+	 * after the swapgs, so that it can do the swapgs
+	 * for the guest and jump here on syscall.
+	 */
+ENTRY(system_call_after_swapgs)
+
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
@@ -246,7 +261,7 @@
 sysret_check:		
 	LOCKDEP_SYS_EXIT
 	GET_THREAD_INFO(%rcx)
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	movl threadinfo_flags(%rcx),%edx
 	andl %edi,%edx
@@ -260,9 +275,7 @@
 	CFI_REGISTER	rip,rcx
 	RESTORE_ARGS 0,-ARG_SKIP,1
 	/*CFI_REGISTER	rflags,r11*/
-	movq	%gs:pda_oldrsp,%rsp
-	swapgs
-	sysretq
+	ENABLE_INTERRUPTS_SYSCALL_RET
 
 	CFI_RESTORE_STATE
 	/* Handle reschedules */
@@ -271,7 +284,7 @@
 	bt $TIF_NEED_RESCHED,%edx
 	jnc sysret_signal
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq %rdi
 	CFI_ADJUST_CFA_OFFSET 8
 	call schedule
@@ -282,7 +295,7 @@
 	/* Handle a signal */ 
 sysret_signal:
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY),%edx
 	jz    1f
 
@@ -295,7 +308,7 @@
 1:	movl $_TIF_NEED_RESCHED,%edi
 	/* Use IRET because user could have changed frame. This
 	   works because ptregscall_common has called FIXUP_TOP_OF_STACK. */
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp int_with_check
 	
@@ -327,7 +340,7 @@
  */
 	.globl int_ret_from_sys_call
 int_ret_from_sys_call:
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl $3,CS-ARGOFFSET(%rsp)
 	je retint_restore_args
@@ -349,20 +362,20 @@
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
@@ -385,7 +398,7 @@
 1:	movl $_TIF_NEED_RESCHED,%edi	
 int_restore_rest:
 	RESTORE_REST
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp int_with_check
 	CFI_ENDPROC
@@ -506,7 +519,7 @@
 	CFI_DEF_CFA_REGISTER	rbp
 	testl $3,CS(%rdi)
 	je 1f
-	swapgs	
+	SWAPGS
 	/* irqcount is used to check if a CPU is already on an interrupt
 	   stack or not. While this is essentially redundant with preempt_count
 	   it is a little cheaper to use a separate counter in the PDA
@@ -527,7 +540,7 @@
 	interrupt do_IRQ
 	/* 0(%rsp): oldrsp-ARGOFFSET */
 ret_from_intr:
-	cli	
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	decl %gs:pda_irqcount
 	leaveq
@@ -556,13 +569,13 @@
 	/*
 	 * The iretq could re-enable interrupts:
 	 */
-	cli
+	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_IRETQ
-	swapgs 
+	SWAPGS
 	jmp restore_args
 
 retint_restore_args:	/* return to kernel space */
-	cli
+	DISABLE_INTERRUPTS(CLBR_ANY)
 	/*
 	 * The iretq could re-enable interrupts:
 	 */
@@ -570,10 +583,14 @@
 restore_args:
 	RESTORE_ARGS 0,8,0						
 iret_label:	
+#ifdef CONFIG_PARAVIRT
+	INTERRUPT_RETURN
+#endif
+ENTRY(native_iret)
 	iretq
 
 	.section __ex_table,"a"
-	.quad iret_label,bad_iret	
+	.quad native_iret, bad_iret
 	.previous
 	.section .fixup,"ax"
 	/* force a signal here? this matches i386 behaviour */
@@ -581,24 +598,24 @@
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
 	
@@ -606,14 +623,14 @@
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
@@ -731,7 +748,7 @@
 	rdmsr
 	testl %edx,%edx
 	js    1f
-	swapgs
+	SWAPGS
 	xorl  %ebx,%ebx
 1:
 	.if \ist
@@ -747,7 +764,7 @@
 	.if \ist
 	addq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
 	.endif
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	.if \irqtrace
 	TRACE_IRQS_OFF
 	.endif
@@ -776,10 +793,10 @@
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
@@ -794,11 +811,11 @@
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
@@ -807,9 +824,9 @@
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
@@ -862,7 +879,7 @@
 	testl $3,CS(%rsp)
 	je  error_kernelspace
 error_swapgs:	
-	swapgs
+	SWAPGS
 error_sti:	
 	movq %rdi,RDI(%rsp) 	
 	CFI_REL_OFFSET	rdi,RDI
@@ -874,7 +891,7 @@
 error_exit:
 	movl %ebx,%eax
 	RESTORE_REST
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	GET_THREAD_INFO(%rcx)	
 	testl %eax,%eax
@@ -911,12 +928,12 @@
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
@@ -930,7 +947,7 @@
         .section .fixup,"ax"
 	/* running with kernelgs */
 bad_gs: 
-	swapgs			/* switch back to user gs */
+	SWAPGS			/* switch back to user gs */
 	xorl %eax,%eax
         movl %eax,%gs
         jmp  2b

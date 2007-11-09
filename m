Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbXKIV3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbXKIV3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757150AbXKIV2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:28:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062AbXKIV2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:28:46 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 10/24] paravirt hooks at entry functions.
Date: Fri,  9 Nov 2007 16:42:51 -0200
Message-Id: <11946338413283-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11946338361369-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <11946338212915-git-send-email-gcosta@redhat.com> <11946338263902-git-send-email-gcosta@redhat.com> <1194633831882-git-send-email-gcosta@redhat.com> <11946338361369-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Those are the hooks needed for paravirt at entry_64.S
In general, they follow the way of i386.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/entry_64.S |  108 +++++++++++++++++++++++++++-----------------
 1 files changed, 66 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3a058bb..b6d7008 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -50,6 +50,7 @@
 #include <asm/hw_irq.h>
 #include <asm/page.h>
 #include <asm/irqflags.h>
+#include <asm/paravirt.h>
 
 	.code64
 
@@ -57,6 +58,20 @@
 #define retint_kernel retint_restore_args
 #endif	
 
+#ifdef CONFIG_PARAVIRT
+ENTRY(native_irq_enable_syscall_ret)
+	movq	%gs:pda_oldrsp,%rsp
+	swapgs
+	sysretq
+/* 
+ * This could well be defined as a C function, but as it is only used here,
+ * let it be locally defined
+ */
+ENTRY(native_swapgs)
+	swapgs
+	retq
+#endif /* CONFIG_PARAVIRT */
+
 
 .macro TRACE_IRQS_IRETQ offset=ARGOFFSET
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -216,14 +231,21 @@ ENTRY(system_call)
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
@@ -246,7 +268,7 @@ ret_from_sys_call:
 sysret_check:		
 	LOCKDEP_SYS_EXIT
 	GET_THREAD_INFO(%rcx)
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	movl threadinfo_flags(%rcx),%edx
 	andl %edi,%edx
@@ -260,9 +282,7 @@ sysret_check:
 	CFI_REGISTER	rip,rcx
 	RESTORE_ARGS 0,-ARG_SKIP,1
 	/*CFI_REGISTER	rflags,r11*/
-	movq	%gs:pda_oldrsp,%rsp
-	swapgs
-	sysretq
+	ENABLE_INTERRUPTS_SYSCALL_RET
 
 	CFI_RESTORE_STATE
 	/* Handle reschedules */
@@ -271,7 +291,7 @@ sysret_careful:
 	bt $TIF_NEED_RESCHED,%edx
 	jnc sysret_signal
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq %rdi
 	CFI_ADJUST_CFA_OFFSET 8
 	call schedule
@@ -282,7 +302,7 @@ sysret_careful:
 	/* Handle a signal */ 
 sysret_signal:
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY),%edx
 	jz    1f
 
@@ -295,7 +315,7 @@ sysret_signal:
 1:	movl $_TIF_NEED_RESCHED,%edi
 	/* Use IRET because user could have changed frame. This
 	   works because ptregscall_common has called FIXUP_TOP_OF_STACK. */
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp int_with_check
 	
@@ -327,7 +347,7 @@ tracesys:
  */
 	.globl int_ret_from_sys_call
 int_ret_from_sys_call:
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl $3,CS-ARGOFFSET(%rsp)
 	je retint_restore_args
@@ -349,20 +369,20 @@ int_careful:
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
@@ -385,7 +405,7 @@ int_signal:
 1:	movl $_TIF_NEED_RESCHED,%edi	
 int_restore_rest:
 	RESTORE_REST
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp int_with_check
 	CFI_ENDPROC
@@ -506,7 +526,7 @@ END(stub_rt_sigreturn)
 	CFI_DEF_CFA_REGISTER	rbp
 	testl $3,CS(%rdi)
 	je 1f
-	swapgs	
+	SWAPGS
 	/* irqcount is used to check if a CPU is already on an interrupt
 	   stack or not. While this is essentially redundant with preempt_count
 	   it is a little cheaper to use a separate counter in the PDA
@@ -527,7 +547,7 @@ ENTRY(common_interrupt)
 	interrupt do_IRQ
 	/* 0(%rsp): oldrsp-ARGOFFSET */
 ret_from_intr:
-	cli	
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	decl %gs:pda_irqcount
 	leaveq
@@ -556,13 +576,13 @@ retint_swapgs:		/* return to user-space */
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
@@ -570,10 +590,14 @@ retint_restore_args:	/* return to kernel space */
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
@@ -581,24 +605,24 @@ iret_label:
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
 	
@@ -606,14 +630,14 @@ retint_signal:
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
@@ -731,7 +755,7 @@ END(spurious_interrupt)
 	rdmsr
 	testl %edx,%edx
 	js    1f
-	swapgs
+	SWAPGS
 	xorl  %ebx,%ebx
 1:
 	.if \ist
@@ -747,7 +771,7 @@ END(spurious_interrupt)
 	.if \ist
 	addq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
 	.endif
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	.if \irqtrace
 	TRACE_IRQS_OFF
 	.endif
@@ -776,10 +800,10 @@ paranoid_swapgs\trace:
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
@@ -794,11 +818,11 @@ paranoid_userspace\trace:
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
@@ -807,9 +831,9 @@ paranoid_schedule\trace:
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
@@ -862,7 +886,7 @@ KPROBE_ENTRY(error_entry)
 	testl $3,CS(%rsp)
 	je  error_kernelspace
 error_swapgs:	
-	swapgs
+	SWAPGS
 error_sti:	
 	movq %rdi,RDI(%rsp) 	
 	CFI_REL_OFFSET	rdi,RDI
@@ -874,7 +898,7 @@ error_sti:
 error_exit:
 	movl %ebx,%eax
 	RESTORE_REST
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	GET_THREAD_INFO(%rcx)	
 	testl %eax,%eax
@@ -911,12 +935,12 @@ ENTRY(load_gs_index)
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
@@ -930,7 +954,7 @@ ENDPROC(load_gs_index)
         .section .fixup,"ax"
 	/* running with kernelgs */
 bad_gs: 
-	swapgs			/* switch back to user gs */
+	SWAPGS			/* switch back to user gs */
 	xorl %eax,%eax
         movl %eax,%gs
         jmp  2b
-- 
1.4.4.2


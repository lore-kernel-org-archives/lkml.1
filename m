Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbZETXTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbZETXTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbZETXS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:18:29 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34309 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756412AbZETXSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:18:12 -0400
X-Sasl-enc: /eVTvyt0Kz1AMrJE3j3z8CwDt0jE5MVv0ej1fJUSxnHZ 1242861492
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] i386, entry_32: get rid of sysenter_audit and sysexit_audit defines
Date: Thu, 21 May 2009 01:18:00 +0200
Message-Id: <1242861486-7255-3-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
References: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_AUDITSYSCALL=n, sysenter_audit and sysexit_audit are
defines for other labels. Remove this by introducing sysenter_trace
and sysexit_trace labels which are always present and move the
audit entry code there.

No functional change intended.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_32.S |   88 +++++++++++++++++++++-----------------------
 1 files changed, 42 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 314563e..3b63eba 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -60,11 +60,6 @@
 #define AUDIT_ARCH_I386		(EM_386|__AUDIT_ARCH_LE)
 #define __AUDIT_ARCH_LE	   0x40000000
 
-#ifndef CONFIG_AUDITSYSCALL
-#define sysenter_audit	syscall_trace_entry
-#define sysexit_audit	syscall_exit_work
-#endif
-
 /*
  * We use macros for low-level operations which need to be overridden
  * for paravirtualization.  The following will never clobber any registers:
@@ -437,7 +432,7 @@ sysenter_past_esp:
 	GET_THREAD_INFO(%ebp)
 
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%ebp)
-	jnz sysenter_audit
+	jnz sysenter_trace
 sysenter_do_call:
 	cmpl $(nr_syscalls), %eax
 	jae syscall_badsys
@@ -448,7 +443,7 @@ sysenter_do_call:
 	TRACE_IRQS_OFF
 	movl TI_flags(%ebp), %ecx
 	testl $_TIF_ALLWORK_MASK, %ecx
-	jne sysexit_audit
+	jne sysexit_trace
 sysenter_exit:
 /* if something modifies registers it must also disable sysexit */
 	movl PT_EIP(%esp), %edx
@@ -458,45 +453,6 @@ sysenter_exit:
 1:	mov  PT_FS(%esp), %fs
 	PTGS_TO_GS
 	ENABLE_INTERRUPTS_SYSEXIT
-
-#ifdef CONFIG_AUDITSYSCALL
-sysenter_audit:
-	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
-	jnz syscall_trace_entry
-	addl $4,%esp
-	CFI_ADJUST_CFA_OFFSET -4
-	/* %esi already in 8(%esp)	   6th arg: 4th syscall arg */
-	/* %edx already in 4(%esp)	   5th arg: 3rd syscall arg */
-	/* %ecx already in 0(%esp)	   4th arg: 2nd syscall arg */
-	movl %ebx,%ecx			/* 3rd arg: 1st syscall arg */
-	movl %eax,%edx			/* 2nd arg: syscall number */
-	movl $AUDIT_ARCH_I386,%eax	/* 1st arg: audit arch */
-	call audit_syscall_entry
-	pushl %ebx
-	CFI_ADJUST_CFA_OFFSET 4
-	movl PT_EAX(%esp),%eax		/* reload syscall number */
-	jmp sysenter_do_call
-
-sysexit_audit:
-	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %ecx
-	jne syscall_exit_work
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_ANY)
-	movl %eax,%edx		/* second arg, syscall return value */
-	cmpl $0,%eax		/* is it < 0? */
-	setl %al		/* 1 if so, 0 if not */
-	movzbl %al,%eax		/* zero-extend that */
-	inc %eax /* first arg, 0->1(AUDITSC_SUCCESS), 1->2(AUDITSC_FAILURE) */
-	call audit_syscall_exit
-	DISABLE_INTERRUPTS(CLBR_ANY)
-	TRACE_IRQS_OFF
-	movl TI_flags(%ebp), %ecx
-	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %ecx
-	jne syscall_exit_work
-	movl PT_EAX(%esp),%eax	/* reload syscall return value */
-	jmp sysenter_exit
-#endif
-
 	CFI_ENDPROC
 .pushsection .fixup,"ax"
 2:	movl $0,PT_FS(%esp)
@@ -650,6 +606,25 @@ END(work_pending)
 
 	# perform syscall exit tracing
 	ALIGN
+sysenter_trace:
+#ifdef CONFIG_AUDITSYSCALL
+	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
+	jnz syscall_trace_entry
+	addl $4,%esp
+	CFI_ADJUST_CFA_OFFSET -4
+	/* %esi already in 8(%esp)	   6th arg: 4th syscall arg */
+	/* %edx already in 4(%esp)	   5th arg: 3rd syscall arg */
+	/* %ecx already in 0(%esp)	   4th arg: 2nd syscall arg */
+	movl %ebx,%ecx			/* 3rd arg: 1st syscall arg */
+	movl %eax,%edx			/* 2nd arg: syscall number */
+	movl $AUDIT_ARCH_I386,%eax	/* 1st arg: audit arch */
+	call audit_syscall_entry
+	pushl %ebx
+	CFI_ADJUST_CFA_OFFSET 4
+	movl PT_EAX(%esp),%eax		/* reload syscall number */
+	jmp sysenter_do_call
+	ALIGN
+#endif
 syscall_trace_entry:
 	movl $-ENOSYS,PT_EAX(%esp)
 	movl %esp, %eax
@@ -662,6 +637,27 @@ END(syscall_trace_entry)
 
 	# perform syscall exit tracing
 	ALIGN
+sysexit_trace:
+#ifdef CONFIG_AUDITSYSCALL
+	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %ecx
+	jne syscall_exit_work
+	TRACE_IRQS_ON
+	ENABLE_INTERRUPTS(CLBR_ANY)
+	movl %eax,%edx		/* second arg, syscall return value */
+	cmpl $0,%eax		/* is it < 0? */
+	setl %al		/* 1 if so, 0 if not */
+	movzbl %al,%eax		/* zero-extend that */
+	inc %eax /* first arg, 0->1(AUDITSC_SUCCESS), 1->2(AUDITSC_FAILURE) */
+	call audit_syscall_exit
+	DISABLE_INTERRUPTS(CLBR_ANY)
+	TRACE_IRQS_OFF
+	movl TI_flags(%ebp), %ecx
+	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %ecx
+	jne syscall_exit_work
+	movl PT_EAX(%esp),%eax	/* reload syscall return value */
+	jmp sysenter_exit
+	ALIGN
+#endif
 syscall_exit_work:
 	testl $_TIF_WORK_SYSCALL_EXIT, %ecx
 	jz work_pending
-- 
1.6.0.4


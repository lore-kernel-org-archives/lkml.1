Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbZCOU0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbZCOU0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758256AbZCOUZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:25:45 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58948 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001AbZCOUZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:25:44 -0400
Message-Id: <20090315200507.548635272@polymtl.ca>
References: <20090315200144.017321577@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 16:02:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC patch 18/20] LTTng Linux Kernel Trace Thread Flag x86
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-x86.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 20:24:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Make x86 support TIF_SYSCALL_TRACE async flag set in entry_32.S/entry_64.S.

x86_64 :

When the flag is inactive upon syscall entry and concurrently activated before
exit, we seem to reach a state where the top of stack is incorrect upon return
to user space.

Fix this by fixing the top of stack and jumping to int_ret_from_sys_call if we
detect that thread flags has been modified.

We make sure that the thread flag read is coherent between our new test and the ALLWORK_MASK test by first saving it in a register used for both comparisons.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <ak@muc.de>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/thread_info.h |    9 ++++++---
 arch/x86/kernel/entry_32.S         |    3 ++-
 arch/x86/kernel/entry_64.S         |   12 ++++++++++++
 3 files changed, 20 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/arch/x86/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/thread_info.h	2009-03-15 15:51:26.000000000 -0400
+++ linux-2.6-lttng/arch/x86/include/asm/thread_info.h	2009-03-15 15:57:19.000000000 -0400
@@ -81,6 +81,7 @@ struct thread_info {
 #define TIF_SYSCALL_EMU		6	/* syscall emulation active */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
+#define TIF_KERNEL_TRACE	9	/* kernel trace active */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
@@ -103,6 +104,7 @@ struct thread_info {
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
@@ -117,17 +119,18 @@ struct thread_info {
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
-	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | \
+	(_TIF_SYSCALL_TRACE | _TIF_KERNEL_TRACE | _TIF_SYSCALL_EMU | \
 	 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | _TIF_SINGLESTEP)
 
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	\
-	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP)
+	(_TIF_SYSCALL_TRACE | _TIF_KERNEL_TRACE | _TIF_SYSCALL_AUDIT | \
+	 _TIF_SINGLESTEP)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
 	(0x0000FFFF &							\
-	 ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|			\
+	 ~(_TIF_SYSCALL_TRACE|_TIF_KERNEL_TRACE|_TIF_SYSCALL_AUDIT|	\
 	   _TIF_SINGLESTEP|_TIF_SECCOMP|_TIF_SYSCALL_EMU))
 
 /* work to do on any return to user space */
Index: linux-2.6-lttng/arch/x86/kernel/entry_32.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/entry_32.S	2009-03-15 15:51:26.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/entry_32.S	2009-03-15 15:57:19.000000000 -0400
@@ -571,7 +571,8 @@ END(syscall_trace_entry)
 	# perform syscall exit tracing
 	ALIGN
 syscall_exit_work:
-	testb $_TIF_WORK_SYSCALL_EXIT, %cl
+	/* Note, _TIF_KERNEL_TRACE is bit number 9, and so it needs testw and not testb */
+	testw $_TIF_WORK_SYSCALL_EXIT, %cx
 	jz work_pending
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_ANY)	# could let syscall_trace_leave() call
Index: linux-2.6-lttng/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/entry_64.S	2009-03-15 15:51:19.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/entry_64.S	2009-03-15 15:57:19.000000000 -0400
@@ -530,6 +530,8 @@ sysret_check:
 	/* Handle reschedules */
 	/* edx:	work, edi: workmask */
 sysret_careful:
+	testl $_TIF_KERNEL_TRACE,%edx	/* Re-read : concurrently changed */
+	jnz ret_from_sys_call_trace
 	bt $TIF_NEED_RESCHED,%edx
 	jnc sysret_signal
 	TRACE_IRQS_ON
@@ -541,6 +543,16 @@ sysret_careful:
 	CFI_ADJUST_CFA_OFFSET -8
 	jmp sysret_check
 
+ret_from_sys_call_trace:
+	TRACE_IRQS_ON
+	sti
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %rdi
+	movq %rsp,%rdi
+	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+
 	/* Handle a signal */
 sysret_signal:
 	TRACE_IRQS_ON

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

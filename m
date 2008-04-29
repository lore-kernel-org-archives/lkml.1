Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbYD2B4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbYD2B4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbYD2BxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:53:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56028 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752371AbYD2BxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:53:03 -0400
Message-Id: <20080429015301.902656145@sgi.com>
References: <20080429015231.908196699@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 18:52:38 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Subject: [patch 7/9] x86: thread_info: Merget TIF_ flags.
Content-Disposition: inline; filename=merge_tif_flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both TIF lists are essentially the same. x86_32 also has TIF_SYSCALL_EMU which
must be undefined for the 64 bit case.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/thread_info.h |  162 +++++++++++++++---------------------------
 1 file changed, 61 insertions(+), 101 deletions(-)

Index: linux-2.6/include/asm-x86/thread_info.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info.h	2008-04-28 17:54:20.149889589 -0700
+++ linux-2.6/include/asm-x86/thread_info.h	2008-04-28 17:57:21.724529078 -0700
@@ -62,6 +62,67 @@ struct thread_info {
 
 #endif
 
+/*
+ * thread information flags
+ * - these are process state flags that various assembly files
+ *   may need to access
+ * - pending work-to-be-done flags are in LSW
+ * - other flags in MSW
+ * Warning: layout of LSW is hardcoded in entry.S
+ */
+#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_SIGPENDING		2	/* signal pending */
+#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_SINGLESTEP		4	/* reenable singlestep on user return*/
+#define TIF_IRET		5	/* force IRET */
+#ifdef CONFIG_X86_32
+#define TIF_SYSCALL_EMU		6	/* syscall emulation active */
+#endif
+#define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
+#define TIF_SECCOMP		8	/* secure computing */
+#define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
+#define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
+#define TIF_HRTICK_RESCHED	11	/* reprogram hrtick timer */
+#define TIF_NOTSC		16	/* TSC is not accessible in userland */
+#define TIF_IA32		17	/* 32bit process */
+#define TIF_FORK		18	/* ret_from_fork */
+#define TIF_ABI_PENDING		19
+#define TIF_MEMDIE		20
+#define TIF_DEBUG		21	/* uses debug registers */
+#define TIF_IO_BITMAP		22	/* uses I/O bitmap */
+#define TIF_FREEZE		23	/* is freezing for suspend */
+#define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
+#define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
+#define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
+#define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */
+
+#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
+#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
+#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
+#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_IRET		(1 << TIF_IRET)
+#ifdef CONFIG_X86_32
+#define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
+#else
+#define _TIF_SYSCALL_EMU	0
+#endif
+#define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
+#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
+#define _TIF_HRTICK_RESCHED	(1 << TIF_HRTICK_RESCHED)
+#define _TIF_NOTSC		(1 << TIF_NOTSC)
+#define _TIF_IA32		(1 << TIF_IA32)
+#define _TIF_FORK		(1 << TIF_FORK)
+#define _TIF_ABI_PENDING	(1 << TIF_ABI_PENDING)
+#define _TIF_DEBUG		(1 << TIF_DEBUG)
+#define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
+#define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
+#define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
+#define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
+#define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
+
 #define PREEMPT_ACTIVE		0x10000000
 
 #ifdef CONFIG_X86_32
@@ -113,53 +174,6 @@ static inline struct thread_info *curren
 
 #endif
 
-/*
- * thread information flags
- * - these are process state flags that various
- *   assembly files may need to access
- * - pending work-to-be-done flags are in LSW
- * - other flags in MSW
- */
-#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_SIGPENDING		1	/* signal pending */
-#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-#define TIF_SINGLESTEP		3	/* restore singlestep on return to
-					   user mode */
-#define TIF_IRET		4	/* return with iret */
-#define TIF_SYSCALL_EMU		5	/* syscall emulation active */
-#define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
-#define TIF_SECCOMP		7	/* secure computing */
-#define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal() */
-#define TIF_HRTICK_RESCHED	9	/* reprogram hrtick timer */
-#define TIF_MEMDIE		16
-#define TIF_DEBUG		17	/* uses debug registers */
-#define TIF_IO_BITMAP		18	/* uses I/O bitmap */
-#define TIF_FREEZE		19	/* is freezing for suspend */
-#define TIF_NOTSC		20	/* TSC is not accessible in userland */
-#define TIF_FORCED_TF		21	/* true if TF in eflags artificially */
-#define TIF_DEBUGCTLMSR		22	/* uses thread_struct.debugctlmsr */
-#define TIF_DS_AREA_MSR 	23      /* uses thread_struct.ds_area_msr */
-#define TIF_BTS_TRACE_TS        24      /* record scheduling event timestamps */
-
-#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
-#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
-#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
-#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
-#define _TIF_IRET		(1 << TIF_IRET)
-#define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
-#define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
-#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
-#define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
-#define _TIF_HRTICK_RESCHED	(1 << TIF_HRTICK_RESCHED)
-#define _TIF_DEBUG		(1 << TIF_DEBUG)
-#define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
-#define _TIF_NOTSC		(1 << TIF_NOTSC)
-#define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
-#define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
-#define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
-#define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
-
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
 	(0x0000FFFF & ~(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT |	\
@@ -217,60 +231,6 @@ static inline struct thread_info *stack_
 
 #endif
 
-/*
- * thread information flags
- * - these are process state flags that various assembly files
- *   may need to access
- * - pending work-to-be-done flags are in LSW
- * - other flags in MSW
- * Warning: layout of LSW is hardcoded in entry.S
- */
-#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_SINGLESTEP		4	/* reenable singlestep on user return*/
-#define TIF_IRET		5	/* force IRET */
-#define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
-#define TIF_SECCOMP		8	/* secure computing */
-#define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
-#define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
-#define TIF_HRTICK_RESCHED	11	/* reprogram hrtick timer */
-/* 16 free */
-#define TIF_IA32		17	/* 32bit process */
-#define TIF_FORK		18	/* ret_from_fork */
-#define TIF_ABI_PENDING		19
-#define TIF_MEMDIE		20
-#define TIF_DEBUG		21	/* uses debug registers */
-#define TIF_IO_BITMAP		22	/* uses I/O bitmap */
-#define TIF_FREEZE		23	/* is freezing for suspend */
-#define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
-#define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
-#define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
-#define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */
-#define TIF_NOTSC		28	/* TSC is not accessible in userland */
-
-#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
-#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
-#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
-#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
-#define _TIF_IRET		(1 << TIF_IRET)
-#define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
-#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
-#define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
-#define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
-#define _TIF_HRTICK_RESCHED	(1 << TIF_HRTICK_RESCHED)
-#define _TIF_IA32		(1 << TIF_IA32)
-#define _TIF_FORK		(1 << TIF_FORK)
-#define _TIF_ABI_PENDING	(1 << TIF_ABI_PENDING)
-#define _TIF_DEBUG		(1 << TIF_DEBUG)
-#define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
-#define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
-#define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
-#define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
-#define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
-#define _TIF_NOTSC		(1 << TIF_NOTSC)
-
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
 	(0x0000FFFF &							\

-- 

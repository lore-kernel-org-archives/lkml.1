Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbZCOUax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbZCOUax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbZCOU0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:26:05 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58967 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758758AbZCOUZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:25:57 -0400
Message-Id: <20090315200505.978971021@polymtl.ca>
References: <20090315200144.017321577@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 16:01:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC patch 08/20] LTTng Kernel Trace Thread Flag ia64
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-ia64.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 20:24:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

FIXME : Masami reported that enabling the KERNEL_TRACE thread flag did disable
the gate page for gettimeofday, falling back on a standard system call. More
work would be needed in this area and I don't have the architecture available.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/ia64/include/asm/thread_info.h |   10 +++++++---
 arch/ia64/kernel/entry.S            |    6 ++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/arch/ia64/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/include/asm/thread_info.h	2009-03-15 15:57:05.000000000 -0400
+++ linux-2.6-lttng/arch/ia64/include/asm/thread_info.h	2009-03-15 15:57:15.000000000 -0400
@@ -100,6 +100,7 @@ struct thread_info {
 #define TIF_SYSCALL_TRACE	2	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	3	/* syscall auditing active */
 #define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
+#define TIF_KERNEL_TRACE	5	/* kernel trace active */
 #define TIF_NOTIFY_RESUME	6	/* resumption notification requested */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
@@ -111,7 +112,9 @@ struct thread_info {
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
-#define _TIF_SYSCALL_TRACEAUDIT	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP)
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
+#define _TIF_SYSCALL_TRACEAUDIT	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|\
+	_TIF_SINGLESTEP|_TIF_KERNEL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
@@ -124,8 +127,9 @@ struct thread_info {
 /* "work to do on user-return" bits */
 #define TIF_ALLWORK_MASK	(_TIF_SIGPENDING|_TIF_NOTIFY_RESUME|_TIF_SYSCALL_AUDIT|\
 				 _TIF_NEED_RESCHED|_TIF_SYSCALL_TRACE)
-/* like TIF_ALLWORK_BITS but sans TIF_SYSCALL_TRACE or TIF_SYSCALL_AUDIT */
-#define TIF_WORK_MASK		(TIF_ALLWORK_MASK&~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT))
+/* like TIF_ALLWORK_BITS but sans TIF_SYSCALL_TRACE, TIF_KERNEL_TRACE or TIF_SYSCALL_AUDIT */
+#define TIF_WORK_MASK		(TIF_ALLWORK_MASK&~(_TIF_SYSCALL_TRACE|_TIF_KERNEL_TRACE|\
+					_TIF_SYSCALL_AUDIT))
 
 #define TS_POLLING		1 	/* true if in idle loop and not sleeping */
 #define TS_RESTORE_SIGMASK	2	/* restore signal mask in do_signal() */
Index: linux-2.6-lttng/arch/ia64/kernel/entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/kernel/entry.S	2009-03-15 15:57:05.000000000 -0400
+++ linux-2.6-lttng/arch/ia64/kernel/entry.S	2009-03-15 15:57:15.000000000 -0400
@@ -634,9 +634,11 @@ GLOBAL_ENTRY(ia64_ret_from_clone)
 	;;
 	ld4 r2=[r2]
 	;;
+	movl r8=_TIF_SYSCALL_TRACEAUDIT
+	;;					// added stop bits to prevent r8 dependency
+	and r2=r8,r2
 	mov r8=0
-	and r2=_TIF_SYSCALL_TRACEAUDIT,r2
-	;;
+	;;					// added stop bits to prevent r2 dependency
 	cmp.ne p6,p0=r2,r0
 (p6)	br.cond.spnt .strace_check_retval
 	;;					// added stop bits to prevent r8 dependency

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

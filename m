Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbXLFCss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbXLFCss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbXLFCo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:44:56 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51362 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbXLFCow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:44:52 -0500
Message-Id: <20071206024432.098095544@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:42:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 09/26] LTTng Kernel Trace Thread Flag ia64
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-ia64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/ia64/kernel/entry.S       |    6 ++++--
 include/asm-ia64/thread_info.h |   13 +++++++++----
 2 files changed, 13 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/include/asm-ia64/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-ia64/thread_info.h	2007-11-20 10:43:04.000000000 -0500
+++ linux-2.6-lttng/include/asm-ia64/thread_info.h	2007-11-20 10:43:28.000000000 -0500
@@ -86,6 +86,7 @@
 #define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_PERFMON_WORK	6	/* work for pfm_handle_work() */
+#define TIF_KERNEL_TRACE	7	/* kernel trace active */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
 #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
@@ -95,7 +96,8 @@
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
-#define _TIF_SYSCALL_TRACEAUDIT	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP)
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
+#define _TIF_SYSCALL_TRACEAUDIT	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP|_TIF_KERNEL_TRACE)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_PERFMON_WORK	(1 << TIF_PERFMON_WORK)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -108,9 +110,12 @@
 /* "work to do on user-return" bits */
 #define TIF_ALLWORK_MASK	(_TIF_SIGPENDING|_TIF_PERFMON_WORK|_TIF_SYSCALL_AUDIT|\
 				 _TIF_NEED_RESCHED| _TIF_SYSCALL_TRACE|\
-				 _TIF_RESTORE_SIGMASK)
-/* like TIF_ALLWORK_BITS but sans TIF_SYSCALL_TRACE or TIF_SYSCALL_AUDIT */
-#define TIF_WORK_MASK		(TIF_ALLWORK_MASK&~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT))
+				 _TIF_RESTORE_SIGMASK|_TIF_KERNEL_TRACE)
+/*
+ * like TIF_ALLWORK_BITS but sans TIF_SYSCALL_TRACE, TIF_KERNEL_TRACE
+ * or TIF_SYSCALL_AUDIT
+ */
+#define TIF_WORK_MASK		(TIF_ALLWORK_MASK&~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE))
 
 #define TS_POLLING		1 	/* true if in idle loop and not sleeping */
 
Index: linux-2.6-lttng/arch/ia64/kernel/entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/kernel/entry.S	2007-11-20 10:43:04.000000000 -0500
+++ linux-2.6-lttng/arch/ia64/kernel/entry.S	2007-11-20 10:50:48.000000000 -0500
@@ -621,9 +621,11 @@
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
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

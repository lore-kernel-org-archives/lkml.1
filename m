Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbZEIQv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbZEIQv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbZEIQtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:49:13 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54452 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060AbZEIQtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:49:10 -0400
Message-Id: <20090509162350.786461346@polymtl.ca>
References: <20090509162209.217414024@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 09 May 2009 12:22:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, roland@redhat.com,
       mbligh@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 16/20] LTTng Kernel Trace Thread Flag sparc
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-sparc.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat,  9 May 2009 16:47:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Folded lttng-kernel-trace-thread-flag-sparc64.patch.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/sparc/include/asm/thread_info_32.h |    2 ++
 arch/sparc/include/asm/thread_info_64.h |    3 ++-
 arch/sparc/kernel/entry.S               |    8 ++++----
 3 files changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/arch/sparc/include/asm/thread_info_32.h
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/include/asm/thread_info_32.h	2009-03-15 15:57:04.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/include/asm/thread_info_32.h	2009-03-15 15:57:18.000000000 -0400
@@ -130,6 +130,7 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_RESTORE_SIGMASK	4	/* restore signal mask in do_signal() */
+#define TIF_KERNEL_TRACE	5	/* kernel trace active */
 #define TIF_USEDFPU		8	/* FPU was used by this task
 					 * this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling
@@ -139,6 +140,7 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
Index: linux-2.6-lttng/arch/sparc/kernel/entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/kernel/entry.S	2009-03-15 15:57:04.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/kernel/entry.S	2009-03-15 15:57:18.000000000 -0400
@@ -1118,7 +1118,7 @@ sys_sigreturn:
 	 add	%sp, STACKFRAME_SZ, %o0
 
 	ld	[%curptr + TI_FLAGS], %l5
-	andcc	%l5, _TIF_SYSCALL_TRACE, %g0
+	andcc	%l5, (_TIF_SYSCALL_TRACE|_TIF_KERNEL_TRACE), %g0
 	be	1f
 	 nop
 
@@ -1138,7 +1138,7 @@ sys_rt_sigreturn:
 	 add	%sp, STACKFRAME_SZ, %o0
 
 	ld	[%curptr + TI_FLAGS], %l5
-	andcc	%l5, _TIF_SYSCALL_TRACE, %g0
+	andcc	%l5, (_TIF_SYSCALL_TRACE|_TIF_KERNEL_TRACE), %g0
 	be	1f
 	 nop
 
@@ -1280,7 +1280,7 @@ syscall_is_too_hard:
 
 	ld	[%curptr + TI_FLAGS], %l5
 	mov	%i3, %o3
-	andcc	%l5, _TIF_SYSCALL_TRACE, %g0
+	andcc	%l5, (_TIF_SYSCALL_TRACE|_TIF_KERNEL_TRACE), %g0
 	mov	%i4, %o4
 	bne	linux_syscall_trace
 	 mov	%i0, %l5
@@ -1297,7 +1297,7 @@ ret_sys_call:
 	ld	[%sp + STACKFRAME_SZ + PT_PSR], %g3
 	set	PSR_C, %g2
 	bgeu	1f
-	 andcc	%l6, _TIF_SYSCALL_TRACE, %g0
+	 andcc	%l6, (_TIF_SYSCALL_TRACE|_TIF_KERNEL_TRACE), %g0
 
 	/* System call success, clear Carry condition code. */
 	andn	%g3, %g2, %g3
Index: linux-2.6-lttng/arch/sparc/include/asm/thread_info_64.h
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/include/asm/thread_info_64.h	2009-03-15 15:57:04.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/include/asm/thread_info_64.h	2009-03-15 15:57:18.000000000 -0400
@@ -226,7 +226,7 @@ register struct thread_info *current_thr
 #define TIF_UNALIGNED		5	/* allowed to do unaligned accesses */
 /* flag bit 6 is available */
 #define TIF_32BIT		7	/* 32-bit binary */
-/* flag bit 8 is available */
+#define TIF_KERNEL_TRACE	8	/* kernel trace active */
 #define TIF_SECCOMP		9	/* secure computing */
 #define TIF_SYSCALL_AUDIT	10	/* syscall auditing active */
 /* flag bit 11 is available */
@@ -246,6 +246,7 @@ register struct thread_info *current_thr
 #define _TIF_PERFCTR		(1<<TIF_PERFCTR)
 #define _TIF_UNALIGNED		(1<<TIF_UNALIGNED)
 #define _TIF_32BIT		(1<<TIF_32BIT)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbZEIQvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbZEIQvj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbZEIQtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:49:12 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54451 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057AbZEIQtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:49:10 -0400
Message-Id: <20090509162348.527546872@polymtl.ca>
References: <20090509162209.217414024@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 09 May 2009 12:22:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, roland@redhat.com,
       mbligh@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 02/20] LTTng Kernel Trace Thread Flag ARM
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-arm.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat,  9 May 2009 16:47:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

folded omap-arm-fix-syscall-exit-trace-flag.patch.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/arm/include/asm/thread_info.h |    3 +++
 arch/arm/kernel/entry-common.S     |    2 ++
 2 files changed, 5 insertions(+)

Index: linux-2.6-lttng/arch/arm/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/arm/include/asm/thread_info.h	2009-04-23 14:56:15.000000000 -0400
+++ linux-2.6-lttng/arch/arm/include/asm/thread_info.h	2009-04-23 14:56:23.000000000 -0400
@@ -128,6 +128,7 @@ extern void vfp_sync_state(struct thread
 /*
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
+ *  TIF_KERNEL_TRACE	- kernel trace active
  *  TIF_SIGPENDING	- signal pending
  *  TIF_NEED_RESCHED	- rescheduling necessary
  *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
@@ -135,6 +136,7 @@ extern void vfp_sync_state(struct thread
  */
 #define TIF_SIGPENDING		0
 #define TIF_NEED_RESCHED	1
+#define TIF_KERNEL_TRACE	7
 #define TIF_SYSCALL_TRACE	8
 #define TIF_POLLING_NRFLAG	16
 #define TIF_USING_IWMMXT	17
@@ -143,6 +145,7 @@ extern void vfp_sync_state(struct thread
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
Index: linux-2.6-lttng/arch/arm/kernel/entry-common.S
===================================================================
--- linux-2.6-lttng.orig/arch/arm/kernel/entry-common.S	2009-04-23 14:56:15.000000000 -0400
+++ linux-2.6-lttng/arch/arm/kernel/entry-common.S	2009-04-23 14:56:23.000000000 -0400
@@ -47,6 +47,8 @@ ret_fast_syscall:
  * Ok, we need to do extra processing, enter the slow path.
  */
 fast_work_pending:
+	tst	r1, #_TIF_KERNEL_TRACE		@ flag can be set asynchronously
+	bne	__sys_trace_return
 	str	r0, [sp, #S_R0+S_OFF]!		@ returned r0
 work_pending:
 	tst	r1, #_TIF_NEED_RESCHED

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZEIQxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZEIQxu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbZEIQus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:50:48 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54586 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706AbZEIQuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:50:46 -0400
Message-Id: <20090509162350.007933690@polymtl.ca>
References: <20090509162209.217414024@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 09 May 2009 12:22:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, roland@redhat.com,
       mbligh@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 11/20] LTTng Kernel Trace Thread Flag MIPS
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-mips.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat,  9 May 2009 16:47:19 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/mips/include/asm/thread_info.h |    4 +++-
 arch/mips/kernel/entry.S            |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/mips/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/mips/include/asm/thread_info.h	2009-03-23 22:40:31.000000000 -0400
+++ linux-2.6-lttng/arch/mips/include/asm/thread_info.h	2009-03-23 22:41:55.000000000 -0400
@@ -125,6 +125,7 @@ register struct thread_info *__current_t
 #define TIF_32BIT_ADDR		23	/* 32-bit address space (o32/n32) */
 #define TIF_FPUBOUND		24	/* thread bound to FPU-full CPU set */
 #define TIF_LOAD_WATCH		25	/* If set, load watch registers */
+#define TIF_KERNEL_TRACE	30	/* kernel trace active */
 #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
 
 #ifdef CONFIG_MIPS32_O32
@@ -134,6 +135,7 @@ register struct thread_info *__current_t
 #endif /* CONFIG_MIPS32_O32 */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
@@ -152,7 +154,7 @@ register struct thread_info *__current_t
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(0x0000ffef & ~_TIF_SECCOMP)
 /* work to do on any return to u-space */
-#define _TIF_ALLWORK_MASK	(0x8000ffff & ~_TIF_SECCOMP)
+#define _TIF_ALLWORK_MASK	(0xc000ffff & ~_TIF_SECCOMP)
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6-lttng/arch/mips/kernel/entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/mips/kernel/entry.S	2009-03-23 22:38:01.000000000 -0400
+++ linux-2.6-lttng/arch/mips/kernel/entry.S	2009-03-23 22:40:40.000000000 -0400
@@ -167,7 +167,7 @@ work_notifysig:				# deal with pending s
 FEXPORT(syscall_exit_work_partial)
 	SAVE_STATIC
 syscall_exit_work:
-	li	t0, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
+	li	t0, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_KERNEL_TRACE
 	and	t0, a2			# a2 is preloaded with TI_FLAGS
 	beqz	t0, work_pending	# trace bit set?
 	local_irq_enable		# could let do_syscall_trace()

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

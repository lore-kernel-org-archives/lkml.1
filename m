Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbZCOU1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbZCOU1J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758001AbZCOUZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:25:48 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58956 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758150AbZCOUZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:25:47 -0400
Message-Id: <20090315200506.443782058@polymtl.ca>
References: <20090315200144.017321577@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 16:01:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 11/20] LTTng Kernel Trace Thread Flag MIPS
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-mips.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 20:24:30 +0000
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
--- linux-2.6-lttng.orig/arch/mips/include/asm/thread_info.h	2009-03-15 15:57:05.000000000 -0400
+++ linux-2.6-lttng/arch/mips/include/asm/thread_info.h	2009-03-15 15:57:16.000000000 -0400
@@ -125,9 +125,11 @@ register struct thread_info *__current_t
 #define TIF_32BIT_ADDR		23	/* 32-bit address space (o32/n32) */
 #define TIF_FPUBOUND		24	/* thread bound to FPU-full CPU set */
 #define TIF_LOAD_WATCH		25	/* If set, load watch registers */
+#define TIF_KERNEL_TRACE	30	/* kernel trace active */
 #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
@@ -146,7 +148,7 @@ register struct thread_info *__current_t
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(0x0000ffef & ~_TIF_SECCOMP)
 /* work to do on any return to u-space */
-#define _TIF_ALLWORK_MASK	(0x8000ffff & ~_TIF_SECCOMP)
+#define _TIF_ALLWORK_MASK	(0xc000ffff & ~_TIF_SECCOMP)
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6-lttng/arch/mips/kernel/entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/mips/kernel/entry.S	2009-03-15 15:57:05.000000000 -0400
+++ linux-2.6-lttng/arch/mips/kernel/entry.S	2009-03-15 15:57:16.000000000 -0400
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

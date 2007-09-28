Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbXI1IBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbXI1IBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbXI1IBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:01:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbXI1IBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:01:22 -0400
Message-Id: <20070928080041.408922000@chello.nl>
References: <20070928074200.436463000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 28 Sep 2007 09:42:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/12] lockdep: x86_64: connect the sysexit hook
Content-Disposition: inline; filename=lockdep-x86_64-sys_exit.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Run the lockdep_sys_exit hook after all other C code on the syscall
return path.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86_64/kernel/entry.S    |    3 +++
 arch/x86_64/lib/thunk.S       |    4 ++++
 include/asm-x86_64/irqflags.h |    9 +++++++++
 3 files changed, 16 insertions(+)

Index: linux-2.6/arch/x86_64/kernel/entry.S
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/entry.S
+++ linux-2.6/arch/x86_64/kernel/entry.S
@@ -164,6 +164,7 @@ ENTRY(ret_from_fork)
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),threadinfo_flags(%rcx)
 	jnz rff_trace
 rff_action:	
+	LOCKDEP_SYS_EXIT
 	RESTORE_REST
 	testl $3,CS-ARGOFFSET(%rsp)	# from kernel_thread?
 	je   int_ret_from_sys_call
@@ -326,6 +327,7 @@ tracesys:			 
  */
 	.globl int_ret_from_sys_call
 int_ret_from_sys_call:
+	LOCKDEP_SYS_EXIT_REST
 	cli
 	TRACE_IRQS_OFF
 	testl $3,CS-ARGOFFSET(%rsp)
@@ -382,6 +384,7 @@ int_signal:
 	call do_notify_resume
 1:	movl $_TIF_NEED_RESCHED,%edi	
 int_restore_rest:
+	LOCKDEP_SYS_EXIT
 	RESTORE_REST
 	cli
 	TRACE_IRQS_OFF
Index: linux-2.6/arch/x86_64/lib/thunk.S
===================================================================
--- linux-2.6.orig/arch/x86_64/lib/thunk.S
+++ linux-2.6/arch/x86_64/lib/thunk.S
@@ -50,6 +50,10 @@
 	thunk trace_hardirqs_on_thunk,trace_hardirqs_on
 	thunk trace_hardirqs_off_thunk,trace_hardirqs_off
 #endif
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	thunk lockdep_sys_exit_thunk,lockdep_sys_exit
+#endif
 	
 	/* SAVE_ARGS below is used only for the .cfi directives it contains. */
 	CFI_STARTPROC
Index: linux-2.6/include/asm-x86_64/irqflags.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/irqflags.h
+++ linux-2.6/include/asm-x86_64/irqflags.h
@@ -137,6 +137,15 @@ static inline void halt(void)
 #  define TRACE_IRQS_ON
 #  define TRACE_IRQS_OFF
 # endif
+# ifdef CONFIG_DEBUG_LOCK_ALLOC
+#  define LOCKDEP_SYS_EXIT	call lockdep_sys_exit_thunk
+#  define LOCKDEP_SYS_EXIT_REST	SAVE_REST; \
+				LOCKDEP_SYS_EXIT; \
+				RESTORE_REST;
+# else
+#  define LOCKDEP_SYS_EXIT
+#  define LOCKDEP_SYS_EXIT_REST
+# endif
 #endif
 
 #endif

--


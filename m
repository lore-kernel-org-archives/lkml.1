Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZBFGzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZBFGzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZBFGyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:54:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64173 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZBFGyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:54:39 -0500
Message-Id: <20090206065438.217847858@goodmis.org>
References: <20090206065352.940088243@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Feb 2009 01:53:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/4] ftrace: change function graph tracer to use new in_nmi
Content-Disposition: inline; filename=0003-ftrace-change-function-graph-tracer-to-use-new-in_n.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function graph tracer piggy backed onto the dynamic ftracer
to use the in_nmi custom code for dynamic tracing. The problem
was (as Andrew Morton pointed out) it really only wanted to bail
out if the context of the current CPU was in NMI context. But the
dynamic ftrace in_nmi custom code was true if _any_ CPU happened
to be in NMI context.

Now that we have a generic in_nmi interface, this patch changes
the function graph code to use it instead of the dynamic ftarce
custom code.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/Kconfig         |    2 +-
 arch/x86/kernel/ftrace.c |   21 +--------------------
 2 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3da7121..0f47315 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -34,7 +34,7 @@ config X86
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE || FUNCTION_GRAPH_TRACER
+	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index e3fad2e..918073c 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -367,25 +367,6 @@ int ftrace_disable_ftrace_graph_caller(void)
 	return ftrace_mod_jmp(ip, old_offset, new_offset);
 }
 
-#else /* CONFIG_DYNAMIC_FTRACE */
-
-/*
- * These functions are picked from those used on
- * this page for dynamic ftrace. They have been
- * simplified to ignore all traces in NMI context.
- */
-static atomic_t nmi_running;
-
-void arch_ftrace_nmi_enter(void)
-{
-	atomic_inc(&nmi_running);
-}
-
-void arch_ftrace_nmi_exit(void)
-{
-	atomic_dec(&nmi_running);
-}
-
 #endif /* !CONFIG_DYNAMIC_FTRACE */
 
 /* Add a function return address to the trace stack on thread info.*/
@@ -475,7 +456,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 				&return_to_handler;
 
 	/* Nmi's are currently unsupported */
-	if (unlikely(atomic_read(&nmi_running)))
+	if (unlikely(in_nmi()))
 		return;
 
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
-- 
1.5.6.5

-- 

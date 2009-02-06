Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZBFP3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZBFP3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbZBFP10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:27:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35486 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbZBFP1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:27:22 -0500
Message-Id: <20090206152721.626610729@goodmis.org>
References: <20090206152151.962749733@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Feb 2009 10:21:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 6/7] ring-buffer: use generic version of in_nmi
Content-Disposition: inline; filename=0006-ring-buffer-use-generic-version-of-in_nmi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

Now that a generic in_nmi is available, this patch removes the
special code in the ring_buffer and implements the in_nmi generic
version instead.

With this change, I was also able to rename the "arch_ftrace_nmi_enter"
back to "ftrace_nmi_enter" and remove the code from the ring buffer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c   |    4 ++--
 include/linux/ftrace_irq.h |    8 --------
 kernel/trace/ring_buffer.c |   43 +++++++++++++------------------------------
 3 files changed, 15 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 918073c..d74d75e 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -113,7 +113,7 @@ static void ftrace_mod_code(void)
 					     MCOUNT_INSN_SIZE);
 }
 
-void arch_ftrace_nmi_enter(void)
+void ftrace_nmi_enter(void)
 {
 	atomic_inc(&nmi_running);
 	/* Must have nmi_running seen before reading write flag */
@@ -124,7 +124,7 @@ void arch_ftrace_nmi_enter(void)
 	}
 }
 
-void arch_ftrace_nmi_exit(void)
+void ftrace_nmi_exit(void)
 {
 	/* Finish all executions before clearing nmi_running */
 	smp_wmb();
diff --git a/include/linux/ftrace_irq.h b/include/linux/ftrace_irq.h
index 29de677..dca7bf8 100644
--- a/include/linux/ftrace_irq.h
+++ b/include/linux/ftrace_irq.h
@@ -3,14 +3,6 @@
 
 
 #ifdef CONFIG_FTRACE_NMI_ENTER
-extern void arch_ftrace_nmi_enter(void);
-extern void arch_ftrace_nmi_exit(void);
-#else
-static inline void arch_ftrace_nmi_enter(void) { }
-static inline void arch_ftrace_nmi_exit(void) { }
-#endif
-
-#ifdef CONFIG_RING_BUFFER
 extern void ftrace_nmi_enter(void);
 extern void ftrace_nmi_exit(void);
 #else
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a60a6a8..5ee3444 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -8,6 +8,7 @@
 #include <linux/spinlock.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
+#include <linux/hardirq.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/mutex.h>
@@ -20,35 +21,6 @@
 #include "trace.h"
 
 /*
- * Since the write to the buffer is still not fully lockless,
- * we must be careful with NMIs. The locks in the writers
- * are taken when a write crosses to a new page. The locks
- * protect against races with the readers (this will soon
- * be fixed with a lockless solution).
- *
- * Because we can not protect against NMIs, and we want to
- * keep traces reentrant, we need to manage what happens
- * when we are in an NMI.
- */
-static DEFINE_PER_CPU(int, rb_in_nmi);
-
-void ftrace_nmi_enter(void)
-{
-	__get_cpu_var(rb_in_nmi)++;
-	/* call arch specific handler too */
-	arch_ftrace_nmi_enter();
-}
-
-void ftrace_nmi_exit(void)
-{
-	arch_ftrace_nmi_exit();
-	__get_cpu_var(rb_in_nmi)--;
-	/* NMIs are not recursive */
-	WARN_ON_ONCE(__get_cpu_var(rb_in_nmi));
-}
-
-
-/*
  * A fast way to enable or disable all ring buffers is to
  * call tracing_on or tracing_off. Turning off the ring buffers
  * prevents all ring buffers from being recorded to.
@@ -1027,12 +999,23 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 
 		local_irq_save(flags);
 		/*
+		 * Since the write to the buffer is still not
+		 * fully lockless, we must be careful with NMIs.
+		 * The locks in the writers are taken when a write
+		 * crosses to a new page. The locks protect against
+		 * races with the readers (this will soon be fixed
+		 * with a lockless solution).
+		 *
+		 * Because we can not protect against NMIs, and we
+		 * want to keep traces reentrant, we need to manage
+		 * what happens when we are in an NMI.
+		 *
 		 * NMIs can happen after we take the lock.
 		 * If we are in an NMI, only take the lock
 		 * if it is not already taken. Otherwise
 		 * simply fail.
 		 */
-		if (unlikely(__get_cpu_var(rb_in_nmi))) {
+		if (unlikely(in_nmi())) {
 			if (!__raw_spin_trylock(&cpu_buffer->lock))
 				goto out_unlock;
 		} else
-- 
1.5.6.5

-- 

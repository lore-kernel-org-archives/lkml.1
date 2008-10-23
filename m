Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYJWNjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYJWNjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYJWNh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:37:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54322 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbYJWNhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:37:25 -0400
Message-Id: <20081023133723.627335983@goodmis.org>
References: <20081023133256.926296694@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Oct 2008 09:33:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 06/12 v3] ftrace: only have ftrace_kill atomic
Content-Disposition: inline; filename=ftrace-only-kill-atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an anomaly is detected, we need a way to completely disable
ftrace. Right now we have two functions: ftrace_kill and ftrace_kill_atomic.
The ftrace_kill tries to do it in a "nice" way by converting everything
back to a nop.

The "nice" way is dangerous itself, so this patch removes it and only
has the "atomic" version, which is all that is needed.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    3 +--
 kernel/trace/ftrace.c  |   42 ++----------------------------------------
 kernel/trace/trace.c   |    2 +-
 3 files changed, 4 insertions(+), 43 deletions(-)

Index: linux-compile.git/include/linux/ftrace.h
===================================================================
--- linux-compile.git.orig/include/linux/ftrace.h	2008-10-22 15:57:31.000000000 -0400
+++ linux-compile.git/include/linux/ftrace.h	2008-10-22 15:58:35.000000000 -0400
@@ -40,7 +40,7 @@ extern void ftrace_stub(unsigned long a0
 # define register_ftrace_function(ops) do { } while (0)
 # define unregister_ftrace_function(ops) do { } while (0)
 # define clear_ftrace_function(ops) do { } while (0)
-static inline void ftrace_kill_atomic(void) { }
+static inline void ftrace_kill(void) { }
 #endif /* CONFIG_FTRACE */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -117,7 +117,6 @@ static inline void ftrace_release(void *
 
 /* totally disable ftrace - can not re-enable after this */
 void ftrace_kill(void);
-void ftrace_kill_atomic(void);
 
 static inline void tracer_disable(void)
 {
Index: linux-compile.git/kernel/trace/ftrace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/ftrace.c	2008-10-22 15:49:49.000000000 -0400
+++ linux-compile.git/kernel/trace/ftrace.c	2008-10-22 15:58:35.000000000 -0400
@@ -1544,22 +1544,6 @@ int ftrace_force_update(void)
 	return ret;
 }
 
-static void ftrace_force_shutdown(void)
-{
-	struct task_struct *task;
-	int command = FTRACE_DISABLE_CALLS | FTRACE_UPDATE_TRACE_FUNC;
-
-	mutex_lock(&ftraced_lock);
-	task = ftraced_task;
-	ftraced_task = NULL;
-	ftraced_suspend = -1;
-	ftrace_run_update_code(command);
-	mutex_unlock(&ftraced_lock);
-
-	if (task)
-		kthread_stop(task);
-}
-
 static __init int ftrace_init_debugfs(void)
 {
 	struct dentry *d_tracer;
@@ -1752,17 +1736,16 @@ core_initcall(ftrace_dynamic_init);
 # define ftrace_shutdown()		do { } while (0)
 # define ftrace_startup_sysctl()	do { } while (0)
 # define ftrace_shutdown_sysctl()	do { } while (0)
-# define ftrace_force_shutdown()	do { } while (0)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 /**
- * ftrace_kill_atomic - kill ftrace from critical sections
+ * ftrace_kill - kill ftrace
  *
  * This function should be used by panic code. It stops ftrace
  * but in a not so nice way. If you need to simply kill ftrace
  * from a non-atomic section, use ftrace_kill.
  */
-void ftrace_kill_atomic(void)
+void ftrace_kill(void)
 {
 	ftrace_disabled = 1;
 	ftrace_enabled = 0;
@@ -1773,27 +1756,6 @@ void ftrace_kill_atomic(void)
 }
 
 /**
- * ftrace_kill - totally shutdown ftrace
- *
- * This is a safety measure. If something was detected that seems
- * wrong, calling this function will keep ftrace from doing
- * any more modifications, and updates.
- * used when something went wrong.
- */
-void ftrace_kill(void)
-{
-	mutex_lock(&ftrace_sysctl_lock);
-	ftrace_disabled = 1;
-	ftrace_enabled = 0;
-
-	clear_ftrace_function();
-	mutex_unlock(&ftrace_sysctl_lock);
-
-	/* Try to totally disable ftrace */
-	ftrace_force_shutdown();
-}
-
-/**
  * register_ftrace_function - register a function for profiling
  * @ops - ops structure that holds the function for profiling.
  *
Index: linux-compile.git/kernel/trace/trace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace.c	2008-10-22 15:09:04.000000000 -0400
+++ linux-compile.git/kernel/trace/trace.c	2008-10-22 15:58:35.000000000 -0400
@@ -3097,7 +3097,7 @@ void ftrace_dump(void)
 	dump_ran = 1;
 
 	/* No turning back! */
-	ftrace_kill_atomic();
+	ftrace_kill();
 
 	for_each_tracing_cpu(cpu) {
 		atomic_inc(&global_trace.data[cpu]->disabled);

-- 

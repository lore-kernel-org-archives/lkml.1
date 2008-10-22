Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbYJVSxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbYJVSxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbYJVSvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:51:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53638 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970AbYJVSvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:51:38 -0400
Message-Id: <20081022185136.312667539@goodmis.org>
References: <20081022184313.179487464@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 14:43:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 05/11] ftrace: only have ftrace_kill atomic
Content-Disposition: inline; filename=ftrace-only-kill-atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only have a way to completely disable ftrace in atomic sections.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    3 +--
 kernel/trace/ftrace.c  |   43 ++-----------------------------------------
 kernel/trace/trace.c   |    2 +-
 3 files changed, 4 insertions(+), 44 deletions(-)

Index: linux-compile.git/include/linux/ftrace.h
===================================================================
--- linux-compile.git.orig/include/linux/ftrace.h	2008-10-22 13:17:26.000000000 -0400
+++ linux-compile.git/include/linux/ftrace.h	2008-10-22 13:17:29.000000000 -0400
@@ -40,7 +40,7 @@ extern void ftrace_stub(unsigned long a0
 # define register_ftrace_function(ops) do { } while (0)
 # define unregister_ftrace_function(ops) do { } while (0)
 # define clear_ftrace_function(ops) do { } while (0)
-static inline void ftrace_kill_atomic(void) { }
+static inline void ftrace_kill(void) { }
 #endif /* CONFIG_FTRACE */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -97,7 +97,6 @@ static inline void ftrace_release(void *
 
 /* totally disable ftrace - can not re-enable after this */
 void ftrace_kill(void);
-void ftrace_kill_atomic(void);
 
 static inline void tracer_disable(void)
 {
Index: linux-compile.git/kernel/trace/ftrace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/ftrace.c	2008-10-22 13:17:26.000000000 -0400
+++ linux-compile.git/kernel/trace/ftrace.c	2008-10-22 13:17:29.000000000 -0400
@@ -606,7 +606,6 @@ ftrace_code_disable(struct dyn_ftrace *r
 		print_ip_ins(" expected: ", call);
 		print_ip_ins(" replace: ", nop);
 		printk(KERN_CONT "\n");
-		break;
 
 		rec->flags |= FTRACE_FL_FAILED;
 		return 0;
@@ -1526,22 +1525,6 @@ int ftrace_force_update(void)
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
@@ -1734,17 +1717,16 @@ core_initcall(ftrace_dynamic_init);
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
@@ -1755,27 +1737,6 @@ void ftrace_kill_atomic(void)
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
--- linux-compile.git.orig/kernel/trace/trace.c	2008-10-22 13:17:26.000000000 -0400
+++ linux-compile.git/kernel/trace/trace.c	2008-10-22 13:17:29.000000000 -0400
@@ -3097,7 +3097,7 @@ void ftrace_dump(void)
 	dump_ran = 1;
 
 	/* No turning back! */
-	ftrace_kill_atomic();
+	ftrace_kill();
 
 	for_each_tracing_cpu(cpu) {
 		atomic_inc(&global_trace.data[cpu]->disabled);

-- 

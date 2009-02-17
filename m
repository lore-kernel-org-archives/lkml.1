Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbZBQFRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbZBQFRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZBQFOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42035 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbZBQFOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:09 -0500
Message-Id: <20090217051406.806356506@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 09/15] ftrace: consolidate mutexes
Content-Disposition: inline; filename=0009-ftrace-consolidate-mutexes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

Now that ftrace_lock is a mutex, there is no reason to have three
different mutexes protecting similar data. All the mutex paths
are not in hot paths, so having a mutex to cover more data is
not a problem.

This patch removes the ftrace_sysctl_lock and ftrace_start_lock
and uses the ftrace_lock to protect the locations that were protected
by these locks. By doing so, this change also removes some of
the lock nesting that was taking place.

There are still more mutexes in ftrace.c that can probably be
consolidated, but they can be dealt with later. We need to be careful
about the way the locks are nested, and by consolidating, we can cause
a recursive deadlock.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   68 +++++++++++++++---------------------------------
 1 files changed, 21 insertions(+), 47 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4771732..157d4f6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -62,8 +62,6 @@ int function_trace_stop;
 static int ftrace_disabled __read_mostly;
 
 static DEFINE_MUTEX(ftrace_lock);
-static DEFINE_MUTEX(ftrace_sysctl_lock);
-static DEFINE_MUTEX(ftrace_start_lock);
 
 static struct ftrace_ops ftrace_list_end __read_mostly =
 {
@@ -134,8 +132,6 @@ static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip)
 
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
-	mutex_lock(&ftrace_lock);
-
 	ops->next = ftrace_list;
 	/*
 	 * We are entering ops into the ftrace_list but another
@@ -171,17 +167,12 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 #endif
 	}
 
-	mutex_unlock(&ftrace_lock);
-
 	return 0;
 }
 
 static int __unregister_ftrace_function(struct ftrace_ops *ops)
 {
 	struct ftrace_ops **p;
-	int ret = 0;
-
-	mutex_lock(&ftrace_lock);
 
 	/*
 	 * If we are removing the last function, then simply point
@@ -190,17 +181,15 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	if (ftrace_list == ops && ops->next == &ftrace_list_end) {
 		ftrace_trace_function = ftrace_stub;
 		ftrace_list = &ftrace_list_end;
-		goto out;
+		return 0;
 	}
 
 	for (p = &ftrace_list; *p != &ftrace_list_end; p = &(*p)->next)
 		if (*p == ops)
 			break;
 
-	if (*p != ops) {
-		ret = -1;
-		goto out;
-	}
+	if (*p != ops)
+		return -1;
 
 	*p = (*p)->next;
 
@@ -221,10 +210,7 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 		}
 	}
 
- out:
-	mutex_unlock(&ftrace_lock);
-
-	return ret;
+	return 0;
 }
 
 static void ftrace_update_pid_func(void)
@@ -622,13 +608,10 @@ static void ftrace_startup(int command)
 	if (unlikely(ftrace_disabled))
 		return;
 
-	mutex_lock(&ftrace_start_lock);
 	ftrace_start_up++;
 	command |= FTRACE_ENABLE_CALLS;
 
 	ftrace_startup_enable(command);
-
-	mutex_unlock(&ftrace_start_lock);
 }
 
 static void ftrace_shutdown(int command)
@@ -636,7 +619,6 @@ static void ftrace_shutdown(int command)
 	if (unlikely(ftrace_disabled))
 		return;
 
-	mutex_lock(&ftrace_start_lock);
 	ftrace_start_up--;
 	if (!ftrace_start_up)
 		command |= FTRACE_DISABLE_CALLS;
@@ -647,11 +629,9 @@ static void ftrace_shutdown(int command)
 	}
 
 	if (!command || !ftrace_enabled)
-		goto out;
+		return;
 
 	ftrace_run_update_code(command);
- out:
-	mutex_unlock(&ftrace_start_lock);
 }
 
 static void ftrace_startup_sysctl(void)
@@ -661,7 +641,6 @@ static void ftrace_startup_sysctl(void)
 	if (unlikely(ftrace_disabled))
 		return;
 
-	mutex_lock(&ftrace_start_lock);
 	/* Force update next time */
 	saved_ftrace_func = NULL;
 	/* ftrace_start_up is true if we want ftrace running */
@@ -669,7 +648,6 @@ static void ftrace_startup_sysctl(void)
 		command |= FTRACE_ENABLE_CALLS;
 
 	ftrace_run_update_code(command);
-	mutex_unlock(&ftrace_start_lock);
 }
 
 static void ftrace_shutdown_sysctl(void)
@@ -679,13 +657,11 @@ static void ftrace_shutdown_sysctl(void)
 	if (unlikely(ftrace_disabled))
 		return;
 
-	mutex_lock(&ftrace_start_lock);
 	/* ftrace_start_up is true if ftrace is running */
 	if (ftrace_start_up)
 		command |= FTRACE_DISABLE_CALLS;
 
 	ftrace_run_update_code(command);
-	mutex_unlock(&ftrace_start_lock);
 }
 
 static cycle_t		ftrace_update_time;
@@ -1502,12 +1478,10 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 		ftrace_match_records(iter->buffer, iter->buffer_idx, enable);
 	}
 
-	mutex_lock(&ftrace_sysctl_lock);
-	mutex_lock(&ftrace_start_lock);
+	mutex_lock(&ftrace_lock);
 	if (ftrace_start_up && ftrace_enabled)
 		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
-	mutex_unlock(&ftrace_start_lock);
-	mutex_unlock(&ftrace_sysctl_lock);
+	mutex_unlock(&ftrace_lock);
 
 	kfree(iter);
 	mutex_unlock(&ftrace_regex_lock);
@@ -1824,7 +1798,7 @@ static int ftrace_convert_nops(struct module *mod,
 	unsigned long addr;
 	unsigned long flags;
 
-	mutex_lock(&ftrace_start_lock);
+	mutex_lock(&ftrace_lock);
 	p = start;
 	while (p < end) {
 		addr = ftrace_call_adjust(*p++);
@@ -1843,7 +1817,7 @@ static int ftrace_convert_nops(struct module *mod,
 	local_irq_save(flags);
 	ftrace_update_code(mod);
 	local_irq_restore(flags);
-	mutex_unlock(&ftrace_start_lock);
+	mutex_unlock(&ftrace_lock);
 
 	return 0;
 }
@@ -2016,7 +1990,7 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
 	if (ret < 0)
 		return ret;
 
-	mutex_lock(&ftrace_start_lock);
+	mutex_lock(&ftrace_lock);
 	if (val < 0) {
 		/* disable pid tracing */
 		if (!ftrace_pid_trace)
@@ -2055,7 +2029,7 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
 	ftrace_startup_enable(0);
 
  out:
-	mutex_unlock(&ftrace_start_lock);
+	mutex_unlock(&ftrace_lock);
 
 	return cnt;
 }
@@ -2118,12 +2092,12 @@ int register_ftrace_function(struct ftrace_ops *ops)
 	if (unlikely(ftrace_disabled))
 		return -1;
 
-	mutex_lock(&ftrace_sysctl_lock);
+	mutex_lock(&ftrace_lock);
 
 	ret = __register_ftrace_function(ops);
 	ftrace_startup(0);
 
-	mutex_unlock(&ftrace_sysctl_lock);
+	mutex_unlock(&ftrace_lock);
 	return ret;
 }
 
@@ -2137,10 +2111,10 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
 {
 	int ret;
 
-	mutex_lock(&ftrace_sysctl_lock);
+	mutex_lock(&ftrace_lock);
 	ret = __unregister_ftrace_function(ops);
 	ftrace_shutdown(0);
-	mutex_unlock(&ftrace_sysctl_lock);
+	mutex_unlock(&ftrace_lock);
 
 	return ret;
 }
@@ -2155,7 +2129,7 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
-	mutex_lock(&ftrace_sysctl_lock);
+	mutex_lock(&ftrace_lock);
 
 	ret  = proc_dointvec(table, write, file, buffer, lenp, ppos);
 
@@ -2184,7 +2158,7 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 	}
 
  out:
-	mutex_unlock(&ftrace_sysctl_lock);
+	mutex_unlock(&ftrace_lock);
 	return ret;
 }
 
@@ -2296,7 +2270,7 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 {
 	int ret = 0;
 
-	mutex_lock(&ftrace_sysctl_lock);
+	mutex_lock(&ftrace_lock);
 
 	ftrace_suspend_notifier.notifier_call = ftrace_suspend_notifier_call;
 	register_pm_notifier(&ftrace_suspend_notifier);
@@ -2314,13 +2288,13 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	ftrace_startup(FTRACE_START_FUNC_RET);
 
 out:
-	mutex_unlock(&ftrace_sysctl_lock);
+	mutex_unlock(&ftrace_lock);
 	return ret;
 }
 
 void unregister_ftrace_graph(void)
 {
-	mutex_lock(&ftrace_sysctl_lock);
+	mutex_lock(&ftrace_lock);
 
 	atomic_dec(&ftrace_graph_active);
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
@@ -2328,7 +2302,7 @@ void unregister_ftrace_graph(void)
 	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 
-	mutex_unlock(&ftrace_sysctl_lock);
+	mutex_unlock(&ftrace_lock);
 }
 
 /* Allocate a return stack for newly created task */
-- 
1.5.6.5

-- 

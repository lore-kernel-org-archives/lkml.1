Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab0CKOiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:38:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:36311 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab0CKOh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:37:59 -0500
Date: Thu, 11 Mar 2010 14:37:27 GMT
From: tip-bot for Tim Bird <tim.bird@am.sony.com>
Cc: linux-kernel@vger.kernel.org, tim.bird@am.sony.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, tim.bird@am.sony.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4B87098B.4040308@am.sony.com>
References: <4B87098B.4040308@am.sony.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] function-graph: Add tracing_thresh support to function_graph tracer
Message-ID: <tip-0e95017355dcf43031da6d0e360a748717e56df1@git.kernel.org>
Git-Commit-ID: 0e95017355dcf43031da6d0e360a748717e56df1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:37:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e95017355dcf43031da6d0e360a748717e56df1
Gitweb:     http://git.kernel.org/tip/0e95017355dcf43031da6d0e360a748717e56df1
Author:     Tim Bird <tim.bird@am.sony.com>
AuthorDate: Thu, 25 Feb 2010 15:36:43 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 5 Mar 2010 21:20:57 -0500

function-graph: Add tracing_thresh support to function_graph tracer

Add support for tracing_thresh to the function_graph tracer.  This
version of this feature isolates the checks into new entry and
return functions, to avoid adding more conditional code into the
main function_graph paths.

When the tracing_thresh is set and the function graph tracer is
enabled, only the functions that took longer than the time in
microseconds that was set in tracing_thresh are recorded. To do this
efficiently, only the function exits are recorded:

 [tracing]# echo 100 > tracing_thresh
 [tracing]# echo function_graph > current_tracer
 [tracing]# cat trace
 # tracer: function_graph
 #
 # CPU  DURATION                  FUNCTION CALLS
 # |     |   |                     |   |   |   |
  1) ! 119.214 us  |  } /* smp_apic_timer_interrupt */
  1)   <========== |
  0) ! 101.527 us  |              } /* __rcu_process_callbacks */
  0) ! 126.461 us  |            } /* rcu_process_callbacks */
  0) ! 145.111 us  |          } /* __do_softirq */
  0) ! 149.667 us  |        } /* do_softirq */
  0) ! 168.817 us  |      } /* irq_exit */
  0) ! 248.254 us  |    } /* smp_apic_timer_interrupt */

Also, add support for specifying tracing_thresh on the kernel
command line.  When used like so: "tracing_thresh=200 ftrace=function_graph"
this can be used to analyse system startup.  It is important to disable
tracing soon after boot, in order to avoid losing the trace data.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Tim Bird <tim.bird@am.sony.com>
LKML-Reference: <4B87098B.4040308@am.sony.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c                 |   20 ++++++++++++++++++--
 kernel/trace/trace.h                 |    3 ++-
 kernel/trace/trace_functions_graph.c |   25 +++++++++++++++++++++++--
 3 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6efd5cb..ababedb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -374,6 +374,21 @@ static int __init set_buf_size(char *str)
 }
 __setup("trace_buf_size=", set_buf_size);
 
+static int __init set_tracing_thresh(char *str)
+{
+	unsigned long threshhold;
+	int ret;
+
+	if (!str)
+		return 0;
+	ret = strict_strtoul(str, 0, &threshhold);
+	if (ret < 0)
+		return 0;
+	tracing_thresh = threshhold * 1000;
+	return 1;
+}
+__setup("tracing_thresh=", set_tracing_thresh);
+
 unsigned long nsecs_to_usecs(unsigned long nsecs)
 {
 	return nsecs / 1000;
@@ -579,9 +594,10 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 static arch_spinlock_t ftrace_max_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
+unsigned long __read_mostly	tracing_thresh;
+
 #ifdef CONFIG_TRACER_MAX_TRACE
 unsigned long __read_mostly	tracing_max_latency;
-unsigned long __read_mostly	tracing_thresh;
 
 /*
  * Copy the new maximum trace into the separate maximum-trace
@@ -4248,10 +4264,10 @@ static __init int tracer_init_debugfs(void)
 #ifdef CONFIG_TRACER_MAX_TRACE
 	trace_create_file("tracing_max_latency", 0644, d_tracer,
 			&tracing_max_latency, &tracing_max_lat_fops);
+#endif
 
 	trace_create_file("tracing_thresh", 0644, d_tracer,
 			&tracing_thresh, &tracing_max_lat_fops);
-#endif
 
 	trace_create_file("README", 0444, d_tracer,
 			NULL, &tracing_readme_fops);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fd05bca..1bc8cd1 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -396,9 +396,10 @@ extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
 
 extern unsigned long nsecs_to_usecs(unsigned long nsecs);
 
+extern unsigned long tracing_thresh;
+
 #ifdef CONFIG_TRACER_MAX_TRACE
 extern unsigned long tracing_max_latency;
-extern unsigned long tracing_thresh;
 
 void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu);
 void update_max_tr_single(struct trace_array *tr,
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 7b1f246..e9df04b 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -237,6 +237,14 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	return ret;
 }
 
+int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
+{
+	if (tracing_thresh)
+		return 1;
+	else
+		return trace_graph_entry(trace);
+}
+
 static void __trace_graph_return(struct trace_array *tr,
 				struct ftrace_graph_ret *trace,
 				unsigned long flags,
@@ -290,13 +298,26 @@ void set_graph_array(struct trace_array *tr)
 	smp_mb();
 }
 
+void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
+{
+	if (tracing_thresh &&
+	    (trace->rettime - trace->calltime < tracing_thresh))
+		return;
+	else
+		trace_graph_return(trace);
+}
+
 static int graph_trace_init(struct trace_array *tr)
 {
 	int ret;
 
 	set_graph_array(tr);
-	ret = register_ftrace_graph(&trace_graph_return,
-				    &trace_graph_entry);
+	if (tracing_thresh)
+		ret = register_ftrace_graph(&trace_graph_thresh_return,
+					    &trace_graph_thresh_entry);
+	else
+		ret = register_ftrace_graph(&trace_graph_return,
+					    &trace_graph_entry);
 	if (ret)
 		return ret;
 	tracing_start_cmdline_record();

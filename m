Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbZCVOUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbZCVOUm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 10:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZCVOUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 10:20:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:44894 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZCVOUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 10:20:30 -0400
Date: Sun, 22 Mar 2009 14:19:46 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237694675-23509-1-git-send-email-fweisbec@gmail.com>
References: <1237694675-23509-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/ftrace] tracing/function-graph-tracer: prevent hangs during self-tests
Message-ID: <tip-cf586b61f80229491127d3c57c06ed93c9f530d3@git.kernel.org>
Git-Commit-ID: cf586b61f80229491127d3c57c06ed93c9f530d3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 22 Mar 2009 14:19:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf586b61f80229491127d3c57c06ed93c9f530d3
Gitweb:     http://git.kernel.org/tip/cf586b61f80229491127d3c57c06ed93c9f530d3
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 22 Mar 2009 05:04:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Mar 2009 14:06:40 +0100

tracing/function-graph-tracer: prevent hangs during self-tests

Impact: detect tracing related hangs

Sometimes, with some configs, the function graph tracer can make
the timer interrupt too much slow, hanging the kernel in an endless
loop of timer interrupts servicing.

As suggested by Ingo, this patch brings a watchdog which stops the
selftest after a defined number of functions traced, definitely
disabling this tracer.

For those who want to debug the cause of the function graph trace
hang, you can pass the ftrace_dump_on_oops kernel parameter to dump
the traces after this hang detection.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1237694675-23509-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c          |   26 +++++++++++++++++++++++---
 kernel/trace/trace_selftest.c |   38 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e3dfefe..e6fac0f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4018,11 +4018,12 @@ trace_printk_seq(struct trace_seq *s)
 	trace_seq_init(s);
 }
 
-void ftrace_dump(void)
+static void __ftrace_dump(bool disable_tracing)
 {
 	static DEFINE_SPINLOCK(ftrace_dump_lock);
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
+	unsigned int old_userobj;
 	static int dump_ran;
 	unsigned long flags;
 	int cnt = 0, cpu;
@@ -4034,14 +4035,17 @@ void ftrace_dump(void)
 
 	dump_ran = 1;
 
-	/* No turning back! */
 	tracing_off();
-	ftrace_kill();
+
+	if (disable_tracing)
+		ftrace_kill();
 
 	for_each_tracing_cpu(cpu) {
 		atomic_inc(&global_trace.data[cpu]->disabled);
 	}
 
+	old_userobj = trace_flags & TRACE_ITER_SYM_USEROBJ;
+
 	/* don't look at user memory in panic mode */
 	trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
 
@@ -4086,10 +4090,26 @@ void ftrace_dump(void)
 	else
 		printk(KERN_TRACE "---------------------------------\n");
 
+	/* Re-enable tracing if requested */
+	if (!disable_tracing) {
+		trace_flags |= old_userobj;
+
+		for_each_tracing_cpu(cpu) {
+			atomic_dec(&global_trace.data[cpu]->disabled);
+		}
+		tracing_on();
+	}
+
  out:
 	spin_unlock_irqrestore(&ftrace_dump_lock, flags);
 }
 
+/* By default: disable tracing after the dump */
+void ftrace_dump(void)
+{
+	__ftrace_dump(true);
+}
+
 __init static int tracer_alloc_buffers(void)
 {
 	struct trace_array_cpu *data;
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 38856ba..b56dcf7 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -248,6 +248,28 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+/* Maximum number of functions to trace before diagnosing a hang */
+#define GRAPH_MAX_FUNC_TEST	100000000
+
+static void __ftrace_dump(bool disable_tracing);
+static unsigned int graph_hang_thresh;
+
+/* Wrap the real function entry probe to avoid possible hanging */
+static int trace_graph_entry_watchdog(struct ftrace_graph_ent *trace)
+{
+	/* This is harmlessly racy, we want to approximately detect a hang */
+	if (unlikely(++graph_hang_thresh > GRAPH_MAX_FUNC_TEST)) {
+		ftrace_graph_stop();
+		printk(KERN_WARNING "BUG: Function graph tracer hang!\n");
+		if (ftrace_dump_on_oops)
+			__ftrace_dump(false);
+		return 0;
+	}
+
+	return trace_graph_entry(trace);
+}
+
 /*
  * Pretty much the same than for the function tracer from which the selftest
  * has been borrowed.
@@ -259,15 +281,29 @@ trace_selftest_startup_function_graph(struct tracer *trace,
 	int ret;
 	unsigned long count;
 
-	ret = tracer_init(trace, tr);
+	/*
+	 * Simulate the init() callback but we attach a watchdog callback
+	 * to detect and recover from possible hangs
+	 */
+	tracing_reset_online_cpus(tr);
+	ret = register_ftrace_graph(&trace_graph_return,
+				    &trace_graph_entry_watchdog);
 	if (ret) {
 		warn_failed_init_tracer(trace, ret);
 		goto out;
 	}
+	tracing_start_cmdline_record();
 
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
 
+	/* Have we just recovered from a hang? */
+	if (graph_hang_thresh > GRAPH_MAX_FUNC_TEST) {
+		trace->reset(tr);
+		ret = -1;
+		goto out;
+	}
+
 	tracing_stop();
 
 	/* check the trace buffer */

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZBGXVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZBGXVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 18:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZBGXVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 18:21:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:21589 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbZBGXVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 18:21:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:date:to:cc:subject;
        b=E3GDz9TjbG2qkSU1ZpEObGdQ2nKelHK/u+pGJYBY/+dAuidnRStWntcbWGdJbrMVg7
         WPilufYEqUZoGI/GycIxmLH3ZsjamTXaMdn33vbXph87Bg7gCd4VEm7WvPMBSPwJUFV6
         HGjquSPYUc+CV9so+HDiJx8qbkOQGCTwvyICo=
Message-ID: <498e175a.0305560a.632d.2a9f@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sat, 7 Feb 2009 21:33:57 +0100
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] tracing/function-graph-tracer: provide a selftest for the function graph tracer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making more easy to do a basic regression test for this tracer.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.h                 |    2 +
 kernel/trace/trace_functions_graph.c |    3 ++
 kernel/trace/trace_selftest.c        |   50 ++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f2742fb..cb8a84b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -501,6 +501,8 @@ extern int DYN_FTRACE_TEST_NAME(void);
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 extern int trace_selftest_startup_function(struct tracer *trace,
 					   struct trace_array *tr);
+extern int trace_selftest_startup_function_graph(struct tracer *trace,
+						 struct trace_array *tr);
 extern int trace_selftest_startup_irqsoff(struct tracer *trace,
 					  struct trace_array *tr);
 extern int trace_selftest_startup_preemptoff(struct tracer *trace,
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 222f97d..88f8d9d 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -750,6 +750,9 @@ static struct tracer graph_trace __read_mostly = {
 	.print_line	= print_graph_function,
 	.print_header	= print_graph_headers,
 	.flags		= &tracer_flags,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest	= trace_selftest_startup_function_graph,
+#endif
 };
 
 static __init int init_graph_trace(void)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 445700e..0c9aa14 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -13,6 +13,8 @@ static inline int trace_valid_entry(struct trace_entry *entry)
 	case TRACE_PRINT:
 	case TRACE_SPECIAL:
 	case TRACE_BRANCH:
+	case TRACE_GRAPH_ENT:
+	case TRACE_GRAPH_RET:
 		return 1;
 	}
 	return 0;
@@ -227,6 +229,54 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 }
 #endif /* CONFIG_FUNCTION_TRACER */
 
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+/*
+ * Pretty much the same than for the function tracer from which the selftest
+ * has been borrowed.
+ */
+int
+trace_selftest_startup_function_graph(struct tracer *trace,
+					struct trace_array *tr)
+{
+	int ret;
+	unsigned long count;
+
+	ret = tracer_init(trace, tr);
+	if (ret) {
+		warn_failed_init_tracer(trace, ret);
+		goto out;
+	}
+
+	/* Sleep for a 1/10 of a second */
+	msleep(100);
+
+	tracing_stop();
+
+	/* check the trace buffer */
+	ret = trace_test_buffer(tr, &count);
+
+	trace->reset(tr);
+	tracing_start();
+
+	if (!ret && !count) {
+		printk(KERN_CONT ".. no entries found ..");
+		ret = -1;
+		goto out;
+	}
+
+	/* Don't test dynamic tracing, the function tracer already did */
+
+out:
+	/* Stop it if we failed */
+	if (ret)
+		ftrace_graph_stop();
+
+	return ret;
+}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+
 #ifdef CONFIG_IRQSOFF_TRACER
 int
 trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
-- 
1.6.1



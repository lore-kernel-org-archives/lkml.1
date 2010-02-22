Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0BVM50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:57:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab0BVM5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:57:24 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/4] tracing: graph output support for preemptirqsoff/preemptoff tracers
Date: Mon, 22 Feb 2010 13:57:01 +0100
Message-Id: <1266843422-18288-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1266843422-18288-1-git-send-email-jolsa@redhat.com>
References: <1266843422-18288-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

adding support for graph output for preemptirqsoff/preemptoff tracers.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_irqsoff.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index f3f43fc..15e05c9 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -58,12 +58,12 @@ irq_trace(void)
 # define irq_trace() (0)
 #endif
 
-#define TRACE_IRQSOFF_GRAPH	1
+#define TRACE_DISPLAY_GRAPH	1
 
 static struct tracer_opt trace_opts[] = {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	/* display latency trace as call graph */
-	{ TRACER_OPT(irqsoff-graph, TRACE_IRQSOFF_GRAPH) },
+	{ TRACER_OPT(display-graph, TRACE_DISPLAY_GRAPH) },
 #endif
 	{ } /* Empty entry */
 };
@@ -73,7 +73,7 @@ static struct tracer_flags tracer_flags = {
 	.opts = trace_opts,
 };
 
-#define is_graph() (tracer_flags.val & TRACE_IRQSOFF_GRAPH)
+#define is_graph() (tracer_flags.val & TRACE_DISPLAY_GRAPH)
 
 /*
  * Sequence count - we record it when starting a measurement and
@@ -133,7 +133,7 @@ static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
 {
 	int cpu;
 
-	if (!(bit & TRACE_IRQSOFF_GRAPH))
+	if (!(bit & TRACE_DISPLAY_GRAPH))
 		return -EINVAL;
 
 	if (!(is_graph() ^ set))
@@ -550,8 +550,8 @@ static struct tracer irqsoff_tracer __read_mostly =
 	.reset		= irqsoff_tracer_reset,
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
-	.flags		= &tracer_flags,
 	.print_max	= 1,
+	.flags		= &tracer_flags,
 	.set_flag	= irqsoff_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_irqsoff,
@@ -583,9 +583,15 @@ static struct tracer preemptoff_tracer __read_mostly =
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
 	.print_max	= 1,
+	.flags		= &tracer_flags,
+	.set_flag	= irqsoff_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptoff,
 #endif
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.open           = irqsoff_trace_open,
+	.close          = irqsoff_trace_close,
+#endif
 };
 # define register_preemptoff(trace) register_tracer(&trace)
 #else
@@ -611,9 +617,15 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
 	.print_max	= 1,
+	.flags		= &tracer_flags,
+	.set_flag	= irqsoff_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptirqsoff,
 #endif
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.open           = irqsoff_trace_open,
+	.close          = irqsoff_trace_close,
+#endif
 };
 
 # define register_preemptirqsoff(trace) register_tracer(&trace)
-- 
1.6.6


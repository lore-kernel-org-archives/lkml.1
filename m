Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbYKHDsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbYKHDsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbYKHDry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:47:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYKHDru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:47:50 -0500
Message-Id: <20081108034748.991813249@goodmis.org>
References: <20081108034605.289816911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 22:46:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 02/10] ftrace: fix boot trace sched startup
Content-Disposition: inline; filename=0002-ftrace-fix-boot-trace-sched-startup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: boot tracer startup modified

The boot tracer calls into some of the schedule tracing private functions
that should not be exported. This patch cleans it up, and makes
way for further changes in the ftrace infrastructure.

This patch adds a api to assign a tracer array to the schedule
context switch tracer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
CC:  Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.h              |    2 +-
 kernel/trace/trace_boot.c         |    9 +++++++--
 kernel/trace/trace_sched_switch.c |   15 ++++++++++++++-
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3422489..db12e16 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -49,7 +49,6 @@ struct ftrace_entry {
 	unsigned long		parent_ip;
 };
 extern struct tracer boot_tracer;
-extern struct tracer sched_switch_trace; /* Used by the boot tracer */
 
 /*
  * Context switch trace entry - which task (and prio) we switched from/to:
@@ -325,6 +324,7 @@ void trace_function(struct trace_array *tr,
 
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
+void tracing_cmdline_assign_trace(struct trace_array *tr);
 int register_tracer(struct tracer *type);
 void unregister_tracer(struct tracer *type);
 
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index bd5046c..662cb91 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -39,7 +39,12 @@ void disable_boot_trace(void)
 
 static void reset_boot_trace(struct trace_array *tr)
 {
-	sched_switch_trace.reset(tr);
+	int cpu;
+
+	tr->time_start = ftrace_now(tr->cpu);
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
 }
 
 static void boot_trace_init(struct trace_array *tr)
@@ -50,7 +55,7 @@ static void boot_trace_init(struct trace_array *tr)
 	for_each_cpu_mask(cpu, cpu_possible_map)
 		tracing_reset(tr, cpu);
 
-	sched_switch_trace.init(tr);
+	tracing_cmdline_assign_trace(tr);
 }
 
 static void boot_trace_ctrl_update(struct trace_array *tr)
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 91c699b..fbf05df 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -152,6 +152,19 @@ void tracing_stop_cmdline_record(void)
 	tracing_stop_sched_switch();
 }
 
+/**
+ * tracing_cmdline_assign_trace - assign a trace array for ctx switch
+ * @tr: trace array pointer to assign
+ *
+ * Some tracers might want to record the context switches in their
+ * trace. This function lets those tracers assign the trace array
+ * to use.
+ */
+void tracing_cmdline_assign_trace(struct trace_array *tr)
+{
+	ctx_trace = tr;
+}
+
 static void start_sched_trace(struct trace_array *tr)
 {
 	sched_switch_reset(tr);
@@ -197,7 +210,7 @@ static void sched_switch_trace_stop(struct trace_array *tr)
 	tracing_stop_sched_switch();
 }
 
-struct tracer sched_switch_trace __read_mostly =
+static struct tracer sched_switch_trace __read_mostly =
 {
 	.name		= "sched_switch",
 	.init		= sched_switch_trace_init,
-- 
1.5.6.5

-- 

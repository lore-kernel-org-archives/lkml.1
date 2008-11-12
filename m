Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYKLVXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYKLVXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYKLVVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:21:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38890 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbYKLVVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:21:53 -0500
Message-Id: <20081112212150.482761150@goodmis.org>
References: <20081112212127.455979814@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 16:21:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/4] ftrace: add tracer called branch
Content-Disposition: inline; filename=0003-ftrace-add-tracer-called-branch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: added new branch tracer

Currently the tracing of branch profiling (unlikelys and likelys hit)
is only activated by the iter_ctrl. This patch adds a tracer called
"branch" that will just trace the branch profiling. The advantage
of adding this tracer is that it can be added to the ftrace selftests
on startup.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.h          |    2 +
 kernel/trace/trace_selftest.c |   23 ++++++++++++++++++++++
 kernel/trace/trace_unlikely.c |   42 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 7fbf37b..9e015f5 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -420,6 +420,8 @@ extern int trace_selftest_startup_sched_switch(struct tracer *trace,
 					       struct trace_array *tr);
 extern int trace_selftest_startup_sysprof(struct tracer *trace,
 					       struct trace_array *tr);
+extern int trace_selftest_startup_branch(struct tracer *trace,
+					 struct trace_array *tr);
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 0728a10..24e6e07 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -13,6 +13,7 @@ static inline int trace_valid_entry(struct trace_entry *entry)
 	case TRACE_STACK:
 	case TRACE_PRINT:
 	case TRACE_SPECIAL:
+	case TRACE_BRANCH:
 		return 1;
 	}
 	return 0;
@@ -544,3 +545,25 @@ trace_selftest_startup_sysprof(struct tracer *trace, struct trace_array *tr)
 	return ret;
 }
 #endif /* CONFIG_SYSPROF_TRACER */
+
+#ifdef CONFIG_BRANCH_TRACER
+int
+trace_selftest_startup_branch(struct tracer *trace, struct trace_array *tr)
+{
+	unsigned long count;
+	int ret;
+
+	/* start the tracing */
+	trace->init(tr);
+	/* Sleep for a 1/10 of a second */
+	msleep(100);
+	/* stop the tracing. */
+	tracing_stop();
+	/* check the trace buffer */
+	ret = trace_test_buffer(tr, &count);
+	trace->reset(tr);
+	tracing_start();
+
+	return ret;
+}
+#endif /* CONFIG_BRANCH_TRACER */
diff --git a/kernel/trace/trace_unlikely.c b/kernel/trace/trace_unlikely.c
index e5d5969..8526555 100644
--- a/kernel/trace/trace_unlikely.c
+++ b/kernel/trace/trace_unlikely.c
@@ -114,6 +114,48 @@ void disable_branch_tracing(void)
  out_unlock:
 	mutex_unlock(&branch_tracing_mutex);
 }
+
+static void start_branch_trace(struct trace_array *tr)
+{
+	enable_branch_tracing(tr);
+}
+
+static void stop_branch_trace(struct trace_array *tr)
+{
+	disable_branch_tracing();
+}
+
+static void branch_trace_init(struct trace_array *tr)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
+
+	start_branch_trace(tr);
+}
+
+static void branch_trace_reset(struct trace_array *tr)
+{
+	stop_branch_trace(tr);
+}
+
+struct tracer branch_trace __read_mostly =
+{
+	.name		= "branch",
+	.init		= branch_trace_init,
+	.reset		= branch_trace_reset,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest	= trace_selftest_startup_branch,
+#endif
+};
+
+__init static int init_branch_trace(void)
+{
+	return register_tracer(&branch_trace);
+}
+
+device_initcall(init_branch_trace);
 #else
 static inline
 void trace_likely_condition(struct ftrace_branch_data *f, int val, int expect)
-- 
1.5.6.5

-- 

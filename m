Return-Path: <linux-kernel-owner+w=401wt.eu-S1765471AbZATAVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765471AbZATAVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764783AbZATARi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:17:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45153 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764779AbZATARe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:17:34 -0500
Message-Id: <20090120001732.411126819@goodmis.org>
References: <20090120001542.687427797@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 19 Jan 2009 19:15:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Markus Metzger <markus.t.metzger@intel.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/8] x86, ftrace, hw-branch-tracer: dump trace on oops
Content-Disposition: inline; filename=0002-x86-ftrace-hw-branch-tracer-dump-trace-on-oops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Metzger <markus.t.metzger@intel.com>

Dump the branch trace on an oops (based on ftrace_dump_on_oops).

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/dumpstack.c      |    6 ++++++
 include/linux/ftrace.h           |   13 +++++++++++++
 kernel/trace/trace.h             |    1 -
 kernel/trace/trace_hw_branches.c |   29 ++++++++++++++++++++++-------
 4 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 6b1f6f6..077c9ea 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -14,6 +14,7 @@
 #include <linux/bug.h>
 #include <linux/nmi.h>
 #include <linux/sysfs.h>
+#include <linux/ftrace.h>
 
 #include <asm/stacktrace.h>
 
@@ -195,6 +196,11 @@ unsigned __kprobes long oops_begin(void)
 	int cpu;
 	unsigned long flags;
 
+	/* notify the hw-branch tracer so it may disable tracing and
+	   add the last trace to the trace buffer -
+	   the earlier this happens, the more useful the trace. */
+	trace_hw_branch_oops();
+
 	oops_enter();
 
 	/* racy, but better than risking deadlock. */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 0547214..9f7880d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -496,4 +496,17 @@ static inline int test_tsk_trace_graph(struct task_struct *tsk)
 
 #endif /* CONFIG_TRACING */
 
+
+#ifdef CONFIG_HW_BRANCH_TRACER
+
+void trace_hw_branch(u64 from, u64 to);
+void trace_hw_branch_oops(void);
+
+#else /* CONFIG_HW_BRANCH_TRACER */
+
+static inline void trace_hw_branch(u64 from, u64 to) {}
+static inline void trace_hw_branch_oops(void) {}
+
+#endif /* CONFIG_HW_BRANCH_TRACER */
+
 #endif /* _LINUX_FTRACE_H */
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 54b7278..b96037d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -438,7 +438,6 @@ void trace_function(struct trace_array *tr,
 
 void trace_graph_return(struct ftrace_graph_ret *trace);
 int trace_graph_entry(struct ftrace_graph_ent *trace);
-void trace_hw_branch(struct trace_array *tr, u64 from, u64 to);
 
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 3981953..e56df2c 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -40,6 +40,7 @@ static DEFINE_PER_CPU(unsigned char[SIZEOF_BTS], buffer);
 #define this_buffer per_cpu(buffer, smp_processor_id())
 
 static int __read_mostly trace_hw_branches_enabled;
+static struct trace_array *hw_branch_trace __read_mostly;
 
 
 /*
@@ -128,6 +129,8 @@ static struct notifier_block bts_hotcpu_notifier __cpuinitdata = {
 
 static int bts_trace_init(struct trace_array *tr)
 {
+	hw_branch_trace = tr;
+
 	register_hotcpu_notifier(&bts_hotcpu_notifier);
 	tracing_reset_online_cpus(tr);
 	bts_trace_start(tr);
@@ -170,8 +173,9 @@ static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
 	return TRACE_TYPE_UNHANDLED;
 }
 
-void trace_hw_branch(struct trace_array *tr, u64 from, u64 to)
+void trace_hw_branch(u64 from, u64 to)
 {
+	struct trace_array *tr = hw_branch_trace;
 	struct ring_buffer_event *event;
 	struct hw_branch_entry *entry;
 	unsigned long irq1, irq2;
@@ -204,8 +208,7 @@ void trace_hw_branch(struct trace_array *tr, u64 from, u64 to)
 	local_irq_restore(irq1);
 }
 
-static void trace_bts_at(struct trace_array *tr,
-			 const struct bts_trace *trace, void *at)
+static void trace_bts_at(const struct bts_trace *trace, void *at)
 {
 	struct bts_struct bts;
 	int err = 0;
@@ -220,7 +223,7 @@ static void trace_bts_at(struct trace_array *tr,
 
 	switch (bts.qualifier) {
 	case BTS_BRANCH:
-		trace_hw_branch(tr, bts.variant.lbr.from, bts.variant.lbr.to);
+		trace_hw_branch(bts.variant.lbr.from, bts.variant.lbr.to);
 		break;
 	}
 }
@@ -236,12 +239,15 @@ static void trace_bts_cpu(void *arg)
 	const struct bts_trace *trace;
 	unsigned char *at;
 
-	if (!this_tracer)
+	if (unlikely(!tr))
 		return;
 
 	if (unlikely(atomic_read(&tr->data[raw_smp_processor_id()]->disabled)))
 		return;
 
+	if (unlikely(!this_tracer))
+		return;
+
 	ds_suspend_bts(this_tracer);
 	trace = ds_read_bts(this_tracer);
 	if (!trace)
@@ -249,11 +255,11 @@ static void trace_bts_cpu(void *arg)
 
 	for (at = trace->ds.top; (void *)at < trace->ds.end;
 	     at += trace->ds.size)
-		trace_bts_at(tr, trace, at);
+		trace_bts_at(trace, at);
 
 	for (at = trace->ds.begin; (void *)at < trace->ds.top;
 	     at += trace->ds.size)
-		trace_bts_at(tr, trace, at);
+		trace_bts_at(trace, at);
 
 out:
 	ds_resume_bts(this_tracer);
@@ -268,6 +274,15 @@ static void trace_bts_prepare(struct trace_iterator *iter)
 	mutex_unlock(&bts_tracer_mutex);
 }
 
+void trace_hw_branch_oops(void)
+{
+	mutex_lock(&bts_tracer_mutex);
+
+	trace_bts_cpu(hw_branch_trace);
+
+	mutex_unlock(&bts_tracer_mutex);
+}
+
 struct tracer bts_tracer __read_mostly =
 {
 	.name		= "hw-branch-tracer",
-- 
1.5.6.5

-- 

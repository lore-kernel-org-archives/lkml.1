Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbZA3XDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbZA3XDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZA3XDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:03:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45830 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbZA3XDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:03:09 -0500
Date: Sat, 31 Jan 2009 00:02:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] tracing fixes
Message-ID: <20090130230253.GA27052@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

these are cherry-picked fixes from the tracing tree.

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      tracing/function-graph-tracer: fix a regression while suspend to disk

Lai Jiangshan (1):
      ring_buffer: reset write when reserve buffer fail

Markus Metzger (1):
      x86, ds, bts: cleanup/fix DS configuration

Steven Rostedt (5):
      ring-buffer: fix alignment problem
      trace: print ftrace_dump at KERN_EMERG log level
      trace: stop all recording to ring buffer on ftrace_dump
      trace: set max latency variable to zero on default
      ring-buffer: reset timestamps when ring buffer is reset


 arch/x86/kernel/ds.c              |   31 +++++++++++++++++--------------
 kernel/trace/ftrace.c             |   27 +++++++++++++++++++++++++++
 kernel/trace/ring_buffer.c        |   15 +++++++++------
 kernel/trace/trace.c              |    5 +++--
 kernel/trace/trace_irqsoff.c      |    1 +
 kernel/trace/trace_sched_wakeup.c |    1 +
 6 files changed, 58 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index da91701..169a120 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -15,8 +15,8 @@
  * - buffer allocation (memory accounting)
  *
  *
- * Copyright (C) 2007-2008 Intel Corporation.
- * Markus Metzger <markus.t.metzger@intel.com>, 2007-2008
+ * Copyright (C) 2007-2009 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, 2007-2009
  */
 
 
@@ -890,7 +890,7 @@ int ds_set_pebs_reset(struct pebs_tracer *tracer, u64 value)
 }
 
 static const struct ds_configuration ds_cfg_netburst = {
-	.name = "netburst",
+	.name = "Netburst",
 	.ctl[dsf_bts]		= (1 << 2) | (1 << 3),
 	.ctl[dsf_bts_kernel]	= (1 << 5),
 	.ctl[dsf_bts_user]	= (1 << 6),
@@ -904,7 +904,7 @@ static const struct ds_configuration ds_cfg_netburst = {
 #endif
 };
 static const struct ds_configuration ds_cfg_pentium_m = {
-	.name = "pentium m",
+	.name = "Pentium M",
 	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
 
 	.sizeof_field		= sizeof(long),
@@ -915,8 +915,8 @@ static const struct ds_configuration ds_cfg_pentium_m = {
 	.sizeof_rec[ds_pebs]	= sizeof(long) * 18,
 #endif
 };
-static const struct ds_configuration ds_cfg_core2 = {
-	.name = "core 2",
+static const struct ds_configuration ds_cfg_core2_atom = {
+	.name = "Core 2/Atom",
 	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
 	.ctl[dsf_bts_kernel]	= (1 << 9),
 	.ctl[dsf_bts_user]	= (1 << 10),
@@ -949,19 +949,22 @@ void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
 	switch (c->x86) {
 	case 0x6:
 		switch (c->x86_model) {
-		case 0 ... 0xC:
-			/* sorry, don't know about them */
-			break;
-		case 0xD:
-		case 0xE: /* Pentium M */
+		case 0x9:
+		case 0xd: /* Pentium M */
 			ds_configure(&ds_cfg_pentium_m);
 			break;
-		default: /* Core2, Atom, ... */
-			ds_configure(&ds_cfg_core2);
+		case 0xf:
+		case 0x17: /* Core2 */
+		case 0x1c: /* Atom */
+			ds_configure(&ds_cfg_core2_atom);
+			break;
+		case 0x1a: /* i7 */
+		default:
+			/* sorry, don't know about them */
 			break;
 		}
 		break;
-	case 0xF:
+	case 0xf:
 		switch (c->x86_model) {
 		case 0x0:
 		case 0x1:
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2f32969..7dcf6e9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -17,6 +17,7 @@
 #include <linux/clocksource.h>
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
+#include <linux/suspend.h>
 #include <linux/debugfs.h>
 #include <linux/hardirq.h>
 #include <linux/kthread.h>
@@ -1965,6 +1966,7 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 static atomic_t ftrace_graph_active;
+static struct notifier_block ftrace_suspend_notifier;
 
 int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
 {
@@ -2043,6 +2045,27 @@ static int start_graph_tracing(void)
 	return ret;
 }
 
+/*
+ * Hibernation protection.
+ * The state of the current task is too much unstable during
+ * suspend/restore to disk. We want to protect against that.
+ */
+static int
+ftrace_suspend_notifier_call(struct notifier_block *bl, unsigned long state,
+							void *unused)
+{
+	switch (state) {
+	case PM_HIBERNATION_PREPARE:
+		pause_graph_tracing();
+		break;
+
+	case PM_POST_HIBERNATION:
+		unpause_graph_tracing();
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
 int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 			trace_func_graph_ent_t entryfunc)
 {
@@ -2050,6 +2073,9 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 
 	mutex_lock(&ftrace_sysctl_lock);
 
+	ftrace_suspend_notifier.notifier_call = ftrace_suspend_notifier_call;
+	register_pm_notifier(&ftrace_suspend_notifier);
+
 	atomic_inc(&ftrace_graph_active);
 	ret = start_graph_tracing();
 	if (ret) {
@@ -2075,6 +2101,7 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
 	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
+	unregister_pm_notifier(&ftrace_suspend_notifier);
 
 	mutex_unlock(&ftrace_sysctl_lock);
 }
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 8b0daf0..bd38c5c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -246,7 +246,7 @@ static inline int test_time_stamp(u64 delta)
 	return 0;
 }
 
-#define BUF_PAGE_SIZE (PAGE_SIZE - sizeof(struct buffer_data_page))
+#define BUF_PAGE_SIZE (PAGE_SIZE - offsetof(struct buffer_data_page, data))
 
 /*
  * head_page == tail_page && head == tail then buffer is empty.
@@ -1025,12 +1025,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		}
 
 		if (next_page == head_page) {
-			if (!(buffer->flags & RB_FL_OVERWRITE)) {
-				/* reset write */
-				if (tail <= BUF_PAGE_SIZE)
-					local_set(&tail_page->write, tail);
+			if (!(buffer->flags & RB_FL_OVERWRITE))
 				goto out_unlock;
-			}
 
 			/* tail_page has not moved yet? */
 			if (tail_page == cpu_buffer->tail_page) {
@@ -1105,6 +1101,10 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	return event;
 
  out_unlock:
+	/* reset write */
+	if (tail <= BUF_PAGE_SIZE)
+		local_set(&tail_page->write, tail);
+
 	__raw_spin_unlock(&cpu_buffer->lock);
 	local_irq_restore(flags);
 	return NULL;
@@ -2174,6 +2174,9 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 
 	cpu_buffer->overrun = 0;
 	cpu_buffer->entries = 0;
+
+	cpu_buffer->write_stamp = 0;
+	cpu_buffer->read_stamp = 0;
 }
 
 /**
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c580233..17bb88d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -40,7 +40,7 @@
 
 #define TRACE_BUFFER_FLAGS	(RB_FL_OVERWRITE)
 
-unsigned long __read_mostly	tracing_max_latency = (cycle_t)ULONG_MAX;
+unsigned long __read_mostly	tracing_max_latency;
 unsigned long __read_mostly	tracing_thresh;
 
 /*
@@ -3736,7 +3736,7 @@ static struct notifier_block trace_die_notifier = {
  * it if we decide to change what log level the ftrace dump
  * should be at.
  */
-#define KERN_TRACE		KERN_INFO
+#define KERN_TRACE		KERN_EMERG
 
 static void
 trace_printk_seq(struct trace_seq *s)
@@ -3770,6 +3770,7 @@ void ftrace_dump(void)
 	dump_ran = 1;
 
 	/* No turning back! */
+	tracing_off();
 	ftrace_kill();
 
 	for_each_tracing_cpu(cpu) {
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 7c2e326..62a78d9 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -380,6 +380,7 @@ static void stop_irqsoff_tracer(struct trace_array *tr)
 
 static void __irqsoff_tracer_init(struct trace_array *tr)
 {
+	tracing_max_latency = 0;
 	irqsoff_trace = tr;
 	/* make sure that the tracer is visible */
 	smp_wmb();
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 43586b6..42ae1e7 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -333,6 +333,7 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 
 static int wakeup_tracer_init(struct trace_array *tr)
 {
+	tracing_max_latency = 0;
 	wakeup_trace = tr;
 	start_wakeup_tracer(tr);
 	return 0;

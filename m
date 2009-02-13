Return-Path: <linux-kernel-owner+w=401wt.eu-S1760102AbZBMP0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbZBMP0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 10:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZBMP0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 10:26:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40351 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZBMP0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:26:39 -0500
Date: Fri, 13 Feb 2009 10:26:35 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull][tip] updates for tip/tracing/ftrace
Message-ID: <alpine.DEB.1.10.0902131025120.27973@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Jason Baron (1):
      tracing: convert c/p state power tracer to use tracepoints

----
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +
 arch/x86/kernel/process.c                  |    3 +
 include/trace/power.h                      |   25 ++--
 kernel/trace/trace_power.c                 |  173 ++++++++++++++++-----------
 4 files changed, 119 insertions(+), 84 deletions(-)
---------------------------
commit b5f9fd0f8a05c9bafb91a9a85b9110938d8e585b
Author: Jason Baron <jbaron@redhat.com>
Date:   Wed Feb 11 13:57:25 2009 -0500

    tracing: convert c/p state power tracer to use tracepoints
    
    Convert the c/p state "power" tracer to use tracepoints. Avoids a
    function call when the tracer is disabled.
    
    Signed-off-by: Jason Baron <jbaron@redhat.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 7ed925e..c5d737c 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -70,6 +70,8 @@ struct acpi_cpufreq_data {
 
 static DEFINE_PER_CPU(struct acpi_cpufreq_data *, drv_data);
 
+DEFINE_TRACE(power_mark);
+
 /* acpi_perf_data is a pointer to percpu data. */
 static struct acpi_processor_performance *acpi_perf_data;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 026819f..e0d0fd7 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -19,6 +19,9 @@ EXPORT_SYMBOL(idle_nomwait);
 
 struct kmem_cache *task_xstate_cachep;
 
+DEFINE_TRACE(power_start);
+DEFINE_TRACE(power_end);
+
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	*dst = *src;
diff --git a/include/trace/power.h b/include/trace/power.h
index c7cefbc..2c733e5 100644
--- a/include/trace/power.h
+++ b/include/trace/power.h
@@ -2,6 +2,7 @@
 #define _TRACE_POWER_H
 
 #include <linux/ktime.h>
+#include <linux/tracepoint.h>
 
 enum {
 	POWER_NONE = 0,
@@ -18,18 +19,16 @@ struct power_trace {
 #endif
 };
 
-#ifdef CONFIG_POWER_TRACER
-extern void trace_power_start(struct power_trace *it, unsigned int type,
-					unsigned int state);
-extern void trace_power_mark(struct power_trace *it, unsigned int type,
-					unsigned int state);
-extern void trace_power_end(struct power_trace *it);
-#else
-static inline void trace_power_start(struct power_trace *it, unsigned int type,
-					unsigned int state) { }
-static inline void trace_power_mark(struct power_trace *it, unsigned int type,
-					unsigned int state) { }
-static inline void trace_power_end(struct power_trace *it) { }
-#endif
+DECLARE_TRACE(power_start,
+	TPPROTO(struct power_trace *it, unsigned int type, unsigned int state),
+		TPARGS(it, type, state));
+
+DECLARE_TRACE(power_mark,
+	TPPROTO(struct power_trace *it, unsigned int type, unsigned int state),
+		TPARGS(it, type, state));
+
+DECLARE_TRACE(power_end,
+	TPPROTO(struct power_trace *it),
+		TPARGS(it));
 
 #endif /* _TRACE_POWER_H */
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index b1d0d08..91ce672 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -21,15 +21,116 @@
 static struct trace_array *power_trace;
 static int __read_mostly trace_power_enabled;
 
+static void probe_power_start(struct power_trace *it, unsigned int type,
+				unsigned int level)
+{
+	if (!trace_power_enabled)
+		return;
+
+	memset(it, 0, sizeof(struct power_trace));
+	it->state = level;
+	it->type = type;
+	it->stamp = ktime_get();
+}
+
+
+static void probe_power_end(struct power_trace *it)
+{
+	struct ring_buffer_event *event;
+	struct trace_power *entry;
+	struct trace_array_cpu *data;
+	struct trace_array *tr = power_trace;
+
+	if (!trace_power_enabled)
+		return;
+
+	preempt_disable();
+	it->end = ktime_get();
+	data = tr->data[smp_processor_id()];
+
+	event = trace_buffer_lock_reserve(tr, TRACE_POWER,
+					  sizeof(*entry), 0, 0);
+	if (!event)
+		goto out;
+	entry	= ring_buffer_event_data(event);
+	entry->state_data = *it;
+	trace_buffer_unlock_commit(tr, event, 0, 0);
+ out:
+	preempt_enable();
+}
+
+static void probe_power_mark(struct power_trace *it, unsigned int type,
+				unsigned int level)
+{
+	struct ring_buffer_event *event;
+	struct trace_power *entry;
+	struct trace_array_cpu *data;
+	struct trace_array *tr = power_trace;
+
+	if (!trace_power_enabled)
+		return;
+
+	memset(it, 0, sizeof(struct power_trace));
+	it->state = level;
+	it->type = type;
+	it->stamp = ktime_get();
+	preempt_disable();
+	it->end = it->stamp;
+	data = tr->data[smp_processor_id()];
+
+	event = trace_buffer_lock_reserve(tr, TRACE_POWER,
+					  sizeof(*entry), 0, 0);
+	if (!event)
+		goto out;
+	entry	= ring_buffer_event_data(event);
+	entry->state_data = *it;
+	trace_buffer_unlock_commit(tr, event, 0, 0);
+ out:
+	preempt_enable();
+}
+
+static int tracing_power_register(void)
+{
+	int ret;
+
+	ret = register_trace_power_start(probe_power_start);
+	if (ret) {
+		pr_info("power trace: Couldn't activate tracepoint"
+			" probe to trace_power_start\n");
+		return ret;
+	}
+	ret = register_trace_power_end(probe_power_end);
+	if (ret) {
+		pr_info("power trace: Couldn't activate tracepoint"
+			" probe to trace_power_end\n");
+		goto fail_start;
+	}
+	ret = register_trace_power_mark(probe_power_mark);
+	if (ret) {
+		pr_info("power trace: Couldn't activate tracepoint"
+			" probe to trace_power_mark\n");
+		goto fail_end;
+	}
+	return ret;
+fail_end:
+	unregister_trace_power_end(probe_power_end);
+fail_start:
+	unregister_trace_power_start(probe_power_start);
+	return ret;
+}
 
 static void start_power_trace(struct trace_array *tr)
 {
 	trace_power_enabled = 1;
+	tracing_power_register();
 }
 
 static void stop_power_trace(struct trace_array *tr)
 {
 	trace_power_enabled = 0;
+	unregister_trace_power_start(probe_power_start);
+	unregister_trace_power_end(probe_power_end);
+	unregister_trace_power_mark(probe_power_mark);
 }
 
 
@@ -39,6 +140,7 @@ static int power_trace_init(struct trace_array *tr)
 	power_trace = tr;
 
 	trace_power_enabled = 1;
+	tracing_power_register();
 
 	for_each_cpu(cpu, cpu_possible_mask)
 		tracing_reset(tr, cpu);
@@ -95,74 +197,3 @@ static int init_power_trace(void)
 	return register_tracer(&power_tracer);
 }
 device_initcall(init_power_trace);
-
-void trace_power_start(struct power_trace *it, unsigned int type,
-			 unsigned int level)
-{
-	if (!trace_power_enabled)
-		return;
-
-	memset(it, 0, sizeof(struct power_trace));
-	it->state = level;
-	it->type = type;
-	it->stamp = ktime_get();
-}
-EXPORT_SYMBOL_GPL(trace_power_start);
-
-
-void trace_power_end(struct power_trace *it)
-{
-	struct ring_buffer_event *event;
-	struct trace_power *entry;
-	struct trace_array_cpu *data;
-	struct trace_array *tr = power_trace;
-
-	if (!trace_power_enabled)
-		return;
-
-	preempt_disable();
-	it->end = ktime_get();
-	data = tr->data[smp_processor_id()];
-
-	event = trace_buffer_lock_reserve(tr, TRACE_POWER,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		goto out;
-	entry	= ring_buffer_event_data(event);
-	entry->state_data = *it;
-	trace_buffer_unlock_commit(tr, event, 0, 0);
- out:
-	preempt_enable();
-}
-EXPORT_SYMBOL_GPL(trace_power_end);
-
-void trace_power_mark(struct power_trace *it, unsigned int type,
-			 unsigned int level)
-{
-	struct ring_buffer_event *event;
-	struct trace_power *entry;
-	struct trace_array_cpu *data;
-	struct trace_array *tr = power_trace;
-
-	if (!trace_power_enabled)
-		return;
-
-	memset(it, 0, sizeof(struct power_trace));
-	it->state = level;
-	it->type = type;
-	it->stamp = ktime_get();
-	preempt_disable();
-	it->end = it->stamp;
-	data = tr->data[smp_processor_id()];
-
-	event = trace_buffer_lock_reserve(tr, TRACE_POWER,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		goto out;
-	entry	= ring_buffer_event_data(event);
-	entry->state_data = *it;
-	trace_buffer_unlock_commit(tr, event, 0, 0);
- out:
-	preempt_enable();
-}
-EXPORT_SYMBOL_GPL(trace_power_mark);


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbYBJH1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbYBJH1V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758178AbYBJHVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:21:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56928 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758164AbYBJHVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:21:18 -0500
Date: Sun, 10 Feb 2008 08:21:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: [16/19] ftrace: trace preempt off critical timings
Message-ID: <20080210072104.GQ4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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

From: Steven Rostedt <srostedt@redhat.com>

Add preempt off timings. A lot of kernel core code is taken from the RT patch
latency trace that was written by Ingo Molnar.

This adds "preemptoff" and "preemptirqsoff" to /debugfs/tracing/available_tracers

Now instead of just tracing irqs off, preemption off can be selected
to be recorded.

When this is selected, it shares the same files as irqs off timings.
One can either trace preemption off, irqs off, or one or the other off.

By echoing "preemptoff" into /debugfs/tracing/current_tracer, recording
of preempt off only is performed. "irqsoff" will only record the time
irqs are disabled, but "preemptirqsoff" will take the total time irqs
or preemption are disabled. Runtime switching of these options is now
supported by simpling echoing in the appropriate trace name into
/debugfs/tracing/current_tracer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process_32.c |    3 
 include/linux/ftrace.h       |    8 +
 include/linux/irqflags.h     |    3 
 include/linux/preempt.h      |    2 
 kernel/sched.c               |   24 +++++
 kernel/trace/Kconfig         |   25 +++++
 kernel/trace/Makefile        |    1 
 kernel/trace/trace_irqsoff.c |  184 +++++++++++++++++++++++++++++++------------
 8 files changed, 197 insertions(+), 53 deletions(-)

Index: linux/arch/x86/kernel/process_32.c
===================================================================
--- linux.orig/arch/x86/kernel/process_32.c
+++ linux/arch/x86/kernel/process_32.c
@@ -207,7 +207,10 @@ void cpu_idle(void)
 				play_dead();
 
 			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
+			/* Don't trace irqs off for idle */
+			stop_critical_timings();
 			idle();
+			start_critical_timings();
 		}
 		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
Index: linux/include/linux/ftrace.h
===================================================================
--- linux.orig/include/linux/ftrace.h
+++ linux/include/linux/ftrace.h
@@ -58,4 +58,12 @@ extern void mcount(void);
 # define time_hardirqs_off(a0, a1)		do { } while (0)
 #endif
 
+#ifdef CONFIG_PREEMPT_TRACER
+  extern void notrace trace_preempt_on(unsigned long a0, unsigned long a1);
+  extern void notrace trace_preempt_off(unsigned long a0, unsigned long a1);
+#else
+# define trace_preempt_on(a0, a1)		do { } while (0)
+# define trace_preempt_off(a0, a1)		do { } while (0)
+#endif
+
 #endif /* _LINUX_FTRACE_H */
Index: linux/include/linux/irqflags.h
===================================================================
--- linux.orig/include/linux/irqflags.h
+++ linux/include/linux/irqflags.h
@@ -41,7 +41,8 @@
 # define INIT_TRACE_IRQFLAGS
 #endif
 
-#ifdef CONFIG_IRQSOFF_TRACER
+#if defined(CONFIG_IRQSOFF_TRACER) || \
+	defined(CONFIG_PREEMPT_TRACER)
  extern void stop_critical_timings(void);
  extern void start_critical_timings(void);
 #else
Index: linux/include/linux/preempt.h
===================================================================
--- linux.orig/include/linux/preempt.h
+++ linux/include/linux/preempt.h
@@ -10,7 +10,7 @@
 #include <linux/linkage.h>
 #include <linux/list.h>
 
-#ifdef CONFIG_DEBUG_PREEMPT
+#if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
   extern void add_preempt_count(int val);
   extern void sub_preempt_count(int val);
 #else
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -66,6 +66,7 @@
 #include <linux/unistd.h>
 #include <linux/pagemap.h>
 #include <linux/hrtimer.h>
+#include <linux/ftrace.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -3772,26 +3773,44 @@ void scheduler_tick(void)
 #endif
 }
 
-#if defined(CONFIG_PREEMPT) && defined(CONFIG_DEBUG_PREEMPT)
+#if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
+				defined(CONFIG_PREEMPT_TRACER))
+
+static inline unsigned long get_parent_ip(unsigned long addr)
+{
+	if (in_lock_functions(addr)) {
+		addr = CALLER_ADDR2;
+		if (in_lock_functions(addr))
+			addr = CALLER_ADDR3;
+	}
+	return addr;
+}
 
 void add_preempt_count(int val)
 {
+#ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Underflow?
 	 */
 	if (DEBUG_LOCKS_WARN_ON((preempt_count() < 0)))
 		return;
+#endif
 	preempt_count() += val;
+#ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Spinlock count overflowing soon?
 	 */
 	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
 				PREEMPT_MASK - 10);
+#endif
+	if (preempt_count() == val)
+		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 }
 EXPORT_SYMBOL(add_preempt_count);
 
 void sub_preempt_count(int val)
 {
+#ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Underflow?
 	 */
@@ -3803,7 +3822,10 @@ void sub_preempt_count(int val)
 	if (DEBUG_LOCKS_WARN_ON((val < PREEMPT_MASK) &&
 			!(preempt_count() & PREEMPT_MASK)))
 		return;
+#endif
 
+	if (preempt_count() == val)
+		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 	preempt_count() -= val;
 }
 EXPORT_SYMBOL(sub_preempt_count);
Index: linux/kernel/trace/Kconfig
===================================================================
--- linux.orig/kernel/trace/Kconfig
+++ linux/kernel/trace/Kconfig
@@ -44,6 +44,31 @@ config IRQSOFF_TRACER
 
 	      echo 0 > /debugfs/tracing/tracing_max_latency
 
+	  (Note that kernel size and overhead increases with this option
+	  enabled. This option and the preempt-off timing option can be
+	  used together or separately.)
+
+config PREEMPT_TRACER
+	bool "Preemption-off Latency Tracer"
+	default n
+	depends on GENERIC_TIME
+	depends on PREEMPT
+	select TRACING
+	select TRACER_MAX_TRACE
+	help
+	  This option measures the time spent in preemption off critical
+	  sections, with microsecond accuracy.
+
+	  The default measurement method is a maximum search, which is
+	  disabled by default and can be runtime (re-)started
+	  via:
+
+	      echo 0 > /debugfs/tracing/tracing_max_latency
+
+	  (Note that kernel size and overhead increases with this option
+	  enabled. This option and the irqs-off timing option can be
+	  used together or separately.)
+
 config SCHED_TRACER
 	bool "Scheduling Latency Tracer"
 	depends on DEBUG_KERNEL
Index: linux/kernel/trace/Makefile
===================================================================
--- linux.orig/kernel/trace/Makefile
+++ linux/kernel/trace/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_FTRACE) += trace_functions.o
 obj-$(CONFIG_IRQSOFF_TRACER) += trace_irqsoff.o
+obj-$(CONFIG_PREEMPT_TRACER) += trace_irqsoff.o
 obj-$(CONFIG_SCHED_TRACER) += trace_sched_wakeup.o
 
 libftrace-y := ftrace.o
Index: linux/kernel/trace/trace_irqsoff.c
===================================================================
--- linux.orig/kernel/trace/trace_irqsoff.c
+++ linux/kernel/trace/trace_irqsoff.c
@@ -21,6 +21,36 @@
 static struct trace_array		*irqsoff_trace __read_mostly;
 static int				tracer_enabled __read_mostly;
 
+static DEFINE_PER_CPU(int, tracing_cpu);
+
+enum {
+	TRACER_IRQS_OFF		= (1 << 1),
+	TRACER_PREEMPT_OFF	= (1 << 2),
+};
+
+static int trace_type __read_mostly;
+
+#ifdef CONFIG_PREEMPT_TRACER
+static inline int notrace
+preempt_trace(void)
+{
+	return ((trace_type & TRACER_PREEMPT_OFF) && preempt_count());
+}
+#else
+# define preempt_trace() (0)
+#endif
+
+#ifdef CONFIG_IRQSOFF_TRACER
+static inline int notrace
+irq_trace(void)
+{
+	return ((trace_type & TRACER_IRQS_OFF) &&
+		irqs_disabled());
+}
+#else
+# define irq_trace() (0)
+#endif
+
 /*
  * Sequence count - we record it when starting a measurement and
  * skip the latency if the sequence has changed - some other section
@@ -44,14 +74,11 @@ irqsoff_tracer_call(unsigned long ip, un
 	long disabled;
 	int cpu;
 
-	if (likely(!tracer_enabled))
+	if (likely(!__get_cpu_var(tracing_cpu)))
 		return;
 
 	local_save_flags(flags);
 
-	if (!irqs_disabled_flags(flags))
-		return;
-
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
@@ -171,23 +198,29 @@ start_critical_timing(unsigned long ip, 
 	if (likely(!tracer_enabled))
 		return;
 
+	if (__get_cpu_var(tracing_cpu))
+		return;
+
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 
 	if (unlikely(!data) || unlikely(!data->trace) ||
-	    data->critical_start || atomic_read(&data->disabled))
+	    atomic_read(&data->disabled))
 		return;
 
 	atomic_inc(&data->disabled);
 
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = now(cpu);
-	data->critical_start = parent_ip;
+	data->critical_start = parent_ip ? : ip;
 	tracing_reset(data);
 
 	local_save_flags(flags);
+
 	ftrace(tr, data, ip, parent_ip, flags);
 
+	__get_cpu_var(tracing_cpu) = 1;
+
 	atomic_dec(&data->disabled);
 }
 
@@ -199,7 +232,13 @@ stop_critical_timing(unsigned long ip, u
 	struct trace_array_cpu *data;
 	unsigned long flags;
 
-	if (likely(!tracer_enabled))
+	/* Always clear the tracing cpu on stopping the trace */
+	if (unlikely(__get_cpu_var(tracing_cpu)))
+		__get_cpu_var(tracing_cpu) = 0;
+	else
+		return;
+
+	if (!tracer_enabled)
 		return;
 
 	cpu = raw_smp_processor_id();
@@ -212,49 +251,35 @@ stop_critical_timing(unsigned long ip, u
 	atomic_inc(&data->disabled);
 	local_save_flags(flags);
 	ftrace(tr, data, ip, parent_ip, flags);
-	check_critical_timing(tr, data, parent_ip, cpu);
+	check_critical_timing(tr, data, parent_ip ? : ip, cpu);
 	data->critical_start = 0;
 	atomic_dec(&data->disabled);
 }
 
+/* start and stop critical timings used to for stoppage (in idle) */
 void notrace start_critical_timings(void)
 {
-	unsigned long flags;
-
-	local_save_flags(flags);
-
-	if (irqs_disabled_flags(flags))
+	if (preempt_trace() || irq_trace())
 		start_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
 }
 
 void notrace stop_critical_timings(void)
 {
-	unsigned long flags;
-
-	local_save_flags(flags);
-
-	if (irqs_disabled_flags(flags))
+	if (preempt_trace() || irq_trace())
 		stop_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
 }
 
+#ifdef CONFIG_IRQSOFF_TRACER
 #ifdef CONFIG_PROVE_LOCKING
 void notrace time_hardirqs_on(unsigned long a0, unsigned long a1)
 {
-	unsigned long flags;
-
-	local_save_flags(flags);
-
-	if (irqs_disabled_flags(flags))
+	if (!preempt_trace() && irq_trace())
 		stop_critical_timing(a0, a1);
 }
 
 void notrace time_hardirqs_off(unsigned long a0, unsigned long a1)
 {
-	unsigned long flags;
-
-	local_save_flags(flags);
-
-	if (irqs_disabled_flags(flags))
+	if (!preempt_trace() && irq_trace())
 		start_critical_timing(a0, a1);
 }
 
@@ -289,49 +314,46 @@ inline void print_irqtrace_events(struct
  */
 void notrace trace_hardirqs_on(void)
 {
-	unsigned long flags;
-
-	local_save_flags(flags);
-
-	if (irqs_disabled_flags(flags))
+	if (!preempt_trace() && irq_trace())
 		stop_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
 }
 EXPORT_SYMBOL(trace_hardirqs_on);
 
 void notrace trace_hardirqs_off(void)
 {
-	unsigned long flags;
-
-	local_save_flags(flags);
-
-	if (irqs_disabled_flags(flags))
+	if (!preempt_trace() && irq_trace())
 		start_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
 }
 EXPORT_SYMBOL(trace_hardirqs_off);
 
 void notrace trace_hardirqs_on_caller(unsigned long caller_addr)
 {
-	unsigned long flags;
-
-	local_save_flags(flags);
-
-	if (irqs_disabled_flags(flags))
+	if (!preempt_trace() && irq_trace())
 		stop_critical_timing(CALLER_ADDR0, caller_addr);
 }
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
 
 void notrace trace_hardirqs_off_caller(unsigned long caller_addr)
 {
-	unsigned long flags;
-
-	local_save_flags(flags);
-
-	if (irqs_disabled_flags(flags))
+	if (!preempt_trace() && irq_trace())
 		start_critical_timing(CALLER_ADDR0, caller_addr);
 }
 EXPORT_SYMBOL(trace_hardirqs_off_caller);
 
 #endif /* CONFIG_PROVE_LOCKING */
+#endif /*  CONFIG_IRQSOFF_TRACER */
+
+#ifdef CONFIG_PREEMPT_TRACER
+void notrace trace_preempt_on(unsigned long a0, unsigned long a1)
+{
+	stop_critical_timing(a0, a1);
+}
+
+void notrace trace_preempt_off(unsigned long a0, unsigned long a1)
+{
+	start_critical_timing(a0, a1);
+}
+#endif /* CONFIG_PREEMPT_TRACER */
 
 static void start_irqsoff_tracer(struct trace_array *tr)
 {
@@ -345,7 +367,7 @@ static void stop_irqsoff_tracer(struct t
 	tracer_enabled = 0;
 }
 
-static void irqsoff_tracer_init(struct trace_array *tr)
+static void __irqsoff_tracer_init(struct trace_array *tr)
 {
 	irqsoff_trace = tr;
 	/* make sure that the tracer is visibel */
@@ -382,6 +404,13 @@ static void notrace irqsoff_tracer_close
 		start_irqsoff_tracer(iter->tr);
 }
 
+#ifdef CONFIG_IRQSOFF_TRACER
+static void irqsoff_tracer_init(struct trace_array *tr)
+{
+	trace_type = TRACER_IRQS_OFF;
+
+	__irqsoff_tracer_init(tr);
+}
 static struct tracer irqsoff_tracer __read_mostly =
 {
 	.name		= "irqsoff",
@@ -392,10 +421,65 @@ static struct tracer irqsoff_tracer __re
 	.ctrl_update	= irqsoff_tracer_ctrl_update,
 	.print_max	= 1,
 };
+# define register_irqsoff(trace) register_tracer(&trace)
+#else
+# define register_irqsoff(trace) do { } while (0)
+#endif
+
+#ifdef CONFIG_PREEMPT_TRACER
+static void preemptoff_tracer_init(struct trace_array *tr)
+{
+	trace_type = TRACER_PREEMPT_OFF;
+
+	__irqsoff_tracer_init(tr);
+}
+
+static struct tracer preemptoff_tracer __read_mostly =
+{
+	.name		= "preemptoff",
+	.init		= preemptoff_tracer_init,
+	.reset		= irqsoff_tracer_reset,
+	.open		= irqsoff_tracer_open,
+	.close		= irqsoff_tracer_close,
+	.ctrl_update	= irqsoff_tracer_ctrl_update,
+	.print_max	= 1,
+};
+# define register_preemptoff(trace) register_tracer(&trace)
+#else
+# define register_preemptoff(trace) do { } while (0)
+#endif
+
+#if defined(CONFIG_IRQSOFF_TRACER) && \
+	defined(CONFIG_PREEMPT_TRACER)
+
+static void preemptirqsoff_tracer_init(struct trace_array *tr)
+{
+	trace_type = TRACER_IRQS_OFF | TRACER_PREEMPT_OFF;
+
+	__irqsoff_tracer_init(tr);
+}
+
+static struct tracer preemptirqsoff_tracer __read_mostly =
+{
+	.name		= "preemptirqsoff",
+	.init		= preemptirqsoff_tracer_init,
+	.reset		= irqsoff_tracer_reset,
+	.open		= irqsoff_tracer_open,
+	.close		= irqsoff_tracer_close,
+	.ctrl_update	= irqsoff_tracer_ctrl_update,
+	.print_max	= 1,
+};
+
+# define register_preemptirqsoff(trace) register_tracer(&trace)
+#else
+# define register_preemptirqsoff(trace) do { } while (0)
+#endif
 
 __init static int init_irqsoff_tracer(void)
 {
-	register_tracer(&irqsoff_tracer);
+	register_irqsoff(irqsoff_tracer);
+	register_preemptoff(preemptoff_tracer);
+	register_preemptirqsoff(preemptirqsoff_tracer);
 
 	return 0;
 }

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbYAOU7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbYAOU7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbYAOUvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:51:00 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:51824 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbYAOUuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:37 -0500
Message-Id: <20080115205026.903313840@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 30/30 v3] trace preempt off critical timings
Content-Disposition: inline; filename=mcount-trace-latency-trace-preempt-off.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add preempt off timings. A lot of this code is taken from the RT patch
latency trace that was written by Ingo Molnar.

Now instead of just tracing irqs off, preemption off can be selected
to be recorded.

When this is selected, it shares the same files as irqs off timings.
One can either trace preemption off, irqs off, or one or the other off.
But once it is configured in the kernel for what to trace, it can't
be changed.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/process_32.c |    3 +++
 include/linux/irqflags.h     |    3 ++-
 include/linux/mcount.h       |    8 ++++++++
 include/linux/preempt.h      |    2 +-
 kernel/sched.c               |   24 +++++++++++++++++++++++-
 lib/tracing/Kconfig          |   24 ++++++++++++++++++++++++
 lib/tracing/Makefile         |    1 +
 lib/tracing/trace_irqsoff.c  |   40 ++++++++++++++++++++++++++++++----------
 8 files changed, 92 insertions(+), 13 deletions(-)

Index: linux-compile.git/lib/tracing/Kconfig
===================================================================
--- linux-compile.git.orig/lib/tracing/Kconfig	2008-01-15 15:13:59.000000000 -0500
+++ linux-compile.git/lib/tracing/Kconfig	2008-01-15 15:15:32.000000000 -0500
@@ -43,6 +43,30 @@ config CRITICAL_IRQSOFF_TIMING
 
 	      echo 0 > /debug/tracing/preempt_max_latency
 
+	  (Note that kernel size and overhead increases with this option
+	  enabled. This option and the preempt-off timing option can be
+	  used together or separately.)
+
+config CRITICAL_PREEMPT_TIMING
+	bool "Preemption-off critical section latency timing"
+	default n
+	depends on GENERIC_TIME
+	depends on PREEMPT
+	select TRACING
+	help
+	  This option measures the time spent in preemption off critical
+	  sections, with microsecond accuracy.
+
+	  The default measurement method is a maximum search, which is
+	  disabled by default and can be runtime (re-)started
+	  via:
+
+	      echo 0 > /debug/tracing/preempt_max_latency
+
+	  (Note that kernel size and overhead increases with this option
+	  enabled. This option and the irqs-off timing option can be
+	  used together or separately.)
+
 config CONTEXT_SWITCH_TRACER
 	bool "Trace process context switches"
 	depends on DEBUG_KERNEL
Index: linux-compile.git/lib/tracing/Makefile
===================================================================
--- linux-compile.git.orig/lib/tracing/Makefile	2008-01-15 15:13:50.000000000 -0500
+++ linux-compile.git/lib/tracing/Makefile	2008-01-15 15:15:32.000000000 -0500
@@ -4,5 +4,6 @@ obj-$(CONFIG_TRACING) += tracer.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace_function.o
 obj-$(CONFIG_CRITICAL_IRQSOFF_TIMING) += trace_irqsoff.o
+obj-$(CONFIG_CRITICAL_PREEMPT_TIMING) += trace_irqsoff.o
 
 libmcount-y := mcount.o
Index: linux-compile.git/lib/tracing/trace_irqsoff.c
===================================================================
--- linux-compile.git.orig/lib/tracing/trace_irqsoff.c	2008-01-15 15:15:00.000000000 -0500
+++ linux-compile.git/lib/tracing/trace_irqsoff.c	2008-01-15 15:15:32.000000000 -0500
@@ -36,6 +36,12 @@ static int __init set_nr_entries(char *s
 }
 __setup("trace_irq_entries=", set_nr_entries);
 
+#ifdef CONFIG_CRITICAL_PREEMPT_TIMING
+# define preempt_trace() (preempt_count())
+#else
+# define preempt_trace() (0)
+#endif
+
 /*
  * max trace is switched with this buffer.
  */
@@ -208,7 +214,7 @@ start_critical_timing(unsigned long ip, 
 
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = now();
-	data->critical_start = parent_ip;
+	data->critical_start = parent_ip ? : ip;
 	tracing_reset(data);
 
 	local_save_flags(flags);
@@ -232,18 +238,19 @@ stop_critical_timing(unsigned long ip, u
 	atomic_inc(&data->disabled);
 	local_save_flags(flags);
 	tracing_function_trace(tr, data, ip, parent_ip, flags);
-	check_critical_timing(tr, data, parent_ip, cpu);
+	check_critical_timing(tr, data, parent_ip ? : ip, cpu);
 	data->critical_start = 0;
 	atomic_dec(&data->disabled);
 }
 
+/* start and stop critical timings used to for stoppage (in idle) */
 void notrace start_critical_timings(void)
 {
 	unsigned long flags;
 
 	local_save_flags(flags);
 
-	if (irqs_disabled_flags(flags))
+	if (preempt_trace() || irqs_disabled_flags(flags))
 		start_critical_timing(CALLER_ADDR0, 0);
 }
 
@@ -253,10 +260,11 @@ void notrace stop_critical_timings(void)
 
 	local_save_flags(flags);
 
-	if (irqs_disabled_flags(flags))
+	if (preempt_trace() || irqs_disabled_flags(flags))
 		stop_critical_timing(CALLER_ADDR0, 0);
 }
 
+#ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
 #ifdef CONFIG_LOCKDEP
 void notrace time_hardirqs_on(unsigned long a0, unsigned long a1)
 {
@@ -264,7 +272,7 @@ void notrace time_hardirqs_on(unsigned l
 
 	local_save_flags(flags);
 
-	if (irqs_disabled_flags(flags))
+	if (!preempt_trace() && irqs_disabled_flags(flags))
 		stop_critical_timing(a0, a1);
 }
 
@@ -274,7 +282,7 @@ void notrace time_hardirqs_off(unsigned 
 
 	local_save_flags(flags);
 
-	if (irqs_disabled_flags(flags))
+	if (!preempt_trace() && irqs_disabled_flags(flags))
 		start_critical_timing(a0, a1);
 }
 
@@ -313,7 +321,7 @@ void notrace trace_hardirqs_on(void)
 
 	local_save_flags(flags);
 
-	if (irqs_disabled_flags(flags))
+	if (!preempt_trace() && irqs_disabled_flags(flags))
 		stop_critical_timing(CALLER_ADDR0, 0);
 }
 EXPORT_SYMBOL(trace_hardirqs_on);
@@ -324,7 +332,7 @@ void notrace trace_hardirqs_off(void)
 
 	local_save_flags(flags);
 
-	if (irqs_disabled_flags(flags))
+	if (!preempt_trace() && irqs_disabled_flags(flags))
 		start_critical_timing(CALLER_ADDR0, 0);
 }
 EXPORT_SYMBOL(trace_hardirqs_off);
@@ -335,7 +343,7 @@ void notrace trace_hardirqs_on_caller(un
 
 	local_save_flags(flags);
 
-	if (irqs_disabled_flags(flags))
+	if (!preempt_trace() && irqs_disabled_flags(flags))
 		stop_critical_timing(CALLER_ADDR0, caller_addr);
 }
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
@@ -346,13 +354,25 @@ void notrace trace_hardirqs_off_caller(u
 
 	local_save_flags(flags);
 
-	if (irqs_disabled_flags(flags))
+	if (!preempt_trace() && irqs_disabled_flags(flags))
 		start_critical_timing(CALLER_ADDR0, caller_addr);
 }
 EXPORT_SYMBOL(trace_hardirqs_off_caller);
 
 #endif /* CONFIG_LOCKDEP */
+#endif /*  CONFIG_CRITICAL_IRQSOFF_TIMING */
 
+#ifdef CONFIG_CRITICAL_PREEMPT_TIMING
+void notrace trace_preempt_on(unsigned long a0, unsigned long a1)
+{
+	stop_critical_timing(a0, a1);
+}
+
+void notrace trace_preempt_off(unsigned long a0, unsigned long a1)
+{
+	start_critical_timing(a0, a1);
+}
+#endif /* CONFIG_CRITICAL_PREEMPT_TIMING */
 
 #ifdef CONFIG_MCOUNT
 static void notrace irqsoff_trace_call(unsigned long ip,
Index: linux-compile.git/include/linux/preempt.h
===================================================================
--- linux-compile.git.orig/include/linux/preempt.h	2008-01-15 14:51:22.000000000 -0500
+++ linux-compile.git/include/linux/preempt.h	2008-01-15 15:15:32.000000000 -0500
@@ -10,7 +10,7 @@
 #include <linux/linkage.h>
 #include <linux/list.h>
 
-#ifdef CONFIG_DEBUG_PREEMPT
+#if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_CRITICAL_PREEMPT_TIMING)
   extern void fastcall add_preempt_count(int val);
   extern void fastcall sub_preempt_count(int val);
 #else
Index: linux-compile.git/kernel/sched.c
===================================================================
--- linux-compile.git.orig/kernel/sched.c	2008-01-15 15:08:46.000000000 -0500
+++ linux-compile.git/kernel/sched.c	2008-01-15 15:15:32.000000000 -0500
@@ -63,6 +63,7 @@
 #include <linux/reciprocal_div.h>
 #include <linux/unistd.h>
 #include <linux/pagemap.h>
+#include <linux/mcount.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -3502,26 +3503,44 @@ void scheduler_tick(void)
 #endif
 }
 
-#if defined(CONFIG_PREEMPT) && defined(CONFIG_DEBUG_PREEMPT)
+#if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
+				defined(CONFIG_CRITICAL_PREEMPT_TIMING))
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
 
 void fastcall add_preempt_count(int val)
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
 
 void fastcall sub_preempt_count(int val)
 {
+#ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Underflow?
 	 */
@@ -3533,7 +3552,10 @@ void fastcall sub_preempt_count(int val)
 	if (DEBUG_LOCKS_WARN_ON((val < PREEMPT_MASK) &&
 			!(preempt_count() & PREEMPT_MASK)))
 		return;
+#endif
 
+	if (preempt_count() == val)
+		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 	preempt_count() -= val;
 }
 EXPORT_SYMBOL(sub_preempt_count);
Index: linux-compile.git/arch/x86/kernel/process_32.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/process_32.c	2008-01-15 14:54:17.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/process_32.c	2008-01-15 15:15:32.000000000 -0500
@@ -195,7 +195,10 @@ void cpu_idle(void)
 				play_dead();
 
 			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
+			/* Don't trace irqs off for idle */
+			stop_critical_timings();
 			idle();
+			start_critical_timings();
 		}
 		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
Index: linux-compile.git/include/linux/mcount.h
===================================================================
--- linux-compile.git.orig/include/linux/mcount.h	2008-01-15 15:07:18.000000000 -0500
+++ linux-compile.git/include/linux/mcount.h	2008-01-15 15:15:32.000000000 -0500
@@ -58,4 +58,12 @@ extern void mcount(void);
 # define time_hardirqs_off(a0, a1)		do { } while (0)
 #endif
 
+#ifdef CONFIG_CRITICAL_PREEMPT_TIMING
+  extern void notrace trace_preempt_on(unsigned long a0, unsigned long a1);
+  extern void notrace trace_preempt_off(unsigned long a0, unsigned long a1);
+#else
+# define trace_preempt_on(a0, a1)		do { } while (0)
+# define trace_preempt_off(a0, a1)		do { } while (0)
+#endif
+
 #endif /* _LINUX_MCOUNT_H */
Index: linux-compile.git/include/linux/irqflags.h
===================================================================
--- linux-compile.git.orig/include/linux/irqflags.h	2008-01-15 15:07:18.000000000 -0500
+++ linux-compile.git/include/linux/irqflags.h	2008-01-15 15:15:32.000000000 -0500
@@ -54,7 +54,8 @@
 # define INIT_TRACE_IRQFLAGS
 #endif
 
-#ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
+#if defined(CONFIG_CRITICAL_IRQSOFF_TIMING) || \
+	defined(CONFIG_CRITICAL_PREEMPT_TIMING)
  extern void stop_critical_timings(void);
  extern void start_critical_timings(void);
 #else

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbYKLXij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbYKLXij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbYKLXeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:34:25 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:48522 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbYKLXeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:34:17 -0500
Message-Id: <20081112232300.990723237@polymtl.ca>
References: <20081112231551.473569400@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 18:16:08 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 17/17] x86 trace clock
Content-Disposition: inline; filename=x86-trace-clock.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 12 Nov 2008 23:33:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86 trace clock. Depends on tsc_sync to detect if timestamp counters are
synchronized on the machine.

I am leaving this poorly scalable solution for now as this is the simplest, yet
working, solution I found (compared to using the HPET which also scales very
poorly, probably due to bus contention). This should be a good start and let us
trace a good amount of machines out there.

A "Big Fat" (TM) warning is shown on the console when the trace clock is used on
systems without synchronized TSCs to tell the user to

- use force_tsc_sync=1
- use idle=poll
- disable Powernow or Speedstep

In order to get accurate and fast timestamps.

This keeps room for further improvement in a second phase.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/Kconfig              |    1 
 arch/x86/kernel/Makefile      |    1 
 arch/x86/kernel/trace-clock.c |  248 ++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/trace-clock.h |   70 +++++++++++
 4 files changed, 320 insertions(+)

Index: linux.trees.git/arch/x86/Kconfig
===================================================================
--- linux.trees.git.orig/arch/x86/Kconfig	2008-11-12 18:02:33.000000000 -0500
+++ linux.trees.git/arch/x86/Kconfig	2008-11-12 18:04:25.000000000 -0500
@@ -27,6 +27,7 @@ config X86
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_KRETPROBES
+	select HAVE_TRACE_CLOCK
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
Index: linux.trees.git/arch/x86/kernel/Makefile
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/Makefile	2008-11-12 18:02:33.000000000 -0500
+++ linux.trees.git/arch/x86/kernel/Makefile	2008-11-12 18:04:09.000000000 -0500
@@ -36,6 +36,7 @@ obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
 obj-y			+= tsc.o io_delay.o rtc.o
+obj-$(CONFIG_HAVE_TRACE_CLOCK)	+= trace-clock.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
Index: linux.trees.git/arch/x86/kernel/trace-clock.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/arch/x86/kernel/trace-clock.c	2008-11-12 18:04:09.000000000 -0500
@@ -0,0 +1,248 @@
+/*
+ * arch/x86/kernel/trace-clock.c
+ *
+ * Trace clock for x86.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, October 2008
+ */
+
+#include <linux/module.h>
+#include <linux/trace-clock.h>
+#include <linux/jiffies.h>
+#include <linux/mutex.h>
+#include <linux/timer.h>
+#include <linux/cpu.h>
+
+static cycles_t trace_clock_last_tsc;
+static DEFINE_PER_CPU(struct timer_list, update_timer);
+static DEFINE_MUTEX(async_tsc_mutex);
+static int async_tsc_refcount;	/* Number of readers */
+static int async_tsc_enabled;	/* Async TSC enabled on all online CPUs */
+
+int _trace_clock_is_sync = 1;
+EXPORT_SYMBOL_GPL(_trace_clock_is_sync);
+
+/*
+ * Called by check_tsc_sync_source from CPU hotplug.
+ */
+void set_trace_clock_is_sync(int state)
+{
+	_trace_clock_is_sync = state;
+}
+
+#if BITS_PER_LONG == 64
+static cycles_t read_last_tsc(void)
+{
+	return trace_clock_last_tsc;
+}
+#else
+/*
+ * A cmpxchg64 update can happen concurrently. Based on the assumption that
+ * two cmpxchg64 will never update it to the same value (the count always
+ * increases), reading it twice insures that we read a coherent value with the
+ * same "sequence number".
+ */
+static cycles_t read_last_tsc(void)
+{
+	cycles_t val1, val2;
+
+	val1 = trace_clock_last_tsc;
+	for (;;) {
+		val2 = val1;
+		barrier();
+		val1 = trace_clock_last_tsc;
+		if (likely(val1 == val2))
+			break;
+	}
+	return val1;
+}
+#endif
+
+/*
+ * Support for architectures with non-sync TSCs.
+ * When the local TSC is discovered to lag behind the highest TSC counter, we
+ * increment the TSC count of an amount that should be, ideally, lower than the
+ * execution time of this routine, in cycles : this is the granularity we look
+ * for : we must be able to order the events.
+ */
+notrace cycles_t trace_clock_async_tsc_read(void)
+{
+	cycles_t new_tsc, last_tsc;
+
+	WARN_ON(!async_tsc_refcount || !async_tsc_enabled);
+	rdtsc_barrier();
+	new_tsc = get_cycles();
+	rdtsc_barrier();
+	last_tsc = read_last_tsc();
+	do {
+		if (new_tsc < last_tsc)
+			new_tsc = last_tsc + TRACE_CLOCK_MIN_PROBE_DURATION;
+		/*
+		 * If cmpxchg fails with a value higher than the new_tsc, don't
+		 * retry : the value has been incremented and the events
+		 * happened almost at the same time.
+		 * We must retry if cmpxchg fails with a lower value :
+		 * it means that we are the CPU with highest frequency and
+		 * therefore MUST update the value.
+		 */
+		last_tsc = cmpxchg64(&trace_clock_last_tsc, last_tsc, new_tsc);
+	} while (unlikely(last_tsc < new_tsc));
+	return new_tsc;
+}
+EXPORT_SYMBOL_GPL(trace_clock_async_tsc_read);
+
+static void update_timer_ipi(void *info)
+{
+	(void)trace_clock_async_tsc_read();
+}
+
+/*
+ * update_timer_fct : - Timer function to resync the clocks
+ * @data: unused
+ *
+ * Fires every jiffy.
+ */
+static void update_timer_fct(unsigned long data)
+{
+	(void)trace_clock_async_tsc_read();
+
+	per_cpu(update_timer, smp_processor_id()).expires = jiffies + 1;
+	add_timer_on(&per_cpu(update_timer, smp_processor_id()),
+		     smp_processor_id());
+}
+
+static void enable_trace_clock(int cpu)
+{
+	init_timer(&per_cpu(update_timer, cpu));
+	per_cpu(update_timer, cpu).function = update_timer_fct;
+	per_cpu(update_timer, cpu).expires = jiffies + 1;
+	smp_call_function_single(cpu, update_timer_ipi, NULL, 1);
+	add_timer_on(&per_cpu(update_timer, cpu), cpu);
+}
+
+static void disable_trace_clock(int cpu)
+{
+	del_timer_sync(&per_cpu(update_timer, cpu));
+}
+
+/*
+ * 	hotcpu_callback - CPU hotplug callback
+ * 	@nb: notifier block
+ * 	@action: hotplug action to take
+ * 	@hcpu: CPU number
+ *
+ * 	Returns the success/failure of the operation. (NOTIFY_OK, NOTIFY_BAD)
+ */
+static int __cpuinit hotcpu_callback(struct notifier_block *nb,
+				unsigned long action,
+				void *hcpu)
+{
+	unsigned int hotcpu = (unsigned long)hcpu;
+	int cpu;
+
+	mutex_lock(&async_tsc_mutex);
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		break;
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		/*
+		 * trace_clock_is_sync() is updated by set_trace_clock_is_sync()
+		 * code, protected by cpu hotplug disable.
+		 * It is ok to let the hotplugged CPU read the timebase before
+		 * the CPU_ONLINE notification. It's just there to give a
+		 * maximum bound to the TSC error.
+		 */
+		if (async_tsc_refcount && !trace_clock_is_sync()) {
+			if (!async_tsc_enabled) {
+				async_tsc_enabled = 1;
+				for_each_online_cpu(cpu)
+					enable_trace_clock(cpu);
+			} else {
+				enable_trace_clock(hotcpu);
+			}
+		}
+		break;
+#ifdef CONFIG_HOTPLUG_CPU
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		if (!async_tsc_refcount && num_online_cpus() == 1)
+			set_trace_clock_is_sync(1);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		/*
+		 * We cannot stop the trace clock on other CPUs when readers are
+		 * active even if we go back to a synchronized state (1 CPU)
+		 * because the CPU left could be the one lagging behind.
+		 */
+		if (async_tsc_refcount && async_tsc_enabled)
+			disable_trace_clock(hotcpu);
+		if (!async_tsc_refcount && num_online_cpus() == 1)
+			set_trace_clock_is_sync(1);
+		break;
+#endif /* CONFIG_HOTPLUG_CPU */
+	}
+	mutex_unlock(&async_tsc_mutex);
+
+	return NOTIFY_OK;
+}
+
+void get_trace_clock(void)
+{
+	int cpu;
+
+	if (!trace_clock_is_sync()) {
+		printk(KERN_WARNING
+			"Trace clock falls back on cache-line bouncing\n"
+			"workaround due to non-synchronized TSCs.\n"
+			"This workaround preserves event order across CPUs.\n"
+			"Please consider disabling Speedstep or PowerNow and\n"
+			"using kernel parameters "
+			"\"force_tsc_sync=1 idle=poll\"\n"
+			"for accurate and fast tracing clock source.\n");
+	}
+
+	get_online_cpus();
+	mutex_lock(&async_tsc_mutex);
+	if (async_tsc_refcount++ || trace_clock_is_sync())
+		goto end;
+
+	async_tsc_enabled = 1;
+	for_each_online_cpu(cpu)
+		enable_trace_clock(cpu);
+end:
+	mutex_unlock(&async_tsc_mutex);
+	put_online_cpus();
+}
+EXPORT_SYMBOL_GPL(get_trace_clock);
+
+void put_trace_clock(void)
+{
+	int cpu;
+
+	get_online_cpus();
+	mutex_lock(&async_tsc_mutex);
+	WARN_ON(async_tsc_refcount <= 0);
+	if (async_tsc_refcount != 1 || !async_tsc_enabled)
+		goto end;
+
+	for_each_online_cpu(cpu)
+		disable_trace_clock(cpu);
+	async_tsc_enabled = 0;
+end:
+	async_tsc_refcount--;
+	if (!async_tsc_refcount && num_online_cpus() == 1)
+		set_trace_clock_is_sync(1);
+	mutex_unlock(&async_tsc_mutex);
+	put_online_cpus();
+}
+EXPORT_SYMBOL_GPL(put_trace_clock);
+
+static __init int init_unsync_trace_clock(void)
+{
+	hotcpu_notifier(hotcpu_callback, 4);
+	return 0;
+}
+early_initcall(init_unsync_trace_clock);
Index: linux.trees.git/include/asm-x86/trace-clock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/asm-x86/trace-clock.h	2008-11-12 18:04:09.000000000 -0500
@@ -0,0 +1,70 @@
+#ifndef _ASM_X86_TRACE_CLOCK_H
+#define _ASM_X86_TRACE_CLOCK_H
+
+/*
+ * linux/include/asm-x86/trace-clock.h
+ *
+ * Copyright (C) 2005,2006,2008
+ *   Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca)
+ *
+ * Trace clock definitions for x86.
+ */
+
+#include <linux/timex.h>
+#include <asm/system.h>
+#include <asm/processor.h>
+#include <asm/atomic.h>
+
+/* Minimum duration of a probe, in cycles */
+#define TRACE_CLOCK_MIN_PROBE_DURATION 200
+
+extern cycles_t trace_clock_async_tsc_read(void);
+
+extern int _trace_clock_is_sync;
+static inline int trace_clock_is_sync(void)
+{
+	return _trace_clock_is_sync;
+}
+
+static inline u32 trace_clock_read32(void)
+{
+	u32 cycles;
+
+	if (likely(trace_clock_is_sync())) {
+		get_cycles_barrier();
+		cycles = (u32)get_cycles(); /* only need the 32 LSB */
+		get_cycles_barrier();
+	} else
+		cycles = (u32)trace_clock_async_tsc_read();
+	return cycles;
+}
+
+static inline u64 trace_clock_read64(void)
+{
+	u64 cycles;
+
+	if (likely(trace_clock_is_sync())) {
+		get_cycles_barrier();
+		cycles = get_cycles();
+		get_cycles_barrier();
+	} else
+		cycles = trace_clock_async_tsc_read();
+	return cycles;
+}
+
+static inline unsigned int trace_clock_frequency(void)
+{
+	return cpu_khz;
+}
+
+static inline u32 trace_clock_freq_scale(void)
+{
+	return 1000;
+}
+
+extern void get_trace_clock(void);
+extern void put_trace_clock(void);
+
+extern void set_trace_clock_is_sync(int state);
+
+#endif /* _ASM_X86_TRACE_CLOCK_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

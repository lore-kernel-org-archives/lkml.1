Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbYKLXiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbYKLXiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbYKLXeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:34:23 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:48514 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbYKLXeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:34:17 -0500
Message-Id: <20081112232259.370634580@polymtl.ca>
References: <20081112231551.473569400@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 18:15:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ralf Baechle <ralf@linux-mips.org>, benh@kernel.crashing.org,
       paulus@samba.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch@vger.kernel.org
Subject: [patch 07/17] Trace clock generic
Content-Disposition: inline; filename=trace-clock-generic.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 12 Nov 2008 23:33:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrapper to use the lower level clock sources available on the systems. Fall-back
on a counter incremented by a timer interrupt every jiffy or'd with a logical
clock for architectures lacking CPU timestamp counters.

A generic fallback based on a logical clock and the timer interrupt is
available.

generic - Uses jiffies or'd with a logical clock extended to 64 bits by
          trace-clock-32-to-64.
i386 - Uses TSC. If detects non synchronized TSC, uses mixed TSC-logical clock.
mips - Uses TSC extended atomically from 32 to 64 bits by trace-clock-32-to-64.
powerpc - Uses TSC.
sparc64 - Uses TSC.
x86_64 - Uses TSC. If detects non synchronized TSC, uses mixed TSC-logical clock

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: benh@kernel.crashing.org
CC: paulus@samba.org
CC: David Miller <davem@davemloft.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: linux-arch@vger.kernel.org
---
 include/asm-generic/trace-clock.h |   64 +++++++++++++++++++++++++
 include/linux/trace-clock.h       |   17 ++++++
 init/Kconfig                      |    6 ++
 kernel/trace/Makefile             |    1 
 kernel/trace/trace-clock.c        |   97 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 185 insertions(+)

Index: linux.trees.git/include/asm-generic/trace-clock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/asm-generic/trace-clock.h	2008-11-12 18:01:18.000000000 -0500
@@ -0,0 +1,64 @@
+#ifndef _ASM_GENERIC_TRACE_CLOCK_H
+#define _ASM_GENERIC_TRACE_CLOCK_H
+
+/*
+ * include/asm-generic/trace-clock.h
+ *
+ * Copyright (C) 2007 - Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca)
+ *
+ * Generic tracing clock for architectures without TSC.
+ */
+
+#include <linux/param.h>	/* For HZ */
+#include <asm/atomic.h>
+
+#define TRACE_CLOCK_SHIFT 13
+
+extern atomic_long_t trace_clock;
+
+static inline u32 trace_clock_read32(void)
+{
+	return (u32)atomic_long_add_return(1, &trace_clock);
+}
+
+#ifdef CONFIG_HAVE_TRACE_CLOCK_32_TO_64
+extern u64 trace_clock_read_synthetic_tsc(void);
+extern void get_synthetic_tsc(void);
+extern void put_synthetic_tsc(void);
+
+static inline u64 trace_clock_read64(void)
+{
+	return trace_clock_read_synthetic_tsc();
+}
+#else
+static inline void get_synthetic_tsc(void)
+{
+}
+
+static inline void put_synthetic_tsc(void)
+{
+}
+
+static inline u64 trace_clock_read64(void)
+{
+	return atomic_long_add_return(1, &trace_clock);
+}
+#endif
+
+static inline unsigned int trace_clock_frequency(void)
+{
+	return HZ << TRACE_CLOCK_SHIFT;
+}
+
+static inline u32 trace_clock_freq_scale(void)
+{
+	return 1;
+}
+
+extern void get_trace_clock(void);
+extern void put_trace_clock(void);
+
+static inline void set_trace_clock_is_sync(int state)
+{
+}
+#endif /* _ASM_GENERIC_TRACE_CLOCK_H */
Index: linux.trees.git/include/linux/trace-clock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/trace-clock.h	2008-11-12 18:01:18.000000000 -0500
@@ -0,0 +1,17 @@
+#ifndef _LINUX_TRACE_CLOCK_H
+#define _LINUX_TRACE_CLOCK_H
+
+/*
+ * Trace clock
+ *
+ * Chooses between an architecture specific clock or an atomic logical clock.
+ *
+ * Copyright (C) 2007,2008 Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca)
+ */
+
+#ifdef CONFIG_HAVE_TRACE_CLOCK
+#include <asm/trace-clock.h>
+#else
+#include <asm-generic/trace-clock.h>
+#endif /* CONFIG_HAVE_TRACE_CLOCK */
+#endif /* _LINUX_TRACE_CLOCK_H */
Index: linux.trees.git/kernel/trace/trace-clock.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/kernel/trace/trace-clock.c	2008-11-12 18:01:18.000000000 -0500
@@ -0,0 +1,97 @@
+/*
+ * kernel/trace/trace-clock.c
+ *
+ * (C) Copyright	2008 -
+ * 		Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca)
+ *
+ * Generic kernel tracing clock for architectures without TSC.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+#include <linux/cpu.h>
+#include <linux/timex.h>
+#include <linux/bitops.h>
+#include <linux/trace-clock.h>
+#include <linux/jiffies.h>
+
+static int trace_clock_refcount;
+static DEFINE_MUTEX(trace_clock_mutex);
+static struct timer_list trace_clock_timer;
+/*
+ * bits 0..12 : counter, atomically incremented
+ * bits 13..{32,64} : time counter, incremented each jiffy.
+ */
+atomic_long_t trace_clock;
+EXPORT_SYMBOL(trace_clock);
+
+static void trace_clock_update(void)
+{
+	long old_clock, new_clock;
+	unsigned long ticks;
+
+	/*
+	 * Make sure we keep track of delayed timer.
+	 */
+	ticks = jiffies - trace_clock_timer.expires + 1;
+	/* Don't update if ticks is zero, time would go backward. */
+	if (unlikely(!ticks))
+		return;
+	do {
+		old_clock = atomic_long_read(&trace_clock);
+		new_clock = (old_clock + (ticks << TRACE_CLOCK_SHIFT))
+			& (~((1 << TRACE_CLOCK_SHIFT) - 1));
+	} while (atomic_long_cmpxchg(&trace_clock, old_clock, new_clock)
+			!= old_clock);
+}
+
+static void trace_clock_timer_fct(unsigned long data)
+{
+	trace_clock_update();
+	trace_clock_timer.expires = jiffies + 1;
+	add_timer(&trace_clock_timer);
+}
+
+static void enable_trace_clock(void)
+{
+	init_timer(&trace_clock_timer);
+	/* trace_clock_update() reads expires */
+	trace_clock_timer.function = trace_clock_timer_fct;
+	trace_clock_timer.expires = jiffies + 1;
+	trace_clock_update();
+	add_timer(&trace_clock_timer);
+}
+
+static void disable_trace_clock(void)
+{
+	del_timer_sync(&trace_clock_timer);
+}
+
+void get_trace_clock(void)
+{
+	get_synthetic_tsc();
+	mutex_lock(&trace_clock_mutex);
+	if (trace_clock_refcount++)
+		goto end;
+	enable_trace_clock();
+end:
+	mutex_unlock(&trace_clock_mutex);
+}
+EXPORT_SYMBOL_GPL(get_trace_clock);
+
+void put_trace_clock(void)
+{
+	mutex_lock(&trace_clock_mutex);
+	WARN_ON(trace_clock_refcount <= 0);
+	if (trace_clock_refcount != 1)
+		goto end;
+	disable_trace_clock();
+end:
+	trace_clock_refcount--;
+	mutex_unlock(&trace_clock_mutex);
+	put_synthetic_tsc();
+}
+EXPORT_SYMBOL_GPL(put_trace_clock);
Index: linux.trees.git/init/Kconfig
===================================================================
--- linux.trees.git.orig/init/Kconfig	2008-11-12 18:00:31.000000000 -0500
+++ linux.trees.git/init/Kconfig	2008-11-12 18:01:18.000000000 -0500
@@ -346,6 +346,12 @@ config HAVE_GET_CYCLES
 config HAVE_TRACE_CLOCK
 	def_bool n
 
+config HAVE_TRACE_CLOCK_GENERIC
+	bool
+	default y if (!HAVE_TRACE_CLOCK)
+	default n if HAVE_TRACE_CLOCK
+	select HAVE_TRACE_CLOCK_32_TO_64 if (!64BIT)
+
 #
 # Architectures with only a 32-bits clock source should select this.
 #
Index: linux.trees.git/kernel/trace/Makefile
===================================================================
--- linux.trees.git.orig/kernel/trace/Makefile	2008-11-12 18:00:47.000000000 -0500
+++ linux.trees.git/kernel/trace/Makefile	2008-11-12 18:01:18.000000000 -0500
@@ -25,5 +25,6 @@ obj-$(CONFIG_STACK_TRACER) += trace_stac
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 obj-$(CONFIG_HAVE_TRACE_CLOCK_32_TO_64) += trace-clock-32-to-64.o
+obj-$(CONFIG_HAVE_TRACE_CLOCK_GENERIC) += trace-clock.o
 
 libftrace-y := ftrace.o

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbYKGFrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbYKGFrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbYKGFon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:44:43 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:60991 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362AbYKGFok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:44:40 -0500
Message-Id: <20081107053349.533903418@polymtl.ca>
References: <20081107052336.652868737@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 00:23:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ralf Baechle <ralf@linux-mips.org>, benh@kernel.crashing.org,
       paulus@samba.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: [RFC patch 06/18] Trace clock generic
Content-Disposition: inline; filename=trace-clock-generic.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  7 Nov 2008 05:43:22 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrapper to use the lower level clock sources available on the systems. Fall-back
on jiffies or'd with a logical clock for architectures lacking CPU timestamp
counters. Fall-back on a mixed TSC-logical clock on architectures lacking
synchronized TSC on SMP.

A generic fallback based on a logical clock and the timer interrupt is
available.

generic - Uses jiffies or'd with a logical clock extended to 64 bits by
          ltt-timestamp.c.
i386 - Uses TSC. If detects non synchronized TSC, uses mixed TSC-logical clock.
mips - Uses TSC extended atomically from 32 to 64 bits by ltt-heartbeat.c.
powerpc - Uses TSC or generic ltt clock.
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
 include/asm-generic/trace-clock.h |   69 ++++++++++++++++++++++++++++++++++++++
 include/linux/trace-clock.h       |   17 +++++++++
 kernel/timer.c                    |    2 +
 3 files changed, 88 insertions(+)

Index: linux.trees.git/kernel/timer.c
===================================================================
--- linux.trees.git.orig/kernel/timer.c	2008-10-06 10:23:39.000000000 -0400
+++ linux.trees.git/kernel/timer.c	2008-11-07 00:10:13.000000000 -0500
@@ -37,6 +37,7 @@
 #include <linux/delay.h>
 #include <linux/tick.h>
 #include <linux/kallsyms.h>
+#include <linux/trace-clock.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -1067,6 +1068,7 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_times(ticks);
+	trace_clock_add_timestamp(ticks);
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM
Index: linux.trees.git/include/asm-generic/trace-clock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/asm-generic/trace-clock.h	2008-11-07 00:10:13.000000000 -0500
@@ -0,0 +1,69 @@
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
+u64 trace_clock_read_synthetic_tsc(void);
+
+extern atomic_t trace_clock;
+
+static inline u32 trace_clock_read32(void)
+{
+	return atomic_add_return(1, &trace_clock);
+}
+
+static inline u64 trace_clock_read64(void)
+{
+	return trace_clock_read_synthetic_tsc();
+}
+
+static inline void trace_clock_add_timestamp(unsigned long ticks)
+{
+	int old_clock, new_clock;
+
+	do {
+		old_clock = atomic_read(&trace_clock);
+		new_clock = (old_clock + (ticks << TRACE_CLOCK_SHIFT))
+			& (~((1 << TRACE_CLOCK_SHIFT) - 1));
+	} while (atomic_cmpxchg(&trace_clock, old_clock, new_clock)
+			!= old_clock);
+}
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
+extern void get_synthetic_tsc(void);
+extern void put_synthetic_tsc(void);
+
+static inline void get_trace_clock(void)
+{
+	get_synthetic_tsc();
+}
+
+static inline void put_trace_clock(void)
+{
+	put_synthetic_tsc();
+}
+
+static inline void set_trace_clock_is_sync(int state)
+{
+}
+#endif /* _ASM_GENERIC_TRACE_CLOCK_H */
Index: linux.trees.git/include/linux/trace-clock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/trace-clock.h	2008-11-07 00:10:13.000000000 -0500
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

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

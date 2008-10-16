Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbYJQABk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbYJQABk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757616AbYJPX4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:56:08 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48993 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429AbYJPX4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:56:05 -0400
Message-Id: <20081016234656.724741666@polymtl.ca>
References: <20081016232729.699004293@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Oct 2008 19:27:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ralf Baechle <ralf@linux-mips.org>, benh@kernel.crashing.org,
       paulus@samba.org, Ingo Molnar <mingo@redhat.com>
Subject: [RFC patch 08/15] LTTng - Timestamping
Content-Disposition: inline; filename=lttng-timestamp-generic.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 16 Oct 2008 23:54:45 +0000
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
 include/asm-generic/ltt.h |   53 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ltt.h       |   27 +++++++++++++++++++++++
 kernel/timer.c            |    2 +
 3 files changed, 82 insertions(+)

Index: linux-2.6-lttng/kernel/timer.c
===================================================================
--- linux-2.6-lttng.orig/kernel/timer.c	2008-09-16 14:50:15.000000000 -0400
+++ linux-2.6-lttng/kernel/timer.c	2008-09-16 14:59:17.000000000 -0400
@@ -37,6 +37,7 @@
 #include <linux/delay.h>
 #include <linux/tick.h>
 #include <linux/kallsyms.h>
+#include <linux/ltt.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -1066,6 +1067,7 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_times(ticks);
+	ltt_add_timestamp(ticks);
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM
Index: linux-2.6-lttng/include/linux/ltt.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/ltt.h	2008-09-16 14:58:47.000000000 -0400
@@ -0,0 +1,27 @@
+#ifndef _LINUX_LTT_H
+#define _LINUX_LTT_H
+
+/*
+ * Generic LTT clock.
+ *
+ * Chooses between an architecture specific clock or an atomic logical clock.
+ *
+ * Copyright (C) 2007 Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca)
+ */
+
+#ifdef CONFIG_LTT_TIMESTAMP
+#ifdef CONFIG_HAVE_LTT_CLOCK
+#include <asm/ltt.h>
+#else
+#include <asm-generic/ltt.h>
+
+#define ltt_get_timestamp32	ltt_get_timestamp32_generic
+#define ltt_get_timestamp64	ltt_get_timestamp64_generic
+#define ltt_add_timestamp	ltt_add_timestamp_generic
+#define ltt_frequency		ltt_frequency_generic
+#define ltt_freq_scale		ltt_freq_scale_generic
+#endif /* CONFIG_HAVE_LTT_CLOCK */
+#else
+#define ltt_add_timestamp(ticks)
+#endif /* CONFIG_LTT_TIMESTAMP */
+#endif /* _LINUX_LTT_H */
Index: linux-2.6-lttng/include/asm-generic/ltt.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-generic/ltt.h	2008-09-16 14:58:47.000000000 -0400
@@ -0,0 +1,53 @@
+#ifndef _ASM_GENERIC_LTT_H
+#define _ASM_GENERIC_LTT_H
+
+/*
+ * linux/include/asm-generic/ltt.h
+ *
+ * Copyright (C) 2007 - Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca)
+ *
+ * Generic definitions for LTT
+ * Architectures without TSC
+ */
+
+#include <linux/param.h>	/* For HZ */
+#include <asm/atomic.h>
+
+#define LTT_GENERIC_CLOCK_SHIFT 13
+
+u64 ltt_read_synthetic_tsc(void);
+
+extern atomic_t lttng_generic_clock;
+
+static inline u32 ltt_get_timestamp32_generic(void)
+{
+	return atomic_add_return(1, &lttng_generic_clock);
+}
+
+static inline u64 ltt_get_timestamp64_generic(void)
+{
+	return ltt_read_synthetic_tsc();
+}
+
+static inline void ltt_add_timestamp_generic(unsigned long ticks)
+{
+	int old_clock, new_clock;
+
+	do {
+		old_clock = atomic_read(&lttng_generic_clock);
+		new_clock = (old_clock + (ticks << LTT_GENERIC_CLOCK_SHIFT))
+			& (~((1 << LTT_GENERIC_CLOCK_SHIFT) - 1));
+	} while (atomic_cmpxchg(&lttng_generic_clock, old_clock, new_clock)
+			!= old_clock);
+}
+
+static inline unsigned int ltt_frequency_generic(void)
+{
+	return HZ << LTT_GENERIC_CLOCK_SHIFT;
+}
+
+static inline u32 ltt_freq_scale_generic(void)
+{
+	return 1;
+}
+#endif /* _ASM_GENERIC_LTT_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

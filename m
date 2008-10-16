Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbYJPX6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbYJPX6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbYJPXzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:55:44 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48857 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbYJPXzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:55:41 -0400
Message-Id: <20081016234657.837704867@polymtl.ca>
References: <20081016232729.699004293@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Oct 2008 19:27:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC patch 15/15] LTTng timestamp x86
Content-Disposition: inline; filename=lttng-timestamp-x86.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 16 Oct 2008 23:54:46 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86 LTTng timestamping. Depends on ltt-test-tsc module to detect if timestamp
counters are synchronized on the machine.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/Kconfig      |    2 
 include/asm-x86/ltt.h |  123 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)

Index: linux-2.6-lttng/include/asm-x86/ltt.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-x86/ltt.h	2008-10-16 18:53:27.000000000 -0400
@@ -0,0 +1,123 @@
+#ifndef _ASM_X86_LTT_H
+#define _ASM_X86_LTT_H
+/*
+ * linux/include/asm-x86/ltt.h
+ *
+ * Copyright (C) 2005,2006 - Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca)
+ *
+ * x86 time and TSC definitions for ltt
+ */
+
+#include <linux/timex.h>
+#include <asm/system.h>
+#include <asm/processor.h>
+#include <asm/atomic.h>
+
+/* Minimum duration of a probe, in cycles */
+#define LTT_MIN_PROBE_DURATION 200
+
+#ifdef CONFIG_HAVE_LTT_SYNTHETIC_TSC
+/* Only for testing. Never needed on x86. */
+u64 ltt_read_synthetic_tsc(void);
+#endif
+
+#ifdef CONFIG_HAVE_LTT_UNSTABLE_TSC
+extern cycles_t ltt_last_tsc;
+extern int ltt_tsc_is_sync;
+
+/*
+ * Support for architectures with non-sync TSCs.
+ * When the local TSC is discovered to lag behind the highest TSC counter, we
+ * increment the TSC count of an amount that should be, ideally, lower than the
+ * execution time of this routine, in cycles : this is the granularity we look
+ * for : we must be able to order the events.
+ */
+static inline cycles_t ltt_async_tsc_read(void)
+{
+	cycles_t new_tsc;
+	cycles_t last_tsc;
+
+	rdtsc_barrier();
+	new_tsc = get_cycles();
+	rdtsc_barrier();
+	do {
+		last_tsc = ltt_last_tsc;
+		if (new_tsc < last_tsc)
+			new_tsc = last_tsc + LTT_MIN_PROBE_DURATION;
+		/*
+		 * If cmpxchg fails with a value higher than the new_tsc, don't
+		 * retry : the value has been incremented and the events
+		 * happened almost at the same time.
+		 * We must retry if cmpxchg fails with a lower value :
+		 * it means that we are the CPU with highest frequency and
+		 * therefore MUST update the value.
+		 */
+	} while (cmpxchg64(&ltt_last_tsc, last_tsc, new_tsc) < new_tsc);
+	return new_tsc;
+}
+
+static inline u32 ltt_get_timestamp32(void)
+{
+	u32 cycles;
+
+	if (ltt_tsc_is_sync) {
+		rdtsc_barrier();
+		cycles = (u32)get_cycles(); /* only need the 32 LSB */
+		rdtsc_barrier();
+	} else
+		cycles = (u32)ltt_async_tsc_read();
+	return cycles;
+}
+
+static inline u64 ltt_get_timestamp64(void)
+{
+	u64 cycles;
+
+	if (ltt_tsc_is_sync) {
+		rdtsc_barrier();
+		cycles = get_cycles();
+		rdtsc_barrier();
+	} else
+		cycles = ltt_async_tsc_read();
+	return cycles;
+}
+#else /* CONFIG_HAVE_LTT_UNSTABLE_TSC */
+static inline u32 ltt_get_timestamp32(void)
+{
+	u32 cycles;
+
+	rdtsc_barrier();
+	cycles = (u32)get_cycles(); /* only need the 32 LSB */
+	rdtsc_barrier();
+	return cycles;
+}
+
+static inline u64 ltt_get_timestamp64(void)
+{
+	u64 cycles;
+
+	rdtsc_barrier();
+	cycles = get_cycles();
+	rdtsc_barrier();
+	return cycles;
+}
+#endif /* CONFIG_HAVE_LTT_UNSTABLE_TSC */
+
+/*
+ * Periodic IPI to have an upper bound on TSC inaccuracy.
+ * TODO: should implement this in ltt-test-tsc.ko.
+ */
+static inline void ltt_add_timestamp(unsigned long ticks)
+{ }
+
+static inline unsigned int ltt_frequency(void)
+{
+	return cpu_khz;
+}
+
+static inline u32 ltt_freq_scale(void)
+{
+	return 1000;
+}
+
+#endif /* _ASM_X86_LTT_H */
Index: linux-2.6-lttng/arch/x86/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig	2008-10-16 18:50:29.000000000 -0400
+++ linux-2.6-lttng/arch/x86/Kconfig	2008-10-16 18:53:09.000000000 -0400
@@ -26,6 +26,8 @@ config X86
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_KRETPROBES
+	select HAVE_LTT_CLOCK
+	select HAVE_LTT_UNSTABLE_TSC
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

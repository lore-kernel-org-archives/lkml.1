Return-Path: <linux-kernel-owner+w=401wt.eu-S1764853AbZE1Utu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764853AbZE1Utu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764884AbZE1Uti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:49:38 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:62341 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764929AbZE1Utg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:49:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lGlYRrfdTLQ+VxSmLT2QFyr+2GZtKllbwwIQ/fi89157nSPiEtrSkuikHrLbRc8Qhb
         i2tQE9tmWrAmJQBeDH7cvS5JXTqAVsuEpPtUXY37jdhhv/VoelDuiahoXsHvX+PxjfRU
         Rgo3DIfFcmXtkji0R206MszoJaSWhzWT6SBnA=
From: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wu Zhangjin <wuzj@lemote.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v1 4/5] mips specific clock function to get precise timestamp
Date: Fri, 29 May 2009 04:49:22 +0800
Message-Id: <d44adaf39284074c93a8dba0209da5b31d0d3c49.1243543471.git.wuzj@lemote.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1243543471.git.wuzj@lemote.com>
References: <cover.1243543471.git.wuzj@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

by default, ring_buffer_time_stamp calling sched_clock(jiffies-based)
function to get timestamp, in x86, there is a tsc(64bit) based
sched_clock, but in mips, the 'tsc'(clock counter) is only 32bit long,
which will easily rollover, and there is no precise sched_clock in mips,
we need to get one ourselves.

to avoid invading the whole linux-mips, i do not want to implement a
tsc-based native_sched_clock like x86 does. because, there is a need to
handling rollover of the only 32-bit long 'tsc' of mips, which will need
extra overhead. in reality, i have tried to implement one(just like the
ring_buffer_time_stamp here does), but make the kernel hangs when
booting, i am not sure why it not work.

herein, i just implement a mips-specific ring_buffer_time_stamp in
arch/mips/kernel/ftrace.c via adding  __attribute__((weak)) before
ring_buffer_time_stamp(...) {} in kernel/trace/ring_buffer.c and do
something in arch/mips/kernel/ftrace.c like this:

u64  ring_buffer_time_stamp \
       __attribute__((alias("native_ring_buffer_time_stamp")));

and, as the same, there is also a need to implement a mips-specific
trace_clock_local based on the above ring_buffer_timep_stamp, this clock
function is called in function graph tracer to get calltime & rettime of
a function.

and what about the trace_clock and trace_clock_global function, should
we also implement a mips-secific one? i am not sure.

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/kernel/Makefile       |    2 +
 arch/mips/kernel/csrc-r4k.c     |    2 +-
 arch/mips/kernel/ftrace_clock.c |   77 +++++++++++++++++++++++++++++++++++++++
 kernel/trace/ring_buffer.c      |    3 +-
 kernel/trace/trace_clock.c      |    2 +-
 5 files changed, 83 insertions(+), 3 deletions(-)
 create mode 100644 arch/mips/kernel/ftrace_clock.c

diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 6b1a8a5..5dec76f 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -12,6 +12,7 @@ ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
 CFLAGS_REMOVE_mcount.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
+CFLAGS_REMOVE_ftrace_clock.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
@@ -33,6 +34,7 @@ obj-$(CONFIG_MODULES)		+= mips_ksyms.o module.o
 
 obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o
+obj-$(CONFIG_NOP_TRACER)	+= ftrace_clock.o
 
 obj-$(CONFIG_CPU_LOONGSON2)	+= r4k_fpu.o r4k_switch.o
 obj-$(CONFIG_CPU_MIPS32)	+= r4k_fpu.o r4k_switch.o
diff --git a/arch/mips/kernel/csrc-r4k.c b/arch/mips/kernel/csrc-r4k.c
index e95a3cd..3da1c7a 100644
--- a/arch/mips/kernel/csrc-r4k.c
+++ b/arch/mips/kernel/csrc-r4k.c
@@ -10,7 +10,7 @@
 
 #include <asm/time.h>
 
-static cycle_t c0_hpt_read(struct clocksource *cs)
+static cycle_t notrace c0_hpt_read(struct clocksource *cs)
 {
 	return read_c0_count();
 }
diff --git a/arch/mips/kernel/ftrace_clock.c b/arch/mips/kernel/ftrace_clock.c
new file mode 100644
index 0000000..2f3b05a
--- /dev/null
+++ b/arch/mips/kernel/ftrace_clock.c
@@ -0,0 +1,77 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive for
+ * more details.
+ *
+ * Copyright (C) 2009 DSLab, Lanzhou University, China
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ */
+
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/jiffies.h>
+#include <linux/clocksource.h>
+#include <linux/ring_buffer.h>
+
+/* Up this if you want to test the TIME_EXTENTS and normalization */
+#ifndef DEBUG_SHIFT
+#define DEBUG_SHIFT 0
+#endif
+
+/* mips-specific ring_buffer_time_stamp implementation,
+ * the original one is defined in kernel/trace/ring_buffer.c
+ */
+
+u64 native_ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
+{
+	u64 current_cycles;
+	static unsigned long old_jiffies;
+	static u64 time, old_cycles;
+
+	preempt_disable_notrace();
+    /* update timestamp to avoid missing the timer interrupt */
+	if (time_before(jiffies, old_jiffies)) {
+		old_jiffies = jiffies;
+		time = sched_clock();
+		old_cycles = clock->cycle_last;
+	}
+	current_cycles = clock->read(clock);
+
+	time = (time + cyc2ns(clock, (current_cycles - old_cycles)
+				& clock->mask)) << DEBUG_SHIFT;
+
+	old_cycles = current_cycles;
+	preempt_enable_no_resched_notrace();
+
+	return time;
+}
+
+u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
+		__attribute__((alias("native_ring_buffer_time_stamp")));
+
+/*
+ * native_trace_clock_local(): the simplest and least coherent tracing clock.
+ *
+ * Useful for tracing that does not cross to other CPUs nor
+ * does it go through idle events.
+ */
+u64 native_trace_clock_local(void)
+{
+	unsigned long flags;
+	u64 clock;
+
+	/*
+	 * sched_clock() is an architecture implemented, fast, scalable,
+	 * lockless clock. It is not guaranteed to be coherent across
+	 * CPUs, nor across CPU idle events.
+	 */
+	raw_local_irq_save(flags);
+	clock = ring_buffer_time_stamp(NULL, raw_smp_processor_id());
+	raw_local_irq_restore(flags);
+
+	return clock;
+}
+
+u64 trace_clock_local(void)
+		__attribute__((alias("native_trace_clock_local")));
+
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 960cbf4..717bd8e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -420,7 +420,8 @@ struct ring_buffer_iter {
 /* Up this if you want to test the TIME_EXTENTS and normalization */
 #define DEBUG_SHIFT 0
 
-u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
+u64 __attribute__((weak)) ring_buffer_time_stamp(struct ring_buffer *buffer,
+				int cpu)
 {
 	u64 time;
 
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index b588fd8..78c98c8 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -26,7 +26,7 @@
  * Useful for tracing that does not cross to other CPUs nor
  * does it go through idle events.
  */
-u64 notrace trace_clock_local(void)
+u64 __attribute__((weak)) notrace trace_clock_local(void)
 {
 	unsigned long flags;
 	u64 clock;
-- 
1.6.0.4


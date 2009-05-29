Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbZE2PGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbZE2PGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759893AbZE2PGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:06:00 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:39836 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758AbZE2PF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:05:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OIKB15vhdRzPewfc/T4PIUJEVFM1J9srTPGqAP90oQjOX0+8sYmNfIFcEGKcgPTaLP
         IFh40OPc1lwNjxRvdogZWTfWXfQ56/nW2A1INjxJ/JVYmiNqZIz0KzNKNIWNNttk77aZ
         IFBB1ZVTQYuDd0yzqVYWHCjHpIQEyzguuvrmg=
From: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wu Zhangjin <wuzj@lemote.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v2 5/6] mips specific clock function to get precise timestamp
Date: Fri, 29 May 2009 23:05:42 +0800
Message-Id: <3a3cb6a251b274bffde37c12ee9851f1aec8d37b.1243604390.git.wuzj@lemote.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1243604390.git.wuzj@lemote.com>
References: <cover.1243604390.git.wuzj@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

by default, trace_clock_local calling sched_clock(jiffies-based) to get
timestamp, in x86, there is a tsc(64bit) based sched_clock, but in mips,
the 'tsc'(clock counter) is only 32bit long, which will easily rollover,
and there is no existing high precise sched_clock in mips, we need to
get one ourselves.

to avoid invading the whole linux-mips, i do not want to implement a
tsc-based native_sched_clock instead of sched_clock like x86 does.
because, there is a need to handling rollover of the only 32-bit long
'tsc' of mips, which will need extra overhead. in reality, i have tried
to do it, but made the kernel hangs when booting, I'm not sure why it
not work.

so, I just implement a native_sched_clock in arch/mips/kernel/ftrace.c,
but not override the original sched_clock(). to get high precise
timestamp, we implement a native_trace_clock_local, which will not call
original sched_clock again, but native_sched_clock().

and what about the trace_clock and trace_clock_global function, should
we also implement a mips-secific one? I'm not sure.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/kernel/Makefile       |    2 +
 arch/mips/kernel/csrc-r4k.c     |    2 +-
 arch/mips/kernel/ftrace_clock.c |   71 +++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_clock.c      |    2 +-
 4 files changed, 75 insertions(+), 2 deletions(-)
 create mode 100644 arch/mips/kernel/ftrace_clock.c

diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 8dabcc6..44ec7e0 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -11,6 +11,7 @@ obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
 ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
 CFLAGS_REMOVE_ftrace.o = -pg
+CFLAGS_REMOVE_ftrace_clock.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
@@ -32,6 +33,7 @@ obj-$(CONFIG_MODULES)		+= mips_ksyms.o module.o
 
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
index 0000000..8ad896e
--- /dev/null
+++ b/arch/mips/kernel/ftrace_clock.c
@@ -0,0 +1,71 @@
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
+
+/*
+ * mips-specific high precise sched_clock() implementation,
+ *
+ * currently, this is only needed in ftrace, so not override the original
+ * sched_clock().
+ */
+
+unsigned long long native_sched_clock(void)
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
+				& clock->mask));
+
+	old_cycles = current_cycles;
+	preempt_enable_no_resched_notrace();
+
+	return time;
+}
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
+	 * herein, we use the above native_sched_clock() to get high precise
+	 * timestamp, because the original sched_clock in mips is jiffies based,
+	 * which not have enough precision.
+	 */
+	raw_local_irq_save(flags);
+	clock = native_sched_clock();
+	raw_local_irq_restore(flags);
+
+	return clock;
+}
+
+u64 trace_clock_local(void)
+		__attribute__((alias("native_trace_clock_local")));
+
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


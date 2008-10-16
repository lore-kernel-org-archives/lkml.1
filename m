Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbYJPX7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbYJPX7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbYJPXzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:55:47 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48861 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbYJPXzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:55:43 -0400
Message-Id: <20081016234657.678118309@polymtl.ca>
References: <20081016232729.699004293@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Oct 2008 19:27:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [RFC patch 14/15] LTTng - TSC synchronicity test
Content-Disposition: inline; filename=lttng-test-tsc.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 16 Oct 2008 23:54:46 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test TSC synchronization across CPUs. Architecture independant and can therefore
be used on various architectures. Aims at testing the TSC synchronization on a
running system (not only at early boot), with minimal impact on interrupt
latency.

I've written this code before x86 tsc_sync.c existed and given it worked well
for my needs, I never switched to tsc_sync.c. Although it has the same goal, it
does it a bit differently :

tsc_sync looks at the cycle counters on two CPUs to see if one compared to the
other are going backward when read in loop. The LTTng code synchronizes both
cores with a counter used as a memory barrier and then reads the two TSCs at a
delta equal to the cache line exchange. Instruction and data caches are primed.
This test is repeated in loops to insure we deal with MCE, NMIs which could skew
the results.

The problem I see with tsc_sync.c is that is one of the two CPUs is delayed by
an interrupt handler (for way too long) while the other CPU is doing its
check_tsc_warp() execution, and if the CPU with the lowest TSC values runs
first, this code will fail to detect unsynchronized CPUs.

LTTng TSC sync test code does not have this problem.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@redhat.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 ltt/Kconfig        |    3 +
 ltt/Makefile       |    1 
 ltt/ltt-test-tsc.c |  132 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+)

Index: linux-2.6-lttng/ltt/ltt-test-tsc.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ltt/ltt-test-tsc.c	2008-10-16 18:53:07.000000000 -0400
@@ -0,0 +1,132 @@
+/*
+ * ltt-test-tsc.c
+ *
+ * Test TSC synchronization
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/timex.h>
+#include <linux/jiffies.h>
+#include <linux/cpu.h>
+#include <linux/kthread.h>
+#include <linux/mutex.h>
+
+#define MAX_CYCLES_DELTA 1000ULL
+
+static DEFINE_PER_CPU(cycles_t, tsc_count);
+static DEFINE_MUTEX(tscsync_mutex);
+
+static DEFINE_PER_CPU(int, wait_sync);
+static DEFINE_PER_CPU(int, wait_end_sync);
+
+int ltt_tsc_is_sync = 1;
+EXPORT_SYMBOL(ltt_tsc_is_sync);
+
+cycles_t ltt_last_tsc;
+EXPORT_SYMBOL(ltt_last_tsc);
+
+/*
+ * Mark it noinline so we make sure it is not unrolled.
+ * Wait until value is reached.
+ */
+static noinline void tsc_barrier(long wait_cpu, int value)
+{
+	sync_core();
+	per_cpu(wait_sync, smp_processor_id())--;
+	do {
+		smp_mb();
+	} while (unlikely(per_cpu(wait_sync, wait_cpu) > value));
+	rdtsc_barrier();
+	__get_cpu_var(tsc_count) = get_cycles();
+	rdtsc_barrier();
+}
+
+/*
+ * Worker thread called on each CPU.
+ * First wait with interrupts enabled, then wait with interrupt disabled,
+ * for precision. We are already bound to one CPU.
+ */
+static void test_sync(void *arg)
+{
+	long wait_cpu = (long)arg;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	/* Make sure the instructions are in I-CACHE */
+	tsc_barrier(wait_cpu, 1);
+	tsc_barrier(wait_cpu, 0);
+	per_cpu(wait_end_sync, smp_processor_id())--;
+	do {
+		smp_mb();
+	} while (unlikely(per_cpu(wait_end_sync, wait_cpu) > 1));
+	per_cpu(wait_end_sync, smp_processor_id())--;
+	local_irq_restore(flags);
+}
+
+/*
+ * Do loops (making sure no unexpected event changes the timing), keep the
+ * best one. The result of each loop is the highest tsc delta between the
+ * master CPU and the slaves.
+ */
+static int test_tsc_synchronization(void)
+{
+	long cpu, master;
+	cycles_t max_diff = 0, diff, best_loop, worse_loop = 0;
+	int i;
+
+	mutex_lock(&tscsync_mutex);
+	preempt_disable();
+	master = smp_processor_id();
+	for_each_online_cpu(cpu) {
+		if (master == cpu)
+			continue;
+		best_loop = ULLONG_MAX;
+		for (i = 0; i < 10; i++) {
+			/*
+			 * Each CPU (master and slave) must decrement the
+			 * wait_sync value twice (one for priming in cache).
+			 */
+			per_cpu(wait_sync, master) = 2;
+			per_cpu(wait_sync, cpu) = 2;
+			per_cpu(wait_end_sync, master) = 2;
+			per_cpu(wait_end_sync, cpu) = 2;
+			smp_call_function_single(cpu, test_sync,
+						(void *)master, 0);
+			test_sync((void *)cpu);
+			/*
+			 * Wait until slave is done so that we don't overwrite
+			 * wait_end_sync prematurely.
+			 */
+			while (unlikely(per_cpu(wait_end_sync, cpu) > 0))
+				cpu_relax();
+
+			diff = abs(per_cpu(tsc_count, cpu)
+				- per_cpu(tsc_count, master));
+			best_loop = min(best_loop, diff);
+			worse_loop = max(worse_loop, diff);
+		}
+		max_diff = max(best_loop, max_diff);
+	}
+	preempt_enable();
+	if (max_diff >= MAX_CYCLES_DELTA) {
+		printk(KERN_WARNING
+			"LTTng : Your timestamp counter is not reliable.\n"
+			"See LTTng documentation to find the "
+			"appropriate solution for your architecture.\n");
+		printk("TSC unsynchronized : %llu cycles delta is over "
+			"threshold %llu\n", max_diff, MAX_CYCLES_DELTA);
+	}
+	mutex_unlock(&tscsync_mutex);
+	return max_diff < MAX_CYCLES_DELTA;
+}
+EXPORT_SYMBOL_GPL(test_tsc_synchronization);
+
+static int __init tsc_test_init(void)
+{
+	ltt_tsc_is_sync = test_tsc_synchronization();
+	return 0;
+}
+
+__initcall(tsc_test_init);
Index: linux-2.6-lttng/ltt/Makefile
===================================================================
--- linux-2.6-lttng.orig/ltt/Makefile	2008-10-16 18:50:32.000000000 -0400
+++ linux-2.6-lttng/ltt/Makefile	2008-10-16 18:52:39.000000000 -0400
@@ -1 +1,2 @@
 obj-$(CONFIG_HAVE_LTT_SYNTHETIC_TSC)	+= ltt-timestamp.o
+obj-$(CONFIG_HAVE_LTT_UNSTABLE_TSC)	+= ltt-test-tsc.o
Index: linux-2.6-lttng/ltt/Kconfig
===================================================================
--- linux-2.6-lttng.orig/ltt/Kconfig	2008-10-16 18:50:32.000000000 -0400
+++ linux-2.6-lttng/ltt/Kconfig	2008-10-16 18:52:39.000000000 -0400
@@ -6,6 +6,9 @@ config LTT_TIMESTAMP
 	help
 	  Allow fine-grained timestamps to be taken from tracing applications.
 
+config HAVE_LTT_UNSTABLE_TSC
+	def_bool n
+
 config HAVE_LTT_CLOCK
 	def_bool n
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

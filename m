Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbYKLXka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbYKLXka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYKLXes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:34:48 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:48613 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586AbYKLXer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:34:47 -0500
Message-Id: <20081112232300.017118352@polymtl.ca>
References: <20081112231551.473569400@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 18:16:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 11/17] LTTng - TSC synchronicity test
Content-Disposition: inline; filename=test-tsc-sync.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 12 Nov 2008 23:33:02 +0000
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

This sync test code does not have this problem.

A following patch replaces the x86 tsc_sync.c code by this architecture
independant code.

This code also adds the kernel parameter
force_tsc_sync=1
which forces resynchronization of CPU TSCs when a CPU is hotplugged.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@redhat.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/kernel-parameters.txt |    4 
 init/Kconfig                        |    7 
 kernel/time/Makefile                |    1 
 kernel/time/tsc-sync.c              |  313 ++++++++++++++++++++++++++++++++++++
 4 files changed, 325 insertions(+)

Index: linux.trees.git/kernel/time/tsc-sync.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/kernel/time/tsc-sync.c	2008-11-12 18:01:59.000000000 -0500
@@ -0,0 +1,313 @@
+/*
+ * kernel/time/tsc-sync.c
+ *
+ * Test TSC synchronization
+ *
+ * marks the tsc as unstable _and_ keep a simple "_tsc_is_sync" variable, which
+ * is fast to read when a simple test must determine which clock source to use
+ * for kernel tracing.
+ *
+ * - CPU init :
+ *
+ * We check whether all boot CPUs have their TSC's synchronized,
+ * print a warning if not and turn off the TSC clock-source.
+ *
+ * Only two CPUs may participate - they can enter in any order.
+ * ( The serial nature of the boot logic and the CPU hotplug lock
+ *   protects against more than 2 CPUs entering this code.
+ *
+ * - When CPUs are up :
+ *
+ * TSC synchronicity of all CPUs can be checked later at run-time by calling
+ * test_tsc_synchronization().
+ *
+ * Copyright 2007, 2008
+ *    Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/timex.h>
+#include <linux/jiffies.h>
+#include <linux/trace-clock.h>
+#include <linux/cpu.h>
+#include <linux/kthread.h>
+#include <linux/mutex.h>
+#include <linux/cpu.h>
+
+#define MAX_CYCLES_DELTA 1000ULL
+
+/*
+ * Number of loops to take care of MCE, NMIs, SMIs.
+ */
+#define NR_LOOPS	10
+
+static DEFINE_MUTEX(tscsync_mutex);
+
+struct sync_data {
+	int nr_waits;
+	int wait_sync;
+	cycles_t tsc_count;
+} ____cacheline_aligned;
+
+/* 0 is master, 1 is slave */
+static struct sync_data sync_data[2] = {
+	[0 ... 1] = {
+		.nr_waits = 3 * NR_LOOPS + 1,
+		.wait_sync = 3 * NR_LOOPS + 1,
+	},
+};
+
+int _tsc_is_sync = 1;
+EXPORT_SYMBOL(_tsc_is_sync);
+
+static int force_tsc_sync;
+static cycles_t slave_offset;
+static int slave_offset_ready;	/* for 32-bits architectures */
+
+static int __init force_tsc_sync_setup(char *str)
+{
+	force_tsc_sync = simple_strtoul(str, NULL, 0);
+	return 1;
+}
+__setup("force_tsc_sync=", force_tsc_sync_setup);
+
+/*
+ * Mark it noinline so we make sure it is not unrolled.
+ * Wait until value is reached.
+ */
+static noinline void tsc_barrier(long this_cpu)
+{
+	sync_core();
+	sync_data[this_cpu].wait_sync--;
+	smp_mb();	/* order master/slave sync_data read/write */
+	while (unlikely(sync_data[1 - this_cpu].wait_sync >=
+			sync_data[this_cpu].nr_waits))
+		barrier();	/*
+				 * barrier is used because faster and
+				 * more predictable than cpu_idle().
+				 */
+	smp_mb();	/* order master/slave sync_data read/write */
+	sync_data[this_cpu].nr_waits--;
+	get_cycles_barrier();
+	sync_data[this_cpu].tsc_count = get_cycles();
+	get_cycles_barrier();
+}
+
+/*
+ * Worker thread called on each CPU.
+ * First wait with interrupts enabled, then wait with interrupt disabled,
+ * for precision. We are already bound to one CPU.
+ * this_cpu 0 : master
+ * this_cpu 1 : slave
+ */
+static void test_sync(void *arg)
+{
+	long this_cpu = (long)arg;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	/* Make sure the instructions are in I-CACHE */
+	tsc_barrier(this_cpu);
+	tsc_barrier(this_cpu);
+	sync_data[this_cpu].wait_sync--;
+	smp_mb();	/* order master/slave sync_data read/write */
+	while (unlikely(sync_data[1 - this_cpu].wait_sync >=
+			sync_data[this_cpu].nr_waits))
+		barrier();	/*
+				 * barrier is used because faster and
+				 * more predictable than cpu_idle().
+				 */
+	smp_mb();	/* order master/slave sync_data read/write */
+	sync_data[this_cpu].nr_waits--;
+	/*
+	 * Here, only the master will wait for the slave to reach this barrier.
+	 * This makes sure that the master, which holds the mutex and will reset
+	 * the barriers, waits for the slave to stop using the barrier values
+	 * before it continues. This is only done at the complete end of all the
+	 * loops. This is why there is a + 1 in original wait_sync value.
+	 */
+	if (sync_data[this_cpu].nr_waits == 1)
+		sync_data[this_cpu].wait_sync--;
+	local_irq_restore(flags);
+}
+
+/*
+ * Each CPU (master and target) must decrement the wait_sync value twice (one
+ * for priming in cache), and also once after the get_cycles. After all the
+ * loops, one last synchronization is required to make sure the master waits
+ * for the slave before resetting the barriers.
+ */
+static void reset_barriers(void)
+{
+	int i;
+
+	/*
+	 * Wait until slave is done so that we don't overwrite
+	 * wait_end_sync prematurely.
+	 */
+	smp_mb();	/* order master/slave sync_data read/write */
+	while (unlikely(sync_data[1].wait_sync >= sync_data[0].nr_waits))
+		barrier();	/*
+				 * barrier is used because faster and
+				 * more predictable than cpu_idle().
+				 */
+	smp_mb();	/* order master/slave sync_data read/write */
+
+	for (i = 0; i < 2; i++) {
+		WARN_ON(sync_data[i].wait_sync != 0);
+		WARN_ON(sync_data[i].nr_waits != 1);
+		sync_data[i].wait_sync = 3 * NR_LOOPS + 1;
+		sync_data[i].nr_waits = 3 * NR_LOOPS + 1;
+	}
+}
+
+/*
+ * Do loops (making sure no unexpected event changes the timing), keep the best
+ * one. The result of each loop is the highest tsc delta between the master CPU
+ * and the slaves. Stop CPU hotplug when this code is executed to make sure we
+ * are concurrency-safe wrt CPU hotplug also using this code.  Test TSC
+ * synchronization even if we already "know" CPUs were not synchronized. This
+ * can be used as a test to check if, for some reason, the CPUs eventually got
+ * in sync after a CPU has been unplugged. This code is kept separate from the
+ * CPU hotplug code because the slave CPU executes in an IPI, which we want to
+ * keep as short as possible (this is happening while the system is running).
+ * Therefore, we do not send a single IPI for all the test loops, but rather
+ * send one IPI per loop.
+ */
+int test_tsc_synchronization(void)
+{
+	long cpu, master;
+	cycles_t max_diff = 0, diff, best_loop, worse_loop = 0;
+	int i;
+
+	mutex_lock(&tscsync_mutex);
+	get_online_cpus();
+
+	printk(KERN_INFO
+	       "checking TSC synchronization across all online CPUs:");
+
+	preempt_disable();
+	master = smp_processor_id();
+	for_each_online_cpu(cpu) {
+		if (master == cpu)
+			continue;
+		best_loop = (cycles_t)ULLONG_MAX;
+		for (i = 0; i < NR_LOOPS; i++) {
+			smp_call_function_single(cpu, test_sync,
+						(void *)1UL, 0);
+			test_sync((void *)0UL);
+			diff = abs(sync_data[1].tsc_count
+				- sync_data[0].tsc_count);
+			best_loop = min(best_loop, diff);
+			worse_loop = max(worse_loop, diff);
+		}
+		reset_barriers();
+		max_diff = max(best_loop, max_diff);
+	}
+	preempt_enable();
+	if (max_diff >= MAX_CYCLES_DELTA) {
+		printk(KERN_WARNING
+			"Measured %llu cycles TSC offset between CPUs,"
+			" turning off TSC clock.\n", (u64)max_diff);
+		mark_tsc_unstable("check_tsc_sync_source failed");
+		_tsc_is_sync = 0;
+	} else {
+		printk(" passed.\n");
+	}
+	put_online_cpus();
+	mutex_unlock(&tscsync_mutex);
+	return max_diff < MAX_CYCLES_DELTA;
+}
+EXPORT_SYMBOL_GPL(test_tsc_synchronization);
+
+/*
+ * Test synchronicity of a single core when it is hotplugged.
+ * Source CPU calls into this - waits for the freshly booted target CPU to
+ * arrive and then start the measurement:
+ */
+void __cpuinit check_tsc_sync_source(int cpu)
+{
+	cycles_t diff, abs_diff,
+		 best_loop = (cycles_t)ULLONG_MAX, worse_loop = 0;
+	int i;
+
+	/*
+	 * No need to check if we already know that the TSC is not synchronized:
+	 */
+	if (!force_tsc_sync && unsynchronized_tsc()) {
+		/*
+		 * Make sure we mark _tsc_is_sync to 0 if the TSC is found
+		 * to be unsynchronized for other causes than non-synchronized
+		 * TSCs across CPUs.
+		 */
+		_tsc_is_sync = 0;
+		set_trace_clock_is_sync(0);
+		return;
+	}
+
+	printk(KERN_INFO "checking TSC synchronization [CPU#%d -> CPU#%d]:",
+			  smp_processor_id(), cpu);
+
+	for (i = 0; i < NR_LOOPS; i++) {
+		test_sync((void *)0UL);
+		diff = sync_data[1].tsc_count - sync_data[0].tsc_count;
+		abs_diff = abs(diff);
+		best_loop = min(best_loop, abs_diff);
+		worse_loop = max(worse_loop, abs_diff);
+		if (force_tsc_sync && best_loop == abs_diff)
+			slave_offset = diff;
+	}
+	reset_barriers();
+
+	if (!force_tsc_sync && best_loop >= MAX_CYCLES_DELTA) {
+		printk(" failed.\n");
+		printk(KERN_WARNING
+			"Measured %llu cycles TSC offset between CPUs,"
+			" turning off TSC clock.\n", (u64)best_loop);
+		mark_tsc_unstable("check_tsc_sync_source failed");
+		_tsc_is_sync = 0;
+		set_trace_clock_is_sync(0);
+	} else {
+		printk(" %s.\n", !force_tsc_sync ? "passed" : "forced");
+	}
+	if (force_tsc_sync) {
+		/* order slave_offset and slave_offset_ready writes */
+		smp_wmb();
+		slave_offset_ready = 1;
+	}
+}
+
+/*
+ * Freshly booted CPUs call into this:
+ */
+void __cpuinit check_tsc_sync_target(void)
+{
+	int i;
+
+	if (!force_tsc_sync && unsynchronized_tsc())
+		return;
+
+	for (i = 0; i < NR_LOOPS; i++)
+		test_sync((void *)1UL);
+
+	/*
+	 * Force slave synchronization if requested.
+	 */
+	if (force_tsc_sync) {
+		unsigned long flags;
+		cycles_t new_tsc;
+
+		while (!slave_offset_ready)
+			cpu_relax();
+		/* order slave_offset and slave_offset_ready reads */
+		smp_rmb();
+		local_irq_save(flags);
+		/*
+		 * slave_offset is read when master has finished writing to it,
+		 * and is protected by cpu hotplug serialization.
+		 */
+		new_tsc = get_cycles() - slave_offset;
+		write_tsc((u32)new_tsc, (u32)((u64)new_tsc >> 32));
+		local_irq_restore(flags);
+	}
+}
Index: linux.trees.git/kernel/time/Makefile
===================================================================
--- linux.trees.git.orig/kernel/time/Makefile	2008-11-07 00:34:10.000000000 -0500
+++ linux.trees.git/kernel/time/Makefile	2008-11-12 18:01:59.000000000 -0500
@@ -6,3 +6,4 @@ obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCA
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
 obj-$(CONFIG_TIMER_STATS)			+= timer_stats.o
+obj-$(CONFIG_HAVE_UNSYNCHRONIZED_TSC)		+= tsc-sync.o
Index: linux.trees.git/init/Kconfig
===================================================================
--- linux.trees.git.orig/init/Kconfig	2008-11-12 18:01:18.000000000 -0500
+++ linux.trees.git/init/Kconfig	2008-11-12 18:01:59.000000000 -0500
@@ -358,6 +358,13 @@ config HAVE_TRACE_CLOCK_GENERIC
 config HAVE_TRACE_CLOCK_32_TO_64
 	def_bool n
 
+#
+# Architectures which need to dynamically detect if their TSC is unsynchronized
+# across cpus should select this.
+#
+config HAVE_UNSYNCHRONIZED_TSC
+	def_bool n
+
 config GROUP_SCHED
 	bool "Group CPU scheduler"
 	depends on EXPERIMENTAL
Index: linux.trees.git/Documentation/kernel-parameters.txt
===================================================================
--- linux.trees.git.orig/Documentation/kernel-parameters.txt	2008-11-07 00:34:10.000000000 -0500
+++ linux.trees.git/Documentation/kernel-parameters.txt	2008-11-12 18:01:59.000000000 -0500
@@ -765,6 +765,10 @@ and is between 256 and 4096 characters. 
 			parameter will force ia64_sal_cache_flush to call
 			ia64_pal_cache_flush instead of SAL_CACHE_FLUSH.
 
+	force_tsc_sync
+			Force TSC resynchronization when SMP CPUs go online.
+			See also idle=poll and disable frequency scaling.
+
 	gamecon.map[2|3]=
 			[HW,JOY] Multisystem joystick and NES/SNES/PSX pad
 			support via parallel port (up to 5 devices per port)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

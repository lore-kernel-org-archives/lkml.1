Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbYJQABV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbYJQABV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYJPX4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:56:07 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48971 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbYJPX4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:56:04 -0400
Message-Id: <20081016234656.542407833@polymtl.ca>
References: <20081016232729.699004293@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Oct 2008 19:27:36 -0400
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
Subject: [RFC patch 07/15] LTTng timestamp
Content-Disposition: inline; filename=lttng-timestamp-core.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 16 Oct 2008 23:54:45 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng synthetic TSC code for timestamping. Extracts 64 bits tsc from a [0..32]
bits counter, kept up to date by periodical timer interrupt. Lockless.

> do you actually use the RCU internals? or do you just reimplement an RCU
> algorithm?
> 

Nope, I don't use RCU internals in this code. Preempt disable seemed
like the best way to handle this utterly short code path and I wanted
the write side to be fast enough to be called periodically. What I do is:

- Disable preemption at the read-side :
  it makes sure the pointer I get will point to a data structure that
  will never change while I am in the preempt disabled code. (see *)
- I use per-cpu data to allow the read-side to be as fast as possible
  (only need to disable preemption, does not race against other CPUs and
  won't generate cache line bouncing). It also allows dealing with
  unsynchronized TSCs if needed.
- Periodical write side : it's called from an IPI running on each CPU.

(*) We expect the read-side (preempt off region) to last shorter than
the interval between IPI updates so we can guarantee the data structure
it uses won't be modified underneath it. Since the IPI update is
launched each seconds or so (depends on the frequency of the counter we
are trying to extend), it's more than ok.

Changelog:

- Support [0..32] bits -> 64 bits.

I volountarily limit the code to use at most 32 bits of the hardware clock for
performance considerations. If this is a problem it could be changed. Also, the
algorithm is aimed at a 32 bits architecture. The code becomes muuuch simpler on
a 64 bits arch, since we can do the updates atomically.

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
 init/Kconfig        |    2 
 ltt/Kconfig         |   17 ++++
 ltt/Makefile        |    1 
 ltt/ltt-timestamp.c |  212 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 232 insertions(+)

Index: linux-2.6-lttng/ltt/ltt-timestamp.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ltt/ltt-timestamp.c	2008-10-16 18:30:25.000000000 -0400
@@ -0,0 +1,212 @@
+/*
+ * (C) Copyright	2006,2007 -
+ * 		Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca)
+ *
+ * notes : ltt-timestamp timer-based clock cannot be used for early tracing in
+ * the boot process, as it depends on timer interrupts.
+ *
+ * The timer is only on one CPU to support hotplug.
+ * We have the choice between schedule_delayed_work_on and an IPI to get each
+ * CPU to write the heartbeat. IPI has been chosen because it is considered
+ * faster than passing through the timer to get the work scheduled on all the
+ * CPUs.
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
+#include <linux/ltt.h>
+#include <linux/smp.h>
+#include <linux/sched.h> /* FIX for m68k local_irq_enable in on_each_cpu */
+
+/*
+ * Number of hardware clock bits. The higher order bits are expected to be 0.
+ * If the hardware clock source has more than 32 bits, the bits higher than the
+ * 32nd will be truncated by a cast to a 32 bits unsigned. Range : 1 - 32.
+ * (too few bits would be unrealistic though, since we depend on the timer to
+ * detect the overflows).
+ */
+#define HW_BITS				32
+
+#define HW_BITMASK			((1ULL << HW_BITS) - 1)
+#define HW_LSB(hw)			((hw) & HW_BITMASK)
+#define SW_MSB(sw)			((sw) & ~HW_BITMASK)
+
+/* Expected maximum interrupt latency in ms : 15ms, *2 for security */
+#define EXPECTED_INTERRUPT_LATENCY	30
+
+atomic_t lttng_generic_clock;
+EXPORT_SYMBOL(lttng_generic_clock);
+
+static struct timer_list stsc_timer;
+static unsigned int precalc_expire;
+
+struct synthetic_tsc_struct {
+	union {
+		u64 val;
+		struct {
+#ifdef __BIG_ENDIAN
+			u32 msb;
+			u32 lsb;
+#else
+			u32 lsb;
+			u32 msb;
+#endif
+		} sel;
+	} tsc[2];
+	unsigned int index;	/* Index of the current synth. tsc. */
+};
+
+static DEFINE_PER_CPU(struct synthetic_tsc_struct, synthetic_tsc);
+
+/* Called from IPI : either in interrupt or process context */
+static void ltt_update_synthetic_tsc(void)
+{
+	struct synthetic_tsc_struct *cpu_synth;
+	u32 tsc;
+
+	preempt_disable();
+	cpu_synth = &per_cpu(synthetic_tsc, smp_processor_id());
+	tsc = ltt_get_timestamp32();		/* Hardware clocksource read */
+
+	if (tsc < HW_LSB(cpu_synth->tsc[cpu_synth->index].sel.lsb)) {
+		unsigned int new_index = 1 - cpu_synth->index; /* 0 <-> 1 */
+		/*
+		 * Overflow
+		 * Non atomic update of the non current synthetic TSC, followed
+		 * by an atomic index change. There is no write concurrency,
+		 * so the index read/write does not need to be atomic.
+		 */
+		cpu_synth->tsc[new_index].val =
+			(SW_MSB(cpu_synth->tsc[cpu_synth->index].val)
+				| (u64)tsc) + (1ULL << HW_BITS);
+		cpu_synth->index = new_index;	/* atomic change of index */
+	} else {
+		/*
+		 * No overflow : We know that the only bits changed are
+		 * contained in the 32 LSBs, which can be written to atomically.
+		 */
+		cpu_synth->tsc[cpu_synth->index].sel.lsb =
+			SW_MSB(cpu_synth->tsc[cpu_synth->index].sel.lsb) | tsc;
+	}
+	preempt_enable();
+}
+
+/* Called from buffer switch : in _any_ context (even NMI) */
+u64 notrace ltt_read_synthetic_tsc(void)
+{
+	struct synthetic_tsc_struct *cpu_synth;
+	u64 ret;
+	unsigned int index;
+	u32 tsc;
+
+	preempt_disable_notrace();
+	cpu_synth = &per_cpu(synthetic_tsc, smp_processor_id());
+	index = cpu_synth->index;		/* atomic read */
+	tsc = ltt_get_timestamp32();		/* Hardware clocksource read */
+
+	/* Overflow detection */
+	if (unlikely(tsc < HW_LSB(cpu_synth->tsc[index].sel.lsb)))
+		ret = (SW_MSB(cpu_synth->tsc[index].val) | (u64)tsc)
+			+ (1ULL << HW_BITS);
+	else
+		ret = SW_MSB(cpu_synth->tsc[index].val) | (u64)tsc;
+	preempt_enable_notrace();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ltt_read_synthetic_tsc);
+
+static void synthetic_tsc_ipi(void *info)
+{
+	ltt_update_synthetic_tsc();
+}
+
+/* We need to be in process context to do an IPI */
+static void synthetic_tsc_work(struct work_struct *work)
+{
+	on_each_cpu(synthetic_tsc_ipi, NULL, 1);
+}
+static DECLARE_WORK(stsc_work, synthetic_tsc_work);
+
+/*
+ * stsc_timer : - Timer function synchronizing synthetic TSC.
+ * @data: unused
+ *
+ * Guarantees at least 1 execution before low word of TSC wraps.
+ */
+static void stsc_timer_fct(unsigned long data)
+{
+	PREPARE_WORK(&stsc_work, synthetic_tsc_work);
+	schedule_work(&stsc_work);
+
+	mod_timer(&stsc_timer, jiffies + precalc_expire);
+}
+
+/*
+ * precalc_stsc_interval: - Precalculates the interval between the clock
+ * wraparounds.
+ */
+static int __init precalc_stsc_interval(void)
+{
+	precalc_expire =
+		(HW_BITMASK / ((ltt_frequency() / HZ * ltt_freq_scale()) << 1)
+			- 1 - (EXPECTED_INTERRUPT_LATENCY * HZ / 1000)) >> 1;
+	WARN_ON(precalc_expire == 0);
+	printk(KERN_DEBUG "Synthetic TSC timer will fire each %u jiffies.\n",
+		precalc_expire);
+	return 0;
+}
+
+/*
+ * 	hotcpu_callback - CPU hotplug callback
+ * 	@nb: notifier block
+ * 	@action: hotplug action to take
+ * 	@hcpu: CPU number
+ *
+ *	Sets the new CPU's current synthetic TSC to the same value as the
+ *	currently running CPU.
+ *
+ * 	Returns the success/failure of the operation. (NOTIFY_OK, NOTIFY_BAD)
+ */
+static int __cpuinit hotcpu_callback(struct notifier_block *nb,
+				unsigned long action,
+				void *hcpu)
+{
+	unsigned int hotcpu = (unsigned long)hcpu;
+	struct synthetic_tsc_struct *cpu_synth;
+	u64 local_count;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+		cpu_synth = &per_cpu(synthetic_tsc, hotcpu);
+		local_count = ltt_read_synthetic_tsc();
+		cpu_synth->tsc[0].val = local_count;
+		cpu_synth->index = 0;
+		smp_wmb();	/* Writing in data of CPU about to come up */
+		break;
+	case CPU_ONLINE:
+		/* As we are preemptible, make sure it runs on the right cpu */
+		smp_call_function_single(hotcpu, synthetic_tsc_ipi, NULL, 0);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+/* Called from one CPU, before any tracing starts, to init each structure */
+static int __init ltt_init_synthetic_tsc(void)
+{
+	hotcpu_notifier(hotcpu_callback, 3);
+	precalc_stsc_interval();
+	init_timer(&stsc_timer);
+	stsc_timer.function = stsc_timer_fct;
+	stsc_timer.expires = jiffies + precalc_expire;
+	add_timer(&stsc_timer);
+	return 0;
+}
+
+__initcall(ltt_init_synthetic_tsc);
Index: linux-2.6-lttng/ltt/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ltt/Kconfig	2008-10-16 18:30:41.000000000 -0400
@@ -0,0 +1,17 @@
+menu "Linux Trace Toolkit"
+
+config LTT_TIMESTAMP
+	bool "LTTng fine-grained timestamping"
+	default y
+	help
+	  Allow fine-grained timestamps to be taken from tracing applications.
+
+config HAVE_LTT_CLOCK
+	def_bool n
+
+config HAVE_LTT_SYNTHETIC_TSC
+	bool
+	default y if (!HAVE_LTT_CLOCK)
+	default n if HAVE_LTT_CLOCK
+
+endmenu
Index: linux-2.6-lttng/ltt/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ltt/Makefile	2008-10-16 18:30:41.000000000 -0400
@@ -0,0 +1 @@
+obj-$(CONFIG_HAVE_LTT_SYNTHETIC_TSC)	+= ltt-timestamp.o
Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2008-10-16 18:18:38.000000000 -0400
+++ linux-2.6-lttng/init/Kconfig	2008-10-16 18:30:39.000000000 -0400
@@ -787,6 +787,8 @@ config MARKERS
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.
 
+source "ltt/Kconfig"
+
 source "arch/Kconfig"
 
 config PROC_PAGE_MONITOR

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

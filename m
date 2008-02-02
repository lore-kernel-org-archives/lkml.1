Return-Path: <linux-kernel-owner+w=401wt.eu-S1765284AbYBBQbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765284AbYBBQbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 11:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbYBBQbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 11:31:07 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:40440 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbYBBQbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 11:31:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAM4ppEdMQWYq/2dsb2JhbACBWJAmm2o
Date: Sat, 2 Feb 2008 11:30:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 06/23 -v8] handle accurate time keeping over long delays
Message-ID: <20080202163057.GB16086@Krystal>
References: <20080130210357.927754294@goodmis.org> <20080130210525.701268662@goodmis.org> <20080131121037.GB8493@Krystal> <1201800297.6789.14.camel@jstultz-laptop> <20080201170219.GA19397@Krystal> <Pine.LNX.4.58.0802020209230.21975@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0802020209230.21975@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:11:09 up 90 days, 20:16,  3 users,  load average: 0.43, 0.52,
	0.53
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> 
> 
> On Fri, 1 Feb 2008, Mathieu Desnoyers wrote:
> 
> > > > > accumulated clock cycles.
> > > > >
> > > >
> > > > About this one.. we talked a lot about the importance of timekeeping at
> > > > the first Montreal Tracing Summit this week. Actually, someone
> > > > mentioned a very interesting point : in order to be able to synchronize
> > > > traces taken from the machine with traces taken on external hardware
> > > > (i.e. memory bus tracer on Freescale), taking the "real" counter value
> > > > rather that using the "cumulated cycles" approach (which creates a
> > > > virtual counted instead) would be better.
> > > >
> > > > So I would recommend using an algorithm that would return a clock value
> > > > which is the same as the underlying hardware counter.
> > >
> > > Hmm. It is an interesting issue. Clearly having the raw cycle value
> > > match up so hardware analysis could be mapped to software timestamps
> > > would be useful(although obscure) feature. However with the variety of
> > > clocksources, dealing properly with the clocksource wrap issue (ACPI PM
> > > for instance wraps about every 5 seconds) also has to be addressed.
> > >
> > > I think you were mentioning an idea that required some work on the read
> > > side to handle the wraps, basically managing the high order bits by
> > > hand. This sounds like it would be an additional feature that could be
> > > added on to the infrastructure being provided in the
> > > get_monotonic_cycles() patch. No?
> > >
> >
> > Yup, exactly.
> >
> > >
> > > However, all of the above is a separate issue then what this (the
> > > timekeeping over long delay) patch addresses, as it is not really
> > > directly related to the get_monotonic_cycles() patch, but instead allows
> > > for correct timekeeping, making update_wall_time() to function properly
> > > if it was deferred for longer then the clocksource's wrap time.
> > >
> >
> > I agree, that could apply on top of the monotonic cycles patch. It's
> > just a different way to see it : dealing with wrapping TSC bits,
> > returning the LSBs given by the hardware, rather than simply
> > accumulating time. This is what the patch I sent earlier (which I use in
> > LTTng) does. I currently expects 32 LSBs to be given by the hardware,
> > but it would be trivial to extend it to support any given number of
> > hardware LSBs.
> >
> 
> So you are saying that you can trivally make it work with a clock that is,
> say 24 bits? And this same code can work if we boot up with a clock with
> 32 bits or more?
> 
> -- Steve
> 

Yes, with this updated version. It supports HW clocks with various
number of bits. I limit myself to the 32 LSBs of the clock even if the
clock provides more bits for performance reasons. This module is aimed
at 32 bits architectures because such tricks are not necessary on 64
bits architectures given they provide atomic 64 bits updates.

(it's only compile-tested)

LTTng timestamp

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
---
 init/Kconfig        |    2 
 ltt/Kconfig         |   17 ++++
 ltt/Makefile        |    1 
 ltt/ltt-timestamp.c |  210 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 230 insertions(+)

Index: linux-2.6-lttng/ltt/ltt-timestamp.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ltt/ltt-timestamp.c	2008-02-02 11:26:08.000000000 -0500
@@ -0,0 +1,210 @@
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
+static struct synthetic_tsc_struct {
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
+} ____cacheline_aligned synthetic_tsc[NR_CPUS];
+
+/* Called from IPI : either in interrupt or process context */
+static void ltt_update_synthetic_tsc(void)
+{
+	struct synthetic_tsc_struct *cpu_synth;
+	u32 tsc;
+
+	preempt_disable();
+	cpu_synth = &synthetic_tsc[smp_processor_id()];
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
+u64 ltt_read_synthetic_tsc(void)
+{
+	struct synthetic_tsc_struct *cpu_synth;
+	u64 ret;
+	unsigned int index;
+	u32 tsc;
+
+	preempt_disable();
+	cpu_synth = &synthetic_tsc[smp_processor_id()];
+	index = cpu_synth->index;		/* atomic read */
+	tsc = ltt_get_timestamp32();		/* Hardware clocksource read */
+
+	/* Overflow detection */
+	if (unlikely(tsc < HW_LSB(cpu_synth->tsc[index].sel.lsb)))
+		ret = (SW_MSB(cpu_synth->tsc[index].val) | (u64)tsc)
+			+ (1ULL << HW_BITS);
+	else
+		ret = SW_MSB(cpu_synth->tsc[index].val) | (u64)tsc;
+	preempt_enable();
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
+	on_each_cpu(synthetic_tsc_ipi, NULL, 1, 1);
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
+		cpu_synth = &synthetic_tsc[hotcpu];
+		local_count = ltt_read_synthetic_tsc();
+		cpu_synth->tsc[0].val = local_count;
+		cpu_synth->index = 0;
+		smp_wmb();	/* Writing in data of CPU about to come up */
+		break;
+	case CPU_ONLINE:
+		/* As we are preemptible, make sure it runs on the right cpu */
+		smp_call_function_single(hotcpu, synthetic_tsc_ipi, NULL, 1, 0);
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
+++ linux-2.6-lttng/ltt/Kconfig	2008-02-02 11:25:36.000000000 -0500
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
+++ linux-2.6-lttng/ltt/Makefile	2008-02-02 11:25:36.000000000 -0500
@@ -0,0 +1 @@
+obj-$(CONFIG_HAVE_LTT_SYNTHETIC_TSC)	+= ltt-timestamp.o
Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2008-02-02 10:07:33.000000000 -0500
+++ linux-2.6-lttng/init/Kconfig	2008-02-02 10:07:36.000000000 -0500
@@ -691,6 +691,8 @@ config MARKERS
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.
 
+source "ltt/Kconfig"
+
 source "arch/Kconfig"
 
 config DISABLE_IMMEDIATE


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

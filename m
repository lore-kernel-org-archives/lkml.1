Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYAJUnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYAJUnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbYAJUnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:43:07 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:46735 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbYAJUnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:43:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FACQShkdMROHU/2dsb2JhbACBVqgj
Date: Thu, 10 Jan 2008 15:42:59 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: john stultz <johnstul@us.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>, bob.picco@hp.com,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 13/22 -v2] handle accurate time keeping over long
	delays
Message-ID: <20080110204259.GB5836@Krystal>
References: <20080109232914.676624725@goodmis.org> <20080109233044.288563621@goodmis.org> <1199923219.6350.16.camel@localhost.localdomain> <12c511ca0801101154q224c7a43sa016190cf209d304@mail.gmail.com> <1199996959.6108.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1199996959.6108.18.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:35:14 up 68 days,  1:40,  6 users,  load average: 0.85, 0.52,
	0.57
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* john stultz (johnstul@us.ibm.com) wrote:
> 
> On Thu, 2008-01-10 at 11:54 -0800, Tony Luck wrote:
> > > Tony:  ia64 also needs something like this, but I found the fsyscall asm
> > > bits a little difficult to grasp. So I'll need some assistance on how to
> > > include the accumulated cycles into the final calculation.
> > 
> > I'm trying to figure out all the ramifications of the new
> > "cycle_accumulated" field.  Does it really need to be
> > propagated all the way to the low level assembler (which
> > I don't want to mess with unless I really, really have to).
> > Can't I do the necessary calculations in update_vsyscall()
> > [Where I can do them in C :-)] and keep the same low
> > level assembly code.  I think I must be missing some
> > important bit of what is going on here.
> 
> (Added Bob Picco to the mail, as he was involved in the ia64 clocksource
> work).
> 
> So the background on the patch is this:
> 
> Some clocksources wrap frequently (every few seconds, for example). This
> can cause issues if we defer the update_wall_time() function where we
> accumulate time for too long (this really only happens on -rt systems
> right now). 
> 
> To avoid that issue, we've added the cycle_accumulated value, which acts
> as a midpoint, where we can quickly accumulate cycles off of the
> counter, without doing the more expensive update_wall_time() function.
> This avoids issues with the clocksource wrapping, but requires that
> cycle_accumulated be added in to the gettiemofday() calculation.
> 
> If you noticed in my email, the fix for ppc was a bit easier, as it has
> only a 64bit counter that is quite unlikely to wrap twice between calls
> to update_wall_time(). There we could decrement the cycles_last value by
> cycles_accumulated and get the same effect of adding it in.
> 
> Unfortunately on ia64, I suspect it will be necessary to do similar to
> the x86_64 code and add in the cycles accumulated value in
> vgettime/fgettime function, since there is the possibility of quickly
> wrapping clocksources on that architecture. 
> 
> So unless someone can point out a nicer trick, it likely means adding a
> new cycles_accumulated value to the fsyscall structure and the asm to do
> the addition. :(
> 

I think it's about time I introduce the approach I have taken for LTTng
timestamping. Basically, one of the main issues with the clock sources
is the xtime lock : having a read seqlock nested over a write seqlock is
a really, really bad idea. This can happen with NMIs. Basically, it
would cause a deadlock.

What I have done is an RCU algorithm that extends a 32 bits TSC (that's
the case on MIPS, for instance) to 64 bits. The update of the MSBs is
done by a periodical timer (fired often enough to make sure we always
detect the 32 LSBs wrap-around) and the read-side only has to disable
preemption.

I use a 2 slots array, each of them keeping, alternatively, the last 64
bits counter value, to implement the RCU algorithm.

Since we are discussing time source modification, this is one that I
would really like to see in the Linux kernel : it would provide the kind
of time source needed for function entry/exit tracing and for generic
kernel tracing as well.

Mathieu

Here is the patch, for reference. It applies on 2.6.24-rc7, after some
other LTTng patches in my patchset.


LTTng timestamp

LTTng synthetic TSC code for timestamping. Extracts 64 bits tsc from a 32 bits
counter, kept up to date by periodical timer interrupt. Lockless.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 init/Kconfig        |    2 
 ltt/Kconfig         |   17 ++++
 ltt/Makefile        |    1 
 ltt/ltt-timestamp.c |  198 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 218 insertions(+)

Index: linux-2.6-lttng/ltt/ltt-timestamp.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ltt/ltt-timestamp.c	2007-12-05 20:54:48.000000000 -0500
@@ -0,0 +1,198 @@
+/*
+ * (C) Copyright	2006,2007 -
+ * 		Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca)
+ *
+ * notes : ltt-timestamp timer-based clock cannot be used for early tracing in
+ * the boot process, as it depends on timer interrupts.
+ *
+ * The timer needs to be only on one CPU to support hotplug.
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
+atomic_t lttng_generic_clock;
+EXPORT_SYMBOL(lttng_generic_clock);
+
+/* Expected maximum interrupt latency in ms : 15ms, *2 for security */
+#define EXPECTED_INTERRUPT_LATENCY	30
+
+static struct timer_list stsc_timer;
+static unsigned int precalc_expire;
+
+/* For architectures with 32 bits TSC */
+static struct synthetic_tsc_struct {
+	u32 tsc[2][2];	/* a pair of 2 32 bits. [0] is the MSB, [1] is LSB */
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
+	tsc = ltt_get_timestamp32();		/* We deal with a 32 LSB TSC */
+
+	if (tsc < cpu_synth->tsc[cpu_synth->index][1]) {
+		unsigned int new_index = cpu_synth->index ? 0 : 1; /* 0 <-> 1 */
+		/*
+		 * Overflow
+		 * Non atomic update of the non current synthetic TSC, followed
+		 * by an atomic index change. There is no write concurrency,
+		 * so the index read/write does not need to be atomic.
+		 */
+		cpu_synth->tsc[new_index][1] = tsc; /* LSB update */
+		cpu_synth->tsc[new_index][0] =
+			cpu_synth->tsc[cpu_synth->index][0]+1; /* MSB update */
+		cpu_synth->index = new_index;	/* atomic change of index */
+	} else {
+		/*
+		 * No overflow : we can simply update the 32 LSB of the current
+		 * synthetic TSC as it's an atomic write.
+		 */
+		cpu_synth->tsc[cpu_synth->index][1] = tsc;
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
+	index = cpu_synth->index; /* atomic read */
+	tsc = ltt_get_timestamp32();		/* We deal with a 32 LSB TSC */
+
+	if (tsc < cpu_synth->tsc[index][1]) {
+		/* Overflow */
+		ret = ((u64)(cpu_synth->tsc[index][0]+1) << 32) | ((u64)tsc);
+	} else {
+		/* no overflow */
+		ret = ((u64)cpu_synth->tsc[index][0] << 32) | ((u64)tsc);
+	}
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
+ * precalc_stsc_interval: - Precalculates the interval between the 32 bits TSC
+ * wraparounds.
+ */
+static int __init precalc_stsc_interval(void)
+{
+	unsigned long mask;
+
+	mask = 0xFFFFFFFFUL;
+	precalc_expire =
+		(mask/((ltt_frequency() / HZ * ltt_freq_scale()) << 1)
+			- 1 - (EXPECTED_INTERRUPT_LATENCY*HZ/1000)) >> 1;
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
+		cpu_synth->tsc[0][1] = (u32)local_count; /* LSB */
+		cpu_synth->tsc[0][0] = (u32)(local_count >> 32); /* MSB */
+		cpu_synth->index = 0;
+		smp_wmb();	/* Writing in data of CPU about to come up */
+		break;
+	case CPU_ONLINE:
+		/*
+		 * FIXME : heartbeat events are currently broken with CPU
+		 * hotplug : events can be recorded before heartbeat, heartbeat
+		 * too far from trace start and are broken with trace stop/start
+		 * as well.
+		 */
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
+	int cpu;
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
+++ linux-2.6-lttng/ltt/Kconfig	2007-12-05 20:54:48.000000000 -0500
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
+++ linux-2.6-lttng/ltt/Makefile	2007-12-05 20:54:48.000000000 -0500
@@ -0,0 +1 @@
+obj-$(CONFIG_HAVE_LTT_SYNTHETIC_TSC)	+= ltt-timestamp.o
Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2007-12-05 20:53:35.000000000 -0500
+++ linux-2.6-lttng/init/Kconfig	2007-12-05 20:54:48.000000000 -0500
@@ -682,6 +682,8 @@ config MARKERS
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

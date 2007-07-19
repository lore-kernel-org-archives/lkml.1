Return-Path: <linux-kernel-owner+w=401wt.eu-S932214AbXGSKDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbXGSKDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXGSJzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918AbXGSJzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:03 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [15/58] i386: Rewrite sched_clock
Message-Id: <20070719095459.E60AD14E11@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Move it into an own file for easy sharing.
Do everything per CPU. This avoids problems with TSCs that
tick at different frequencies per CPU.
Resync properly on cpufreq changes. CPU frequency is instable
around cpu frequency changing, so fall back during a backing
clock during this period.
Hopefully TSC will work now on all systems except when there isn't a
physical TSC. 

And

+From: Jeremy Fitzhardinge <jeremy@goop.org>
Three cleanups there:
 - change "instable" -> "unstable"
 - it's better to use get_cpu_var for getting this cpu's variables
 - change cycles_2_ns to do the full computation rather than just the
   tsc->ns scaling.  It's a simpler interface, and it makes the function

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/Makefile      |    3 
 arch/i386/kernel/sched-clock.c |  265 +++++++++++++++++++++++++++++++++++++++++
 arch/i386/kernel/tsc.c         |   74 -----------
 include/asm-i386/timer.h       |   32 ----
 include/asm-i386/tsc.h         |    1 
 5 files changed, 269 insertions(+), 106 deletions(-)

Index: linux/arch/i386/kernel/sched-clock.c
===================================================================
--- /dev/null
+++ linux/arch/i386/kernel/sched-clock.c
@@ -0,0 +1,265 @@
+/* A fast clock for the scheduler.
+ * Copyright 2007 Andi Kleen SUSE Labs
+ * Subject to the GNU Public License, version 2 only.
+ */
+#include <linux/init.h>
+#include <linux/cpu.h>
+#include <linux/cpufreq.h>
+#include <linux/kernel.h>
+#include <linux/percpu.h>
+#include <linux/ktime.h>
+#include <linux/hrtimer.h>
+#include <linux/smp.h>
+#include <linux/notifier.h>
+#include <linux/init.h>
+#include <asm/tsc.h>
+#include <asm/cpufeature.h>
+#include <asm/timer.h>
+
+/*
+ * convert from cycles(64bits) => nanoseconds (64bits)
+ *  basic equation:
+ *		ns = cycles / (freq / ns_per_sec)
+ *		ns = cycles * (ns_per_sec / freq)
+ *		ns = cycles * (10^9 / (cpu_khz * 10^3))
+ *		ns = cycles * (10^6 / cpu_khz)
+ *
+ *	Then we use scaling math (suggested by george@mvista.com) to get:
+ *		ns = cycles * (10^6 * SC / cpu_khz) / SC
+ *		ns = cycles * cyc2ns_scale / SC
+ *
+ *	And since SC is a constant power of two, we can convert the div
+ *  into a shift.
+ *
+ *  We can use khz divisor instead of mhz to keep a better percision, since
+ *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
+ *  (mathieu.desnoyers@polymtl.ca)
+ *
+ *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
+ */
+
+#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
+
+struct sc_data {
+	unsigned cyc2ns_scale;
+	unsigned unstable;
+	unsigned long long sync_base;		/* TSC or jiffies at syncpoint*/
+	unsigned long long ns_base;		/* nanoseconds at sync point */
+	unsigned long long last_val;		/* Last returned value */
+};
+
+static DEFINE_PER_CPU(struct sc_data, sc_data) =
+	{ .unstable = 1, .sync_base = INITIAL_JIFFIES };
+
+static inline u64 __cycles_2_ns(struct sc_data *sc, u64 cyc)
+{
+	u64 ns;
+
+	cyc -= sc->sync_base;
+	ns = (cyc * sc->cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
+	ns += sc->ns_base;
+
+	return ns;
+}
+
+u64 cycles_2_ns(u64 cyc)
+{
+	struct sc_data *sc = &get_cpu_var(sc_data);
+	u64 ns = __cycles_2_ns(sc, cyc);
+	put_cpu_var(sc_data);
+	return ns;
+}
+
+/*
+ * Scheduler clock - returns current time in nanosec units.
+ * All data is local to the CPU.
+ * The values are approximately[1] monotonic local to a CPU, but not
+ * between CPUs.   There might be also an occasionally random error,
+ * but not too bad. Between CPUs the values can be non monotonic.
+ *
+ * [1] no attempt to stop CPU instruction reordering, which can hit
+ * in a 100 instruction window or so.
+ *
+ * The clock can be in two states: stable and unstable.
+ * When it is stable we use the TSC per CPU.
+ * When it is unstable we use jiffies as fallback.
+ * stable->unstable->stable transitions can happen regularly
+ * during CPU frequency changes.
+ * There is special code to avoid having the clock jump backwards
+ * when we switch from TSC to jiffies, which needs to keep some state
+ * per CPU. This state is protected against parallel state changes
+ * with interrupts off.
+ */
+unsigned long long tsc_sched_clock(void)
+{
+	unsigned long long r;
+	struct sc_data *sc = &get_cpu_var(sc_data);
+
+	if (unlikely(sc->unstable)) {
+		r = (jiffies_64 - sc->sync_base) * (1000000000 / HZ);
+		r += sc->ns_base;
+		/*
+		 * last_val is used to avoid non monotonity on a
+		 * stable->unstable transition. Make sure the time
+		 * never goes to before the last value returned by the
+		 * TSC clock.
+		 */
+		while (r <= sc->last_val) {
+			rmb();
+			r = sc->last_val + 1;
+			rmb();
+		}
+		sc->last_val = r;
+	} else {
+		rdtscll(r);
+		r = __cycles_2_ns(sc, r);
+		sc->last_val = r;
+	}
+
+	put_cpu_var(sc_data);
+
+	return r;
+}
+
+/* We need to define a real function for sched_clock, to override the
+   weak default version */
+#ifdef CONFIG_PARAVIRT
+unsigned long long sched_clock(void)
+{
+	return paravirt_sched_clock();
+}
+#else
+unsigned long long sched_clock(void)
+	__attribute__((alias("tsc_sched_clock")));
+#endif
+
+static int no_sc_for_printk;
+
+/*
+ * printk clock: when it is known the sc results are very non monotonic
+ * fall back to jiffies for printk. Other sched_clock users are supposed
+ * to handle this.
+ */
+unsigned long long printk_clock(void)
+{
+	if (unlikely(no_sc_for_printk))
+		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
+	return tsc_sched_clock();
+}
+
+static void resolve_freq(struct cpufreq_freqs *freq)
+{
+	if (!freq->new) {
+		freq->new = cpufreq_get(freq->cpu);
+		if (!freq->new)
+			freq->new = tsc_khz;
+	}
+}
+
+/* Resync with new CPU frequency. Must run on to be synced CPU */
+static void resync_freq(void *arg)
+{
+	struct cpufreq_freqs *freq = (void *)arg;
+	struct sc_data *sc = &__get_cpu_var(sc_data);
+
+	sc->sync_base = jiffies;
+	if (!cpu_has_tsc) {
+		sc->unstable = 1;
+		return;
+	}
+	resolve_freq(freq);
+
+	/*
+	 * Handle nesting, but when we're zero multiple calls in a row
+	 * are ok too and not a bug. This can happen during startup
+	 * when the different callbacks race with each other.
+	 */
+	if (sc->unstable > 0)
+		sc->unstable--;
+	if (sc->unstable)
+		return;
+
+	/* Minor race window here, but should not add significant errors. */
+	sc->ns_base = ktime_to_ns(ktime_get());
+	rdtscll(sc->sync_base);
+	sc->cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR) / freq->new;
+}
+
+static void resync_freq_on_cpu(void *arg)
+{
+	struct cpufreq_freqs f = { .new = 0 };
+
+	f.cpu = get_cpu();
+	resync_freq(&f);
+	put_cpu();
+}
+
+static int sc_freq_event(struct notifier_block *nb, unsigned long event,
+			 void *data)
+{
+	struct cpufreq_freqs *freq = data;
+	struct sc_data *sc = &per_cpu(sc_data, freq->cpu);
+
+	if (cpu_has(&cpu_data[freq->cpu], X86_FEATURE_CONSTANT_TSC))
+		return NOTIFY_DONE;
+	if (freq->old == freq->new)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case CPUFREQ_SUSPENDCHANGE:
+		/* Mark TSC unstable during suspend/resume */
+	case CPUFREQ_PRECHANGE:
+		/*
+		 * Mark TSC as unstable until cpu frequency change is
+		 * done because we don't know when exactly it will
+		 * change.  unstable in used as a counter to guard
+		 * against races between the cpu frequency notifiers
+		 * and normal resyncs
+		 */
+		sc->unstable++;
+		/* FALL THROUGH */
+	case CPUFREQ_RESUMECHANGE:
+	case CPUFREQ_POSTCHANGE:
+		/*
+		 * Frequency change or resume is done -- update everything and
+		 * mark TSC as stable again.
+		 */
+		on_cpu_single(freq->cpu, resync_freq, freq);
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block sc_freq_notifier = {
+	.notifier_call = sc_freq_event
+};
+
+static int __cpuinit
+sc_cpu_event(struct notifier_block *self, unsigned long event, void *hcpu)
+{
+	long cpu = (long)hcpu;
+	if (event == CPU_ONLINE) {
+		struct cpufreq_freqs f = { .cpu = cpu, .new = 0 };
+
+		on_cpu_single(cpu, resync_freq, &f);
+	}
+	return NOTIFY_DONE;
+}
+
+static __init int init_sched_clock(void)
+{
+	if (unsynchronized_tsc())
+		no_sc_for_printk = 1;
+
+	/*
+	 * On a race between the various events the initialization
+	 * might be done multiple times, but code is tolerant to
+	 * this .
+	 */
+	cpufreq_register_notifier(&sc_freq_notifier,
+				CPUFREQ_TRANSITION_NOTIFIER);
+	hotcpu_notifier(sc_cpu_event, 0);
+	on_each_cpu(resync_freq_on_cpu, NULL, 0, 0);
+	return 0;
+}
+core_initcall(init_sched_clock);
Index: linux/arch/i386/kernel/tsc.c
===================================================================
--- linux.orig/arch/i386/kernel/tsc.c
+++ linux/arch/i386/kernel/tsc.c
@@ -63,74 +63,6 @@ static inline int check_tsc_unstable(voi
 	return tsc_unstable;
 }
 
-/* Accellerators for sched_clock()
- * convert from cycles(64bits) => nanoseconds (64bits)
- *  basic equation:
- *		ns = cycles / (freq / ns_per_sec)
- *		ns = cycles * (ns_per_sec / freq)
- *		ns = cycles * (10^9 / (cpu_khz * 10^3))
- *		ns = cycles * (10^6 / cpu_khz)
- *
- *	Then we use scaling math (suggested by george@mvista.com) to get:
- *		ns = cycles * (10^6 * SC / cpu_khz) / SC
- *		ns = cycles * cyc2ns_scale / SC
- *
- *	And since SC is a constant power of two, we can convert the div
- *  into a shift.
- *
- *  We can use khz divisor instead of mhz to keep a better percision, since
- *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
- *  (mathieu.desnoyers@polymtl.ca)
- *
- *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
- */
-unsigned long cyc2ns_scale __read_mostly;
-
-#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
-
-static inline void set_cyc2ns_scale(unsigned long cpu_khz)
-{
-	cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
-}
-
-/*
- * Scheduler clock - returns current time in nanosec units.
- */
-unsigned long long native_sched_clock(void)
-{
-	unsigned long long this_offset;
-
-	/*
-	 * Fall back to jiffies if there's no TSC available:
-	 * ( But note that we still use it if the TSC is marked
-	 *   unstable. We do this because unlike Time Of Day,
-	 *   the scheduler clock tolerates small errors and it's
-	 *   very important for it to be as fast as the platform
-	 *   can achive it. )
-	 */
-	if (unlikely(!tsc_enabled && !tsc_unstable))
-		/* No locking but a rare wrong value is not a big deal: */
-		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
-
-	/* read the Time Stamp Counter: */
-	rdtscll(this_offset);
-
-	/* return the value in ns */
-	return cycles_2_ns(this_offset);
-}
-
-/* We need to define a real function for sched_clock, to override the
-   weak default version */
-#ifdef CONFIG_PARAVIRT
-unsigned long long sched_clock(void)
-{
-	return paravirt_sched_clock();
-}
-#else
-unsigned long long sched_clock(void)
-	__attribute__((alias("native_sched_clock")));
-#endif
-
 unsigned long native_calculate_cpu_khz(void)
 {
 	unsigned long long start, end;
@@ -238,11 +170,6 @@ time_cpufreq_notifier(struct notifier_bl
 						ref_freq, freq->new);
 			if (!(freq->flags & CPUFREQ_CONST_LOOPS)) {
 				tsc_khz = cpu_khz;
-				set_cyc2ns_scale(cpu_khz);
-				/*
-				 * TSC based sched_clock turns
-				 * to junk w/ cpufreq
-				 */
 				mark_tsc_unstable("cpufreq changes");
 			}
 		}
@@ -380,7 +307,6 @@ void __init tsc_init(void)
 				(unsigned long)cpu_khz / 1000,
 				(unsigned long)cpu_khz % 1000);
 
-	set_cyc2ns_scale(cpu_khz);
 	use_tsc_delay();
 
 	/* Check and install the TSC clocksource */
Index: linux/arch/i386/kernel/Makefile
===================================================================
--- linux.orig/arch/i386/kernel/Makefile
+++ linux/arch/i386/kernel/Makefile
@@ -7,7 +7,8 @@ extra-y := head.o init_task.o vmlinux.ld
 obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_i386.o \
 		pci-dma.o i386_ksyms.o i387.o bootflag.o e820.o\
-		quirks.o i8237.o topology.o alternative.o i8253.o tsc.o
+		quirks.o i8237.o topology.o alternative.o i8253.o tsc.o \
+		sched-clock.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
Index: linux/include/asm-i386/timer.h
===================================================================
--- linux.orig/include/asm-i386/timer.h
+++ linux/include/asm-i386/timer.h
@@ -6,7 +6,6 @@
 #define TICK_SIZE (tick_nsec / 1000)
 
 void setup_pit_timer(void);
-unsigned long long native_sched_clock(void);
 unsigned long native_calculate_cpu_khz(void);
 
 extern int timer_ack;
@@ -18,35 +17,6 @@ extern int recalibrate_cpu_khz(void);
 #define calculate_cpu_khz() native_calculate_cpu_khz()
 #endif
 
-/* Accellerators for sched_clock()
- * convert from cycles(64bits) => nanoseconds (64bits)
- *  basic equation:
- *		ns = cycles / (freq / ns_per_sec)
- *		ns = cycles * (ns_per_sec / freq)
- *		ns = cycles * (10^9 / (cpu_khz * 10^3))
- *		ns = cycles * (10^6 / cpu_khz)
- *
- *	Then we use scaling math (suggested by george@mvista.com) to get:
- *		ns = cycles * (10^6 * SC / cpu_khz) / SC
- *		ns = cycles * cyc2ns_scale / SC
- *
- *	And since SC is a constant power of two, we can convert the div
- *  into a shift.
- *
- *  We can use khz divisor instead of mhz to keep a better percision, since
- *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
- *  (mathieu.desnoyers@polymtl.ca)
- *
- *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
- */
-extern unsigned long cyc2ns_scale __read_mostly;
-
-#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
-
-static inline unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
-}
-
+u64 cycles_2_ns(u64 cyc);
 
 #endif
Index: linux/include/asm-i386/tsc.h
===================================================================
--- linux.orig/include/asm-i386/tsc.h
+++ linux/include/asm-i386/tsc.h
@@ -63,6 +63,7 @@ extern void tsc_init(void);
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
 extern void init_tsc_clocksource(void);
+extern unsigned long long tsc_sched_clock(void);
 
 /*
  * Boot-time check whether the TSCs are synchronized across

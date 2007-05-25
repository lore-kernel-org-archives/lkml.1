Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbXEYTdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbXEYTdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbXEYTc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:32:58 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:38285 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752680AbXEYTc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:32:57 -0400
Message-Id: <20070525193242.248168149@mvista.com>
References: <20070525193209.607200255@mvista.com>
User-Agent: quilt/0.46
Date: Fri, 25 May 2007 12:32:11 -0700
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org
Content-Disposition: inline; filename=sched-clock-follows-percpu-frequency.patch
Subject: [PATCH 2/2] i386: sched_clock() follows percpu frequency changes -v2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Considering that Andi has a similar patch, I'm going to assume there
is already justification for this..

What it ends up doing is allows the TSC to be used in cases which
we didn't use it before, and hope it's still mostly accurate.

For instance, when the frequency changes due to cpufreq we update
sched_clock to convert cycles to nanoseconds using the new frequency.
I also allow tsc usage when the tsc is considered unsynced on an SMP
system. My understanding is that the scheduler should only be
comparing one cpus tsc to itself, and not to other cpus tsc. So
it should handle unsynced tsc.

I ran lat_ctx a few times to see the difference,

Before this patch,

root@happy:~# lat_ctx -s 0 2

"size=0k ovr=1.40
2 1.06
root@happy:~# lat_ctx -s 0 2

"size=0k ovr=1.39
2 0.91

After this patch,

root@happy:~# lat_ctx -s 0 2

"size=0k ovr=1.14
2 0.64
root@happy:~# lat_ctx -s 0 2

"size=0k ovr=1.12
2 0.97

I don't see a great deal of difference here. Considering the wide range
of values I get from lat_ctx it's all within the margin of error. If anyone
can better test this, or has thoughts on it I'm all ears.

Comment are certainly welcome ..

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---

Against 2.6.22-rc2	

 arch/i386/kernel/tsc.c      |  128 ++++++++++++++++++++------------------------
 include/linux/clocksource.h |   14 +++-
 2 files changed, 72 insertions(+), 70 deletions(-)

Index: linux-2.6.21/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.21/arch/i386/kernel/tsc.c
@@ -18,7 +18,7 @@
 
 #include "mach_timer.h"
 
-static int tsc_enabled;
+static struct clocksource clocksource_tsc;
 
 /*
  * On some systems the TSC frequency does not
@@ -56,46 +56,18 @@ __setup("notsc", tsc_setup);
  * due to cpufreq or due to unsynced TSCs
  */
 static int tsc_unstable;
+static int tsc_sched_clock_unstable;
 
 static inline int check_tsc_unstable(void)
 {
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
+/*
+ * Place holder for the percpu mult values used by sched_clock() to
+ * overcome a system which shifts frequencies per cpu.
  */
-static unsigned long cyc2ns_scale __read_mostly;
-
-#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
-
-static inline void set_cyc2ns_scale(unsigned long cpu_khz)
-{
-	cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
-}
-
-static inline unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
-}
+DEFINE_PER_CPU(u32, cpu_khz_mult);
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -103,19 +75,26 @@ static inline unsigned long long cycles_
 unsigned long long sched_clock(void)
 {
 	unsigned long long this_offset;
+	u32 this_cpus_mult;
 
 	/*
-	 * Fall back to jiffies if there's no TSC available:
+	 * Fall back to jiffies if the TSC is unusable:
 	 */
-	if (unlikely(!tsc_enabled))
+	if (unlikely(tsc_sched_clock_unstable))
 		/* No locking but a rare wrong value is not a big deal: */
-		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
+		return cyc2ns_sc(clocksource_jiffies.shift,
+				 clocksource_jiffies.mult, jiffies);
+
+	this_cpus_mult = per_cpu(cpu_khz_mult, raw_smp_processor_id());
 
 	/* read the Time Stamp Counter: */
 	get_scheduled_cycles(this_offset);
 
-	/* return the value in ns */
-	return cycles_2_ns(this_offset);
+	/*
+	 * We take advantage of the clocksource since it uses
+	 * the same math to convert to nanoseconds.
+	 */
+	return cyc2ns_sc(clocksource_tsc.shift, this_cpus_mult, this_offset);
 }
 
 unsigned long native_calculate_cpu_khz(void)
@@ -213,27 +192,36 @@ time_cpufreq_notifier(struct notifier_bl
 	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
 	    (val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
 	    (val == CPUFREQ_RESUMECHANGE)) {
-		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
-			cpu_data[freq->cpu].loops_per_jiffy =
-				cpufreq_scale(loops_per_jiffy_ref,
-						ref_freq, freq->new);
-
-		if (cpu_khz) {
-
-			if (num_online_cpus() == 1)
-				cpu_khz = cpufreq_scale(cpu_khz_ref,
-						ref_freq, freq->new);
-			if (!(freq->flags & CPUFREQ_CONST_LOOPS)) {
-				tsc_khz = cpu_khz;
-				set_cyc2ns_scale(cpu_khz);
-				/*
-				 * TSC based sched_clock turns
-				 * to junk w/ cpufreq
-				 */
-				mark_tsc_unstable(CLOCK_TSC_CPUFREQ_ADJUSTED,
-						  "cpufreq changes");
-			}
-		}
+
+		if (likely(cpu_khz) && num_online_cpus() == 1)
+			cpu_khz = cpufreq_scale(cpu_khz_ref, ref_freq,
+						freq->new);
+
+		if ((freq->flags & CPUFREQ_CONST_LOOPS))
+			return 0;
+
+		cpu_data[freq->cpu].loops_per_jiffy =
+			cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
+
+		if (unlikely(!cpu_khz))
+			return 0;
+
+		tsc_khz = cpu_khz;
+
+		/*
+		 * Set the new percpu mult value to be used
+		 * for sched_clock(). We can't use cpu_khz
+		 * since it's only tracking a single cpu.
+		 */
+		per_cpu(cpu_khz_mult, freq->cpu) =
+			clocksource_hz2mult(freq->new,
+					     clocksource_tsc.shift);
+		/*
+		 * TSC based gettimeofday turns
+		 * to junk w/ cpufreq
+		 */
+		mark_tsc_unstable(CLOCK_TSC_CPUFREQ_ADJUSTED,
+				  "cpufreq changes");
 	}
 
 	return 0;
@@ -278,17 +266,17 @@ static struct clocksource clocksource_ts
 
 void mark_tsc_unstable(enum tsc_unstable_flags flag, char *reason)
 {
-	if (likely(tsc_unstable))
-		return;
-
 	switch (flag) {
 		case CLOCK_TSC_UNSTABLE_FREQUENCY:
 		case CLOCK_TSC_HALTS_IN_CSTATES:
+			tsc_sched_clock_unstable = 1;
 
 		case CLOCK_TSC_UNSYNCHRONIZED:
 		case CLOCK_TSC_CPUFREQ_ADJUSTED:
+			if (likely(tsc_unstable))
+				return;
+
 			tsc_unstable = 1;
-			tsc_enabled = 0;
 			printk("Marking TSC unstable due to: %s.\n", reason);
 			/* Can be called before registration */
 			if (clocksource_tsc.mult)
@@ -361,6 +349,8 @@ static inline void check_geode_tsc_relia
 
 void __init tsc_init(void)
 {
+	int cpu;
+
 	if (!cpu_has_tsc || tsc_disable)
 		goto out_no_tsc;
 
@@ -374,7 +364,6 @@ void __init tsc_init(void)
 				(unsigned long)cpu_khz / 1000,
 				(unsigned long)cpu_khz % 1000);
 
-	set_cyc2ns_scale(cpu_khz);
 	use_tsc_delay();
 
 	/* Check and install the TSC clocksource */
@@ -385,12 +374,17 @@ void __init tsc_init(void)
 	current_tsc_khz = tsc_khz;
 	clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
 							clocksource_tsc.shift);
+	/*
+	 * Initialize the per cpu mult values used in sched_clock()
+	 */
+	for_each_possible_cpu(cpu)
+		per_cpu(cpu_khz_mult, cpu) = clocksource_tsc.mult;
+
 	/* lower the rating if we already know its unstable: */
 	if (check_tsc_unstable()) {
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
-	} else
-		tsc_enabled = 1;
+	}
 
 	clocksource_register(&clocksource_tsc);
 
Index: linux-2.6.21/include/linux/clocksource.h
===================================================================
--- linux-2.6.21.orig/include/linux/clocksource.h
+++ linux-2.6.21/include/linux/clocksource.h
@@ -21,6 +21,12 @@
 typedef u64 cycle_t;
 struct clocksource;
 
+/*
+ * clocksource_jiffies is the only generic clock. It may
+ * be used for initialization, or generic clock needs.
+ */
+extern struct clocksource clocksource_jiffies;
+
 /**
  * struct clocksource - hardware abstraction for a free running counter
  *	Provides mostly state-free accessors to the underlying hardware.
@@ -161,6 +167,10 @@ static inline cycle_t clocksource_read(s
 	return cs->read();
 }
 
+static inline s64 cyc2ns_sc(u32 shift, u32 mult, cycle_t cycles)
+{
+	return ((cycles * mult) >> shift);
+}
 /**
  * cyc2ns - converts clocksource cycles to nanoseconds
  * @cs:		Pointer to clocksource
@@ -172,9 +182,7 @@ static inline cycle_t clocksource_read(s
  */
 static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
 {
-	u64 ret = (u64)cycles;
-	ret = (ret * cs->mult) >> cs->shift;
-	return ret;
+	return cyc2ns_sc(cs->shift, cs->mult, cycles);
 }
 
 /**

-- 

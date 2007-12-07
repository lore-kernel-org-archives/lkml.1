Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbXLGOwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbXLGOwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 09:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbXLGOwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 09:52:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48771 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbXLGOwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 09:52:43 -0500
Date: Fri, 7 Dec 2007 15:52:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] x86: scale cyc_2_nsec according to CPU frequency
Message-ID: <20071207145206.GA21326@elte.hu>
References: <20071207021952.6f0ac922@morte> <alpine.LFD.0.99999.0712070646210.3221@localhost.localdomain> <3d8471ca0712062318j483f8be6h256778752a13639a@mail.gmail.com> <20071207090252.1caf1509@inria.fr> <20071207135525.GA5588@elte.hu> <20071207152741.3408aeef@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207152741.3408aeef@inria.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> Le Fri, 7 Dec 2007 14:55:25 +0100,
> Ingo Molnar <mingo@elte.hu> a ??crit :
> 
> > Firstly, we dont need the 'offset' anymore because cpu_clock() 
> > maintains offsets itself.
> 
> Yes, but a lower quality one. __update_rq_clock tries to compensate 
> large jumping clocks with a jiffy resolution, while my offset arranges 
> for a very smooth frequency transition.

yes, but that would be easy to fix up via calling 
sched_clock_idle_wakeup_event(0) when doing a frequency transition, 
without burdening the normal sched_clock() codepath with the offset. See 
the attached latest version.

	Ingo

--------------->
Subject: x86: scale cyc_2_nsec according to CPU frequency
From: "Guillaume Chazarain" <guichaz@yahoo.fr>

scale the sched_clock() cyc_2_nsec scaling factor according to
CPU frequency changes.

[ mingo@elte.hu: simplified it and fixed it for SMP. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tsc_32.c |   45 +++++++++++++++++++++++++++++++----
 arch/x86/kernel/tsc_64.c |   59 +++++++++++++++++++++++++++++++++++++++--------
 include/asm-x86/timer.h  |   23 ++++++++++++++----
 3 files changed, 106 insertions(+), 21 deletions(-)

Index: linux-x86.q/arch/x86/kernel/tsc_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/tsc_32.c
+++ linux-x86.q/arch/x86/kernel/tsc_32.c
@@ -5,6 +5,7 @@
 #include <linux/jiffies.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
+#include <linux/percpu.h>
 
 #include <asm/delay.h>
 #include <asm/tsc.h>
@@ -78,15 +79,35 @@ EXPORT_SYMBOL_GPL(check_tsc_unstable);
  *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
  *  (mathieu.desnoyers@polymtl.ca)
  *
+ *  ns += offset to avoid sched_clock jumps with cpufreq
+ *
  *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
-unsigned long cyc2ns_scale __read_mostly;
 
-#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
+DEFINE_PER_CPU(unsigned long, cyc2ns);
 
-static inline void set_cyc2ns_scale(unsigned long cpu_khz)
+static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
-	cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
+	unsigned long flags, prev_scale, *scale;
+	unsigned long long tsc_now, ns_now;
+
+	local_irq_save(flags);
+	sched_clock_idle_sleep_event();
+
+	scale = &per_cpu(cyc2ns, cpu);
+
+	rdtscll(tsc_now);
+	ns_now = __cycles_2_ns(tsc_now);
+
+	prev_scale = *scale;
+	if (cpu_khz)
+		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+
+	/*
+	 * Start smoothly with the new frequency:
+	 */
+	sched_clock_idle_wakeup_event(0);
+	local_irq_restore(flags);
 }
 
 /*
@@ -239,7 +260,9 @@ time_cpufreq_notifier(struct notifier_bl
 						ref_freq, freq->new);
 			if (!(freq->flags & CPUFREQ_CONST_LOOPS)) {
 				tsc_khz = cpu_khz;
-				set_cyc2ns_scale(cpu_khz);
+				preempt_disable();
+				set_cyc2ns_scale(cpu_khz, smp_processor_id());
+				preempt_enable();
 				/*
 				 * TSC based sched_clock turns
 				 * to junk w/ cpufreq
@@ -367,6 +390,8 @@ static inline void check_geode_tsc_relia
 
 void __init tsc_init(void)
 {
+	int cpu;
+
 	if (!cpu_has_tsc || tsc_disable)
 		goto out_no_tsc;
 
@@ -380,7 +405,15 @@ void __init tsc_init(void)
 				(unsigned long)cpu_khz / 1000,
 				(unsigned long)cpu_khz % 1000);
 
-	set_cyc2ns_scale(cpu_khz);
+	/*
+	 * Secondary CPUs do not run through tsc_init(), so set up
+	 * all the scale factors for all CPUs, assuming the same
+	 * speed as the bootup CPU. (cpufreq notifiers will fix this
+	 * up if their speed diverges)
+	 */
+	for_each_possible_cpu(cpu)
+		set_cyc2ns_scale(cpu_khz, cpu);
+
 	use_tsc_delay();
 
 	/* Check and install the TSC clocksource */
Index: linux-x86.q/arch/x86/kernel/tsc_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/tsc_64.c
+++ linux-x86.q/arch/x86/kernel/tsc_64.c
@@ -10,6 +10,7 @@
 
 #include <asm/hpet.h>
 #include <asm/timex.h>
+#include <asm/timer.h>
 
 static int notsc __initdata = 0;
 
@@ -18,16 +19,50 @@ EXPORT_SYMBOL(cpu_khz);
 unsigned int tsc_khz;
 EXPORT_SYMBOL(tsc_khz);
 
-static unsigned int cyc2ns_scale __read_mostly;
+/* Accelerators for sched_clock()
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
+ *  We can use khz divisor instead of mhz to keep a better precision, since
+ *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
+ *  (mathieu.desnoyers@polymtl.ca)
+ *
+ *  ns += offset to avoid sched_clock jumps with cpufreq
+ *
+ *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
+ */
+DEFINE_PER_CPU(unsigned long, cyc2ns);
 
-static inline void set_cyc2ns_scale(unsigned long khz)
+static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
-	cyc2ns_scale = (NSEC_PER_MSEC << NS_SCALE) / khz;
-}
+	unsigned long flags, prev_scale, *scale;
+	unsigned long long tsc_now, ns_now;
 
-static unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	return (cyc * cyc2ns_scale) >> NS_SCALE;
+	local_irq_save(flags);
+	sched_clock_idle_sleep_event();
+
+	scale = &per_cpu(cyc2ns, cpu);
+
+	rdtscll(tsc_now);
+	ns_now = __cycles_2_ns(tsc_now);
+
+	prev_scale = *scale;
+	if (cpu_khz)
+		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+
+	sched_clock_idle_wakeup_event(0);
+	local_irq_restore(flags);
 }
 
 unsigned long long sched_clock(void)
@@ -100,7 +135,9 @@ static int time_cpufreq_notifier(struct 
 			mark_tsc_unstable("cpufreq changes");
 	}
 
-	set_cyc2ns_scale(tsc_khz_ref);
+	preempt_disable();
+	set_cyc2ns_scale(tsc_khz_ref, smp_processor_id());
+	preempt_enable();
 
 	return 0;
 }
@@ -151,7 +188,7 @@ static unsigned long __init tsc_read_ref
 void __init tsc_calibrate(void)
 {
 	unsigned long flags, tsc1, tsc2, tr1, tr2, pm1, pm2, hpet1, hpet2;
-	int hpet = is_hpet_enabled();
+	int hpet = is_hpet_enabled(), cpu;
 
 	local_irq_save(flags);
 
@@ -206,7 +243,9 @@ void __init tsc_calibrate(void)
 	}
 
 	tsc_khz = tsc2 / tsc1;
-	set_cyc2ns_scale(tsc_khz);
+
+	for_each_possible_cpu(cpu)
+		set_cyc2ns_scale(tsc_khz, cpu);
 }
 
 /*
Index: linux-x86.q/include/asm-x86/timer.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/timer.h
+++ linux-x86.q/include/asm-x86/timer.h
@@ -2,6 +2,7 @@
 #define _ASMi386_TIMER_H
 #include <linux/init.h>
 #include <linux/pm.h>
+#include <linux/percpu.h>
 
 #define TICK_SIZE (tick_nsec / 1000)
 
@@ -16,7 +17,7 @@ extern int recalibrate_cpu_khz(void);
 #define calculate_cpu_khz() native_calculate_cpu_khz()
 #endif
 
-/* Accellerators for sched_clock()
+/* Accelerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
  *  basic equation:
  *		ns = cycles / (freq / ns_per_sec)
@@ -31,20 +32,32 @@ extern int recalibrate_cpu_khz(void);
  *	And since SC is a constant power of two, we can convert the div
  *  into a shift.
  *
- *  We can use khz divisor instead of mhz to keep a better percision, since
+ *  We can use khz divisor instead of mhz to keep a better precision, since
  *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
  *  (mathieu.desnoyers@polymtl.ca)
  *
  *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
-extern unsigned long cyc2ns_scale __read_mostly;
+
+DECLARE_PER_CPU(unsigned long, cyc2ns);
 
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
-static inline unsigned long long cycles_2_ns(unsigned long long cyc)
+static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
 {
-	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
+	return cyc * per_cpu(cyc2ns, smp_processor_id()) >> CYC2NS_SCALE_FACTOR;
 }
 
+static inline unsigned long long cycles_2_ns(unsigned long long cyc)
+{
+	unsigned long long ns;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	ns = __cycles_2_ns(cyc);
+	local_irq_restore(flags);
+
+	return ns;
+}
 
 #endif

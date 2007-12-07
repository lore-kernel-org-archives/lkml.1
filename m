Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbXLGOzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbXLGOzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 09:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbXLGOyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 09:54:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48986 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbXLGOyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 09:54:54 -0500
Date: Fri, 7 Dec 2007 15:54:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: stefano.brivio@polimi.it
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071207145418.GA22277@elte.hu>
References: <20071207021952.6f0ac922@morte> <20071207084559.GA11162@elte.hu> <200712072213.06530.nickpiggin@yahoo.com.au> <20071207122310.maqkoxlb4gsg4ggc@webmail.polimi.it> <20071207122516.GA25115@elte.hu> <20071207123509.GA28676@elte.hu> <20071207124034.GA30052@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207124034.GA30052@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> third update. the cpufreq callbacks are not quite OK yet.

fourth update - the cpufreq callbacks are back. This is a version that 
is supposed fix all known aspects of TSC and frequency-change 
weirdnesses.

	Ingo

Index: linux/arch/arm/kernel/time.c
===================================================================
--- linux.orig/arch/arm/kernel/time.c
+++ linux/arch/arm/kernel/time.c
@@ -79,17 +79,6 @@ static unsigned long dummy_gettimeoffset
 }
 #endif
 
-/*
- * An implementation of printk_clock() independent from
- * sched_clock().  This avoids non-bootable kernels when
- * printk_clock is enabled.
- */
-unsigned long long printk_clock(void)
-{
-	return (unsigned long long)(jiffies - INITIAL_JIFFIES) *
-			(1000000000 / HZ);
-}
-
 static unsigned long next_rtc_update;
 
 /*
Index: linux/arch/ia64/kernel/time.c
===================================================================
--- linux.orig/arch/ia64/kernel/time.c
+++ linux/arch/ia64/kernel/time.c
@@ -344,33 +344,6 @@ udelay (unsigned long usecs)
 }
 EXPORT_SYMBOL(udelay);
 
-static unsigned long long ia64_itc_printk_clock(void)
-{
-	if (ia64_get_kr(IA64_KR_PER_CPU_DATA))
-		return sched_clock();
-	return 0;
-}
-
-static unsigned long long ia64_default_printk_clock(void)
-{
-	return (unsigned long long)(jiffies_64 - INITIAL_JIFFIES) *
-		(1000000000/HZ);
-}
-
-unsigned long long (*ia64_printk_clock)(void) = &ia64_default_printk_clock;
-
-unsigned long long printk_clock(void)
-{
-	return ia64_printk_clock();
-}
-
-void __init
-ia64_setup_printk_clock(void)
-{
-	if (!(sal_platform_features & IA64_SAL_PLATFORM_FEATURE_ITC_DRIFT))
-		ia64_printk_clock = ia64_itc_printk_clock;
-}
-
 /* IA64 doesn't cache the timezone */
 void update_vsyscall_tz(void)
 {
Index: linux/arch/x86/kernel/process_32.c
===================================================================
--- linux.orig/arch/x86/kernel/process_32.c
+++ linux/arch/x86/kernel/process_32.c
@@ -113,10 +113,19 @@ void default_idle(void)
 		smp_mb();
 
 		local_irq_disable();
-		if (!need_resched())
+		if (!need_resched()) {
+			ktime_t t0, t1;
+			u64 t0n, t1n;
+
+			t0 = ktime_get();
+			t0n = ktime_to_ns(t0);
 			safe_halt();	/* enables interrupts racelessly */
-		else
-			local_irq_enable();
+			local_irq_disable();
+			t1 = ktime_get();
+			t1n = ktime_to_ns(t1);
+			sched_clock_idle_wakeup_event(t1n - t0n);
+		}
+		local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
 	} else {
 		/* loop is done by the caller */
Index: linux/arch/x86/kernel/tsc_32.c
===================================================================
--- linux.orig/arch/x86/kernel/tsc_32.c
+++ linux/arch/x86/kernel/tsc_32.c
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
Index: linux/arch/x86/kernel/tsc_64.c
===================================================================
--- linux.orig/arch/x86/kernel/tsc_64.c
+++ linux/arch/x86/kernel/tsc_64.c
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
Index: linux/drivers/acpi/processor_idle.c
===================================================================
--- linux.orig/drivers/acpi/processor_idle.c
+++ linux/drivers/acpi/processor_idle.c
@@ -531,6 +531,11 @@ static void acpi_processor_idle(void)
 
 	case ACPI_STATE_C3:
 		/*
+		 * Must be done before busmaster disable as we might
+		 * need to access HPET !
+		 */
+		acpi_state_timer_broadcast(pr, cx, 1);
+		/*
 		 * disable bus master
 		 * bm_check implies we need ARB_DIS
 		 * !bm_check implies we need cache flush
@@ -557,7 +562,6 @@ static void acpi_processor_idle(void)
 		/* Get start time (ticks) */
 		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 		/* Invoke C3 */
-		acpi_state_timer_broadcast(pr, cx, 1);
 		/* Tell the scheduler that we are going deep-idle: */
 		sched_clock_idle_sleep_event();
 		acpi_cstate_enter(cx);
@@ -1401,9 +1405,6 @@ static int acpi_idle_enter_simple(struct
 	if (acpi_idle_suspend)
 		return(acpi_idle_enter_c1(dev, state));
 
-	if (pr->flags.bm_check)
-		acpi_idle_update_bm_rld(pr, cx);
-
 	local_irq_disable();
 	current_thread_info()->status &= ~TS_POLLING;
 	/*
@@ -1418,13 +1419,21 @@ static int acpi_idle_enter_simple(struct
 		return 0;
 	}
 
+	/*
+	 * Must be done before busmaster disable as we might need to
+	 * access HPET !
+	 */
+	acpi_state_timer_broadcast(pr, cx, 1);
+
+	if (pr->flags.bm_check)
+		acpi_idle_update_bm_rld(pr, cx);
+
 	if (cx->type == ACPI_STATE_C3)
 		ACPI_FLUSH_CPU_CACHE();
 
 	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 	/* Tell the scheduler that we are going deep-idle: */
 	sched_clock_idle_sleep_event();
-	acpi_state_timer_broadcast(pr, cx, 1);
 	acpi_idle_do_entry(cx);
 	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
Index: linux/include/asm-x86/timer.h
===================================================================
--- linux.orig/include/asm-x86/timer.h
+++ linux/include/asm-x86/timer.h
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
Index: linux/kernel/hrtimer.c
===================================================================
--- linux.orig/kernel/hrtimer.c
+++ linux/kernel/hrtimer.c
@@ -850,6 +850,14 @@ hrtimer_start(struct hrtimer *timer, kti
 #ifdef CONFIG_TIME_LOW_RES
 		tim = ktime_add(tim, base->resolution);
 #endif
+		/*
+		 * Careful here: User space might have asked for a
+		 * very long sleep, so the add above might result in a
+		 * negative number, which enqueues the timer in front
+		 * of the queue.
+		 */
+		if (tim.tv64 < 0)
+			tim.tv64 = KTIME_MAX;
 	}
 	timer->expires = tim;
 
Index: linux/kernel/lockdep.c
===================================================================
--- linux.orig/kernel/lockdep.c
+++ linux/kernel/lockdep.c
@@ -2654,10 +2654,15 @@ static void check_flags(unsigned long fl
 	if (!debug_locks)
 		return;
 
-	if (irqs_disabled_flags(flags))
-		DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled);
-	else
-		DEBUG_LOCKS_WARN_ON(!current->hardirqs_enabled);
+	if (irqs_disabled_flags(flags)) {
+		if (DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)) {
+			printk("possible reason: unannotated irqs-off.\n");
+		}
+	} else {
+		if (DEBUG_LOCKS_WARN_ON(!current->hardirqs_enabled)) {
+			printk("possible reason: unannotated irqs-on.\n");
+		}
+	}
 
 	/*
 	 * We dont accurately track softirq state in e.g.
Index: linux/kernel/printk.c
===================================================================
--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -573,11 +573,6 @@ static int __init printk_time_setup(char
 
 __setup("time", printk_time_setup);
 
-__attribute__((weak)) unsigned long long printk_clock(void)
-{
-	return sched_clock();
-}
-
 /* Check if we have any console registered that can be called early in boot. */
 static int have_callable_console(void)
 {
@@ -628,30 +623,57 @@ asmlinkage int printk(const char *fmt, .
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int printk_cpu = UINT_MAX;
 
+const char printk_recursion_bug_msg [] =
+			KERN_CRIT "BUG: recent printk recursion!\n";
+static int printk_recursion_bug;
+
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
+	static int log_level_unknown = 1;
+	static char printk_buf[1024];
+
 	unsigned long flags;
-	int printed_len;
+	int printed_len = 0;
+	int this_cpu;
 	char *p;
-	static char printk_buf[1024];
-	static int log_level_unknown = 1;
 
 	boot_delay_msec();
 
 	preempt_disable();
-	if (unlikely(oops_in_progress) && printk_cpu == smp_processor_id())
-		/* If a crash is occurring during printk() on this CPU,
-		 * make sure we can't deadlock */
-		zap_locks();
-
 	/* This stops the holder of console_sem just where we want him */
 	raw_local_irq_save(flags);
+	this_cpu = smp_processor_id();
+
+	/*
+	 * Ouch, printk recursed into itself!
+	 */
+	if (unlikely(printk_cpu == this_cpu)) {
+		/*
+		 * If a crash is occurring during printk() on this CPU,
+		 * then try to get the crash message out but make sure
+		 * we can't deadlock. Otherwise just return to avoid the
+		 * recursion and return - but flag the recursion so that
+		 * it can be printed at the next appropriate moment:
+		 */
+		if (!oops_in_progress) {
+			printk_recursion_bug = 1;
+			goto out_restore_irqs;
+		}
+		zap_locks();
+	}
+
 	lockdep_off();
 	spin_lock(&logbuf_lock);
-	printk_cpu = smp_processor_id();
+	printk_cpu = this_cpu;
 
+	if (printk_recursion_bug) {
+		printk_recursion_bug = 0;
+		strcpy(printk_buf, printk_recursion_bug_msg);
+		printed_len = sizeof(printk_recursion_bug_msg);
+	}
 	/* Emit the output into the temporary buffer */
-	printed_len = vscnprintf(printk_buf, sizeof(printk_buf), fmt, args);
+	printed_len += vscnprintf(printk_buf + printed_len,
+				  sizeof(printk_buf), fmt, args);
 
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
@@ -680,7 +702,11 @@ asmlinkage int vprintk(const char *fmt, 
 					loglev_char = default_message_loglevel
 						+ '0';
 				}
-				t = printk_clock();
+				if (panic_timeout) {
+					panic_timeout = 0;
+					printk("recurse!\n");
+				}
+				t = cpu_clock(printk_cpu);
 				nanosec_rem = do_div(t, 1000000000);
 				tlen = sprintf(tbuf,
 						"<%c>[%5lu.%06lu] ",
@@ -744,6 +770,7 @@ asmlinkage int vprintk(const char *fmt, 
 		printk_cpu = UINT_MAX;
 		spin_unlock(&logbuf_lock);
 		lockdep_on();
+out_restore_irqs:
 		raw_local_irq_restore(flags);
 	}
 
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -488,7 +488,12 @@ unsigned long long cpu_clock(int cpu)
 
 	local_irq_save(flags);
 	rq = cpu_rq(cpu);
-	update_rq_clock(rq);
+	/*
+	 * Only call sched_clock() if the scheduler has already been
+	 * initialized (some code might call cpu_clock() very early):
+	 */
+	if (rq->idle)
+		update_rq_clock(rq);
 	now = rq->clock;
 	local_irq_restore(flags);
 
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -511,8 +511,7 @@ place_entity(struct cfs_rq *cfs_rq, stru
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se) &&
-				task_of(se)->policy != SCHED_BATCH)
+		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se))
 			vruntime -= sysctl_sched_latency;
 
 		/* ensure we never gain time by being placed backwards. */
Index: linux/kernel/time/clockevents.c
===================================================================
--- linux.orig/kernel/time/clockevents.c
+++ linux/kernel/time/clockevents.c
@@ -78,6 +78,11 @@ int clockevents_program_event(struct clo
 	unsigned long long clc;
 	int64_t delta;
 
+	if (unlikely(expires.tv64 < 0)) {
+		WARN_ON_ONCE(1);
+		return -ETIME;
+	}
+
 	delta = ktime_to_ns(ktime_sub(expires, now));
 
 	if (delta <= 0)

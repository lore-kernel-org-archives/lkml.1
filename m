Return-Path: <linux-kernel-owner+w=401wt.eu-S933218AbZLFKBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218AbZLFKBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 05:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933200AbZLFKBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 05:01:48 -0500
Received: from www.tglx.de ([62.245.132.106]:48344 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933195AbZLFKBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 05:01:45 -0500
Date: Sun, 6 Dec 2009 11:00:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timers core for 2.6.33
Message-ID: <alpine.LFD.2.00.0912061100100.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus

Thanks,

	tglx

------------------>
H Hartley Sweeten (1):
      clockevents: Add missing include to pacify sparse

John Stultz (2):
      time: Implement logarithmic time accumulation
      time: Remove xtime_cache

Jon Hunter (2):
      nohz: Prevent clocksource wrapping during idle
      nohz: Allow 32-bit machines to sleep for more than 2.15 seconds

Martin Schwidefsky (2):
      nohz: Reuse ktime in sub-functions of tick_check_idle.
      nohz: Introduce arch_needs_cpu

Mike Travis (1):
      timers, init: Limit the number of per cpu calibration bootup messages

Stanislaw Gruszka (1):
      posix-cpu-timers: optimize and document timer_create callback

Stephen Rothwell (1):
      sparc: fix printk for change of variable type

Thomas Gleixner (8):
      clockevents: Use u32 for mult and shift factors
      clocksource: Provide a generic mult/shift factor calculation
      mips: Use generic mult/shift factor calculation for clocks
      nohz: Type cast printk argument
      nohz: Track last do_timer() cpu
      clocksource/events: Fix fallout of generic code changes
      x86: Fix printk format due to variable type change
      x86: vmiclock: Fix printk format


 arch/mips/include/asm/time.h    |   14 +++-
 arch/mips/kernel/time.c         |   33 ---------
 arch/powerpc/kernel/time.c      |    2 +-
 arch/s390/include/asm/cputime.h |    8 ++
 arch/s390/kernel/s390_ext.c     |    2 +
 arch/s390/kernel/vtime.c        |    2 +
 arch/sparc/kernel/time_64.c     |    2 +-
 arch/x86/kernel/apic/apic.c     |    2 +-
 arch/x86/kernel/vmiclock_32.c   |    2 +-
 drivers/s390/cio/cio.c          |    1 +
 include/linux/clockchips.h      |   19 ++++--
 include/linux/clocksource.h     |   12 +++
 include/linux/tick.h            |    5 ++
 include/linux/time.h            |    1 +
 include/linux/timex.h           |    4 -
 init/calibrate.c                |   24 ++++---
 kernel/cpu.c                    |    5 +-
 kernel/hrtimer.c                |    3 +-
 kernel/posix-cpu-timers.c       |    5 +-
 kernel/time.c                   |    1 -
 kernel/time/clockevents.c       |   13 ++--
 kernel/time/clocksource.c       |   97 +++++++++++++++++++++++++++
 kernel/time/tick-oneshot.c      |    4 +-
 kernel/time/tick-sched.c        |  141 ++++++++++++++++++++++++---------------
 kernel/time/timekeeping.c       |  119 ++++++++++++++++++++-------------
 kernel/time/timer_list.c        |   10 ++-
 26 files changed, 353 insertions(+), 178 deletions(-)

diff --git a/arch/mips/include/asm/time.h b/arch/mips/include/asm/time.h
index df6a430..c7f1bfe 100644
--- a/arch/mips/include/asm/time.h
+++ b/arch/mips/include/asm/time.h
@@ -84,8 +84,16 @@ static inline int init_mips_clocksource(void)
 #endif
 }
 
-extern void clocksource_set_clock(struct clocksource *cs, unsigned int clock);
-extern void clockevent_set_clock(struct clock_event_device *cd,
-		unsigned int clock);
+static inline void clocksource_set_clock(struct clocksource *cs,
+					 unsigned int clock)
+{
+	clocksource_calc_mult_shift(cs, clock, 4);
+}
+
+static inline void clockevent_set_clock(struct clock_event_device *cd,
+					unsigned int clock)
+{
+	clockevents_calc_mult_shift(cd, clock, 4);
+}
 
 #endif /* _ASM_TIME_H */
diff --git a/arch/mips/kernel/time.c b/arch/mips/kernel/time.c
index 1f467d5..fb74974 100644
--- a/arch/mips/kernel/time.c
+++ b/arch/mips/kernel/time.c
@@ -71,39 +71,6 @@ EXPORT_SYMBOL(perf_irq);
 
 unsigned int mips_hpt_frequency;
 
-void __init clocksource_set_clock(struct clocksource *cs, unsigned int clock)
-{
-	u64 temp;
-	u32 shift;
-
-	/* Find a shift value */
-	for (shift = 32; shift > 0; shift--) {
-		temp = (u64) NSEC_PER_SEC << shift;
-		do_div(temp, clock);
-		if ((temp >> 32) == 0)
-			break;
-	}
-	cs->shift = shift;
-	cs->mult = (u32) temp;
-}
-
-void __cpuinit clockevent_set_clock(struct clock_event_device *cd,
-	unsigned int clock)
-{
-	u64 temp;
-	u32 shift;
-
-	/* Find a shift value */
-	for (shift = 32; shift > 0; shift--) {
-		temp = (u64) clock << shift;
-		do_div(temp, NSEC_PER_SEC);
-		if ((temp >> 32) == 0)
-			break;
-	}
-	cd->shift = shift;
-	cd->mult = (u32) temp;
-}
-
 /*
  * This function exists in order to cause an error due to a duplicate
  * definition if platform code should have its own implementation.  The hook
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 92dc844..60ceb27 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -905,7 +905,7 @@ static void register_decrementer_clockevent(int cpu)
 	*dec = decrementer_clockevent;
 	dec->cpumask = cpumask_of(cpu);
 
-	printk(KERN_DEBUG "clockevent: %s mult[%lx] shift[%d] cpu[%d]\n",
+	printk(KERN_DEBUG "clockevent: %s mult[%x] shift[%d] cpu[%d]\n",
 	       dec->name, dec->mult, dec->shift, cpu);
 
 	clockevents_register_device(dec);
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index 24b1244..95f3561 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -183,6 +183,7 @@ struct s390_idle_data {
 	unsigned long long idle_count;
 	unsigned long long idle_enter;
 	unsigned long long idle_time;
+	int nohz_delay;
 };
 
 DECLARE_PER_CPU(struct s390_idle_data, s390_idle);
@@ -198,4 +199,11 @@ static inline void s390_idle_check(void)
 		vtime_start_cpu();
 }
 
+static inline int s390_nohz_delay(int cpu)
+{
+	return per_cpu(s390_idle, cpu).nohz_delay != 0;
+}
+
+#define arch_needs_cpu(cpu) s390_nohz_delay(cpu)
+
 #endif /* _S390_CPUTIME_H */
diff --git a/arch/s390/kernel/s390_ext.c b/arch/s390/kernel/s390_ext.c
index 0de305b..59618bc 100644
--- a/arch/s390/kernel/s390_ext.c
+++ b/arch/s390/kernel/s390_ext.c
@@ -126,6 +126,8 @@ void __irq_entry do_extint(struct pt_regs *regs, unsigned short code)
 		/* Serve timer interrupts first. */
 		clock_comparator_work();
 	kstat_cpu(smp_processor_id()).irqs[EXTERNAL_INTERRUPT]++;
+	if (code != 0x1004)
+		__get_cpu_var(s390_idle).nohz_delay = 1;
         index = ext_hash(code);
 	for (p = ext_int_hash[index]; p; p = p->next) {
 		if (likely(p->code == code))
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index c41bb0d..b59a812 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -167,6 +167,8 @@ void vtime_stop_cpu(void)
 	/* Wait for external, I/O or machine check interrupt. */
 	psw.mask = psw_kernel_bits | PSW_MASK_WAIT | PSW_MASK_IO | PSW_MASK_EXT;
 
+	idle->nohz_delay = 0;
+
 	/* Check if the CPU timer needs to be reprogrammed. */
 	if (vq->do_spt) {
 		__u64 vmax = VTIMER_MAX_SLICE;
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index da1218e..63f73ae 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -847,7 +847,7 @@ void __init time_init(void)
 	sparc64_clockevent.min_delta_ns =
 		clockevent_delta2ns(0xF, &sparc64_clockevent);
 
-	printk("clockevent: mult[%lx] shift[%d]\n",
+	printk("clockevent: mult[%ux] shift[%d]\n",
 	       sparc64_clockevent.mult, sparc64_clockevent.shift);
 
 	setup_sparc64_timer();
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 894aa97..cf4ee51 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -662,7 +662,7 @@ static int __init calibrate_APIC_clock(void)
 	calibration_result = (delta * APIC_DIVISOR) / LAPIC_CAL_LOOPS;
 
 	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
-	apic_printk(APIC_VERBOSE, "..... mult: %ld\n", lapic_clockevent.mult);
+	apic_printk(APIC_VERBOSE, "..... mult: %u\n", lapic_clockevent.mult);
 	apic_printk(APIC_VERBOSE, "..... calibration result: %u\n",
 		    calibration_result);
 
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index 611b9e2..74c92bb 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -226,7 +226,7 @@ static void __devinit vmi_time_init_clockevent(void)
 	evt->min_delta_ns = clockevent_delta2ns(1, evt);
 	evt->cpumask = cpumask_of(cpu);
 
-	printk(KERN_WARNING "vmi: registering clock event %s. mult=%lu shift=%u\n",
+	printk(KERN_WARNING "vmi: registering clock event %s. mult=%u shift=%u\n",
 	       evt->name, evt->mult, evt->shift);
 	clockevents_register_device(evt);
 }
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 138124f..126f240 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -618,6 +618,7 @@ void __irq_entry do_IRQ(struct pt_regs *regs)
 	old_regs = set_irq_regs(regs);
 	s390_idle_check();
 	irq_enter();
+	__get_cpu_var(s390_idle).nohz_delay = 1;
 	if (S390_lowcore.int_clock >= S390_lowcore.clock_comparator)
 		/* Serve timer interrupts first. */
 		clock_comparator_work();
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 3a1dbba..0cf725b 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -77,10 +77,10 @@ enum clock_event_nofitiers {
 struct clock_event_device {
 	const char		*name;
 	unsigned int		features;
-	unsigned long		max_delta_ns;
-	unsigned long		min_delta_ns;
-	unsigned long		mult;
-	int			shift;
+	u64			max_delta_ns;
+	u64			min_delta_ns;
+	u32			mult;
+	u32			shift;
 	int			rating;
 	int			irq;
 	const struct cpumask	*cpumask;
@@ -116,8 +116,8 @@ static inline unsigned long div_sc(unsigned long ticks, unsigned long nsec,
 }
 
 /* Clock event layer functions */
-extern unsigned long clockevent_delta2ns(unsigned long latch,
-					 struct clock_event_device *evt);
+extern u64 clockevent_delta2ns(unsigned long latch,
+			       struct clock_event_device *evt);
 extern void clockevents_register_device(struct clock_event_device *dev);
 
 extern void clockevents_exchange_device(struct clock_event_device *old,
@@ -130,6 +130,13 @@ extern int clockevents_program_event(struct clock_event_device *dev,
 
 extern void clockevents_handle_noop(struct clock_event_device *dev);
 
+static inline void
+clockevents_calc_mult_shift(struct clock_event_device *ce, u32 freq, u32 minsec)
+{
+	return clocks_calc_mult_shift(&ce->mult, &ce->shift, NSEC_PER_SEC,
+				      freq, minsec);
+}
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
 #else
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 83d2fbd..279c547 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -151,6 +151,7 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  *			subtraction of non 64 bit counters
  * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
+ * @max_idle_ns:	max idle time permitted by the clocksource (nsecs)
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
  * @resume:		resume function for the clocksource, if necessary
@@ -168,6 +169,7 @@ struct clocksource {
 	cycle_t mask;
 	u32 mult;
 	u32 shift;
+	u64 max_idle_ns;
 	unsigned long flags;
 	cycle_t (*vread)(void);
 	void (*resume)(void);
@@ -279,6 +281,16 @@ extern void clocksource_resume(void);
 extern struct clocksource * __init __weak clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
 
+extern void
+clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
+
+static inline void
+clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec)
+{
+	return clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
+				      NSEC_PER_SEC, minsec);
+}
+
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
 extern void update_vsyscall_tz(void);
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 0482229..d2ae79e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -43,6 +43,7 @@ enum tick_nohz_mode {
  * @idle_exittime:	Time when the idle state was left
  * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
  * @sleep_length:	Duration of the current idle sleep
+ * @do_timer_lst:	CPU was the last one doing do_timer before going idle
  */
 struct tick_sched {
 	struct hrtimer			sched_timer;
@@ -64,6 +65,7 @@ struct tick_sched {
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
 	ktime_t				idle_expires;
+	int				do_timer_last;
 };
 
 extern void __init tick_init(void);
@@ -98,6 +100,9 @@ extern int tick_check_oneshot_change(int allow_nohz);
 extern struct tick_sched *tick_get_tick_sched(int cpu);
 extern void tick_check_idle(int cpu);
 extern int tick_oneshot_mode_active(void);
+#  ifndef arch_needs_cpu
+#   define arch_needs_cpu(cpu) (0)
+#  endif
 # else
 static inline void tick_clock_notify(void) { }
 static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
diff --git a/include/linux/time.h b/include/linux/time.h
index fe04e5e..6e026e4 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -148,6 +148,7 @@ extern void monotonic_to_bootbased(struct timespec *ts);
 
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
+extern u64 timekeeping_max_deferment(void);
 extern void update_wall_time(void);
 extern void update_xtime_cache(u64 nsec);
 extern void timekeeping_leap_insert(int leapsecond);
diff --git a/include/linux/timex.h b/include/linux/timex.h
index e6967d1..0c0ef7d 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -261,11 +261,7 @@ static inline int ntp_synced(void)
 
 #define NTP_SCALE_SHIFT		32
 
-#ifdef CONFIG_NO_HZ
-#define NTP_INTERVAL_FREQ  (2)
-#else
 #define NTP_INTERVAL_FREQ  (HZ)
-#endif
 #define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
 /* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
diff --git a/init/calibrate.c b/init/calibrate.c
index a379c90..6eb48e5 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -123,23 +123,26 @@ void __cpuinit calibrate_delay(void)
 {
 	unsigned long ticks, loopbit;
 	int lps_precision = LPS_PREC;
+	static bool printed;
 
 	if (preset_lpj) {
 		loops_per_jiffy = preset_lpj;
-		printk(KERN_INFO
-			"Calibrating delay loop (skipped) preset value.. ");
-	} else if ((smp_processor_id() == 0) && lpj_fine) {
+		if (!printed)
+			pr_info("Calibrating delay loop (skipped) "
+				"preset value.. ");
+	} else if ((!printed) && lpj_fine) {
 		loops_per_jiffy = lpj_fine;
-		printk(KERN_INFO
-			"Calibrating delay loop (skipped), "
+		pr_info("Calibrating delay loop (skipped), "
 			"value calculated using timer frequency.. ");
 	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
-		printk(KERN_INFO
-			"Calibrating delay using timer specific routine.. ");
+		if (!printed)
+			pr_info("Calibrating delay using timer "
+				"specific routine.. ");
 	} else {
 		loops_per_jiffy = (1<<12);
 
-		printk(KERN_INFO "Calibrating delay loop... ");
+		if (!printed)
+			pr_info("Calibrating delay loop... ");
 		while ((loops_per_jiffy <<= 1) != 0) {
 			/* wait for "start of" clock tick */
 			ticks = jiffies;
@@ -170,7 +173,10 @@ void __cpuinit calibrate_delay(void)
 				loops_per_jiffy &= ~loopbit;
 		}
 	}
-	printk(KERN_CONT "%lu.%02lu BogoMIPS (lpj=%lu)\n",
+	if (!printed)
+		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
 			loops_per_jiffy/(500000/HZ),
 			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
+
+	printed = true;
 }
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 6ba0f1e..7c4e271 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -392,10 +392,9 @@ int disable_nonboot_cpus(void)
 		if (cpu == first_cpu)
 			continue;
 		error = _cpu_down(cpu, 1);
-		if (!error) {
+		if (!error)
 			cpumask_set_cpu(cpu, frozen_cpus);
-			printk("CPU%d is down\n", cpu);
-		} else {
+		else {
 			printk(KERN_ERR "Error taking CPU%d down: %d\n",
 				cpu, error);
 			break;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6d70204..c215b74 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1240,7 +1240,8 @@ hrtimer_interrupt_hanging(struct clock_event_device *dev,
 	force_clock_reprogram = 1;
 	dev->min_delta_ns = (unsigned long)try_time.tv64 * 3;
 	printk(KERN_WARNING "hrtimer: interrupt too slow, "
-		"forcing clock min delta to %lu ns\n", dev->min_delta_ns);
+	       "forcing clock min delta to %llu ns\n",
+	       (unsigned long long) dev->min_delta_ns);
 }
 /*
  * High resolution timer interrupt
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 5c9dc22..438ff45 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -384,7 +384,8 @@ int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 
 /*
  * Validate the clockid_t for a new CPU-clock timer, and initialize the timer.
- * This is called from sys_timer_create with the new timer already locked.
+ * This is called from sys_timer_create() and do_cpu_nanosleep() with the
+ * new timer already all-zeros initialized.
  */
 int posix_cpu_timer_create(struct k_itimer *new_timer)
 {
@@ -396,8 +397,6 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 		return -EINVAL;
 
 	INIT_LIST_HEAD(&new_timer->it.cpu.entry);
-	new_timer->it.cpu.incr.sched = 0;
-	new_timer->it.cpu.expires.sched = 0;
 
 	read_lock(&tasklist_lock);
 	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
diff --git a/kernel/time.c b/kernel/time.c
index 2e2e469..2ef4fe2 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -136,7 +136,6 @@ static inline void warp_clock(void)
 	write_seqlock_irq(&xtime_lock);
 	wall_to_monotonic.tv_sec -= sys_tz.tz_minuteswest * 60;
 	xtime.tv_sec += sys_tz.tz_minuteswest * 60;
-	update_xtime_cache(0);
 	write_sequnlock_irq(&xtime_lock);
 	clock_was_set();
 }
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 620b58a..20a8920 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -20,6 +20,8 @@
 #include <linux/sysdev.h>
 #include <linux/tick.h>
 
+#include "tick-internal.h"
+
 /* The registered clock event devices */
 static LIST_HEAD(clockevent_devices);
 static LIST_HEAD(clockevents_released);
@@ -37,10 +39,9 @@ static DEFINE_SPINLOCK(clockevents_lock);
  *
  * Math helper, returns latch value converted to nanoseconds (bound checked)
  */
-unsigned long clockevent_delta2ns(unsigned long latch,
-				  struct clock_event_device *evt)
+u64 clockevent_delta2ns(unsigned long latch, struct clock_event_device *evt)
 {
-	u64 clc = ((u64) latch << evt->shift);
+	u64 clc = (u64) latch << evt->shift;
 
 	if (unlikely(!evt->mult)) {
 		evt->mult = 1;
@@ -50,10 +51,10 @@ unsigned long clockevent_delta2ns(unsigned long latch,
 	do_div(clc, evt->mult);
 	if (clc < 1000)
 		clc = 1000;
-	if (clc > LONG_MAX)
-		clc = LONG_MAX;
+	if (clc > KTIME_MAX)
+		clc = KTIME_MAX;
 
-	return (unsigned long) clc;
+	return clc;
 }
 EXPORT_SYMBOL_GPL(clockevent_delta2ns);
 
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 5e18c6a..72a2dcb 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -107,6 +107,59 @@ u64 timecounter_cyc2time(struct timecounter *tc,
 }
 EXPORT_SYMBOL(timecounter_cyc2time);
 
+/**
+ * clocks_calc_mult_shift - calculate mult/shift factors for scaled math of clocks
+ * @mult:	pointer to mult variable
+ * @shift:	pointer to shift variable
+ * @from:	frequency to convert from
+ * @to:		frequency to convert to
+ * @minsec:	guaranteed runtime conversion range in seconds
+ *
+ * The function evaluates the shift/mult pair for the scaled math
+ * operations of clocksources and clockevents.
+ *
+ * @to and @from are frequency values in HZ. For clock sources @to is
+ * NSEC_PER_SEC == 1GHz and @from is the counter frequency. For clock
+ * event @to is the counter frequency and @from is NSEC_PER_SEC.
+ *
+ * The @minsec conversion range argument controls the time frame in
+ * seconds which must be covered by the runtime conversion with the
+ * calculated mult and shift factors. This guarantees that no 64bit
+ * overflow happens when the input value of the conversion is
+ * multiplied with the calculated mult factor. Larger ranges may
+ * reduce the conversion accuracy by chosing smaller mult and shift
+ * factors.
+ */
+void
+clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec)
+{
+	u64 tmp;
+	u32 sft, sftacc= 32;
+
+	/*
+	 * Calculate the shift factor which is limiting the conversion
+	 * range:
+	 */
+	tmp = ((u64)minsec * from) >> 32;
+	while (tmp) {
+		tmp >>=1;
+		sftacc--;
+	}
+
+	/*
+	 * Find the conversion shift/mult pair which has the best
+	 * accuracy and fits the maxsec conversion range:
+	 */
+	for (sft = 32; sft > 0; sft--) {
+		tmp = (u64) to << sft;
+		do_div(tmp, from);
+		if ((tmp >> sftacc) == 0)
+			break;
+	}
+	*mult = tmp;
+	*shift = sft;
+}
+
 /*[Clocksource internal variables]---------
  * curr_clocksource:
  *	currently selected clocksource.
@@ -413,6 +466,47 @@ void clocksource_touch_watchdog(void)
 	clocksource_resume_watchdog();
 }
 
+/**
+ * clocksource_max_deferment - Returns max time the clocksource can be deferred
+ * @cs:         Pointer to clocksource
+ *
+ */
+static u64 clocksource_max_deferment(struct clocksource *cs)
+{
+	u64 max_nsecs, max_cycles;
+
+	/*
+	 * Calculate the maximum number of cycles that we can pass to the
+	 * cyc2ns function without overflowing a 64-bit signed result. The
+	 * maximum number of cycles is equal to ULLONG_MAX/cs->mult which
+	 * is equivalent to the below.
+	 * max_cycles < (2^63)/cs->mult
+	 * max_cycles < 2^(log2((2^63)/cs->mult))
+	 * max_cycles < 2^(log2(2^63) - log2(cs->mult))
+	 * max_cycles < 2^(63 - log2(cs->mult))
+	 * max_cycles < 1 << (63 - log2(cs->mult))
+	 * Please note that we add 1 to the result of the log2 to account for
+	 * any rounding errors, ensure the above inequality is satisfied and
+	 * no overflow will occur.
+	 */
+	max_cycles = 1ULL << (63 - (ilog2(cs->mult) + 1));
+
+	/*
+	 * The actual maximum number of cycles we can defer the clocksource is
+	 * determined by the minimum of max_cycles and cs->mask.
+	 */
+	max_cycles = min_t(u64, max_cycles, (u64) cs->mask);
+	max_nsecs = clocksource_cyc2ns(max_cycles, cs->mult, cs->shift);
+
+	/*
+	 * To ensure that the clocksource does not wrap whilst we are idle,
+	 * limit the time the clocksource can be deferred by 12.5%. Please
+	 * note a margin of 12.5% is used because this can be computed with
+	 * a shift, versus say 10% which would require division.
+	 */
+	return max_nsecs - (max_nsecs >> 5);
+}
+
 #ifdef CONFIG_GENERIC_TIME
 
 /**
@@ -511,6 +605,9 @@ static void clocksource_enqueue(struct clocksource *cs)
  */
 int clocksource_register(struct clocksource *cs)
 {
+	/* calculate max idle time permitted for this clocksource */
+	cs->max_idle_ns = clocksource_max_deferment(cs);
+
 	mutex_lock(&clocksource_mutex);
 	clocksource_enqueue(cs);
 	clocksource_select();
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index a96c0e2..0a8a213 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -50,9 +50,9 @@ int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
 				dev->min_delta_ns += dev->min_delta_ns >> 1;
 
 			printk(KERN_WARNING
-			       "CE: %s increasing min_delta_ns to %lu nsec\n",
+			       "CE: %s increasing min_delta_ns to %llu nsec\n",
 			       dev->name ? dev->name : "?",
-			       dev->min_delta_ns << 1);
+			       (unsigned long long) dev->min_delta_ns << 1);
 
 			i = 0;
 		}
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e0f59a2..df133bc 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -134,18 +134,13 @@ __setup("nohz=", setup_tick_nohz);
  * value. We do this unconditionally on any cpu, as we don't know whether the
  * cpu, which has the update task assigned is in a long sleep.
  */
-static void tick_nohz_update_jiffies(void)
+static void tick_nohz_update_jiffies(ktime_t now)
 {
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	unsigned long flags;
-	ktime_t now;
-
-	if (!ts->tick_stopped)
-		return;
 
 	cpumask_clear_cpu(cpu, nohz_cpu_mask);
-	now = ktime_get();
 	ts->idle_waketime = now;
 
 	local_irq_save(flags);
@@ -155,20 +150,17 @@ static void tick_nohz_update_jiffies(void)
 	touch_softlockup_watchdog();
 }
 
-static void tick_nohz_stop_idle(int cpu)
+static void tick_nohz_stop_idle(int cpu, ktime_t now)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t delta;
 
-	if (ts->idle_active) {
-		ktime_t now, delta;
-		now = ktime_get();
-		delta = ktime_sub(now, ts->idle_entrytime);
-		ts->idle_lastupdate = now;
-		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-		ts->idle_active = 0;
+	delta = ktime_sub(now, ts->idle_entrytime);
+	ts->idle_lastupdate = now;
+	ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	ts->idle_active = 0;
 
-		sched_clock_idle_wakeup_event(0);
-	}
+	sched_clock_idle_wakeup_event(0);
 }
 
 static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
@@ -216,6 +208,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	struct tick_sched *ts;
 	ktime_t last_update, expires, now;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+	u64 time_delta;
 	int cpu;
 
 	local_irq_save(flags);
@@ -258,7 +251,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 
 		if (ratelimit < 10) {
 			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-			       local_softirq_pending());
+			       (unsigned int) local_softirq_pending());
 			ratelimit++;
 		}
 		goto end;
@@ -270,14 +263,18 @@ void tick_nohz_stop_sched_tick(int inidle)
 		seq = read_seqbegin(&xtime_lock);
 		last_update = last_jiffies_update;
 		last_jiffies = jiffies;
+		time_delta = timekeeping_max_deferment();
 	} while (read_seqretry(&xtime_lock, seq));
 
-	/* Get the next timer wheel timer */
-	next_jiffies = get_next_timer_interrupt(last_jiffies);
-	delta_jiffies = next_jiffies - last_jiffies;
-
-	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu))
+	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
+	    arch_needs_cpu(cpu)) {
+		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
+	} else {
+		/* Get the next timer wheel timer */
+		next_jiffies = get_next_timer_interrupt(last_jiffies);
+		delta_jiffies = next_jiffies - last_jiffies;
+	}
 	/*
 	 * Do not stop the tick, if we are only one off
 	 * or if the cpu is required for rcu
@@ -289,22 +286,51 @@ void tick_nohz_stop_sched_tick(int inidle)
 	if ((long)delta_jiffies >= 1) {
 
 		/*
-		* calculate the expiry time for the next timer wheel
-		* timer
-		*/
-		expires = ktime_add_ns(last_update, tick_period.tv64 *
-				   delta_jiffies);
-
-		/*
 		 * If this cpu is the one which updates jiffies, then
 		 * give up the assignment and let it be taken by the
 		 * cpu which runs the tick timer next, which might be
 		 * this cpu as well. If we don't drop this here the
 		 * jiffies might be stale and do_timer() never
-		 * invoked.
+		 * invoked. Keep track of the fact that it was the one
+		 * which had the do_timer() duty last. If this cpu is
+		 * the one which had the do_timer() duty last, we
+		 * limit the sleep time to the timekeeping
+		 * max_deferement value which we retrieved
+		 * above. Otherwise we can sleep as long as we want.
 		 */
-		if (cpu == tick_do_timer_cpu)
+		if (cpu == tick_do_timer_cpu) {
 			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+			ts->do_timer_last = 1;
+		} else if (tick_do_timer_cpu != TICK_DO_TIMER_NONE) {
+			time_delta = KTIME_MAX;
+			ts->do_timer_last = 0;
+		} else if (!ts->do_timer_last) {
+			time_delta = KTIME_MAX;
+		}
+
+		/*
+		 * calculate the expiry time for the next timer wheel
+		 * timer. delta_jiffies >= NEXT_TIMER_MAX_DELTA signals
+		 * that there is no timer pending or at least extremely
+		 * far into the future (12 days for HZ=1000). In this
+		 * case we set the expiry to the end of time.
+		 */
+		if (likely(delta_jiffies < NEXT_TIMER_MAX_DELTA)) {
+			/*
+			 * Calculate the time delta for the next timer event.
+			 * If the time delta exceeds the maximum time delta
+			 * permitted by the current clocksource then adjust
+			 * the time delta accordingly to ensure the
+			 * clocksource does not wrap.
+			 */
+			time_delta = min_t(u64, time_delta,
+					   tick_period.tv64 * delta_jiffies);
+		}
+
+		if (time_delta < KTIME_MAX)
+			expires = ktime_add_ns(last_update, time_delta);
+		else
+			expires.tv64 = KTIME_MAX;
 
 		if (delta_jiffies > 1)
 			cpumask_set_cpu(cpu, nohz_cpu_mask);
@@ -337,22 +363,19 @@ void tick_nohz_stop_sched_tick(int inidle)
 
 		ts->idle_sleeps++;
 
+		/* Mark expires */
+		ts->idle_expires = expires;
+
 		/*
-		 * delta_jiffies >= NEXT_TIMER_MAX_DELTA signals that
-		 * there is no timer pending or at least extremly far
-		 * into the future (12 days for HZ=1000). In this case
-		 * we simply stop the tick timer:
+		 * If the expiration time == KTIME_MAX, then
+		 * in this case we simply stop the tick timer.
 		 */
-		if (unlikely(delta_jiffies >= NEXT_TIMER_MAX_DELTA)) {
-			ts->idle_expires.tv64 = KTIME_MAX;
+		 if (unlikely(expires.tv64 == KTIME_MAX)) {
 			if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
 				hrtimer_cancel(&ts->sched_timer);
 			goto out;
 		}
 
-		/* Mark expiries */
-		ts->idle_expires = expires;
-
 		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
 			hrtimer_start(&ts->sched_timer, expires,
 				      HRTIMER_MODE_ABS_PINNED);
@@ -431,7 +454,11 @@ void tick_nohz_restart_sched_tick(void)
 	ktime_t now;
 
 	local_irq_disable();
-	tick_nohz_stop_idle(cpu);
+	if (ts->idle_active || (ts->inidle && ts->tick_stopped))
+		now = ktime_get();
+
+	if (ts->idle_active)
+		tick_nohz_stop_idle(cpu, now);
 
 	if (!ts->inidle || !ts->tick_stopped) {
 		ts->inidle = 0;
@@ -445,7 +472,6 @@ void tick_nohz_restart_sched_tick(void)
 
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
-	now = ktime_get();
 	tick_do_update_jiffies64(now);
 	cpumask_clear_cpu(cpu, nohz_cpu_mask);
 
@@ -579,22 +605,18 @@ static void tick_nohz_switch_to_nohz(void)
  * timer and do not touch the other magic bits which need to be done
  * when idle is left.
  */
-static void tick_nohz_kick_tick(int cpu)
+static void tick_nohz_kick_tick(int cpu, ktime_t now)
 {
 #if 0
 	/* Switch back to 2.6.27 behaviour */
 
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	ktime_t delta, now;
-
-	if (!ts->tick_stopped)
-		return;
+	ktime_t delta;
 
 	/*
 	 * Do not touch the tick device, when the next expiry is either
 	 * already reached or less/equal than the tick period.
 	 */
-	now = ktime_get();
 	delta =	ktime_sub(hrtimer_get_expires(&ts->sched_timer), now);
 	if (delta.tv64 <= tick_period.tv64)
 		return;
@@ -603,9 +625,26 @@ static void tick_nohz_kick_tick(int cpu)
 #endif
 }
 
+static inline void tick_check_nohz(int cpu)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now;
+
+	if (!ts->idle_active && !ts->tick_stopped)
+		return;
+	now = ktime_get();
+	if (ts->idle_active)
+		tick_nohz_stop_idle(cpu, now);
+	if (ts->tick_stopped) {
+		tick_nohz_update_jiffies(now);
+		tick_nohz_kick_tick(cpu, now);
+	}
+}
+
 #else
 
 static inline void tick_nohz_switch_to_nohz(void) { }
+static inline void tick_check_nohz(int cpu) { }
 
 #endif /* NO_HZ */
 
@@ -615,11 +654,7 @@ static inline void tick_nohz_switch_to_nohz(void) { }
 void tick_check_idle(int cpu)
 {
 	tick_check_oneshot_broadcast(cpu);
-#ifdef CONFIG_NO_HZ
-	tick_nohz_stop_idle(cpu);
-	tick_nohz_update_jiffies();
-	tick_nohz_kick_tick(cpu);
-#endif
+	tick_check_nohz(cpu);
 }
 
 /*
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fb0f46f..5d4d423 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -164,13 +164,6 @@ struct timespec raw_time;
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
-static struct timespec xtime_cache __attribute__ ((aligned (16)));
-void update_xtime_cache(u64 nsec)
-{
-	xtime_cache = xtime;
-	timespec_add_ns(&xtime_cache, nsec);
-}
-
 /* must hold xtime_lock */
 void timekeeping_leap_insert(int leapsecond)
 {
@@ -331,8 +324,6 @@ int do_settimeofday(struct timespec *tv)
 
 	xtime = *tv;
 
-	update_xtime_cache(0);
-
 	timekeeper.ntp_error = 0;
 	ntp_clear();
 
@@ -487,6 +478,17 @@ int timekeeping_valid_for_hres(void)
 }
 
 /**
+ * timekeeping_max_deferment - Returns max time the clocksource can be deferred
+ *
+ * Caller must observe xtime_lock via read_seqbegin/read_seqretry to
+ * ensure that the clocksource does not change!
+ */
+u64 timekeeping_max_deferment(void)
+{
+	return timekeeper.clock->max_idle_ns;
+}
+
+/**
  * read_persistent_clock -  Return time from the persistent clock.
  *
  * Weak dummy function for arches that do not yet support it.
@@ -547,7 +549,6 @@ void __init timekeeping_init(void)
 	}
 	set_normalized_timespec(&wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
-	update_xtime_cache(0);
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -581,7 +582,6 @@ static int timekeeping_resume(struct sys_device *dev)
 		wall_to_monotonic = timespec_sub(wall_to_monotonic, ts);
 		total_sleep_time = timespec_add_safe(total_sleep_time, ts);
 	}
-	update_xtime_cache(0);
 	/* re-base the last cycle value */
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
@@ -722,6 +722,49 @@ static void timekeeping_adjust(s64 offset)
 }
 
 /**
+ * logarithmic_accumulation - shifted accumulation of cycles
+ *
+ * This functions accumulates a shifted interval of cycles into
+ * into a shifted interval nanoseconds. Allows for O(log) accumulation
+ * loop.
+ *
+ * Returns the unconsumed cycles.
+ */
+static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
+{
+	u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
+
+	/* If the offset is smaller then a shifted interval, do nothing */
+	if (offset < timekeeper.cycle_interval<<shift)
+		return offset;
+
+	/* Accumulate one shifted interval */
+	offset -= timekeeper.cycle_interval << shift;
+	timekeeper.clock->cycle_last += timekeeper.cycle_interval << shift;
+
+	timekeeper.xtime_nsec += timekeeper.xtime_interval << shift;
+	while (timekeeper.xtime_nsec >= nsecps) {
+		timekeeper.xtime_nsec -= nsecps;
+		xtime.tv_sec++;
+		second_overflow();
+	}
+
+	/* Accumulate into raw time */
+	raw_time.tv_nsec += timekeeper.raw_interval << shift;;
+	while (raw_time.tv_nsec >= NSEC_PER_SEC) {
+		raw_time.tv_nsec -= NSEC_PER_SEC;
+		raw_time.tv_sec++;
+	}
+
+	/* Accumulate error between NTP and clock interval */
+	timekeeper.ntp_error += tick_length << shift;
+	timekeeper.ntp_error -= timekeeper.xtime_interval <<
+				(timekeeper.ntp_error_shift + shift);
+
+	return offset;
+}
+
+/**
  * update_wall_time - Uses the current clocksource to increment the wall time
  *
  * Called from the timer interrupt, must hold a write on xtime_lock.
@@ -730,7 +773,7 @@ void update_wall_time(void)
 {
 	struct clocksource *clock;
 	cycle_t offset;
-	u64 nsecs;
+	int shift = 0, maxshift;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -744,33 +787,22 @@ void update_wall_time(void)
 #endif
 	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
 
-	/* normally this loop will run just once, however in the
-	 * case of lost or late ticks, it will accumulate correctly.
+	/*
+	 * With NO_HZ we may have to accumulate many cycle_intervals
+	 * (think "ticks") worth of time at once. To do this efficiently,
+	 * we calculate the largest doubling multiple of cycle_intervals
+	 * that is smaller then the offset. We then accumulate that
+	 * chunk in one go, and then try to consume the next smaller
+	 * doubled multiple.
 	 */
+	shift = ilog2(offset) - ilog2(timekeeper.cycle_interval);
+	shift = max(0, shift);
+	/* Bound shift to one less then what overflows tick_length */
+	maxshift = (8*sizeof(tick_length) - (ilog2(tick_length)+1)) - 1;
+	shift = min(shift, maxshift);
 	while (offset >= timekeeper.cycle_interval) {
-		u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
-
-		/* accumulate one interval */
-		offset -= timekeeper.cycle_interval;
-		clock->cycle_last += timekeeper.cycle_interval;
-
-		timekeeper.xtime_nsec += timekeeper.xtime_interval;
-		if (timekeeper.xtime_nsec >= nsecps) {
-			timekeeper.xtime_nsec -= nsecps;
-			xtime.tv_sec++;
-			second_overflow();
-		}
-
-		raw_time.tv_nsec += timekeeper.raw_interval;
-		if (raw_time.tv_nsec >= NSEC_PER_SEC) {
-			raw_time.tv_nsec -= NSEC_PER_SEC;
-			raw_time.tv_sec++;
-		}
-
-		/* accumulate error between NTP and clock interval */
-		timekeeper.ntp_error += tick_length;
-		timekeeper.ntp_error -= timekeeper.xtime_interval <<
-					timekeeper.ntp_error_shift;
+		offset = logarithmic_accumulation(offset, shift);
+		shift--;
 	}
 
 	/* correct the clock when NTP error is too big */
@@ -806,9 +838,6 @@ void update_wall_time(void)
 	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
 				timekeeper.ntp_error_shift;
 
-	nsecs = clocksource_cyc2ns(offset, timekeeper.mult, timekeeper.shift);
-	update_xtime_cache(nsecs);
-
 	/* check to see if there is a new clocksource to use */
 	update_vsyscall(&xtime, timekeeper.clock);
 }
@@ -845,13 +874,13 @@ void monotonic_to_bootbased(struct timespec *ts)
 
 unsigned long get_seconds(void)
 {
-	return xtime_cache.tv_sec;
+	return xtime.tv_sec;
 }
 EXPORT_SYMBOL(get_seconds);
 
 struct timespec __current_kernel_time(void)
 {
-	return xtime_cache;
+	return xtime;
 }
 
 struct timespec current_kernel_time(void)
@@ -861,8 +890,7 @@ struct timespec current_kernel_time(void)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-
-		now = xtime_cache;
+		now = xtime;
 	} while (read_seqretry(&xtime_lock, seq));
 
 	return now;
@@ -876,8 +904,7 @@ struct timespec get_monotonic_coarse(void)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-
-		now = xtime_cache;
+		now = xtime;
 		mono = wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 1b5b7aa..665c76e 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -204,10 +204,12 @@ print_tickdevice(struct seq_file *m, struct tick_device *td, int cpu)
 		return;
 	}
 	SEQ_printf(m, "%s\n", dev->name);
-	SEQ_printf(m, " max_delta_ns:   %lu\n", dev->max_delta_ns);
-	SEQ_printf(m, " min_delta_ns:   %lu\n", dev->min_delta_ns);
-	SEQ_printf(m, " mult:           %lu\n", dev->mult);
-	SEQ_printf(m, " shift:          %d\n", dev->shift);
+	SEQ_printf(m, " max_delta_ns:   %llu\n",
+		   (unsigned long long) dev->max_delta_ns);
+	SEQ_printf(m, " min_delta_ns:   %llu\n",
+		   (unsigned long long) dev->min_delta_ns);
+	SEQ_printf(m, " mult:           %u\n", dev->mult);
+	SEQ_printf(m, " shift:          %u\n", dev->shift);
 	SEQ_printf(m, " mode:           %d\n", dev->mode);
 	SEQ_printf(m, " next_event:     %Ld nsecs\n",
 		   (unsigned long long) ktime_to_ns(dev->next_event));

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbZIPO5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbZIPO5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZIPO5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:57:23 -0400
Received: from www.tglx.de ([62.245.132.106]:54345 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbZIPO5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:57:19 -0400
Date: Wed, 16 Sep 2009 16:56:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timers/timekeeping for 2.6.32
Message-ID: <alpine.LFD.2.00.0909161555360.8957@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus

The changes in arch/arm, m68knommu, mips, powerpc, s390, sh, x86 and
xtensa are fixups due to API changes in the core code.

Thanks,

	tglx

------------------>
Hiroshi Shimamoto (1):
      timekeeping: Fix invalid getboottime() value

John Stultz (2):
      timekeeping: Introduce timekeeping_leap_insert
      time: Introduce CLOCK_REALTIME_COARSE

Martin Schwidefsky (19):
      timekeeping: optimized ktime_get[_ts] for GENERIC_TIME=y
      timers: Cache __next_timer_interrupt result
      timekeeping: Remove clocksource inline functions
      timekeeping: Move reset of cycle_last for tsc clocksource to tsc
      clocksource: Cleanup clocksource selection
      clocksource: Delay clocksource watchdog highres enablement
      clocksource: Simplify clocksource watchdog resume logic
      clocksource: Refactor clocksource watchdog
      clocksource: Move watchdog downgrade to a work queue thread
      timekeeping: Introduce struct timekeeper
      timekeeping: Add xtime_shift and ntp_error_shift to struct timekeeper
      timekeeping: Move NTP adjusted clock multiplier to struct timekeeper
      timekeeping: Add timekeeper read_clock helper functions
      timekeeping: Update clocksource with stop_machine
      timekeeping: Increase granularity of read_persistent_clock()
      timekeeping: Introduce read_boot_clock
      clocksource: Avoid clocksource watchdog circular locking dependency
      timekeeping: Increase granularity of read_persistent_clock(), build fix
      clocksource: Resolve cpu hotplug dead lock with TSC unstable, fix crash

Paul Mundt (1):
      timekeeping: Fix up read_persistent_clock() breakage on sh

Peter Zijlstra (1):
      hrtimer: Remove cb_entry from struct hrtimer

Randy Dunlap (2):
      timer.c: Fix S/390 comments
      timers: Drop a function prototype

Thomas Gleixner (8):
      timekeeping: Move ktime_get() functions to timekeeping.c
      clocksource: Call clocksource_change_rating() outside of watchdog_lock
      clocksource: Protect the watchdog rating changes with clocksource_mutex
      x86: Do not unregister PIT clocksource on PIT oneshot setup/shutdown
      clocksource: Resolve cpu hotplug dead lock with TSC unstable
      clocksource: clocksource_select must be called with mutex locked
      clocksource: Delay clocksource down rating to late boot
      time: Prevent 32 bit overflow with set_normalized_timespec()


 arch/arm/plat-omap/common.c           |    7 +-
 arch/m68knommu/kernel/time.c          |    5 +-
 arch/mips/dec/time.c                  |    5 +-
 arch/mips/lasat/ds1603.c              |    5 +-
 arch/mips/lasat/sysctl.c              |    8 +-
 arch/mips/lemote/lm2e/setup.c         |    5 +-
 arch/mips/mti-malta/malta-time.c      |    5 +-
 arch/mips/pmc-sierra/yosemite/setup.c |    5 +-
 arch/mips/sibyte/swarm/setup.c        |   15 +-
 arch/mips/sni/time.c                  |    5 +-
 arch/powerpc/kernel/time.c            |   19 +-
 arch/s390/kernel/time.c               |   38 +--
 arch/sh/kernel/time.c                 |    6 +-
 arch/x86/include/asm/vgtod.h          |    1 +
 arch/x86/kernel/i8253.c               |   19 --
 arch/x86/kernel/rtc.c                 |    5 +-
 arch/x86/kernel/tsc.c                 |   14 +-
 arch/x86/kernel/vsyscall_64.c         |    1 +
 arch/x86/vdso/vclock_gettime.c        |   39 +++-
 arch/xtensa/kernel/time.c             |    5 +-
 include/linux/clocksource.h           |  122 +-------
 include/linux/hrtimer.h               |    2 -
 include/linux/time.h                  |   10 +-
 include/linux/timer.h                 |    5 -
 kernel/hrtimer.c                      |   57 ----
 kernel/posix-timers.c                 |   35 +++
 kernel/time.c                         |    9 +-
 kernel/time/clocksource.c             |  529 +++++++++++++++++++--------------
 kernel/time/jiffies.c                 |    6 +-
 kernel/time/ntp.c                     |    7 +-
 kernel/time/timekeeping.c             |  535 ++++++++++++++++++++++++--------
 kernel/timer.c                        |   28 ++-
 32 files changed, 917 insertions(+), 640 deletions(-)

diff --git a/arch/arm/plat-omap/common.c b/arch/arm/plat-omap/common.c
index ebcf006..95587b6 100644
--- a/arch/arm/plat-omap/common.c
+++ b/arch/arm/plat-omap/common.c
@@ -253,11 +253,8 @@ static struct clocksource clocksource_32k = {
  */
 unsigned long long sched_clock(void)
 {
-	unsigned long long ret;
-
-	ret = (unsigned long long)clocksource_32k.read(&clocksource_32k);
-	ret = (ret * clocksource_32k.mult_orig) >> clocksource_32k.shift;
-	return ret;
+	return clocksource_cyc2ns(clocksource_32k.read(&clocksource_32k),
+				  clocksource_32k.mult, clocksource_32k.shift);
 }
 
 static int __init omap_init_clocksource_32k(void)
diff --git a/arch/m68knommu/kernel/time.c b/arch/m68knommu/kernel/time.c
index d182b2f..6843224 100644
--- a/arch/m68knommu/kernel/time.c
+++ b/arch/m68knommu/kernel/time.c
@@ -72,9 +72,10 @@ static unsigned long read_rtc_mmss(void)
 	return  mktime(year, mon, day, hour, min, sec);;
 }
 
-unsigned long read_persistent_clock(void)
+void read_persistent_clock(struct timespec *ts)
 {
-	return read_rtc_mmss();
+	ts->tv_sec = read_rtc_mmss();
+	ts->tv_nsec = 0;
 }
 
 int update_persistent_clock(struct timespec now)
diff --git a/arch/mips/dec/time.c b/arch/mips/dec/time.c
index 463136e..02f505f 100644
--- a/arch/mips/dec/time.c
+++ b/arch/mips/dec/time.c
@@ -18,7 +18,7 @@
 #include <asm/dec/ioasic.h>
 #include <asm/dec/machtype.h>
 
-unsigned long read_persistent_clock(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	unsigned int year, mon, day, hour, min, sec, real_year;
 	unsigned long flags;
@@ -53,7 +53,8 @@ unsigned long read_persistent_clock(void)
 
 	year += real_year - 72 + 2000;
 
-	return mktime(year, mon, day, hour, min, sec);
+	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+	ts->tv_nsec = 0;
 }
 
 /*
diff --git a/arch/mips/lasat/ds1603.c b/arch/mips/lasat/ds1603.c
index 52cb143..c6fd96f 100644
--- a/arch/mips/lasat/ds1603.c
+++ b/arch/mips/lasat/ds1603.c
@@ -135,7 +135,7 @@ static void rtc_end_op(void)
 	lasat_ndelay(1000);
 }
 
-unsigned long read_persistent_clock(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	unsigned long word;
 	unsigned long flags;
@@ -147,7 +147,8 @@ unsigned long read_persistent_clock(void)
 	rtc_end_op();
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
-	return word;
+	ts->tv_sec = word;
+	ts->tv_nsec = 0;
 }
 
 int rtc_mips_set_mmss(unsigned long time)
diff --git a/arch/mips/lasat/sysctl.c b/arch/mips/lasat/sysctl.c
index 8f88886..3f04d4c 100644
--- a/arch/mips/lasat/sysctl.c
+++ b/arch/mips/lasat/sysctl.c
@@ -92,10 +92,12 @@ static int rtctmp;
 int proc_dolasatrtc(ctl_table *table, int write, struct file *filp,
 		       void *buffer, size_t *lenp, loff_t *ppos)
 {
+	struct timespec ts;
 	int r;
 
 	if (!write) {
-		rtctmp = read_persistent_clock();
+		read_persistent_clock(&ts);
+		rtctmp = ts.tv_sec;
 		/* check for time < 0 and set to 0 */
 		if (rtctmp < 0)
 			rtctmp = 0;
@@ -134,9 +136,11 @@ int sysctl_lasat_rtc(ctl_table *table,
 		    void *oldval, size_t *oldlenp,
 		    void *newval, size_t newlen)
 {
+	struct timespec ts;
 	int r;
 
-	rtctmp = read_persistent_clock();
+	read_persistent_clock(&ts);
+	rtctmp = ts.tv_sec;
 	if (rtctmp < 0)
 		rtctmp = 0;
 	r = sysctl_intvec(table, oldval, oldlenp, newval, newlen);
diff --git a/arch/mips/lemote/lm2e/setup.c b/arch/mips/lemote/lm2e/setup.c
index ebd6cea..24b355d 100644
--- a/arch/mips/lemote/lm2e/setup.c
+++ b/arch/mips/lemote/lm2e/setup.c
@@ -54,9 +54,10 @@ void __init plat_time_init(void)
 	mips_hpt_frequency = cpu_clock_freq / 2;
 }
 
-unsigned long read_persistent_clock(void)
+void read_persistent_clock(struct timespec *ts)
 {
-	return mc146818_get_cmos_time();
+	ts->tv_sec = mc146818_get_cmos_time();
+	ts->tv_nsec = 0;
 }
 
 void (*__wbflush)(void);
diff --git a/arch/mips/mti-malta/malta-time.c b/arch/mips/mti-malta/malta-time.c
index 0b97d47..3c6f190 100644
--- a/arch/mips/mti-malta/malta-time.c
+++ b/arch/mips/mti-malta/malta-time.c
@@ -100,9 +100,10 @@ static unsigned int __init estimate_cpu_frequency(void)
 	return count;
 }
 
-unsigned long read_persistent_clock(void)
+void read_persistent_clock(struct timespec *ts)
 {
-	return mc146818_get_cmos_time();
+	ts->tv_sec = mc146818_get_cmos_time();
+	ts->tv_nsec = 0;
 }
 
 static void __init plat_perf_setup(void)
diff --git a/arch/mips/pmc-sierra/yosemite/setup.c b/arch/mips/pmc-sierra/yosemite/setup.c
index 2d3c0dc..3498ac9 100644
--- a/arch/mips/pmc-sierra/yosemite/setup.c
+++ b/arch/mips/pmc-sierra/yosemite/setup.c
@@ -70,7 +70,7 @@ void __init bus_error_init(void)
 }
 
 
-unsigned long read_persistent_clock(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	unsigned int year, month, day, hour, min, sec;
 	unsigned long flags;
@@ -92,7 +92,8 @@ unsigned long read_persistent_clock(void)
 	m48t37_base->control = 0x00;
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
-	return mktime(year, month, day, hour, min, sec);
+	ts->tv_sec = mktime(year, month, day, hour, min, sec);
+	ts->tv_nsec = 0;
 }
 
 int rtc_mips_set_time(unsigned long tim)
diff --git a/arch/mips/sibyte/swarm/setup.c b/arch/mips/sibyte/swarm/setup.c
index 672e45d..623ffc9 100644
--- a/arch/mips/sibyte/swarm/setup.c
+++ b/arch/mips/sibyte/swarm/setup.c
@@ -87,19 +87,26 @@ enum swarm_rtc_type {
 
 enum swarm_rtc_type swarm_rtc_type;
 
-unsigned long read_persistent_clock(void)
+void read_persistent_clock(struct timespec *ts)
 {
+	unsigned long sec;
+
 	switch (swarm_rtc_type) {
 	case RTC_XICOR:
-		return xicor_get_time();
+		sec = xicor_get_time();
+		break;
 
 	case RTC_M4LT81:
-		return m41t81_get_time();
+		sec = m41t81_get_time();
+		break;
 
 	case RTC_NONE:
 	default:
-		return mktime(2000, 1, 1, 0, 0, 0);
+		sec = mktime(2000, 1, 1, 0, 0, 0);
+		break;
 	}
+	ts->tv_sec = sec;
+	tv->tv_nsec = 0;
 }
 
 int rtc_mips_set_time(unsigned long sec)
diff --git a/arch/mips/sni/time.c b/arch/mips/sni/time.c
index 0d9ec1a..62df6a5 100644
--- a/arch/mips/sni/time.c
+++ b/arch/mips/sni/time.c
@@ -182,7 +182,8 @@ void __init plat_time_init(void)
 	setup_pit_timer();
 }
 
-unsigned long read_persistent_clock(void)
+void read_persistent_clock(struct timespec *ts)
 {
-	return -1;
+	ts->tv_sec = -1;
+	ts->tv_nsec = 0;
 }
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index eae4511..a508388 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -769,11 +769,12 @@ int update_persistent_clock(struct timespec now)
 	return ppc_md.set_rtc_time(&tm);
 }
 
-unsigned long read_persistent_clock(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	struct rtc_time tm;
 	static int first = 1;
 
+	ts->tv_nsec = 0;
 	/* XXX this is a litle fragile but will work okay in the short term */
 	if (first) {
 		first = 0;
@@ -781,14 +782,18 @@ unsigned long read_persistent_clock(void)
 			timezone_offset = ppc_md.time_init();
 
 		/* get_boot_time() isn't guaranteed to be safe to call late */
-		if (ppc_md.get_boot_time)
-			return ppc_md.get_boot_time() -timezone_offset;
+		if (ppc_md.get_boot_time) {
+			ts->tv_sec = ppc_md.get_boot_time() - timezone_offset;
+			return;
+		}
+	}
+	if (!ppc_md.get_rtc_time) {
+		ts->tv_sec = 0;
+		return;
 	}
-	if (!ppc_md.get_rtc_time)
-		return 0;
 	ppc_md.get_rtc_time(&tm);
-	return mktime(tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
-		      tm.tm_hour, tm.tm_min, tm.tm_sec);
+	ts->tv_sec = mktime(tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
+			    tm.tm_hour, tm.tm_min, tm.tm_sec);
 }
 
 /* clocksource code */
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index d4c8e9c..6bff1a1 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -182,12 +182,14 @@ static void timing_alert_interrupt(__u16 code)
 static void etr_reset(void);
 static void stp_reset(void);
 
-unsigned long read_persistent_clock(void)
+void read_persistent_clock(struct timespec *ts)
 {
-	struct timespec ts;
+	tod_to_timeval(get_clock() - TOD_UNIX_EPOCH, ts);
+}
 
-	tod_to_timeval(get_clock() - TOD_UNIX_EPOCH, &ts);
-	return ts.tv_sec;
+void read_boot_clock(struct timespec *ts)
+{
+	tod_to_timeval(sched_clock_base_cc - TOD_UNIX_EPOCH, ts);
 }
 
 static cycle_t read_tod_clock(struct clocksource *cs)
@@ -205,6 +207,10 @@ static struct clocksource clocksource_tod = {
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
+struct clocksource * __init clocksource_default_clock(void)
+{
+	return &clocksource_tod;
+}
 
 void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 {
@@ -242,10 +248,6 @@ void update_vsyscall_tz(void)
  */
 void __init time_init(void)
 {
-	struct timespec ts;
-	unsigned long flags;
-	cycle_t now;
-
 	/* Reset time synchronization interfaces. */
 	etr_reset();
 	stp_reset();
@@ -261,26 +263,6 @@ void __init time_init(void)
 	if (clocksource_register(&clocksource_tod) != 0)
 		panic("Could not register TOD clock source");
 
-	/*
-	 * The TOD clock is an accurate clock. The xtime should be
-	 * initialized in a way that the difference between TOD and
-	 * xtime is reasonably small. Too bad that timekeeping_init
-	 * sets xtime.tv_nsec to zero. In addition the clock source
-	 * change from the jiffies clock source to the TOD clock
-	 * source add another error of up to 1/HZ second. The same
-	 * function sets wall_to_monotonic to a value that is too
-	 * small for /proc/uptime to be accurate.
-	 * Reset xtime and wall_to_monotonic to sane values.
-	 */
-	write_seqlock_irqsave(&xtime_lock, flags);
-	now = get_clock();
-	tod_to_timeval(now - TOD_UNIX_EPOCH, &xtime);
-	clocksource_tod.cycle_last = now;
-	clocksource_tod.raw_time = xtime;
-	tod_to_timeval(sched_clock_base_cc - TOD_UNIX_EPOCH, &ts);
-	set_normalized_timespec(&wall_to_monotonic, -ts.tv_sec, -ts.tv_nsec);
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-
 	/* Enable TOD clock interrupts on the boot cpu. */
 	init_cpu_timer();
 
diff --git a/arch/sh/kernel/time.c b/arch/sh/kernel/time.c
index 9b352a1..0e0e858 100644
--- a/arch/sh/kernel/time.c
+++ b/arch/sh/kernel/time.c
@@ -39,11 +39,9 @@ void (*rtc_sh_get_time)(struct timespec *) = null_rtc_get_time;
 int (*rtc_sh_set_time)(const time_t) = null_rtc_set_time;
 
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
-unsigned long read_persistent_clock(void)
+void read_persistent_clock(struct timespec *ts)
 {
-	struct timespec tv;
-	rtc_sh_get_time(&tv);
-	return tv.tv_sec;
+	rtc_sh_get_time(ts);
 }
 
 int update_persistent_clock(struct timespec now)
diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index dc27a69..3d61e20 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -21,6 +21,7 @@ struct vsyscall_gtod_data {
 		u32	shift;
 	} clock;
 	struct timespec wall_to_monotonic;
+	struct timespec wall_time_coarse;
 };
 extern struct vsyscall_gtod_data __vsyscall_gtod_data
 __section_vsyscall_gtod_data;
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 5cf36c0..23c1679 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -19,12 +19,6 @@
 DEFINE_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
 
-#ifdef CONFIG_X86_32
-static void pit_disable_clocksource(void);
-#else
-static inline void pit_disable_clocksource(void) { }
-#endif
-
 /*
  * HPET replaces the PIT, when enabled. So we need to know, which of
  * the two timers is used
@@ -57,12 +51,10 @@ static void init_pit_timer(enum clock_event_mode mode,
 			outb_pit(0, PIT_CH0);
 			outb_pit(0, PIT_CH0);
 		}
-		pit_disable_clocksource();
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
 		/* One shot setup */
-		pit_disable_clocksource();
 		outb_pit(0x38, PIT_MODE);
 		break;
 
@@ -200,17 +192,6 @@ static struct clocksource pit_cs = {
 	.shift		= 20,
 };
 
-static void pit_disable_clocksource(void)
-{
-	/*
-	 * Use mult to check whether it is registered or not
-	 */
-	if (pit_cs.mult) {
-		clocksource_unregister(&pit_cs);
-		pit_cs.mult = 0;
-	}
-}
-
 static int __init init_pit_clocksource(void)
 {
 	 /*
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 5d465b2..bf67dcb 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -178,7 +178,7 @@ static int set_rtc_mmss(unsigned long nowtime)
 }
 
 /* not static: needed by APM */
-unsigned long read_persistent_clock(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	unsigned long retval, flags;
 
@@ -186,7 +186,8 @@ unsigned long read_persistent_clock(void)
 	retval = get_wallclock();
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
-	return retval;
+	ts->tv_sec = retval;
+	ts->tv_nsec = 0;
 }
 
 int update_persistent_clock(struct timespec now)
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 71f4368..fc3672a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -744,10 +744,16 @@ static cycle_t __vsyscall_fn vread_tsc(void)
 }
 #endif
 
+static void resume_tsc(void)
+{
+	clocksource_tsc.cycle_last = 0;
+}
+
 static struct clocksource clocksource_tsc = {
 	.name                   = "tsc",
 	.rating                 = 300,
 	.read                   = read_tsc,
+	.resume			= resume_tsc,
 	.mask                   = CLOCKSOURCE_MASK(64),
 	.shift                  = 22,
 	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
@@ -761,12 +767,14 @@ void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
-		printk("Marking TSC unstable due to %s\n", reason);
+		printk(KERN_INFO "Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
-			clocksource_change_rating(&clocksource_tsc, 0);
-		else
+			clocksource_mark_unstable(&clocksource_tsc);
+		else {
+			clocksource_tsc.flags |= CLOCK_SOURCE_UNSTABLE;
 			clocksource_tsc.rating = 0;
+		}
 	}
 }
 
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 25ee06a..cf53a78 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -87,6 +87,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
 	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
+	vsyscall_gtod_data.wall_time_coarse = __current_kernel_time();
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 6a40b78..ee55754 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -86,14 +86,47 @@ notrace static noinline int do_monotonic(struct timespec *ts)
 	return 0;
 }
 
+notrace static noinline int do_realtime_coarse(struct timespec *ts)
+{
+	unsigned long seq;
+	do {
+		seq = read_seqbegin(&gtod->lock);
+		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
+		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
+	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	return 0;
+}
+
+notrace static noinline int do_monotonic_coarse(struct timespec *ts)
+{
+	unsigned long seq, ns, secs;
+	do {
+		seq = read_seqbegin(&gtod->lock);
+		secs = gtod->wall_time_coarse.tv_sec;
+		ns = gtod->wall_time_coarse.tv_nsec;
+		secs += gtod->wall_to_monotonic.tv_sec;
+		ns += gtod->wall_to_monotonic.tv_nsec;
+	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	vset_normalized_timespec(ts, secs, ns);
+	return 0;
+}
+
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
-	if (likely(gtod->sysctl_enabled && gtod->clock.vread))
+	if (likely(gtod->sysctl_enabled))
 		switch (clock) {
 		case CLOCK_REALTIME:
-			return do_realtime(ts);
+			if (likely(gtod->clock.vread))
+				return do_realtime(ts);
+			break;
 		case CLOCK_MONOTONIC:
-			return do_monotonic(ts);
+			if (likely(gtod->clock.vread))
+				return do_monotonic(ts);
+			break;
+		case CLOCK_REALTIME_COARSE:
+			return do_realtime_coarse(ts);
+		case CLOCK_MONOTONIC_COARSE:
+			return do_monotonic_coarse(ts);
 		}
 	return vdso_fallback_gettime(clock, ts);
 }
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 8848120..19085ff 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -59,9 +59,8 @@ static struct irqaction timer_irqaction = {
 
 void __init time_init(void)
 {
-	xtime.tv_nsec = 0;
-	xtime.tv_sec = read_persistent_clock();
-
+	/* FIXME: xtime&wall_to_monotonic are set in timekeeping_init. */
+	read_persistent_clock(&xtime);
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
 
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 1219be4..83d2fbd 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -14,6 +14,7 @@
 #include <linux/list.h>
 #include <linux/cache.h>
 #include <linux/timer.h>
+#include <linux/init.h>
 #include <asm/div64.h>
 #include <asm/io.h>
 
@@ -148,14 +149,11 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  * @disable:		optional function to disable the clocksource
  * @mask:		bitmask for two's complement
  *			subtraction of non 64 bit counters
- * @mult:		cycle to nanosecond multiplier (adjusted by NTP)
- * @mult_orig:		cycle to nanosecond multiplier (unadjusted by NTP)
+ * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
  * @resume:		resume function for the clocksource, if necessary
- * @cycle_interval:	Used internally by timekeeping core, please ignore.
- * @xtime_interval:	Used internally by timekeeping core, please ignore.
  */
 struct clocksource {
 	/*
@@ -169,7 +167,6 @@ struct clocksource {
 	void (*disable)(struct clocksource *cs);
 	cycle_t mask;
 	u32 mult;
-	u32 mult_orig;
 	u32 shift;
 	unsigned long flags;
 	cycle_t (*vread)(void);
@@ -181,19 +178,12 @@ struct clocksource {
 #define CLKSRC_FSYS_MMIO_SET(mmio, addr)      do { } while (0)
 #endif
 
-	/* timekeeping specific data, ignore */
-	cycle_t cycle_interval;
-	u64	xtime_interval;
-	u32	raw_interval;
 	/*
 	 * Second part is written at each timer interrupt
 	 * Keep it in a different cache line to dirty no
 	 * more than one cache line.
 	 */
 	cycle_t cycle_last ____cacheline_aligned_in_smp;
-	u64 xtime_nsec;
-	s64 error;
-	struct timespec raw_time;
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
@@ -202,8 +192,6 @@ struct clocksource {
 #endif
 };
 
-extern struct clocksource *clock;	/* current clocksource */
-
 /*
  * Clock source flags bits::
  */
@@ -212,6 +200,7 @@ extern struct clocksource *clock;	/* current clocksource */
 
 #define CLOCK_SOURCE_WATCHDOG			0x10
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
+#define CLOCK_SOURCE_UNSTABLE			0x40
 
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
@@ -268,108 +257,15 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
 }
 
 /**
- * clocksource_read: - Access the clocksource's current cycle value
- * @cs:		pointer to clocksource being read
- *
- * Uses the clocksource to return the current cycle_t value
- */
-static inline cycle_t clocksource_read(struct clocksource *cs)
-{
-	return cs->read(cs);
-}
-
-/**
- * clocksource_enable: - enable clocksource
- * @cs:		pointer to clocksource
- *
- * Enables the specified clocksource. The clocksource callback
- * function should start up the hardware and setup mult and field
- * members of struct clocksource to reflect hardware capabilities.
- */
-static inline int clocksource_enable(struct clocksource *cs)
-{
-	int ret = 0;
-
-	if (cs->enable)
-		ret = cs->enable(cs);
-
-	/*
-	 * The frequency may have changed while the clocksource
-	 * was disabled. If so the code in ->enable() must update
-	 * the mult value to reflect the new frequency. Make sure
-	 * mult_orig follows this change.
-	 */
-	cs->mult_orig = cs->mult;
-
-	return ret;
-}
-
-/**
- * clocksource_disable: - disable clocksource
- * @cs:		pointer to clocksource
- *
- * Disables the specified clocksource. The clocksource callback
- * function should power down the now unused hardware block to
- * save power.
- */
-static inline void clocksource_disable(struct clocksource *cs)
-{
-	/*
-	 * Save mult_orig in mult so clocksource_enable() can
-	 * restore the value regardless if ->enable() updates
-	 * the value of mult or not.
-	 */
-	cs->mult = cs->mult_orig;
-
-	if (cs->disable)
-		cs->disable(cs);
-}
-
-/**
- * cyc2ns - converts clocksource cycles to nanoseconds
- * @cs:		Pointer to clocksource
- * @cycles:	Cycles
+ * clocksource_cyc2ns - converts clocksource cycles to nanoseconds
  *
- * Uses the clocksource and ntp ajdustment to convert cycle_ts to nanoseconds.
+ * Converts cycles to nanoseconds, using the given mult and shift.
  *
  * XXX - This could use some mult_lxl_ll() asm optimization
  */
-static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
-{
-	u64 ret = (u64)cycles;
-	ret = (ret * cs->mult) >> cs->shift;
-	return ret;
-}
-
-/**
- * clocksource_calculate_interval - Calculates a clocksource interval struct
- *
- * @c:		Pointer to clocksource.
- * @length_nsec: Desired interval length in nanoseconds.
- *
- * Calculates a fixed cycle/nsec interval for a given clocksource/adjustment
- * pair and interval request.
- *
- * Unless you're the timekeeping code, you should not be using this!
- */
-static inline void clocksource_calculate_interval(struct clocksource *c,
-					  	  unsigned long length_nsec)
+static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 {
-	u64 tmp;
-
-	/* Do the ns -> cycle conversion first, using original mult */
-	tmp = length_nsec;
-	tmp <<= c->shift;
-	tmp += c->mult_orig/2;
-	do_div(tmp, c->mult_orig);
-
-	c->cycle_interval = (cycle_t)tmp;
-	if (c->cycle_interval == 0)
-		c->cycle_interval = 1;
-
-	/* Go back from cycles -> shifted ns, this time use ntp adjused mult */
-	c->xtime_interval = (u64)c->cycle_interval * c->mult;
-	c->raw_interval = ((u64)c->cycle_interval * c->mult_orig) >> c->shift;
+	return ((u64) cycles * mult) >> shift;
 }
 
 
@@ -380,6 +276,8 @@ extern void clocksource_touch_watchdog(void);
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_resume(void);
+extern struct clocksource * __init __weak clocksource_default_clock(void);
+extern void clocksource_mark_unstable(struct clocksource *cs);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
@@ -394,4 +292,6 @@ static inline void update_vsyscall_tz(void)
 }
 #endif
 
+extern void timekeeping_notify(struct clocksource *clock);
+
 #endif /* _LINUX_CLOCKSOURCE_H */
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 4759917..ff037f0 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -91,7 +91,6 @@ enum hrtimer_restart {
  * @function:	timer expiry callback function
  * @base:	pointer to the timer base (per cpu and per clock)
  * @state:	state information (See bit values above)
- * @cb_entry:	list head to enqueue an expired timer into the callback list
  * @start_site:	timer statistics field to store the site where the timer
  *		was started
  * @start_comm: timer statistics field to store the name of the process which
@@ -108,7 +107,6 @@ struct hrtimer {
 	enum hrtimer_restart		(*function)(struct hrtimer *);
 	struct hrtimer_clock_base	*base;
 	unsigned long			state;
-	struct list_head		cb_entry;
 #ifdef CONFIG_TIMER_STATS
 	int				start_pid;
 	void				*start_site;
diff --git a/include/linux/time.h b/include/linux/time.h
index ea16c1a..56787c0 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -75,7 +75,7 @@ extern unsigned long mktime(const unsigned int year, const unsigned int mon,
 			    const unsigned int day, const unsigned int hour,
 			    const unsigned int min, const unsigned int sec);
 
-extern void set_normalized_timespec(struct timespec *ts, time_t sec, long nsec);
+extern void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec);
 extern struct timespec timespec_add_safe(const struct timespec lhs,
 					 const struct timespec rhs);
 
@@ -101,7 +101,8 @@ extern struct timespec xtime;
 extern struct timespec wall_to_monotonic;
 extern seqlock_t xtime_lock;
 
-extern unsigned long read_persistent_clock(void);
+extern void read_persistent_clock(struct timespec *ts);
+extern void read_boot_clock(struct timespec *ts);
 extern int update_persistent_clock(struct timespec now);
 extern int no_sync_cmos_clock __read_mostly;
 void timekeeping_init(void);
@@ -109,6 +110,8 @@ extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
+struct timespec __current_kernel_time(void); /* does not hold xtime_lock */
+struct timespec get_monotonic_coarse(void);
 
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
@@ -147,6 +150,7 @@ extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
 extern void update_wall_time(void);
 extern void update_xtime_cache(u64 nsec);
+extern void timekeeping_leap_insert(int leapsecond);
 
 struct tms;
 extern void do_sys_times(struct tms *);
@@ -241,6 +245,8 @@ struct itimerval {
 #define CLOCK_PROCESS_CPUTIME_ID	2
 #define CLOCK_THREAD_CPUTIME_ID		3
 #define CLOCK_MONOTONIC_RAW		4
+#define CLOCK_REALTIME_COARSE		5
+#define CLOCK_MONOTONIC_COARSE		6
 
 /*
  * The IDs of various hardware clocks:
diff --git a/include/linux/timer.h b/include/linux/timer.h
index be62ec2..a2d1eb6 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -175,11 +175,6 @@ extern int mod_timer_pinned(struct timer_list *timer, unsigned long expires);
 
 /*
  * Return when the next timer-wheel timeout occurs (in absolute jiffies),
- * locks the timer base:
- */
-extern unsigned long next_timer_interrupt(void);
-/*
- * Return when the next timer-wheel timeout occurs (in absolute jiffies),
  * locks the timer base and does the comparison against the given
  * jiffie.
  */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 49da79a..e2f91ec 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -48,37 +48,6 @@
 
 #include <asm/uaccess.h>
 
-/**
- * ktime_get - get the monotonic time in ktime_t format
- *
- * returns the time in ktime_t format
- */
-ktime_t ktime_get(void)
-{
-	struct timespec now;
-
-	ktime_get_ts(&now);
-
-	return timespec_to_ktime(now);
-}
-EXPORT_SYMBOL_GPL(ktime_get);
-
-/**
- * ktime_get_real - get the real (wall-) time in ktime_t format
- *
- * returns the time in ktime_t format
- */
-ktime_t ktime_get_real(void)
-{
-	struct timespec now;
-
-	getnstimeofday(&now);
-
-	return timespec_to_ktime(now);
-}
-
-EXPORT_SYMBOL_GPL(ktime_get_real);
-
 /*
  * The timer bases:
  *
@@ -106,31 +75,6 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 	}
 };
 
-/**
- * ktime_get_ts - get the monotonic clock in timespec format
- * @ts:		pointer to timespec variable
- *
- * The function calculates the monotonic clock from the realtime
- * clock and the wall_to_monotonic offset and stores the result
- * in normalized timespec format in the variable pointed to by @ts.
- */
-void ktime_get_ts(struct timespec *ts)
-{
-	struct timespec tomono;
-	unsigned long seq;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		getnstimeofday(ts);
-		tomono = wall_to_monotonic;
-
-	} while (read_seqretry(&xtime_lock, seq));
-
-	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
-				ts->tv_nsec + tomono.tv_nsec);
-}
-EXPORT_SYMBOL_GPL(ktime_get_ts);
-
 /*
  * Get the coarse grained time at the softirq based on xtime and
  * wall_to_monotonic.
@@ -1154,7 +1098,6 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 		clock_id = CLOCK_MONOTONIC;
 
 	timer->base = &cpu_base->clock_base[clock_id];
-	INIT_LIST_HEAD(&timer->cb_entry);
 	hrtimer_init_timer_hres(timer);
 
 #ifdef CONFIG_TIMER_STATS
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index d089d05..4954407 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -242,6 +242,25 @@ static int posix_get_monotonic_raw(clockid_t which_clock, struct timespec *tp)
 	return 0;
 }
 
+
+static int posix_get_realtime_coarse(clockid_t which_clock, struct timespec *tp)
+{
+	*tp = current_kernel_time();
+	return 0;
+}
+
+static int posix_get_monotonic_coarse(clockid_t which_clock,
+						struct timespec *tp)
+{
+	*tp = get_monotonic_coarse();
+	return 0;
+}
+
+int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
+{
+	*tp = ktime_to_timespec(KTIME_LOW_RES);
+	return 0;
+}
 /*
  * Initialize everything, well, just everything in Posix clocks/timers ;)
  */
@@ -262,10 +281,26 @@ static __init int init_posix_timers(void)
 		.timer_create = no_timer_create,
 		.nsleep = no_nsleep,
 	};
+	struct k_clock clock_realtime_coarse = {
+		.clock_getres = posix_get_coarse_res,
+		.clock_get = posix_get_realtime_coarse,
+		.clock_set = do_posix_clock_nosettime,
+		.timer_create = no_timer_create,
+		.nsleep = no_nsleep,
+	};
+	struct k_clock clock_monotonic_coarse = {
+		.clock_getres = posix_get_coarse_res,
+		.clock_get = posix_get_monotonic_coarse,
+		.clock_set = do_posix_clock_nosettime,
+		.timer_create = no_timer_create,
+		.nsleep = no_nsleep,
+	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
 	register_posix_clock(CLOCK_MONOTONIC, &clock_monotonic);
 	register_posix_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
+	register_posix_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
+	register_posix_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
diff --git a/kernel/time.c b/kernel/time.c
index 2951194..2e2e469 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -370,13 +370,20 @@ EXPORT_SYMBOL(mktime);
  *	0 <= tv_nsec < NSEC_PER_SEC
  * For negative values only the tv_sec field is negative !
  */
-void set_normalized_timespec(struct timespec *ts, time_t sec, long nsec)
+void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec)
 {
 	while (nsec >= NSEC_PER_SEC) {
+		/*
+		 * The following asm() prevents the compiler from
+		 * optimising this loop into a modulo operation. See
+		 * also __iter_div_u64_rem() in include/linux/time.h
+		 */
+		asm("" : "+rm"(nsec));
 		nsec -= NSEC_PER_SEC;
 		++sec;
 	}
 	while (nsec < 0) {
+		asm("" : "+rm"(nsec));
 		nsec += NSEC_PER_SEC;
 		--sec;
 	}
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 7466cb8..0911334 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -21,7 +21,6 @@
  *
  * TODO WishList:
  *   o Allow clocksource drivers to be unregistered
- *   o get rid of clocksource_jiffies extern
  */
 
 #include <linux/clocksource.h>
@@ -30,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 #include <linux/tick.h>
+#include <linux/kthread.h>
 
 void timecounter_init(struct timecounter *tc,
 		      const struct cyclecounter *cc,
@@ -107,50 +107,35 @@ u64 timecounter_cyc2time(struct timecounter *tc,
 }
 EXPORT_SYMBOL(timecounter_cyc2time);
 
-/* XXX - Would like a better way for initializing curr_clocksource */
-extern struct clocksource clocksource_jiffies;
-
 /*[Clocksource internal variables]---------
  * curr_clocksource:
- *	currently selected clocksource. Initialized to clocksource_jiffies.
- * next_clocksource:
- *	pending next selected clocksource.
+ *	currently selected clocksource.
  * clocksource_list:
  *	linked list with the registered clocksources
- * clocksource_lock:
- *	protects manipulations to curr_clocksource and next_clocksource
- *	and the clocksource_list
+ * clocksource_mutex:
+ *	protects manipulations to curr_clocksource and the clocksource_list
  * override_name:
  *	Name of the user-specified clocksource.
  */
-static struct clocksource *curr_clocksource = &clocksource_jiffies;
-static struct clocksource *next_clocksource;
-static struct clocksource *clocksource_override;
+static struct clocksource *curr_clocksource;
 static LIST_HEAD(clocksource_list);
-static DEFINE_SPINLOCK(clocksource_lock);
+static DEFINE_MUTEX(clocksource_mutex);
 static char override_name[32];
 static int finished_booting;
 
-/* clocksource_done_booting - Called near the end of core bootup
- *
- * Hack to avoid lots of clocksource churn at boot time.
- * We use fs_initcall because we want this to start before
- * device_initcall but after subsys_initcall.
- */
-static int __init clocksource_done_booting(void)
-{
-	finished_booting = 1;
-	return 0;
-}
-fs_initcall(clocksource_done_booting);
-
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+static void clocksource_watchdog_work(struct work_struct *work);
+
 static LIST_HEAD(watchdog_list);
 static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
+static DECLARE_WORK(watchdog_work, clocksource_watchdog_work);
 static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
-static unsigned long watchdog_resumed;
+static int watchdog_running;
+
+static int clocksource_watchdog_kthread(void *data);
+static void __clocksource_change_rating(struct clocksource *cs, int rating);
 
 /*
  * Interval: 0.5sec Threshold: 0.0625s
@@ -158,135 +143,249 @@ static unsigned long watchdog_resumed;
 #define WATCHDOG_INTERVAL (HZ >> 1)
 #define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 4)
 
-static void clocksource_ratewd(struct clocksource *cs, int64_t delta)
+static void clocksource_watchdog_work(struct work_struct *work)
 {
-	if (delta > -WATCHDOG_THRESHOLD && delta < WATCHDOG_THRESHOLD)
-		return;
+	/*
+	 * If kthread_run fails the next watchdog scan over the
+	 * watchdog_list will find the unstable clock again.
+	 */
+	kthread_run(clocksource_watchdog_kthread, NULL, "kwatchdog");
+}
 
+static void __clocksource_unstable(struct clocksource *cs)
+{
+	cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
+	cs->flags |= CLOCK_SOURCE_UNSTABLE;
+	if (finished_booting)
+		schedule_work(&watchdog_work);
+}
+
+static void clocksource_unstable(struct clocksource *cs, int64_t delta)
+{
 	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
 	       cs->name, delta);
-	cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
-	clocksource_change_rating(cs, 0);
-	list_del(&cs->wd_list);
+	__clocksource_unstable(cs);
+}
+
+/**
+ * clocksource_mark_unstable - mark clocksource unstable via watchdog
+ * @cs:		clocksource to be marked unstable
+ *
+ * This function is called instead of clocksource_change_rating from
+ * cpu hotplug code to avoid a deadlock between the clocksource mutex
+ * and the cpu hotplug mutex. It defers the update of the clocksource
+ * to the watchdog thread.
+ */
+void clocksource_mark_unstable(struct clocksource *cs)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&watchdog_lock, flags);
+	if (!(cs->flags & CLOCK_SOURCE_UNSTABLE)) {
+		if (list_empty(&cs->wd_list))
+			list_add(&cs->wd_list, &watchdog_list);
+		__clocksource_unstable(cs);
+	}
+	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
 static void clocksource_watchdog(unsigned long data)
 {
-	struct clocksource *cs, *tmp;
+	struct clocksource *cs;
 	cycle_t csnow, wdnow;
 	int64_t wd_nsec, cs_nsec;
-	int resumed;
+	int next_cpu;
 
 	spin_lock(&watchdog_lock);
-
-	resumed = test_and_clear_bit(0, &watchdog_resumed);
+	if (!watchdog_running)
+		goto out;
 
 	wdnow = watchdog->read(watchdog);
-	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
+	wd_nsec = clocksource_cyc2ns((wdnow - watchdog_last) & watchdog->mask,
+				     watchdog->mult, watchdog->shift);
 	watchdog_last = wdnow;
 
-	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
-		csnow = cs->read(cs);
+	list_for_each_entry(cs, &watchdog_list, wd_list) {
 
-		if (unlikely(resumed)) {
-			cs->wd_last = csnow;
+		/* Clocksource already marked unstable? */
+		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
+			if (finished_booting)
+				schedule_work(&watchdog_work);
 			continue;
 		}
 
-		/* Initialized ? */
+		csnow = cs->read(cs);
+
+		/* Clocksource initialized ? */
 		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG)) {
-			if ((cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
-			    (watchdog->flags & CLOCK_SOURCE_IS_CONTINUOUS)) {
-				cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
-				/*
-				 * We just marked the clocksource as
-				 * highres-capable, notify the rest of the
-				 * system as well so that we transition
-				 * into high-res mode:
-				 */
-				tick_clock_notify();
-			}
 			cs->flags |= CLOCK_SOURCE_WATCHDOG;
 			cs->wd_last = csnow;
-		} else {
-			cs_nsec = cyc2ns(cs, (csnow - cs->wd_last) & cs->mask);
-			cs->wd_last = csnow;
-			/* Check the delta. Might remove from the list ! */
-			clocksource_ratewd(cs, cs_nsec - wd_nsec);
+			continue;
 		}
-	}
 
-	if (!list_empty(&watchdog_list)) {
-		/*
-		 * Cycle through CPUs to check if the CPUs stay
-		 * synchronized to each other.
-		 */
-		int next_cpu = cpumask_next(raw_smp_processor_id(),
-					    cpu_online_mask);
+		/* Check the deviation from the watchdog clocksource. */
+		cs_nsec = clocksource_cyc2ns((csnow - cs->wd_last) &
+					     cs->mask, cs->mult, cs->shift);
+		cs->wd_last = csnow;
+		if (abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
+			clocksource_unstable(cs, cs_nsec - wd_nsec);
+			continue;
+		}
 
-		if (next_cpu >= nr_cpu_ids)
-			next_cpu = cpumask_first(cpu_online_mask);
-		watchdog_timer.expires += WATCHDOG_INTERVAL;
-		add_timer_on(&watchdog_timer, next_cpu);
+		if (!(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES) &&
+		    (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
+		    (watchdog->flags & CLOCK_SOURCE_IS_CONTINUOUS)) {
+			cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
+			/*
+			 * We just marked the clocksource as highres-capable,
+			 * notify the rest of the system as well so that we
+			 * transition into high-res mode:
+			 */
+			tick_clock_notify();
+		}
 	}
+
+	/*
+	 * Cycle through CPUs to check if the CPUs stay synchronized
+	 * to each other.
+	 */
+	next_cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
+	if (next_cpu >= nr_cpu_ids)
+		next_cpu = cpumask_first(cpu_online_mask);
+	watchdog_timer.expires += WATCHDOG_INTERVAL;
+	add_timer_on(&watchdog_timer, next_cpu);
+out:
 	spin_unlock(&watchdog_lock);
 }
+
+static inline void clocksource_start_watchdog(void)
+{
+	if (watchdog_running || !watchdog || list_empty(&watchdog_list))
+		return;
+	init_timer(&watchdog_timer);
+	watchdog_timer.function = clocksource_watchdog;
+	watchdog_last = watchdog->read(watchdog);
+	watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
+	add_timer_on(&watchdog_timer, cpumask_first(cpu_online_mask));
+	watchdog_running = 1;
+}
+
+static inline void clocksource_stop_watchdog(void)
+{
+	if (!watchdog_running || (watchdog && !list_empty(&watchdog_list)))
+		return;
+	del_timer(&watchdog_timer);
+	watchdog_running = 0;
+}
+
+static inline void clocksource_reset_watchdog(void)
+{
+	struct clocksource *cs;
+
+	list_for_each_entry(cs, &watchdog_list, wd_list)
+		cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
+}
+
 static void clocksource_resume_watchdog(void)
 {
-	set_bit(0, &watchdog_resumed);
+	unsigned long flags;
+
+	spin_lock_irqsave(&watchdog_lock, flags);
+	clocksource_reset_watchdog();
+	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
-static void clocksource_check_watchdog(struct clocksource *cs)
+static void clocksource_enqueue_watchdog(struct clocksource *cs)
 {
-	struct clocksource *cse;
 	unsigned long flags;
 
 	spin_lock_irqsave(&watchdog_lock, flags);
 	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
-		int started = !list_empty(&watchdog_list);
-
+		/* cs is a clocksource to be watched. */
 		list_add(&cs->wd_list, &watchdog_list);
-		if (!started && watchdog) {
-			watchdog_last = watchdog->read(watchdog);
-			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
-			add_timer_on(&watchdog_timer,
-				     cpumask_first(cpu_online_mask));
-		}
+		cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
 	} else {
+		/* cs is a watchdog. */
 		if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
 			cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
-
+		/* Pick the best watchdog. */
 		if (!watchdog || cs->rating > watchdog->rating) {
-			if (watchdog)
-				del_timer(&watchdog_timer);
 			watchdog = cs;
-			init_timer(&watchdog_timer);
-			watchdog_timer.function = clocksource_watchdog;
-
 			/* Reset watchdog cycles */
-			list_for_each_entry(cse, &watchdog_list, wd_list)
-				cse->flags &= ~CLOCK_SOURCE_WATCHDOG;
-			/* Start if list is not empty */
-			if (!list_empty(&watchdog_list)) {
-				watchdog_last = watchdog->read(watchdog);
-				watchdog_timer.expires =
-					jiffies + WATCHDOG_INTERVAL;
-				add_timer_on(&watchdog_timer,
-					     cpumask_first(cpu_online_mask));
-			}
+			clocksource_reset_watchdog();
+		}
+	}
+	/* Check if the watchdog timer needs to be started. */
+	clocksource_start_watchdog();
+	spin_unlock_irqrestore(&watchdog_lock, flags);
+}
+
+static void clocksource_dequeue_watchdog(struct clocksource *cs)
+{
+	struct clocksource *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&watchdog_lock, flags);
+	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
+		/* cs is a watched clocksource. */
+		list_del_init(&cs->wd_list);
+	} else if (cs == watchdog) {
+		/* Reset watchdog cycles */
+		clocksource_reset_watchdog();
+		/* Current watchdog is removed. Find an alternative. */
+		watchdog = NULL;
+		list_for_each_entry(tmp, &clocksource_list, list) {
+			if (tmp == cs || tmp->flags & CLOCK_SOURCE_MUST_VERIFY)
+				continue;
+			if (!watchdog || tmp->rating > watchdog->rating)
+				watchdog = tmp;
 		}
 	}
+	cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
+	/* Check if the watchdog timer needs to be stopped. */
+	clocksource_stop_watchdog();
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
-#else
-static void clocksource_check_watchdog(struct clocksource *cs)
+
+static int clocksource_watchdog_kthread(void *data)
+{
+	struct clocksource *cs, *tmp;
+	unsigned long flags;
+	LIST_HEAD(unstable);
+
+	mutex_lock(&clocksource_mutex);
+	spin_lock_irqsave(&watchdog_lock, flags);
+	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list)
+		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
+			list_del_init(&cs->wd_list);
+			list_add(&cs->wd_list, &unstable);
+		}
+	/* Check if the watchdog timer needs to be stopped. */
+	clocksource_stop_watchdog();
+	spin_unlock_irqrestore(&watchdog_lock, flags);
+
+	/* Needs to be done outside of watchdog lock */
+	list_for_each_entry_safe(cs, tmp, &unstable, wd_list) {
+		list_del_init(&cs->wd_list);
+		__clocksource_change_rating(cs, 0);
+	}
+	mutex_unlock(&clocksource_mutex);
+	return 0;
+}
+
+#else /* CONFIG_CLOCKSOURCE_WATCHDOG */
+
+static void clocksource_enqueue_watchdog(struct clocksource *cs)
 {
 	if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
 		cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
 }
 
+static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
 static inline void clocksource_resume_watchdog(void) { }
-#endif
+static inline int clocksource_watchdog_kthread(void *data) { return 0; }
+
+#endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
 /**
  * clocksource_resume - resume the clocksource(s)
@@ -294,18 +393,16 @@ static inline void clocksource_resume_watchdog(void) { }
 void clocksource_resume(void)
 {
 	struct clocksource *cs;
-	unsigned long flags;
 
-	spin_lock_irqsave(&clocksource_lock, flags);
+	mutex_lock(&clocksource_mutex);
 
-	list_for_each_entry(cs, &clocksource_list, list) {
+	list_for_each_entry(cs, &clocksource_list, list)
 		if (cs->resume)
 			cs->resume();
-	}
 
 	clocksource_resume_watchdog();
 
-	spin_unlock_irqrestore(&clocksource_lock, flags);
+	mutex_unlock(&clocksource_mutex);
 }
 
 /**
@@ -320,75 +417,94 @@ void clocksource_touch_watchdog(void)
 	clocksource_resume_watchdog();
 }
 
+#ifdef CONFIG_GENERIC_TIME
+
 /**
- * clocksource_get_next - Returns the selected clocksource
+ * clocksource_select - Select the best clocksource available
+ *
+ * Private function. Must hold clocksource_mutex when called.
  *
+ * Select the clocksource with the best rating, or the clocksource,
+ * which is selected by userspace override.
  */
-struct clocksource *clocksource_get_next(void)
+static void clocksource_select(void)
 {
-	unsigned long flags;
+	struct clocksource *best, *cs;
 
-	spin_lock_irqsave(&clocksource_lock, flags);
-	if (next_clocksource && finished_booting) {
-		curr_clocksource = next_clocksource;
-		next_clocksource = NULL;
+	if (!finished_booting || list_empty(&clocksource_list))
+		return;
+	/* First clocksource on the list has the best rating. */
+	best = list_first_entry(&clocksource_list, struct clocksource, list);
+	/* Check for the override clocksource. */
+	list_for_each_entry(cs, &clocksource_list, list) {
+		if (strcmp(cs->name, override_name) != 0)
+			continue;
+		/*
+		 * Check to make sure we don't switch to a non-highres
+		 * capable clocksource if the tick code is in oneshot
+		 * mode (highres or nohz)
+		 */
+		if (!(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES) &&
+		    tick_oneshot_mode_active()) {
+			/* Override clocksource cannot be used. */
+			printk(KERN_WARNING "Override clocksource %s is not "
+			       "HRT compatible. Cannot switch while in "
+			       "HRT/NOHZ mode\n", cs->name);
+			override_name[0] = 0;
+		} else
+			/* Override clocksource can be used. */
+			best = cs;
+		break;
+	}
+	if (curr_clocksource != best) {
+		printk(KERN_INFO "Switching to clocksource %s\n", best->name);
+		curr_clocksource = best;
+		timekeeping_notify(curr_clocksource);
 	}
-	spin_unlock_irqrestore(&clocksource_lock, flags);
-
-	return curr_clocksource;
 }
 
-/**
- * select_clocksource - Selects the best registered clocksource.
- *
- * Private function. Must hold clocksource_lock when called.
+#else /* CONFIG_GENERIC_TIME */
+
+static inline void clocksource_select(void) { }
+
+#endif
+
+/*
+ * clocksource_done_booting - Called near the end of core bootup
  *
- * Select the clocksource with the best rating, or the clocksource,
- * which is selected by userspace override.
+ * Hack to avoid lots of clocksource churn at boot time.
+ * We use fs_initcall because we want this to start before
+ * device_initcall but after subsys_initcall.
  */
-static struct clocksource *select_clocksource(void)
+static int __init clocksource_done_booting(void)
 {
-	struct clocksource *next;
-
-	if (list_empty(&clocksource_list))
-		return NULL;
-
-	if (clocksource_override)
-		next = clocksource_override;
-	else
-		next = list_entry(clocksource_list.next, struct clocksource,
-				  list);
+	finished_booting = 1;
 
-	if (next == curr_clocksource)
-		return NULL;
+	/*
+	 * Run the watchdog first to eliminate unstable clock sources
+	 */
+	clocksource_watchdog_kthread(NULL);
 
-	return next;
+	mutex_lock(&clocksource_mutex);
+	clocksource_select();
+	mutex_unlock(&clocksource_mutex);
+	return 0;
 }
+fs_initcall(clocksource_done_booting);
 
 /*
  * Enqueue the clocksource sorted by rating
  */
-static int clocksource_enqueue(struct clocksource *c)
+static void clocksource_enqueue(struct clocksource *cs)
 {
-	struct list_head *tmp, *entry = &clocksource_list;
+	struct list_head *entry = &clocksource_list;
+	struct clocksource *tmp;
 
-	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *cs;
-
-		cs = list_entry(tmp, struct clocksource, list);
-		if (cs == c)
-			return -EBUSY;
+	list_for_each_entry(tmp, &clocksource_list, list)
 		/* Keep track of the place, where to insert */
-		if (cs->rating >= c->rating)
-			entry = tmp;
-	}
-	list_add(&c->list, entry);
-
-	if (strlen(c->name) == strlen(override_name) &&
-	    !strcmp(c->name, override_name))
-		clocksource_override = c;
-
-	return 0;
+		if (tmp->rating >= cs->rating)
+			entry = &tmp->list;
+	list_add(&cs->list, entry);
 }
 
 /**
@@ -397,52 +513,48 @@ static int clocksource_enqueue(struct clocksource *c)
  *
  * Returns -EBUSY if registration fails, zero otherwise.
  */
-int clocksource_register(struct clocksource *c)
+int clocksource_register(struct clocksource *cs)
 {
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&clocksource_lock, flags);
-	ret = clocksource_enqueue(c);
-	if (!ret)
-		next_clocksource = select_clocksource();
-	spin_unlock_irqrestore(&clocksource_lock, flags);
-	if (!ret)
-		clocksource_check_watchdog(c);
-	return ret;
+	mutex_lock(&clocksource_mutex);
+	clocksource_enqueue(cs);
+	clocksource_select();
+	clocksource_enqueue_watchdog(cs);
+	mutex_unlock(&clocksource_mutex);
+	return 0;
 }
 EXPORT_SYMBOL(clocksource_register);
 
+static void __clocksource_change_rating(struct clocksource *cs, int rating)
+{
+	list_del(&cs->list);
+	cs->rating = rating;
+	clocksource_enqueue(cs);
+	clocksource_select();
+}
+
 /**
  * clocksource_change_rating - Change the rating of a registered clocksource
- *
  */
 void clocksource_change_rating(struct clocksource *cs, int rating)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&clocksource_lock, flags);
-	list_del(&cs->list);
-	cs->rating = rating;
-	clocksource_enqueue(cs);
-	next_clocksource = select_clocksource();
-	spin_unlock_irqrestore(&clocksource_lock, flags);
+	mutex_lock(&clocksource_mutex);
+	__clocksource_change_rating(cs, rating);
+	mutex_unlock(&clocksource_mutex);
 }
+EXPORT_SYMBOL(clocksource_change_rating);
 
 /**
  * clocksource_unregister - remove a registered clocksource
  */
 void clocksource_unregister(struct clocksource *cs)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&clocksource_lock, flags);
+	mutex_lock(&clocksource_mutex);
+	clocksource_dequeue_watchdog(cs);
 	list_del(&cs->list);
-	if (clocksource_override == cs)
-		clocksource_override = NULL;
-	next_clocksource = select_clocksource();
-	spin_unlock_irqrestore(&clocksource_lock, flags);
+	clocksource_select();
+	mutex_unlock(&clocksource_mutex);
 }
+EXPORT_SYMBOL(clocksource_unregister);
 
 #ifdef CONFIG_SYSFS
 /**
@@ -458,9 +570,9 @@ sysfs_show_current_clocksources(struct sys_device *dev,
 {
 	ssize_t count = 0;
 
-	spin_lock_irq(&clocksource_lock);
+	mutex_lock(&clocksource_mutex);
 	count = snprintf(buf, PAGE_SIZE, "%s\n", curr_clocksource->name);
-	spin_unlock_irq(&clocksource_lock);
+	mutex_unlock(&clocksource_mutex);
 
 	return count;
 }
@@ -478,9 +590,7 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 					  struct sysdev_attribute *attr,
 					  const char *buf, size_t count)
 {
-	struct clocksource *ovr = NULL;
 	size_t ret = count;
-	int len;
 
 	/* strings from sysfs write are not 0 terminated! */
 	if (count >= sizeof(override_name))
@@ -490,44 +600,14 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 	if (buf[count-1] == '\n')
 		count--;
 
-	spin_lock_irq(&clocksource_lock);
+	mutex_lock(&clocksource_mutex);
 
 	if (count > 0)
 		memcpy(override_name, buf, count);
 	override_name[count] = 0;
+	clocksource_select();
 
-	len = strlen(override_name);
-	if (len) {
-		struct clocksource *cs;
-
-		ovr = clocksource_override;
-		/* try to select it: */
-		list_for_each_entry(cs, &clocksource_list, list) {
-			if (strlen(cs->name) == len &&
-			    !strcmp(cs->name, override_name))
-				ovr = cs;
-		}
-	}
-
-	/*
-	 * Check to make sure we don't switch to a non-highres capable
-	 * clocksource if the tick code is in oneshot mode (highres or nohz)
-	 */
-	if (tick_oneshot_mode_active() && ovr &&
-	    !(ovr->flags & CLOCK_SOURCE_VALID_FOR_HRES)) {
-		printk(KERN_WARNING "%s clocksource is not HRT compatible. "
-			"Cannot switch while in HRT/NOHZ mode\n", ovr->name);
-		ovr = NULL;
-		override_name[0] = 0;
-	}
-
-	/* Reselect, when the override name has changed */
-	if (ovr != clocksource_override) {
-		clocksource_override = ovr;
-		next_clocksource = select_clocksource();
-	}
-
-	spin_unlock_irq(&clocksource_lock);
+	mutex_unlock(&clocksource_mutex);
 
 	return ret;
 }
@@ -547,7 +627,7 @@ sysfs_show_available_clocksources(struct sys_device *dev,
 	struct clocksource *src;
 	ssize_t count = 0;
 
-	spin_lock_irq(&clocksource_lock);
+	mutex_lock(&clocksource_mutex);
 	list_for_each_entry(src, &clocksource_list, list) {
 		/*
 		 * Don't show non-HRES clocksource if the tick code is
@@ -559,7 +639,7 @@ sysfs_show_available_clocksources(struct sys_device *dev,
 				  max((ssize_t)PAGE_SIZE - count, (ssize_t)0),
 				  "%s ", src->name);
 	}
-	spin_unlock_irq(&clocksource_lock);
+	mutex_unlock(&clocksource_mutex);
 
 	count += snprintf(buf + count,
 			  max((ssize_t)PAGE_SIZE - count, (ssize_t)0), "\n");
@@ -614,11 +694,10 @@ device_initcall(init_clocksource_sysfs);
  */
 static int __init boot_override_clocksource(char* str)
 {
-	unsigned long flags;
-	spin_lock_irqsave(&clocksource_lock, flags);
+	mutex_lock(&clocksource_mutex);
 	if (str)
 		strlcpy(override_name, str, sizeof(override_name));
-	spin_unlock_irqrestore(&clocksource_lock, flags);
+	mutex_unlock(&clocksource_mutex);
 	return 1;
 }
 
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index c3f6c30..5404a84 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -61,7 +61,6 @@ struct clocksource clocksource_jiffies = {
 	.read		= jiffies_read,
 	.mask		= 0xffffffff, /*32bits*/
 	.mult		= NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
-	.mult_orig	= NSEC_PER_JIFFY << JIFFIES_SHIFT,
 	.shift		= JIFFIES_SHIFT,
 };
 
@@ -71,3 +70,8 @@ static int __init init_jiffies_clocksource(void)
 }
 
 core_initcall(init_jiffies_clocksource);
+
+struct clocksource * __init __weak clocksource_default_clock(void)
+{
+	return &clocksource_jiffies;
+}
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 7fc6437..4800f93 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -194,8 +194,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 	case TIME_OK:
 		break;
 	case TIME_INS:
-		xtime.tv_sec--;
-		wall_to_monotonic.tv_sec++;
+		timekeeping_leap_insert(-1);
 		time_state = TIME_OOP;
 		printk(KERN_NOTICE
 			"Clock: inserting leap second 23:59:60 UTC\n");
@@ -203,9 +202,8 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 		res = HRTIMER_RESTART;
 		break;
 	case TIME_DEL:
-		xtime.tv_sec++;
+		timekeeping_leap_insert(1);
 		time_tai--;
-		wall_to_monotonic.tv_sec--;
 		time_state = TIME_WAIT;
 		printk(KERN_NOTICE
 			"Clock: deleting leap second 23:59:59 UTC\n");
@@ -219,7 +217,6 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 			time_state = TIME_OK;
 		break;
 	}
-	update_vsyscall(&xtime, clock);
 
 	write_sequnlock(&xtime_lock);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e8c77d9..fb0f46f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -18,7 +18,117 @@
 #include <linux/jiffies.h>
 #include <linux/time.h>
 #include <linux/tick.h>
+#include <linux/stop_machine.h>
+
+/* Structure holding internal timekeeping values. */
+struct timekeeper {
+	/* Current clocksource used for timekeeping. */
+	struct clocksource *clock;
+	/* The shift value of the current clocksource. */
+	int	shift;
+
+	/* Number of clock cycles in one NTP interval. */
+	cycle_t cycle_interval;
+	/* Number of clock shifted nano seconds in one NTP interval. */
+	u64	xtime_interval;
+	/* Raw nano seconds accumulated per NTP interval. */
+	u32	raw_interval;
+
+	/* Clock shifted nano seconds remainder not stored in xtime.tv_nsec. */
+	u64	xtime_nsec;
+	/* Difference between accumulated time and NTP time in ntp
+	 * shifted nano seconds. */
+	s64	ntp_error;
+	/* Shift conversion between clock shifted nano seconds and
+	 * ntp shifted nano seconds. */
+	int	ntp_error_shift;
+	/* NTP adjusted clock multiplier */
+	u32	mult;
+};
+
+struct timekeeper timekeeper;
+
+/**
+ * timekeeper_setup_internals - Set up internals to use clocksource clock.
+ *
+ * @clock:		Pointer to clocksource.
+ *
+ * Calculates a fixed cycle/nsec interval for a given clocksource/adjustment
+ * pair and interval request.
+ *
+ * Unless you're the timekeeping code, you should not be using this!
+ */
+static void timekeeper_setup_internals(struct clocksource *clock)
+{
+	cycle_t interval;
+	u64 tmp;
+
+	timekeeper.clock = clock;
+	clock->cycle_last = clock->read(clock);
 
+	/* Do the ns -> cycle conversion first, using original mult */
+	tmp = NTP_INTERVAL_LENGTH;
+	tmp <<= clock->shift;
+	tmp += clock->mult/2;
+	do_div(tmp, clock->mult);
+	if (tmp == 0)
+		tmp = 1;
+
+	interval = (cycle_t) tmp;
+	timekeeper.cycle_interval = interval;
+
+	/* Go back from cycles -> shifted ns */
+	timekeeper.xtime_interval = (u64) interval * clock->mult;
+	timekeeper.raw_interval =
+		((u64) interval * clock->mult) >> clock->shift;
+
+	timekeeper.xtime_nsec = 0;
+	timekeeper.shift = clock->shift;
+
+	timekeeper.ntp_error = 0;
+	timekeeper.ntp_error_shift = NTP_SCALE_SHIFT - clock->shift;
+
+	/*
+	 * The timekeeper keeps its own mult values for the currently
+	 * active clocksource. These value will be adjusted via NTP
+	 * to counteract clock drifting.
+	 */
+	timekeeper.mult = clock->mult;
+}
+
+/* Timekeeper helper functions. */
+static inline s64 timekeeping_get_ns(void)
+{
+	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
+
+	/* read clocksource: */
+	clock = timekeeper.clock;
+	cycle_now = clock->read(clock);
+
+	/* calculate the delta since the last update_wall_time: */
+	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+
+	/* return delta convert to nanoseconds using ntp adjusted mult. */
+	return clocksource_cyc2ns(cycle_delta, timekeeper.mult,
+				  timekeeper.shift);
+}
+
+static inline s64 timekeeping_get_ns_raw(void)
+{
+	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
+
+	/* read clocksource: */
+	clock = timekeeper.clock;
+	cycle_now = clock->read(clock);
+
+	/* calculate the delta since the last update_wall_time: */
+	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+
+	/* return delta convert to nanoseconds using ntp adjusted mult. */
+	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
+}
 
 /*
  * This read-write spinlock protects us from races in SMP while
@@ -44,7 +154,12 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
  */
 struct timespec xtime __attribute__ ((aligned (16)));
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
-static unsigned long total_sleep_time;		/* seconds */
+static struct timespec total_sleep_time;
+
+/*
+ * The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock.
+ */
+struct timespec raw_time;
 
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
@@ -56,35 +171,44 @@ void update_xtime_cache(u64 nsec)
 	timespec_add_ns(&xtime_cache, nsec);
 }
 
-struct clocksource *clock;
-
+/* must hold xtime_lock */
+void timekeeping_leap_insert(int leapsecond)
+{
+	xtime.tv_sec += leapsecond;
+	wall_to_monotonic.tv_sec -= leapsecond;
+	update_vsyscall(&xtime, timekeeper.clock);
+}
 
 #ifdef CONFIG_GENERIC_TIME
+
 /**
- * clocksource_forward_now - update clock to the current time
+ * timekeeping_forward_now - update clock to the current time
  *
  * Forward the current clock to update its state since the last call to
  * update_wall_time(). This is useful before significant clock changes,
  * as it avoids having to deal with this time offset explicitly.
  */
-static void clocksource_forward_now(void)
+static void timekeeping_forward_now(void)
 {
 	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
 	s64 nsec;
 
-	cycle_now = clocksource_read(clock);
+	clock = timekeeper.clock;
+	cycle_now = clock->read(clock);
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 	clock->cycle_last = cycle_now;
 
-	nsec = cyc2ns(clock, cycle_delta);
+	nsec = clocksource_cyc2ns(cycle_delta, timekeeper.mult,
+				  timekeeper.shift);
 
 	/* If arch requires, add in gettimeoffset() */
 	nsec += arch_gettimeoffset();
 
 	timespec_add_ns(&xtime, nsec);
 
-	nsec = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
-	clock->raw_time.tv_nsec += nsec;
+	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
+	timespec_add_ns(&raw_time, nsec);
 }
 
 /**
@@ -95,7 +219,6 @@ static void clocksource_forward_now(void)
  */
 void getnstimeofday(struct timespec *ts)
 {
-	cycle_t cycle_now, cycle_delta;
 	unsigned long seq;
 	s64 nsecs;
 
@@ -105,15 +228,7 @@ void getnstimeofday(struct timespec *ts)
 		seq = read_seqbegin(&xtime_lock);
 
 		*ts = xtime;
-
-		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
-
-		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-		/* convert to nanoseconds: */
-		nsecs = cyc2ns(clock, cycle_delta);
+		nsecs = timekeeping_get_ns();
 
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
@@ -125,6 +240,57 @@ void getnstimeofday(struct timespec *ts)
 
 EXPORT_SYMBOL(getnstimeofday);
 
+ktime_t ktime_get(void)
+{
+	unsigned int seq;
+	s64 secs, nsecs;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
+		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
+		nsecs += timekeeping_get_ns();
+
+	} while (read_seqretry(&xtime_lock, seq));
+	/*
+	 * Use ktime_set/ktime_add_ns to create a proper ktime on
+	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
+	 */
+	return ktime_add_ns(ktime_set(secs, 0), nsecs);
+}
+EXPORT_SYMBOL_GPL(ktime_get);
+
+/**
+ * ktime_get_ts - get the monotonic clock in timespec format
+ * @ts:		pointer to timespec variable
+ *
+ * The function calculates the monotonic clock from the realtime
+ * clock and the wall_to_monotonic offset and stores the result
+ * in normalized timespec format in the variable pointed to by @ts.
+ */
+void ktime_get_ts(struct timespec *ts)
+{
+	struct timespec tomono;
+	unsigned int seq;
+	s64 nsecs;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		*ts = xtime;
+		tomono = wall_to_monotonic;
+		nsecs = timekeeping_get_ns();
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
+				ts->tv_nsec + tomono.tv_nsec + nsecs);
+}
+EXPORT_SYMBOL_GPL(ktime_get_ts);
+
 /**
  * do_gettimeofday - Returns the time of day in a timeval
  * @tv:		pointer to the timeval to be set
@@ -157,7 +323,7 @@ int do_settimeofday(struct timespec *tv)
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
-	clocksource_forward_now();
+	timekeeping_forward_now();
 
 	ts_delta.tv_sec = tv->tv_sec - xtime.tv_sec;
 	ts_delta.tv_nsec = tv->tv_nsec - xtime.tv_nsec;
@@ -167,10 +333,10 @@ int do_settimeofday(struct timespec *tv)
 
 	update_xtime_cache(0);
 
-	clock->error = 0;
+	timekeeper.ntp_error = 0;
 	ntp_clear();
 
-	update_vsyscall(&xtime, clock);
+	update_vsyscall(&xtime, timekeeper.clock);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -187,44 +353,97 @@ EXPORT_SYMBOL(do_settimeofday);
  *
  * Accumulates current time interval and initializes new clocksource
  */
-static void change_clocksource(void)
+static int change_clocksource(void *data)
 {
 	struct clocksource *new, *old;
 
-	new = clocksource_get_next();
+	new = (struct clocksource *) data;
+
+	timekeeping_forward_now();
+	if (!new->enable || new->enable(new) == 0) {
+		old = timekeeper.clock;
+		timekeeper_setup_internals(new);
+		if (old->disable)
+			old->disable(old);
+	}
+	return 0;
+}
 
-	if (clock == new)
+/**
+ * timekeeping_notify - Install a new clock source
+ * @clock:		pointer to the clock source
+ *
+ * This function is called from clocksource.c after a new, better clock
+ * source has been registered. The caller holds the clocksource_mutex.
+ */
+void timekeeping_notify(struct clocksource *clock)
+{
+	if (timekeeper.clock == clock)
 		return;
+	stop_machine(change_clocksource, clock, NULL);
+	tick_clock_notify();
+}
 
-	clocksource_forward_now();
+#else /* GENERIC_TIME */
 
-	if (clocksource_enable(new))
-		return;
+static inline void timekeeping_forward_now(void) { }
 
-	new->raw_time = clock->raw_time;
-	old = clock;
-	clock = new;
-	clocksource_disable(old);
+/**
+ * ktime_get - get the monotonic time in ktime_t format
+ *
+ * returns the time in ktime_t format
+ */
+ktime_t ktime_get(void)
+{
+	struct timespec now;
 
-	clock->cycle_last = 0;
-	clock->cycle_last = clocksource_read(clock);
-	clock->error = 0;
-	clock->xtime_nsec = 0;
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
+	ktime_get_ts(&now);
 
-	tick_clock_notify();
+	return timespec_to_ktime(now);
+}
+EXPORT_SYMBOL_GPL(ktime_get);
 
-	/*
-	 * We're holding xtime lock and waking up klogd would deadlock
-	 * us on enqueue.  So no printing!
-	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
-	       clock->name);
-	 */
+/**
+ * ktime_get_ts - get the monotonic clock in timespec format
+ * @ts:		pointer to timespec variable
+ *
+ * The function calculates the monotonic clock from the realtime
+ * clock and the wall_to_monotonic offset and stores the result
+ * in normalized timespec format in the variable pointed to by @ts.
+ */
+void ktime_get_ts(struct timespec *ts)
+{
+	struct timespec tomono;
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		getnstimeofday(ts);
+		tomono = wall_to_monotonic;
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
+				ts->tv_nsec + tomono.tv_nsec);
 }
-#else
-static inline void clocksource_forward_now(void) { }
-static inline void change_clocksource(void) { }
-#endif
+EXPORT_SYMBOL_GPL(ktime_get_ts);
+
+#endif /* !GENERIC_TIME */
+
+/**
+ * ktime_get_real - get the real (wall-) time in ktime_t format
+ *
+ * returns the time in ktime_t format
+ */
+ktime_t ktime_get_real(void)
+{
+	struct timespec now;
+
+	getnstimeofday(&now);
+
+	return timespec_to_ktime(now);
+}
+EXPORT_SYMBOL_GPL(ktime_get_real);
 
 /**
  * getrawmonotonic - Returns the raw monotonic time in a timespec
@@ -236,21 +455,11 @@ void getrawmonotonic(struct timespec *ts)
 {
 	unsigned long seq;
 	s64 nsecs;
-	cycle_t cycle_now, cycle_delta;
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-
-		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
-
-		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-		/* convert to nanoseconds: */
-		nsecs = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
-
-		*ts = clock->raw_time;
+		nsecs = timekeeping_get_ns_raw();
+		*ts = raw_time;
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -270,7 +479,7 @@ int timekeeping_valid_for_hres(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		ret = clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
+		ret = timekeeper.clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -278,17 +487,33 @@ int timekeeping_valid_for_hres(void)
 }
 
 /**
- * read_persistent_clock -  Return time in seconds from the persistent clock.
+ * read_persistent_clock -  Return time from the persistent clock.
  *
  * Weak dummy function for arches that do not yet support it.
- * Returns seconds from epoch using the battery backed persistent clock.
- * Returns zero if unsupported.
+ * Reads the time from the battery backed persistent clock.
+ * Returns a timespec with tv_sec=0 and tv_nsec=0 if unsupported.
  *
  *  XXX - Do be sure to remove it once all arches implement it.
  */
-unsigned long __attribute__((weak)) read_persistent_clock(void)
+void __attribute__((weak)) read_persistent_clock(struct timespec *ts)
 {
-	return 0;
+	ts->tv_sec = 0;
+	ts->tv_nsec = 0;
+}
+
+/**
+ * read_boot_clock -  Return time of the system start.
+ *
+ * Weak dummy function for arches that do not yet support it.
+ * Function to read the exact time the system has been started.
+ * Returns a timespec with tv_sec=0 and tv_nsec=0 if unsupported.
+ *
+ *  XXX - Do be sure to remove it once all arches implement it.
+ */
+void __attribute__((weak)) read_boot_clock(struct timespec *ts)
+{
+	ts->tv_sec = 0;
+	ts->tv_nsec = 0;
 }
 
 /*
@@ -296,29 +521,40 @@ unsigned long __attribute__((weak)) read_persistent_clock(void)
  */
 void __init timekeeping_init(void)
 {
+	struct clocksource *clock;
 	unsigned long flags;
-	unsigned long sec = read_persistent_clock();
+	struct timespec now, boot;
+
+	read_persistent_clock(&now);
+	read_boot_clock(&boot);
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
 	ntp_init();
 
-	clock = clocksource_get_next();
-	clocksource_enable(clock);
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-	clock->cycle_last = clocksource_read(clock);
-
-	xtime.tv_sec = sec;
-	xtime.tv_nsec = 0;
+	clock = clocksource_default_clock();
+	if (clock->enable)
+		clock->enable(clock);
+	timekeeper_setup_internals(clock);
+
+	xtime.tv_sec = now.tv_sec;
+	xtime.tv_nsec = now.tv_nsec;
+	raw_time.tv_sec = 0;
+	raw_time.tv_nsec = 0;
+	if (boot.tv_sec == 0 && boot.tv_nsec == 0) {
+		boot.tv_sec = xtime.tv_sec;
+		boot.tv_nsec = xtime.tv_nsec;
+	}
 	set_normalized_timespec(&wall_to_monotonic,
-		-xtime.tv_sec, -xtime.tv_nsec);
+				-boot.tv_sec, -boot.tv_nsec);
 	update_xtime_cache(0);
-	total_sleep_time = 0;
+	total_sleep_time.tv_sec = 0;
+	total_sleep_time.tv_nsec = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
 /* time in seconds when suspend began */
-static unsigned long timekeeping_suspend_time;
+static struct timespec timekeeping_suspend_time;
 
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
@@ -331,24 +567,24 @@ static unsigned long timekeeping_suspend_time;
 static int timekeeping_resume(struct sys_device *dev)
 {
 	unsigned long flags;
-	unsigned long now = read_persistent_clock();
+	struct timespec ts;
+
+	read_persistent_clock(&ts);
 
 	clocksource_resume();
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
-	if (now && (now > timekeeping_suspend_time)) {
-		unsigned long sleep_length = now - timekeeping_suspend_time;
-
-		xtime.tv_sec += sleep_length;
-		wall_to_monotonic.tv_sec -= sleep_length;
-		total_sleep_time += sleep_length;
+	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
+		ts = timespec_sub(ts, timekeeping_suspend_time);
+		xtime = timespec_add_safe(xtime, ts);
+		wall_to_monotonic = timespec_sub(wall_to_monotonic, ts);
+		total_sleep_time = timespec_add_safe(total_sleep_time, ts);
 	}
 	update_xtime_cache(0);
 	/* re-base the last cycle value */
-	clock->cycle_last = 0;
-	clock->cycle_last = clocksource_read(clock);
-	clock->error = 0;
+	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
+	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -366,10 +602,10 @@ static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
 {
 	unsigned long flags;
 
-	timekeeping_suspend_time = read_persistent_clock();
+	read_persistent_clock(&timekeeping_suspend_time);
 
 	write_seqlock_irqsave(&xtime_lock, flags);
-	clocksource_forward_now();
+	timekeeping_forward_now();
 	timekeeping_suspended = 1;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -404,7 +640,7 @@ device_initcall(timekeeping_init_device);
  * If the error is already larger, we look ahead even further
  * to compensate for late or lost adjustments.
  */
-static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
+static __always_inline int timekeeping_bigadjust(s64 error, s64 *interval,
 						 s64 *offset)
 {
 	s64 tick_error, i;
@@ -420,7 +656,7 @@ static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
 	 * here.  This is tuned so that an error of about 1 msec is adjusted
 	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
 	 */
-	error2 = clock->error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
+	error2 = timekeeper.ntp_error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
 	error2 = abs(error2);
 	for (look_ahead = 0; error2 > 0; look_ahead++)
 		error2 >>= 2;
@@ -429,8 +665,8 @@ static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = tick_length >> (NTP_SCALE_SHIFT - clock->shift + 1);
-	tick_error -= clock->xtime_interval >> 1;
+	tick_error = tick_length >> (timekeeper.ntp_error_shift + 1);
+	tick_error -= timekeeper.xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
 	/* Finally calculate the adjustment shift value.  */
@@ -455,18 +691,18 @@ static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
  * this is optimized for the most common adjustments of -1,0,1,
  * for other values we can do a bit more work.
  */
-static void clocksource_adjust(s64 offset)
+static void timekeeping_adjust(s64 offset)
 {
-	s64 error, interval = clock->cycle_interval;
+	s64 error, interval = timekeeper.cycle_interval;
 	int adj;
 
-	error = clock->error >> (NTP_SCALE_SHIFT - clock->shift - 1);
+	error = timekeeper.ntp_error >> (timekeeper.ntp_error_shift - 1);
 	if (error > interval) {
 		error >>= 2;
 		if (likely(error <= interval))
 			adj = 1;
 		else
-			adj = clocksource_bigadjust(error, &interval, &offset);
+			adj = timekeeping_bigadjust(error, &interval, &offset);
 	} else if (error < -interval) {
 		error >>= 2;
 		if (likely(error >= -interval)) {
@@ -474,15 +710,15 @@ static void clocksource_adjust(s64 offset)
 			interval = -interval;
 			offset = -offset;
 		} else
-			adj = clocksource_bigadjust(error, &interval, &offset);
+			adj = timekeeping_bigadjust(error, &interval, &offset);
 	} else
 		return;
 
-	clock->mult += adj;
-	clock->xtime_interval += interval;
-	clock->xtime_nsec -= offset;
-	clock->error -= (interval - offset) <<
-			(NTP_SCALE_SHIFT - clock->shift);
+	timekeeper.mult += adj;
+	timekeeper.xtime_interval += interval;
+	timekeeper.xtime_nsec -= offset;
+	timekeeper.ntp_error -= (interval - offset) <<
+				timekeeper.ntp_error_shift;
 }
 
 /**
@@ -492,53 +728,59 @@ static void clocksource_adjust(s64 offset)
  */
 void update_wall_time(void)
 {
+	struct clocksource *clock;
 	cycle_t offset;
+	u64 nsecs;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
 		return;
 
+	clock = timekeeper.clock;
 #ifdef CONFIG_GENERIC_TIME
-	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
+	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #else
-	offset = clock->cycle_interval;
+	offset = timekeeper.cycle_interval;
 #endif
-	clock->xtime_nsec = (s64)xtime.tv_nsec << clock->shift;
+	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
 
 	/* normally this loop will run just once, however in the
 	 * case of lost or late ticks, it will accumulate correctly.
 	 */
-	while (offset >= clock->cycle_interval) {
+	while (offset >= timekeeper.cycle_interval) {
+		u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
+
 		/* accumulate one interval */
-		offset -= clock->cycle_interval;
-		clock->cycle_last += clock->cycle_interval;
+		offset -= timekeeper.cycle_interval;
+		clock->cycle_last += timekeeper.cycle_interval;
 
-		clock->xtime_nsec += clock->xtime_interval;
-		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
-			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
+		timekeeper.xtime_nsec += timekeeper.xtime_interval;
+		if (timekeeper.xtime_nsec >= nsecps) {
+			timekeeper.xtime_nsec -= nsecps;
 			xtime.tv_sec++;
 			second_overflow();
 		}
 
-		clock->raw_time.tv_nsec += clock->raw_interval;
-		if (clock->raw_time.tv_nsec >= NSEC_PER_SEC) {
-			clock->raw_time.tv_nsec -= NSEC_PER_SEC;
-			clock->raw_time.tv_sec++;
+		raw_time.tv_nsec += timekeeper.raw_interval;
+		if (raw_time.tv_nsec >= NSEC_PER_SEC) {
+			raw_time.tv_nsec -= NSEC_PER_SEC;
+			raw_time.tv_sec++;
 		}
 
 		/* accumulate error between NTP and clock interval */
-		clock->error += tick_length;
-		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
+		timekeeper.ntp_error += tick_length;
+		timekeeper.ntp_error -= timekeeper.xtime_interval <<
+					timekeeper.ntp_error_shift;
 	}
 
 	/* correct the clock when NTP error is too big */
-	clocksource_adjust(offset);
+	timekeeping_adjust(offset);
 
 	/*
 	 * Since in the loop above, we accumulate any amount of time
 	 * in xtime_nsec over a second into xtime.tv_sec, its possible for
 	 * xtime_nsec to be fairly small after the loop. Further, if we're
-	 * slightly speeding the clocksource up in clocksource_adjust(),
+	 * slightly speeding the clocksource up in timekeeping_adjust(),
 	 * its possible the required corrective factor to xtime_nsec could
 	 * cause it to underflow.
 	 *
@@ -550,24 +792,25 @@ void update_wall_time(void)
 	 * We'll correct this error next time through this function, when
 	 * xtime_nsec is not as small.
 	 */
-	if (unlikely((s64)clock->xtime_nsec < 0)) {
-		s64 neg = -(s64)clock->xtime_nsec;
-		clock->xtime_nsec = 0;
-		clock->error += neg << (NTP_SCALE_SHIFT - clock->shift);
+	if (unlikely((s64)timekeeper.xtime_nsec < 0)) {
+		s64 neg = -(s64)timekeeper.xtime_nsec;
+		timekeeper.xtime_nsec = 0;
+		timekeeper.ntp_error += neg << timekeeper.ntp_error_shift;
 	}
 
 	/* store full nanoseconds into xtime after rounding it up and
 	 * add the remainder to the error difference.
 	 */
-	xtime.tv_nsec = ((s64)clock->xtime_nsec >> clock->shift) + 1;
-	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
-	clock->error += clock->xtime_nsec << (NTP_SCALE_SHIFT - clock->shift);
+	xtime.tv_nsec =	((s64) timekeeper.xtime_nsec >> timekeeper.shift) + 1;
+	timekeeper.xtime_nsec -= (s64) xtime.tv_nsec << timekeeper.shift;
+	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
+				timekeeper.ntp_error_shift;
 
-	update_xtime_cache(cyc2ns(clock, offset));
+	nsecs = clocksource_cyc2ns(offset, timekeeper.mult, timekeeper.shift);
+	update_xtime_cache(nsecs);
 
 	/* check to see if there is a new clocksource to use */
-	change_clocksource();
-	update_vsyscall(&xtime, clock);
+	update_vsyscall(&xtime, timekeeper.clock);
 }
 
 /**
@@ -583,9 +826,12 @@ void update_wall_time(void)
  */
 void getboottime(struct timespec *ts)
 {
-	set_normalized_timespec(ts,
-		- (wall_to_monotonic.tv_sec + total_sleep_time),
-		- wall_to_monotonic.tv_nsec);
+	struct timespec boottime = {
+		.tv_sec = wall_to_monotonic.tv_sec + total_sleep_time.tv_sec,
+		.tv_nsec = wall_to_monotonic.tv_nsec + total_sleep_time.tv_nsec
+	};
+
+	set_normalized_timespec(ts, -boottime.tv_sec, -boottime.tv_nsec);
 }
 
 /**
@@ -594,7 +840,7 @@ void getboottime(struct timespec *ts)
  */
 void monotonic_to_bootbased(struct timespec *ts)
 {
-	ts->tv_sec += total_sleep_time;
+	*ts = timespec_add_safe(*ts, total_sleep_time);
 }
 
 unsigned long get_seconds(void)
@@ -603,6 +849,10 @@ unsigned long get_seconds(void)
 }
 EXPORT_SYMBOL(get_seconds);
 
+struct timespec __current_kernel_time(void)
+{
+	return xtime_cache;
+}
 
 struct timespec current_kernel_time(void)
 {
@@ -618,3 +868,20 @@ struct timespec current_kernel_time(void)
 	return now;
 }
 EXPORT_SYMBOL(current_kernel_time);
+
+struct timespec get_monotonic_coarse(void)
+{
+	struct timespec now, mono;
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		now = xtime_cache;
+		mono = wall_to_monotonic;
+	} while (read_seqretry(&xtime_lock, seq));
+
+	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
+				now.tv_nsec + mono.tv_nsec);
+	return now;
+}
diff --git a/kernel/timer.c b/kernel/timer.c
index a7f07d5..8e92be6 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -72,6 +72,7 @@ struct tvec_base {
 	spinlock_t lock;
 	struct timer_list *running_timer;
 	unsigned long timer_jiffies;
+	unsigned long next_timer;
 	struct tvec_root tv1;
 	struct tvec tv2;
 	struct tvec tv3;
@@ -622,6 +623,9 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	if (timer_pending(timer)) {
 		detach_timer(timer, 0);
+		if (timer->expires == base->next_timer &&
+		    !tbase_get_deferrable(timer->base))
+			base->next_timer = base->timer_jiffies;
 		ret = 1;
 	} else {
 		if (pending_only)
@@ -663,6 +667,9 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 	}
 
 	timer->expires = expires;
+	if (time_before(timer->expires, base->next_timer) &&
+	    !tbase_get_deferrable(timer->base))
+		base->next_timer = timer->expires;
 	internal_add_timer(base, timer);
 
 out_unlock:
@@ -781,6 +788,9 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
 	debug_timer_activate(timer);
+	if (time_before(timer->expires, base->next_timer) &&
+	    !tbase_get_deferrable(timer->base))
+		base->next_timer = timer->expires;
 	internal_add_timer(base, timer);
 	/*
 	 * Check whether the other CPU is idle and needs to be
@@ -817,6 +827,9 @@ int del_timer(struct timer_list *timer)
 		base = lock_timer_base(timer, &flags);
 		if (timer_pending(timer)) {
 			detach_timer(timer, 1);
+			if (timer->expires == base->next_timer &&
+			    !tbase_get_deferrable(timer->base))
+				base->next_timer = base->timer_jiffies;
 			ret = 1;
 		}
 		spin_unlock_irqrestore(&base->lock, flags);
@@ -850,6 +863,9 @@ int try_to_del_timer_sync(struct timer_list *timer)
 	ret = 0;
 	if (timer_pending(timer)) {
 		detach_timer(timer, 1);
+		if (timer->expires == base->next_timer &&
+		    !tbase_get_deferrable(timer->base))
+			base->next_timer = base->timer_jiffies;
 		ret = 1;
 	}
 out:
@@ -1007,8 +1023,8 @@ static inline void __run_timers(struct tvec_base *base)
 #ifdef CONFIG_NO_HZ
 /*
  * Find out when the next timer event is due to happen. This
- * is used on S/390 to stop all activity when a cpus is idle.
- * This functions needs to be called disabled.
+ * is used on S/390 to stop all activity when a CPU is idle.
+ * This function needs to be called with interrupts disabled.
  */
 static unsigned long __next_timer_interrupt(struct tvec_base *base)
 {
@@ -1134,7 +1150,9 @@ unsigned long get_next_timer_interrupt(unsigned long now)
 	unsigned long expires;
 
 	spin_lock(&base->lock);
-	expires = __next_timer_interrupt(base);
+	if (time_before_eq(base->next_timer, base->timer_jiffies))
+		base->next_timer = __next_timer_interrupt(base);
+	expires = base->next_timer;
 	spin_unlock(&base->lock);
 
 	if (time_before_eq(expires, now))
@@ -1523,6 +1541,7 @@ static int __cpuinit init_timers_cpu(int cpu)
 		INIT_LIST_HEAD(base->tv1.vec + j);
 
 	base->timer_jiffies = jiffies;
+	base->next_timer = base->timer_jiffies;
 	return 0;
 }
 
@@ -1535,6 +1554,9 @@ static void migrate_timer_list(struct tvec_base *new_base, struct list_head *hea
 		timer = list_first_entry(head, struct timer_list, entry);
 		detach_timer(timer, 0);
 		timer_set_base(timer, new_base);
+		if (time_before(timer->expires, new_base->next_timer) &&
+		    !tbase_get_deferrable(timer->base))
+			new_base->next_timer = timer->expires;
 		internal_add_timer(new_base, timer);
 	}
 }

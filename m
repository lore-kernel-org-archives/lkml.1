Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbZHOJFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbZHOJFO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZHOJFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:05:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:55393 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbZHOJFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:05:01 -0400
Date: Sat, 15 Aug 2009 09:04:18 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, dwalker@fifo99.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: dwalker@fifo99.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090814134811.013873340@de.ibm.com>
References: <20090814134811.013873340@de.ibm.com>
Subject: [tip:timers/core] timekeeping: Increase granularity of read_persistent_clock()
Message-ID: <tip-d4f587c67fc39e0030ddd718675e252e208da4d7@git.kernel.org>
Git-Commit-ID: d4f587c67fc39e0030ddd718675e252e208da4d7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 09:04:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4f587c67fc39e0030ddd718675e252e208da4d7
Gitweb:     http://git.kernel.org/tip/d4f587c67fc39e0030ddd718675e252e208da4d7
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Fri, 14 Aug 2009 15:47:31 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 15 Aug 2009 10:55:46 +0200

timekeeping: Increase granularity of read_persistent_clock()

The persistent clock of some architectures (e.g. s390) have a
better granularity than seconds. To reduce the delta between the
host clock and the guest clock in a virtualized system change the 
read_persistent_clock function to return a struct timespec.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
LKML-Reference: <20090814134811.013873340@de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 arch/m68knommu/kernel/time.c          |    5 ++-
 arch/mips/dec/time.c                  |    5 ++-
 arch/mips/lasat/ds1603.c              |    5 ++-
 arch/mips/lasat/sysctl.c              |    8 ++++-
 arch/mips/lemote/lm2e/setup.c         |    5 ++-
 arch/mips/mti-malta/malta-time.c      |    5 ++-
 arch/mips/pmc-sierra/yosemite/setup.c |    5 ++-
 arch/mips/sibyte/swarm/setup.c        |   15 +++++++--
 arch/mips/sni/time.c                  |    5 ++-
 arch/powerpc/kernel/time.c            |    7 ++--
 arch/s390/kernel/time.c               |   22 ++-----------
 arch/sh/kernel/time.c                 |    6 +--
 arch/x86/kernel/rtc.c                 |    5 ++-
 arch/xtensa/kernel/time.c             |    5 +--
 include/linux/time.h                  |    2 +-
 kernel/time/timekeeping.c             |   52 ++++++++++++++++++--------------
 16 files changed, 83 insertions(+), 74 deletions(-)

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
index eae4511..ad63f30 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -769,7 +769,7 @@ int update_persistent_clock(struct timespec now)
 	return ppc_md.set_rtc_time(&tm);
 }
 
-unsigned long read_persistent_clock(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	struct rtc_time tm;
 	static int first = 1;
@@ -787,8 +787,9 @@ unsigned long read_persistent_clock(void)
 	if (!ppc_md.get_rtc_time)
 		return 0;
 	ppc_md.get_rtc_time(&tm);
-	return mktime(tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
-		      tm.tm_hour, tm.tm_min, tm.tm_sec);
+	ts->tv_sec = mktime(tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
+			    tm.tm_hour, tm.tm_min, tm.tm_sec);
+	ts->tv_nsec = 0;
 }
 
 /* clocksource code */
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index e76c2e7..a94ec48 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -182,12 +182,9 @@ static void timing_alert_interrupt(__u16 code)
 static void etr_reset(void);
 static void stp_reset(void);
 
-unsigned long read_persistent_clock(void)
+void read_persistent_clock(struct timespec *ts)
 {
-	struct timespec ts;
-
-	tod_to_timeval(get_clock() - TOD_UNIX_EPOCH, &ts);
-	return ts.tv_sec;
+	tod_to_timeval(get_clock() - TOD_UNIX_EPOCH, ts);
 }
 
 static cycle_t read_tod_clock(struct clocksource *cs)
@@ -248,7 +245,6 @@ void __init time_init(void)
 {
 	struct timespec ts;
 	unsigned long flags;
-	cycle_t now;
 
 	/* Reset time synchronization interfaces. */
 	etr_reset();
@@ -266,20 +262,10 @@ void __init time_init(void)
 		panic("Could not register TOD clock source");
 
 	/*
-	 * The TOD clock is an accurate clock. The xtime should be
-	 * initialized in a way that the difference between TOD and
-	 * xtime is reasonably small. Too bad that timekeeping_init
-	 * sets xtime.tv_nsec to zero. In addition the clock source
-	 * change from the jiffies clock source to the TOD clock
-	 * source add another error of up to 1/HZ second. The same
-	 * function sets wall_to_monotonic to a value that is too
-	 * small for /proc/uptime to be accurate.
-	 * Reset xtime and wall_to_monotonic to sane values.
+	 * Reset wall_to_monotonic to the initial timestamp created
+	 * in head.S to get a precise value in /proc/uptime.
 	 */
 	write_seqlock_irqsave(&xtime_lock, flags);
-	now = get_clock();
-	tod_to_timeval(now - TOD_UNIX_EPOCH, &xtime);
-	clocksource_tod.cycle_last = now;
 	tod_to_timeval(sched_clock_base_cc - TOD_UNIX_EPOCH, &ts);
 	set_normalized_timespec(&wall_to_monotonic, -ts.tv_sec, -ts.tv_nsec);
 	write_sequnlock_irqrestore(&xtime_lock, flags);
diff --git a/arch/sh/kernel/time.c b/arch/sh/kernel/time.c
index 9b352a1..3f4706a 100644
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
+	rtc_sh_get_time(&ts);
 }
 
 int update_persistent_clock(struct timespec now)
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
 
diff --git a/include/linux/time.h b/include/linux/time.h
index e7c8445..53a3216 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -101,7 +101,7 @@ extern struct timespec xtime;
 extern struct timespec wall_to_monotonic;
 extern seqlock_t xtime_lock;
 
-extern unsigned long read_persistent_clock(void);
+extern void read_persistent_clock(struct timespec *ts);
 extern int update_persistent_clock(struct timespec now);
 extern int no_sync_cmos_clock __read_mostly;
 void timekeeping_init(void);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 41579e7..f1a21ce 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -154,7 +154,7 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
  */
 struct timespec xtime __attribute__ ((aligned (16)));
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
-static unsigned long total_sleep_time;		/* seconds */
+static struct timespec total_sleep_time;
 
 /*
  * The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock.
@@ -487,17 +487,18 @@ int timekeeping_valid_for_hres(void)
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
 }
 
 /*
@@ -507,7 +508,9 @@ void __init timekeeping_init(void)
 {
 	struct clocksource *clock;
 	unsigned long flags;
-	unsigned long sec = read_persistent_clock();
+	struct timespec now;
+
+	read_persistent_clock(&now);
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
@@ -518,19 +521,20 @@ void __init timekeeping_init(void)
 		clock->enable(clock);
 	timekeeper_setup_internals(clock);
 
-	xtime.tv_sec = sec;
-	xtime.tv_nsec = 0;
+	xtime.tv_sec = now.tv_sec;
+	xtime.tv_nsec = now.tv_nsec;
 	raw_time.tv_sec = 0;
 	raw_time.tv_nsec = 0;
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
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
@@ -543,18 +547,19 @@ static unsigned long timekeeping_suspend_time;
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
@@ -577,7 +582,7 @@ static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
 {
 	unsigned long flags;
 
-	timekeeping_suspend_time = read_persistent_clock();
+	read_persistent_clock(&timekeeping_suspend_time);
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 	timekeeping_forward_now();
@@ -801,9 +806,10 @@ void update_wall_time(void)
  */
 void getboottime(struct timespec *ts)
 {
-	set_normalized_timespec(ts,
-		- (wall_to_monotonic.tv_sec + total_sleep_time),
-		- wall_to_monotonic.tv_nsec);
+	struct timespec boottime;
+
+	boottime = timespec_add_safe(wall_to_monotonic, total_sleep_time);
+	set_normalized_timespec(ts, -boottime.tv_sec, -boottime.tv_nsec);
 }
 
 /**
@@ -812,7 +818,7 @@ void getboottime(struct timespec *ts)
  */
 void monotonic_to_bootbased(struct timespec *ts)
 {
-	ts->tv_sec += total_sleep_time;
+	*ts = timespec_add_safe(*ts, total_sleep_time);
 }
 
 unsigned long get_seconds(void)

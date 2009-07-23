Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbZGWA3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbZGWA3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 20:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZGWA3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 20:29:11 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38849 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZGWA3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 20:29:09 -0400
Subject: Re: [RFC][patch 1/5] move clock source related code to
 clocksource.c
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1248284733.18789.32.camel@work-vm>
References: <20090721191745.788551122@de.ibm.com>
	 <20090721192057.177653956@de.ibm.com>	<1248205851.14209.777.camel@desktop>
	 <1248213607.3298.107.camel@localhost>  <20090722092519.772b238b@skybase>
	 <1248284733.18789.32.camel@work-vm>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 17:28:20 -0700
Message-Id: <1248308900.7592.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 10:45 -0700, john stultz wrote:
> On Wed, 2009-07-22 at 09:25 +0200, Martin Schwidefsky wrote:
> > On Tue, 21 Jul 2009 15:00:07 -0700
> > john stultz <johnstul@us.ibm.com> wrote:
> > > Unfortunately, many timekeeping values got stuffed into the struct
> > > clocksource. I've had plans to try to clean this up and utilize Patrick
> > > Ohly's simpler clockcounter struct as a basis for a clocksource, nesting
> > > the structures somewhat to look something like:
> > > 
> > > 
> > > /* minimal structure only giving hardware info and access methods */
> > > struct cyclecounter {
> > > 	char *name;
> > > 	cycle_t (*read)(const struct cyclecounter *cc);
> > > 	cycle_t (*vread)(const struct cyclecounter *cc);
> > > 	cycle_t mask;
> > > 	u32 mult;
> > > 	u32 shift;
> > > };
> > > 
> > > /* more complicated structure holding timekeeping values */
> > > struct timesource {
> > > 	struct cyclecounter counter;
> > > 	u32	corrected_mult;
> > > 	cycle_t cycle_interval;
> > > 	u64	xtime_interval;
> > > 	u32	raw_interval;
> > > 	cycle_t cycle_last;
> > > 	u64	xtime_nsec;
> > > 	s64	error; /* probably should be ntp_error */
> > > 	...
> > > }
> > > 
> > > However such a change would be quite a bit of churn to much of the
> > > timekeeping code, and to only marginal benefit. So I've put it off.
> > 
[snip]
> If I can find some cycles today, I'll try to take a rough swing at some
> of the cleanup I mentioned earlier. Probably won't build, but will maybe
> give you an idea of the direction I'm thinking about, and then you can
> let me know where you feel its still too complex. Maybe then we can meet
> in the middle?

Hey Martin,
	So here's a really quick swipe at breaking apart the clocksource struct
into a clocksource only portion and a timekeeping portion.

Caveats:
1) This doesn't completely build. The core bits do, but there's still a
few left-over issues (see following caveats). Its just here to give you
an idea of what I'm thinking about. I'd of course break it up into more
manageable chunks before submitting it.

2) Structure names aren't too great right now. Not sure timeclock is
what I want to use, probably system_time or something. Will find/replace
before the next revision is sent out.

3) I still need to unify the clocksource and cyclecounter structures, as
they're basically redundant now.

4) I still need to fix the update_vsyscall code (shouldn't be hard, I
didn't want to run through arch code yet).

5) The TSC clocksource uses cycles_last to avoid very slight skew issues
(that otherwise would not be noticed). Not sure how to fix that if we're
pulling cycles_last (which is purely timekeeping state) out of the
clocksource. Will have to think of something.


Other cleanups still out there in the distant future:
1) Once all arches are converted to GENERIC_TIME, we can remove the
ifdefs, and cleanup a lot of the more complicated xtime struct
manipulation. It will cleanup update_wall_time() nicely.

2) I have a logarithmic accumulation patch to update_wall_time that will
remove the need for xtime_cache to be managed and updated. Just have to
spend some additional time making sure its bugfree.

3) Once all arches are converted to using read_persistent_clock(), then
the arch specific time initialization can be dropped. Removing the
majority of direct xtime structure accesses.

4) Then once the remaining direct wall_to_monotonic and xtime accessors
are moved to timekeeping.c we can make those both static and embed them
into the core timekeeping structure.


But let me know if this patch doesn't achieve most of the cleanup you
wanted to see.

thanks
-john


DOES NOT BUILD! FOR REVIEW PURPOSES ONLY!
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index c56457c..3ad14b5 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -154,8 +154,6 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
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
@@ -181,19 +178,6 @@ struct clocksource {
 #define CLKSRC_FSYS_MMIO_SET(mmio, addr)      do { } while (0)
 #endif
 
-	/* timekeeping specific data, ignore */
-	cycle_t cycle_interval;
-	u64	xtime_interval;
-	u32	raw_interval;
-	/*
-	 * Second part is written at each timer interrupt
-	 * Keep it in a different cache line to dirty no
-	 * more than one cache line.
-	 */
-	cycle_t cycle_last ____cacheline_aligned_in_smp;
-	u64 xtime_nsec;
-	s64 error;
-	struct timespec raw_time;
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
@@ -202,7 +186,6 @@ struct clocksource {
 #endif
 };
 
-extern struct clocksource *clock;	/* current clocksource */
 
 /*
  * Clock source flags bits::
@@ -267,99 +250,21 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
 	return (u32)tmp;
 }
 
-/**
- * clocksource_read: - Access the clocksource's current cycle value
- * @cs:		pointer to clocksource being read
- *
- * Uses the clocksource to return the current cycle_t value
- */
-static inline cycle_t clocksource_read(struct clocksource *cs)
-{
-	return cs->read(cs);
-}
 
 /**
- * clocksource_enable: - enable clocksource
- * @cs:		pointer to clocksource
+ * clocksource_cyc2ns - converts clocksource cycles to nanoseconds
  *
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
-	/* save mult_orig on enable */
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
-	if (cs->disable)
-		cs->disable(cs);
-}
-
-/**
- * cyc2ns - converts clocksource cycles to nanoseconds
- * @cs:		Pointer to clocksource
- * @cycles:	Cycles
- *
- * Uses the clocksource and ntp ajdustment to convert cycle_ts to nanoseconds.
+ * Converts cycles to nanoseconds, using the given mult and shift.
  *
  * XXX - This could use some mult_lxl_ll() asm optimization
  */
-static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
+static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 {
 	u64 ret = (u64)cycles;
-	ret = (ret * cs->mult) >> cs->shift;
+	ret = (ret * mult) >> shift;
 	return ret;
 }
 
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
-{
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
-}
-
 
 /* used to install a new clocksource */
 extern int clocksource_register(struct clocksource*);
diff --git a/include/linux/time.h b/include/linux/time.h
index ea16c1a..65e94a6 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -147,6 +147,8 @@ extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
 extern void update_wall_time(void);
 extern void update_xtime_cache(u64 nsec);
+extern void timekeeping_leap_insert(int leapsecond);
+
 
 struct tms;
 extern void do_sys_times(struct tms *);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 7466cb8..13db0a8 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -182,7 +182,8 @@ static void clocksource_watchdog(unsigned long data)
 	resumed = test_and_clear_bit(0, &watchdog_resumed);
 
 	wdnow = watchdog->read(watchdog);
-	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
+	wd_nsec = clocksource_cyc2ns((wdnow - watchdog_last) & watchdog->mask,
+			watchdog->mult, watchdog->shift);
 	watchdog_last = wdnow;
 
 	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
@@ -209,7 +210,7 @@ static void clocksource_watchdog(unsigned long data)
 			cs->flags |= CLOCK_SOURCE_WATCHDOG;
 			cs->wd_last = csnow;
 		} else {
-			cs_nsec = cyc2ns(cs, (csnow - cs->wd_last) & cs->mask);
+			cs_nsec = clocksource_cyc2ns((csnow - cs->wd_last) & cs->mask, cs->mult, cs->shift);
 			cs->wd_last = csnow;
 			/* Check the delta. Might remove from the list ! */
 			clocksource_ratewd(cs, cs_nsec - wd_nsec);
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index c3f6c30..e26185a 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -61,7 +61,6 @@ struct clocksource clocksource_jiffies = {
 	.read		= jiffies_read,
 	.mask		= 0xffffffff, /*32bits*/
 	.mult		= NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
-	.mult_orig	= NSEC_PER_JIFFY << JIFFIES_SHIFT,
 	.shift		= JIFFIES_SHIFT,
 };
 
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 7fc6437..5fabaf3 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -142,11 +142,11 @@ static void ntp_update_offset(long offset)
 	 * Select how the frequency is to be controlled
 	 * and in which mode (PLL or FLL).
 	 */
-	secs = xtime.tv_sec - time_reftime;
+	secs = get_seconds() - time_reftime;
 	if (unlikely(time_status & STA_FREQHOLD))
 		secs = 0;
 
-	time_reftime = xtime.tv_sec;
+	time_reftime = get_seconds();
 
 	offset64    = offset;
 	freq_adj    = (offset64 * secs) <<
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
@@ -219,8 +217,6 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 			time_state = TIME_OK;
 		break;
 	}
-	update_vsyscall(&xtime, clock);
-
 	write_sequnlock(&xtime_lock);
 
 	return res;
@@ -371,7 +367,7 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 	 * reference time to current time.
 	 */
 	if (!(time_status & STA_PLL) && (txc->status & STA_PLL))
-		time_reftime = xtime.tv_sec;
+		time_reftime = get_seconds();
 
 	/* only set allowed bits */
 	time_status &= STA_RONLY;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e8c77d9..f95f9e3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -44,47 +44,172 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
  */
 struct timespec xtime __attribute__ ((aligned (16)));
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
-static unsigned long total_sleep_time;		/* seconds */
 
-/* flag for if timekeeping is suspended */
-int __read_mostly timekeeping_suspended;
 
-static struct timespec xtime_cache __attribute__ ((aligned (16)));
+/* background stuff to document:
+ *  This code is a little extra complicated as we deal with things 
+ *  in lots of similar but different units. We have to keep these
+ *  different units as we try to do each step of managing time with 
+ *  the highest precision.
+ *
+ * cycles: these are simply counter cycles
+ * nsecs:  these are simply nanoseconds
+ * Clock shifted nsecs: These are high precision nanoseconds,
+ *   shifted by struct clocksource.shift.
+ * NTP shifted nsecs: These are high precision nanoseconds, 
+ *   shifted by NTP_SHIFT_SCALE
+ * 
+ * One might ask, why not use one type of shifted nanosecond?
+ * The reason is, clock shifted nanoseconds are carefully managed
+ * so we don't overflow 64bits. We need higher then nanosecond 
+ * precision, but NTP_SHIFT SCALE is too large and we might overflow.
+ * However, we want to keep the extra fine precision for error accounting
+ * that NTP_SHIFT_SCALE gives us, so we convert from clock shifted nsecs
+ * to NTP shifted nsecs when its safe.
+ *
+ */ 
+
+
+/* This structure stores all of the information used to generate or
+ * manage time.
+ */
+static struct timeclock {
+	struct clocksource * source; /* current clocksource */
+	u32 mult; /* ntp adjusted mult */
+
+	cycle_t cycle_interval;	/* interval in cycles */
+	u64	xtime_interval; /* interval in clock shifted nsecs */
+	u32	raw_interval;	/* raw interval in nsecs */
+
+	/*
+	 * The following is written at each timer interrupt
+	 * Keep it in a different cache line to dirty no
+	 * more than one cache line.
+	 */
+	cycle_t cycle_last ____cacheline_aligned_in_smp;
+	u64 xtime_nsec; /* clock shifted nsecs */
+	s64 error; /* ntp shifted nsecs */
+	struct timespec raw_time;
+	struct timespec xtime_cache;
+	unsigned long total_sleep_time;		/* seconds */
+	int timekeeping_suspended;
+
+	/* XXX - TODO
+	 *  o pull in the xtime, wall_to_monotoinc, xtime_lock
+	 */
+} clock;
+
+
+/* timeclock helper functions */
+static inline cycle_t timeclock_read(void)
+{
+	return clock.source->read(clock.source);
+}
+
+static inline u64 timeclock_cyc2ns(cycle_t cycles)
+{
+	/* noraml cyc2ns, use the NTP adjusted mult */
+	return clocksource_cyc2ns(cycles, clock.mult, clock.source->shift);
+}
+
+static inline u64 timeclock_cyc2ns_raw(cycle_t cycles)
+{
+	/* raw cyc2ns, use the unadjusted original clocksource mult */
+	return clocksource_cyc2ns(cycles, clock.source->mult,
+				 clock.source->shift);
+}
+
+static inline u64 timeclock_getoffset(cycle_t now)
+{
+	cycle_t cycle_delta = (now - clock.cycle_last)&clock.source->mask;
+	s64 nsec = timeclock_cyc2ns(cycle_delta);
+	nsec += arch_gettimeoffset(); 
+	return nsec;
+}
+
+static inline u64 timeclock_getoffset_raw(cycle_t now)
+{
+	cycle_t cycle_delta = (now - clock.cycle_last)&clock.source->mask;
+	s64 nsec = timeclock_cyc2ns_raw(cycle_delta);
+	nsec += arch_gettimeoffset(); 
+	return nsec;
+}
+
+static inline void timeclock_calculate_interval(unsigned long length_nsec)
+{
+	u64 tmp;
+
+	/* Do the ns -> cycle conversion first, using original mult */
+	tmp = length_nsec;
+	tmp <<= clock.source->shift;
+	tmp += clock.source->mult/2;
+	do_div(tmp, clock.source->mult);
+
+	clock.cycle_interval = (cycle_t)tmp;
+	if (clock.cycle_interval == 0)
+		clock.cycle_interval = 1;
+
+	/* Go back from cycles -> shifted ns, this time use ntp adjused mult */
+	clock.xtime_interval = (u64)clock.cycle_interval * clock.mult;
+	clock.raw_interval = timeclock_cyc2ns_raw(clock.cycle_interval);
+}
+
+static inline long CLOCK2NTP_SHIFT(void)
+{
+	return NTP_SCALE_SHIFT - clock.source->shift;	
+}
+
+
+/* must hold xtime_lock */
 void update_xtime_cache(u64 nsec)
 {
-	xtime_cache = xtime;
-	timespec_add_ns(&xtime_cache, nsec);
+	clock.xtime_cache = xtime;
+	timespec_add_ns(&clock.xtime_cache, nsec);
+}
+
+/* must hold xtime_lock */
+void timekeeping_leap_insert(int leapsecond)
+{
+	xtime.tv_sec += leapsecond;
+	wall_to_monotonic.tv_sec -= leapsecond;
+	update_vsyscall(&xtime, clock.source);
 }
 
-struct clocksource *clock;
 
+static inline void xtime_nsec_add(s64 snsec)
+{
+	clock.xtime_nsec += snsec;
+	if (clock.xtime_nsec >= 
+			(u64)NSEC_PER_SEC << clock.source->shift) {
+		clock.xtime_nsec -=
+			(u64)NSEC_PER_SEC << clock.source->shift;
+		xtime.tv_sec++;
+		second_overflow();
+	}
+}
 
 #ifdef CONFIG_GENERIC_TIME
 /**
- * clocksource_forward_now - update clock to the current time
+ * timeclock_forward_now - update clock to the current time
  *
  * Forward the current clock to update its state since the last call to
  * update_wall_time(). This is useful before significant clock changes,
  * as it avoids having to deal with this time offset explicitly.
  */
-static void clocksource_forward_now(void)
+static void timeclock_forward_now(void)
 {
-	cycle_t cycle_now, cycle_delta;
+	cycle_t cycle_now;
 	s64 nsec;
 
-	cycle_now = clocksource_read(clock);
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-	clock->cycle_last = cycle_now;
-
-	nsec = cyc2ns(clock, cycle_delta);
-
-	/* If arch requires, add in gettimeoffset() */
-	nsec += arch_gettimeoffset();
+	cycle_now = timeclock_read();
 
+	nsec = timeclock_getoffset(cycle_now);
 	timespec_add_ns(&xtime, nsec);
 
-	nsec = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
-	clock->raw_time.tv_nsec += nsec;
+	nsec = timeclock_getoffset_raw(cycle_now);
+	timespec_add_ns(&clock.raw_time, nsec);
+
+	clock.cycle_last = cycle_now;
 }
 
 /**
@@ -95,28 +220,15 @@ static void clocksource_forward_now(void)
  */
 void getnstimeofday(struct timespec *ts)
 {
-	cycle_t cycle_now, cycle_delta;
 	unsigned long seq;
 	s64 nsecs;
 
-	WARN_ON(timekeeping_suspended);
-
+	WARN_ON(clock.timekeeping_suspended);
 	do {
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
-
-		/* If arch requires, add in gettimeoffset() */
-		nsecs += arch_gettimeoffset();
+		nsecs = timeclock_getoffset(timeclock_read());
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -157,7 +269,7 @@ int do_settimeofday(struct timespec *tv)
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
-	clocksource_forward_now();
+	timeclock_forward_now();
 
 	ts_delta.tv_sec = tv->tv_sec - xtime.tv_sec;
 	ts_delta.tv_nsec = tv->tv_nsec - xtime.tv_nsec;
@@ -167,10 +279,10 @@ int do_settimeofday(struct timespec *tv)
 
 	update_xtime_cache(0);
 
-	clock->error = 0;
+	clock.error = 0;
 	ntp_clear();
 
-	update_vsyscall(&xtime, clock);
+	update_vsyscall(&xtime, clock.source);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -193,36 +305,30 @@ static void change_clocksource(void)
 
 	new = clocksource_get_next();
 
-	if (clock == new)
+	if (clock.source == new)
 		return;
 
-	clocksource_forward_now();
+	timeclock_forward_now();
 
-	if (clocksource_enable(new))
+	if (new->enable(new))
 		return;
 
-	new->raw_time = clock->raw_time;
-	old = clock;
-	clock = new;
-	clocksource_disable(old);
+	old = clock.source;
+	clock.source = new;
+	old->disable(old);
 
-	clock->cycle_last = 0;
-	clock->cycle_last = clocksource_read(clock);
-	clock->error = 0;
-	clock->xtime_nsec = 0;
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
+	/* XXX - ugh.. TSC clocksource uses cycle_last... sort this out*/
+	clock.cycle_last = 0; 
+	clock.cycle_last = timeclock_read();
+	clock.mult = clock.source->mult;
+	clock.error = 0;
+	clock.xtime_nsec = 0;
+	timeclock_calculate_interval(NTP_INTERVAL_LENGTH);
 
 	tick_clock_notify();
-
-	/*
-	 * We're holding xtime lock and waking up klogd would deadlock
-	 * us on enqueue.  So no printing!
-	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
-	       clock->name);
-	 */
 }
 #else
-static inline void clocksource_forward_now(void) { }
+static inline void timeclock_forward_now(void) { }
 static inline void change_clocksource(void) { }
 #endif
 
@@ -236,21 +342,12 @@ void getrawmonotonic(struct timespec *ts)
 {
 	unsigned long seq;
 	s64 nsecs;
-	cycle_t cycle_now, cycle_delta;
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
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
+		nsecs = timeclock_getoffset_raw(timeclock_read());
+		*ts = clock.raw_time;
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -260,6 +357,55 @@ EXPORT_SYMBOL(getrawmonotonic);
 
 
 /**
+ * getboottime - Return the real time of system boot.
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the time of day in a timespec.
+ *
+ * This is based on the wall_to_monotonic offset and the total suspend
+ * time. Calls to settimeofday will affect the value returned (which
+ * basically means that however wrong your real time clock is at boot time,
+ * you get the right time here).
+ */
+void getboottime(struct timespec *ts)
+{
+	set_normalized_timespec(ts,
+		- (wall_to_monotonic.tv_sec + clock.total_sleep_time),
+		- wall_to_monotonic.tv_nsec);
+}
+
+/**
+ * monotonic_to_bootbased - Convert the monotonic time to boot based.
+ * @ts:		pointer to the timespec to be converted
+ */
+void monotonic_to_bootbased(struct timespec *ts)
+{
+	ts->tv_sec += clock.total_sleep_time;
+}
+
+unsigned long get_seconds(void)
+{
+	return clock.xtime_cache.tv_sec;
+}
+EXPORT_SYMBOL(get_seconds);
+
+
+struct timespec current_kernel_time(void)
+{
+	struct timespec now;
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		now = clock.xtime_cache;
+	} while (read_seqretry(&xtime_lock, seq));
+
+	return now;
+}
+EXPORT_SYMBOL(current_kernel_time);
+
+/**
  * timekeeping_valid_for_hres - Check if timekeeping is suitable for hres
  */
 int timekeeping_valid_for_hres(void)
@@ -270,7 +416,7 @@ int timekeeping_valid_for_hres(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		ret = clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
+		ret = clock.source->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -303,17 +449,18 @@ void __init timekeeping_init(void)
 
 	ntp_init();
 
-	clock = clocksource_get_next();
-	clocksource_enable(clock);
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-	clock->cycle_last = clocksource_read(clock);
+	clock.source = clocksource_get_next();
+	clock.source->enable(clock.source);
+	timeclock_calculate_interval(NTP_INTERVAL_LENGTH);
+	clock.mult = clock.source->mult;
+	clock.cycle_last = timeclock_read();
 
 	xtime.tv_sec = sec;
 	xtime.tv_nsec = 0;
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
 	update_xtime_cache(0);
-	total_sleep_time = 0;
+	clock.total_sleep_time = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
@@ -342,14 +489,15 @@ static int timekeeping_resume(struct sys_device *dev)
 
 		xtime.tv_sec += sleep_length;
 		wall_to_monotonic.tv_sec -= sleep_length;
-		total_sleep_time += sleep_length;
+		clock.total_sleep_time += sleep_length;
 	}
 	update_xtime_cache(0);
 	/* re-base the last cycle value */
-	clock->cycle_last = 0;
-	clock->cycle_last = clocksource_read(clock);
-	clock->error = 0;
-	timekeeping_suspended = 0;
+	/* XXX - TSC bug here */
+	clock.cycle_last = 0;
+	clock.cycle_last = timeclock_read();
+	clock.error = 0;
+	clock.timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	touch_softlockup_watchdog();
@@ -369,8 +517,8 @@ static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
 	timekeeping_suspend_time = read_persistent_clock();
 
 	write_seqlock_irqsave(&xtime_lock, flags);
-	clocksource_forward_now();
-	timekeeping_suspended = 1;
+	timeclock_forward_now();
+	clock.timekeeping_suspended = 1;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
@@ -404,7 +552,7 @@ device_initcall(timekeeping_init_device);
  * If the error is already larger, we look ahead even further
  * to compensate for late or lost adjustments.
  */
-static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
+static __always_inline int timeclock_bigadjust(s64 error, s64 *interval,
 						 s64 *offset)
 {
 	s64 tick_error, i;
@@ -420,7 +568,7 @@ static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
 	 * here.  This is tuned so that an error of about 1 msec is adjusted
 	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
 	 */
-	error2 = clock->error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
+	error2 = clock.error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
 	error2 = abs(error2);
 	for (look_ahead = 0; error2 > 0; look_ahead++)
 		error2 >>= 2;
@@ -429,8 +577,8 @@ static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = tick_length >> (NTP_SCALE_SHIFT - clock->shift + 1);
-	tick_error -= clock->xtime_interval >> 1;
+	tick_error = tick_length >> (CLOCK2NTP_SHIFT() + 1);
+	tick_error -= clock.xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
 	/* Finally calculate the adjustment shift value.  */
@@ -455,18 +603,18 @@ static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
  * this is optimized for the most common adjustments of -1,0,1,
  * for other values we can do a bit more work.
  */
-static void clocksource_adjust(s64 offset)
+static void timeclock_adjust(s64 offset)
 {
-	s64 error, interval = clock->cycle_interval;
+	s64 error, interval = clock.cycle_interval;
 	int adj;
 
-	error = clock->error >> (NTP_SCALE_SHIFT - clock->shift - 1);
+	error = clock.error >> (CLOCK2NTP_SHIFT() - 1);
 	if (error > interval) {
 		error >>= 2;
 		if (likely(error <= interval))
 			adj = 1;
 		else
-			adj = clocksource_bigadjust(error, &interval, &offset);
+			adj = timeclock_bigadjust(error, &interval, &offset);
 	} else if (error < -interval) {
 		error >>= 2;
 		if (likely(error >= -interval)) {
@@ -474,15 +622,15 @@ static void clocksource_adjust(s64 offset)
 			interval = -interval;
 			offset = -offset;
 		} else
-			adj = clocksource_bigadjust(error, &interval, &offset);
+			adj = timeclock_bigadjust(error, &interval, &offset);
 	} else
 		return;
 
-	clock->mult += adj;
-	clock->xtime_interval += interval;
-	clock->xtime_nsec -= offset;
-	clock->error -= (interval - offset) <<
-			(NTP_SCALE_SHIFT - clock->shift);
+	clock.mult += adj;
+	clock.xtime_interval += interval;
+	clock.xtime_nsec -= offset;
+	clock.error -= (interval - offset) << CLOCK2NTP_SHIFT();
+
 }
 
 /**
@@ -495,44 +643,36 @@ void update_wall_time(void)
 	cycle_t offset;
 
 	/* Make sure we're fully resumed: */
-	if (unlikely(timekeeping_suspended))
+	if (unlikely(clock.timekeeping_suspended))
 		return;
 
 #ifdef CONFIG_GENERIC_TIME
-	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
+	offset = (timeclock_read() - clock.cycle_last) & clock.source->mask;
 #else
-	offset = clock->cycle_interval;
+	offset = clock.cycle_interval;
 #endif
-	clock->xtime_nsec = (s64)xtime.tv_nsec << clock->shift;
+	/* XXX the following line can be dropped when 
+	 * everyone is convertd GENERIC_TIME.
+	 */
+	clock.xtime_nsec = (s64)xtime.tv_nsec << clock.source->shift;
 
 	/* normally this loop will run just once, however in the
 	 * case of lost or late ticks, it will accumulate correctly.
 	 */
-	while (offset >= clock->cycle_interval) {
+	while (offset >= clock.cycle_interval) {
 		/* accumulate one interval */
-		offset -= clock->cycle_interval;
-		clock->cycle_last += clock->cycle_interval;
-
-		clock->xtime_nsec += clock->xtime_interval;
-		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
-			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
-			xtime.tv_sec++;
-			second_overflow();
-		}
-
-		clock->raw_time.tv_nsec += clock->raw_interval;
-		if (clock->raw_time.tv_nsec >= NSEC_PER_SEC) {
-			clock->raw_time.tv_nsec -= NSEC_PER_SEC;
-			clock->raw_time.tv_sec++;
-		}
+		offset -= clock.cycle_interval;
+		clock.cycle_last += clock.cycle_interval;
+		xtime_nsec_add(clock.xtime_interval);
+		timespec_add_ns(&clock.raw_time, clock.raw_interval);
 
 		/* accumulate error between NTP and clock interval */
-		clock->error += tick_length;
-		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
+		clock.error += tick_length;
+		clock.error -= clock.xtime_interval << CLOCK2NTP_SHIFT();
 	}
 
 	/* correct the clock when NTP error is too big */
-	clocksource_adjust(offset);
+	timeclock_adjust(offset);
 
 	/*
 	 * Since in the loop above, we accumulate any amount of time
@@ -549,72 +689,30 @@ void update_wall_time(void)
 	 *
 	 * We'll correct this error next time through this function, when
 	 * xtime_nsec is not as small.
+	 * 
+	 * XXX - once everyone is converted to GENERIC_TIME this
+	 * can be dropped an we'll handle negative values properly
 	 */
-	if (unlikely((s64)clock->xtime_nsec < 0)) {
-		s64 neg = -(s64)clock->xtime_nsec;
-		clock->xtime_nsec = 0;
-		clock->error += neg << (NTP_SCALE_SHIFT - clock->shift);
+	if (unlikely((s64)clock.xtime_nsec < 0)) {
+		s64 neg = -(s64)clock.xtime_nsec;
+		clock.xtime_nsec = 0;
+		clock.error += neg << CLOCK2NTP_SHIFT();
 	}
 
 	/* store full nanoseconds into xtime after rounding it up and
 	 * add the remainder to the error difference.
+	 *
+	 * XXX - once everyone is converted to GENERIC_TIME this
+	 * (the following three lines) can be dropped 
 	 */
-	xtime.tv_nsec = ((s64)clock->xtime_nsec >> clock->shift) + 1;
-	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
-	clock->error += clock->xtime_nsec << (NTP_SCALE_SHIFT - clock->shift);
+	xtime.tv_nsec = ((s64)clock.xtime_nsec >> clock.source->shift) + 1;
+	clock.xtime_nsec -= (s64)xtime.tv_nsec << clock.source->shift;
+	clock.error += clock.xtime_nsec << CLOCK2NTP_SHIFT();
 
-	update_xtime_cache(cyc2ns(clock, offset));
+	update_xtime_cache(timeclock_cyc2ns(offset));
 
 	/* check to see if there is a new clocksource to use */
 	change_clocksource();
-	update_vsyscall(&xtime, clock);
-}
-
-/**
- * getboottime - Return the real time of system boot.
- * @ts:		pointer to the timespec to be set
- *
- * Returns the time of day in a timespec.
- *
- * This is based on the wall_to_monotonic offset and the total suspend
- * time. Calls to settimeofday will affect the value returned (which
- * basically means that however wrong your real time clock is at boot time,
- * you get the right time here).
- */
-void getboottime(struct timespec *ts)
-{
-	set_normalized_timespec(ts,
-		- (wall_to_monotonic.tv_sec + total_sleep_time),
-		- wall_to_monotonic.tv_nsec);
+	update_vsyscall(&xtime, clock.source);
 }
 
-/**
- * monotonic_to_bootbased - Convert the monotonic time to boot based.
- * @ts:		pointer to the timespec to be converted
- */
-void monotonic_to_bootbased(struct timespec *ts)
-{
-	ts->tv_sec += total_sleep_time;
-}
-
-unsigned long get_seconds(void)
-{
-	return xtime_cache.tv_sec;
-}
-EXPORT_SYMBOL(get_seconds);
-
-
-struct timespec current_kernel_time(void)
-{
-	struct timespec now;
-	unsigned long seq;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-
-		now = xtime_cache;
-	} while (read_seqretry(&xtime_lock, seq));
-
-	return now;
-}
-EXPORT_SYMBOL(current_kernel_time);




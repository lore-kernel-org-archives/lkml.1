Return-Path: <linux-kernel-owner+w=401wt.eu-S936021AbYCSVdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936021AbYCSVdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763103AbYCSUFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:05:37 -0400
Received: from over.ny.us.ibm.com ([32.97.182.150]:39278 "EHLO
	over.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763081AbYCSUFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:05:35 -0400
Subject: [PATCH 2/2] Introduce CLOCK_MONOTONIC_RAW
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <1205878279.28128.114.camel@localhost>
References: <1205878279.28128.114.camel@localhost>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 15:13:40 -0700
Message-Id: <1205878420.28128.117.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's my CLOCK_MONOTONIC_RAW, including some suggested changes from
Roman.

Andrew, if there are not major objections, could you add it to your
2.6.26 pending list?

thanks
-john


In talking with Josip Loncaric, and his work on clock synchronization
(see btime.sf.net), he mentioned that for really close synchronization,
it is useful to have access to "hardware time", that is a notion of time
that is not in any way adjusted by the clock slewing done to keep close
time sync.

Part of the issue is if we are using the kernel's ntp adjusted
representation of time in order to measure how we should correct time,
we can run into what Paul McKenney aptly described as "Painting a road
using the lines we're painting as the guide". 

I had been thinking of a similar problem, and was trying to come up with
a way to give users access to a purely hardware based time
representation that avoided users having to know the underlying
frequency and mask values needed to deal with the wide variety of
possible underlying hardware counters.

My solution is to introduce CLOCK_MONOTONIC_RAW. This exposes a
nanosecond based time value, that increments starting at bootup and has
no frequency adjustments made to it what so ever.

The time is accessed from userspace via the posix_clock_gettime()
syscall, passing CLOCK_MONOTONIC_RAW as the clock_id.

This patch depends on the mult_orig patch, just sent a moment ago.


Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index b282b79..3936d2e 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -79,6 +79,7 @@ struct clocksource {
 	/* timekeeping specific data, ignore */
 	cycle_t cycle_interval;
 	u64	xtime_interval;
+	u64	raw_interval;
 	/*
 	 * Second part is written at each timer interrupt
 	 * Keep it in a different cache line to dirty no
@@ -86,6 +87,7 @@ struct clocksource {
 	 */
 	cycle_t cycle_last ____cacheline_aligned_in_smp;
 	u64 xtime_nsec;
+	u64 raw_snsec;
 	s64 error;
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
@@ -215,6 +217,7 @@ static inline void clocksource_calculate_interval(struct clocksource *c,
 
 	/* Go back from cycles -> shifted ns, this time use ntp adjused mult */
 	c->xtime_interval = (u64)c->cycle_interval * c->mult;
+	c->raw_interval = (u64)c->cycle_interval * c->mult_orig;
 }
 
 
diff --git a/include/linux/time.h b/include/linux/time.h
index d32ef0a..f9f41be 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -116,6 +116,7 @@ extern int do_setitimer(int which, struct itimerval *value,
 extern unsigned int alarm_setitimer(unsigned int seconds);
 extern int do_getitimer(int which, struct itimerval *value);
 extern void getnstimeofday(struct timespec *tv);
+extern void getrawmonotonic(struct timespec *ts);
 extern void getboottime(struct timespec *ts);
 extern void monotonic_to_bootbased(struct timespec *ts);
 
@@ -218,6 +219,7 @@ struct itimerval {
 #define CLOCK_MONOTONIC			1
 #define CLOCK_PROCESS_CPUTIME_ID	2
 #define CLOCK_THREAD_CPUTIME_ID		3
+#define CLOCK_MONOTONIC_RAW		4
 
 /*
  * The IDs of various hardware clocks:
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index a9b0420..f75adfa 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -224,6 +224,15 @@ static int posix_ktime_get_ts(clockid_t which_clock, struct timespec *tp)
 }
 
 /*
+ * Get monotonic time for posix timers
+ */
+static int posix_get_monotonic_raw(clockid_t which_clock, struct timespec *tp)
+{
+	getrawmonotonic(tp);
+	return 0;
+}
+
+/*
  * Initialize everything, well, just everything in Posix clocks/timers ;)
  */
 static __init int init_posix_timers(void)
@@ -236,9 +245,15 @@ static __init int init_posix_timers(void)
 		.clock_get = posix_ktime_get_ts,
 		.clock_set = do_posix_clock_nosettime,
 	};
+	struct k_clock clock_monotonic_raw = {
+		.clock_getres = hrtimer_get_res,
+		.clock_get = posix_get_monotonic_raw,
+		.clock_set = do_posix_clock_nosettime,
+	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
 	register_posix_clock(CLOCK_MONOTONIC, &clock_monotonic);
+	register_posix_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 26cf0e7..f5cce8d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -44,6 +44,7 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
  */
 struct timespec xtime __attribute__ ((aligned (16)));
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
+struct timespec monotonic_raw;
 static unsigned long total_sleep_time;		/* seconds */
 
 static struct timespec xtime_cache __attribute__ ((aligned (16)));
@@ -106,6 +107,39 @@ void getnstimeofday(struct timespec *ts)
 EXPORT_SYMBOL(getnstimeofday);
 
 /**
+ * getrawmonotonic - Returns the raw monotonic time in a timespec
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the raw monotonic time (completely un-modified by ntp)
+ */
+void getrawmonotonic(struct timespec *ts)
+{
+	unsigned long seq;
+	s64 nsecs;
+	cycle_t cycle_now, cycle_delta;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		/* read clocksource: */
+		cycle_now = clocksource_read(clock);
+
+		/* calculate the delta since the last update_wall_time: */
+		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+
+		/* convert to nanoseconds: */
+		nsecs = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
+
+		*ts = monotonic_raw;
+		
+	} while (read_seqretry(&xtime_lock, seq));
+
+	timespec_add_ns(ts, nsecs);
+}
+
+EXPORT_SYMBOL(getrawmonotonic);
+
+/**
  * do_gettimeofday - Returns the time of day in a timeval
  * @tv:		pointer to the timeval to be set
  *
@@ -187,6 +221,7 @@ static void change_clocksource(void)
 
 	clock->error = 0;
 	clock->xtime_nsec = 0;
+	clock->raw_snsec = 0;
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 
 	tick_clock_notify();
@@ -251,6 +286,8 @@ void __init timekeeping_init(void)
 	xtime.tv_nsec = 0;
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
+	set_normalized_timespec(&monotonic_raw, 0,0);
+	
 	update_xtime_cache(0);
 	total_sleep_time = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -449,6 +486,7 @@ void update_wall_time(void)
 	offset = clock->cycle_interval;
 #endif
 	clock->xtime_nsec += (s64)xtime.tv_nsec << clock->shift;
+	clock->raw_snsec += (s64) monotonic_raw.tv_nsec <<  clock->shift;
 
 	/* normally this loop will run just once, however in the
 	 * case of lost or late ticks, it will accumulate correctly.
@@ -456,6 +494,7 @@ void update_wall_time(void)
 	while (offset >= clock->cycle_interval) {
 		/* accumulate one interval */
 		clock->xtime_nsec += clock->xtime_interval;
+		clock->raw_snsec += clock->raw_interval;
 		clock->cycle_last += clock->cycle_interval;
 		offset -= clock->cycle_interval;
 
@@ -465,6 +504,11 @@ void update_wall_time(void)
 			second_overflow();
 		}
 
+		if (clock->raw_snsec >= (u64)NSEC_PER_SEC << clock->shift) {
+			clock->raw_snsec -= (u64)NSEC_PER_SEC << clock->shift;
+			monotonic_raw.tv_sec++;
+		}
+	
 		/* accumulate error between NTP and clock interval */
 		clock->error += tick_length;
 		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
@@ -477,6 +521,11 @@ void update_wall_time(void)
 	xtime.tv_nsec = (s64)clock->xtime_nsec >> clock->shift;
 	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
 
+	/* store full nanoseconds into raw_monotonic */
+	monotonic_raw.tv_nsec = (s64)clock->raw_snsec >> clock->shift;
+	clock->raw_snsec -= (s64)monotonic_raw.tv_nsec << clock->shift;
+
+
 	update_xtime_cache(cyc2ns(clock, offset));
 
 	/* check to see if there is a new clocksource to use */



Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbYDBL4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbYDBL4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 07:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYDBL4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 07:56:08 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1925 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbYDBL4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:56:07 -0400
Date: Wed, 2 Apr 2008 13:50:36 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] Introduce CLOCK_MONOTONIC_RAW
In-Reply-To: <1205878420.28128.117.camel@localhost>
Message-ID: <Pine.LNX.4.64.0804021340290.26791@localhost.localdomain>
References: <1205878279.28128.114.camel@localhost> <1205878420.28128.117.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 18 Mar 2008, john stultz wrote:

> My solution is to introduce CLOCK_MONOTONIC_RAW. This exposes a
> nanosecond based time value, that increments starting at bootup and has
> no frequency adjustments made to it what so ever.
> 
> The time is accessed from userspace via the posix_clock_gettime()
> syscall, passing CLOCK_MONOTONIC_RAW as the clock_id.

This is a reworked version of this patch based on the previous 
clocksource_forward_now patch, since clocksource_forward_now() takes 
care of the time offset now, it's not needed to do this at various places.
I also got rid of the monotonic_raw splitting, so the work done during 
update_wall_time() is quite a bit simpler.

bye, Roman

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 include/linux/clocksource.h |    5 ++++
 include/linux/time.h        |    2 +
 kernel/posix-timers.c       |   15 ++++++++++++++
 kernel/time/timekeeping.c   |   47 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 69 insertions(+)

Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -79,6 +79,7 @@ struct clocksource {
 	/* timekeeping specific data, ignore */
 	cycle_t cycle_interval;
 	u64	xtime_interval;
+	u64	raw_interval;
 	/*
 	 * Second part is written at each timer interrupt
 	 * Keep it in a different cache line to dirty no
@@ -87,6 +88,8 @@ struct clocksource {
 	cycle_t cycle_last ____cacheline_aligned_in_smp;
 	u64 xtime_nsec;
 	s64 error;
+	u64 raw_nsec;
+	long raw_sec;
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
@@ -215,6 +218,8 @@ static inline void clocksource_calculate
 
 	/* Go back from cycles -> shifted ns, this time use ntp adjused mult */
 	c->xtime_interval = (u64)c->cycle_interval * c->mult;
+	c->raw_interval = ((u64)c->cycle_interval * c->mult_orig) <<
+			  (NTP_SCALE_SHIFT - c->shift);
 }
 
 
Index: linux-2.6/include/linux/time.h
===================================================================
--- linux-2.6.orig/include/linux/time.h
+++ linux-2.6/include/linux/time.h
@@ -116,6 +116,7 @@ extern int do_setitimer(int which, struc
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
Index: linux-2.6/kernel/posix-timers.c
===================================================================
--- linux-2.6.orig/kernel/posix-timers.c
+++ linux-2.6/kernel/posix-timers.c
@@ -224,6 +224,15 @@ static int posix_ktime_get_ts(clockid_t 
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
@@ -236,9 +245,15 @@ static __init int init_posix_timers(void
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
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -75,6 +75,10 @@ static void clocksource_forward_now(void
 
 	nsec = cyc2ns(clock, cycle_delta);
 	timespec_add_ns(&xtime, nsec);
+
+	nsec = ((s64)cycle_delta * clock->mult_orig) <<
+	       (NTP_SCALE_SHIFT - clock->shift);
+	clock->raw_nsec += nsec;
 }
 
 /**
@@ -181,6 +185,9 @@ static void change_clocksource(void)
 
 	clocksource_forward_now();
 
+	new->raw_sec = clock->raw_sec;
+	new->raw_nsec = clock->raw_nsec;
+
 	clock = new;
 	clock->cycle_last = clocksource_read(new);
 	clock->error = 0;
@@ -202,6 +209,40 @@ static inline void change_clocksource(vo
 #endif
 
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
+		ts->tv_sec = clock->raw_sec;
+		ts->tv_nsec = clock->raw_nsec >> NTP_SCALE_SHIFT;
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	timespec_add_ns(ts, nsecs);
+}
+EXPORT_SYMBOL(getrawmonotonic);
+
+
+/**
  * timekeeping_valid_for_hres - Check if timekeeping is suitable for hres
  */
 int timekeeping_valid_for_hres(void)
@@ -462,6 +503,12 @@ void update_wall_time(void)
 			second_overflow();
 		}
 
+		clock->raw_nsec += clock->raw_interval;
+		if ((u32)(clock->raw_nsec >> NTP_SCALE_SHIFT) >= NSEC_PER_SEC) {
+			clock->raw_nsec -= (u64)NSEC_PER_SEC << NTP_SCALE_SHIFT;
+			clock->raw_sec++;
+		}
+
 		/* accumulate error between NTP and clock interval */
 		clock->error += tick_length;
 		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);

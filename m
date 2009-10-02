Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbZJBXZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbZJBXZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 19:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZJBXZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 19:25:51 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41391 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbZJBXZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 19:25:51 -0400
Subject: [PATCH 2/2] time: remove xtime_cache
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>, Clark Williams <williams@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1254525473.7741.88.camel@localhost.localdomain>
References: <1254525473.7741.88.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 02 Oct 2009 16:24:15 -0700
Message-Id: <1254525855.7741.95.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the prior logarithmic time accumulation patch, xtime will now
always be within one "tick" of the current time, instead of possibly
half a second off. 

This removes the need for the xtime_cache value, which always stored the
time at the last interrupt, so this patch cleans that up removing the
xtime_cache related code.

This is a bit simpler, but still could use some wider testing.

Any comments or feedback would be appreciated!

thanks
-john


Signed-off-by: John Stultz <johnstul@us.ibm.com>

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
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 4cc5656..a1513d0 100644
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
 
@@ -547,7 +538,6 @@ void __init timekeeping_init(void)
 	}
 	set_normalized_timespec(&wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
-	update_xtime_cache(0);
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -581,7 +571,6 @@ static int timekeeping_resume(struct sys_device *dev)
 		wall_to_monotonic = timespec_sub(wall_to_monotonic, ts);
 		total_sleep_time = timespec_add_safe(total_sleep_time, ts);
 	}
-	update_xtime_cache(0);
 	/* re-base the last cycle value */
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
@@ -721,7 +710,6 @@ static void timekeeping_adjust(s64 offset)
 				timekeeper.ntp_error_shift;
 }
 
-
 /**
  * logarithmic_accumulation - shifted accumulation of cycles
  *
@@ -765,7 +753,6 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 	return offset;
 }
 
-
 /**
  * update_wall_time - Uses the current clocksource to increment the wall time
  *
@@ -775,7 +762,6 @@ void update_wall_time(void)
 {
 	struct clocksource *clock;
 	cycle_t offset;
-	u64 nsecs;
 	int shift = 0, maxshift;
 
 	/* Make sure we're fully resumed: */
@@ -841,9 +827,6 @@ void update_wall_time(void)
 	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
 				timekeeper.ntp_error_shift;
 
-	nsecs = clocksource_cyc2ns(offset, timekeeper.mult, timekeeper.shift);
-	update_xtime_cache(nsecs);
-
 	/* check to see if there is a new clocksource to use */
 	update_vsyscall(&xtime, timekeeper.clock);
 }
@@ -880,13 +863,13 @@ void monotonic_to_bootbased(struct timespec *ts)
 
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
@@ -896,8 +879,7 @@ struct timespec current_kernel_time(void)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-
-		now = xtime_cache;
+		now = xtime;
 	} while (read_seqretry(&xtime_lock, seq));
 
 	return now;
@@ -911,8 +893,7 @@ struct timespec get_monotonic_coarse(void)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-
-		now = xtime_cache;
+		now = xtime;
 		mono = wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 



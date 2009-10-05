Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbZJELzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbZJELzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 07:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758805AbZJELzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 07:55:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:33173 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758529AbZJELzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 07:55:53 -0400
Date: Mon, 5 Oct 2009 11:54:38 GMT
From: tip-bot for john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkacur@redhat.com, williams@redhat.com, johnstul@us.ibm.com,
       schwidefsky@de.ibm.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, johnstul@us.ibm.com, williams@redhat.com,
       schwidefsky@de.ibm.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1254525473.7741.88.camel@localhost.localdomain>
References: <1254525473.7741.88.camel@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Implement logarithmic time accumulation
Message-ID: <tip-a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601@git.kernel.org>
Git-Commit-ID: a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 05 Oct 2009 11:54:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601
Gitweb:     http://git.kernel.org/tip/a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601
Author:     john stultz <johnstul@us.ibm.com>
AuthorDate: Fri, 2 Oct 2009 16:17:53 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Oct 2009 13:51:48 +0200

time: Implement logarithmic time accumulation

Accumulating one tick at a time works well unless we're using NOHZ.
Then it can be an issue, since we may have to run through the loop
a few thousand times, which can increase timer interrupt caused
latency.

The current solution was to accumulate in half-second intervals
with NOHZ. This kept the number of loops down, however it did
slightly change how we make NTP adjustments. While not an issue
with NTPd users, as NTPd makes adjustments over a longer period of
time, other adjtimex() users have noticed the half-second
granularity with which we can apply frequency changes to the clock.

For instance, if a application tries to apply a 100ppm frequency
correction for 20ms to correct a 2us offset, with NOHZ they either
get no correction, or a 50us correction.

Now, there will always be some granularity error for applying
frequency corrections. However with users sensitive to this error
have seen a 50-500x increase with NOHZ compared to running without
NOHZ.

So I figured I'd try another approach then just simply increasing
the interval. My approach is to consume the time interval
logarithmically. This reduces the number of times through the loop
needed keeping latency down, while still preserving the original
granularity error for adjtimex() changes.

Further, this change allows us to remove the xtime_cache code
(patch to follow), as xtime is always within one tick of the
current time, instead of the half-second updates it saw before.

An earlier version of this patch has been shipping to x86 users in
the RedHat MRG releases for awhile without issue, but I've reworked
this version to be even more careful about avoiding possible
overflows if the shift value gets too large.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: John Kacur <jkacur@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1254525473.7741.88.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/timex.h     |    4 --
 kernel/time/timekeeping.c |   85 +++++++++++++++++++++++++++++++-------------
 2 files changed, 60 insertions(+), 29 deletions(-)

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
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fb0f46f..5fdd78e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -721,6 +721,51 @@ static void timekeeping_adjust(s64 offset)
 				timekeeper.ntp_error_shift;
 }
 
+
+/**
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
+
 /**
  * update_wall_time - Uses the current clocksource to increment the wall time
  *
@@ -731,6 +776,7 @@ void update_wall_time(void)
 	struct clocksource *clock;
 	cycle_t offset;
 	u64 nsecs;
+	int shift = 0, maxshift;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -744,33 +790,22 @@ void update_wall_time(void)
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

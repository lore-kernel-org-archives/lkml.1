Return-Path: <linux-kernel-owner+w=401wt.eu-S1757824AbZJGIO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbZJGIO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932477AbZJGIA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:00:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454AbZJGIAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:00:24 -0400
Date: Wed, 7 Oct 2009 09:58:48 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       tglx@linutronix.de
cc: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] time: logrithmic time accumulation
In-Reply-To: <20091005115218.GA7475@elte.hu>
Message-ID: <alpine.LFD.2.00.0910070948080.15183@localhost.localdomain>
References: <1254525473.7741.88.camel@localhost.localdomain> <alpine.LFD.2.00.0910051228420.5132@localhost.localdomain> <20091005115218.GA7475@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@John Stultz
I backported your patch to 2.6.31.2-rt13, could you please look it over 
and see if it looks okay to you?

@Thomas
Could you please consider queuing this up for -rt14.
Since John submitted it upstream, we will be able to drop it again in the 
future.

Thanks

>From 8090f669e58901c1b0c5e8bac4160eaaf7990f4d Mon Sep 17 00:00:00 2001
From: tip-bot for john stultz <johnstul@us.ibm.com>
Date: Mon, 5 Oct 2009 11:54:38 +0000
Subject: [PATCH] time: Implement logarithmic time accumulation

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
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 include/linux/timex.h     |    4 --
 kernel/time/timekeeping.c |   83 +++++++++++++++++++++++++++++++++------------
 2 files changed, 61 insertions(+), 26 deletions(-)

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
index 9d1bac7..4630874 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -608,6 +608,51 @@ static void clocksource_adjust(s64 offset)
 			(NTP_SCALE_SHIFT - clock->shift);
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
+	u64 nsecps = (u64)NSEC_PER_SEC << clock->shift;
+
+	/* If the offset is smaller then a shifted interval, do nothing */
+	if (offset < clock->cycle_interval<<shift)
+		return offset;
+
+	/* Accumulate one shifted interval */
+	offset -= clock->cycle_interval << shift;
+	clock->cycle_last += clock->cycle_interval << shift;
+
+	clock->xtime_nsec += clock->xtime_interval << shift;
+	while (clock->xtime_nsec >= nsecps) {
+		clock->xtime_nsec -= nsecps;
+		xtime.tv_sec++;
+		second_overflow();
+	}
+
+	/* Accumulate into raw time */
+	clock->raw_time.tv_nsec += clock->raw_interval << shift;;
+	while (clock->raw_time.tv_nsec >= NSEC_PER_SEC) {
+		clock->raw_time.tv_nsec -= NSEC_PER_SEC;
+		clock->raw_time.tv_sec++;
+	}
+
+	/* Accumulate error between NTP and clock interval */
+	clock->error += tick_length << shift;
+	clock->error -= clock->xtime_interval <<
+				(NTP_SCALE_SHIFT - clock->shift + shift);
+
+	return offset;
+}
+
+
 /**
  * update_wall_time - Uses the current clocksource to increment the wall time
  *
@@ -616,6 +661,8 @@ static void clocksource_adjust(s64 offset)
 void update_wall_time(void)
 {
 	cycle_t offset;
+	u64 nsecs;
+	int shift = 0, maxshift;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -628,30 +675,22 @@ void update_wall_time(void)
 #endif
 	clock->xtime_nsec = (s64)xtime.tv_nsec << clock->shift;
 
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
+	shift = ilog2(offset) - ilog2(clock->cycle_interval);
+	shift = max(0, shift);
+	/* Bound shift to one less then what overflows tick_length */
+	maxshift = (8*sizeof(tick_length) - (ilog2(tick_length)+1)) - 1;
+	shift = min(shift, maxshift);
 	while (offset >= clock->cycle_interval) {
-		/* accumulate one interval */
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
-
-		/* accumulate error between NTP and clock interval */
-		clock->error += tick_length;
-		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
+		offset = logarithmic_accumulation(offset, shift);
+		shift--;
 	}
 
 	/* correct the clock when NTP error is too big */
-- 
1.6.0.6


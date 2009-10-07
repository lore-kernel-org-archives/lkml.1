Return-Path: <linux-kernel-owner+w=401wt.eu-S934117AbZJGIEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934117AbZJGIEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934113AbZJGID4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:03:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934088AbZJGIDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:03:49 -0400
Date: Wed, 7 Oct 2009 10:02:27 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       tglx@linutronix.de, john stultz <johnstul@us.ibm.com>
cc: Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] time: remove xtime_cache
In-Reply-To: <1254525855.7741.95.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910070959360.15183@localhost.localdomain>
References: <1254525473.7741.88.camel@localhost.localdomain> <1254525855.7741.95.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


@John Stultz
I also backported this patch to 2.6.31.2-rt13, could you please look it 
over and see if it looks okay to you?

@Thomas
Same as the previous patch, please consider queuing this for -rt14 and we 
can drop it in the future because John Stultz submitted it upstream.

Thanks

>From 868ee3f7346a90ae3b529ac24996f059cc322a82 Mon Sep 17 00:00:00 2001
From: tip-bot for john stultz <johnstul@us.ibm.com>
Date: Mon, 5 Oct 2009 11:54:53 +0000
Subject: [PATCH] time: Remove xtime_cache

Commit-ID:  7bc7d637452383d56ba4368d4336b0dde1bb476d
Gitweb:     http://git.kernel.org/tip/7bc7d637452383d56ba4368d4336b0dde1bb476d
Author:     john stultz <johnstul@us.ibm.com>
AuthorDate: Fri, 2 Oct 2009 16:24:15 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Oct 2009 13:52:02 +0200

time: Remove xtime_cache

With the prior logarithmic time accumulation patch, xtime will now
always be within one "tick" of the current time, instead of
possibly half a second off.

This removes the need for the xtime_cache value, which always
stored the time at the last interrupt, so this patch cleans that up
removing the xtime_cache related code.

This is a bit simpler, but still could use some wider testing.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: John Kacur <jkacur@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1254525855.7741.95.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/time.c             |    1 -
 kernel/time/timekeeping.c |   20 ++------------------
 2 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index 35d1aaa..01944b5 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -136,7 +136,6 @@ static inline void warp_clock(void)
 	write_atomic_seqlock_irq(&xtime_lock);
 	wall_to_monotonic.tv_sec -= sys_tz.tz_minuteswest * 60;
 	xtime.tv_sec += sys_tz.tz_minuteswest * 60;
-	update_xtime_cache(0);
 	write_atomic_sequnlock_irq(&xtime_lock);
 	clock_was_set();
 }
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 4630874..4a0920d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -48,16 +48,8 @@ static unsigned long total_sleep_time;		/* seconds */
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
-static struct timespec xtime_cache __attribute__ ((aligned (16)));
-void update_xtime_cache(u64 nsec)
-{
-	xtime_cache = xtime;
-	timespec_add_ns(&xtime_cache, nsec);
-}
-
 struct clocksource *clock;
 
-
 #ifdef CONFIG_GENERIC_TIME
 /**
  * clocksource_forward_now - update clock to the current time
@@ -233,7 +225,6 @@ int do_settimeofday(struct timespec *tv)
 
 	xtime = *tv;
 
-	update_xtime_cache(0);
 
 	clock->error = 0;
 	ntp_clear();
@@ -435,7 +426,6 @@ void __init timekeeping_init(void)
 	xtime.tv_nsec = 0;
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
-	update_xtime_cache(0);
 	total_sleep_time = 0;
 	write_atomic_sequnlock_irqrestore(&xtime_lock, flags);
 }
@@ -467,7 +457,6 @@ static int timekeeping_resume(struct sys_device *dev)
 		wall_to_monotonic.tv_sec -= sleep_length;
 		total_sleep_time += sleep_length;
 	}
-	update_xtime_cache(0);
 	/* re-base the last cycle value */
 	clock->cycle_last = 0;
 	clock->cycle_last = clocksource_read(clock);
@@ -608,7 +597,6 @@ static void clocksource_adjust(s64 offset)
 			(NTP_SCALE_SHIFT - clock->shift);
 }
 
-
 /**
  * logarithmic_accumulation - shifted accumulation of cycles
  *
@@ -652,7 +640,6 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 	return offset;
 }
 
-
 /**
  * update_wall_time - Uses the current clocksource to increment the wall time
  *
@@ -661,7 +648,6 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 void update_wall_time(void)
 {
 	cycle_t offset;
-	u64 nsecs;
 	int shift = 0, maxshift;
 
 	/* Make sure we're fully resumed: */
@@ -725,8 +711,6 @@ void update_wall_time(void)
 	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
 	clock->error += clock->xtime_nsec << (NTP_SCALE_SHIFT - clock->shift);
 
-	update_xtime_cache(cyc2ns(clock, offset));
-
 	/* check to see if there is a new clocksource to use */
 	change_clocksource();
 	update_vsyscall(&xtime, clock);
@@ -761,7 +745,7 @@ void monotonic_to_bootbased(struct timespec *ts)
 
 unsigned long get_seconds(void)
 {
-	return xtime_cache.tv_sec;
+	return xtime.tv_sec;
 }
 EXPORT_SYMBOL(get_seconds);
 
@@ -774,7 +758,7 @@ struct timespec current_kernel_time(void)
 	do {
 		seq = read_atomic_seqbegin(&xtime_lock);
 
-		now = xtime_cache;
+		now = xtime;
 	} while (read_atomic_seqretry(&xtime_lock, seq));
 
 	return now;
-- 
1.6.0.6


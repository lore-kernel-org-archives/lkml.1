Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbZGFNtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbZGFNtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZGFNtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:49:33 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:58738 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZGFNtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:49:32 -0400
Date: Mon, 6 Jul 2009 15:49:33 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: [PATCH] optimized ktime_get[_ts] for GENERIC_TIME=y
Message-ID: <20090706154933.5a1f8990@skybase>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The generic ktime_get function defined in kernel/hrtimer.c is suboptimial
for GENERIC_TIME=y:

 0)               |  ktime_get() {
 0)               |    ktime_get_ts() {
 0)               |      getnstimeofday() {
 0)               |        read_tod_clock() {
 0)   0.601 us    |        }
 0)   1.938 us    |      }
 0)               |      set_normalized_timespec() {
 0)   0.602 us    |      }
 0)   4.375 us    |    }
 0)   5.523 us    |  }

Overall there are two read_seqbegin/read_seqretry loops and a lot of
unnecessary struct timespec calculations. ktime_get returns a nano second
value which is the sum of xtime, wall_to_monotonic and the nano second
delta from the clock source.

ktime_get can be optimized for GENERIC_TIME=y. The new version only calls
clocksource_read:

 0)               |  ktime_get() {
 0)               |    read_tod_clock() {
 0)   0.610 us    |    }
 0)   1.977 us    |  }

It uses a single read_seqbegin/readseqretry loop and just adds everthing
to a nano second value.

ktime_get_ts is optimized in a similar fashion.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 kernel/hrtimer.c          |    4 ++
 kernel/time/timekeeping.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)


diff -urpN linux-2.5/kernel/hrtimer.c linux-2.5-patched/kernel/hrtimer.c
--- linux-2.5/kernel/hrtimer.c	2009-07-03 10:46:07.000000000 +0200
+++ linux-2.5-patched/kernel/hrtimer.c	2009-07-03 10:46:23.000000000 +0200
@@ -46,6 +46,7 @@
 
 #include <asm/uaccess.h>
 
+#ifndef CONFIG_GENERIC_TIME
 /**
  * ktime_get - get the monotonic time in ktime_t format
  *
@@ -60,6 +61,7 @@ ktime_t ktime_get(void)
 	return timespec_to_ktime(now);
 }
 EXPORT_SYMBOL_GPL(ktime_get);
+#endif
 
 /**
  * ktime_get_real - get the real (wall-) time in ktime_t format
@@ -104,6 +106,7 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, 
 	}
 };
 
+#ifndef CONFIG_GENERIC_TIME
 /**
  * ktime_get_ts - get the monotonic clock in timespec format
  * @ts:		pointer to timespec variable
@@ -128,6 +131,7 @@ void ktime_get_ts(struct timespec *ts)
 				ts->tv_nsec + tomono.tv_nsec);
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts);
+#endif
 
 /*
  * Get the coarse grained time at the softirq based on xtime and
diff -urpN linux-2.5/kernel/time/timekeeping.c linux-2.5-patched/kernel/time/timekeeping.c
--- linux-2.5/kernel/time/timekeeping.c	2009-07-03 10:46:07.000000000 +0200
+++ linux-2.5-patched/kernel/time/timekeeping.c	2009-07-03 10:46:23.000000000 +0200
@@ -118,6 +118,69 @@ void getnstimeofday(struct timespec *ts)
 
 EXPORT_SYMBOL(getnstimeofday);
 
+ktime_t ktime_get(void)
+{
+	cycle_t cycle_now, cycle_delta;
+	struct timespec time;
+	unsigned long seq;
+	s64 nsecs;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		time.tv_sec = xtime.tv_sec + wall_to_monotonic.tv_sec;
+		time.tv_nsec = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
+
+		/* read clocksource: */
+		cycle_now = clocksource_read(clock);
+
+		/* calculate the delta since the last update_wall_time: */
+		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+
+		/* convert to nanoseconds: */
+		nsecs = cyc2ns(clock, cycle_delta);
+
+	} while (read_seqretry(&xtime_lock, seq));
+	nsecs += time.tv_sec * 1000000000ULL + time.tv_nsec;
+	return (ktime_t) { .tv64 = nsecs };
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
+	cycle_t cycle_now, cycle_delta;
+	struct timespec tomono;
+	unsigned long seq;
+	s64 nsecs;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		*ts = xtime;
+		tomono = wall_to_monotonic;
+
+		/* read clocksource: */
+		cycle_now = clocksource_read(clock);
+
+		/* calculate the delta since the last update_wall_time: */
+		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+
+		/* convert to nanoseconds: */
+		nsecs = cyc2ns(clock, cycle_delta);
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


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


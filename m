Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbZGGMHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbZGGMHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 08:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZGGMHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 08:07:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:56248 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbZGGMHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 08:07:21 -0400
Date: Tue, 7 Jul 2009 12:06:51 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <20090707112728.3005244d@skybase>
References: <20090707112728.3005244d@skybase>
Subject: [tip:timers/core] timekeeping: optimized ktime_get[_ts] for GENERIC_TIME=y
Message-ID: <tip-951ed4d36b77ba9fe1ea08fc3c59d8bb6c9bda32@git.kernel.org>
Git-Commit-ID: 951ed4d36b77ba9fe1ea08fc3c59d8bb6c9bda32
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Jul 2009 12:06:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  951ed4d36b77ba9fe1ea08fc3c59d8bb6c9bda32
Gitweb:     http://git.kernel.org/tip/951ed4d36b77ba9fe1ea08fc3c59d8bb6c9bda32
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Tue, 7 Jul 2009 11:27:28 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 7 Jul 2009 12:47:33 +0200

timekeeping: optimized ktime_get[_ts] for GENERIC_TIME=y

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

[ tglx: added WARN_ON(timekeeping_suspended) as in getnstimeofday() ]

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: john stultz <johnstul@us.ibm.com>
LKML-Reference: <20090707112728.3005244d@skybase>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/hrtimer.c          |    4 ++
 kernel/time/timekeeping.c |   69 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 9002958..829e066 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -48,6 +48,7 @@
 
 #include <asm/uaccess.h>
 
+#ifndef CONFIG_GENERIC_TIME
 /**
  * ktime_get - get the monotonic time in ktime_t format
  *
@@ -62,6 +63,7 @@ ktime_t ktime_get(void)
 	return timespec_to_ktime(now);
 }
 EXPORT_SYMBOL_GPL(ktime_get);
+#endif
 
 /**
  * ktime_get_real - get the real (wall-) time in ktime_t format
@@ -106,6 +108,7 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 	}
 };
 
+#ifndef CONFIG_GENERIC_TIME
 /**
  * ktime_get_ts - get the monotonic clock in timespec format
  * @ts:		pointer to timespec variable
@@ -130,6 +133,7 @@ void ktime_get_ts(struct timespec *ts)
 				ts->tv_nsec + tomono.tv_nsec);
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts);
+#endif
 
 /*
  * Get the coarse grained time at the softirq based on xtime and
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e8c77d9..7a24813 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -125,6 +125,75 @@ void getnstimeofday(struct timespec *ts)
 
 EXPORT_SYMBOL(getnstimeofday);
 
+ktime_t ktime_get(void)
+{
+	cycle_t cycle_now, cycle_delta;
+	unsigned int seq;
+	s64 secs, nsecs;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
+		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
+
+		/* read clocksource: */
+		cycle_now = clocksource_read(clock);
+
+		/* calculate the delta since the last update_wall_time: */
+		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+
+		/* convert to nanoseconds: */
+		nsecs += cyc2ns(clock, cycle_delta);
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
+	cycle_t cycle_now, cycle_delta;
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

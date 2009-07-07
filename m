Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZGGJ1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZGGJ1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZGGJ12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:27:28 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:57925 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbZGGJ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:27:27 -0400
Date: Tue, 7 Jul 2009 11:27:28 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] optimized ktime_get[_ts] for GENERIC_TIME=y
Message-ID: <20090707112728.3005244d@skybase>
In-Reply-To: <alpine.LFD.2.00.0907071004380.19480@localhost.localdomain>
References: <20090706154933.5a1f8990@skybase>
	<alpine.LFD.2.00.0907062215380.19480@localhost.localdomain>
	<20090707094018.08406c49@skybase>
	<alpine.LFD.2.00.0907071004380.19480@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009 10:08:56 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> Martin,
> 
> On Tue, 7 Jul 2009, Martin Schwidefsky wrote:
> > On Mon, 6 Jul 2009 22:31:39 +0200 (CEST)
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > On Mon, 6 Jul 2009, Martin Schwidefsky wrote:
> > > > +ktime_t ktime_get(void)
> > > > +{
> > > > +	cycle_t cycle_now, cycle_delta;
> > > > +	struct timespec time;
> > > > +	unsigned long seq;
> > > > +	s64 nsecs;
> > > > +
> > > > +	do {
> > > > +		seq = read_seqbegin(&xtime_lock);
> > > > +		time.tv_sec = xtime.tv_sec + wall_to_monotonic.tv_sec;
> > > > +		time.tv_nsec = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
> > > 
> > > That's actually a violation of the timespec semantics. tv_nsec can end
> > > up greater than (10^9 - 1). Please use separate sec and nsec variables.
> > 
> > Well the tv_sec/tv_nsec fields of a timespec are long values. But its
> > no problem to switch to local variables.
> 
> Right. I'm not worried about an overflow of the variable. I was about
> to suggest using timespec_to_ktime() to fix the !SCALAR problem when I
> noticed that the timespec is possibly not normalized. Not using a
> timespec makes the code more obvious I think.

That makes sense. New patch:

--
Subject: [PATCH] optimized ktime_get[_ts] for GENERIC_TIME=y

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
Acked-by: john stultz <johnstul@us.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 kernel/hrtimer.c          |    4 ++
 kernel/time/timekeeping.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff -urpN linux-2.6/kernel/hrtimer.c linux-2.6-patched/kernel/hrtimer.c
--- linux-2.6/kernel/hrtimer.c	2009-07-07 11:24:29.000000000 +0200
+++ linux-2.6-patched/kernel/hrtimer.c	2009-07-07 11:24:37.000000000 +0200
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
@@ -106,6 +108,7 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, 
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
diff -urpN linux-2.6/kernel/time/timekeeping.c linux-2.6-patched/kernel/time/timekeeping.c
--- linux-2.6/kernel/time/timekeeping.c	2009-07-07 11:24:29.000000000 +0200
+++ linux-2.6-patched/kernel/time/timekeeping.c	2009-07-07 11:24:37.000000000 +0200
@@ -125,6 +125,71 @@ void getnstimeofday(struct timespec *ts)
 
 EXPORT_SYMBOL(getnstimeofday);
 
+ktime_t ktime_get(void)
+{
+	cycle_t cycle_now, cycle_delta;
+	unsigned int seq;
+	s64 secs, nsecs;
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


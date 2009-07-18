Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZGRWJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZGRWJo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 18:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZGRWJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 18:09:42 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44461 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZGRWJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 18:09:41 -0400
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@tglx.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       nikolag@ca.ibm.com, Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <alpine.LFD.2.00.0907181027510.11571@localhost.localdomain>
References: <1247873945.8334.67.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0907181027510.11571@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 15:09:38 -0700
Message-Id: <1247954978.14494.19.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-18 at 10:30 +0200, Thomas Gleixner wrote:
> On Fri, 17 Jul 2009, john stultz wrote:
> > +static int posix_get_realtime_coarse(clockid_t which_clock, struct timespec *tp)
> > +{
> > +	*tp = current_kernel_time();
> > +	return 0;
> > +}
> > +
> > +static int posix_get_monotonic_coarse(clockid_t which_clock,
> > +						struct timespec *tp)
> > +{
> > +	*tp = get_monotonic_coarse();
> > +	return 0;
> > +}
> > +
> > +int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
> > +{
> > +	*tp = ktime_to_timespec(KTIME_LOW_RES);
> > +	return 0;
> > +}
> >  /*
> >   * Initialize everything, well, just everything in Posix clocks/timers ;)
> >   */
> > @@ -255,10 +274,24 @@ static __init int init_posix_timers(void)
> >  		.clock_set = do_posix_clock_nosettime,
> >  		.timer_create = no_timer_create,
> >  	};
> > +	struct k_clock clock_realtime_coarse = {
> > +		.clock_getres = hrtimer_get_res,
> 
>   shouldn't that be posix_get_coarse_res ?

Doh! Thanks for pointing that out.

Fixed patch below.

-john


After talking with some application writers who want very fast, but not
fine-grained timestamps, I decided to try to implement a new clock_ids
to clock_gettime(): CLOCK_REALTIME_COARSE and CLOCK_MONOTONIC_COARSE
which returns the time at the last tick. This is very fast as we don't
have to access any hardware (which can be very painful if you're using
something like the acpi_pm clocksource), and we can even use the vdso
clock_gettime() method to avoid the syscall. The only trade off is you
only get low-res tick grained time resolution.

This isn't a new idea, I know Ingo pushed a patch (see commit
5899a0f044f3c80e9f7262ec5bc7164773a4c28e) a little while ago that made
the vsyscall gettimeofday() return coarse grained time when the
vsyscall64 sysctrl was set to 2. However this affects all applications
on a system.

With this method, applications can choose the proper speed/granularity
trade-off for themselves.

This is a first pass on this implementation, and while I did test it,
the box I tested it with did not have a glibc new enough to utilize the
vdso clock_gettime(), so there may still be issues there. I'll find a
newer box for testing shortly.

Any thoughts or feedback will be appreciated!

thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 1ef0f90..e949cc7 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -83,14 +83,47 @@ notrace static noinline int do_monotonic(struct timespec *ts)
 	return 0;
 }
 
+notrace static noinline int do_realtime_coarse(struct timespec *ts)
+{
+	unsigned long seq;
+	do {
+		seq = read_seqbegin(&gtod->lock);
+		ts->tv_sec = gtod->wall_time_sec;
+		ts->tv_nsec = gtod->wall_time_nsec;
+	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	return 0;
+}
+
+notrace static noinline int do_monotonic_coarse(struct timespec *ts)
+{
+	unsigned long seq, ns, secs;
+	do {
+		seq = read_seqbegin(&gtod->lock);
+		secs = gtod->wall_time_sec;
+		ns = gtod->wall_time_nsec;
+		secs += gtod->wall_to_monotonic.tv_sec;
+		ns += gtod->wall_to_monotonic.tv_nsec;
+	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	vset_normalized_timespec(ts, secs, ns);
+	return 0;
+}
+
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
-	if (likely(gtod->sysctl_enabled && gtod->clock.vread))
+	if (likely(gtod->sysctl_enabled))
 		switch (clock) {
 		case CLOCK_REALTIME:
-			return do_realtime(ts);
+			if (likely(gtod->clock.vread))
+				return do_realtime(ts);
+			break;
 		case CLOCK_MONOTONIC:
-			return do_monotonic(ts);
+			if (likely(gtod->clock.vread))
+				return do_monotonic(ts);
+			break;
+		case CLOCK_REALTIME_COARSE:
+			return do_realtime_coarse(ts);
+		case CLOCK_MONOTONIC_COARSE:
+			return do_monotonic_coarse(ts);
 		}
 	return vdso_fallback_gettime(clock, ts);
 }
diff --git a/include/linux/time.h b/include/linux/time.h
index ce321ac..9db8421 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -108,6 +108,7 @@ void timekeeping_init(void);
 
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
+struct timespec get_monotonic_coarse(void);
 
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
@@ -225,6 +226,8 @@ struct itimerval {
 #define CLOCK_PROCESS_CPUTIME_ID	2
 #define CLOCK_THREAD_CPUTIME_ID		3
 #define CLOCK_MONOTONIC_RAW		4
+#define CLOCK_REALTIME_COARSE		5
+#define CLOCK_MONOTONIC_COARSE		6
 
 /*
  * The IDs of various hardware clocks:
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 752b036..3a60c50 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -236,6 +236,25 @@ static int posix_get_monotonic_raw(clockid_t which_clock, struct timespec *tp)
 	return 0;
 }
 
+
+static int posix_get_realtime_coarse(clockid_t which_clock, struct timespec *tp)
+{
+	*tp = current_kernel_time();
+	return 0;
+}
+
+static int posix_get_monotonic_coarse(clockid_t which_clock,
+						struct timespec *tp)
+{
+	*tp = get_monotonic_coarse();
+	return 0;
+}
+
+int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
+{
+	*tp = ktime_to_timespec(KTIME_LOW_RES);
+	return 0;
+}
 /*
  * Initialize everything, well, just everything in Posix clocks/timers ;)
  */
@@ -255,10 +274,24 @@ static __init int init_posix_timers(void)
 		.clock_set = do_posix_clock_nosettime,
 		.timer_create = no_timer_create,
 	};
+	struct k_clock clock_realtime_coarse = {
+		.clock_getres = posix_get_coarse_res,
+		.clock_get = posix_get_realtime_coarse,
+		.clock_set = do_posix_clock_nosettime,
+		.timer_create = no_timer_create,
+	};
+	struct k_clock clock_monotonic_coarse = {
+		.clock_getres = posix_get_coarse_res,
+		.clock_get = posix_get_monotonic_coarse,
+		.clock_set = do_posix_clock_nosettime,
+		.timer_create = no_timer_create,
+	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
 	register_posix_clock(CLOCK_MONOTONIC, &clock_monotonic);
 	register_posix_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
+	register_posix_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
+	register_posix_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fa05e88..cfe1f32 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -602,3 +602,22 @@ struct timespec current_kernel_time(void)
 	return now;
 }
 EXPORT_SYMBOL(current_kernel_time);
+
+struct timespec get_monotonic_coarse(void)
+{
+	struct timespec now, mono;
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		now = xtime_cache;
+		mono = wall_to_monotonic;
+	} while (read_seqretry(&xtime_lock, seq));
+
+	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
+				now.tv_nsec + mono.tv_nsec);
+	return now;
+}
+EXPORT_SYMBOL(get_monotonic_coarse);
+



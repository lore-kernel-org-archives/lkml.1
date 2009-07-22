Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbZGVB30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbZGVB30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 21:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbZGVB3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 21:29:25 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40146 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZGVB3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 21:29:24 -0400
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
From: john stultz <johnstul@us.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, nikolag@ca.ibm.com,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <1248215479.3298.124.camel@localhost>
References: <1247873945.8334.67.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0907181027510.11571@localhost.localdomain>
	 <1247954978.14494.19.camel@work-vm> <20090718153011.1de3af8e@infradead.org>
	 <1248215479.3298.124.camel@localhost>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 18:26:18 -0700
Message-Id: <1248225978.3298.164.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 15:31 -0700, john stultz wrote:
> On Sat, 2009-07-18 at 15:30 -0700, Arjan van de Ven wrote:
> > On Sat, 18 Jul 2009 15:09:38 -0700
> > john stultz <johnstul@us.ibm.com> wrote:
> >
> > > me_lock, seq));
> > > +
> > > +	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
> > > +				now.tv_nsec + mono.tv_nsec);
> > > +	return now;
> > > +}
> > > +EXPORT_SYMBOL(get_monotonic_coarse);
> > > +
> > 
> > why does this need to be exported ?
> 
> Doesn't. Thanks for noticing!

Here's an updated version of the patch that fixes the following:
1) Remove EXPORT_SYMBOL for get_monotonic_coarse
2) The x86_64 vsyscall was using xtime instead of xtime_cache for the
calculations. This would cause the resolution to be actually
NTP_INTERVAL_FREQ (possibly 2/sec) instead of HZ.

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

Any thoughts or feedback will be appreciated!

thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index dc27a69..3d61e20 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -21,6 +21,7 @@ struct vsyscall_gtod_data {
 		u32	shift;
 	} clock;
 	struct timespec wall_to_monotonic;
+	struct timespec wall_time_coarse;
 };
 extern struct vsyscall_gtod_data __vsyscall_gtod_data
 __section_vsyscall_gtod_data;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 25ee06a..cf53a78 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -87,6 +87,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
 	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
+	vsyscall_gtod_data.wall_time_coarse = __current_kernel_time();
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 6a40b78..ee55754 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -86,14 +86,47 @@ notrace static noinline int do_monotonic(struct timespec *ts)
 	return 0;
 }
 
+notrace static noinline int do_realtime_coarse(struct timespec *ts)
+{
+	unsigned long seq;
+	do {
+		seq = read_seqbegin(&gtod->lock);
+		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
+		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
+	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	return 0;
+}
+
+notrace static noinline int do_monotonic_coarse(struct timespec *ts)
+{
+	unsigned long seq, ns, secs;
+	do {
+		seq = read_seqbegin(&gtod->lock);
+		secs = gtod->wall_time_coarse.tv_sec;
+		ns = gtod->wall_time_coarse.tv_nsec;
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
index ea16c1a..ce13067 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -109,6 +109,8 @@ extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
+struct timespec __current_kernel_time(void); /* does not hold xtime_lock */
+struct timespec get_monotonic_coarse(void);
 
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
@@ -241,6 +243,8 @@ struct itimerval {
 #define CLOCK_PROCESS_CPUTIME_ID	2
 #define CLOCK_THREAD_CPUTIME_ID		3
 #define CLOCK_MONOTONIC_RAW		4
+#define CLOCK_REALTIME_COARSE		5
+#define CLOCK_MONOTONIC_COARSE		6
 
 /*
  * The IDs of various hardware clocks:
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 052ec4d..ddf33bf 100644
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
index e8c77d9..d4735d7 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -603,6 +603,10 @@ unsigned long get_seconds(void)
 }
 EXPORT_SYMBOL(get_seconds);
 
+struct timespec __current_kernel_time(void)
+{
+	return xtime_cache;
+}
 
 struct timespec current_kernel_time(void)
 {
@@ -618,3 +622,20 @@ struct timespec current_kernel_time(void)
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



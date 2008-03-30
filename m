Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYC3V1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYC3V1w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 17:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbYC3V1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 17:27:43 -0400
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37]:53855
	"EHLO mk-outboundfilter-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752971AbYC3V1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 17:27:42 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Mar 2008 17:27:41 EDT
X-Trace: 81726939/mk-outboundfilter-1.mail.uk.tiscali.com/PIPEX/$ACCEPTED/pipex-customers/85.210.71.33
X-SBRS: None
X-RemoteIP: 85.210.71.33
X-IP-MAIL-FROM: tr@earth.li
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AngFAPuf70dV0kch/2dsb2JhbACBWqVa
X-IP-Direction: IN
Date: Sun, 30 Mar 2008 22:17:33 +0100 (BST)
From: Tim Ricketts <tr@earth.li>
To: Michael Smith <msmith@xiph.org>
cc: linux-kernel@vger.kernel.org, Andy Wingo <wingo@fluendo.com>
Subject: Re: gettimeofday() jumping into the future
In-Reply-To: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803302210060.3056@falcon.foo>
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007, Michael Smith wrote:

> We've been seeing some strange behaviour on some of our applications
> recently. I've tracked this down to gettimeofday() returning spurious
> values occasionally.
>
> Specifically, gettimeofday() will suddenly, for a single call, return
> a value about 4398 seconds (~1 hour 13 minutes) in the future. The
> following call goes back to a normal value.

I have also seen this.

> This seems to be occurring when the clock source goes slightly
> backwards for a single call. In
> kernel/time/timekeeping.c:__get_nsec_offset(), we have this:
> cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
>
> So a small decrease in time here will (this is all unsigned
> arithmetic) give us a very large cycle_delta. cyc2ns() then multiplies
> this by some value, then right shifts by 22. The resulting value (in
> nanoseconds) is approximately 4398 seconds; this gets added on to the
> xtime value, giving us our jump into the future. The next call to
> gettimeofday() returns to normal as we don't have this huge nanosecond
> offset.

Indeed.  I don't know where the suggestion of off by 2^32us came in
later in this thread.  As you've already pointed out, it's off by
2^42ns.

I've no idea why the TSC might go backwards, but perhaps we should not
break horribly if it does.  How about treating it as zero?

diff -urN linux-2.6.24.4/include/linux/clocksource.h linux/include/linux/clocksource.h
--- linux-2.6.24.4/include/linux/clocksource.h	2008-03-24 18:49:18.000000000 +0000
+++ linux/include/linux/clocksource.h	2008-03-28 11:15:02.000000000 +0000
@@ -176,7 +176,7 @@
   *
   * XXX - This could use some mult_lxl_ll() asm optimization
   */
-static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
+static inline u64 cyc2ns(struct clocksource *cs, cycle_t cycles)
  {
  	u64 ret = (u64)cycles;
  	ret = (ret * cs->mult) >> cs->shift;
diff -urN linux-2.6.24.4/kernel/time/timekeeping.c linux/kernel/time/timekeeping.c
--- linux-2.6.24.4/kernel/time/timekeeping.c	2008-03-24 18:49:18.000000000 +0000
+++ linux/kernel/time/timekeeping.c	2008-03-28 11:15:01.000000000 +0000
@@ -64,14 +64,17 @@
   * called. Returns the number of nanoseconds since the
   * last call to update_wall_time() (adjusted by NTP scaling)
   */
-static inline s64 __get_nsec_offset(void)
+static inline u64 __get_nsec_offset(void)
  {
  	cycle_t cycle_now, cycle_delta;
-	s64 ns_offset;
+	u64 ns_offset;

  	/* read clocksource: */
  	cycle_now = clocksource_read(clock);

+	if (cycle_now < clock->cycle_last)
+		return 0;
+
  	/* calculate the delta since the last update_wall_time: */
  	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;

@@ -91,7 +94,7 @@
  static inline void __get_realtime_clock_ts(struct timespec *ts)
  {
  	unsigned long seq;
-	s64 nsecs;
+	u64 nsecs;

  	do {
  		seq = read_seqbegin(&xtime_lock);
@@ -207,7 +210,7 @@
  }
  #else
  static inline void change_clocksource(void) { }
-static inline s64 __get_nsec_offset(void) { return 0; }
+static inline u64 __get_nsec_offset(void) { return 0; }
  #endif

  /**
@@ -272,7 +275,7 @@
  /* time in seconds when suspend began */
  static unsigned long timekeeping_suspend_time;
  /* xtime offset when we went into suspend */
-static s64 timekeeping_suspend_nsecs;
+static u64 timekeeping_suspend_nsecs;

  /**
   * timekeeping_resume - Resumes the generic timekeeping subsystem.




Alternatively, we could try to make it work and have gettimeofday jump
back slightly in this case, but I don't like this as much, because I
think it's more complicated, slower and unnecessary.

diff -urN linux-2.6.24.4/arch/x86/vdso/vclock_gettime.c linux/arch/x86/vdso/vclock_gettime.c
--- linux-2.6.24.4/arch/x86/vdso/vclock_gettime.c	2008-03-24 18:49:18.000000000 +0000
+++ linux/arch/x86/vdso/vclock_gettime.c	2008-03-28 12:15:24.000000000 +0000
@@ -43,7 +43,8 @@

  static noinline int do_realtime(struct timespec *ts)
  {
-	unsigned long seq, ns;
+	unsigned long seq;
+	long ns;
  	do {
  		seq = read_seqbegin(&gtod->lock);
  		ts->tv_sec = gtod->wall_time_sec;
diff -urN linux-2.6.24.4/include/linux/clocksource.h linux/include/linux/clocksource.h
--- linux-2.6.24.4/include/linux/clocksource.h	2008-03-24 18:49:18.000000000 +0000
+++ linux/include/linux/clocksource.h	2008-03-28 11:59:05.000000000 +0000
@@ -176,11 +176,9 @@
   *
   * XXX - This could use some mult_lxl_ll() asm optimization
   */
-static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
+static inline s64 cyc2ns(struct clocksource *cs, s64 cycles)
  {
-	u64 ret = (u64)cycles;
-	ret = (ret * cs->mult) >> cs->shift;
-	return ret;
+	return (cycles * cs->mult) >> cs->shift;
  }

  /**
diff -urN linux-2.6.24.4/include/linux/time.h linux/include/linux/time.h
--- linux-2.6.24.4/include/linux/time.h	2008-03-24 18:49:18.000000000 +0000
+++ linux/include/linux/time.h	2008-03-28 11:59:06.000000000 +0000
@@ -169,13 +169,17 @@
   * @a:		pointer to timespec to be incremented
   * @ns:		unsigned nanoseconds value to be added
   */
-static inline void timespec_add_ns(struct timespec *a, u64 ns)
+static inline void timespec_add_ns(struct timespec *a, s64 ns)
  {
  	ns += a->tv_nsec;
  	while(unlikely(ns >= NSEC_PER_SEC)) {
  		ns -= NSEC_PER_SEC;
  		a->tv_sec++;
  	}
+	while(unlikely(ns < 0)) {
+		ns += NSEC_PER_SEC;
+		a->tv_sec--;
+	}
  	a->tv_nsec = ns;
  }
  #endif /* __KERNEL__ */
diff -urN linux-2.6.24.4/kernel/time/timekeeping.c linux/kernel/time/timekeeping.c
--- linux-2.6.24.4/kernel/time/timekeeping.c	2008-03-24 18:49:18.000000000 +0000
+++ linux/kernel/time/timekeeping.c	2008-03-28 12:31:48.000000000 +0000
@@ -47,7 +47,7 @@
  static unsigned long total_sleep_time;		/* seconds */

  static struct timespec xtime_cache __attribute__ ((aligned (16)));
-static inline void update_xtime_cache(u64 nsec)
+static inline void update_xtime_cache(s64 nsec)
  {
  	xtime_cache = xtime;
  	timespec_add_ns(&xtime_cache, nsec);
@@ -66,8 +66,8 @@
   */
  static inline s64 __get_nsec_offset(void)
  {
-	cycle_t cycle_now, cycle_delta;
-	s64 ns_offset;
+	cycle_t cycle_now;
+	s64 ns_offset, cycle_delta;

  	/* read clocksource: */
  	cycle_now = clocksource_read(clock);
@@ -75,6 +75,12 @@
  	/* calculate the delta since the last update_wall_time: */
  	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;

+	/* Sign-extend. */
+	if (cycle_now < clock->cycle_last)
+	{
+		cycle_delta |= ~clock->mask;
+	}
+
  	/* convert to nanoseconds: */
  	ns_offset = cyc2ns(clock, cycle_delta);

@@ -182,7 +188,7 @@
  {
  	struct clocksource *new;
  	cycle_t now;
-	u64 nsec;
+	s64 nsec;

  	new = clocksource_get_next();

@@ -455,7 +461,17 @@
  		return;

  #ifdef CONFIG_GENERIC_TIME
-	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
+	offset = clocksource_read(clock) - clock->cycle_last;
+
+	/* Mask but preserving sign. */
+	if (offset < 0)
+	{
+		offset = (offset & clock->mask) | ~clock->mask;
+	}
+	else
+	{
+		offset &= clock->mask;
+	}
  #else
  	offset = clock->cycle_interval;
  #endif
@@ -464,7 +480,7 @@
  	/* normally this loop will run just once, however in the
  	 * case of lost or late ticks, it will accumulate correctly.
  	 */
-	while (offset >= clock->cycle_interval) {
+	while (offset >= (s64)clock->cycle_interval) {
  		/* accumulate one interval */
  		clock->xtime_nsec += clock->xtime_interval;
  		clock->cycle_last += clock->cycle_interval;





-- 
Tim
Quidquid latine dictum sit, altum viditur.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764262AbYCDMMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764262AbYCDMMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbYCDMME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:12:04 -0500
Received: from ozlabs.org ([203.10.76.45]:40680 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbYCDMMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:12:02 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] lguest: sanitize the clock.
Date: Tue, 4 Mar 2008 23:11:20 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       lguest@ozlabs.org, akpm <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
References: <20080224155515.GA24831@ubuntu> <20080229195838.GB21494@elte.hu> <200803042307.51645.rusty@rustcorp.com.au>
In-Reply-To: <200803042307.51645.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803042311.21040.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the TSC code handles a zero return from calculate_cpu_khz(),
lguest can simply pass through the value it gets from the Host: if
non-zero, all the normal TSC code applies.

Otherwise (or if the Host really doesn't support TSC), the clocksource
code will fall back to the slower but reasonable lguest clock.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r f9a80502dc46 arch/x86/lguest/boot.c
--- a/arch/x86/lguest/boot.c	Tue Mar 04 21:06:41 2008 +1100
+++ b/arch/x86/lguest/boot.c	Tue Mar 04 22:55:10 2008 +1100
@@ -84,7 +84,6 @@ struct lguest_data lguest_data = {
 	.blocked_interrupts = { 1 }, /* Block timer interrupts */
 	.syscall_vec = SYSCALL_VECTOR,
 };
-static cycle_t clock_base;
 
 /*G:037 async_hcall() is pretty simple: I'm quite proud of it really.  We have a
  * ring buffer of stored hypercalls which the Host will run though next time we
@@ -327,8 +326,8 @@ static void lguest_cpuid(unsigned int *a
 	case 1:	/* Basic feature request. */
 		/* We only allow kernel to see SSE3, CMPXCHG16B and SSSE3 */
 		*cx &= 0x00002201;
-		/* SSE, SSE2, FXSR, MMX, CMOV, CMPXCHG8B, FPU. */
-		*dx &= 0x07808101;
+		/* SSE, SSE2, FXSR, MMX, CMOV, CMPXCHG8B, TSC, FPU. */
+		*dx &= 0x07808111;
 		/* The Host can do a nice optimization if it knows that the
 		 * kernel mappings (addresses above 0xC0000000 or whatever
 		 * PAGE_OFFSET is set to) haven't changed.  But Linux calls
@@ -595,19 +594,25 @@ static unsigned long lguest_get_wallcloc
 	return lguest_data.time.tv_sec;
 }
 
+/* The TSC is a Time Stamp Counter.  The Host tells us what speed it runs at,
+ * or 0 if it's unusable as a reliable clock source.  This matches what we want
+ * here: if we return 0 from this function, the x86 TSC clock will not register
+ * itself. */
+static unsigned long lguest_cpu_khz(void)
+{
+	return lguest_data.tsc_khz;
+}
+
+/* If we can't use the TSC, the kernel falls back to our "lguest_clock", where
+ * we read the time value given to us by the Host. */
 static cycle_t lguest_clock_read(void)
 {
 	unsigned long sec, nsec;
 
-	/* If the Host tells the TSC speed, we can trust that. */
-	if (lguest_data.tsc_khz)
-		return native_read_tsc();
-
-	/* If we can't use the TSC, we read the time value written by the Host.
-	 * Since it's in two parts (seconds and nanoseconds), we risk reading
-	 * it just as it's changing from 99 & 0.999999999 to 100 and 0, and
-	 * getting 99 and 0.  As Linux tends to come apart under the stress of
-	 * time travel, we must be careful: */
+	/* Since the time is in two parts (seconds and nanoseconds), we risk
+	 * reading it just as it's changing from 99 & 0.999999999 to 100 and 0,
+	 * and getting 99 and 0.  As Linux tends to come apart under the stress
+	 * of time travel, we must be careful: */
 	do {
 		/* First we read the seconds part. */
 		sec = lguest_data.time.tv_sec;
@@ -622,26 +627,20 @@ static cycle_t lguest_clock_read(void)
 		/* Now if the seconds part has changed, try again. */
 	} while (unlikely(lguest_data.time.tv_sec != sec));
 
-	/* Our non-TSC clock is in real nanoseconds. */
+	/* Our lguest clock is in real nanoseconds. */
 	return sec*1000000000ULL + nsec;
 }
 
-/* This is what we tell the kernel is our clocksource.  */
+/* This is the fallback clocksource: lower priority than the TSC clocksource. */
 static struct clocksource lguest_clock = {
 	.name		= "lguest",
-	.rating		= 400,
+	.rating		= 200,
 	.read		= lguest_clock_read,
 	.mask		= CLOCKSOURCE_MASK(64),
 	.mult		= 1 << 22,
 	.shift		= 22,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
-
-/* The "scheduler clock" is just our real clock, adjusted to start at zero */
-static unsigned long long lguest_sched_clock(void)
-{
-	return cyc2ns(&lguest_clock, lguest_clock_read() - clock_base);
-}
 
 /* We also need a "struct clock_event_device": Linux asks us to set it to go
  * off some time in the future.  Actually, James Morris figured all this out, I
@@ -712,18 +711,7 @@ static void lguest_time_init(void)
 	/* Set up the timer interrupt (0) to go to our simple timer routine */
 	set_irq_handler(0, lguest_time_irq);
 
-	/* Our clock structure looks like arch/x86/kernel/tsc_32.c if we can
-	 * use the TSC, otherwise it's a dumb nanosecond-resolution clock.
-	 * Either way, the "rating" is set so high that it's always chosen over
-	 * any other clocksource. */
-	if (lguest_data.tsc_khz)
-		lguest_clock.mult = clocksource_khz2mult(lguest_data.tsc_khz,
-							 lguest_clock.shift);
-	clock_base = lguest_clock_read();
 	clocksource_register(&lguest_clock);
-
-	/* Now we've set up our clock, we can use it as the scheduler clock */
-	pv_time_ops.sched_clock = lguest_sched_clock;
 
 	/* We can't set cpumask in the initializer: damn C limitations!  Set it
 	 * here and register our timer device. */
@@ -995,6 +983,7 @@ __init void lguest_init(void)
 	/* time operations */
 	pv_time_ops.get_wallclock = lguest_get_wallclock;
 	pv_time_ops.time_init = lguest_time_init;
+	pv_time_ops.get_cpu_khz = lguest_cpu_khz;
 
 	/* Now is a good time to look at the implementations of these functions
 	 * before returning to the rest of lguest_init(). */

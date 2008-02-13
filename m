Return-Path: <linux-kernel-owner+w=401wt.eu-S932669AbYBMJie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbYBMJie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbYBMJiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:38:17 -0500
Received: from www.tglx.de ([62.245.132.106]:52487 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbYBMJiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:38:13 -0500
Date: Wed, 13 Feb 2008 10:32:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frans Pop <elendil@planet.nl>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [stable 2.6.24] WARNING: at kernel/time/clockevents.c
In-Reply-To: <200802130947.10781.elendil@planet.nl>
Message-ID: <alpine.LFD.1.00.0802131004460.12988@apollo.tec.linutronix.de>
References: <200802101440.22118.elendil@planet.nl> <20080212230741.576b8004.akpm@linux-foundation.org> <alpine.LFD.1.00.0802130845380.12988@apollo.tec.linutronix.de> <200802130947.10781.elendil@planet.nl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Frans Pop wrote:
> On Wednesday 13 February 2008, Thomas Gleixner wrote:
> > On Tue, 12 Feb 2008, Andrew Morton wrote:
> > > On Sun, 10 Feb 2008 14:40:21 +0100 Frans Pop <elendil@planet.nl> wrote:
> > > the hrtimer code is preparing an invalid ktime_t.  Note that
> > > clockevents_program_event() actually fails when this happens - I am
> > > surprised that this is not causing observeable userspace problems.
> > >
> > > The WARN_ON_ONCE() means that you'll only see this warning once per
> > > boot. But the actually error could be happening any number of times
> > > without being reported.
> > >
> > > Looks pretty serious?
> >
> > Yes. It's the same problem, which got fixed with:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit
> >;h=62f0f61e6673e67151a7c8c0f9a09c7ea43fe2b5
> 
> OK, so probably glibc performs a unit test during build that asks for a long 
> sleep. I guess that makes sense.

Frans,

can you please apply the following patch ? I really should have
thought about that, when I fixed the above one.

Thanks,
	tglx

------------>

Subject: hrtimer: check relative timeouts for overflow
From: Thomas Gleixner <tglx@linutronix.de>

Various user space callers ask for relative timeouts. While we fixed
that overflow issue in hrtimer_start(), the sites which convert
relative user space values to absolute timeouts themself were uncovered.

Instead of putting overflow checks into each place add a function
which does the sanity checking and convert all affected callers to use
it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ktime.h |    2 ++
 kernel/futex.c        |    2 +-
 kernel/futex_compat.c |    2 +-
 kernel/hrtimer.c      |   33 ++++++++++++++++-----------------
 kernel/posix-timers.c |    8 +++++---
 5 files changed, 25 insertions(+), 22 deletions(-)

Index: linux-2.6-hrt/include/linux/ktime.h
===================================================================
--- linux-2.6-hrt.orig/include/linux/ktime.h
+++ linux-2.6-hrt/include/linux/ktime.h
@@ -310,6 +310,8 @@ static inline ktime_t ktime_sub_us(const
 	return ktime_sub_ns(kt, usec * 1000);
 }
 
+extern ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs);
+
 /*
  * The resolution of the clocks. The resolution value is returned in
  * the clock_getres() system call to give application programmers an
Index: linux-2.6-hrt/kernel/futex.c
===================================================================
--- linux-2.6-hrt.orig/kernel/futex.c
+++ linux-2.6-hrt/kernel/futex.c
@@ -2116,7 +2116,7 @@ asmlinkage long sys_futex(u32 __user *ua
 
 		t = timespec_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
-			t = ktime_add(ktime_get(), t);
+			t = ktime_add_safe(ktime_get(), t);
 		tp = &t;
 	}
 	/*
Index: linux-2.6-hrt/kernel/futex_compat.c
===================================================================
--- linux-2.6-hrt.orig/kernel/futex_compat.c
+++ linux-2.6-hrt/kernel/futex_compat.c
@@ -176,7 +176,7 @@ asmlinkage long compat_sys_futex(u32 __u
 
 		t = timespec_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
-			t = ktime_add(ktime_get(), t);
+			t = ktime_add_safe(ktime_get(), t);
 		tp = &t;
 	}
 	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
Index: linux-2.6-hrt/kernel/hrtimer.c
===================================================================
--- linux-2.6-hrt.orig/kernel/hrtimer.c
+++ linux-2.6-hrt/kernel/hrtimer.c
@@ -326,6 +326,19 @@ u64 ktime_divns(const ktime_t kt, s64 di
 #endif /* BITS_PER_LONG >= 64 */
 
 /*
+ * Add two ktime values and do a safety check for overflow:
+ */
+ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs)
+{
+	ktime_t res = ktime_add(lhs, rhs);
+
+	if (res.tv64 < 0 || res.tv64 < lhs.tv64 || res.tv64 < rhs.tv64)
+		res.tv64 = KTIME_MAX;
+
+	return res;
+}
+
+/*
  * Check, whether the timer is on the callback pending list
  */
 static inline int hrtimer_cb_pending(const struct hrtimer *timer)
@@ -682,13 +695,7 @@ u64 hrtimer_forward(struct hrtimer *time
 		 */
 		orun++;
 	}
-	timer->expires = ktime_add(timer->expires, interval);
-	/*
-	 * Make sure, that the result did not wrap with a very large
-	 * interval.
-	 */
-	if (timer->expires.tv64 < 0)
-		timer->expires = ktime_set(KTIME_SEC_MAX, 0);
+	timer->expires = ktime_add_safe(timer->expires, interval);
 
 	return orun;
 }
@@ -839,7 +846,7 @@ hrtimer_start(struct hrtimer *timer, kti
 	new_base = switch_hrtimer_base(timer, base);
 
 	if (mode == HRTIMER_MODE_REL) {
-		tim = ktime_add(tim, new_base->get_time());
+		tim = ktime_add_safe(tim, new_base->get_time());
 		/*
 		 * CONFIG_TIME_LOW_RES is a temporary way for architectures
 		 * to signal that they simply return xtime in
@@ -848,16 +855,8 @@ hrtimer_start(struct hrtimer *timer, kti
 		 * timeouts. This will go away with the GTOD framework.
 		 */
 #ifdef CONFIG_TIME_LOW_RES
-		tim = ktime_add(tim, base->resolution);
+		tim = ktime_add_safe(tim, base->resolution);
 #endif
-		/*
-		 * Careful here: User space might have asked for a
-		 * very long sleep, so the add above might result in a
-		 * negative number, which enqueues the timer in front
-		 * of the queue.
-		 */
-		if (tim.tv64 < 0)
-			tim.tv64 = KTIME_MAX;
 	}
 	timer->expires = tim;
 
Index: linux-2.6-hrt/kernel/posix-timers.c
===================================================================
--- linux-2.6-hrt.orig/kernel/posix-timers.c
+++ linux-2.6-hrt/kernel/posix-timers.c
@@ -767,9 +767,11 @@ common_timer_set(struct k_itimer *timr, 
 	/* SIGEV_NONE timers are not queued ! See common_timer_get */
 	if (((timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE)) {
 		/* Setup correct expiry time for relative timers */
-		if (mode == HRTIMER_MODE_REL)
-			timer->expires = ktime_add(timer->expires,
-						   timer->base->get_time());
+		if (mode == HRTIMER_MODE_REL) {
+			timer->expires =
+				ktime_add_safe(timer->expires,
+					       timer->base->get_time());
+		}
 		return 0;
 	}
 

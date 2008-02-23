Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbYBWAUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbYBWAUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764992AbYBWATA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:19:00 -0500
Received: from ns2.suse.de ([195.135.220.15]:53783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764789AbYBWAS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:18:57 -0500
Date: Fri, 22 Feb 2008 16:17:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 4/8] hrtimer: check relative timeouts for overflow
Message-ID: <20080223001728.GE27727@suse.de>
References: <20080223001123.939868182@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hrtimer-check-relative-timeouts-for-overflow.patch"
In-Reply-To: <20080223001702.GA27727@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit: 5a7780e725d1bb4c3094fcc12f1c5c5faea1e988

Various user space callers ask for relative timeouts. While we fixed
that overflow issue in hrtimer_start(), the sites which convert
relative user space values to absolute timeouts themself were uncovered.

Instead of putting overflow checks into each place add a function
which does the sanity checking and convert all affected callers to use
it.

Thanks to Frans Pop, who reported the problem and tested the fixes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 include/linux/ktime.h |    2 ++
 kernel/futex.c        |    2 +-
 kernel/futex_compat.c |    2 +-
 kernel/hrtimer.c      |   38 +++++++++++++++++++++-----------------
 kernel/posix-timers.c |    8 +++++---
 5 files changed, 30 insertions(+), 22 deletions(-)

--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -289,6 +289,8 @@ static inline ktime_t ktime_add_us(const
 	return ktime_add_ns(kt, usec * 1000);
 }
 
+extern ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs);
+
 /*
  * The resolution of the clocks. The resolution value is returned in
  * the clock_getres() system call to give application programmers an
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2063,7 +2063,7 @@ asmlinkage long sys_futex(u32 __user *ua
 
 		t = timespec_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
-			t = ktime_add(ktime_get(), t);
+			t = ktime_add_safe(ktime_get(), t);
 		tp = &t;
 	}
 	/*
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -175,7 +175,7 @@ asmlinkage long compat_sys_futex(u32 __u
 
 		t = timespec_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
-			t = ktime_add(ktime_get(), t);
+			t = ktime_add_safe(ktime_get(), t);
 		tp = &t;
 	}
 	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -301,6 +301,24 @@ unsigned long ktime_divns(const ktime_t 
 }
 #endif /* BITS_PER_LONG >= 64 */
 
+/*
+ * Add two ktime values and do a safety check for overflow:
+ */
+
+ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs)
+{
+	ktime_t res = ktime_add(lhs, rhs);
+
+	/*
+	 * We use KTIME_SEC_MAX here, the maximum timeout which we can
+	 * return to user space in a timespec:
+	 */
+	if (res.tv64 < 0 || res.tv64 < lhs.tv64 || res.tv64 < rhs.tv64)
+		res = ktime_set(KTIME_SEC_MAX, 0);
+
+	return res;
+}
+
 /* High resolution timer related functions */
 #ifdef CONFIG_HIGH_RES_TIMERS
 
@@ -658,13 +676,7 @@ hrtimer_forward(struct hrtimer *timer, k
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
@@ -815,7 +827,7 @@ hrtimer_start(struct hrtimer *timer, kti
 	new_base = switch_hrtimer_base(timer, base);
 
 	if (mode == HRTIMER_MODE_REL) {
-		tim = ktime_add(tim, new_base->get_time());
+		tim = ktime_add_safe(tim, new_base->get_time());
 		/*
 		 * CONFIG_TIME_LOW_RES is a temporary way for architectures
 		 * to signal that they simply return xtime in
@@ -824,16 +836,8 @@ hrtimer_start(struct hrtimer *timer, kti
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
 
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -765,9 +765,11 @@ common_timer_set(struct k_itimer *timr, 
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
 

-- 

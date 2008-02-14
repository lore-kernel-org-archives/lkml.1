Return-Path: <linux-kernel-owner+w=401wt.eu-S934009AbYBNVUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934009AbYBNVUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbYBNVUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:20:06 -0500
Received: from www.tglx.de ([62.245.132.106]:37367 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488AbYBNVUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:20:04 -0500
Date: Thu, 14 Feb 2008 22:19:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>,
       Stable Team <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] hrtimer fixes
Message-ID: <alpine.LFD.1.00.0802142120200.12988@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull hrtimer fixes from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git master

The first patch fixes an overflow problem, which is caused by missing
checks in the relative to absolute time conversion in the futex
code. It got caught by the WARN_ON() in clockevents_program_event().

The second patch prevents a false positive of the same WARN_ON().

Fixes are confirmed to solve http://lkml.org/lkml/2008/2/10/137

Thanks,

	tglx
---

Thomas Gleixner (2):
      hrtimer: check relative timeouts for overflow
      hrtimer: catch expired CLOCK_REALTIME timers early

 include/linux/ktime.h |    2 ++
 kernel/futex.c        |    2 +-
 kernel/futex_compat.c |    2 +-
 kernel/hrtimer.c      |   48 +++++++++++++++++++++++++++++++-----------------
 kernel/posix-timers.c |    8 +++++---
 5 files changed, 40 insertions(+), 22 deletions(-)
diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index 36c542b..2cd7fa7 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -310,6 +310,8 @@ static inline ktime_t ktime_sub_us(const ktime_t kt, const u64 usec)
 	return ktime_sub_ns(kt, usec * 1000);
 }
 
+extern ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs);
+
 /*
  * The resolution of the clocks. The resolution value is returned in
  * the clock_getres() system call to give application programmers an
diff --git a/kernel/futex.c b/kernel/futex.c
index a6baaec..221f212 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2116,7 +2116,7 @@ asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
 
 		t = timespec_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
-			t = ktime_add(ktime_get(), t);
+			t = ktime_add_safe(ktime_get(), t);
 		tp = &t;
 	}
 	/*
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 133d558..7d5e4b0 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -176,7 +176,7 @@ asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
 
 		t = timespec_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
-			t = ktime_add(ktime_get(), t);
+			t = ktime_add_safe(ktime_get(), t);
 		tp = &t;
 	}
 	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 3f4a57c..98bee01 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -326,6 +326,23 @@ u64 ktime_divns(const ktime_t kt, s64 div)
 #endif /* BITS_PER_LONG >= 64 */
 
 /*
+ * Add two ktime values and do a safety check for overflow:
+ */
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
+/*
  * Check, whether the timer is on the callback pending list
  */
 static inline int hrtimer_cb_pending(const struct hrtimer *timer)
@@ -425,6 +442,8 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 	ktime_t expires = ktime_sub(timer->expires, base->offset);
 	int res;
 
+	WARN_ON_ONCE(timer->expires.tv64 < 0);
+
 	/*
 	 * When the callback is running, we do not reprogram the clock event
 	 * device. The timer callback is either running on a different CPU or
@@ -435,6 +454,15 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 	if (hrtimer_callback_running(timer))
 		return 0;
 
+	/*
+	 * CLOCK_REALTIME timer might be requested with an absolute
+	 * expiry time which is less than base->offset. Nothing wrong
+	 * about that, just avoid to call into the tick code, which
+	 * has now objections against negative expiry values.
+	 */
+	if (expires.tv64 < 0)
+		return -ETIME;
+
 	if (expires.tv64 >= expires_next->tv64)
 		return 0;
 
@@ -682,13 +710,7 @@ u64 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval)
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
@@ -839,7 +861,7 @@ hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
 	new_base = switch_hrtimer_base(timer, base);
 
 	if (mode == HRTIMER_MODE_REL) {
-		tim = ktime_add(tim, new_base->get_time());
+		tim = ktime_add_safe(tim, new_base->get_time());
 		/*
 		 * CONFIG_TIME_LOW_RES is a temporary way for architectures
 		 * to signal that they simply return xtime in
@@ -848,16 +870,8 @@ hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
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
 
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 022c9c3..a9b0420 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -767,9 +767,11 @@ common_timer_set(struct k_itimer *timr, int flags,
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
 

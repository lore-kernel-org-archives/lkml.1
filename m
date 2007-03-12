Return-Path: <linux-kernel-owner+w=401wt.eu-S965415AbXCLJK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965415AbXCLJK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965410AbXCLJK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:10:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59792 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965365AbXCLJKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:10:23 -0400
Date: Mon, 12 Mar 2007 10:10:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, npiggin@suse.de,
       drepper@redhat.com, oleg@tv-sign.ru, sebastien.dugue@bull.net,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] change futex_wait() to hrtimers
Message-ID: <20070312091006.GF21024@elte.hu>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070312011259.3834A1801C4@magilla.sf.frob.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> I agree it should restart.  But I don't think this is quite right in 
> the timeout case.  It will increase the total maximum real time spent 
> arbitrarily by the amount of time elapsed in signal handlers.  Other 
> restartable, timed calls have to convert to an absolute timeout for 
> the restart block (and convert back when doing the restart).

i dont think we should try to do this. We should not and cannot do 
anything about all of the artifacts that comes with the use of relative 
timeouts and schedule_timeout().

basically, using jiffies here (which schedule_timeout() does) is 
/fundamentally/ imprecise. If you get many interrupts, rounding errors 
sum up - and there's nothing we can do about it!

the only correct approach is the use of hrtimers, and a patch exists for 
that - see below. This has been included in -rt for quite some time.

so i'd suggest for Nick to add restart processing ontop of this patch: 
hrtimers use absolute timeouts and hence there are neither rounding nor 
signal processing delay artifacts.

	Ingo

-------------->
From: S�bastien Dugu� <sebastien.dugue@bull.net>
Subject: [patch] change futex_wait() to hrtimers

This patch modifies futex_wait() to use an hrtimer + schedule() in place 
of schedule_timeout().

schedule_timeout() is tick based, therefore the timeout granularity is 
the tick (1 ms, 4 ms or 10 ms depending on HZ). By using a high 
resolution timer for timeout wakeup, we can attain a much finer timeout 
granularity (in the microsecond range). This parallels what is already 
done for futex_lock_pi().

The timeout passed to the syscall is no longer converted to jiffies and 
is therefore passed to do_futex() and futex_wait() as a timespec 
therefore keeping nanosecond resolution.

Also this removes the need to pass the nanoseconds timeout part to 
futex_lock_pi() in val2.

In futex_wait(), if the timeout is zero then a regular schedule() is 
performed. Otherwise, an hrtimer is fired before schedule() is called.

Signed-off-by: S�bastien Dugu� <sebastien.dugue@bull.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

 include/linux/futex.h | 2 -
 kernel/futex.c        |   61 +++++++++++++++++++++++++++++++++-----------------
 kernel/futex_compat.c |   11 +--------
 3 files changed, 44 insertions(+), 30 deletions(-)

Index: linux/include/linux/futex.h
===================================================================
--- linux.orig/include/linux/futex.h
+++ linux/include/linux/futex.h
@@ -94,7 +94,7 @@ struct robust_list_head {
 #define ROBUST_LIST_LIMIT	2048
 
 #ifdef __KERNEL__
-long do_futex(u32 __user *uaddr, int op, u32 val, unsigned long timeout,
+long do_futex(u32 __user *uaddr, int op, u32 val, struct timespec *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 
 extern int
Index: linux/kernel/futex.c
===================================================================
--- linux.orig/kernel/futex.c
+++ linux/kernel/futex.c
@@ -49,6 +49,7 @@
 #include <linux/syscalls.h>
 #include <linux/signal.h>
 #include <asm/futex.h>
+#include <linux/hrtimer.h>
 
 #include "rtmutex_common.h"
 
@@ -1000,7 +1001,7 @@ static void unqueue_me_pi(struct futex_q
 	drop_key_refs(&q->key);
 }
 
-static int futex_wait(u32 __user *uaddr, u32 val, unsigned long time)
+static int futex_wait(u32 __user *uaddr, u32 val, struct timespec *time)
 {
 	struct task_struct *curr = current;
 	DECLARE_WAITQUEUE(wait, curr);
@@ -1008,6 +1009,8 @@ static int futex_wait(u32 __user *uaddr,
 	struct futex_q q;
 	u32 uval;
 	int ret;
+	struct hrtimer_sleeper t;
+	int rem = 0;
 
 	q.pi_state = NULL;
  retry:
@@ -1085,8 +1088,33 @@ static int futex_wait(u32 __user *uaddr,
 	 * !list_empty() is safe here without any lock.
 	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
 	 */
-	if (likely(!list_empty(&q.list)))
-		time = schedule_timeout(time);
+	if (likely(!list_empty(&q.list))) {
+		if (time->tv_sec == 0 && time->tv_nsec == 0)
+			schedule();
+		else {
+
+			hrtimer_init(&t.timer, CLOCK_MONOTONIC,
+				     HRTIMER_MODE_REL);
+			hrtimer_init_sleeper(&t, current);
+			t.timer.expires = timespec_to_ktime(*time);
+
+			hrtimer_start(&t.timer, t.timer.expires,
+				      HRTIMER_MODE_REL);
+
+			/*
+			 * the timer could have already expired, in which
+			 * case current would be flagged for rescheduling.
+			 * Don't bother calling schedule.
+			 */
+			if (likely(t.task))
+				schedule();
+
+			hrtimer_cancel(&t.timer);
+
+			/* Flag if a timeout occured */
+			rem = (t.task == NULL);
+		}
+	}
 	__set_current_state(TASK_RUNNING);
 
 	/*
@@ -1097,7 +1125,7 @@ static int futex_wait(u32 __user *uaddr,
 	/* If we were woken (and unqueued), we succeeded, whatever. */
 	if (!unqueue_me(&q))
 		return 0;
-	if (time == 0)
+	if (rem)
 		return -ETIMEDOUT;
 	/*
 	 * We expect signal_pending(current), but another thread may
@@ -1119,8 +1147,8 @@ static int futex_wait(u32 __user *uaddr,
  * if there are waiters then it will block, it does PI, etc. (Due to
  * races the kernel might see a 0 value of the futex too.)
  */
-static int futex_lock_pi(u32 __user *uaddr, int detect, unsigned long sec,
-			 long nsec, int trylock)
+static int futex_lock_pi(u32 __user *uaddr, int detect, struct timespec *time,
+			 int trylock)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct task_struct *curr = current;
@@ -1132,11 +1160,11 @@ static int futex_lock_pi(u32 __user *uad
 	if (refill_pi_state_cache())
 		return -ENOMEM;
 
-	if (sec != MAX_SCHEDULE_TIMEOUT) {
+	if (time->tv_sec || time->tv_nsec) {
 		to = &timeout;
 		hrtimer_init(&to->timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
-		to->timer.expires = ktime_set(sec, nsec);
+		to->timer.expires = timespec_to_ktime(*time);
 	}
 
 	q.pi_state = NULL;
@@ -1772,7 +1800,7 @@ void exit_robust_list(struct task_struct
 	}
 }
 
-long do_futex(u32 __user *uaddr, int op, u32 val, unsigned long timeout,
+long do_futex(u32 __user *uaddr, int op, u32 val, struct timespec *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
 	int ret;
@@ -1798,13 +1826,13 @@ long do_futex(u32 __user *uaddr, int op,
 		ret = futex_wake_op(uaddr, uaddr2, val, val2, val3);
 		break;
 	case FUTEX_LOCK_PI:
-		ret = futex_lock_pi(uaddr, val, timeout, val2, 0);
+		ret = futex_lock_pi(uaddr, val, timeout, 0);
 		break;
 	case FUTEX_UNLOCK_PI:
 		ret = futex_unlock_pi(uaddr);
 		break;
 	case FUTEX_TRYLOCK_PI:
-		ret = futex_lock_pi(uaddr, 0, timeout, val2, 1);
+		ret = futex_lock_pi(uaddr, 0, timeout, 1);
 		break;
 	default:
 		ret = -ENOSYS;
@@ -1817,8 +1845,7 @@ asmlinkage long sys_futex(u32 __user *ua
 			  struct timespec __user *utime, u32 __user *uaddr2,
 			  u32 val3)
 {
-	struct timespec t;
-	unsigned long timeout = MAX_SCHEDULE_TIMEOUT;
+	struct timespec t = {.tv_sec=0, .tv_nsec=0};
 	u32 val2 = 0;
 
 	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
@@ -1826,12 +1853,6 @@ asmlinkage long sys_futex(u32 __user *ua
 			return -EFAULT;
 		if (!timespec_valid(&t))
 			return -EINVAL;
-		if (op == FUTEX_WAIT)
-			timeout = timespec_to_jiffies(&t) + 1;
-		else {
-			timeout = t.tv_sec;
-			val2 = t.tv_nsec;
-		}
 	}
 	/*
 	 * requeue parameter in 'utime' if op == FUTEX_REQUEUE.
@@ -1839,7 +1860,7 @@ asmlinkage long sys_futex(u32 __user *ua
 	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE)
 		val2 = (u32) (unsigned long) utime;
 
-	return do_futex(uaddr, op, val, timeout, uaddr2, val2, val3);
+	return do_futex(uaddr, op, val, &t, uaddr2, val2, val3);
 }
 
 static int futexfs_get_sb(struct file_system_type *fs_type,
Index: linux/kernel/futex_compat.c
===================================================================
--- linux.orig/kernel/futex_compat.c
+++ linux/kernel/futex_compat.c
@@ -141,8 +141,7 @@ asmlinkage long compat_sys_futex(u32 __u
 		struct compat_timespec __user *utime, u32 __user *uaddr2,
 		u32 val3)
 {
-	struct timespec t;
-	unsigned long timeout = MAX_SCHEDULE_TIMEOUT;
+	struct timespec t = {.tv_sec = 0, .tv_nsec = 0};
 	int val2 = 0;
 
 	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
@@ -150,15 +149,9 @@ asmlinkage long compat_sys_futex(u32 __u
 			return -EFAULT;
 		if (!timespec_valid(&t))
 			return -EINVAL;
-		if (op == FUTEX_WAIT)
-			timeout = timespec_to_jiffies(&t) + 1;
-		else {
-			timeout = t.tv_sec;
-			val2 = t.tv_nsec;
-		}
 	}
 	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE)
 		val2 = (int) (unsigned long) utime;
 
-	return do_futex(uaddr, op, val, timeout, uaddr2, val2, val3);
+	return do_futex(uaddr, op, val, &t, uaddr2, val2, val3);
 }

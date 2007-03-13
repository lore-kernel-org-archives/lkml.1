Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbXCMJ5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbXCMJ5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbXCMJ5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:57:04 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44331 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbXCMJ5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:57:01 -0400
Message-Id: <20070313095547.548933801@bull.net>
References: <20070313095203.154246923@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 13 Mar 2007 10:52:05 +0100
From: Pierre.Peiffer@bull.net
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, drepper@redhat.com, linux-kernel@vger.kernel.org,
       jean-pierre.dion@bull.net,
       =?ISO-8859-15?q?S=C3=A9bastien=20Dugu=C3=A9?= 
	<sebastien.dugue@bull.net>,
       Pierre Peiffer <pierre.peiffer@bull.net>
Subject: [PATCH 2.6.21-rc3-mm2 2/4] Make futex_wait() use an hrtimer for timeout
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/03/2007 10:58:46,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/03/2007 10:58:50,
	Serialize complete at 13/03/2007 10:58:50
Content-Disposition: inline; filename=futex_wait-use-hrtimer.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies futex_wait() to use an hrtimer + schedule() in place of
schedule_timeout().

  schedule_timeout() is tick based, therefore the timeout granularity is
the tick (1 ms, 4 ms or 10 ms depending on HZ). By using a high resolution
timer for timeout wakeup, we can attain a much finer timeout granularity
(in the microsecond range). This parallels what is already done for
futex_lock_pi().

  The timeout passed to the syscall is no longer converted to jiffies
and is therefore passed to do_futex() and futex_wait() as a timespec
therefore keeping nanosecond resolution.

  Also this removes the need to pass the nanoseconds timeout part to
futex_lock_pi() in val2.

  In futex_wait(), if there is no timeout then a regular schedule() is
performed. Otherwise, an hrtimer is fired before schedule() is called.

Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>
Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>

---
 include/linux/futex.h |    2 -
 kernel/futex.c        |   59 +++++++++++++++++++++++++++++++++-----------------
 kernel/futex_compat.c |   12 ++--------
 3 files changed, 43 insertions(+), 30 deletions(-)

Index: b/kernel/futex.c
===================================================================
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -998,7 +998,7 @@ static void unqueue_me_pi(struct futex_q
 	drop_futex_key_refs(&q->key);
 }
 
-static int futex_wait(u32 __user *uaddr, u32 val, unsigned long time)
+static int futex_wait(u32 __user *uaddr, u32 val, struct timespec *time)
 {
 	struct task_struct *curr = current;
 	DECLARE_WAITQUEUE(wait, curr);
@@ -1006,6 +1006,8 @@ static int futex_wait(u32 __user *uaddr,
 	struct futex_q q;
 	u32 uval;
 	int ret;
+	struct hrtimer_sleeper t;
+	int rem = 0;
 
 	q.pi_state = NULL;
  retry:
@@ -1083,8 +1085,31 @@ static int futex_wait(u32 __user *uaddr,
 	 * !plist_node_empty() is safe here without any lock.
 	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
 	 */
-	if (likely(!plist_node_empty(&q.list)))
-		time = schedule_timeout(time);
+	if (likely(!plist_node_empty(&q.list))) {
+		if (!time)
+			schedule();
+		else {
+			hrtimer_init(&t.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+			hrtimer_init_sleeper(&t, current);
+			t.timer.expires = timespec_to_ktime(*time);
+
+			hrtimer_start(&t.timer, t.timer.expires, HRTIMER_MODE_REL);
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
+
 	__set_current_state(TASK_RUNNING);
 
 	/*
@@ -1095,7 +1120,7 @@ static int futex_wait(u32 __user *uaddr,
 	/* If we were woken (and unqueued), we succeeded, whatever. */
 	if (!unqueue_me(&q))
 		return 0;
-	if (time == 0)
+	if (rem)
 		return -ETIMEDOUT;
 	/*
 	 * We expect signal_pending(current), but another thread may
@@ -1117,8 +1142,8 @@ static int futex_wait(u32 __user *uaddr,
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
@@ -1130,11 +1155,11 @@ static int futex_lock_pi(u32 __user *uad
 	if (refill_pi_state_cache())
 		return -ENOMEM;
 
-	if (sec != MAX_SCHEDULE_TIMEOUT) {
+	if (time) {
 		to = &timeout;
 		hrtimer_init(&to->timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
-		to->timer.expires = ktime_set(sec, nsec);
+		to->timer.expires = timespec_to_ktime(*time);
 	}
 
 	q.pi_state = NULL;
@@ -1770,7 +1795,7 @@ void exit_robust_list(struct task_struct
 	}
 }
 
-long do_futex(u32 __user *uaddr, int op, u32 val, unsigned long timeout,
+long do_futex(u32 __user *uaddr, int op, u32 val, struct timespec *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
 	int ret;
@@ -1796,13 +1821,13 @@ long do_futex(u32 __user *uaddr, int op,
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
@@ -1815,8 +1840,7 @@ asmlinkage long sys_futex(u32 __user *ua
 			  struct timespec __user *utime, u32 __user *uaddr2,
 			  u32 val3)
 {
-	struct timespec t;
-	unsigned long timeout = MAX_SCHEDULE_TIMEOUT;
+	struct timespec t, *tp = NULL;
 	u32 val2 = 0;
 
 	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
@@ -1824,12 +1848,7 @@ asmlinkage long sys_futex(u32 __user *ua
 			return -EFAULT;
 		if (!timespec_valid(&t))
 			return -EINVAL;
-		if (op == FUTEX_WAIT)
-			timeout = timespec_to_jiffies(&t) + 1;
-		else {
-			timeout = t.tv_sec;
-			val2 = t.tv_nsec;
-		}
+		tp = &t;
 	}
 	/*
 	 * requeue parameter in 'utime' if op == FUTEX_REQUEUE.
@@ -1837,7 +1856,7 @@ asmlinkage long sys_futex(u32 __user *ua
 	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE)
 		val2 = (u32) (unsigned long) utime;
 
-	return do_futex(uaddr, op, val, timeout, uaddr2, val2, val3);
+	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
 }
 
 static int futexfs_get_sb(struct file_system_type *fs_type,
Index: b/include/linux/futex.h
===================================================================
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -94,7 +94,7 @@ struct robust_list_head {
 #define ROBUST_LIST_LIMIT	2048
 
 #ifdef __KERNEL__
-long do_futex(u32 __user *uaddr, int op, u32 val, unsigned long timeout,
+long do_futex(u32 __user *uaddr, int op, u32 val, struct timespec *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 
 extern int
Index: b/kernel/futex_compat.c
===================================================================
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -141,8 +141,7 @@ asmlinkage long compat_sys_futex(u32 __u
 		struct compat_timespec __user *utime, u32 __user *uaddr2,
 		u32 val3)
 {
-	struct timespec t;
-	unsigned long timeout = MAX_SCHEDULE_TIMEOUT;
+	struct timespec t, *tp = NULL;
 	int val2 = 0;
 
 	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
@@ -150,15 +149,10 @@ asmlinkage long compat_sys_futex(u32 __u
 			return -EFAULT;
 		if (!timespec_valid(&t))
 			return -EINVAL;
-		if (op == FUTEX_WAIT)
-			timeout = timespec_to_jiffies(&t) + 1;
-		else {
-			timeout = t.tv_sec;
-			val2 = t.tv_nsec;
-		}
+		tp = &t;
 	}
 	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE)
 		val2 = (int) (unsigned long) utime;
 
-	return do_futex(uaddr, op, val, timeout, uaddr2, val2, val3);
+	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
 }

-- 
-- 
Pierre Peiffer

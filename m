Return-Path: <linux-kernel-owner+w=401wt.eu-S1763519AbXJRVXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763519AbXJRVXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 17:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbXJRVWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 17:22:53 -0400
Received: from www.tglx.de ([62.245.132.106]:38549 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959AbXJRVWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 17:22:52 -0400
Date: Thu, 18 Oct 2007 23:22:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Anton Blanchard <anton@samba.org>
Subject: [Git pull] hrtimer updates
Message-ID: <alpine.LFD.0.9999.0710182316570.20161@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull hrtimer updates for 2.6.24 from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git

Thanks,

	tglx
---

Anton Blanchard (2):
      hrtimer: Rework hrtimer_nanosleep to make sys_compat_nanosleep easier
      hrtimer: hook compat_sys_nanosleep up to high res timer code

 include/linux/hrtimer.h |    2 +-
 kernel/compat.c         |   57 +++++++++-------------------------------------
 kernel/hrtimer.c        |   29 +++++++++++++----------
 kernel/posix-timers.c   |   17 +++++++++++--
 4 files changed, 42 insertions(+), 63 deletions(-)

commit c70878b4e0b6cf8d2f1e46319e48e821ef4a8aba
Author: Anton Blanchard <anton@samba.org>
Date:   Mon Oct 15 16:13:56 2007 -0500

    hrtimer: hook compat_sys_nanosleep up to high res timer code
    
    Now we have high res timers on ppc64 I thought Id test them. It turns
    out compat_sys_nanosleep hasnt been converted to the hrtimer code and so
    is limited to HZ resolution.
    
    The follow patch converts compat_sys_nanosleep to use high res timers.
    
    Signed-off-by: Anton Blanchard <anton@samba.org>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/compat.c b/kernel/compat.c
index 3bae374..252a446 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -40,62 +40,27 @@ int put_compat_timespec(const struct timespec *ts, struct compat_timespec __user
 			__put_user(ts->tv_nsec, &cts->tv_nsec)) ? -EFAULT : 0;
 }
 
-static long compat_nanosleep_restart(struct restart_block *restart)
-{
-	unsigned long expire = restart->arg0, now = jiffies;
-	struct compat_timespec __user *rmtp;
-
-	/* Did it expire while we handled signals? */
-	if (!time_after(expire, now))
-		return 0;
-
-	expire = schedule_timeout_interruptible(expire - now);
-	if (expire == 0)
-		return 0;
-
-	rmtp = (struct compat_timespec __user *)restart->arg1;
-	if (rmtp) {
-		struct compat_timespec ct;
-		struct timespec t;
-
-		jiffies_to_timespec(expire, &t);
-		ct.tv_sec = t.tv_sec;
-		ct.tv_nsec = t.tv_nsec;
-		if (copy_to_user(rmtp, &ct, sizeof(ct)))
-			return -EFAULT;
-	}
-	/* The 'restart' block is already filled in */
-	return -ERESTART_RESTARTBLOCK;
-}
-
 asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
-		struct compat_timespec __user *rmtp)
+				     struct compat_timespec __user *rmtp)
 {
-	struct timespec t;
-	struct restart_block *restart;
-	unsigned long expire;
+	struct timespec tu, rmt;
+	long ret;
 
-	if (get_compat_timespec(&t, rqtp))
+	if (get_compat_timespec(&tu, rqtp))
 		return -EFAULT;
 
-	if ((t.tv_nsec >= 1000000000L) || (t.tv_nsec < 0) || (t.tv_sec < 0))
+	if (!timespec_valid(&tu))
 		return -EINVAL;
 
-	expire = timespec_to_jiffies(&t) + (t.tv_sec || t.tv_nsec);
-	expire = schedule_timeout_interruptible(expire);
-	if (expire == 0)
-		return 0;
+	ret = hrtimer_nanosleep(&tu, rmtp ? &rmt : NULL, HRTIMER_MODE_REL,
+				CLOCK_MONOTONIC);
 
-	if (rmtp) {
-		jiffies_to_timespec(expire, &t);
-		if (put_compat_timespec(&t, rmtp))
+	if (ret && rmtp) {
+		if (put_compat_timespec(&rmt, rmtp))
 			return -EFAULT;
 	}
-	restart = &current_thread_info()->restart_block;
-	restart->fn = compat_nanosleep_restart;
-	restart->arg0 = jiffies + expire;
-	restart->arg1 = (unsigned long) rmtp;
-	return -ERESTART_RESTARTBLOCK;
+
+	return ret;
 }
 
 static inline long get_compat_itimerval(struct itimerval *o,
commit 04c227140fed77587432667a574b14736a06dd7f
Author: Anton Blanchard <anton@samba.org>
Date:   Mon Oct 15 16:06:04 2007 -0500

    hrtimer: Rework hrtimer_nanosleep to make sys_compat_nanosleep easier
    
    Pull the copy_to_user out of hrtimer_nanosleep and into the callers
    (common_nsleep, sys_nanosleep) in preparation for converting
    compat_sys_nanosleep to use hrtimers.
    
    Signed-off-by: Anton Blanchard <anton@samba.org>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 540799b..7a9398e 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -300,7 +300,7 @@ hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);
 
 /* Precise sleep: */
 extern long hrtimer_nanosleep(struct timespec *rqtp,
-			      struct timespec __user *rmtp,
+			      struct timespec *rmtp,
 			      const enum hrtimer_mode mode,
 			      const clockid_t clockid);
 extern long hrtimer_nanosleep_restart(struct restart_block *restart_block);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index dc8a445..b2b2c2b 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1286,8 +1286,7 @@ static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mod
 long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 {
 	struct hrtimer_sleeper t;
-	struct timespec __user *rmtp;
-	struct timespec tu;
+	struct timespec *rmtp;
 	ktime_t time;
 
 	restart->fn = do_no_restart_syscall;
@@ -1298,14 +1297,12 @@ long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
 		return 0;
 
-	rmtp = (struct timespec __user *) restart->arg1;
+	rmtp = (struct timespec *)restart->arg1;
 	if (rmtp) {
 		time = ktime_sub(t.timer.expires, t.timer.base->get_time());
 		if (time.tv64 <= 0)
 			return 0;
-		tu = ktime_to_timespec(time);
-		if (copy_to_user(rmtp, &tu, sizeof(tu)))
-			return -EFAULT;
+		*rmtp = ktime_to_timespec(time);
 	}
 
 	restart->fn = hrtimer_nanosleep_restart;
@@ -1314,12 +1311,11 @@ long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 	return -ERESTART_RESTARTBLOCK;
 }
 
-long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
+long hrtimer_nanosleep(struct timespec *rqtp, struct timespec *rmtp,
 		       const enum hrtimer_mode mode, const clockid_t clockid)
 {
 	struct restart_block *restart;
 	struct hrtimer_sleeper t;
-	struct timespec tu;
 	ktime_t rem;
 
 	hrtimer_init(&t.timer, clockid, mode);
@@ -1335,9 +1331,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 		rem = ktime_sub(t.timer.expires, t.timer.base->get_time());
 		if (rem.tv64 <= 0)
 			return 0;
-		tu = ktime_to_timespec(rem);
-		if (copy_to_user(rmtp, &tu, sizeof(tu)))
-			return -EFAULT;
+		*rmtp = ktime_to_timespec(rem);
 	}
 
 	restart = &current_thread_info()->restart_block;
@@ -1353,7 +1347,8 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 asmlinkage long
 sys_nanosleep(struct timespec __user *rqtp, struct timespec __user *rmtp)
 {
-	struct timespec tu;
+	struct timespec tu, rmt;
+	int ret;
 
 	if (copy_from_user(&tu, rqtp, sizeof(tu)))
 		return -EFAULT;
@@ -1361,7 +1356,15 @@ sys_nanosleep(struct timespec __user *rqtp, struct timespec __user *rmtp)
 	if (!timespec_valid(&tu))
 		return -EINVAL;
 
-	return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+	ret = hrtimer_nanosleep(&tu, rmtp ? &rmt : NULL, HRTIMER_MODE_REL,
+				CLOCK_MONOTONIC);
+
+	if (ret && rmtp) {
+		if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
+			return -EFAULT;
+	}
+
+	return ret;
 }
 
 /*
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index d71ed09..d11f579 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -981,9 +981,20 @@ sys_clock_getres(const clockid_t which_clock, struct timespec __user *tp)
 static int common_nsleep(const clockid_t which_clock, int flags,
 			 struct timespec *tsave, struct timespec __user *rmtp)
 {
-	return hrtimer_nanosleep(tsave, rmtp, flags & TIMER_ABSTIME ?
-				 HRTIMER_MODE_ABS : HRTIMER_MODE_REL,
-				 which_clock);
+	struct timespec rmt;
+	int ret;
+
+	ret = hrtimer_nanosleep(tsave, rmtp ? &rmt : NULL,
+				flags & TIMER_ABSTIME ?
+				HRTIMER_MODE_ABS : HRTIMER_MODE_REL,
+				which_clock);
+
+	if (ret && rmtp) {
+		if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
+			return -EFAULT;
+	}
+
+	return ret;
 }
 
 asmlinkage long

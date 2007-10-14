Return-Path: <linux-kernel-owner+w=401wt.eu-S1764304AbXJNXUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764304AbXJNXUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 19:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759439AbXJNXUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 19:20:31 -0400
Received: from ozlabs.org ([203.10.76.45]:35223 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759930AbXJNXUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 19:20:31 -0400
Date: Sun, 14 Oct 2007 18:16:16 -0500
From: Anton Blanchard <anton@samba.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Hook compat_sys_nanosleep up to high res timer code
Message-ID: <20071014231616.GA24519@kryten>
References: <20071014215437.GF26693@kryten> <200710150028.06493.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710150028.06493.arnd@arndb.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Arnd,
 
> The code looks correct, but I think it would be nicer to change 
> hrtimer_nanosleep to take a kernel pointer and have all three
> callers (common_nsleep, sys_nanosleep and compat_sys_nanosleep)
> do the copy_to_user/put_compat_timespec in the caller.

Good idea, I had considered that but thought a larger cleanup might run
afoul of the merge rules :)

Regardless, here it is. Id appreciate a once over since it does affect
more code than the previous patch :)

Anton

--

Now we have high res timers on ppc64 I thought Id test them. It turns
out compat_sys_nanosleep hasnt been converted to the hrtimer code and so
is limited to HZ resolution.

The following patch pulls the copy_to_user out of hrtimer_nanosleep and
into the callers (common_nsleep, sys_nanosleep and compat_sys_nanosleep)
thus avoiding any set_fs(KERNEL_DS) or compat_alloc_userspace tricks.
 
Signed-off-by: Anton Blanchard <anton@samba.org>
---

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
diff --git a/kernel/compat.c b/kernel/compat.c
index 3bae374..44abfce 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -40,62 +40,26 @@ int put_compat_timespec(const struct timespec *ts, struct compat_timespec __user
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
+	ret = hrtimer_nanosleep(&tu, &rmt, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
 
-	if (rmtp) {
-		jiffies_to_timespec(expire, &t);
-		if (put_compat_timespec(&t, rmtp))
+	if (ret) {
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
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index dc8a445..095e09e 100644
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
@@ -1361,7 +1356,14 @@ sys_nanosleep(struct timespec __user *rqtp, struct timespec __user *rmtp)
 	if (!timespec_valid(&tu))
 		return -EINVAL;
 
-	return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+	ret = hrtimer_nanosleep(&tu, &rmt, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+
+	if (ret) {
+		if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
+			return -EFAULT;
+	}
+
+	return ret;
 }
 
 /*
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 7a15afb..fc7dac2 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -980,9 +980,19 @@ sys_clock_getres(const clockid_t which_clock, struct timespec __user *tp)
 static int common_nsleep(const clockid_t which_clock, int flags,
 			 struct timespec *tsave, struct timespec __user *rmtp)
 {
-	return hrtimer_nanosleep(tsave, rmtp, flags & TIMER_ABSTIME ?
+	struct timespec rmt;
+	int ret;
+
+	ret = hrtimer_nanosleep(tsave, &rmt, flags & TIMER_ABSTIME ?
 				 HRTIMER_MODE_ABS : HRTIMER_MODE_REL,
 				 which_clock);
+
+	if (ret) {
+		if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
+			return -EFAULT;
+	}
+
+	return ret;
 }
 
 asmlinkage long

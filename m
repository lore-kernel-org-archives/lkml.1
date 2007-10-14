Return-Path: <linux-kernel-owner+w=401wt.eu-S1763986AbXJNV6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763986AbXJNV6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759698AbXJNV6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:58:31 -0400
Received: from ozlabs.org ([203.10.76.45]:56037 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759534AbXJNV6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:58:30 -0400
Date: Sun, 14 Oct 2007 16:54:37 -0500
From: Anton Blanchard <anton@samba.org>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Hook compat_sys_nanosleep up to high res timer code
Message-ID: <20071014215437.GF26693@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now we have high res timers on ppc64 I thought Id test them. It turns
out compat_sys_nanosleep hasnt been converted to the hrtimer code and so
is limited to HZ resolution.

The following patch makes compat_sys_nanosleep call hrtimer_nanosleep
and uses compat_alloc_user_space to avoid setting KERNEL_DS.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/kernel/compat.c b/kernel/compat.c
index 3bae374..46795ac 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -40,62 +40,29 @@ int put_compat_timespec(const struct timespec *ts, struct compat_timespec __user
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
+	struct timespec tu;
+	struct timespec __user *rmtp64;
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
+	rmtp64 = compat_alloc_user_space(sizeof(*rmtp64));
+	ret = hrtimer_nanosleep(&tu, rmtp64, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
 
-	if (rmtp) {
-		jiffies_to_timespec(expire, &t);
-		if (put_compat_timespec(&t, rmtp))
+	if (ret) {
+		if (copy_from_user(&tu, rmtp64, sizeof(*rmtp64)) ||
+		    put_compat_timespec(&tu, rmtp))
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

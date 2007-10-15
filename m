Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbXJOGnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbXJOGnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 02:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbXJOGnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 02:43:07 -0400
Received: from ozlabs.org ([203.10.76.45]:60171 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646AbXJOGnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 02:43:06 -0400
Date: Mon, 15 Oct 2007 01:38:33 -0500
From: Anton Blanchard <anton@samba.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Rework hrtimer_nanosleep to make sys_compat_nanosleep
	easier
Message-ID: <20071015063833.GA15396@kryten>
References: <20071014215437.GF26693@kryten> <200710150028.06493.arnd@arndb.de> <20071014231616.GA24519@kryten> <alpine.LFD.0.9999.0710150804290.22612@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0710150804290.22612@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

Thanks for the review, updates to follow.

Anton

--

Pull the copy_to_user out of hrtimer_nanosleep and into the callers
(common_nsleep, sys_nanosleep) in preparation for converting
compat_sys_nanosleep to use hrtimers.

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
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index dc8a445..129fead 100644
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
+	if (ret && rmtp) {
+		if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
+			return -EFAULT;
+	}
+
+	return ret;
 }
 
 /*
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 57efe04..cce8c75 100644
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
+	if (ret && rmtp) {
+		if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
+			return -EFAULT;
+	}
+
+	return ret;
 }
 
 asmlinkage long

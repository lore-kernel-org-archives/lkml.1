Return-Path: <linux-kernel-owner+w=401wt.eu-S937349AbYBWApq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937349AbYBWApq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760026AbYBWAfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:35:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934051AbYBWAf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:35:28 -0500
Date: Fri, 22 Feb 2008 16:31:09 -0800
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
       Oleg Nesterov <oleg@tv-sign.ru>, Alexey Dobriyan <adobriyan@sw.ru>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Pavel Emelyanov <xemul@sw.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Toyo Abe <toyoa@mvista.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 25/38] hrtimer: fix *rmtp handling in hrtimer_nanosleep()
Message-ID: <20080223003109.GZ7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hrtimer-fix-rmtp-handling-in-hrtimer_nanosleep.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Oleg Nesterov <oleg@tv-sign.ru>

commit 080344b98805553f9b01de0f59a41b1533036d8d

Spotted by Pavel Emelyanov and Alexey Dobriyan.

hrtimer_nanosleep() sets restart_block->arg1 = rmtp, but this rmtp points to
the local variable which lives in the caller's stack frame. This means that
if sys_restart_syscall() actually happens and it is interrupted as well, we
don't update the user-space variable, but write into the already dead stack
frame.

Introduced by commit 04c227140fed77587432667a574b14736a06dd7f
hrtimer: Rework hrtimer_nanosleep to make sys_compat_nanosleep easier

Change the callers to pass "__user *rmtp" to hrtimer_nanosleep(), and change
hrtimer_nanosleep() to use copy_to_user() to actually update *rmtp.

Small problem remains. man 2 nanosleep states that *rtmp should be written if
nanosleep() was interrupted (it says nothing whether it is OK to update *rmtp
if nanosleep returns 0), but (with or without this patch) we can dirty *rem
even if nanosleep() returns 0.

NOTE: this patch doesn't change compat_sys_nanosleep(), because it has other
bugs. Fixed by the next patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Pavel Emelyanov <xemul@sw.ru>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Toyo Abe <toyoa@mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/hrtimer.h |    2 -
 kernel/hrtimer.c        |   51 +++++++++++++++++++++++++-----------------------
 kernel/posix-timers.c   |   17 ++--------------
 3 files changed, 31 insertions(+), 39 deletions(-)

--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -300,7 +300,7 @@ hrtimer_forward(struct hrtimer *timer, k
 
 /* Precise sleep: */
 extern long hrtimer_nanosleep(struct timespec *rqtp,
-			      struct timespec *rmtp,
+			      struct timespec __user *rmtp,
 			      const enum hrtimer_mode mode,
 			      const clockid_t clockid);
 extern long hrtimer_nanosleep_restart(struct restart_block *restart_block);
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1291,11 +1291,26 @@ static int __sched do_nanosleep(struct h
 	return t->task == NULL;
 }
 
+static int update_rmtp(struct hrtimer *timer, struct timespec __user *rmtp)
+{
+	struct timespec rmt;
+	ktime_t rem;
+
+	rem = ktime_sub(timer->expires, timer->base->get_time());
+	if (rem.tv64 <= 0)
+		return 0;
+	rmt = ktime_to_timespec(rem);
+
+	if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
+		return -EFAULT;
+
+	return 1;
+}
+
 long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 {
 	struct hrtimer_sleeper t;
-	struct timespec *rmtp;
-	ktime_t time;
+	struct timespec __user  *rmtp;
 
 	restart->fn = do_no_restart_syscall;
 
@@ -1305,12 +1320,11 @@ long __sched hrtimer_nanosleep_restart(s
 	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
 		return 0;
 
-	rmtp = (struct timespec *)restart->arg1;
+	rmtp = (struct timespec __user *)restart->arg1;
 	if (rmtp) {
-		time = ktime_sub(t.timer.expires, t.timer.base->get_time());
-		if (time.tv64 <= 0)
-			return 0;
-		*rmtp = ktime_to_timespec(time);
+		int ret = update_rmtp(&t.timer, rmtp);
+		if (ret <= 0)
+			return ret;
 	}
 
 	restart->fn = hrtimer_nanosleep_restart;
@@ -1319,12 +1333,11 @@ long __sched hrtimer_nanosleep_restart(s
 	return -ERESTART_RESTARTBLOCK;
 }
 
-long hrtimer_nanosleep(struct timespec *rqtp, struct timespec *rmtp,
+long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 		       const enum hrtimer_mode mode, const clockid_t clockid)
 {
 	struct restart_block *restart;
 	struct hrtimer_sleeper t;
-	ktime_t rem;
 
 	hrtimer_init(&t.timer, clockid, mode);
 	t.timer.expires = timespec_to_ktime(*rqtp);
@@ -1336,10 +1349,9 @@ long hrtimer_nanosleep(struct timespec *
 		return -ERESTARTNOHAND;
 
 	if (rmtp) {
-		rem = ktime_sub(t.timer.expires, t.timer.base->get_time());
-		if (rem.tv64 <= 0)
-			return 0;
-		*rmtp = ktime_to_timespec(rem);
+		int ret = update_rmtp(&t.timer, rmtp);
+		if (ret <= 0)
+			return ret;
 	}
 
 	restart = &current_thread_info()->restart_block;
@@ -1355,8 +1367,7 @@ long hrtimer_nanosleep(struct timespec *
 asmlinkage long
 sys_nanosleep(struct timespec __user *rqtp, struct timespec __user *rmtp)
 {
-	struct timespec tu, rmt;
-	int ret;
+	struct timespec tu;
 
 	if (copy_from_user(&tu, rqtp, sizeof(tu)))
 		return -EFAULT;
@@ -1364,15 +1375,7 @@ sys_nanosleep(struct timespec __user *rq
 	if (!timespec_valid(&tu))
 		return -EINVAL;
 
-	ret = hrtimer_nanosleep(&tu, rmtp ? &rmt : NULL, HRTIMER_MODE_REL,
-				CLOCK_MONOTONIC);
-
-	if (ret && rmtp) {
-		if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
-			return -EFAULT;
-	}
-
-	return ret;
+	return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
 }
 
 /*
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -981,20 +981,9 @@ sys_clock_getres(const clockid_t which_c
 static int common_nsleep(const clockid_t which_clock, int flags,
 			 struct timespec *tsave, struct timespec __user *rmtp)
 {
-	struct timespec rmt;
-	int ret;
-
-	ret = hrtimer_nanosleep(tsave, rmtp ? &rmt : NULL,
-				flags & TIMER_ABSTIME ?
-				HRTIMER_MODE_ABS : HRTIMER_MODE_REL,
-				which_clock);
-
-	if (ret && rmtp) {
-		if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
-			return -EFAULT;
-	}
-
-	return ret;
+	return hrtimer_nanosleep(tsave, rmtp, flags & TIMER_ABSTIME ?
+				 HRTIMER_MODE_ABS : HRTIMER_MODE_REL,
+				 which_clock);
 }
 
 asmlinkage long

-- 

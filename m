Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbYB2OAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbYB2OAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYB2OAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:00:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38532 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbYB2OAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:00:41 -0500
Date: Fri, 29 Feb 2008 15:00:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: huggie@earth.li, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080229140024.GA26342@elte.hu>
References: <20080229115256.GG24533@paranoidfreak.co.uk> <20080229133433.GA15532@elte.hu> <20080229135137.GA23781@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229135137.GA23781@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> alternatively, instead of applying the first patch, could you apply 
> the patch below instead? This makes "msleep()" much more precise. Does 
> this help in the HZ != 1000 case?

ok, this had a build failure - use the one below instead.

	Ingo

-------------->
Subject: hrtimers: use hrtimers so that msleep() sleeps for the requested time
From: Jonathan Corbet <corbet@lwn.net>

The problem being addressed here is that the current msleep() will stop
for a minimum of two jiffies, meaning that, on a HZ=100 system,
msleep(1) delays for for about 20ms.  In a driver with one such delay
for each of 150 or so register setting operations, the extra time adds
up to a few seconds.

This patch addresses the situation by using hrtimers.  On tickless
systems with working timers, msleep(1) now sleeps for 1ms, even with
HZ=100.

Most comments last time were favorable.  The one dissenter was Roman,
who worries about the overhead of using hrtimers for this operation; my
understanding is that he would rather see a really_msleep() function for
those who actually want millisecond resolution.  I'm not sure how to
characterize what the cost could be, but it can only be buried by the
fact that every call sleeps for some number of milliseconds.  On my
system, the several hundred total msleep() calls can't cause any real
overhead, and almost all happen at initialization time.

I still think it would be useful for msleep() to do what it says it does
and not vastly oversleep with small arguments.  A quick grep turns up
450 msleep(1) calls in the current mainline.  Andrew, if you agree, can
you drop this into -mm?  If not, I guess I'll let it go.

Current msleep() snoozes for at least two jiffies, causing msleep(1) to
sleep for at least 20ms on HZ=100 systems.  Using hrtimers allows
msleep() to sleep for something much closer to the requested time.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/proc/proc_misc.c |    4 ++--
 fs/select.c         |    6 ++++--
 kernel/timer.c      |   47 ++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 44 insertions(+), 13 deletions(-)

Index: linux/fs/proc/proc_misc.c
===================================================================
--- linux.orig/fs/proc/proc_misc.c
+++ linux/fs/proc/proc_misc.c
@@ -115,9 +115,9 @@ static int uptime_read_proc(char *page, 
 	cputime_to_timespec(idletime, &idle);
 	len = sprintf(page,"%lu.%02lu %lu.%02lu\n",
 			(unsigned long) uptime.tv_sec,
-			(uptime.tv_nsec / (NSEC_PER_SEC / 100)),
+			(uptime.tv_nsec / (unsigned long)(NSEC_PER_SEC / 100)),
 			(unsigned long) idle.tv_sec,
-			(idle.tv_nsec / (NSEC_PER_SEC / 100)));
+			(idle.tv_nsec / (unsigned long)(NSEC_PER_SEC / 100)));
 
 	return proc_calc_metrics(page, start, off, count, eof, len);
 }
Index: linux/fs/select.c
===================================================================
--- linux.orig/fs/select.c
+++ linux/fs/select.c
@@ -446,7 +446,8 @@ asmlinkage long sys_pselect7(int n, fd_s
 		if ((u64)ts.tv_sec >= (u64)MAX_INT64_SECONDS)
 			timeout = -1;	/* infinite */
 		else {
-			timeout = DIV_ROUND_UP(ts.tv_nsec, NSEC_PER_SEC/HZ);
+			timeout = DIV_ROUND_UP(ts.tv_nsec,
+					       (unsigned long)NSEC_PER_SEC/HZ);
 			timeout += ts.tv_sec * HZ;
 		}
 	}
@@ -777,7 +778,8 @@ asmlinkage long sys_ppoll(struct pollfd 
 		if ((u64)ts.tv_sec >= (u64)MAX_INT64_SECONDS)
 			timeout = -1;	/* infinite */
 		else {
-			timeout = DIV_ROUND_UP(ts.tv_nsec, NSEC_PER_SEC/HZ);
+			timeout = DIV_ROUND_UP(ts.tv_nsec,
+					       (unsigned long)NSEC_PER_SEC/HZ);
 			timeout += ts.tv_sec * HZ;
 		}
 	}
Index: linux/kernel/timer.c
===================================================================
--- linux.orig/kernel/timer.c
+++ linux/kernel/timer.c
@@ -1368,18 +1368,43 @@ void __init init_timers(void)
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq, NULL);
 }
 
+
+
+
+static void do_msleep(unsigned int msecs, struct hrtimer_sleeper *sleeper,
+	int sigs)
+{
+	enum hrtimer_mode mode = HRTIMER_MODE_REL;
+	int state = sigs ? TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE;
+
+	/*
+	 * This is really just a reworked and simplified version
+	 * of do_nanosleep().
+	 */
+	hrtimer_init(&sleeper->timer, CLOCK_MONOTONIC, mode);
+	sleeper->timer.expires = ktime_set(0, msecs*NSEC_PER_MSEC);
+	hrtimer_init_sleeper(sleeper, current);
+
+	do {
+		set_current_state(state);
+		hrtimer_start(&sleeper->timer, sleeper->timer.expires, mode);
+		if (sleeper->task)
+			schedule();
+		hrtimer_cancel(&sleeper->timer);
+		mode = HRTIMER_MODE_ABS;
+	} while (sleeper->task && !(sigs && signal_pending(current)));
+}
+
 /**
  * msleep - sleep safely even with waitqueue interruptions
  * @msecs: Time in milliseconds to sleep for
  */
 void msleep(unsigned int msecs)
 {
-	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
+	struct hrtimer_sleeper sleeper;
 
-	while (timeout)
-		timeout = schedule_timeout_uninterruptible(timeout);
+	do_msleep(msecs, &sleeper, 0);
 }
-
 EXPORT_SYMBOL(msleep);
 
 /**
@@ -1388,11 +1413,15 @@ EXPORT_SYMBOL(msleep);
  */
 unsigned long msleep_interruptible(unsigned int msecs)
 {
-	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
+	struct hrtimer_sleeper sleeper;
+	ktime_t left;
 
-	while (timeout && !signal_pending(current))
-		timeout = schedule_timeout_interruptible(timeout);
-	return jiffies_to_msecs(timeout);
-}
+	do_msleep(msecs, &sleeper, 1);
 
+	if (!sleeper.task)
+		return 0;
+	left = ktime_sub(sleeper.timer.expires,
+			 sleeper.timer.base->get_time());
+	return max(((long) ktime_to_ns(left))/(long)NSEC_PER_MSEC, 1L);
+}
 EXPORT_SYMBOL(msleep_interruptible);

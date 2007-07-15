Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbXGOWmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbXGOWmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 18:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbXGOWmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 18:42:45 -0400
Received: from vena.lwn.net ([206.168.112.25]:38861 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbXGOWmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 18:42:45 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH/RFC] msleep() with hrtimers
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
From: Jonathan Corbet <corbet@lwn.net>
Date: Sun, 15 Jul 2007 16:42:44 -0600
Message-ID: <19044.1184539364@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The OLPC folks and I recently discovered something interesting: on a
HZ=100 system, a call to msleep(1) will delay for about 20ms.  The
combination of jiffies timekeeping and rounding up means that the
minimum delay from msleep will be two jiffies, never less.  That led to
multi-second delays in a driver which does a bunch of short msleep()
calls and, in response, a change to mdelay(), which will come back in
something closer to the requested time.

Here's another approach: a reimplementation of msleep() and
msleep_interruptible() using hrtimers.  On a system without real
hrtimers this code will at least drop down to single-jiffy delays much
of the time (though not deterministically so).  On my x86_64 system with
Thomas's hrtimer/dyntick patch applied, msleep(1) gives almost exactly
what was asked for.

jon

Use hrtimers for msleep() and msleep_interruptible()

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

--- 2.6.22-vanilla/kernel/timer.c	2007-07-15 13:08:36.000000000 -0600
+++ 2.6.22-timer/kernel/timer.c	2007-07-15 16:13:34.000000000 -0600
@@ -1522,18 +1522,43 @@ unregister_time_interpolator(struct time
 }
 #endif /* CONFIG_TIME_INTERPOLATION */
 
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
@@ -1542,11 +1567,15 @@ EXPORT_SYMBOL(msleep);
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
 
+	if (! sleeper.task)
+		return 0;
+	left = ktime_sub(sleeper.timer.expires,
+			 sleeper.timer.base->get_time());
+	return max(((long) ktime_to_ns(left))/NSEC_PER_MSEC, 1L);
+}
 EXPORT_SYMBOL(msleep_interruptible);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbXCYMXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbXCYMXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXCYMXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:23:49 -0400
Received: from www.osadl.org ([213.239.205.134]:56545 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753350AbXCYMXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:23:48 -0400
Subject: [PATCH] dynticks: fix hrtimer rounding error in
	next_timer_interrupt
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Emil Karlson <jkarlson@cc.hut.fi>
In-Reply-To: <1174744046.10840.428.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
	 <1174677724.10840.328.camel@localhost.localdomain>
	 <1174744046.10840.428.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 14:31:17 +0200
Message-Id: <1174825877.10840.509.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The rework of next_timer_interrupt() fixed the timer wheel bugs, but
invented a rounding error versus the next hrtimer event. This is caused
by the conversion of the hrtimer internal representation to relative
jiffies.

This causes bug #8100:
http://bugzilla.kernel.org/show_bug.cgi?id=8100

next_timer_interrupt() returns "now" in such a case and causes the code
in tick_nohz_stop_sched_tick() to trigger the timer softirq, which is
bogus as no timer is due for expiry. This results in an endless context
switching between idle and ksoftirqd until a timer is due for expiry.

Modify the hrtimer evaluation so that, it returns now + 1, when the
conversion results in a delta < 1 jiffie. 

It's confirmed to resolve bug #8100

Reported-by: Emil Karlson <jkarlson@cc.hut.fi>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/timer.c b/kernel/timer.c
index 797cccb..440048a 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -695,15 +695,28 @@ static unsigned long cmp_next_hrtimer_event(unsigned long now,
 {
 	ktime_t hr_delta = hrtimer_get_next_event();
 	struct timespec tsdelta;
+	unsigned long delta;
 
 	if (hr_delta.tv64 == KTIME_MAX)
 		return expires;
 
-	if (hr_delta.tv64 <= TICK_NSEC)
-		return now;
+	/*
+	 * Expired timer available, let it expire in the next tick
+	 */
+	if (hr_delta.tv64 <= 0)
+		return now + 1;
 
 	tsdelta = ktime_to_timespec(hr_delta);
-	now += timespec_to_jiffies(&tsdelta);
+	delta = timespec_to_jiffies(&tsdelta);
+	/*
+	 * Take rounding errors in to account and make sure, that it
+	 * expires in the next tick. Otherwise we go into an endless
+	 * ping pong due to tick_nohz_stop_sched_tick() retriggering
+	 * the timer softirq
+	 */
+	if (delta < 1)
+		delta = 1;
+	now += delta;
 	if (time_before(now, expires))
 		return now;
 	return expires;



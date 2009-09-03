Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbZICRsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbZICRsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZICRsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:48:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45951 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbZICRsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:48:19 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5730"; a="23073523"
Message-ID: <4AA00165.90609@codeaurora.org>
Date: Thu, 03 Sep 2009 13:48:21 -0400
From: Ashwin Chaugule <ashwinc@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC] [PATCH 1/1] hrtimers: Cache next hrtimer
References: <4A96FFE9.6060105@codeaurora.org> <4A970103.7010804@codeaurora.org> <alpine.LFD.2.00.0908280045200.2888@localhost.localdomain> <4A971245.5070507@codeaurora.org> <alpine.LFD.2.00.0908280111260.2888@localhost.localdomain> <4A9771AA.2090004@codeaurora.org> <alpine.LFD.2.00.0908281308380.2888@localhost.localdomain> <4A98070D.1050308@codeaurora.org> <alpine.LFD.2.00.0908282005410.19335@localhost.localdomain> <4A9A1701.2070703@codeaurora.org> <alpine.LFD.2.00.0908301016230.19335@localhost.localdomain> <4A9B4ECB.7070506@codeaurora.org> <alpine.LFD.2.00.0908310854020.19335@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908310854020.19335@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

>>>   
>>>       
>> This looks very good ! Our results are almost similar now. However, I think
>> that with this new
>> patch we're still arming the timer needlessly at least once. This is the
>> case when we're trying to remove the first (oldest) hrtimer with
>> timer->expires = cpu->expires_next, but we forgo the reprogramming, when we
>> really shouldn't. At this point, with the current scheme of things, we will
>> needlessly wakeup and simply correct the expires_next value by
>> traversing up the rbtree, to the parent node.
>>     
>
> That only happens, when that timer is the last one in both trees. Then
> the resulting reprogramming value is KTIME_MAX and we skip the
> reprogramming. That's easy to fix by removing the KTIME_MAX check.
>  
>   
Thinking more about this, I realized that the said case is already taken 
care of by hrtimer_interrupt. We have a while loop there which will traverse
to the parents on both trees and get the correct expires_next value.

In the case in remove_hrtimer, we actually don't want to reprogram the device,
because, the base->first node on the other tree with timer->expires = cpu->expires_next
hasn't expired yet.

Attached final patch here. Is this okay with you ?


>From 867753d2300c358e2a980b70b26beaee40efaf9f Mon Sep 17 00:00:00 2001
From: Ashwin Chaugule <ashwinc@quicinc.com>
Date: Tue, 1 Sep 2009 23:03:33 -0400


	hrtimer: Eliminate needless reprogramming of clock events
 	device.

	On NOHZ systems the following timers,

	-  tick_nohz_restart_sched_tick (tick_sched_timer)
	-  hrtimer_start (tick_sched_timer)

	were reprogramming the clock events device far more often than needed.
	No specific test case was required to observe this effect. This
	occurred because, there was no check to see if the currently removed
	or restarted hrtimer was:

	1) the one which previously armed the clock events device.
	2) going to be replaced by another timer which has the same expiry time.

	This patch avoids the extra programming and results in faster application
 	startup time by ~4% amongst other benefits.

	modified:   kernel/hrtimer.c

	[tglx: simplified code]

	Signed-off-by: Ashwin Chaugule <ashwinc@quicinc.com>
---
 kernel/hrtimer.c |   53 +++++++++++++++++++++++++++++++++++------------------
 1 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 49da79a..24c8cc3 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -4,6 +4,7 @@
  *  Copyright(C) 2005-2006, Thomas Gleixner <tglx@linutronix.de>
  *  Copyright(C) 2005-2007, Red Hat, Inc., Ingo Molnar
  *  Copyright(C) 2006-2007  Timesys Corp., Thomas Gleixner
+ *  Copyright(C) 2009 Code Aurora Forum., Ashwin Chaugule
  *
  *  High-resolution kernel timers
  *
@@ -542,13 +543,14 @@ static inline int hrtimer_hres_active(void)
  * next event
  * Called with interrupts disabled and base->lock held
  */
-static void hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base)
+static void
+hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 {
 	int i;
 	struct hrtimer_clock_base *base = cpu_base->clock_base;
-	ktime_t expires;
+	ktime_t expires, expires_next;
 
-	cpu_base->expires_next.tv64 = KTIME_MAX;
+	expires_next.tv64 = KTIME_MAX;
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
 		struct hrtimer *timer;
@@ -564,10 +566,15 @@ static void hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base)
 		 */
 		if (expires.tv64 < 0)
 			expires.tv64 = 0;
-		if (expires.tv64 < cpu_base->expires_next.tv64)
-			cpu_base->expires_next = expires;
+		if (expires.tv64 < expires_next.tv64)
+			expires_next = expires;
 	}
 
+	if (skip_equal && expires_next.tv64 == cpu_base->expires_next.tv64)
+		return;
+
+	cpu_base->expires_next.tv64 = expires_next.tv64;
+
 	if (cpu_base->expires_next.tv64 != KTIME_MAX)
 		tick_program_event(cpu_base->expires_next, 1);
 }
@@ -650,7 +657,7 @@ static void retrigger_next_event(void *arg)
 	base->clock_base[CLOCK_REALTIME].offset =
 		timespec_to_ktime(realtime_offset);
 
-	hrtimer_force_reprogram(base);
+	hrtimer_force_reprogram(base, 0);
 	spin_unlock(&base->lock);
 }
 
@@ -763,7 +770,8 @@ static int hrtimer_switch_to_hres(void)
 static inline int hrtimer_hres_active(void) { return 0; }
 static inline int hrtimer_is_hres_enabled(void) { return 0; }
 static inline int hrtimer_switch_to_hres(void) { return 0; }
-static inline void hrtimer_force_reprogram(struct hrtimer_cpu_base *base) { }
+static inline void
+hrtimer_force_reprogram(struct hrtimer_cpu_base *base, int skip_equal) { }
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 					    struct hrtimer_clock_base *base,
 					    int wakeup)
@@ -906,19 +914,28 @@ static void __remove_hrtimer(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base,
 			     unsigned long newstate, int reprogram)
 {
-	if (timer->state & HRTIMER_STATE_ENQUEUED) {
-		/*
-		 * Remove the timer from the rbtree and replace the
-		 * first entry pointer if necessary.
-		 */
-		if (base->first == &timer->node) {
-			base->first = rb_next(&timer->node);
-			/* Reprogram the clock event device. if enabled */
-			if (reprogram && hrtimer_hres_active())
-				hrtimer_force_reprogram(base->cpu_base);
+	ktime_t expires;
+
+	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
+		goto out;
+
+	/*
+	 * Remove the timer from the rbtree and replace the first
+	 * entry pointer if necessary.
+	 */
+	if (base->first == &timer->node) {
+		base->first = rb_next(&timer->node);
+		/* Reprogram the clock event device. if enabled */
+		if (reprogram && hrtimer_hres_active()) {
+			expires = ktime_sub(hrtimer_get_expires(timer),
+					    base->offset);
+			if (base->cpu_base->expires_next.tv64 == expires.tv64)
+				hrtimer_force_reprogram(base->cpu_base, 1);
 		}
-		rb_erase(&timer->node, &base->active);
 	}
+
+	rb_erase(&timer->node, &base->active);
+out:
 	timer->state = newstate;
 }
 
-- 
1.5.6.3


Cheers,
Ashwin


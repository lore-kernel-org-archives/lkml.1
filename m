Return-Path: <linux-kernel-owner+w=401wt.eu-S1751916AbZH1F46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbZH1F46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 01:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZH1F45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 01:56:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19757 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbZH1F45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 01:56:57 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5722"; a="22774557"
Message-ID: <4A9771AA.2090004@codeaurora.org>
Date: Fri, 28 Aug 2009 01:56:58 -0400
From: Ashwin Chaugule <ashwinc@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC] [PATCH 1/1] hrtimers: Cache next hrtimer
References: <4A96FFE9.6060105@codeaurora.org> <4A970103.7010804@codeaurora.org> <alpine.LFD.2.00.0908280045200.2888@localhost.localdomain> <4A971245.5070507@codeaurora.org> <alpine.LFD.2.00.0908280111260.2888@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908280111260.2888@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> Hmm. That's related to NOHZ I guess. Ok, that's a serious issue and we
> need to look at that.
>   
Yes. I'm running with NOHZ.

>> So, you suggest checking the ktime of the hrtimer thats about to expire and
>> compare it with expires_next ?
>>     
>
> What's wrong with that ?
>   
Nothing :) 

Just didn't know the following could have the same effect. (base->offset is confusing)

+	expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+	if (base->cpu_base->expires_next.tv64 == expires.tv64)



> Can you reevaluate against my patch please ?
>
>   

The avg. startup time with your patch came to: 26.4 sec (10 runs) as against 25.8 sec (my patch).

To calculate the hit ratio, I made some changes to your code as shown below.

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 49da79a..91d099c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -906,19 +906,30 @@ static void __remove_hrtimer(struct hrtimer *timer,
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
-		}
-		rb_erase(&timer->node, &base->active);
-	}
+	ktime_t expires;
+
+	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
+		goto out;
+
+	/*
+	 * Remove the timer from the rbtree and replace the first
+	 * entry pointer if necessary.
+	 */
+	rb_erase(&timer->node, &base->active);
+
+	if (base->first != &timer->node)
+		goto out;
+
+	base->first = rb_next(&timer->node);
+	/* Reprogram the clock event device. if enabled */
+	if (!reprogram || !hrtimer_hres_active())
+		goto out;

	else
		timer->total_calls++

+
+	expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+	if (base->cpu_base->expires_next.tv64 == expires.tv64)
		{

			timer->cache_hits++

			hrtimer_force_reprogram(base->cpu_base);
		}
+
+out:
 	timer->state = newstate;
 }



So basically, total_count is the number of times the reprogram would have been forced, cache_hit is number of times it is reduced to.
In my patch I had these counters as follows:


@@ -858,10 +858,18 @@ static void __remove_hrtimer(struct hrtimer *timer,
 		 */
 		if (base->first == &timer->node) {
 			base->first = rb_next(&timer->node);
+#ifdef CONFIG_TIMER_STATS
+			if (reprogram && hrtimer_hres_active())
+				timer->total_calls++;
+#endif
 			if (next_hrtimer == timer) {
 				/* Reprogram the clock event device. if enabled */
-				if (reprogram && hrtimer_hres_active())
+				if (reprogram && hrtimer_hres_active()) {
 					hrtimer_force_reprogram(base->cpu_base);
+#ifdef CONFIG_TIMER_STATS
+					timer->cache_hits++;
+#endif
+				}


Both counters are init'd to 0 in hrtimer_init_hres(timer).

Your patch looks perfect but, total_calls is always equal to cache_hits ?! IOW, the timer we're removing is always the next one to expire, hence we see no benefit.



Cheers,
Ashwin






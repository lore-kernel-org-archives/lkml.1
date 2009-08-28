Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbZH1LRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbZH1LRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 07:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZH1LRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 07:17:24 -0400
Received: from www.tglx.de ([62.245.132.106]:51018 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbZH1LRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 07:17:23 -0400
Date: Fri, 28 Aug 2009 13:17:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ashwin Chaugule <ashwinc@codeaurora.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC] [PATCH 1/1] hrtimers: Cache next hrtimer
In-Reply-To: <4A9771AA.2090004@codeaurora.org>
Message-ID: <alpine.LFD.2.00.0908281308380.2888@localhost.localdomain>
References: <4A96FFE9.6060105@codeaurora.org> <4A970103.7010804@codeaurora.org> <alpine.LFD.2.00.0908280045200.2888@localhost.localdomain> <4A971245.5070507@codeaurora.org> <alpine.LFD.2.00.0908280111260.2888@localhost.localdomain>
 <4A9771AA.2090004@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, Ashwin Chaugule wrote:
> Thomas Gleixner wrote:
> Just didn't know the following could have the same effect. (base->offset is
> confusing)

It's simple. We have CLOCK_MONOTONIC and CLOCK_REALTIME. The internal
time base is CLOCK_MONOTONIC. So we use base->offset to convert
CLOCK_REALTIME to CLOCK_MONOTONIC. In case the timer is
CLOCK_MONOTONIC we so the substraction as well, but it simply
subtracts 0 :)
 
> +	/*
> +	 * Remove the timer from the rbtree and replace the first
> +	 * entry pointer if necessary.
> +	 */
> +	rb_erase(&timer->node, &base->active);
> +
> +	if (base->first != &timer->node)
> +		goto out;
> +
> +	base->first = rb_next(&timer->node);

Gah. Looking at the patch with an awake brain makes me feel
stupid. Working version below.

Thanks,

	tglx
---
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 49da79a..380682b 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -906,19 +906,28 @@ static void __remove_hrtimer(struct hrtimer *timer,
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
 				hrtimer_force_reprogram(base->cpu_base);
 		}
-		rb_erase(&timer->node, &base->active);
 	}
+
+	rb_erase(&timer->node, &base->active);
+out:
 	timer->state = newstate;
 }
 

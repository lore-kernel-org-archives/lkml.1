Return-Path: <linux-kernel-owner+w=401wt.eu-S1751245AbZH0Wvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbZH0Wvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 18:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbZH0Wvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 18:51:37 -0400
Received: from www.tglx.de ([62.245.132.106]:33690 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZH0Wvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 18:51:36 -0400
Date: Fri, 28 Aug 2009 00:51:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ashwin Chaugule <ashwinc@codeaurora.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC] [PATCH 1/1] hrtimers: Cache next hrtimer
In-Reply-To: <4A970103.7010804@codeaurora.org>
Message-ID: <alpine.LFD.2.00.0908280045200.2888@localhost.localdomain>
References: <4A96FFE9.6060105@codeaurora.org> <4A970103.7010804@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009, Ashwin Chaugule wrote:
>    Cached the hrtimer which causes the expire_next
>    value to change. This is to avoid unnecessary re-programming
>    of the clock events device.

You forgot to describe the application scenario which triggers this.
 
> @@ -843,16 +851,20 @@ static void __remove_hrtimer(struct hrtimer *timer,
>                  struct hrtimer_clock_base *base,
>                  unsigned long newstate, int reprogram)
> {
> -    if (timer->state & HRTIMER_STATE_ENQUEUED) {
> +    struct hrtimer *next_hrtimer = __get_cpu_var(hrtimer_bases).next_hrtimer;
> +
> +    if (hrtimer_is_queued(timer)) {
>         /*
>          * Remove the timer from the rbtree and replace the
>          * first entry pointer if necessary.
>          */
>         if (base->first == &timer->node) {
>             base->first = rb_next(&timer->node);
> -            /* Reprogram the clock event device. if enabled */
> -            if (reprogram && hrtimer_hres_active())
> -                hrtimer_force_reprogram(base->cpu_base);
> +            if (next_hrtimer == timer) {
> +                /* Reprogram the clock event device. if enabled */
> +                if (reprogram && hrtimer_hres_active())
> +                    hrtimer_force_reprogram(base->cpu_base);
> +            }
>         }
>         rb_erase(&timer->node, &base->active);

So if I'm not totally on the wrong track, that's the meat of the
patch.

Any reason why we can't solve that problem with checking
cpu_base->expires_next against the timer which is deleted ? 

See the patently untested patch below.

Another question which arises is whether we should bother with the
reprogramming at all and just let the last programmed event happen
even when the corresponding timer has been removed.

Thanks,

	tglx
---
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
+
+	expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+	if (base->cpu_base->expires_next.tv64 == expires.tv64)
+		hrtimer_force_reprogram(base->cpu_base);
+
+out:
 	timer->state = newstate;
 }
 


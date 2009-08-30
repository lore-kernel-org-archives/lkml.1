Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbZH3Ig1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbZH3Ig1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 04:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbZH3Ig0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 04:36:26 -0400
Received: from www.tglx.de ([62.245.132.106]:53714 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbZH3IgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 04:36:25 -0400
Date: Sun, 30 Aug 2009 10:36:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ashwin Chaugule <ashwinc@codeaurora.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC] [PATCH 1/1] hrtimers: Cache next hrtimer
In-Reply-To: <4A9A1701.2070703@codeaurora.org>
Message-ID: <alpine.LFD.2.00.0908301016230.19335@localhost.localdomain>
References: <4A96FFE9.6060105@codeaurora.org> <4A970103.7010804@codeaurora.org> <alpine.LFD.2.00.0908280045200.2888@localhost.localdomain> <4A971245.5070507@codeaurora.org> <alpine.LFD.2.00.0908280111260.2888@localhost.localdomain> <4A9771AA.2090004@codeaurora.org>
 <alpine.LFD.2.00.0908281308380.2888@localhost.localdomain> <4A98070D.1050308@codeaurora.org> <alpine.LFD.2.00.0908282005410.19335@localhost.localdomain> <4A9A1701.2070703@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Aug 2009, Ashwin Chaugule wrote:
> Thomas Gleixner wrote:
> 
> > Hmm. I'd really like to know why that's behaving different. 
> > Usually there are only timers in the CLOCK_MONOTONIC base during
> > boot. CLOCK_REALTIME base should be empty most of the time. If my
> > theory is correct then the number of reprogram events is correct as
> > well because base[MONOTONIC]->first is always the one which armed the
> > timer.
> >   
> Okay, I think I figured this out :)
> 
> With your latest patch, we will force reprogram, but the next node to arm
> the timer will be needless, because, its expiry is equal to expires_next.
> 
> So, by having a pointer like next_hrtimer, helps to represent all the timers
> that are going to expire next, and thats why timer->cache_hits was always less
> than timer->total_count.IOW, we avoided re-programming the device, if the next
> timer was going to expire at the same time as the one we just removed.

That's not hard to fix by allowing the reprogramming to skip when the
new expiry time is the same as the old one.

I think that allowing the reprogram to skip is catching more cases
than the cached pointer. If the cached pointer is the one which gets
removed we might still reprogram with the same expiry value.

Can you please try the delta patch on top of the last one I sent ?

Thanks,

	tglx
---

--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -542,13 +542,14 @@ static inline int hrtimer_hres_active(vo
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
@@ -564,10 +565,15 @@ static void hrtimer_force_reprogram(stru
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
@@ -650,7 +656,7 @@ static void retrigger_next_event(void *a
 	base->clock_base[CLOCK_REALTIME].offset =
 		timespec_to_ktime(realtime_offset);
 
-	hrtimer_force_reprogram(base);
+	hrtimer_force_reprogram(base, 0);
 	spin_unlock(&base->lock);
 }
 
@@ -763,7 +769,8 @@ static int hrtimer_switch_to_hres(void)
 static inline int hrtimer_hres_active(void) { return 0; }
 static inline int hrtimer_is_hres_enabled(void) { return 0; }
 static inline int hrtimer_switch_to_hres(void) { return 0; }
-static inline void hrtimer_force_reprogram(struct hrtimer_cpu_base *base) { }
+static inline void
+hrtimer_force_reprogram(struct hrtimer_cpu_base *base, int skip_equal) { }
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 					    struct hrtimer_clock_base *base,
 					    int wakeup)
@@ -922,7 +929,7 @@ static void __remove_hrtimer(struct hrti
 			expires = ktime_sub(hrtimer_get_expires(timer),
 					    base->offset);
 			if (base->cpu_base->expires_next.tv64 == expires.tv64)
-				hrtimer_force_reprogram(base->cpu_base);
+				hrtimer_force_reprogram(base->cpu_base, 1);
 		}
 	}
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZH3GG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZH3GG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 02:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbZH3GG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 02:06:56 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36205 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZH3GG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 02:06:56 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5724"; a="22825870"
Message-ID: <4A9A1701.2070703@codeaurora.org>
Date: Sun, 30 Aug 2009 02:06:57 -0400
From: Ashwin Chaugule <ashwinc@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC] [PATCH 1/1] hrtimers: Cache next hrtimer
References: <4A96FFE9.6060105@codeaurora.org> <4A970103.7010804@codeaurora.org> <alpine.LFD.2.00.0908280045200.2888@localhost.localdomain> <4A971245.5070507@codeaurora.org> <alpine.LFD.2.00.0908280111260.2888@localhost.localdomain> <4A9771AA.2090004@codeaurora.org> <alpine.LFD.2.00.0908281308380.2888@localhost.localdomain> <4A98070D.1050308@codeaurora.org> <alpine.LFD.2.00.0908282005410.19335@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908282005410.19335@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> Hmm. I'd really like to know why that's behaving different. 
>
> Usually there are only timers in the CLOCK_MONOTONIC base during
> boot. CLOCK_REALTIME base should be empty most of the time. If my
> theory is correct then the number of reprogram events is correct as
> well because base[MONOTONIC]->first is always the one which armed the
> timer.
>
>
>   
Okay, I think I figured this out :)

I added some debug to find out how many timers are going to expire_next. 

hrtimer_reprogram()

   if (expires.tv64 == expires_next->tv64)

                if (timer != next_hrtimer)

                        timer->realtime++;  
(lazily reusing realtime here, coz we know its always zero otherwise ;) )

Now timer->realtime is very much non-zero :)

So, now base->first has already changed (leftmost node in the rb tree) and is 
pointing to this new timer node which is also going to expire_next, but hasn't
changed the value of expire_next (we just returned 0).

Therefore, in remove_hrtimer()

+	if (base->first == &timer->node) {
+		base->first = rb_next(&timer->node);
+		/* Reprogram the clock event device. if enabled */
+		if (reprogram && hrtimer_hres_active()) {
+			expires = ktime_sub(hrtimer_get_expires(timer),
+					    base->offset);


timer->node is going to point to the latest timer enqueued which is going 
to expire_next.

With your latest patch, we will force reprogram, but the next node to arm
the timer will be needless, because, its expiry is equal to expires_next.

So, by having a pointer like next_hrtimer, helps to represent all the timers
that are going to expire next, and thats why timer->cache_hits was always less
than timer->total_count.IOW, we avoided re-programming the device, if the 
next timer was going to expire at the same time as the one we just removed.

Thoughts ?

Cheers,

Ashwin


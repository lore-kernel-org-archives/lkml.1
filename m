Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbZH1QeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbZH1QeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZH1QeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:34:20 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4295 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZH1QeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:34:19 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5722"; a="22776080"
Message-ID: <4A98070D.1050308@codeaurora.org>
Date: Fri, 28 Aug 2009 12:34:21 -0400
From: Ashwin Chaugule <ashwinc@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC] [PATCH 1/1] hrtimers: Cache next hrtimer
References: <4A96FFE9.6060105@codeaurora.org> <4A970103.7010804@codeaurora.org> <alpine.LFD.2.00.0908280045200.2888@localhost.localdomain> <4A971245.5070507@codeaurora.org> <alpine.LFD.2.00.0908280111260.2888@localhost.localdomain> <4A9771AA.2090004@codeaurora.org> <alpine.LFD.2.00.0908281308380.2888@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908281308380.2888@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> On Fri, 28 Aug 2009, Ashwin Chaugule wrote:
>   
>> Thomas Gleixner wrote:
>> Just didn't know the following could have the same effect. (base->offset is
>> confusing)
>>     
>
> It's simple. We have CLOCK_MONOTONIC and CLOCK_REALTIME. The internal
> time base is CLOCK_MONOTONIC. So we use base->offset to convert
> CLOCK_REALTIME to CLOCK_MONOTONIC. In case the timer is
> CLOCK_MONOTONIC we so the substraction as well, but it simply
> subtracts 0 :)
>  
>   
Cool ! 

> Gah. Looking at the patch with an awake brain makes me feel
> stupid. Working version below.
>   
Um. Same thing happened again. See below .. :)

> ---
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 49da79a..380682b 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -906,19 +906,28 @@ static void __remove_hrtimer(struct hrtimer *timer,
>  			     struct hrtimer_clock_base *base,
>  			     unsigned long newstate, int reprogram)
>  {
> -	if (timer->state & HRTIMER_STATE_ENQUEUED) {
> -		/*
> -		 * Remove the timer from the rbtree and replace the
> -		 * first entry pointer if necessary.
> -		 */
> -		if (base->first == &timer->node) {
> -			base->first = rb_next(&timer->node);
> -			/* Reprogram the clock event device. if enabled */
> -			if (reprogram && hrtimer_hres_active())
> +	ktime_t expires;
> +
> +	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
> +		goto out;
> +
> +	/*
> +	 * Remove the timer from the rbtree and replace the first
> +	 * entry pointer if necessary.
> +	 */
> +	if (base->first == &timer->node) {
> +		base->first = rb_next(&timer->node);       
>   
> +		/* Reprogram the clock event device. if enabled */
> +		if (reprogram && hrtimer_hres_active()) {
>   

  			   timer->total_calls++;


> +			expires = ktime_sub(hrtimer_get_expires(timer),
> +					    base->offset);
> +			if (base->cpu_base->expires_next.tv64 == expires.tv64)
>   

                          {

                                   timer->cache_hits++;    

>  				hrtimer_force_reprogram(base->cpu_base);
>   
                          }

>  		}
> -		rb_erase(&timer->node, &base->active);
>  	}
> +
> +	rb_erase(&timer->node, &base->active);
> +out:
>  	timer->state = newstate;
>  }
>   
 

Avg startup time 26.4 (10 runs) same as last run.

total_calls is again equal to cache_hits ... 
Its been a while since I wrote my patch. I'll need to look deeper to see if I've done something more. B)
Just to make sure, I ran my patch again, I clearly see cache_hits is always less than total_calls.


Cheers,
Ashwin




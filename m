Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbZH0XJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbZH0XJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 19:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbZH0XJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 19:09:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28390 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZH0XJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 19:09:55 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5722"; a="22761052"
Message-ID: <4A971245.5070507@codeaurora.org>
Date: Thu, 27 Aug 2009 19:09:57 -0400
From: Ashwin Chaugule <ashwinc@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC] [PATCH 1/1] hrtimers: Cache next hrtimer
References: <4A96FFE9.6060105@codeaurora.org> <4A970103.7010804@codeaurora.org> <alpine.LFD.2.00.0908280045200.2888@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908280045200.2888@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> You forgot to describe the application scenario which triggers this.
>  
>   
I didn't have anything specific running in userspace to trigger this. 
The sched_timer itself was causing most of the unnecessary 
reprogramming. I reckon, with more applications running, the timer_stats 
will show other timers (hrtimer_wakeup, it_real_fn etc.) that cause this 
effect too.
>> @@ -843,16 +851,20 @@ static void __remove_hrtimer(struct hrtimer *timer,
>>                  struct hrtimer_clock_base *base,
>>                  unsigned long newstate, int reprogram)
>> {
>> -    if (timer->state & HRTIMER_STATE_ENQUEUED) {
>> +    struct hrtimer *next_hrtimer = __get_cpu_var(hrtimer_bases).next_hrtimer;
>> +
>> +    if (hrtimer_is_queued(timer)) {
>>         /*
>>          * Remove the timer from the rbtree and replace the
>>          * first entry pointer if necessary.
>>          */
>>         if (base->first == &timer->node) {
>>             base->first = rb_next(&timer->node);
>> -            /* Reprogram the clock event device. if enabled */
>> -            if (reprogram && hrtimer_hres_active())
>> -                hrtimer_force_reprogram(base->cpu_base);
>> +            if (next_hrtimer == timer) {
>> +                /* Reprogram the clock event device. if enabled */
>> +                if (reprogram && hrtimer_hres_active())
>> +                    hrtimer_force_reprogram(base->cpu_base);
>> +            }
>>         }
>>         rb_erase(&timer->node, &base->active);
>>     
>
> So if I'm not totally on the wrong track, that's the meat of the
> patch.
>   
Yup.
> Any reason why we can't solve that problem with checking
> cpu_base->expires_next against the timer which is deleted ? 
>
> See the patently untested patch below.
>
> Another question which arises is whether we should bother with the
> reprogramming at all and just let the last programmed event happen
> even when the corresponding timer has been removed.
>   
Hm. Interesting approach. See below.
> ---
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 49da79a..91d099c 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -906,19 +906,30 @@ static void __remove_hrtimer(struct hrtimer *timer,
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
> -				hrtimer_force_reprogram(base->cpu_base);
> -		}
> -		rb_erase(&timer->node, &base->active);
> -	}
> +	ktime_t expires;
> +
> +	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
> +		goto out;
> +
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
> +	/* Reprogram the clock event device. if enabled */
> +	if (!reprogram || !hrtimer_hres_active())
> +		goto out;
> +
> +	expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
> +	if (base->cpu_base->expires_next.tv64 == expires.tv64)
> +		hrtimer_force_reprogram(base->cpu_base);
> +
> +out:
>  	timer->state = newstate;
>  }
>
>   

So, you suggest checking the ktime of the hrtimer thats about to expire 
and compare it with expires_next ?
I guess, another reason to go with caching the hrtimer is to avoid 
looping through HRTIMER_MAX_CLOCK_BASES, which may increase to more than 
2 (?) for other architectures, and also all the code flow to arm the 
clock events device.
With the caching approach, I also saw a 4% speedup in various 
application startups too.


Cheers,
Ashwin

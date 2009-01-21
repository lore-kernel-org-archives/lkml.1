Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZAUUIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZAUUIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 15:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZAUUIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 15:08:37 -0500
Received: from main.gmane.org ([80.91.229.2]:35673 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbZAUUIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 15:08:36 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [PATCH] [REPOST] timer iomem hwrng driver
Date: Wed, 21 Jan 2009 20:00:50 +0000
Message-ID: <slrngnevni.2r5.alex@woodchuck.wormnet.eu>
References: <20081230145209.GA26015@woodchuck> <20090112131321.b3b8b7b9.akpm@linux-foundation.org>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: woodchuck.wormnet.eu
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the slow reply. <insert-usual-excuses/>

Thanks though for picking this up and finding the time to have a nosey 
at it.

* Andrew Morton <akpm@linux-foundation.org> [Mon, 12 Jan 2009 13:13:21 -0800]:
>
>> +/*
>> + * have data return 1, however return 0 if we have nothing
>> + */
>> +static int timeriomem_rng_data_present(struct hwrng *rng, int wait)
>> +{
>> +	s32 delay;
>> +
>> +	if (rng->priv == 0)
>> +		return 1;
>> +
>> +	if (timer_pending(&timeriomem_rng_timer)) {
>> +		if (!wait)
>> +			return 0;
>> +
>> +		del_timer(&timeriomem_rng_timer);
>> +		delay = (long)timeriomem_rng_timer.expires - (long)jiffies;
>> +
>> +		schedule_timeout_uninterruptible(delay);
>> +	}
>> +
>> +	return 1;
>> +}
>
> Would it be better (less racy) to do
>
> 	if (del_timer(&timeriomem_rng_timer)) {
> 		if (!wait)
> 			return 0;
>
> 		delay = (long)timeriomem_rng_timer.expires - (long)jiffies;
>
> 		schedule_timeout_uninterruptible(delay);
> 	}
>
Agreed.

> Secondly, can `delay' be negative, if jiffies increments at just the
> right (ie: wrong) time?
>
I thought long and hard about this when I initially put the code 
together, I thought that it could only go very large (when jiffies 
wraps) but never negative as I could not think of a case unless people 
had a source that provided new data at intervals of time where jiffies 
is larger than 2^32...hell you might as well not bother with that source 
:)

Of course I should handle the wrap case, which I have already done at 
least one (with an interval period of one second)...seemed to work fine.

> Thirdly, why the typecasts in the calculation of `delay'?  Both terms
> already have type `unsigned long'.
>
Blind following of whats going on in linux/jiffies.h.  If they can be 
dropped then that's fine with me, I thought 'jiffies' was possibly 
64bit on a platform or two (sparc64 and alpha for example).

> Fourthly, should it use del_timer_sync()?  Bear in mind that the timer
> handler might be concurrently running on another CPU.
>
Will do, had no idea about that.

>> +static int timeriomem_rng_data_read(struct hwrng *rng, u32 *data)
>> +{
>> +	u32 cur;
>> +	s32 delay;
>> +
>> +	*data = *timeriomem_rng_data->address;
>
> This is reading from I/O memory.  It should use readl()?
>
Fixed.

>> +	if (rng->priv != 0) {
>> +		cur = jiffies;
>> +
>> +		delay = (long)cur - (long)timeriomem_rng_timer.expires;
>
> bug: `cur' should have type `unsigned long'.  The u32 can get truncated.
>
> Then, the casts are unneeded.
>
Fixed.

>> +		delay = rng->priv - (delay % rng->priv);
>> +
>> +		timeriomem_rng_timer.expires = cur + delay;
>> +		add_timer(&timeriomem_rng_timer);
>> +	}
>> +
>> +	return 4;
>> +}
>> +
>> +static void timeriomem_rng_trigger(unsigned long dummy)
>> +{
>> +	del_timer(&timeriomem_rng_timer);
>> +}
>
> del_timer_sync()?
>
Check.

>> +static struct hwrng timeriomem_rng_ops = {
>> +	.name		= "timeriomem",
>> +	.data_present	= timeriomem_rng_data_present,
>> +	.data_read	= timeriomem_rng_data_read,
>> +	.priv		= 0,
>> +};
>> +
>> +static int __init timeriomem_rng_probe(struct platform_device *pdev)
>> +{
>> +	int ret;
>> +
>> +	timeriomem_rng_data = pdev->dev.platform_data;
>> +
>> +	if (timeriomem_rng_data->period != 0
>> +		&& usecs_to_jiffies(timeriomem_rng_data->period) > 0) {
>> +		timeriomem_rng_timer.expires = jiffies;
>> +		init_timer(&timeriomem_rng_timer);
>
> I don't think the init_timer() is needed - we already (correctly)
> initialised it at compile time?
>
Again, I had no idea, I was reading a tutorial on timers[1] and it said 
init_timer().  "Just following orders capt'in".

I have removed the init_timer() and you are right, it is unneeded.

> What will happen if we load this driver on machines which don't
> actually have the necessary hardware?  Even non-x86 hardware?
>
Cooks on my development ARM board with no problems, no idea if it works 
on x86 though :) As for not having the hardware present, it's a platform 
driver, surely it would be the fault of the crazed platform writer who 
would to do something like this?

>> +static int __devexit timeriomem_rng_remove(struct platform_device *pdev)
>> +{
>> +	del_timer(&timeriomem_rng_timer);
>
> This should be del_timer_sync().  Otherwise the timer handler could be
> running on another CPU during driver teardown.
>
Check.

Thanks again for having a look at my module.  All I need is some further 
feedback on the timer wrap bit (just ran it again now and it seems to 
work still as expected after five minutes) and then I will re-submit.

Cheers

[1] http://lwn.net/images/pdf/LDD3/ch07.pdf

-- 
Alexander Clouter
.sigmonster says: Don't be overly suspicious where it's not warranted.


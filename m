Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbZEMRys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbZEMRys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 13:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbZEMRyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 13:54:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33653 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbZEMRyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 13:54:37 -0400
Message-ID: <4A0B0939.5030008@ti.com>
Date: Wed, 13 May 2009 12:54:01 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep   
 formorethan2.15 seconds
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>	 <1240358525.6080.40.camel@localhost>  <4A02F5A3.3050004@ti.com>	 <1241744048.7518.132.camel@localhost.localdomain> <4A04584E.4020307@ti.com>	 <1241830281.7297.21.camel@localhost.localdomain>  <4A0A07D6.90408@ti.com>	 <1242172727.3462.55.camel@localhost>  <4A0AE3E3.5090304@ti.com> <1242232872.9110.98.camel@jstultz-laptop>
In-Reply-To: <1242232872.9110.98.camel@jstultz-laptop>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


John Stultz wrote:
>>> Alternatively instead of NSEC_PER_SEC/HZ, we could always drop the
>>> larger of NSEC_PER_SEC/HZ or max_deferment/10? That way we should scale
>>> up without a problem. 
>> Yes, may be this would be a safer option. Thinking about this I was 
>> wondering if we should always use max_deferement/10, because I did not 
>> think that there would ever be a case where NSEC_PER_SEC/HZ would be 
>> greater. If NSEC_PER_SEC/HZ was greater than max_deferement/10 this 
>> would imply that the clocksource would wrap after only 10 jiffies, if I 
>> have the math right...
> 
> Right, but even with such limitiations, if an arch can skip every 5
> ticks, they probably will try, right? :)

Sure, but I guess I was wondering if there would ever be a clocksource 
that would overflow in 10-20 ticks? If not then it would be safe to 
always use -10% or -5% margin and we can forget about NSEC_PER_SEC/HZ.

Unless I am understanding this wrong, but I thought we are just trying 
to make sure we never sleep for a time longer than the total time a 
clocksource can count.

> That sounds reasonable to me.

Great.

>> One final question, I noticed in clocksource.h that the definition of 
>> function cyc2ns returns a type of s64, however, in the function itself a 
>> variable of type u64 is used and returned. Should this function be 
>> modified as follows?
>>
>>   static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
>>   {
>> -       u64 ret = (u64)cycles;
>> +       s64 ret = (s64)cycles;
>>          ret = (ret * cs->mult) >> cs->shift;
>>          return ret;
>>   }
> 
> Damn. So this brings up an issue I had missed prior.

Any comments on whether this should be u64 versus s64?

> I'll have to think about how that would change
> timekeeping_max_deferment() and how we'd have to calculate a reasonable
> max efficiently.
> 
> Other then this issue (which is my fault for not noticing it earlier),
> you're patch looks great. I just feel badly for making you rev this
> thing over and over. 

No problem, its fine. Its more important for us to get this right so I 
am happy to help where I can.

> One option if you're itching to push it in and be done with it: Make
> timekeeping_max_deferment() return just 1 second for now. Your patch
> provides the right infrastructure for the timekeeping code to provide
> its limits to the clockevents code. So you can use a safe short constant
> value for now, and we can extend that out correctly in a future patch.

How about going back to your original thought and making it 50% margin 
for now? In other words, use max_deferment/2? Therefore, for clocksource 
that can count for 10s of years before overflowing it will not be as 
severe.

> Sorry again for not catching this until now. :(

No problem at all. Thanks for all the inputs.

Cheers
Jon



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZCTH1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZCTH1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 03:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZCTH1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 03:27:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:3180 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZCTH1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 03:27:24 -0400
Message-ID: <49C34558.6030006@monstr.eu>
Date: Fri, 20 Mar 2009 08:27:20 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner 1 <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, john.williams@petalogix.com
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>	 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>	 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>	 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>	 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>	 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>	 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>	 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>	 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>	 <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain>	 <49C2AB09.9040300@monstr.eu>	 <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain> <1237515861.7106.215.camel@jstultz-laptop>
In-Reply-To: <1237515861.7106.215.camel@jstultz-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John S,

> On Thu, 2009-03-19 at 22:47 +0100, Thomas Gleixner wrote:
>> On Thu, 19 Mar 2009, Michal Simek wrote:
>>> And the second question is about shift and rating values.
>>> I wrote one message in past http://lkml.org/lkml/2009/1/11/291
>>> Here is the important of part of that message.
>>>
>>> ...
>>>
>>> And the second part is about shift and rating values. Rating is
>>> describe(linux/clocksource.h) and seems to me that should be
>>> corresponded with CONFIG_HZ value,right?
> 
> Not sure where the idea of correspondence w/ CONFIG_HZ came from. The
> rating value just provides a relative ordering of preferences between
> possible clocksources. Since different hardware may have a number of
> different clocksources available, we just need to have a method of
> selecting a preferred clocksource, and the rating value is used for
> that.
> 
> The guide in linux/clocksource.h is just a guide. Most arches, which
> only have one or two clocksource options probably won't need much care,
> and a rating of 200 or 300 will probably suffice. Or if there really
> isn't any option about it and there is only one which is a must-use
> clocksource, 400.

ok. That mean that for my case (only one clocksource) I should set rating to 400
 - I have one clocksource and is perfect for me.

> 
> 
>>> And I found any explanation of shift value -> max value for equation
>>> (2-5) * freq << shift / NSEC_PER_SEC should be for my case still 32bit
>>> number, where (2-5s) are because of NTP
>> @John, can you explain the shift vlaue please ?
> 
> The shift value is a bit more difficult to explain. The algorithm you
> describe above is used by sparc to generate shift, and I think it will
> work, but may not be optimal.
> 
> This question comes up over and over, so I figured I should sit down and
> really solve it. 
> 
> Basically the constraint is you want to calculate a mult value using the
> highest shift possible. However we have to be careful not to overflow
> 64bits when we multiply ~5second worth of cycles times the mult value.
> 
> So I finally put this down into code and here it is. No promises that it
> is 100% right, but from my simple test examples it worked ok.

OK. Please check my case of that value.
MB can run from 5Mhz till 150MHz I think.
I need generic approach that's why I have to calculate with max value (150MHz).
My timer can tick on that freq too. (There is no different time bases in HW).

I need to find out how many ticks takes ~5s.
150MHz means that I need for 1sec 150 000 000 timer ticks.
One tick takes 1/150MHz = ~6-7ns - in the best case I can recognize and set
6-7ns (this is only theoretical value because of overhead)

~5s takes 750 000 000 ticks = 0x2CB4 1780. And I have 32bit counter.

That my question is how big could be a shift of value above till overflow.
0x2CB4 1780 << shift not exceed 0xffff ffff ffff ffff.

Here is that table for my case
shift
0 = 0x2CB4 1780
1 = 0x5968 2F00
2 = 0xB2D0 5E00
3 = 0x1 65A0 BC00

4 = 0x2 CB41 7800
5 = 0x5 9682 F000
6 = 0xB 2D05 E000
7 = 0x16 5A0B C000

>From first value I can tell that I can shift that value with 32 + 3 => 35 is the
first shift with overflow 64bit. Am I right?
If yes, I haven't found that big value in any arch.

For example avr has shift 16, rating 50 (arch/avr32/kernel/time.c) (BTW: Sets
time from 2007 too)

And the next my question is about difference in clocksource and clock event
value. Situation is the same. Is it mean that I should set the same rating and
shift value for both. (It doesn't matter if I use one or two timer -> they are
the same).

And about high resolution timer. I can recognize in the best case ~6-7ns. That
mean that measuring values around 100-200ns make sense and should work. Could I
use it?

Thanks,
Michal


> Let me know if it helps.
> 
> thanks
> -john
> 
> 
> Add helper functions to calculate ideal clocksource shift values given
> its frequency (either hz or khz). Lightly tested, use with care. 
> Also fixes a few old-old-old timesource (well, timsource) references my
> find and replace attempts failed on.
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index f88d32f..9ef062d 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -116,7 +116,7 @@ extern struct clocksource *clock;	/* current clocksource */
>   * @khz:		Clocksource frequency in KHz
>   * @shift_constant:	Clocksource shift factor
>   *
> - * Helper functions that converts a khz counter frequency to a timsource
> + * Helper functions that converts a khz counter frequency to a clocksource
>   * multiplier, given the clocksource shift value
>   */
>  static inline u32 clocksource_khz2mult(u32 khz, u32 shift_constant)
> @@ -142,7 +142,7 @@ static inline u32 clocksource_khz2mult(u32 khz, u32 shift_constant)
>   * @shift_constant:	Clocksource shift factor
>   *
>   * Helper functions that converts a hz counter
> - * frequency to a timsource multiplier, given the
> + * frequency to a clocksource multiplier, given the
>   * clocksource shift value
>   */
>  static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
> @@ -162,6 +162,10 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
>  	return (u32)tmp;
>  }
>  
> +extern u32 clocksource_khz2shift(u32 freq_khz);
> +extern u32 clocksource_hz2shift(u32 freq_hz);
> +
> +
>  /**
>   * clocksource_read: - Access the clocksource's current cycle value
>   * @cs:		pointer to clocksource being read
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index ca89e15..0a2538d 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -212,6 +212,83 @@ static void clocksource_check_watchdog(struct clocksource *cs)
>  static inline void clocksource_resume_watchdog(void) { }
>  #endif
>  
> +
> +/* Maximum seconds worth of cycles we consider valid */
> +#define MAX_SEC_OF_CYCLES 5ULL
> +
> +/**
> + * clocksource_khz2shift - calculates shift from khz
> + * @freq_khz:		Clocksource frequency in KHz
> + *
> + * Helper functions that converts a khz counter
> + * frequency to a clocksource shift.
> + */
> +u32 clocksource_khz2shift(u32 freq_khz)
> +{
> +	s32 shift = 32;
> +	u32 mult;
> +
> +	while (1) {
> +		s64 tmp;
> +		u64 cycles;
> +		mult = clocksource_khz2mult(freq_khz, shift);
> +
> +		cycles = (u64)freq_khz*1000*MAX_SEC_OF_CYCLES;
> +		tmp = (cycles * mult) >> shift;
> +
> +		tmp = (MAX_SEC_OF_CYCLES*NSEC_PER_SEC) - tmp;
> +		if (tmp < 0)
> +			tmp = -tmp;
> +
> +		/* if we are witin one mult unit, we're good */
> +		if (tmp < cycles>>shift)
> +			break;
> +
> +		shift--;
> +		if (shift < 1)
> +			BUG();
> +	}
> +	return shift;
> +}
> +
> +/**
> + * clocksource_hz2shift - calculates shift from hz
> + * @freq_hz:		Clocksource frequency in Hz
> + *
> + * Helper functions that converts a hz counter
> + * frequency to a clocksource shift.
> + */
> +
> +u32 clocksource_hz2shift(u32 freq_hz)
> +{
> +	s32 shift = 32;
> +	u32 mult;
> +
> +	while (1) {
> +		s64 tmp;
> +		u64 cycles;
> +		mult = clocksource_hz2mult(freq_hz, shift);
> +
> +		cycles = (u64)freq_hz*MAX_SEC_OF_CYCLES;
> +		tmp = (cycles * mult) >> shift;
> +
> +		tmp = MAX_SEC_OF_CYCLES*NSEC_PER_SEC - tmp;
> +		if (tmp < 0)
> +			tmp = -tmp;
> +
> +		/* if we are witin one mult unit, we're good */
> +		if (tmp < cycles>>shift)
> +			break;
> +
> +		shift--;
> +		if (shift < 1)
> +			BUG();
> +	}
> +	return shift;
> +}
> +
> +
> +
>  /**
>   * clocksource_resume - resume the clocksource(s)
>   */
> 
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854

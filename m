Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZCUKjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZCUKjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZCUKjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:39:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:32673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbZCUKjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:39:00 -0400
Message-ID: <49C4C3BD.9090905@monstr.eu>
Date: Sat, 21 Mar 2009 11:38:53 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner 1 <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, john.williams@petalogix.com
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>	 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>	 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>	 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>	 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>	 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>	 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>	 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>	 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>	 <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain>	 <49C2AB09.9040300@monstr.eu>	 <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain>	 <1237515861.7106.215.camel@jstultz-laptop>  <49C34558.6030006@monstr.eu> <1237581607.7191.51.camel@localhost.localdomain>
In-Reply-To: <1237581607.7191.51.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,
> On Fri, 2009-03-20 at 08:27 +0100, Michal Simek wrote:
>> Hi John S,
>>
>>> On Thu, 2009-03-19 at 22:47 +0100, Thomas Gleixner wrote:
>>>> On Thu, 19 Mar 2009, Michal Simek wrote:
>>>>> And the second question is about shift and rating values.
>>>>> I wrote one message in past http://lkml.org/lkml/2009/1/11/291
>>>>> Here is the important of part of that message.
>>>>>
>>>>> ...
>>>>>
>>>>> And the second part is about shift and rating values. Rating is
>>>>> describe(linux/clocksource.h) and seems to me that should be
>>>>> corresponded with CONFIG_HZ value,right?
>>> Not sure where the idea of correspondence w/ CONFIG_HZ came from. The
>>> rating value just provides a relative ordering of preferences between
>>> possible clocksources. Since different hardware may have a number of
>>> different clocksources available, we just need to have a method of
>>> selecting a preferred clocksource, and the rating value is used for
>>> that.
>>>
>>> The guide in linux/clocksource.h is just a guide. Most arches, which
>>> only have one or two clocksource options probably won't need much care,
>>> and a rating of 200 or 300 will probably suffice. Or if there really
>>> isn't any option about it and there is only one which is a must-use
>>> clocksource, 400.
>> ok. That mean that for my case (only one clocksource) I should set rating to 400
>>  - I have one clocksource and is perfect for me.
> 
> As long as there will never be another clocksource used on that
> architecture, 400 is probably ok. Since its sometimes hard to tell, you
> might want to pick a more moderate 300. 
> 
> But again, its a relative scale and doesn't matter all that much, as
> long as the right clocksource is always selected at boot for the
> hardware.

OK that mean that rating do the same work for clockevent sources too, right?


> 
> 
>>>>> And I found any explanation of shift value -> max value for equation
>>>>> (2-5) * freq << shift / NSEC_PER_SEC should be for my case still 32bit
>>>>> number, where (2-5s) are because of NTP
>>>> @John, can you explain the shift vlaue please ?
>>> The shift value is a bit more difficult to explain. The algorithm you
>>> describe above is used by sparc to generate shift, and I think it will
>>> work, but may not be optimal.
>>>
>>> This question comes up over and over, so I figured I should sit down and
>>> really solve it. 
>>>
>>> Basically the constraint is you want to calculate a mult value using the
>>> highest shift possible. However we have to be careful not to overflow
>>> 64bits when we multiply ~5second worth of cycles times the mult value.
>>>
>>> So I finally put this down into code and here it is. No promises that it
>>> is 100% right, but from my simple test examples it worked ok.
>> OK. Please check my case of that value.
>> MB can run from 5Mhz till 150MHz I think.
>> I need generic approach that's why I have to calculate with max value (150MHz).
>> My timer can tick on that freq too. (There is no different time bases in HW).
>>
>> I need to find out how many ticks takes ~5s.
>> 150MHz means that I need for 1sec 150 000 000 timer ticks.
> 
> I think you mean counter cycles instead of timer ticks.  Timer tick
> terminology usually describes a timer based interrupt.

yes.

> 
>> One tick takes 1/150MHz = ~6-7ns - in the best case I can recognize and set
>> 6-7ns (this is only theoretical value because of overhead)
>>
>> ~5s takes 750 000 000 ticks = 0x2CB4 1780. And I have 32bit counter.
>>
>> That my question is how big could be a shift of value above till overflow.
>> 0x2CB4 1780 << shift not exceed 0xffff ffff ffff ffff.
> 
> Almost.  Its not the shift that causes the problem right off, but the
> resulting mult value calculated from a shift. Again, the key points are,
> you want to make sure that:
> 
> 1) that mult value for the given shift fits in 32 bits. 
> and

ok. Formula.

For mult  1GHz * 2^shift/timer_freq < (u32)
=> const=1GHz/timer_freq, const * 2^shift < (u32)

2^30=0x4000 0000
2^29=0x2000 0000
2^28=0x1000 0000

2^26=0x 400 0000
2^25=0x 200 0000
2^24=0x 100 0000
For shift in test
2^20=0x  10 0000
2^8= 0x      100

For 150MHz ->const = 6,6666 -> 30 is over, 29 fits.
For 5MHz -> const = 200   -> 25 is over, 24 fits.
For 1GHz -> const = 1 -> 32 is over, 31 fits - that's correct


For your test case below ->
  (5 * timer_freq * 1GHz * 2^shift/timer_freq)>>shift <= 5sec in ns
=>(5 *              1GHz * 2^shift           )>>shift <= 5sec in ns
=>(                 5GHz * 2^shift           )>>shift <= 5sec in ns
=>(                 1GHz * 2^shift           )>>shift <= 1sec in ns
=>                  1GHz                              <= 1sec in ns
=> I think this is no test -> this is equal for every values.

Am I right?

If yes.

min_delta_ns is set to (const<1000 ? 1000 : const) -> I think that only for
slower machines than 1MHx uses const value.
max_delta_ns is for 32bit timer 2^31 -1  and for 64bit arch 2^63 - 1


> 2) mult * 5sec of cycles doesn't overflow 64bits (really is only an
> issue for very very fast counters that run faster then 1Ghz).
> 
> 
> So let's follow my algorithm and start by picking a shift value of 32.
> 
> We calculate the mult, which would be (using clocksource_khz2mult()):
> 
> 	(1Million * 2^32) / 150,000 = 28633115307 which overflows 32bits.
> BZZZZZZ.
> 
> 	1Million * 2^31 / 150,000 = 14316557653 (to big. BZZZZZZZ)
> 	
> 
> 	1Million * 2^30 / 150,000 = 7158278827 (to big. BZZZZZZZ)
> 
> 
> 	1Million * 2^29 / 150,000 = 3579139413 (BING! it fits!)
> 
> Now the test:
> 	(750 000 000 * 3 579 139 413)>>29 ?= 5 seconds
> 	2684354559750000000 (doesn't overflow!) >> 29
> 	4999999999ns ?= 5seconds (within the error range, so we're good!)
> 
> 
> Now take care, because the slower the clocksource, often the lower the
> shift value we can use, because the nsecs per cycle value that mult
> approximates is much larger.
> 
> 
> So for 5mhz (using 
> 
> 	1Million * 2^29 / 5,000 = 107374182400 (32bit overflow!)
> 	...
> 	1Million * 2^24 / 5,000 = 3355443200 (fits!)
> 
> Now the test:
> 	(25000000 * 3355443200)>>24 ?= 5 seconds
> 	83886080000000000 (doesn't overflow!) >> 24 ?=
> 	5000000000ns ?= 5seconds (BING!)
> 
> 
> So you can either dynamically calculate the best shift value for the
> actual freq using the helper functions I provided, or just use 24 and be
> safe, your pick.

ok. we will talk what the smaller freq is.

> 
> 
> 
>> For example avr has shift 16, rating 50 (arch/avr32/kernel/time.c) (BTW: Sets
>> time from 2007 too)
> 
> Most arches probably low ball the shift to be safe. Mainly because
> explaining how to calculate the optimal shift was hard and there weren't
> helper functions.

I hope that our discussion clear this.

> 
> As an aside (feel free to ignore for the microblaze bits):
> 	Some complexity may grow here as well, since 5 seconds of cycles may
> prove too short as folks become more interested running w/ NOHZ and
> avoiding interrupts for extreme lengths of time (I've heard 30
> minutes!?). For those situations we will need lower shift values, since
> 30 minutes of cycles * a large mult value close to (1<<32) will likely
> overflow 64bits. But that trades off how finely we can tweak the clock
> steering. Probably converting folks to use the helper functions will be
> the best approach, as it will allow us to configure that depending on
> NOHZ or not.

ok.Let's talk about NOHZ case.
I enabled NOHZ choice in menuconfig. I am sourcing source two Kconfigs
(kernel/time/Kconfig and kernel/Kconfig.hz)
Here is the fragment from my .config file.

CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_PREEMPT_NONE=y
...
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100

For NO_HZ val I shouldn't use HZ value because of NO_HZ and HZ values shouldn't
be in .config file. Am I right?

If yes I have still problem in my code.

I have there these two parts.
Just counting value for periodic mode but depends on HZ value.
	cpuinfo.freq_div_hz = cpuinfo.cpu_clock_freq / HZ;

+ usage in periodic mode.
	case CLOCK_EVT_MODE_PERIODIC:
		printk(KERN_INFO "%s: periodic\n", __func__);
		microblaze_timer0_start_periodic(cpuinfo.freq_div_hz);
		break;


Here is the part of my kernel log. At the beginning is setup periodic mode and
then is switched to oneshot mode. And for periodic mode I use HZ value which
shouldn't be there.

microblaze_timer_set_mode: shutdown
microblaze_timer_set_mode: periodic
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 254848k/262144k available
ODEBUG: selftest passed
Calibrating delay loop... 60.82 BogoMIPS (lpj=304128)
Mount-cache hash table entries: 512
net_namespace: 544 bytes
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
NET: Registered protocol family 2
microblaze_timer_set_mode: oneshot   ------------------------- switch to oneshot
Switched to high resolution mode on CPU 0

What is the correct solution for NO_HZ case?

BTW: I just tried to remove Kconfig.hz sourcing and I am getting faults in
include/linux/jiffies.h and I expect the problems in other code too.


Thanks,
Michal


> 
> thanks
> -john
> 
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854

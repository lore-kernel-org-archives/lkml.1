Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbYEHTga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbYEHTga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbYEHTgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:36:19 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:45813 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1755464AbYEHTgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:36:17 -0400
Date: Thu, 8 May 2008 23:36:14 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: "Richard A. Smith" <richard@laptop.org>
Cc: Andres Salomon <dilinger@queued.net>,
       Andrew Morton <akpm@linux-foundation.org>, cbou@mail.ru,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH] power_supply: support CHARGE_NOW in OLPC battery
Message-ID: <20080508193614.GA31188@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080508003454.722ba511@ephemeral> <20080508105145.GA32017@polina.dev.rtsoft.ru> <20080508130102.3218f1e9@ephemeral> <20080508171320.GA8226@polina.dev.rtsoft.ru> <48234C25.4040807@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <48234C25.4040807@laptop.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 02:53:25PM -0400, Richard A. Smith wrote:
> Anton Vorontsov wrote:
>> On Thu, May 08, 2008 at 01:01:02PM -0400, Andres Salomon wrote:
>>> Ok, CC'ing Richard as I should've done in the first place...
>> [...]
>>>>> +	case POWER_SUPPLY_PROP_CHARGE_NOW:
>>>>> +		ret = olpc_ec_cmd(EC_BAT_ACR, NULL, 0, (void
>>>>> *)&ec_word, 2);
>>>>> +		if (ret)
>>>>> +			return ret;
>>>>> +
>>>>> +		val->intval = be16_to_cpu(ec_word);
>>>> But you didn't convert it to the uAh, I think you should.
>>>
>>> We have logic in userspace that converts ACR to a useful number; for
>>> our purposes, we'd just like to read the raw ACR values.
>>
>> No. The purpose of power supply class is to report values in common
>> units. Not some random value that userspace then should guess how to
>> compute.
>
> I'm fine with that.  I'll have to make my scripts do some detection on  
> what kernel is running and convert or not convert but thats not too hard.
>
> I remember Dave asking me if I wanted it converted and I told him not to  
> bother and just to export the raw value.  I would deal with the units.  
> At the time I was just trying to get some simple debugging info.  Turns  
> out that ACR is really useful for debugging battery problems and it 
> stuck.
>
> A single ACR reading itself does not tell you anything usefull.  Its a  
> signed 16 bit free running coulomb counter that counts up and down based  
> on how much juice goes into or out of the battery.  So to extract any  
> meaningful info you need 2 readings separated by some instance in time.  
> The difference between the 2 tells you the relative energy you have  
> consumed or added.

Cool, I believe this is exactly same thing as we have on DS2760. ACR
counts up and down. For example, if there was a current of 10 uA for
30 minutes, ACR will show 5 uAh. Additional 30 minutes with current
-10 uA will result in 0 uAh in ACR... Right?

> The units for the ACR register in the DS2765 are:

Do you have any specs for the ds2765? I'd like to see one, if
it isn't restricted matter. google:ds2765 pdf wasn't helpful...

> 6.25 uVh / Rsense
> OLPC Rsense = .015 Ohms
>
> The integer math conversion for ACR to mAh that I use in my scripts is:
>
> (ACR2 - ACR1) * 625 / 1500

Just curious.. What does the final value mean and how do you use it?
ACR is the Ah counter. You're subtracting one from another, and that
value will show you.. difference of Ah between T2 and T1..?

You'll get something useful (current) if you divide the value by T2-T1
though... ;-) But I believe OLPC can report current by itself...

>>> Perhaps CHARGE_NOW is the wrong thing to be using, if we can't get
>>> uAh and CHARGE_* requires that unit.
>>
>> I don't think that converting X * uAh or uAh / Y to uAh is impossible.
>> I'd suggest you to convert the ACR value to uAh using fractions, see
>> ds2760_battery.c. Even if the final value losing precision a bit, it is
>> still useful to do CHARGE_NOW.
>
> Is CHARGE_NOW supposed to be an absolute indication of the level of  
> charge in the battery?  If so then thats not ACR.

This depends. On DS2760 ACR is the only way to determine battery's
"charge" at the given time (thus the capacity in percents, since ds2760
can't report it).

It needs calibration though... ds2760_battery.c doing this: resetting the
ACR to CHARGE_FULL value when battery is in charging state with current
flow < 10 mA.

Works quite good here.

> That would be SOC% *  
> battery capacity.  The EC uses the relative motion of the ACR to update  
> the SOC%.

Since you don't seem to use ACR as CHARGE_NOW, I think maybe we indeed
should implement PROP_ACR or better PROP_CHARGE_COUNTER? With units of
uAh... would that work?

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

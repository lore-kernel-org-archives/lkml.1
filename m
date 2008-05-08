Return-Path: <linux-kernel-owner+w=401wt.eu-S933402AbYEHSyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbYEHSyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765527AbYEHSxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:53:33 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:50681 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760550AbYEHSx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:53:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=mqpjjOAe6V/I+upaC552rsmlaQ1sF9ajGEtiL84EyabdtL+Alqerxo0RMIKmJEBDs2RLzw01yiDA69nk2tv/SN0eavIOhI0rEOwzGaCVOG75nEnzYrvlUacnGMOdBSgQdB0JNWpcbVeyOiv6vaAcF05B6FTpilS0UJVvDgCfDjQ=
Message-ID: <48234C25.4040807@laptop.org>
Date: Thu, 08 May 2008 14:53:25 -0400
From: "Richard A. Smith" <richard@laptop.org>
Reply-To: richard@laptop.org
Organization: One Laptop per Child
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: Andres Salomon <dilinger@queued.net>,
       Andrew Morton <akpm@linux-foundation.org>, cbou@mail.ru,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH] power_supply: support CHARGE_NOW in OLPC battery
References: <20080508003454.722ba511@ephemeral> <20080508105145.GA32017@polina.dev.rtsoft.ru> <20080508130102.3218f1e9@ephemeral> <20080508171320.GA8226@polina.dev.rtsoft.ru>
In-Reply-To: <20080508171320.GA8226@polina.dev.rtsoft.ru>
Content-Type: text/plain; charset=utf8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> On Thu, May 08, 2008 at 01:01:02PM -0400, Andres Salomon wrote:
>> Ok, CC'ing Richard as I should've done in the first place...
> [...]
>>>> +	case POWER_SUPPLY_PROP_CHARGE_NOW:
>>>> +		ret = olpc_ec_cmd(EC_BAT_ACR, NULL, 0, (void
>>>> *)&ec_word, 2);
>>>> +		if (ret)
>>>> +			return ret;
>>>> +
>>>> +		val->intval = be16_to_cpu(ec_word);
>>> But you didn't convert it to the uAh, I think you should.
>>
>> We have logic in userspace that converts ACR to a useful number; for
>> our purposes, we'd just like to read the raw ACR values.
> 
> No. The purpose of power supply class is to report values in common
> units. Not some random value that userspace then should guess how to
> compute.

I'm fine with that.  I'll have to make my scripts do some detection on 
what kernel is running and convert or not convert but thats not too hard.

I remember Dave asking me if I wanted it converted and I told him not to 
bother and just to export the raw value.  I would deal with the units. 
At the time I was just trying to get some simple debugging info.  Turns 
out that ACR is really useful for debugging battery problems and it stuck.

A single ACR reading itself does not tell you anything usefull.  Its a 
signed 16 bit free running coulomb counter that counts up and down based 
on how much juice goes into or out of the battery.  So to extract any 
meaningful info you need 2 readings separated by some instance in time. 
  The difference between the 2 tells you the relative energy you have 
consumed or added.

The units for the ACR register in the DS2765 are:

6.25 uVh / Rsense
OLPC Rsense = .015 Ohms

The integer math conversion for ACR to mAh that I use in my scripts is:

(ACR2 - ACR1) * 625 / 1500

>> Perhaps CHARGE_NOW is the wrong thing to be using, if we can't get
>> uAh and CHARGE_* requires that unit.
> 
> I don't think that converting X * uAh or uAh / Y to uAh is impossible.
> I'd suggest you to convert the ACR value to uAh using fractions, see
> ds2760_battery.c. Even if the final value losing precision a bit, it is
> still useful to do CHARGE_NOW.

Is CHARGE_NOW supposed to be an absolute indication of the level of 
charge in the battery?  If so then thats not ACR.  That would be SOC% * 
battery capacity.  The EC uses the relative motion of the ACR to update 
the SOC%.

-- 
Richard Smith  <richard@laptop.org>
One Laptop Per Child

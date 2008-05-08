Return-Path: <linux-kernel-owner+w=401wt.eu-S1764787AbYEHUo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764787AbYEHUo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYEHUot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:44:49 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:38008 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYEHUoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:44:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=rSCp9wmdHQor6vziL87Z92xZbyhZ7+ydqOenorR2Jvh+bUj/ylhOIjnunxmxPpKX2NgdIie7EM4UPy00iCfw2EwrTeigxOXJ752ZPNi1qBtWcD4NP5BsFJ4oYaHa2RRRT9PZDWR78baEta05fhZwUdl0W8NpBpsDPAQVLCRv+co=
Message-ID: <4823663B.6060409@laptop.org>
Date: Thu, 08 May 2008 16:44:43 -0400
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
References: <20080508003454.722ba511@ephemeral> <20080508105145.GA32017@polina.dev.rtsoft.ru> <20080508130102.3218f1e9@ephemeral> <20080508171320.GA8226@polina.dev.rtsoft.ru> <48234C25.4040807@laptop.org> <20080508193614.GA31188@polina.dev.rtsoft.ru>
In-Reply-To: <20080508193614.GA31188@polina.dev.rtsoft.ru>
Content-Type: text/plain; charset=utf8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:

> Cool, I believe this is exactly same thing as we have on DS2760. ACR
> counts up and down. For example, if there was a current of 10 uA for
> 30 minutes, ACR will show 5 uAh. Additional 30 minutes with current
> -10 uA will result in 0 uAh in ACR... Right?

Yes. Exactly correct.

>> The units for the ACR register in the DS2765 are:
> 
> Do you have any specs for the ds2765? I'd like to see one, if
> it isn't restricted matter. google:ds2765 pdf wasn't helpful...
> 

Ooop.  Sorry my typo.  DS2756.

http://wiki.laptop.org/images/e/e9/DS2756.pdf
or
http://www.maxim-ic.com/quick_view2.cfm/qv_pk/5104

>> 6.25 uVh / Rsense
>> OLPC Rsense = .015 Ohms
>>
>> The integer math conversion for ACR to mAh that I use in my scripts is:
>>
>> (ACR2 - ACR1) * 625 / 1500
> 
> Just curious.. What does the final value mean and how do you use it?
> ACR is the Ah counter. You're subtracting one from another, and that
> value will show you.. difference of Ah between T2 and T1..?
> 
> You'll get something useful (current) if you divide the value by T2-T1
> though... ;-) But I believe OLPC can report current by itself...

There is no final value. Only relative values.  The EC can detect the 
ends of the spectrum.  Battery empty and battery full.  At those 
endpoints it sets the SOC% to x% (exact x varies depending on the 
battery type) But lets use full and 90% as the example.

So you charge the battery until the criteria for a full battery are met 
and then you set the SOC% to 90%.  This value is stored in the EEPROM of 
the DS2756.   So then when the EC senses that the battery is discharging 
it monitors the relative ACR change.  It uses that to compute how much % 
loss and updates the SOC%.  If you are partially discharged and Ext 
power is provided so that the battery begins to charge then the reverse 
happens.  The absolute value of the ACR is never used. Only the 
difference.  The corrections of any errors happen when the full or empty 
conditions are met.

>> Is CHARGE_NOW supposed to be an absolute indication of the level of  
>> charge in the battery?  If so then thats not ACR.
> 
> This depends. On DS2760 ACR is the only way to determine battery's
> "charge" at the given time (thus the capacity in percents, since ds2760
> can't report it).

Ours is the same way.  The EC just does the extra work to keep an SOC% 
value.

> It needs calibration though... ds2760_battery.c doing this: resetting the
> ACR to CHARGE_FULL value when battery is in charging state with current
> flow < 10 mA.
> 
> Works quite good here.

Ah.. I see now.  You are using the ACR directly as the SOC value. 
Whereas OLPC does not.

If your battery capacity stays reasonably constant across the operating 
temp range then I see how that would work fine.  With NiMh chemistry the 
capacity changes quite a bit wrt temperature. Li chemistries capacity 
are much less temp sensitive.

I can't say for certain because I didn't do the original code design but 
from what I see in the EC code it tries to compensate for that capacity 
change when using NiMh.  So they record the net ACR change and use that 
to try and compute the real SOC% change.  I suppose you could still make 
it work with just the ACR register but thats not how Quanta chose to do 
the implementation.

>> That would be SOC% *  
>> battery capacity.  The EC uses the relative motion of the ACR to update  
>> the SOC%.
> 
> Since you don't seem to use ACR as CHARGE_NOW, I think maybe we indeed
> should implement PROP_ACR or better PROP_CHARGE_COUNTER? With units of
> uAh... would that work?

That would work fine.

-- 
Richard Smith  <richard@laptop.org>
One Laptop Per Child

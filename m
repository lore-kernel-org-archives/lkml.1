Return-Path: <linux-kernel-owner+w=401wt.eu-S1762791AbYAQWza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762791AbYAQWza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761404AbYAQWvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:51:33 -0500
Received: from slowhand.arndnet.de ([88.198.19.76]:54906 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761504AbYAQWvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:51:25 -0500
Message-ID: <478FDC12.6020505@i4.informatik.rwth-aachen.de>
Date: Thu, 17 Jan 2008 23:52:02 +0100
From: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
References: <478E4267.7020509@i4.informatik.rwth-aachen.de> <20080116161912.7b449466@ephemeral> <20080116165606.3ebc06a4@ephemeral> <478F25D6.3060503@i4.informatik.rwth-aachen.de> <20080117134032.4cc1a1cf@ephemeral> <478FB255.5040001@i4.informatik.rwth-aachen.de> <20080117211917.GF8244@cosmic.amd.com> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <20080117223644.GK8244@cosmic.amd.com>
In-Reply-To: <20080117223644.GK8244@cosmic.amd.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse wrote:
> On 17/01/08 22:50 +0100, Arnd Hannemann wrote:
>> Jordan Crouse schrieb:
>>> On 17/01/08 20:53 +0100, Arnd Hannemann wrote:
>>>> Andres Salomon schrieb:
>>>>> On Thu, 17 Jan 2008 10:54:30 +0100
>>>>> Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:
>>>>>
>>>>>> Andres Salomon schrieb:
>>>>>>> On Wed, 16 Jan 2008 16:19:12 -0500
>>>>>>> Andres Salomon <dilinger@queued.net> wrote:
>>>>>>>
>>>>>>>> On Wed, 16 Jan 2008 18:44:07 +0100
>>>>>>>> Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:
>>>>>>>>
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> I'm trying to boot 2.6.24-rc8 on a GEODE LX board (ALIX.3),
>>>>>>>>> and it hangs during boot:
>>>>>>>>>
>>>>>>>>> [   12.689971] NET: Registered protocol family 16
>>>>>>>>> [   12.703329] geode-mfgpt:  Registered timer 0
>>>>>>>>> [   12.716149] mfgpt-timer:  registering the MFGT timer as a clock event...
>>>>>>>>>
>>>>>>>> What BIOS are you using?  It's possible that our detection code is
>>>>>>>> failing to detect in-use timers.
>>>>>> I'm using v0.99 (latest available).
>>>>> v0.99 of what?  Jordan seems to think it's an Award BIOS, but I'd like
>>>>> to make sure.
>>>> Its an ALIX board from PCEngines, they have their own BIOS
>>>> implementation (tinyBios).
>>>> http://www.pcengines.ch/alix.htm
>>>>
>>>>>> Also note when I do enable the mysterios "MFGPT workaround" option in
>>>>>> the bios the machine hangs directly after:
>>>>>> [   36.780990] NET: Registered protocol family 16
>>>>> "MFGPT workaround"?  That sounds a bit frightening.
>>>>>
>>>>> Presumably, the BIOS is using the MFGPTs, but we're not detecting them as
>>>>> being in use.
>>>> Yes I think so too, for the fun of it I compiled a 2.6.16.29 kernel with
>>>> the attached patch from fi4l.
>>> Okay - thats an MFPGT patch from pre-OLPC days. I am the guilty and
>>> dubious party.  We changed the API to work better with the timer tick,
>>> and thats the version that ended up in the kernel.
>>>
>>> I really wish I could take back this patch, because it keeps coming back
>>> to torment me.  We must, as a people, put it behind us and forgot it. :)
>>>
>>>> relevant output is this:
>>>> [   31.015425] geode-mfgpt:  7 timers available.
>>>> ...
>>>> [   31.245875] geode-mfgpt:  Registered timer 0
>>>> So the above kernel detects only 7 timers not 8, and it works. But note
>>>> that timer 0 is not used as a clock event source but as a watchdog,
>>>> which btw actually works fine :-)
>>> It detects 7 timers because of a bug in the code -  there really are 8 
>>> timers, which the current code correctly identifies.
>> Yes I can confirm this, changed MFGPT_MAX_TIMERS from 7 to 8 in the old
>> kernel and it still works.
>>
>>>> The funny thing is the #define workaround part of this dubious patch and
>>>> its interaction with the bios:
>>>>
>>>> #ifdef WORKAROUND:
>>>>  I have to turn the "MFPGT workaround" option in the bios ON, to boot
>>>> the kernel probably.
>>>>
>>>> #ifndef WORKAROUND:
>>>>  I have to turn the "MFPGT workaround" option in the bios OFF, to boot
>>>> the kernel probably.
>>> So the workaround works around the workaround.   Fun.  I think that Mitch
>>> Bradley verified that if you write the magic MSR when all the clocks are
>>> already clear that bad things happen.  The workaround probably adds a 
>>> dummy clock in.  Notice that the "magic MSR" no longer is in the vanilla
>>> code, and thats the way it should be.  If the BIOS doesn't allow use of
>>> the clocks, then we have to live with that.
>>>
>>> So, based on everything you are saying, I think its clear that our
>>> problem isn't in the MFGPT, but rather in the timer tick (because, as
>>> you said, the watchdog works).  We try to use IRQ 7 for the tick, which
>>> Andres and I totally plucked out of thin air based on what we had to work
>>> with on OLPC.  Its totally possible that the TinyBIOS had other ideas.
>>> Please try to boot with nomfgpt, and see which interrupts are free, and
>>> use mfgpt_irq= to change it to something else if 7 is in use.  Based on
>>> your findings above, you'll probably need to leave the MFGPT workaround
>>> off from now on.
>> Great analysis! I think I can confirm this too. I tried the following:
>>
>> First in mfgpt_timer_setup I commented out "clockevents_register_device"
>> result: the system still hangs with "registering the MFGT timer as a
>> clock event" !
>>
>> Then I also commented out "ret = setup_irq(irq, &mfgptirq)".
>> result: system boots, voila!
> 
> Hmmm - not sure whats happening here.  I wonder if we're stuck in an
> interrupt storm of some sort as soon as you register the interrupt handler.
> But I would think that whatever was causing the interrupt storm would be
> running well before we hit setup_irq(), and you would be recording "nobody
> cared" interrupts left and right.

Interesting thing is that it hangs not in setup_irq() but later, right
after printing the newline of the printk.

> The thing that scares me is that the TinyBIOS seems to know that we want
> to use the MFGPT timers, and I wonder if they did anything behind the scenes
> to "help us out" even though we didn't ask for it.
> 
> I don't know how easy it would be for you - but can you try reading 
> MSRs 0x51400020 - 0x51400023?   If you need a command line app to do it,
> you can use rdmsr from here:
> 
> http://wiki.laptop.org/go/Flashing_LinuxBIOS_on_A-Test_Boards

MSR register 0x51400020 => b7:ef:5f:f4:bf:d1:95:68
MSR register 0x51400021 => b7:fd:1f:f4:bf:cf:5a:d8
MSR register 0x51400022 => b7:f3:bf:f4:bf:f5:fb:a8
MSR register 0x51400023 => b7:fb:9f:f4:bf:fd:d9:f8

> 
>> Watchdog for the new API would be great :-)
> 
> Coming soon.
> 
> Jordan

Arnd

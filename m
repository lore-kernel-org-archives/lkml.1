Return-Path: <linux-kernel-owner+w=401wt.eu-S1759802AbYAQVvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802AbYAQVvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759766AbYAQVuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:50:13 -0500
Received: from slowhand.arndnet.de ([88.198.19.76]:38527 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759755AbYAQVuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:50:10 -0500
Message-ID: <478FCDB6.4010708@i4.informatik.rwth-aachen.de>
Date: Thu, 17 Jan 2008 22:50:46 +0100
From: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
References: <478E4267.7020509@i4.informatik.rwth-aachen.de> <20080116161912.7b449466@ephemeral> <20080116165606.3ebc06a4@ephemeral> <478F25D6.3060503@i4.informatik.rwth-aachen.de> <20080117134032.4cc1a1cf@ephemeral> <478FB255.5040001@i4.informatik.rwth-aachen.de> <20080117211917.GF8244@cosmic.amd.com>
In-Reply-To: <20080117211917.GF8244@cosmic.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse schrieb:
> On 17/01/08 20:53 +0100, Arnd Hannemann wrote:
>> Andres Salomon schrieb:
>>> On Thu, 17 Jan 2008 10:54:30 +0100
>>> Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:
>>>
>>>> Andres Salomon schrieb:
>>>>> On Wed, 16 Jan 2008 16:19:12 -0500
>>>>> Andres Salomon <dilinger@queued.net> wrote:
>>>>>
>>>>>> On Wed, 16 Jan 2008 18:44:07 +0100
>>>>>> Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:
>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> I'm trying to boot 2.6.24-rc8 on a GEODE LX board (ALIX.3),
>>>>>>> and it hangs during boot:
>>>>>>>
>>>>>>> [   12.689971] NET: Registered protocol family 16
>>>>>>> [   12.703329] geode-mfgpt:  Registered timer 0
>>>>>>> [   12.716149] mfgpt-timer:  registering the MFGT timer as a clock event...
>>>>>>>
>>>>>> What BIOS are you using?  It's possible that our detection code is
>>>>>> failing to detect in-use timers.
>>>> I'm using v0.99 (latest available).
>>>
>>> v0.99 of what?  Jordan seems to think it's an Award BIOS, but I'd like
>>> to make sure.
>> Its an ALIX board from PCEngines, they have their own BIOS
>> implementation (tinyBios).
>> http://www.pcengines.ch/alix.htm
>>
>>>> Also note when I do enable the mysterios "MFGPT workaround" option in
>>>> the bios the machine hangs directly after:
>>>> [   36.780990] NET: Registered protocol family 16
>>>
>>> "MFGPT workaround"?  That sounds a bit frightening.
>>>
>>> Presumably, the BIOS is using the MFGPTs, but we're not detecting them as
>>> being in use.
>> Yes I think so too, for the fun of it I compiled a 2.6.16.29 kernel with
>> the attached patch from fi4l.
> 
> Okay - thats an MFPGT patch from pre-OLPC days. I am the guilty and
> dubious party.  We changed the API to work better with the timer tick,
> and thats the version that ended up in the kernel.
> 
> I really wish I could take back this patch, because it keeps coming back
> to torment me.  We must, as a people, put it behind us and forgot it. :)
> 
>> relevant output is this:
>> [   31.015425] geode-mfgpt:  7 timers available.
>> ...
>> [   31.245875] geode-mfgpt:  Registered timer 0
> 
>> So the above kernel detects only 7 timers not 8, and it works. But note
>> that timer 0 is not used as a clock event source but as a watchdog,
>> which btw actually works fine :-)
> 
> It detects 7 timers because of a bug in the code -  there really are 8 
> timers, which the current code correctly identifies.
Yes I can confirm this, changed MFGPT_MAX_TIMERS from 7 to 8 in the old
kernel and it still works.

>> The funny thing is the #define workaround part of this dubious patch and
>> its interaction with the bios:
>>
>> #ifdef WORKAROUND:
>>  I have to turn the "MFPGT workaround" option in the bios ON, to boot
>> the kernel probably.
>>
>> #ifndef WORKAROUND:
>>  I have to turn the "MFPGT workaround" option in the bios OFF, to boot
>> the kernel probably.
> 
> So the workaround works around the workaround.   Fun.  I think that Mitch
> Bradley verified that if you write the magic MSR when all the clocks are
> already clear that bad things happen.  The workaround probably adds a 
> dummy clock in.  Notice that the "magic MSR" no longer is in the vanilla
> code, and thats the way it should be.  If the BIOS doesn't allow use of
> the clocks, then we have to live with that.
> 
> So, based on everything you are saying, I think its clear that our
> problem isn't in the MFGPT, but rather in the timer tick (because, as
> you said, the watchdog works).  We try to use IRQ 7 for the tick, which
> Andres and I totally plucked out of thin air based on what we had to work
> with on OLPC.  Its totally possible that the TinyBIOS had other ideas.
> Please try to boot with nomfgpt, and see which interrupts are free, and
> use mfgpt_irq= to change it to something else if 7 is in use.  Based on
> your findings above, you'll probably need to leave the MFGPT workaround
> off from now on.
Great analysis! I think I can confirm this too. I tried the following:

First in mfgpt_timer_setup I commented out "clockevents_register_device"
result: the system still hangs with "registering the MFGT timer as a
clock event" !

Then I also commented out "ret = setup_irq(irq, &mfgptirq)".
result: system boots, voila!

However the vendor claims that 7 should be used (from the bios changelog):
"v0.90 (IRQ7 is no longer directed to the LPC bus, used as a default
interrupt for MFGPT high resolution timer."

There is also a interrupt map in the bios[0] readme:

IRQ0    timer
IRQ1    KBD (LPC)
IRQ2    cascade
IRQ3    COM1 serial (internal / LPC)
IRQ4    COM2 serial (LPC)
IRQ5    audio (CS5536)
IRQ6    FDC (LPC)
IRQ7    spare, used for MFGPT high resolution timer

IRQ8    RTC
IRQ9    PCI INTA
IRQ10   PCI INTB
IRQ11   PCI INTC
IRQ12   PCI INTD
IRQ13   floating point
IRQ14   IDE HDD
IRQ15   USB (CS5536)

/proc/interrupts on a running system looks like this:
           CPU0
  0:      12329          XT-PIC  timer
  2:          0          XT-PIC  cascade
  4:        240          XT-PIC  serial
  8:          3          XT-PIC  rtc
  9:        558          XT-PIC  wifi0
 10:      67591          XT-PIC  eth0
 11:        622          XT-PIC  wifi1
NMI:          0
ERR:          0

> I'll port the watchdog timer to the new API, and we can use that instead
> of the timer tick to just make sure that it isn't the timer that is broken.
> Also, hopefully that will cease the stream of angry emails asking me why
> the ancient patch doesn't work on a current kernel... :)
Watchdog for the new API would be great :-)

> Jordan
Thanks for your effort!

[0] http://www.pcengines.ch/file/alixb099.zip

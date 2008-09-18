Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbYIRVud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbYIRVud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 17:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbYIRVtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 17:49:50 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:64346 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbYIRVtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 17:49:47 -0400
Message-ID: <f488382f0809181449x7343aa7endff066cb5836a73c@mail.gmail.com>
Date: Thu, 18 Sep 2008 14:49:45 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <43e72e890809181344q416b5944w3332ee5a33db048c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
	 <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
	 <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com>
	 <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com>
	 <43e72e890809181344q416b5944w3332ee5a33db048c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 1:44 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Sep 18, 2008 at 12:00 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>> On Thu, Sep 18, 2008 at 11:42 AM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>>> On Thu, Sep 18, 2008 at 11:34 AM, Luis R. Rodriguez
>>>> irqpoll is a monster of evil and that should make your system crawl to
>>>> its knees. I would advise instead we work with you fixing the the
>>>> missed interrupts issue upon rmmod.
>>>
>>> Also, please provide the output of
>>>
>>> cat /proc/interrupts
>>
>> Note that the problem necessitating use of irqpoll in the first place
>> seems to only happen under certain conditions. I am unsure what these
>> conditions are. Before 'ath9k: connectivity is lost after Group
>> rekeying is done',
>
> You mean this patch:
>
> [PATCH] ath9k: connectivity is lost after Group rekeying is done
> http://marc.info/?l=linux-wireless&m=122163541519736&w=2
>
> So let me get this straight -- you applied this new patch, and haven't
> tried disabling irqpoll now?

I hadn't at the time of that writing, no. I saw it as a fix for future
ignored IRQs, and hadn't noticed any difference with it on or off. So
it seemed like since there was no consequence having it enabled, why
not leave it enabled all the time?

Now that I'm aware it's the spawn of satan, I'm trying with it off. So
far, so good. But I haven't had need to reload ath9k so frequently,
and even when I do, I can't reproduce the specific conditions which
caused the problem in the first place.

>> I had used rmmod/modprobe as my solution to the
>> issue, which triggered the IRQ issue.
>
> Understood, but I also have used this before with ath9k and I got
> exactly the same results you did -- I just refused to use it again and
> just try to fix the issues present.
>
> ath9k issues tons of interrupts, not sure why irqpoll option would
> cause latency so bad as the interrupts *are* handled. Not sure
> *exactly* how irqpoll works but its description mentions using it
> forces each interrupt handler on the IRQ line to check the interrupt
> is for it. You have to keep in mind that not only are ath9k interrupts
> then being sent to the devices on its line but it would seem that all
> other devices on each line would suffer from the interrupts of the
> other guys. Why ath9k would be the *only* culprit of causing latency
> when using irqpoll if the irq line it son is clean? Beats me.

I'm guessing there's at least one interrupt that wasn't accounted for somehow.

>
>> alcarin steven # cat /proc/interrupts
>>           CPU0       CPU1
>> 0x0:      63227          0   IO-APIC-edge      hpet
>> 0x8:          1          0   IO-APIC-edge      rtc0
>> 0x9:      13080          0   IO-APIC-fasteoi   acpi
>> 0xe:       8195          0   IO-APIC-edge      ide0
>> 0xf:          0          0   IO-APIC-edge      ide1
>> 0x10:         36          0   IO-APIC-fasteoi   uhci_hcd:usb5
>> 0x11:      10645          0   IO-APIC-fasteoi   ath
>
> In this case your 11n Atheros device is on a clean line.
>
>> 0x12:         42          0   IO-APIC-fasteoi   uhci_hcd:usb4
>> 0x17:        919          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
>
> But it was this interrupt line which had an interrupt not handled.

No, it's in hex. 0x17 = 23, 0x11 = 17. IRQ 17 is the one that pooped
in my case, which is my wireless chipset.

>> 0x13:      32885          0   IO-APIC-fasteoi   uhci_hcd:usb3,
>> ata_piix, ohci1394
>> 0x200100:          1          0   PCI-MSI-edge      eth0
>> 0x16:        223          0   IO-APIC-fasteoi   HDA Intel
>> NMI:          0          0   Non-maskable interrupts
>> LOC:      78087      95718   Local timer interrupts
>> RES:      11576      16384   Rescheduling interrupts
>> CAL:       6862       8889   Function call interrupts
>> TLB:         54         41   TLB shootdowns
>> TRM:          0          0   Thermal event interrupts
>> THR:          0          0   Threshold APIC interrupts
>> SPU:          0          0   Spurious interrupts
>> ERR:          0
>
> Can you try to reproduce the irq not handled again?

If I do, I'll need to know what precisely to do about it. What debug
info should I collect before rebooting?

>
>>>
>>> and also please do not cross post to all these lists, just use
>>> linux-wireless or ath9k.
>>>
>>
>> Sorry, but in the past I've posted to linux-wireless, ath9k-devel, and
>> all the maintainers of ath9k and didn't get a single response (except
>> a 'me too' from a fellow ath9k user). I didn't just want to hear
>> crickets this time.
>
> Patches speak more than words, but yeah sorry, we should have
> addressed this there. I've personally have just been busy with
> tackling aggregation.
>

Which is far more important, I agree. It's annoying to get speeds
<802.11b on my pre-802.11n capable chipset and network. ;)

- Steven

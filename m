Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbYGaOg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbYGaOg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYGaOgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:36:49 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:32279 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbYGaOgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:36:47 -0400
X-BigFish: VPS-23(zz1dbaM146fK1432R98dR936eQ4015M1805Mzz10d3izzz32i6bh87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4VKKT-02-Q2P-01
Date: Thu, 31 Jul 2008 08:36:35 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
CC: Andres Salomon <dilinger@debian.org>, linux-geode@bombadil.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: MFGPT driver inhibits boot on some boards
Message-ID: <20080731143635.GA12585@cosmic.amd.com>
References: <48916864.901@LiPPERTEmbedded.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48916864.901@LiPPERTEmbedded.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 31 Jul 2008 14:36:28.0670 (UTC) FILETIME=[D153F9E0:01C8F31A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/08 09:23 +0200, Jens Rottmann wrote:
> The driver defaults to IRQ7. Our boards use this for the parallel port.
> This alone would be ok, but the parallel port is on a LPC SIO, so IRQ7
> is routed to the LPC bus in MSR 51400025, so MFGPT IRQs are not received.
> 
> Possible solution 1: make geode_mfgpt_set_irq() clear the needed bit in
> MSR 51400025. This would break lp0, but at least Linux would boot and
> users could cat /proc/interrupts and see what's going on.
> 
> Possible solution 2: make geode_mfgpt_set_irq() check the bit and fail
> if the IRQ is routed to LPC. (I think I'd prefer this over 1.)

Either of these solutions is the "right" solution. I prefer automatically
detecting the SIO interrupts and finding a free interrupt. 

> But that's not clean, even an IRQ not routed to LPC might be the wrong
> one. The BIOS we're using (Insyde BIOS, uses VSA and 5 MFGPTs, but
> leaves 3 timers available) exports a PCI header for MFGPT, which of
> course gets an IRQ assigned (LNKB-->IRQ11), and this is the right IRQ to
> use. Some autodetection instead of hardcoding IRQ7 would be perfect. But
> looking for the PCI header won't work, because AMD removed them from the
> spec, most BIOSes don't support them (any more) and some day our BIOS
> will hide them, too.

I know the platform you are talking about - that was a special test case
the MFGPT header.  It would have become standard, but then circumstances
intervened, and we lost the resources to push that into the VSA and
to all of our BIOS vendors.  It is easiest for us to assume that we won't
have the PCI header for the MFGPT.

> I guess MSR 51400022 aka MSR_PIC_ZSEL_LOW is the key here.
> geode_mfgpt_set_irq() overwrites this unconditionally, which I think is
> bad. If the BIOS has already set an IRQ here, the driver should keep it
> and assume it to be ok.

Agreed.

> Possible solution 3: keep the IRQ already chosen in MSR_PIC_ZSEL_LOW
> unless it's 0, only in that case use IRQ7

This goes against our basic policy of not trusting the BIOS.

> But how about CMP1 and CMP2? geode_mfgpt_set_irq() currently sets IRQs
> for both, but I think it's better to only read/set the IRQ for the
> requested CMP, because they might differ.
> 
> In fact, they do differ, because pairs of MFGPTs always share an IRQ
> (stupid idea, that): E.g. VSA sets CMP1 of MFGPT7 to IRQ2, so its twin
> MFGPT3, which itself is available, has its CMP1 also set to IRQ2. But
> the clocksource driver only requests CMP2, so MFGPT3 could still be used.

> Possible solution 4: only touch the CMP actually requested. But also
> fail if this CMP is set to IRQ2, because this means VSA is using its twin.

The main problem with this is configuring your second timer wrong, and
it fires on the wrong interrupt.  I believe thats why we added this
code in the first place.  I wouldn't be opposed to removing it, though,
assuming that we can avoid confusion when trying to use paired GPIOs.

> IMHO hardcoding IRQ7 is bad. Yes, you can override it, but this isn't
> some non-critical device driver like audio where only this one device
> won't work. And MFGPT can't be compiled as module, so initramfs can't do
> anything about it.
> I think, if there is any chance to do it, Linux should be able to boot
> without any parameters given - even if with reduced functionality.

I agree 100%.

> Now about the baseaddress issue:
> 
> 
> The problem is that Linux upon PCI scan detects a resource conflict
> (which in fact is none, but Linux cannot know that) and moves the
> resources (MFGPT IO space among them) to some other place.
> 
> But init_lbars() in geode_32.c has saved all base addresses in an array
> _before_ the move, and geode_get_dev_base() and geode_mfgpt_write() keep
> using these addresses _after_ the move.

> Possible solutions 5-7:
> * drop the array and always read the baseaddr from the MSR - but this
>   would impact performance quite a lot, I guess
> * run init_lbars() only after the PCI scan - but they might be needed
>   before that, and what if someone changes the base again, say with
>   setpci?
> * update the array every time the base is changed - but I have no idea
>   how to do that ...
> 
> Anyway, the baseaddr issue is not that serious for me, I will probably
> be able to fix the bogus resource conflict that triggers the baseaddr
> move, and this issue will disappear. But still - mfgpt will still crash
> again if someone moves the resource for any reason ...

This does sound like a problem with your particular system - Linux can 
move the resource space, but if it has to, then I generally consider
that to be a BIOS issue.  But that said, the point of Linux is to work
around buggy BIOSen.  So, lets consider:

The GPIO code has to run before the PCI code for various reasons, so moving
it really isn't an option.  Reading the base MSR every time wouldn't affect
performance too badly (its an MSR, not I/O), but that would be ugly.

I guess i don't know much about how PCI manages changes to the resources
through setpci and other mechanisms.  This seems like it would break a
lot of drivers.  If there is a notifier or something that we can tie into
great, but perhaps this is a case of "user beware".  Anybody else concur?

> 
> Well, that's what I've figured out so far. (Thanks if you're still
> reading on!)  :-)   I might be able to implement some fixes for the IRQ
> issue, but I'd like your opinion first. What do you think?

Yes, please do - the interrupt problem only bites us occasionally, but
when it does, it hurts.

Thanks,
Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


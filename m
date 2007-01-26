Return-Path: <linux-kernel-owner+w=401wt.eu-S1030694AbXAZB2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030694AbXAZB2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 20:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030695AbXAZB2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 20:28:45 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40077 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030694AbXAZB2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 20:28:44 -0500
Date: Thu, 25 Jan 2007 17:28:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
In-Reply-To: <1169770985.3593.146.camel@shinybook.infradead.org>
Message-ID: <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain> 
 <1169741658.3593.98.camel@shinybook.infradead.org> 
 <20070125172739.0c990a9a@localhost.localdomain> 
 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>
 <1169770985.3593.146.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Jan 2007, David Woodhouse wrote:
> 
> You're thinking of MMIO, while the case we were discussing was PIO. My
> laptop is perfectly happy to assign PIO resources from zero.

I was indeed thinking MMIO, but I really think it should extend to PIO 
also. It certainly is (again) true on PC's, where the low IO space is 
special and reserved for motherboard/system devices.

If you want to be different, that's YOUR problem. Some architectures have 
tried to look different, and then drivers break on them, but they have 
only themselves to blame.

> I believe PCMCIA just uses the generic resource code, which also seems
> to lack any knowledge of this hackish special case for zero.

The resource code actually knows what "enabled" means. A lot of other code 
does not.

> > kernel and all devices are concerned, "!dev->irq" means that the irq 
> > doesn't exist or hasn't been mapped for that device yet).
> 
> So again you end up in a situation where zero is a strange special case.

No. We end up in a situation where *drivers* never have any strange or 
special cases. 

You need to have a "no irq" thing. It might as well be zero, since that is 
not just the de-facto standard, it's also the one and only value that 
leads to easily readable source-code (ie test it as a boolean in C).

The exact same thing has been true of MMIO. I would be not at all 
surprised if several drivers do the same for PIO.

It's something you can trust on a PC. See above on your problems if you 
decide that you want to be "generic" and use a value that is illegal on 
99% of all hardware.

> It doesn't need to be per-architecture; it can just be -1.

Bollocks. People tried that. People tried to force this idiotic notion of 
"NO_IRQ" down my throat for several years. I even accepted it.

And then, after several years, when it was clear that it still didn't 
work, and drivers just weren't getting updated, it was time to just face 
reality: if the choice is between 0 and -1, 0 is simply much easier for 
the bulk of the code.

Live with it, or don't. I really don't care what you do on your hardware. 
But if you can't face that

	if (!dev->irq)
		..

is simpler for people to write, and that it's what we've done for a long 
time, then that really is YOUR problem.

The exact same issues have been true in MMIO. Some code will keep track of 
separate "enabled" bits: the resource management code is such code. Guess 
what? Not a lot of drivers tend to do that. You can try to fight 
windmills, or you can just accept that the very language we use (namely, 
C) has made 0 be special, and tends to be used to say "nobody home" simply 
because it has that special meaning for a C compiler.

And I bet there are PIO devices out there that consider address zero to be 
disabled. For EXACTLY the same reason.

(And yes, hardware actually tends to do the same thing. For PCI irq 
routing registers, an irq value of 0 pretty much universally means 
"disabled". In fact, even your lovely Cardbus example actually is an 
example of exactly this: the very IO limit registers are DEFINED IN 
HARDWARE to special-case address zero - so that making the base/limit 
registers be zero actually disables the IO window, rather than making it 
mean "four IO bytes at address zero").

But hey, if it works for you, go wild. Just don't expect drivers to always 
work.

		Linus

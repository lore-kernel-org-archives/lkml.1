Return-Path: <linux-kernel-owner+w=401wt.eu-S1030671AbXAZAXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030671AbXAZAXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 19:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030673AbXAZAXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 19:23:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46124 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030671AbXAZAXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 19:23:22 -0500
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
	controllers
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain>
	 <1169741658.3593.98.camel@shinybook.infradead.org>
	 <20070125172739.0c990a9a@localhost.localdomain>
	 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 26 Jan 2007 08:23:05 +0800
Message-Id: <1169770985.3593.146.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-01-25 at 09:56 -0800, Linus Torvalds wrote:
> Broken architectures that put PCI things at some "PCI physical address 
> zero" need to map their PCI addresses to something else. It's part of why 
> we have the whole infrastructure for doing things like
> 
> 	pcibios_bus_to_resource()
> 	pcibios_resource_to_bus()
> 
> etc - not just because a resource having zero in "start" means that it is 
> disabled, but because normally such broken setups have *other* problems 
> too (ie they don't have a 1:1 mapping between PCI addresses and physical 
> addresses _anyway_, so they need to address translations).

You're thinking of MMIO, while the case we were discussing was PIO. My
laptop is perfectly happy to assign PIO resources from zero.

The claim that "zero is disabled" is a relatively new (and IMO broken)
thing, and doesn't seem to be universal. This bizarre new special case
certainly isn't shared by the PCMCIA code, for example, which is quite
happy to put devices are PIO address 0...

shinybook /root # cat /sys/class/pcmcia_socket/pcmcia_socket0/available_resources_io 
0x00000000 - 0x007fffff
shinybook /root # dmesg | grep 'max PIO'
ata2: PATA max PIO0 cmd 0x0 ctl 0xE bmdma 0x0 irq 53
ata2.00: CFA, max PIO4, 500400 sectors: LBA 

I believe PCMCIA just uses the generic resource code, which also seems
to lack any knowledge of this hackish special case for zero.

> This has come up before. For example: for an IRQ, 0 means "does not 
> exist", it does _not_ mean "physical irq 0", and we test for whether a 
> device has a valid irq by doing "if (dev->irq)" rather than having some 
> insane archiecture-specific "IRQ_NONE". And if you validly really have an 
> irq at the hardware level that is zero, then that just means that the irq 
> numbers you should tell the kernel should be translated some way.
>
> (On a PC, hardware irq 0 is a real irq too, but it's a _special_ irq, and 
> it is set up by architecture-specific code. So as far as the generic 
> kernel and all devices are concerned, "!dev->irq" means that the irq 
> doesn't exist or hasn't been mapped for that device yet).

So again you end up in a situation where zero is a strange special case.
It works sometimes (setup_irq()) but not other times, and has meaning in
some places but not others. Once we go tickless and I start playing with
the PC speaker audio driver again, that hackish special case is going to
be fun to play with, I'm sure.

And your IRQ numbers no longer match the labels on the IRQ lines in the
hardware documentation; you have to have some 'mapping', which should
ideally be used for user-visible displays of IRQ numbers too.

That doesn't really sound much like the 'CLEANEST SOURCE CODE' to me. 

Programmers do seem to cope with comparing file descriptors with -1.
Counting from zero is quite normal. But would you suggest that our "zero
is invalid" policy should extend to those too, just in case our kernel
hackers can't manage? Obviously userspace programs will still expect
stdin to be fd #0 but glibc can fix that up for us -- it can handle the
"should be translated in some way" requirement of which you speak, so
that we can have the special case which seems to be permeating the
kernel.

> So there are three issues:
> 
>  - we always need a way of saying "not mapped"/"nonexistent", and using 
>    the value zero is the one that GIVES THE CLEANEST SOURCE CODE! It's why 
>    NULL pointers are zero too. Sure, virtual address zero is a real 
>    virtual address, but that doesn't change the fact that C made 0 be 
>    special on a language level. If you want to access that virtual 
>    address, and use NULL as a "doesn't exist" at the same time, you need 
>    to swizzle your pointer somehow.

Really, it doesn't make the code cleaner when you have to add a whole
layer of translation just because of a single misguided special case.
The "special case" of NULL isn't really a special case because we just
refrain from _mapping_ that page. We don't actually treat it any
differently.
 
>  - the x86[-64] architecture is the one that gets tested the most. So 
>    everybody else should try to look like it, rather than say "we are 
>    different/better/strange". Don't have any special IO instructions? 
>    Tough. You'd better do "inb/outb" anyway, and map them onto your 
>    memory-mapped IO somehow.

I look forward to pretending the world is little-endian and
dma-coherent, and doesn't need memory barriers :)

>  - per-architecture magic values is a bad idea. If you need a magic value 
>    (and things like this _do_ need one, unless we always want to carry a 
>    separate flag around saying "valid" or "not valid"), it's a lot better 
>    to just say "everybody uses this value" and then have the _small_ 
>    architecture-specific code work around it, than have everybody have to 
>    work around a lot of architectures doing things differently.

It doesn't need to be per-architecture; it can just be -1. The only
reason it was per-arch before is because some architectures were using
zero and someone considered it easier to #define NO_IRQ rather than just
making it consistent.

> All these issues boil down to the same thing: whenever at all physically 
> possible, we make sure that everything looks as much as a PC as possible. 
> Only when that literally isn't an option do we add other abstractions.

No, Linux is better than that. We tend to use models which encompass the
PC and other systems, and we're actually quite good at it.

The argument falls down a little more when we observe that our
assumptions about zero aren't necessarily valid on a PC either. On a PC,
IRQ0 _is_ valid, and the current code is inconsistent and confusing.
Even the PC needs some hackish "IRQ mapping" if we actually put our
money where your mouth is and make the code self-consistent by doing
something like this:

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -220,7 +220,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
        unsigned long flags;
        int shared = 0;
 
-       if (irq >= NR_IRQS)
+       if (!irq || irq >= NR_IRQS)
                return -EINVAL;
 
        if (desc->chip == &no_irq_chip)


PIO address 0 is also valid on a PC -- assuming you have the NO_ISA bit
turned off on any PCI bridges in the path. And even on a PC I've
sometimes had to manually clear that bit in order to get PCMCIA resource
assignment to work. 

PCMCIA resource assignment can be hard enough already without
gratuitously throwing away a perfectly valid location on the grounds
that we've lost the ability to use zero. 

This is a computer. We count from zero.

-- 
dwmw2


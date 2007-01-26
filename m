Return-Path: <linux-kernel-owner+w=401wt.eu-S1030770AbXAZGBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030770AbXAZGBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030772AbXAZGBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:01:32 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47241 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030770AbXAZGBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:01:31 -0500
Date: Thu, 25 Jan 2007 22:01:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
In-Reply-To: <1169788181.3593.250.camel@shinybook.infradead.org>
Message-ID: <Pine.LNX.4.64.0701252125280.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain> 
 <1169741658.3593.98.camel@shinybook.infradead.org> 
 <20070125172739.0c990a9a@localhost.localdomain> 
 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org> 
 <1169770985.3593.146.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org> 
 <1169778239.3593.195.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0701251832040.25027@woody.linux-foundation.org> 
 <1169782107.3593.219.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0701251932250.25027@woody.linux-foundation.org> 
 <1169785150.3593.231.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0701252029570.25027@woody.linux-foundation.org>
 <1169788181.3593.250.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Jan 2007, David Woodhouse wrote:
> 
> My question was about _how_ you think this should be achieved in this
> particular case.

I already told you.

Have you noticed that the resource-allocation code _already_ never returns 
zero on a PC?

Have you noticed that the resource-allocation code _already_ never returns 
zero on sparc64?

Your special-case hack would actually be actively *wrong*, because the 
resource-allocation code already does this correctly.

But by "correctly" I very much mean "the architecture has to tell it what 
the allocation rules are".

And different architectures will have different rules.

On x86[-64], the reason the allocation code never returns a zero is 
because of several factors:

 - PCIBIOS_MIN_IO is 0x1000
 - PCIBIOS_MIN_CARDBUS_IO is 0x1000
 - the x86 arch startup code has already reserved all the special ranges, 
   including IO port 0.

so on a PC, no dynamic resource will _ever_ be allocated at zero simply 
because there are several rules in place (that the resource allocation 
code honors) that just makes sure it doesn't.

Now, the reason I say that it needs the architecture-specific code to tell 
it those rules is that on other architectures, the reasons for not 
returning zero may simply be *different*.

For example, on other platforms, as I already tried to explain, the root 
PCI bus itself may not even start at 0 at all. You may have 16 bits worth 
of "PIO space", but for all you know, you may have that for 8 different 
PCI domains, and for all the kernel cares about, the domains may end up 
mapping their PCI IO ports in any random way. For example, what might 
"physically" be port 0 on domain0 might be mapped into the IO port 
resource tree at 0xff000000, and "physical port 0" in domain1 might be at 
0xff010000 - so that the eight different PCI domains really end up having 
8 separate ranges of 64k ports each, covering 0xff000000-0xff07ffff in the 
IO resource map.

See? I tried to explain this to you already..

If you are a cardbus device, and you get plugged in, your IO port range 
DOES NOT GET allocated from "ioport_resource". No, no, no. It gets 
allocated from the IO resource of the cardbus controller. And _that_ IO 
resource was allocated within the resource that was the PCI bridge for the 
PCI bus that the cardbus controller was on. And so on, all the way up to 
the root bridge on that PCI domain.

And on x86, the root bridge will use the ioport_resource directly, since 
it will always cover the whole area from 0 - IO_SPACE_LIMIT.

But that's an *architecture-specific* choice. It makes sense on x86, 
because that's how the IO ports physically work. They're literally tied to 
the CPU, and the CPU ends up being in that sense the "root" of the IO port 
resources.

But on a lot of non-x86 architectures, it actually could make most sense 
to never use "ioport_resource" AT ALL (in which case "cat /proc/ioports" 
will always be empty), and instead make the root PCI controller have it's 
IORESOURFE_IO resource be a resource that is then mapped into 
"iomem_resource". Because that's _physically_ how most non-x86 
architectures are literally wired up.

See? Nobody happens to do that (probably because a number of them want to 
actually emulate ISA accesses too, and then you actually want to make the 
PIO accesses look like a different address space, and probably because 
others just copied that, and never did anything different), but the point 
is, the resource allocation code really doesn't care. And it _shouldn't_ 
care. Because the resource allocation code tries to be generic and cater 
to all these *different* ways people hook up hardware.

Now, I should finish this by saying that there's a number of legacy 
issues, like the fact that "ioport_resource" and "iomem_resource" actually 
even *exist* for all platforms. As mentioned, in some cases, it would 
probably actually make more sense to not even have "ioport_resource" at 
all, except perhaps as a sub-resource of "iomem_resource" (*).

So a lot of this ends up then beign slightly set up in certain way - or at 
least only tested in certain configurations - due to various historical 
reasons.

For example, we've never needed to abstract out the IO port address 
translations as much as we did for MMIO. MMIO has always had 
"remap_io_range()" and other translator functions, because even x86 needed 
them. The PIO resources have generally needed less indirection, not only 
because x86 can't even use them *anyway* (for the "iomap" interfaces we 
actually do the mapping totally in software on x86, because the hardware 
cannot do it), but also because quite often, PIO simply isn't used as 
much, and thus we've often ended up having ugly hacks instead of any real 
"IO port abstraction".

For an example of this, look at the IDE driver. It has a lot of crap to 
just allow other architectures to just use their own MMIO accessors 
instead of even trying to abstract PIO some way. So the PIO layer actually 
lacks some of the abstraction, simply because it's no used very much.

		Linus

(*) It should actually be possible to really just let an architecture 
insert the "ioport_resource" as a sub-resource of the "iomem_resource". It 
would be a bit strange, with "cat /proc/iomem" literally as part of it 
showing all the same things that "cat /proc/ioport" shows, but it would 
really be technically *correct* in many ways. BUT! I won't guarantee that 
it works, simply because I've never tried it. There might be some reason 
why something like that would break.

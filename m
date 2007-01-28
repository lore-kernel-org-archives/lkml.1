Return-Path: <linux-kernel-owner+w=401wt.eu-S932944AbXA1WwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944AbXA1WwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 17:52:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932947AbXA1WwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 17:52:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:53414 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932944AbXA1WwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 17:52:04 -0500
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
	controllers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, David Woodhouse <dwmw2@infradead.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain>
	 <1169741658.3593.98.camel@shinybook.infradead.org>
	 <20070125172739.0c990a9a@localhost.localdomain>
	 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 09:49:40 +1100
Message-Id: <1170024580.26655.89.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Indeed. Zero means "not in use". It really is that simple. 

I tried to avoid stepping into that specific flamewar as I don't have
strong opinions either way, but I've been asked to so ... and there are
a few things in your statement that I do like to argue about a bit :-)

> And I'm sorry, David, but 99% of the world _is_ a PC, and that is where 
> PCI and ATA came from, so anybody who thinks that zero is a valid PCI 
> address is just sadly mistaken and has a bug. In fact, even on a hardware 
> level, a lot of devices will literally have "zero means disabled".
> 
> Broken architectures that put PCI things at some "PCI physical address 
> zero" need to map their PCI addresses to something else. It's part of why 
> we have the whole infrastructure for doing things like

As I said, I don't have a firm pro/con position in that matter, but I
notice that we had some firmwares putting things at IO port 0 for a
while now and it generally worked for what we did with it.

I do still think that there is some value to the argument that, for IO
ports (and I'm really talking about IO ports here, the HW one, not
what's in the struct resource which may or may not be the actual HW IO
port number depending on how the arch implements them) :

 - 0 is valid and works fine on some platforms with some devices
 - 0 seems to be in some rare cases the only valid/useable spot
   according to David and even pretty common in pcmcia land
 - some existing firmwares -are- allocating things at 0 and having
   to relocate things is a pain.

Thus, based on that, while I -do- agree that it's a bad idea to
purposefully put things at 0 if you can avoid it (looking for trouble...
I always tell FW folks to start assigning IO ports at 0x1000), I don't
think it's nice to say that it's ok for drivers to use it as a special
case and thus intentionally break some of the cases that would have
worked just fine.

> 	pcibios_bus_to_resource()
> 	pcibios_resource_to_bus()
> 
> etc - not just because a resource having zero in "start" means that it is 
> disabled, but because normally such broken setups have *other* problems 
> too (ie they don't have a 1:1 mapping between PCI addresses and physical 
> addresses _anyway_, so they need to address translations).

Yes well... remapping... there are several issues with that, see below.

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

While I didn't much like your decree forcing everybody to consider IRQ 0
as invalid (I think nor everybody adapted yet even, isn't ARM still
using -1 as NO_IRQ ? BTW... I do like having a constant even if it's
defined to 0 :-) ... I do admit that writing a remapping layer on
powerpc (in part because of that, in part to solve other issues) ended
up cleaning up a lot of cruft, especially in the area of multiple
cascaded controllers.

Once the remapping layer was there, HW numbers became totally irrelevant
to anything but the controller instance they sit on, and linux irqs
became dynamically allocated virtual numbers, thus allowing to do some
tricks like 0 is always invalid or 1...15 are never assigned to anybody
except legacy 8259 if any. A nice way to fool-proof against stupid
drivers. In the end, remapping of IRQs did improve more stuffs than it
added bloat so I think it was a winning situation. Now, the next step is
to completely get rid of linux irq numbers alltogether and use irq_desc
* :-)

However, for IOs, things are a bit more annoying in several areas.
First, if you remap, do you remap at the HW level or the linux resource
content ? (And I'm talking about both PIO and MMIO here).

Because if we just do a linux remapping layer, we basically:

 - Don't solve any problem where HW actually doesn't like 0

 - Add a possibly complicated remapping layer on top of something that
doesn't necessarily need one.

Besides, there's already enough convoluted issues in the way archs remap
or don't remap PCI resources to not want to start playing more games in
that area (and possibly break X while at it, heh, I know it needs to be
fixed and Ian is working on it, but still).

Thus, if for some reason, IO resource 0 or memory resource 0 are
unacceptable, then they should probably be remapped by the arch code in
HW (moving the devices elsewhere), _NOT_ as a virtual remapping thing in
linux.

> So there are three issues:
> 
>  - we always need a way of saying "not mapped"/"nonexistent", and using 
>    the value zero is the one that GIVES THE CLEANEST SOURCE CODE!

I have to agree with that one... Though in various parts of the kernel,
we actually use resource->flags = 0 :-) And I think that's a nicer way
to do it.

That is, the resource flags define the type of what's in start/end, and
if no type ... then non existent.

Or maybe you think we should keep the information that there's actually
something like a BAR there (and thus remember it's IO/MEM type) but we
just didn't assign it ? I like keeping the resource "value" as something
totally "magic" that has no defined semantic outside of the accessors
provided to use it.

>    It's why 
>    NULL pointers are zero too. Sure, virtual address zero is a real 
>    virtual address, but that doesn't change the fact that C made 0 be 
>    special on a language level. If you want to access that virtual 
>    address, and use NULL as a "doesn't exist" at the same time, you need 
>    to swizzle your pointer somehow.
> 
>  - the x86[-64] architecture is the one that gets tested the most. So 
>    everybody else should try to look like it, rather than say "we are 
>    different/better/strange". Don't have any special IO instructions? 
>    Tough. You'd better do "inb/outb" anyway, and map them onto your 
>    memory-mapped IO somehow.

Well, for IO space, most non-x86 archs basically ioremap some magic area
of bus space used to generate IO cycles, put that virtual address in a
global, and have inb/outb add that as an offset to the port number.

That means that port numbers are kept intact (0 based) and I don't see
the need to add another remapping layer on top of that. Works fine.

If you want 0 to be an illegal port number, then make it so by having
the arch code actually -move- the device elsewhere, don't add a
remapping trick to please drivers.

>  - per-architecture magic values is a bad idea. If you need a magic value 
>    (and things like this _do_ need one, unless we always want to carry a 
>    separate flag around saying "valid" or "not valid"), it's a lot better 
>    to just say "everybody uses this value" and then have the _small_ 
>    architecture-specific code work around it, than have everybody have to 
>    work around a lot of architectures doing things differently.
> 
> All these issues boil down to the same thing: whenever at all physically 
> possible, we make sure that everything looks as much as a PC as possible. 
> Only when that literally isn't an option do we add other abstractions.

They are everywhere !!! :-)

Ben.


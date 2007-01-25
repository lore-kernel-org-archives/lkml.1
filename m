Return-Path: <linux-kernel-owner+w=401wt.eu-S965031AbXAYR4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031AbXAYR4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 12:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965376AbXAYR4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 12:56:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44100 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965031AbXAYR4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 12:56:53 -0500
Date: Thu, 25 Jan 2007 09:56:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
cc: David Woodhouse <dwmw2@infradead.org>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
In-Reply-To: <20070125172739.0c990a9a@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain>
 <1169741658.3593.98.camel@shinybook.infradead.org>
 <20070125172739.0c990a9a@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jan 2007, Alan wrote:
> 
> If you want to put your bmdma address at zero then libata-sff won't help
> you at the moment, and assumes zero is a safe "not in use" value because
> the PCI layer also takes a similar view in places.

Indeed. Zero means "not in use". It really is that simple. 

And I'm sorry, David, but 99% of the world _is_ a PC, and that is where 
PCI and ATA came from, so anybody who thinks that zero is a valid PCI 
address is just sadly mistaken and has a bug. In fact, even on a hardware 
level, a lot of devices will literally have "zero means disabled".

Broken architectures that put PCI things at some "PCI physical address 
zero" need to map their PCI addresses to something else. It's part of why 
we have the whole infrastructure for doing things like

	pcibios_bus_to_resource()
	pcibios_resource_to_bus()

etc - not just because a resource having zero in "start" means that it is 
disabled, but because normally such broken setups have *other* problems 
too (ie they don't have a 1:1 mapping between PCI addresses and physical 
addresses _anyway_, so they need to address translations).

This has come up before. For example: for an IRQ, 0 means "does not 
exist", it does _not_ mean "physical irq 0", and we test for whether a 
device has a valid irq by doing "if (dev->irq)" rather than having some 
insane archiecture-specific "IRQ_NONE". And if you validly really have an 
irq at the hardware level that is zero, then that just means that the irq 
numbers you should tell the kernel should be translated some way.

(On a PC, hardware irq 0 is a real irq too, but it's a _special_ irq, and 
it is set up by architecture-specific code. So as far as the generic 
kernel and all devices are concerned, "!dev->irq" means that the irq 
doesn't exist or hasn't been mapped for that device yet).

So there are three issues:

 - we always need a way of saying "not mapped"/"nonexistent", and using 
   the value zero is the one that GIVES THE CLEANEST SOURCE CODE! It's why 
   NULL pointers are zero too. Sure, virtual address zero is a real 
   virtual address, but that doesn't change the fact that C made 0 be 
   special on a language level. If you want to access that virtual 
   address, and use NULL as a "doesn't exist" at the same time, you need 
   to swizzle your pointer somehow.

 - the x86[-64] architecture is the one that gets tested the most. So 
   everybody else should try to look like it, rather than say "we are 
   different/better/strange". Don't have any special IO instructions? 
   Tough. You'd better do "inb/outb" anyway, and map them onto your 
   memory-mapped IO somehow.

 - per-architecture magic values is a bad idea. If you need a magic value 
   (and things like this _do_ need one, unless we always want to carry a 
   separate flag around saying "valid" or "not valid"), it's a lot better 
   to just say "everybody uses this value" and then have the _small_ 
   architecture-specific code work around it, than have everybody have to 
   work around a lot of architectures doing things differently.

All these issues boil down to the same thing: whenever at all physically 
possible, we make sure that everything looks as much as a PC as possible. 
Only when that literally isn't an option do we add other abstractions.

			Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S932951AbXA1XBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbXA1XBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 18:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932957AbXA1XBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 18:01:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:38408 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932951AbXA1XBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 18:01:36 -0500
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
	controllers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <dwmw2@infradead.org>,
       Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701251751380.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain>
	 <1169741658.3593.98.camel@shinybook.infradead.org>
	 <20070125172739.0c990a9a@localhost.localdomain>
	 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>
	 <1169770985.3593.146.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org>
	 <45B95D3A.10108@pobox.com>
	 <Pine.LNX.4.64.0701251751380.25027@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 10:01:23 +1100
Message-Id: <1170025283.26655.101.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> However, in all honesty, we have triggered bugs in that area too, simply 
> because some driver code "knew" that PIO addresses could fit in 16 bits, 
> and used u16 or "unsigned short" to remember the PIO address. Both ARM and 
> Sparc was bitten by this, although usually the issue is trivial to fix 
> once found.
> 
> Also, many ISA-only drivers actually have hardcoded PIO numbers (eg 
> "0x1f0").
> 
> But yes, I would generally suggest that architectures where the PIO range 
> is really just another magic MMIO range (which is most of the non-x86 
> world, as you point out) might as well at least aim for doing the 
> remapping early (ie with "pci_resource_start()")
> 
> Making that easy was one of my goals for the "new" IO accessor functions, 
> in fact.
> 
> Not that many people actually use them.

Well, as I said, I prefer keeping PIO numbers 0 based so that legacy
crap works. If 0 is to be illegal, then remap any devive that's sitting
there, but don't do weirder remapping tricks than necessary ;-) 

Note that on PowerPC, we do actually remap PIO on non-primary busses
(well, we have to since we have to present a flat space to inx/outx).

What we do there is basically we "pick" a bus as beeing primary
(typically the one that has an ISA bridge and/or SuperIO on it) and
that's the one that gets PIO 0. Resources for device on that domain
aren't fixed up.

All other ones are fixed up in such a way that pointer arithmeric gives
you an inx/outx landing in the right spot for PCI devices.

> So *if* you use the new "iomap" interfaces, and the new "pci_iomap()" 
> things, that should actually not just allow drivers (like the ATA layer) 
> to share much more code between the PIO and MMIO cases, but it hopefully 
> actually makes it easier for strange architectures to do it all.

Yes. Though adoption of iomap is a bit slow on the driver side of
things.

> So traditionally, we've had PIO be "limited integer addresses, and some 
> drivers know magic numbers", but hopefully new drivers could at least try 
> to use some of the infrastructure where we try to help people not have to 
> deal with it so much as a special case any more.

Well, hopefully new drivers don't need PIO as it's about time people
stop releasing devices that do PIO, bloody hell ! That should have been
"deprecated use for compatibility only" from day #1 :-) In fact, if I'm
not mistaken, the PCI spec mandates that device should have an MMIO way
of doing everything that can be done via PIO nowadays no ?

Ben.



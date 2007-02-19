Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbXBSPDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbXBSPDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 10:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932339AbXBSPDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 10:03:18 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:54329 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932336AbXBSPDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 10:03:17 -0500
Date: Mon, 19 Feb 2007 10:03:16 -0500
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
Message-ID: <20070219150316.GP7582@csclub.uwaterloo.ca>
References: <45D85DA1.7090502@xs4all.nl> <20070218155445.GV7584@csclub.uwaterloo.ca> <m3ejon8afh.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3ejon8afh.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 09:42:26PM +0100, Krzysztof Halasa wrote:
> lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:
> 
> > My understanding (which is better of verified against the specs) is:
> >
> > PCI interrupts (PCI INTA to INTD) are rotated for every slot by one. So
> > slot 0, 4, 8, etc see INTA->realINTA, INTB->realINTB. INTC->realINTC,
> > INTD->realINTD
> > slot 1, 5, 9, etc see INTA->realINTB, INTB->realINTC. INTC->realINTD,
> > INTD->realINTA
> > slot 2, 6, 10, etc see INTA->realINTC, INTB->realINTD. INTC->realINTA,
> > INTD->realINTB
> > slot 3, 7, 11, etc see INTA->realINTD, INTB->realINTA. INTC->realINTB,
> > INTD->realINTC
> 
> This is common and suggested practice but the PCI specs don't require
> it. There is no rule - you can, for example, have all INT lines
> connected to a single CPU IRQ input.

The PCI spec doesn't require 4 seperate interrupts.  They certainly can
all be the same.  I do believe it does require the rotation method on
anything using PCI bridges and such if you want your card to work in PCI
compliant systems since that is how they will assume the lines are
routed and hence will assume that is how to set the interrupts.  If you
make a mainboard on the other hand you can do whatever you want since
you get to design the firmware that assigns the interrupts.

> Anyway, something has to know how the IRQs are routed. BIOS, other
> firmware, Linux.
> 
> Actually it has to be wired consistently with the BIOS (which is
> probably consistent with chipset manufacturer's instructions).

Depends if the riser card is specific to that system, or if it is
supposed to be a generic PCI card.

> Usually they are just bus splitters, they route IRQs and IDSELs
> (and maybe JTAG) as required by the BIOS, all others pins are
> connected 1:1.
> 
> I.e., they are completely transparent, generally comply to PCI specs
> and are dedicated to a specific motherboard(s).

Well dedicated hardware would be different.  Of course if it is
dedicated the BIOS better do the right thing when configuring it.

> Actually I think (would have to check the specs for sure) every
> subdevice (function) may use just one interrupt line.

It may.  But using just INTB and INTD on a card is not allowed by the
spec as far as I understand it.

> This rotating INTx scheme is common because it's cheap. There are
> systems which support more than 4 shared INTs per bus, for example
> you can have different sets of 4 INTx lines for every PCI slot, even
> if all slots are on the same PCI bus.

Sure.  But if you have a PCI to PCI bridge on a card, then you only get
4 interrupt lines into the card, and you have to distribute them by the
spec to the chips behind the bridge if you want the system to know how
the interrupts should be used (although I guess a driver could do its
own thing if it really wanted to).

> Correct. This scheme assumes at most 4 single-function devices
> on the bus, otherwise INTs are shared.

It does help make sure that if you have 8 devices, each IRQ is used by
only two devices, so the interrupt handler doesn't have too many devices
to check when an interrupt occours.

--
Len Sorensen

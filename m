Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbXBRUm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbXBRUm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 15:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbXBRUm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 15:42:29 -0500
Received: from khc.piap.pl ([195.187.100.11]:37746 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbXBRUm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 15:42:29 -0500
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl>
	<20070218155445.GV7584@csclub.uwaterloo.ca>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 18 Feb 2007 21:42:26 +0100
In-Reply-To: <20070218155445.GV7584@csclub.uwaterloo.ca> (Lennart Sorensen's message of "Sun, 18 Feb 2007 10:54:45 -0500")
Message-ID: <m3ejon8afh.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:

> My understanding (which is better of verified against the specs) is:
>
> PCI interrupts (PCI INTA to INTD) are rotated for every slot by one. So
> slot 0, 4, 8, etc see INTA->realINTA, INTB->realINTB. INTC->realINTC,
> INTD->realINTD
> slot 1, 5, 9, etc see INTA->realINTB, INTB->realINTC. INTC->realINTD,
> INTD->realINTA
> slot 2, 6, 10, etc see INTA->realINTC, INTB->realINTD. INTC->realINTA,
> INTD->realINTB
> slot 3, 7, 11, etc see INTA->realINTD, INTB->realINTA. INTC->realINTB,
> INTD->realINTC

This is common and suggested practice but the PCI specs don't require
it. There is no rule - you can, for example, have all INT lines
connected to a single CPU IRQ input.

> On a PC, the BIOS is supposed to assign interrupts to devices based on
> those rules, since that is how the hardware must be done according to
> the PCI specifications.  On other platforms the firmware may or may not
> handle it.

Anyway, something has to know how the IRQs are routed. BIOS, other
firmware, Linux.

> So as long as the riser board is wired according to the PCI bridge
> rules,

Actually it has to be wired consistently with the BIOS (which is
probably consistent with chipset manufacturer's instructions).

> Of course if the
> riser card is NOT a proper pci bridge, but rather some weird device,
> well then it probably isn't even PCI complient and who knows how it
> shold be handled.

Usually they are just bus splitters, they route IRQs and IDSELs
(and maybe JTAG) as required by the BIOS, all others pins are
connected 1:1.

I.e., they are completely transparent, generally comply to PCI specs
and are dedicated to a specific motherboard(s).

> Interrupts for PCI are assigned based on the 4 shared interrupts line on
> PCI, not really per device.  A PCI device may use up to 4 interrupts if
> it wants to, and is supposed to always use interrupt A (as seen from
> it's slot) as the first interrupt.

Actually I think (would have to check the specs for sure) every
subdevice (function) may use just one interrupt line.

This rotating INTx scheme is common because it's cheap. There are
systems which support more than 4 shared INTs per bus, for example
you can have different sets of 4 INTx lines for every PCI slot, even
if all slots are on the same PCI bus.

> The rotating assignment of the 4
> interrupts to the slots are supposed to help balance the distribution of
> the interrupts between devices in the system, so that although they are
> shared interrupts, as few devices as possible get assigned to each
> interrupt.

Correct. This scheme assumes at most 4 single-function devices
on the bus, otherwise INTs are shared.
-- 
Krzysztof Halasa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751346AbXBRPyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbXBRPyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 10:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbXBRPyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 10:54:47 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:58533 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbXBRPyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 10:54:46 -0500
Date: Sun, 18 Feb 2007 10:54:45 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
Message-ID: <20070218155445.GV7584@csclub.uwaterloo.ca>
References: <45D85DA1.7090502@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D85DA1.7090502@xs4all.nl>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 03:07:29PM +0100, Udo van den Heuvel wrote:
> Is there some howto information available about using PCI riser cards
> (with multiple PCI slots) under Linux?
> Several incarnations exist of PCI riser cards with two PCI slots where
> the Device Number of one slot can be changed.
> How, based on what information, does Linux assign an IRQ to each card,
> plugged into the riser?
> How can one tweak/influence the irq routing?
> How can I make a dual riser card work so that both cards have a working
> interrupt?
> Or if stuff should work all by itself, what could be wrong?

The PCI specifications cover how pci to pci bridges should work.

My understanding (which is better of verified against the specs) is:

PCI interrupts (PCI INTA to INTD) are rotated for every slot by one. So
slot 0, 4, 8, etc see INTA->realINTA, INTB->realINTB. INTC->realINTC,
INTD->realINTD
slot 1, 5, 9, etc see INTA->realINTB, INTB->realINTC. INTC->realINTD,
INTD->realINTA
slot 2, 6, 10, etc see INTA->realINTC, INTB->realINTD. INTC->realINTA,
INTD->realINTB
slot 3, 7, 11, etc see INTA->realINTD, INTB->realINTA. INTC->realINTB,
INTD->realINTC

The same rules apply behind a PCI bridge, so whatever INTA is on the
slot with the pci bridge chip, should make to INTA on slots 0, 4, 8, etc
behind the bridge, while INTB is seen as INTA on slots 1, 5, 9, etc.

On a PC, the BIOS is supposed to assign interrupts to devices based on
those rules, since that is how the hardware must be done according to
the PCI specifications.  On other platforms the firmware may or may not
handle it.  On ARM for example, the kernel takes care of assigning this
(or it least it should).  I have seen pci interrupt swizzle routines in
the kernel code for an arm system which went through, looking for
devices, and assigning IRQs based on their slot number, and when it
found a bridge it would do a mapping past the bridge and continue
assigning interrupts to devices behind the bridge.

So as long as the riser board is wired according to the PCI bridge
rules, then interrupts assignment should simply work.  Of course if the
riser card is NOT a proper pci bridge, but rather some weird device,
well then it probably isn't even PCI complient and who knows how it
shold be handled.

Interrupts for PCI are assigned based on the 4 shared interrupts line on
PCI, not really per device.  A PCI device may use up to 4 interrupts if
it wants to, and is supposed to always use interrupt A (as seen from
it's slot) as the first interrupt.  The rotating assignment of the 4
interrupts to the slots are supposed to help balance the distribution of
the interrupts between devices in the system, so that although they are
shared interrupts, as few devices as possible get assigned to each
interrupt.  On some systems some of the 4 PCI interrupts may in fact get
mapped to the same interrupts if not enough are available (for example a
system I work with only has two PCI interrupts available, so PCI INTA
and C are the same interrupt line, and INTB and D are the same, but the
system is still wired as if there were 4 interrupts, and the BIOS
assigns the interrupts properly based on that, but using IRQ 11 for A
and C and IRQ 10 for B and D.)

--
Len Sorensen

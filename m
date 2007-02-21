Return-Path: <linux-kernel-owner+w=401wt.eu-S1423215AbXBUWk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423215AbXBUWk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423216AbXBUWk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:40:29 -0500
Received: from csclub1.cs.uwaterloo.ca ([129.97.7.226]:47642 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1423215AbXBUWk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:40:28 -0500
Date: Wed, 21 Feb 2007 17:40:27 -0500
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>
Subject: Re: PCI riser cards and PCI irq routing, etc
Message-ID: <20070221224027.GK22464@csclub.uwaterloo.ca>
References: <45D85DA1.7090502@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain> <45DA7643.4020305@xs4all.nl> <200702201456.30794.s0348365@sms.ed.ac.uk> <45DB174F.30708@xs4all.nl> <45DC0FCC.7010705@xs4all.nl> <m3wt2bem13.fsf@maximus.localdomain> <45DC5E67.8060101@xs4all.nl> <20070221151202.GE22464@csclub.uwaterloo.ca> <m3hctfqjna.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3hctfqjna.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 10:35:05PM +0100, Krzysztof Halasa wrote:
> Do you mean both slots on the riser card? No, they have to be rotated.
> 
> Given the table from the manual:
> 
> > The IRQ (interrupt request line) are hardware lines over which devices
> > can send interrupt signals to the microprocessor. The ??PCI & LAN?? IRQ
> > pins are typically connected to the PCI bus INT A# ~ INT D# pins as follows:
> > 		Order 1		Order 2 	Order 3 	Order 4
> > PCI Slot 1	INT B# 		INT C# 		INT D# 		INT A#
> > IEEE1394 	INT B#
> 
> (I assume Order 1 is device's INT A and so on)
> the chipset-centric view is:

Well someone said the VIA uses INTA for the DN19 on their riser card,
although is that INTA from the CPUs point of view or INTA from the slot
the riser card is plugged into?  There was also mention of a BIOS update
needed on some boards to even support the riser card at all.  Maybe that
applies.

> Device#	IDSEL	INT (first)
> 0x08    A19	n/a
> 0x09	A20	n/a
> 0x0A	A21	INT D (and A, B, C)
> 0x0B	A22	n/a
> 0x0C	A23	n/a
> 0x0D	A24	IEEE1394 chip (INT B (single function), unused C, D, A)
> 0x0E	A25	n/a
> 0x0F	A26	n/a
> 0x10	A27	USB (INT A, B, C, D - 3 UHCI and 1 OHCI = 4 functions)
> 0x11	A28	VT823x (11.5 uses INT C so it means INT B, C, D, A)
> 0x12	A29	onboard Ethernet (INT A, unused B, C, D)
> 0x13	A30	INT A (and B, C, D of course)
> 0x14	A31	INT B (the MB PCI slot is wired this way, and C, D, A of
>                     course as there are 4 usable interrupt lines here)
> 
> The on-board VGA is INT A (shares with Ethernet, and it's device #0
> behind a bridge so it has to use INT A).

Which bridge?  Interrupts on the mainboard can do anything they want
(and do).

> Device 0x14 (the original PCI slot) ABCD = chipset DABC (as above)
> (equal to BCDA = chipset ABCD).
> This is a "backward" rotation because the "new" device number is 1 less
> than the original one (0x13 vs. 0x14), and the riser card probably uses
> "normal" rotation as it assumes the device numer increases.
> Device 0x13 is the additional slot on the riser card, 0x14 is the
> "original" slot on the riser card (uses 1:1 INT mapping and IDSEL
> from the motherboard slot).
> 
> Device 0x0A would need a double rotation, ABCD => CDAB (not sure
> if it could work but there was a photo with 3-card riser somewhere
> and it seems it's the only possibility, short of PCI-PCI bridge).

This would be true, if the bios assigned interrupts to devices that way
all the time, but this is bus 0 and there are no rules.  After all if
slot 0, 4, 8, 12, 16, and 20 all used INTA->INTA then that would make
sense, but slot 20 (0x14) is using INTB->INTA so that isn't the case.
And why would slot 18 (0x12) and slot 19 (0x13) both use INTA?  If the
bios doesn't expect a device in slot 19 then it won't assing an irq
correctly, and it will only be correct if the bios knows how it was
wired.

> The BIOS just doesn't give an IRQ to other devices (that's what
> "n/a" above means).
> 
> This is for EPIA-M but since they all can use the same riser card...

Are there any bios options for enabling support for slot 19 devices on
riser cards?

--
Len Sorensen

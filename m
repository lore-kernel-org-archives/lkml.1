Return-Path: <linux-kernel-owner+w=401wt.eu-S1422846AbXBVBQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422846AbXBVBQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932974AbXBVBQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:16:38 -0500
Received: from khc.piap.pl ([195.187.100.11]:55007 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932955AbXBVBQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:16:37 -0500
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain>
	<45DA7643.4020305@xs4all.nl>
	<200702201456.30794.s0348365@sms.ed.ac.uk> <45DB174F.30708@xs4all.nl>
	<45DC0FCC.7010705@xs4all.nl> <m3wt2bem13.fsf@maximus.localdomain>
	<45DC5E67.8060101@xs4all.nl>
	<20070221151202.GE22464@csclub.uwaterloo.ca>
	<m3hctfqjna.fsf@maximus.localdomain>
	<20070221224027.GK22464@csclub.uwaterloo.ca>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 22 Feb 2007 02:16:34 +0100
In-Reply-To: <20070221224027.GK22464@csclub.uwaterloo.ca> (Lennart Sorensen's message of "Wed, 21 Feb 2007 17:40:27 -0500")
Message-ID: <m3fy8zrnyl.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:

> Well someone said the VIA uses INTA for the DN19 on their riser card,
> although is that INTA from the CPUs point of view or INTA from the slot
> the riser card is plugged into?

CPU/chipset it seems.

>> Device#	IDSEL	INT (first)
>> 0x08    A19	n/a
>> 0x09	A20	n/a
>> 0x0A	A21	INT D (and A, B, C)
>> 0x0B	A22	n/a
>> 0x0C	A23	n/a
>> 0x0D	A24	IEEE1394 chip (INT B (single function), unused C, D, A)
>> 0x0E	A25	n/a
>> 0x0F	A26	n/a
>> 0x10	A27	USB (INT A, B, C, D - 3 UHCI and 1 OHCI = 4 functions)
>> 0x11	A28	VT823x (11.5 uses INT C so it means INT B, C, D, A)
>> 0x12	A29	onboard Ethernet (INT A, unused B, C, D)
>> 0x13	A30	INT A (and B, C, D of course)
>> 0x14	A31	INT B (the MB PCI slot is wired this way, and C, D, A of
>>                     course as there are 4 usable interrupt lines here)
>> 
>> The on-board VGA is INT A (shares with Ethernet, and it's device #0
>> behind a bridge so it has to use INT A).
>
> Which bridge?  Interrupts on the mainboard can do anything they want
> (and do).

Anyway, this is consistent with their manual, and it really doesn't
matter (what matters is "what you have to do with INTx signals on
device 0x14 to connect them to device 0x13).

> This would be true, if the bios assigned interrupts to devices that way
> all the time, but this is bus 0 and there are no rules.

That's a function of the PCB, the BIOS can alter IRQx-INTx assignments
(and does it) but can't alter PCB traces, so the INTx-deviceX
assignments are constant.

> After all if
> slot 0, 4, 8, 12, 16, and 20 all used INTA->INTA then that would make
> sense, but slot 20 (0x14) is using INTB->INTA so that isn't the case.

As you wrote, no rules.

> And why would slot 18 (0x12) and slot 19 (0x13) both use INTA?

Who knows? They made it this way, we have to use what we got.

> If the
> bios doesn't expect a device in slot 19 then it won't assing an irq
> correctly, and it will only be correct if the bios knows how it was
> wired.

Sure, but the BIOS expects a device here and expects it to use said
INT A (as seen by the chipset).

Look, I just got that EPIA-M board, connected it to PSU, put a strip
of schotch tape over IDSEL connector (MB PCI slot), tried connecting
IDSEL going to the device to different PCI ADxx lines and noted what
the BIOS thought after RESET. The table just shows that :-)

I initially mapped the MB slot INTs with a 4-port Ethernet card
(with DEC 21152 bridge chip) and then tested device/INT mapping
with a small, simple 1-function card.

I haven't tested devices 1-7 (can test, 0 is used by the chipset),
and I haven't investigated IO-APIC connections, that's right. But
it's almost certain both slots on original VIA riser card share
that set of 4 INTs (rotated) so it doesn't matter.

> Are there any bios options for enabling support for slot 19 devices on
> riser cards?

No, if the BIOS shows the device and (any valid) IRQ number at
startup ("Show summary" = yes in BIOS setup) then the card is
detected and supported, even if the riser card isn't the correct one
(= the card wouldn't work but it shows up).
You just have to connect that card's INT A to whatever the BIOS
wants and expects. That's it.
-- 
Krzysztof Halasa

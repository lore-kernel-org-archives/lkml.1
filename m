Return-Path: <linux-kernel-owner+w=401wt.eu-S1751925AbXBRTjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbXBRTjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 14:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXBRTjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 14:39:05 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:45562 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbXBRTjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 14:39:04 -0500
Date: Sun, 18 Feb 2007 14:39:01 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
Message-ID: <20070218193901.GN7582@csclub.uwaterloo.ca>
References: <45D85DA1.7090502@xs4all.nl> <20070218155445.GV7584@csclub.uwaterloo.ca> <45D87BA2.9020001@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D87BA2.9020001@xs4all.nl>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 05:15:30PM +0100, Udo van den Heuvel wrote:
> FYI: My situation is a VIA Epia EN12000 with a TranquilPC dual PCI riser
> where only the Device Number can be changed.
> The kernel sees the two DVB cards in there as:
> 
> saa7146: register extension 'budget_av'.
> ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level, low) -> IRQ 16
> saa7146: found saa7146 @ mem f8c3e000 (revision 1, irq 16) (0x153b,0x1157).
> saa7146 (0): dma buffer size 192512
> DVB: registering new adapter (Terratec Cinergy 1200 DVB-T).
> adapter failed MAC signature check
> encoded MAC from EEPROM was
> ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
> KNC1-0: MAC addr = 00:0a:ac:01:d6:87
> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> budget-av: ci interface initialised.
> ACPI: PCI Interrupt 0000:00:14.0[A] -> GSI 17 (level, low) -> IRQ 20
> saa7146: found saa7146 @ mem f8cb2000 (revision 1, irq 20) (0x153b,0x1155).
> saa7146 (1): dma buffer size 192512
> DVB: registering new adapter (TerraTec Cinergy 1200 DVB-S).
> adapter failed MAC signature check
> encoded MAC from EEPROM was
> ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> KNC1-1: MAC addr = 00:0a:ac:12:93:8d
> DVB: registering frontend 1 (ST STV0299 DVB-S)...
> budget-av: ci interface initialised.

Well it says they are slot 13 and 14.  What other pci devices are
present in the system and what irq's are they using?  Now it appears you
have acpi, and probably an apic on that board, which would explain
having IRQs higher than the 15 a plain old PC had.

> So IRQ 16 and 20. But when using the stock 2.6.20 kernel there is no
> communication with the DVB-T card (the frontend), so there is no
> /dev/dvb/* entry. This points to an IRQ problem.

Any documentation on that riser card?

I guess it is possible the card does something weird and the IRQs for
both cards have to actually be the same.  If that is the case you could
make the kernel change the IRQ assigned to the second card before
loading the driver.  Or you could do it from the boot loader or
something (The system I work with has a stupid bios that doesn't have a
clue about bridges, so we added IRQ fixup code to grub to deal with all
PCI bridges before booting the system).

> How can I find out the actual IRQ that the card is using?
> If it is different from what Linux thinks: how do I tell Linux?

Linux doesn't think anything.  It goes by the IRQ assigned to the
device, which is in one of the PCI registers on each device.  You can
change those registers though, and then it should use the new value
(although you may have to change it from the kernel before it enumerates
the pci devices).

> > On a PC, the BIOS is supposed to assign interrupts to devices based on
> > those rules, since that is how the hardware must be done according to
> > the PCI specifications.  
> 
> I set the BIOS for 'PnP OS installed'. Should I change that?

I would NEVER do that.  That actually disables the BIOS from doing
configuration of most hardware since it really means "Microsoft wants to
do configuration themselves and asked us to put in a setting to make the
bios only configure drive controllers and sound cards".  I know some
people have worked towards making linux a "PnP OS" by microsoft
standards, but whether it is entirely there or not by now I am not sure.
Fortunately most motherboards I have ever bought come preset at 'pnp os
installed' off, which is how I like it.  I have had a number of
problems on systems with that setting on, which went away when the
setting was set back to off.

It might actually work better if you change that, although it may also
just make no difference.

--
Len Sorensen

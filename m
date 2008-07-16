Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbYGPT7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbYGPT7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 15:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYGPT6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 15:58:55 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34470 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYGPT6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 15:58:54 -0400
Date: Wed, 16 Jul 2008 13:58:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Vrabel <david.vrabel@csr.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PCI: MSI interrupts masked using prohibited method
Message-ID: <20080716195853.GL25255@parisc-linux.org>
References: <4860D09D.4060801@csr.com> <4864DA54.6000205@csr.com> <200806271007.26248.jbarnes@virtuousgeek.org> <200807161243.03360.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807161243.03360.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 12:43:03PM -0700, Jesse Barnes wrote:
> On Friday, June 27, 2008 10:07 am Jesse Barnes wrote:
> > On Friday, June 27, 2008 5:17 am David Vrabel wrote:
> > > Jesse Barnes wrote:
> > > > On Tuesday, June 24, 2008 3:46 am David Vrabel wrote:
> > > >> PCI MSI interrupts are masked and unmasked using a method (by writing
> > > >> the MSI Enable capability bit) that is prohibited by the PCI
> > > >> specification.
> > > >
> > > > Yeah, it's probably quite a bit slower too (I assume you're talking
> > > > about io_apic_64's msi_mask_irq).  Seems like masking this at the
> > > > ioapic level would make more sense anyway...
> > > >
> > > >> This behaviour can cause missed interrupts with some devices if the
> > > >> interrupt is asserted by the hardware while MSI is disabled.
> > > >>
> > > >> I believe the interrupt should be masked/unmasked on the interrupt
> > > >> controller (the APIC on x86, for example).   I'm going to test this
> > > >> now and see if it works.
> > >
> > > After further research it seems that MSI interrupts aren't routed via
> > > the IO-APIC, so this cannot be done.
> > >
> > > I think the only solution is to not perform any sort of masking and rely
> > > on the device driver being able to handle this.
> >
> > On x86, they're targetted at the LAPIC block (see section 8 of the IA SDM);
> > maybe we could modify the message address or data such that it won't
> > generate an interrupt instead?  I think this latest approach is correct in
> > the sense that both the system and drivers have to take care that
> >   1) we don't miss interrupts, and
> >   2) we don't generate spurious unhandled interrupts (as might happen if we
> > disable MSI and the device generates a legacy IRQ on a different vector).
> >
> > But it looks like the real problem is in the system interrupt code that
> > handles MSIs.  We should only be disabling MSIs using the capability bit at
> > device enable or disable time, not during the normal course of interrupt
> > handling, since if we do we may miss device interrupts or have them routed
> > to the wrong (legacy) vector.
> >
> > Cc'ing Ingo & Thomas since they know the core interrupt code pretty well.
> 
> Ingo or Matthew, any ideas about this?  The fundamental issue is that if we go 
> poke at a device's MSI cap bits during interrupt handling, the device may 
> start using regular IRQs instead, potentially on a different vector.  It 
> would be good if we could come up with a better way of masking MSIs during 
> handling...

OK, I didn't see the initial report, but I've looked at the PCI MSI
masking a little bit due to the multiple MSI work.

The first thing is that some MSI implementations permit masking on the
PCI device.  That's handled through the

                if (entry->msi_attrib.maskbit) {

part of msi_set_mask_bits() in drivers/pci/msi.c.

David's clearly talking about devices which don't support mask bits.
For these devices, we call
                        msi_set_enable(entry->dev, !flag);

which turns off the PCI_MSI_FLAGS_ENABLE bit.  I'm not sure I see the
bit in the PCI spec that says devices are then allowed to ignore the
Interrupt Disable bit in the device control register, but I concede such
devices may be out there.

We have some infrastructure for resending IRQs, so we could soft-mask an
MSI and resend it when the irq is unmasked, if it has triggered.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

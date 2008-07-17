Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYGQPj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYGQPj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbYGQPjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:39:20 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39641 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbYGQPjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:39:19 -0400
Date: Thu, 17 Jul 2008 09:39:17 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PCI: MSI interrupts masked using prohibited method
Message-ID: <20080717153917.GR25255@parisc-linux.org>
References: <4860D09D.4060801@csr.com> <4864DA54.6000205@csr.com> <200806271007.26248.jbarnes@virtuousgeek.org> <200807161243.03360.jbarnes@virtuousgeek.org> <20080716195853.GL25255@parisc-linux.org> <487F45C0.2080201@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487F45C0.2080201@csr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 02:14:40PM +0100, David Vrabel wrote:
> Matthew Wilcox wrote:
> > David's clearly talking about devices which don't support mask bits.
> > For these devices, we call
> >                         msi_set_enable(entry->dev, !flag);
> > 
> > which turns off the PCI_MSI_FLAGS_ENABLE bit.  I'm not sure I see the
> > bit in the PCI spec that says devices are then allowed to ignore the
> > Interrupt Disable bit in the device control register, but I concede such
> > devices may be out there.
> 
> From the PCI spec:
> 
> "This bit disables the device/function from asserting INTx#. A value of
> 0 enables the assertion of its INTx# signal. A value of 1 disables the
> assertion of its INTx# signal. This bit?s state after RST# is 0. Refer
> to Section 6.8.1.3 for control of MSI."
> 
> So the interrupt disable bit is only for the line interrupts, and not MSI.

Yes it is, but we don't touch that bit at this time.

When we enable MSIs, we set the INTx disable bit (or at least do a write
to it ... as Krzysztof Halasa pointed out, not all devices implement
this bit).  When we mask MSIs, we clear the MSI enable bit.  So a device
conforming to PCI 2.3 has both INTx and MSI disabled.  Unfortunately, a
device conforming to PCI 2.2 has MSI disabled and INTx implicitly
re-enabled.  Oops.

> > We have some infrastructure for resending IRQs, so we could soft-mask an
> > MSI and resend it when the irq is unmasked, if it has triggered.
> 
> Is this really necessary?  Any PCI device with MSI that doesn't have the
> hardware MSI mask bits must have some sort of device specific
> handshaking for managing when MSIs can be generated.

Maybe so, but we don't control that.  Here's the flow that leads to
the problem you've observed (note: only x86-64 analysed here, other
architectures may vary):

The mask_msi_irq() function is the heart of what's going on.  This is
set to be the ->mask() function pointer in the MSI irq_chip struct.

The device generates an MSI interrupt.
Some magic happens in assembly, and the processor ends up in do_IRQ()
which calls generic_handle_irq().  Because it's an MSI IRQ,
handle_edge_irq() is called instead of __do_IRQ().

There are two opportunities for calling the ->mask() here, one is:

        if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
                    !desc->action)) {
                desc->status |= (IRQ_PENDING | IRQ_MASKED);
                mask_ack_irq(desc, irq);

The other is:

                if (unlikely(!action)) {
                        desc->chip->mask(irq);

This is all in generic code which knows nothing about any device-specific
method of masking interrupts from the chip.

> Regardless, doesn't __do_IRQ() handle this already anyway?

This is a good thought, let's follow it through.  What if we simply make
->mask a no-op for devices which don't support mask bits?

MSIs are 'edge triggered' interrupts.  They're sent once and then
forgotten by the hardware (as opposed to level triggered which will
continue to be triggered until deasserted).

The first time through (assuming ->action is non-NULL ...), we won't
try to mask the irq.  The second time through, IRQ_INPROGRESS will be set,
so we try to mask_ack_irq().

How about we simply don't ack the irq at this point?  That should prevent
it being triggered again, right?

Working on a patch to do this now ...

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

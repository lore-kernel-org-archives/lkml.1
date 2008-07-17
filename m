Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbYGQP6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbYGQP6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbYGQP6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:58:44 -0400
Received: from www.tglx.de ([62.245.132.106]:51377 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145AbYGQP6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:58:43 -0400
Date: Thu, 17 Jul 2008 17:58:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Wilcox <matthew@wil.cx>
cc: David Vrabel <david.vrabel@csr.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI: MSI interrupts masked using prohibited method
In-Reply-To: <20080717153917.GR25255@parisc-linux.org>
Message-ID: <alpine.LFD.1.10.0807171745270.4316@apollo.tec.linutronix.de>
References: <4860D09D.4060801@csr.com> <4864DA54.6000205@csr.com> <200806271007.26248.jbarnes@virtuousgeek.org> <200807161243.03360.jbarnes@virtuousgeek.org> <20080716195853.GL25255@parisc-linux.org> <487F45C0.2080201@csr.com>
 <20080717153917.GR25255@parisc-linux.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Matthew Wilcox wrote:
> 
> The device generates an MSI interrupt.
> Some magic happens in assembly, and the processor ends up in do_IRQ()
> which calls generic_handle_irq().  Because it's an MSI IRQ,
> handle_edge_irq() is called instead of __do_IRQ().

__do_IRQ() is the old all-in-one handler which is not called on
platforms which have GENERIC_HARDIRQS set. You can safely ignore what
__do_IRQ() does.
 
> There are two opportunities for calling the ->mask() here, one is:
> 
>         if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
>                     !desc->action)) {
>                 desc->status |= (IRQ_PENDING | IRQ_MASKED);
>                 mask_ack_irq(desc, irq);
> 
> The other is:
> 
>                 if (unlikely(!action)) {
>                         desc->chip->mask(irq);
> 
> This is all in generic code which knows nothing about any device-specific
> method of masking interrupts from the chip.

Right and it is not supposed to know anything about the hardware
details at all. The per irq setting can provide NOOP functions for all
the mask/mask_ack/unmask things when thats the right way for the
particular irq line.
 
> > Regardless, doesn't __do_IRQ() handle this already anyway?

That's irrelevant. All the interrupts are handled via
irq_desc[irq].handle_irq() when GENERIC_HARDIRQS is set.
 
> This is a good thought, let's follow it through.  What if we simply make
> ->mask a no-op for devices which don't support mask bits?

Yep. You can also use fasteoi_handler, which just calls ->eoi() after
the handler.
 
> MSIs are 'edge triggered' interrupts.  They're sent once and then
> forgotten by the hardware (as opposed to level triggered which will
> continue to be triggered until deasserted).
> 
> The first time through (assuming ->action is non-NULL ...), we won't
> try to mask the irq.  The second time through, IRQ_INPROGRESS will be set,
> so we try to mask_ack_irq().
> 
> How about we simply don't ack the irq at this point?  That should prevent
> it being triggered again, right?
> 
> Working on a patch to do this now ...

You want to use the fasteoi_handler.

Thanks,
	tglx

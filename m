Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZBCTxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZBCTxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZBCTxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:53:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57954 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZBCTxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:53:33 -0500
Date: Tue, 3 Feb 2009 20:53:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Jesse Barnes <jesse.barnes@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
	standard config registers of all devices early)
Message-ID: <20090203195304.GA31049@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain> <200902031032.26771.jesse.barnes@intel.com> <alpine.LFD.2.00.0902031033310.3247@localhost.localdomain> <alpine.LFD.2.00.0902031047320.3247@localhost.localdomain> <20090203191334.GA2797@elte.hu> <alpine.LFD.2.00.0902031120080.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902031120080.3247@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 3 Feb 2009, Ingo Molnar wrote:
> > > 
> > > I'm really not sure why that handle_edge_irq thing uses "ack_and_mask()" 
> > > instead of just "desc->chip->ack()"? I'm also totally flummoxed as to why 
> > > it feels it needs to go all the way out to the device to mask things, 
> > > instead of just masking at an apic level, which is much simpler and faster 
> > > (especially since masking should never happen in practice anyway).
> > 
> > Hm, do you mean mask_ack_irq()?
> 
> Yes.
> 
> >		 The ->mask_ack() irqchip method is just a 
> > small tweak normally: if we get an irq while the irq was disabled, we can 
> > mark it pending and masks it for real.
> 
> No, I know why mask_ack_irq() does what it does and I agree with it. What 
> I was really reacting to was that handle_edge_irq() calls it at _all_. 
> IOW, I'm talking about this code:
> 
> 	handle_edge_irq(unsigned int irq, struct irq_desc *desc)
> 	...
> 	        if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
> 	                    !desc->action)) {
> 	                desc->status |= (IRQ_PENDING | IRQ_MASKED);
> 	                mask_ack_irq(desc, irq);
> 	..
> 
> where the masking part seems a bit pointless. And in the case of MSI, it 
> causes us to go all the way out to the device, which sounds pretty 
> expensive too.

hm, i agree that your patched version looks much simpler.

There's two reasons we have this variant:

 - huge bikeshed painting thread in the early days of the genirq patchset, 
   with folks expressing concern about our original plans to keep 
   edge-triggered unmasked _always_. (which your patch does too)
   So we just went with the path of least resistence and used this hybride.

 - the screaming-irq observation i had - do you consider that valid?:

   >> [ In theory this also solves screaming level-triggered irqs that 
   >>   advertise themselves as edge-triggered [due to firmware/BIOS bug - 
   >>   these do happen] and then keep spamming the system. ]

   I wanted to have a pretty much interchangeable flow method between edge 
   and level triggered - so that the BIOS cannot screw us by enumerating an 
   irq as edge-triggered while it's level-triggered.

   Especially for legacy x86 irqs in the low <16 range the trigger mode can 
   be influenced by chipset settings and might not always be what we think 
   it is.

That's my rough recollection - Thomas, is that correct and do you have 
anything to add here?

	Ingo

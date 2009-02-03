Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZBCTOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZBCTOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:14:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZBCTNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:13:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37602 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbZBCTNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:13:52 -0500
Date: Tue, 3 Feb 2009 20:13:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jesse.barnes@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
	standard config registers of all devices early)
Message-ID: <20090203191334.GA2797@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain> <200902031032.26771.jesse.barnes@intel.com> <alpine.LFD.2.00.0902031033310.3247@localhost.localdomain> <alpine.LFD.2.00.0902031047320.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902031047320.3247@localhost.localdomain>
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

> On Tue, 3 Feb 2009, Linus Torvalds wrote:
> >
> > That said, we've also never had much reason to _care_ deeply, so it's also 
> > possible that we do mask things over some path. I didn't actually walk 
> > _all_ the paths, and the logic for irq handling has changed enough over 
> > the years that I don't know all the paths any more. Maybe we do that 
> > explicit mask in some path I missed. We _shouldn't_, but who knows..
> 
> Ok, so I decided to actually try to walk it all. Better look at the actual 
> code.
> 
> Hmm. The _normal_ simple irq handler does this the way I described, but 
> for some reason the "handle_edge_irq()" does not. And the reason is 
> actually a buglet: it needs to mask things for the "recursive interrupt" 
> case.
> 
> But that literally just looks like a small implementation detail (the code 
> decided to share the code for IRQ_INPROGRESS and IRQ_DISABLED). We should 
> fix it, so that you _can_ disable irqs and not have to worry about this 
> all.
> 
> I'm really not sure why that handle_edge_irq thing uses "ack_and_mask()" 
> instead of just "desc->chip->ack()"? I'm also totally flummoxed as to why 
> it feels it needs to go all the way out to the device to mask things, 
> instead of just masking at an apic level, which is much simpler and faster 
> (especially since masking should never happen in practice anyway).

Hm, do you mean mask_ack_irq()? The ->mask_ack() irqchip method is just a 
small tweak normally: if we get an irq while the irq was disabled, we can 
mark it pending and masks it for real.

It's optional for a PIC implementation to provide it and the generic code 
does it via ->mask() + ->ack() if the PIC implementation keeps it NULL.

[ In theory this also solves screaming level-triggered irqs that advertise 
  themselves as edge-triggered [due to firmware/BIOS bug - these do happen] 
  and then keep spamming the system. ]

I have not done a deep audit, normally (on x86 at least) ->mask_ack() should 
not touch any lowlevel device bits (only the interrupt controller bits). 
Have you found a case where it does?

That would be arguably broken i think - we should not touch lowlevel device 
bits from the current generation of PIC code really, there's just no point.

	Ingo

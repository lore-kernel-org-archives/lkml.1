Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbZBCTjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbZBCTjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZBCTjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:39:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949AbZBCTjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:39:09 -0500
Date: Tue, 3 Feb 2009 11:38:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Jesse Barnes <jesse.barnes@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
In-Reply-To: <20090203191334.GA2797@elte.hu>
Message-ID: <alpine.LFD.2.00.0902031120080.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain> <200902031032.26771.jesse.barnes@intel.com> <alpine.LFD.2.00.0902031033310.3247@localhost.localdomain>
 <alpine.LFD.2.00.0902031047320.3247@localhost.localdomain> <20090203191334.GA2797@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Ingo Molnar wrote:
> > 
> > I'm really not sure why that handle_edge_irq thing uses "ack_and_mask()" 
> > instead of just "desc->chip->ack()"? I'm also totally flummoxed as to why 
> > it feels it needs to go all the way out to the device to mask things, 
> > instead of just masking at an apic level, which is much simpler and faster 
> > (especially since masking should never happen in practice anyway).
> 
> Hm, do you mean mask_ack_irq()?

Yes.

>		 The ->mask_ack() irqchip method is just a 
> small tweak normally: if we get an irq while the irq was disabled, we can 
> mark it pending and masks it for real.

No, I know why mask_ack_irq() does what it does and I agree with it. What 
I was really reacting to was that handle_edge_irq() calls it at _all_. 
IOW, I'm talking about this code:

	handle_edge_irq(unsigned int irq, struct irq_desc *desc)
	...
	        if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
	                    !desc->action)) {
	                desc->status |= (IRQ_PENDING | IRQ_MASKED);
	                mask_ack_irq(desc, irq);
	..

where the masking part seems a bit pointless. And in the case of MSI, it 
causes us to go all the way out to the device, which sounds pretty 
expensive too.

So if you have high enough interrupt load that you get another interrupt 
on another CPU while handling one, I think the "mask_ack_irq()" likely 
makes things go slower. It also causes us to have that horrible:

                /*
                 * When another irq arrived while we were handling
                 * one, we could have masked the irq.
                 * Renable it, if it was not disabled in meantime.
                 */
                if (unlikely((desc->status &
                               (IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
                              (IRQ_PENDING | IRQ_MASKED))) {
                        desc->chip->unmask(irq);
                        desc->status &= ~IRQ_MASKED;
                }

code there in the middle of the loop to handle the interrupt.

That function has another oddity too: it does

                if (unlikely(!action)) {
			desc->chip->mask(irq);
                        goto out_unlock;
		}

but the thing is, if somebody unregistered the interrupt, then it should 
have been masked to begin with. Why would be need to mask it in the 
interrupt handler?

Maybe I'm missing something really subtle, but my reaction would be that 
the function _should_ look just something like the appended.

But no, I'm really not going to commit this. Consider this patch to be a 
question ("why does it do that?") rather than a suggestion ("we should do 
this").

		Linus

---
 kernel/irq/chip.c |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 7de11bd..ad852ce 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -468,8 +468,8 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	 */
 	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
 		    !desc->action)) {
-		desc->status |= (IRQ_PENDING | IRQ_MASKED);
-		mask_ack_irq(desc, irq);
+		desc->status |= IRQ_PENDING;
+		desc->chip->ack(irq);
 		desc = irq_remap_to_desc(irq, desc);
 		goto out_unlock;
 	}
@@ -486,22 +486,8 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		struct irqaction *action = desc->action;
 		irqreturn_t action_ret;
 
-		if (unlikely(!action)) {
-			desc->chip->mask(irq);
+		if (unlikely(!action))
 			goto out_unlock;
-		}
-
-		/*
-		 * When another irq arrived while we were handling
-		 * one, we could have masked the irq.
-		 * Renable it, if it was not disabled in meantime.
-		 */
-		if (unlikely((desc->status &
-			       (IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
-			      (IRQ_PENDING | IRQ_MASKED))) {
-			desc->chip->unmask(irq);
-			desc->status &= ~IRQ_MASKED;
-		}
 
 		desc->status &= ~IRQ_PENDING;
 		spin_unlock(&desc->lock);

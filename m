Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZBCSrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZBCSrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZBCSrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:47:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbZBCSrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:47:13 -0500
Date: Tue, 3 Feb 2009 10:46:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jesse.barnes@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
In-Reply-To: <200902031032.26771.jesse.barnes@intel.com>
Message-ID: <alpine.LFD.2.00.0902031033310.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain> <200902031032.26771.jesse.barnes@intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Jesse Barnes wrote:
> 
> But won't ->disable point at ->mask in the MSI case (msi_chip doesn't have 
> a ->disable, so the IRQ core will make ->disable point at ->mask)?

No. I clarified this in the next message, but basically it boils down to a 
simple case: "for edge-triggered interrupts, it's actually stupid to mask 
things, because it's both simpler and _cheaper_ to just take change that 
the interrupt might happen once" (especially since it almost never 
happens).

In fact, for an edge-triggered interrupt it is often a _bug_ to mask the 
interrupt source, because you often lose the interrupt. So masking is not 
only complex and expensive, it's also often _wrong_. Instead, what 
disable_irq() does is to take the interrupt, but instead of calling the 
interrupt handlers (it's disabled!) it just sets a flag.

And that is a big _correctness_ issue, because the setting of the flag is 
how we know to resend the interrupt when we enable things again - even 
though the hardware itself actually lost the edge.

[ Of course, you can hope that the PCI device itself doesn't lose it, and 
  sees the edge again when unmasking, but the fact that many interrupt 
  controllers get this fundamental masking issue wrong means that I'd 
  almost bet that lots of PCI devices get it wrong too! ]

> And in mask we do go poke at PCI regs (msi_set_mask_bits) to mask interrupts 
> if possible (though if there's no mask bit in the legacy MSI case we don't do 
> anything).

I actually think that's a bug. I think it's just horribly stupid for to 
->mask to go down to the device layer (for all the same reasons that we 
don't do it for disable), but it doesn't much matter. We only use it for 
"shutdown" of the irq controller - we should do the same thing we do for 
irq_disable and just set a flag.

The only reason to actually _mask_ an interrupt is if it is 
level-triggered and can cause screaming. But even then it's often better 
to just wait for the interrupt to happen (and mask it then), because 99% 
of the time the interrupt obviously never happens.

But we've never had reason to optimize ->mask/->unmask.

That said, we've also never had much reason to _care_ deeply, so it's also 
possible that we do mask things over some path. I didn't actually walk 
_all_ the paths, and the logic for irq handling has changed enough over 
the years that I don't know all the paths any more. Maybe we do that 
explicit mask in some path I missed. We _shouldn't_, but who knows..

		Linus

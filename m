Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbZBCScm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbZBCScm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZBCSce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:32:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:10992 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbZBCScd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:32:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,373,1231142400"; 
   d="scan'208";a="486839906"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore standard config registers of all devices early)
Date: Tue, 3 Feb 2009 10:32:25 -0800
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031032.26771.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 3, 2009 9:59 am Linus Torvalds wrote:
> On Tue, 3 Feb 2009, Rafael J. Wysocki wrote:
> > Having reconsidered it, I think that the "loop of disable_irq()" may be
> > problematic due to MSI/MSI-X and devices that are put into D3 during the
> > "normal" suspend.  That is, we shouldn't try to mask MSI/MSI-X for
> > devices in D3
>
> Rafael, you seem to be confused about what "disable_irq()" does.
>
> It does not touch the driver hardware AT ALL. It literally just touches
> the interrupt controller, and even that only indirectly.
>
> What disable_irq() does it literally:
>
> 	void disable_irq_nosync(unsigned int irq)
> 	{
> 	        struct irq_desc *desc = irq_to_desc(irq);
> 	        unsigned long flags;
>
> 	        if (!desc)
> 	                return;
>
> 	        spin_lock_irqsave(&desc->lock, flags);
> 	        if (!desc->depth++) {
> 	                desc->status |= IRQ_DISABLED;
> 	                desc->chip->disable(irq);
> 	        }
> 	        spin_unlock_irqrestore(&desc->lock, flags);
> 	}
>
> and then it does a "synchronize_irq()" to wait to make sure that there are
> no pending ones.
>
> And in many cases, even the
>
> 	desc->chip->disable(irq);
>
> doesn't actually _do_ anything - we'll quite possibly continue to take the
> interrupt, and only when the interrupt happens will it see the "oh,
> IRQ_DISABLED is set" thing, and do something about it.

But won't ->disable point at ->mask in the MSI case (msi_chip doesn't have 
a ->disable, so the IRQ core will make ->disable point at ->mask)?

And in mask we do go poke at PCI regs (msi_set_mask_bits) to mask interrupts 
if possible (though if there's no mask bit in the legacy MSI case we don't do 
anything).

But again, these interrupts won't be shared, so maybe it doesn't matter, and 
maybe the IRQ_DISABLED flag will keep any drivers from seeing post suspend 
interrupts anyway...

-- 
Jesse Barnes, Intel Open Source Technology Center

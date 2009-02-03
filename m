Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbZBCSAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbZBCSAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZBCSAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:00:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbZBCSAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:00:33 -0500
Date: Tue, 3 Feb 2009 09:59:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
In-Reply-To: <200902031804.26752.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <1233633061.16867.41.camel@pasglop> <200902031026.34093.rjw@sisk.pl> <200902031804.26752.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Rafael J. Wysocki wrote:
>
> Having reconsidered it, I think that the "loop of disable_irq()" may be
> problematic due to MSI/MSI-X and devices that are put into D3 during the
> "normal" suspend.  That is, we shouldn't try to mask MSI/MSI-X for devices in
> D3

Rafael, you seem to be confused about what "disable_irq()" does.

It does not touch the driver hardware AT ALL. It literally just touches 
the interrupt controller, and even that only indirectly.

What disable_irq() does it literally:

	void disable_irq_nosync(unsigned int irq)
	{
	        struct irq_desc *desc = irq_to_desc(irq);
	        unsigned long flags;
  
	        if (!desc)
	                return;

	        spin_lock_irqsave(&desc->lock, flags);
	        if (!desc->depth++) {
	                desc->status |= IRQ_DISABLED;
	                desc->chip->disable(irq);
	        }
	        spin_unlock_irqrestore(&desc->lock, flags);
	}

and then it does a "synchronize_irq()" to wait to make sure that there are 
no pending ones.

And in many cases, even the

	desc->chip->disable(irq);

doesn't actually _do_ anything - we'll quite possibly continue to take the 
interrupt, and only when the interrupt happens will it see the "oh, 
IRQ_DISABLED is set" thing, and do something about it.

So don't worry about putting devices in D3 - disable_irq() will not care 
AT ALL whether the device is alive or not, and will never try to touch it 
anyway.

		Linus

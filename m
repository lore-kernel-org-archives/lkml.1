Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbZBCXOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbZBCXOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZBCXOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:14:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961AbZBCXOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:14:02 -0500
Date: Tue, 3 Feb 2009 15:13:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <200902032309.01983.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902031504420.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain> <20090202234923.GA7499@elte.hu> <200902032309.01983.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Rafael J. Wysocki wrote:
> > 
> >         struct irq_desc *desc;
> >         int irq;
> > 
> >         for_each_irq_desc(i, desc) {
> > 	...
> > 	}
> > 
> > should do the trick.
> 
> So, what do I do in the loop to disable irqs for all devices on the IOAPIC
> level.  Would disable_irq(irq) be sufficient?

Yes. It literally should be something as simple as

	void disable_device_irqs(void)
	{
		struct irq_desc *desc;
		int i;

		for_each_irq_desc(i, desc)
			disable_irq(i);
	}

	void enable_device_irqs(void)
	{
		struct irq_desc *desc;
		int i;

		for_each_irq_desc(i, desc)
			enable_irq(i);
	}

although we might do something smarter eventually (ie start adding tests 
for specific flags etc - at that point we'll also need to mark which 
interrupts we've disabled so that we get the disable/enable nesting 
right).

And it probably makes sense to do this inside kernel/irq/manage.c or 
similar, since any extensions are going to be very aware of irq internals. 
For example, the thing might well end up taking the desc->lock and peek 
inside the descriptor to see if it's really a "device" interrupt or a 
"system" interrupt etc.

		Linus

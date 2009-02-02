Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbZBCAA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbZBCAA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZBCAAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:00:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752584AbZBCAAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:00:10 -0500
Date: Mon, 2 Feb 2009 15:59:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <200902030045.19416.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902021551050.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902022331.49131.rjw@sisk.pl> <alpine.LFD.2.00.0902021508340.3247@localhost.localdomain> <200902030045.19416.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Rafael J. Wysocki wrote:
> 
> So, perhaps we can just loop over the interrupt links and disable them all
> at this point?

Well, we could, but I think it's actually inferior. Why? Because timer 
interrupts can come over those too.

So we're really better off just looping over our own software irq_desc 
arrays. That has the feature that 

 (a) we can easily mark the individual irqs if we want to - in ways that 
     we can never do if we end up looping over some hardware concept like 
     the IO-APIC inputs. 

     IOW, we can easily add a magic flag for registering a timer 
     interrupt (in fact, I guess we already have IRQF_TIMER), but we can 
     also expand on this in the future with other purely software 
     interrupt flags - ie a driver that knows it is irq-safe could just 
     tell us so, and we wouldn't need to disable that irq if there are 
     only irq-safe drivers registered on it.

 (b) it's portable, and handles re-sending the interrupts correctly 
     (unlike just turning the interrupts off), and doesn't have any issues 
     with worrying about polarity etc complicating issues.

     Looping over the irq links is really quite hard. Sure, we can do the 
     ACPI thing, but that's platform-specific, _and_ it's not actually 
     guaranteed to hit everything anyway (ie it likely only disables the 
     mapped ones, not necessarily at all directly connected ones - IDE 
     and USB tend to be direct irq's because they are often on the same 
     chip as the irq controller).

> > @@ -1419,7 +1419,7 @@ int pci_restore_standard_config(struct pci_dev *dev)
> > -	dev->current_state = PCI_D0;
> > +	pci_update_current_state(dev, PCI_D0);
> 
> Good idea anyway.

Yeah, it probably makes sense to do this regardless of any PPC issues. 
Exactly because we don't call the platform code.

> Or perhaps put
> 
> current_state = PCI_UNKNOWN;
> 
> under that 'if (machine_is(powermac))' ?

Yes. That would be ok, but in _theory_ ACPI could hit the same thing, and 
then the pci_restore_standard_config() really needs to do that anyway.

			Linus

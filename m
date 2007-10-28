Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbXJ1Uob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbXJ1Uob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 16:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbXJ1UoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 16:44:24 -0400
Received: from outbound.mse10.exchange.ms ([216.52.164.190]:15254 "EHLO
	outbound.mse10.exchange.ms" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbXJ1UoX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 16:44:23 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Align PCI memory regions to page size (4K) - Fix
Date: Sun, 28 Oct 2007 16:44:49 -0400
Message-ID: <9392A06CB0FDC847B3A530B3DC174E7B03C96F3B@mse10be1.mse10.exchange.ms>
In-reply-to: <20071028200336.GA14563@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Align PCI memory regions to page size (4K) - Fix
Thread-Index: AcgZnbULSJw2+FpSRESE9ocRbP8ibQABaJnw
References: <9392A06CB0FDC847B3A530B3DC174E7B03C96F1D@mse10be1.mse10.exchange.ms> <20071028193104.GA13956@suse.de> <9392A06CB0FDC847B3A530B3DC174E7B03C96F36@mse10be1.mse10.exchange.ms> <20071028200336.GA14563@suse.de>
From: "Barak Fargoun" <barak@neocleus.com>
To: "Greg KH" <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@atrey.karlin.mff.cuni.cz>,
       "Guy Zana" <guy@neocleus.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Sunday, October 28, 2007 10:04 PM
> To: Barak Fargoun
> Cc: linux-kernel@vger.kernel.org;
> linux-pci@atrey.karlin.mff.cuni.cz; Guy Zana
> Subject: Re: [PATCH] Align PCI memory regions to page size (4K) - Fix
> 
> On Sun, Oct 28, 2007 at 03:53:20PM -0400, Barak Fargoun wrote:
> > Hi!
> > 
> > Regarding all the technical stuff (documentation, coding
> style, etc.)
> > - I thought I did it correctly :( I will fix it ASAP, and send an 
> > update when I will finish it.
> > 
> > About your question: today, some of the hypervisors are using linux 
> > kernel as their domain-0 (e.g. Xen). In order to implement direct 
> > hardware access for these native domains (e.g.  running
> windows in a
> > virtual machine above Xen), the PCI memory regions should
> be aligned
> > at-least at the page-level (so, a virtual machine - can't
> see data of
> > other devices which may not be assigned to it). So, for
> that reason,
> > we wanted a boot parameter to let us force the kernel to align PCI 
> > memory regions at-least at a PAGE_SIZE alignment. It is very useful 
> > for hypervisors which are developed at Linux environment
> (e.g.: Xen).
> 
> But doesn't aligning such regions on that alignment break some devices

> as that is not what the device is asking for in the BIOS?

No, it shouldn't break. If for example, a device request an alignment of
order 7, it will be provided if you will supply an alignment of larger
order (say 10 bits). An alignment of order that is bigger than 12 bits
is already page aligned, so we do not touch it in that case.

> 
> And if not, why would we not do this for all devices not just for 
> virtual machines, if it is such a benefit?

Since if a device asks for just 1K, the rest of the page (in mmio space)
will be empty if you'll page align it. The other resource will be in
another page and it consumes a separate page. It'll just consume
additional mmio space for nothing.

> 
> Also, how does this play with the hardware IOMMU chips that provide 
> such virtualization in hardware for you?

Actually we are not using an IOMMU, we use a 1:1 mapping that was
developed by Neocleus (for Xen right now), but that holds the same for
Intel VT-d as well.
IOMMUs are there to translate accesses to RAM from PCI devices, we are
more concerned about accesses by the host (cpu).
By using pci-mem-align, we assure that both the virtualized hardware &
the real hardware resources will be page aligned, this way we can remap
those pages so the HVM could safely access the hardware.

> 
> And, we can't accept a patch for 2.6.18, there is no development tree 
> to apply it to anymore, that is a dead kernel tree.  It needs to be 
> against
> 2.6.24-rc1 at the latest to have a chance for approval.
> 

Of course!
If you'll find it useful, we can make a progress and test it on the
latest rev and also do the changes that you asked.

> Is this a patch that distros are shipping in their Xen versions?

Actually, no one knows about it yet :-)

> 
> And how does this play with KVM?

Since we are working on Xen right now (dom0 is 2.6.18) and this feature
might be useful for other hypervisors that will implement pass-through
in the future (AFAIK KVM doesn't support PCI pass-through yet) we
thought to release it for Linux in general.

> 
> thanks,
> 
> greg k-h
>

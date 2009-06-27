Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZF0E0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZF0E0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 00:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbZF0EZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 00:25:55 -0400
Received: from complete.lackof.org ([198.49.126.79]:37595 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZF0EZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 00:25:54 -0400
Date: Fri, 26 Jun 2009 22:25:56 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, hpa@zytor.com
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
	x86
Message-ID: <20090627042556.GA31085@lackof.org>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19013.29264.623540.275538@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19013.29264.623540.275538@pilspetsen.it.uu.se>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 03:13:52AM +0200, Mikael Pettersson wrote:
> Mikael Pettersson writes:
...
>  > CPU: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
>  > Checking 'hlt' instruction... OK.
>  > PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=2
...
>  > pci 0000:00:1e.0: transparent bridge
>  > pci 0000:00:1f.0: PIIX/ICH IRQ router [8086:2810]
>  > 
>  > At this point the kernel hangs hard until rebooted.

...
> I've now identified commit 95ee14e4379c5e19c0897c872350570402014742
> "x86: cap iomem_resource to addressable physical memory" by hpa (cc:d)
> as the culprit. Reverting it fixes my boot hang.

Mikael,
thanks for tracking this down...can you dump the value of c->x86_phys_bits
please?

I have one question about the original commit below.

> > x86: cap iomem_resource to addressable physical memory
> > 
> > iomem_resource is by default initialized to -1, which means 64 bits of
> > physical address space if 64-bit resources are enabled.  However, x86
> > CPUs cannot address 64 bits of physical address space.  Thus, we want
> > to cap the physical address space to what the union of all CPU can
> > actually address.
> > 
> > Without this patch, we may end up assigning inaccessible values to
> > uninitialized 64-bit PCI memory resources.

In general, this makes sense to me and that's why I didn't comment
on the patch when it was originally submitted.

...
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -853,6 +853,9 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
> >  #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
> >  	numa_add_cpu(smp_processor_id());
> >  #endif
> > +
> > +	/* Cap the iomem address space to what is addressable on all CPUs */
> > +	iomem_resource.end &= (1ULL << c->x86_phys_bits) - 1;

Does x86_phys_bits represent the number of address lines/bits handled by
the memory controller, coming out of the CPU, or handled by the
"north bridge" (IO controller)?

I was assuming all three are the same thing but that might not be true
with "QPI" or whatever Intel is calling it's serial interconnect these days.
I'm wondering if the addressing capability of the CPU->memory controller
might be different than CPU->IO Controller.

Parallel interconnects are limited by the number of lines wired to
transmit address data and I expect that's where x86_phys_bits originally
came from. Chipsets _were_ all designed around those limits.

thanks,
grant

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYGDWYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYGDWYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 18:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYGDWYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 18:24:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:42809 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbYGDWYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 18:24:22 -0400
Date: Fri, 4 Jul 2008 15:24:10 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: How to alloc highmem page below 4GB on i386?
Message-ID: <20080704152410.758d4bf4@infradead.org>
In-Reply-To: <20080705000259.3d74c5b6@mjolnir.drzeus.cx>
References: <20080630200323.2a5992cd@mjolnir.drzeus.cx>
	<20080704195800.4ef6e00a@mjolnir.drzeus.cx>
	<20080704111224.68266afc@infradead.org>
	<20080704222323.68afbe88@mjolnir.drzeus.cx>
	<20080704133733.278b6458@infradead.org>
	<20080705000259.3d74c5b6@mjolnir.drzeus.cx>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2008 00:02:59 +0200
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> On Fri, 4 Jul 2008 13:37:33 -0700
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > On Fri, 4 Jul 2008 22:23:23 +0200
> > Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> > > 
> > > I was under the impression that the PCI bus was utterly incapable
> > > of any larger address than 32 bits? But perhaps you only consider
> > > PCIE stuff high-perf. :)
> > 
> > actually your impression is not correct. There's a difference
> > between how many physical bits the bus has, and the logical data.
> > Specifically, PCI (and PCIE etc) have something that's called "Dual
> > Address Cycle", which is a pci bus transaction that sends the 64
> > bit address using 2 cycles on the bus even if the buswidth is 32
> > bit (logically).
> > 
> 
> Ah, I see. I have to admit to only have read the PCI spec briefly. :)
> 
> Still, the devices I'm poking have 32-bit fields, so the limitation is
> still there for my case.

yeah only a portion of the devices out there support the higher
addresses unfortunately. (This comes back to: "the assumption is that
high performance devices support 64 bit". It's an assumption but it
doesn't seem to be too far off the mark)

> 
> > > 
> > > The strange thing is that I keep getting pages from > 4GB all the
> > > time, even on a loaded system. I would have expected mostly
> > > getting pages below that limit as that's where most of the memory
> > > is. Do you have any insight into which areas tend to fill up
> > > first?
> > 
> > ok this is tricky and goes way deep into buddy allocator internals.
> > On the highest level (2Mb chunks iirc, but it could be a bit or
> > two bigger now) we allocate top down. But once we split such a top
> > level chunk up, inside the chunk we allocate bottom up (so that the
> > scatter gather IOs tend to group nicer). 
> > In addition, the kernel will prefer allocating userspace/pagecache
> > memory from highmem over lowmem, out of an effort to keep memory
> > pressure in the lowmem zones lower.
> > 
> 
> For the test I'm playing with, in does a second order allocation,
> which I suppose has good odds of finding a suitable hole somewhere in
> the upper GB.
> 
> Ah well, I suppose this highmem business will eventually blow over. ;)

hehe

well... a copy isn't free, but it's also not THAT expensive. In the
order of 3000 to 4000 cycles or so for a 4Kb copy (of course this varies
with hardware, but as a rough estimate it's in that ballpark)

Another thing is.. use the iommu ;)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbXF3HzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbXF3HzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 03:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbXF3HzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 03:55:09 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2447 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbXF3HzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 03:55:08 -0400
Date: Sat, 30 Jun 2007 08:54:29 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, clameter@sgi.com, hugh@veritas.com,
       James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather lists
Message-ID: <20070630075429.GA26051@flint.arm.linux.org.uk>
References: <Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com> <20070628.220606.112621271.davem@davemloft.net> <20070628222424.4cbae90c.akpm@linux-foundation.org> <20070628.223734.21928089.davem@davemloft.net> <20070628224519.1a3319c3.akpm@linux-foundation.org> <20070629131657.5ecc3baa@the-village.bc.nu> <20070629134529.3e12a131.akpm@linux-foundation.org> <20070629211434.GA21187@flint.arm.linux.org.uk> <20070630001138.6caeb745@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070630001138.6caeb745@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 12:11:38AM +0100, Alan Cox wrote:
> > DMA to or from memory should be done via the DMA mapping API.  If we're
> > DMAing to/from a limited range within a page, either we should be using
> > dma_map_single(), or dma_map_page() with an appropriate offset and size.
> 
> If those ranges overlap a cache line then the dma mapping API will not
> save your backside.

There's nothing much that the DMA API can do though.  Consider DMA
to a result buffer which is, eg, only 16 bytes in size.  So you get
passed a size of '16' to the DMA API.  What should you do at this
point?  BUG()?

What if you have 64 or 128 byte cache lines?

> > sizes, but they do happen.  We handle this on ARM by writing back
> > the overlapped lines and invalidating the rest before the DMA operation
> > commences, and hope that the overlapped lines aren't touched for the
> > duration of the DMA.)
> 
> The combination of "hope" and "DMA" isn't a good one for stable system
> design. In this situation we should be waving large red flags

I agree.

However, I don't think this is an issue for the DMA API to handle; it's
something that driver authors need to be aware of.  If they wish to do
a DMA to a kmalloc'd buffer or even a page, we could require that
offsets and sizes are cache line aligned.

However, remember that turning on slab debugging turns off cache line
alignment, so imposing such a requirement implies that the slab
debugging will break DMA, or driver authors also have to be aware of
that and do their own alignment internally, *or* we provide an allocator
which does unconditionally align.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

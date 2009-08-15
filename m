Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbZHOWfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbZHOWfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 18:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZHOWe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 18:34:59 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:57681 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752334AbZHOWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 18:34:59 -0400
Subject: Re: [PATCH] kmemleak: Ignore the aperture memory hole on x86_64
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090815141716.GA15941@elte.hu>
References: <20090815141716.GA15941@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Sat, 15 Aug 2009 23:34:41 +0100
Message-Id: <1250375681.6889.25.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Aug 2009 22:34:42.0481 (UTC) FILETIME=[95251210:01CA1DF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-15 at 15:17 +0100, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > +     /*
> > +      * Kmemleak should not scan this block as it may not be mapped via the
> > +      * kernel direct mapping.
> > +      */
> > +     kmemleak_ignore(p);
> 
> More importantly, kmemleak should _never_ do the garbage collection
> scan for device memory (such as the agp aperture above). All the
> aperture areas are in that category - PCI aperture, IOMMU areas,
> etc. etc.
> 
> Please double check that kmemleak does not check those - there are
> devices where pure reading of that address space can have
> side-effects.

I'll do a grep. But would such memory still be mapped in the kernel
direct mapping? In this particular case, it was alloc_bootmem() memory
which seems to have been unmapped (and cause an oops), otherwise, at
least on some architectures, may have problems with speculative fetches.

Kmemleak doesn't track other mappings like ioremap, so it should not
scan device memory.

Since you raised this, I realised there is a class of kmalloc'ed memory
blocks that may have some issues on non-coherent architectures. If such
blocks are used for DMA and cache invalidation is only done in
dma_map_single(FROM_DEVICE) (the ARM case), kmemleak scanning before
dma_unmap_single() may pollute the cache. One solution is to invalidate
the caches again in dma_unmap_single(). I'm not sure ignoring GFP_DMA
blocks would be feasible if this flag is used for other blocks
containing pointers. I need to do some tests but I don't think x86 is
affected.

Thanks.

-- 
Catalin


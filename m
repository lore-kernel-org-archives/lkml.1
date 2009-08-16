Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbZHPHFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbZHPHFH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 03:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZHPHFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 03:05:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41370 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZHPHFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 03:05:04 -0400
Date: Sun, 16 Aug 2009 09:04:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemleak: Ignore the aperture memory hole on x86_64
Message-ID: <20090816070451.GA29537@elte.hu>
References: <20090815141716.GA15941@elte.hu> <1250375681.6889.25.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250375681.6889.25.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Sat, 2009-08-15 at 15:17 +0100, Ingo Molnar wrote:
> > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > +     /*
> > > +      * Kmemleak should not scan this block as it may not be mapped via the
> > > +      * kernel direct mapping.
> > > +      */
> > > +     kmemleak_ignore(p);
> > 
> > More importantly, kmemleak should _never_ do the garbage collection
> > scan for device memory (such as the agp aperture above). All the
> > aperture areas are in that category - PCI aperture, IOMMU areas,
> > etc. etc.
> > 
> > Please double check that kmemleak does not check those - there are
> > devices where pure reading of that address space can have
> > side-effects.
> 
> I'll do a grep. But would such memory still be mapped in the 
> kernel direct mapping? [...]

It should not be mapped directly - we try to map all kinds of 
resources 'precisely', so that there can be no cache aliasing 
complications due to over-mapping - but still, there are 
compatibility ranges that are always mapped (the BIOS area for 
example).

> [...] In this particular case, it was alloc_bootmem() memory which 
> seems to have been unmapped (and cause an oops), otherwise, at 
> least on some architectures, may have problems with speculative 
> fetches.
> 
> Kmemleak doesn't track other mappings like ioremap, so it should 
> not scan device memory.
> 
> Since you raised this, I realised there is a class of kmalloc'ed 
> memory blocks that may have some issues on non-coherent 
> architectures. If such blocks are used for DMA and cache 
> invalidation is only done in dma_map_single(FROM_DEVICE) (the ARM 
> case), kmemleak scanning before dma_unmap_single() may pollute the 
> cache. One solution is to invalidate the caches again in 
> dma_unmap_single(). I'm not sure ignoring GFP_DMA blocks would be 
> feasible if this flag is used for other blocks containing 
> pointers. I need to do some tests but I don't think x86 is 
> affected.

Yeah, x86 shouldnt be affected.

	Ingo

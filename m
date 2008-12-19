Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYLSXTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYLSXTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYLSXTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:19:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:38243 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751164AbYLSXTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:19:46 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18L7rJzLw8L7uxLAYN5wYO9d1P6/manQVa93fEHIR
	LG5oXh74cQg6AJ
Date: Sat, 20 Dec 2008 00:19:46 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Johannes Weiner <hannes@cmpxchg.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] bitmap: fix bitmap_find_free_region()
In-Reply-To: <20081219224532.GA2581@cmpxchg.org>
Message-ID: <Pine.LNX.4.64.0812200005430.9649@axis700.grange>
References: <Pine.LNX.4.64.0812191202130.4536@axis700.grange>
 <20081219130211.GA1560@cmpxchg.org> <Pine.LNX.4.64.0812191413520.4536@axis700.grange>
 <20081219144726.GA1991@cmpxchg.org> <Pine.LNX.4.64.0812191553550.4536@axis700.grange>
 <20081219224532.GA2581@cmpxchg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008, Johannes Weiner wrote:

> On Fri, Dec 19, 2008 at 04:09:42PM +0100, Guennadi Liakhovetski wrote:
> > Yes, this is the i.MX31 video capture driver (patch has once been 
> > submitted, new version in work). The thing is, we reserve and declare a 
> > fixed size coherent region in the board code at start-up, but then what 
> > the driver allocates depends on what a user-space application requests - 
> > what size video frame and how many buffers. And the driver does not check 
> > how much coherent memory it has available, it relies on 
> > dma_alloc_coherent() to tell. In fact, the actual i.MX31 camera driver 
> > knows nothing about this allocation, this all happens automatically in 
> > soc_camera.c::soc_camera_mmap() -> 
> > videobuf-dma-contig.c::__videobuf_mmap_mapper().
> > 
> > > I think we should add the check, WARN if it's true and return an
> > > appropriate error number.  It will be handled gracefully then and we
> > > still know which callsite screwed up.
> > 
> > Well, given above you'd get warning each time the user requests too big a 
> > frame or too many buffers, which is not nice.
> 
> Indeed, that's BS then.
> 
> The region size information is local to the dma-coherent code.  So
> either the callsite keeps track of the size itself or, if it can not
> as in your case, we should check for the correct size on exactly that
> layer of code, as well.  Does that sound reasonable?
> 
> Why do other driver not need this?  I will look further into it.  If
> it's any use, here is a patch that does the check on the allocation
> level.

Well, I don't quite understand. Doesn't bitmap_find_free_region() _have_ 
to return an error if the request cannot be satisfied? Isn't it what it 
does if after scanning the bitmap no suitable free region is found? What's 
the difference? Why don't we want to fix _that_ function? It also has 
other users - currently I see 3 of them in the kernel:

mm/vmalloc.c
arch/powerpc/sysdev/msi_bitmap.c (5 occurrences)
arch/sh/kernel/cpu/sh4/sq.c

are we sure that they all are safe wrt to this problem?

Yes, I understand that the caller _can_ verify whether the requested 
region at all fits into the bitmap, but from the PoV of offering a 
consistent API this seems strange.

Thanks
Guennadi

> 
> ---
> dma-coherent: catch oversized requests to dma_alloc_from_coherent()
> 
> Prevent passing an order to bitmap_find_free_region() that is larger
> than the actual bitmap can represent.
> 
> These requests can come from device drivers that have no idea how big
> the dma region is and need to rely on dma_alloc_from_coherent() to
> sort it out for them.
> 
> Reported-by: Guennadi Liakhovetski <lg@denx.de>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
> 
> diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
> index f013a0c..56ea73e 100644
> --- a/kernel/dma-coherent.c
> +++ b/kernel/dma-coherent.c
> @@ -112,6 +112,9 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
>  	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
>  	int order = get_order(size);
>  
> +	if (unlikely(size > mem->size))
> +		return 0;
> +
>  	if (mem) {
>  		int page = bitmap_find_free_region(mem->bitmap, mem->size,
>  						     order);
> 
> 

---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de

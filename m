Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbYLSPJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbYLSPJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 10:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYLSPJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 10:09:33 -0500
Received: from mail.gmx.net ([213.165.64.20]:47484 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750950AbYLSPJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 10:09:33 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18Ki0cCkeoKf3XjHW5XozjNC3zU3Yc3GaTBFlL/VT
	EbaKXDYFe8EbPe
Date: Fri, 19 Dec 2008 16:09:42 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Johannes Weiner <hannes@cmpxchg.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] bitmap: fix bitmap_find_free_region()
In-Reply-To: <20081219144726.GA1991@cmpxchg.org>
Message-ID: <Pine.LNX.4.64.0812191553550.4536@axis700.grange>
References: <Pine.LNX.4.64.0812191202130.4536@axis700.grange>
 <20081219130211.GA1560@cmpxchg.org> <Pine.LNX.4.64.0812191413520.4536@axis700.grange>
 <20081219144726.GA1991@cmpxchg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008, Johannes Weiner wrote:

> On Fri, Dec 19, 2008 at 02:18:22PM +0100, Guennadi Liakhovetski wrote:
> > On Fri, 19 Dec 2008, Johannes Weiner wrote:
> > 
> > > On Fri, Dec 19, 2008 at 12:26:41PM +0100, Guennadi Liakhovetski wrote:
> > > > Currently bitmap_find_free_region() assumes, that the requested region 
> > > > size is smaller than the entire bitmap. If this is not the case it fails 
> > > > to detect it and returns success, while pointing at a position outside of 
> > > > the region.
> > > > 
> > > > Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > ---
> > > > It is hard to believe, that this is a bug, last time this code was touched 
> > > > in 2006... Or should the caller guarantee, that the requested region is 
> > > > not larger than the bitmap? Then dma_alloc_from_coherent() is buggy, which 
> > > > is where I hit this bug. But it seems to me bitmap_find_free_region() 
> > > > should be fixed.
> > > > 
> > > > diff --git a/lib/bitmap.c b/lib/bitmap.c
> > > > index 1338469..079c5e3 100644
> > > > --- a/lib/bitmap.c
> > > > +++ b/lib/bitmap.c
> > > > @@ -950,6 +950,9 @@ int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
> > > >  {
> > > >  	int pos;		/* scans bitmap by regions of size order */
> > > >  
> > > > +	if (bits < 1 << order)
> > > > +		return -ENOMEM;
> > > 
> > > I think this is an error on the callsite, so a WARN_ON() might be good
> > > to spot these.  I would be interested in the callpath that triggered
> > > this bug for you.
> > 
> > As I said above it's called from dma_alloc_from_coherent() from 
> > dma_alloc_coherent().
> 
> Sure, but someone must have done dma_declare_coherent_memory() before
> with a size smaller than it later passed to dma_alloc_coherent(), no?

Yes, this is the i.MX31 video capture driver (patch has once been 
submitted, new version in work). The thing is, we reserve and declare a 
fixed size coherent region in the board code at start-up, but then what 
the driver allocates depends on what a user-space application requests - 
what size video frame and how many buffers. And the driver does not check 
how much coherent memory it has available, it relies on 
dma_alloc_coherent() to tell. In fact, the actual i.MX31 camera driver 
knows nothing about this allocation, this all happens automatically in 
soc_camera.c::soc_camera_mmap() -> 
videobuf-dma-contig.c::__videobuf_mmap_mapper().

> I think we should add the check, WARN if it's true and return an
> appropriate error number.  It will be handled gracefully then and we
> still know which callsite screwed up.

Well, given above you'd get warning each time the user requests too big a 
frame or too many buffers, which is not nice.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de

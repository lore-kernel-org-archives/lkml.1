Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYLSNSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYLSNSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 08:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbYLSNSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 08:18:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:37420 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753121AbYLSNSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 08:18:14 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18S6zBSA1ESr/Eo68Q2RIASCjL2hAMDREH5iivf43
	qRlK/B/3ptVs5u
Date: Fri, 19 Dec 2008 14:18:22 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Johannes Weiner <hannes@cmpxchg.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] bitmap: fix bitmap_find_free_region()
In-Reply-To: <20081219130211.GA1560@cmpxchg.org>
Message-ID: <Pine.LNX.4.64.0812191413520.4536@axis700.grange>
References: <Pine.LNX.4.64.0812191202130.4536@axis700.grange>
 <20081219130211.GA1560@cmpxchg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008, Johannes Weiner wrote:

> On Fri, Dec 19, 2008 at 12:26:41PM +0100, Guennadi Liakhovetski wrote:
> > Currently bitmap_find_free_region() assumes, that the requested region 
> > size is smaller than the entire bitmap. If this is not the case it fails 
> > to detect it and returns success, while pointing at a position outside of 
> > the region.
> > 
> > Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > It is hard to believe, that this is a bug, last time this code was touched 
> > in 2006... Or should the caller guarantee, that the requested region is 
> > not larger than the bitmap? Then dma_alloc_from_coherent() is buggy, which 
> > is where I hit this bug. But it seems to me bitmap_find_free_region() 
> > should be fixed.
> > 
> > diff --git a/lib/bitmap.c b/lib/bitmap.c
> > index 1338469..079c5e3 100644
> > --- a/lib/bitmap.c
> > +++ b/lib/bitmap.c
> > @@ -950,6 +950,9 @@ int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
> >  {
> >  	int pos;		/* scans bitmap by regions of size order */
> >  
> > +	if (bits < 1 << order)
> > +		return -ENOMEM;
> 
> I think this is an error on the callsite, so a WARN_ON() might be good
> to spot these.  I would be interested in the callpath that triggered
> this bug for you.

As I said above it's called from dma_alloc_from_coherent() from 
dma_alloc_coherent().

> And return -ENOSPC?

So, you agree that a check should be added to bitmap_find_free_region()? 
As for details - to warn or not to warn and what error code to return, 
that can be discussed, although "No space left on device" doesn't seem to 
fit very well IMHO:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de

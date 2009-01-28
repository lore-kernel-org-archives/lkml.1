Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZA1IhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZA1IhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 03:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZA1Ig6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 03:36:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:37060 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752704AbZA1Ig5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 03:36:57 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18Z1eRlcpQZeXROgYP0acutfwAho9zoQaF3AtC4/t
	EcXc+Ks+0tx8Wk
Date: Wed, 28 Jan 2009 09:36:57 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Paul Mundt <lethal@linux-sh.org>
cc: Andrew Morton <akpm@linux-foundation.org>, adrian@newgolddream.dyndns.info,
       lkmladrian@gmail.com, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, penberg@cs.helsinki.fi, dbaryshkov@gmail.com,
       penguin-kernel@i-love.sakura.ne.jp, hannes@cmpxchg.org
Subject: Re: [PATCH] dma: fix up broken comparison in dma_alloc_from_coherent
In-Reply-To: <20090127225458.GA8756@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0901280913090.4926@axis700.grange>
References: <8b67d60901201348r6a59928dw3fcf8c9c823d5c68@mail.gmail.com>
 <1232488507.6794.8.camel@localhost.localdomain> <20090121033951.GB14094@linux-sh.org>
 <20090121081118.GA14537@linux-sh.org> <20090127134831.3dd04182.akpm@linux-foundation.org>
 <20090127225458.GA8756@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Paul Mundt wrote:

> On Tue, Jan 27, 2009 at 01:48:31PM -0800, Andrew Morton wrote:
> > On Wed, 21 Jan 2009 17:11:19 +0900
> > Paul Mundt <lethal@linux-sh.org> wrote:
> > 
> > > @@ -118,31 +118,32 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
> > >  	mem = dev->dma_mem;
> > >  	if (!mem)
> > >  		return 0;
> > > -	if (unlikely(size > mem->size))
> > > - 		return 0;
> > > +
> > > +	*ret = NULL;
> > > +
> > > +	if (unlikely(size > (mem->size << PAGE_SHIFT)))
> > > +		goto err;
> > 
> > Looks a bit broken on 64-bit.

Not related to the 64-bit dangers, but using bitmap_find_free_region() in 
dma_alloc_from_coherent() breaks in most non-spectacular ways again and 
again. This loop and test in bitmap_find_free_region()

	for (pos = 0; pos < bits; pos += (1 << order))
		if (__reg_op(bitmap, pos, order, REG_OP_ISFREE))
			break;
	if (pos == bits)
		return -ENOMEM;

can only return an error (-ENOMEM) if bits is a multiple of (1 << order), 
which is, for instance, true, if bits is (also) a power of 2. Which 
doesn't seem to be necessarily the case with dma_alloc_from_coherent(). 
Where shall this one be fixed - in bitmap or in DMA? The correct test in 
bitmap code seems to be

	if (pos + (1 << order) > bits)
		return -ENOMEM;

and I don't see a way to fix this in dma. Checking afterwards is too late 
- the current bitmap_find_free_region() will (with a bit of luck) quietly 
overwrite data beyond bits.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbZA0W62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbZA0W62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbZA0W6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:58:17 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:42009 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751240AbZA0W6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:58:16 -0500
Date: Wed, 28 Jan 2009 07:54:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adrian@newgolddream.dyndns.info, lkmladrian@gmail.com,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       penberg@cs.helsinki.fi, dbaryshkov@gmail.com,
       penguin-kernel@i-love.sakura.ne.jp, lg@denx.de, hannes@cmpxchg.org
Subject: Re: [PATCH] dma: fix up broken comparison in dma_alloc_from_coherent
Message-ID: <20090127225458.GA8756@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	adrian@newgolddream.dyndns.info, lkmladrian@gmail.com,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	penberg@cs.helsinki.fi, dbaryshkov@gmail.com,
	penguin-kernel@i-love.sakura.ne.jp, lg@denx.de, hannes@cmpxchg.org
References: <8b67d60901201348r6a59928dw3fcf8c9c823d5c68@mail.gmail.com> <1232488507.6794.8.camel@localhost.localdomain> <20090121033951.GB14094@linux-sh.org> <20090121081118.GA14537@linux-sh.org> <20090127134831.3dd04182.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127134831.3dd04182.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 01:48:31PM -0800, Andrew Morton wrote:
> On Wed, 21 Jan 2009 17:11:19 +0900
> Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > @@ -118,31 +118,32 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
> >  	mem = dev->dma_mem;
> >  	if (!mem)
> >  		return 0;
> > -	if (unlikely(size > mem->size))
> > - 		return 0;
> > +
> > +	*ret = NULL;
> > +
> > +	if (unlikely(size > (mem->size << PAGE_SHIFT)))
> > +		goto err;
> 
> Looks a bit broken on 64-bit.
> 
> `size' is ssize_t (long).
> 
> `mem->size' is `int'.
> 
> The left shift can overflow and cause badnesses.
> 
> > +	*dma_handle = mem->device_base + (pageno << PAGE_SHIFT);
> > +	*ret = mem->virt_base + (pageno << PAGE_SHIFT);
> 
> Ditto.
> 
> 
> Maybe it's a can't-happen (why?), but...

It is probably worth adding casts to avoid the potential for overflow,
but it's not likely that this would ever be a problem in practice.
Someone would need a pretty big per-device memory area for this to ever
overflow anyways, and if the device has that much memory, people are
probably going to want to do something else with it besides designating
all of it for DMA buffer usage ;-)

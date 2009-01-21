Return-Path: <linux-kernel-owner+w=401wt.eu-S1762488AbZAUDnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762488AbZAUDnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 22:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZAUDm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 22:42:56 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:63953 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755062AbZAUDmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 22:42:55 -0500
Date: Wed, 21 Jan 2009 12:39:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Adrian McMenamin <lkmladrian@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-sh <linux-sh@vger.kernel.org>, penberg@cs.helsinki.fi,
       dbaryshkov@gmail.com, penguin-kernel@i-love.sakura.ne.jp,
       Guennadi Liakhovetski <lg@denx.de>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] dma: fix up broken comparison in dma_alloc_from_coherent
Message-ID: <20090121033951.GB14094@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-sh <linux-sh@vger.kernel.org>, penberg@cs.helsinki.fi,
	dbaryshkov@gmail.com, penguin-kernel@i-love.sakura.ne.jp,
	Guennadi Liakhovetski <lg@denx.de>,
	Johannes Weiner <hannes@cmpxchg.org>
References: <8b67d60901201348r6a59928dw3fcf8c9c823d5c68@mail.gmail.com> <1232488507.6794.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232488507.6794.8.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 09:55:07PM +0000, Adrian McMenamin wrote:
> On Tue, 2009-01-20 at 21:48 +0000, Adrian McMenamin wrote:
> > Currently this code compares a size in bytes with a size in pages.
> > This patch makes both sides of the comparison bytes.
> 
> Apologies, here it is without the line wrap.
> 
> Currently this comparison is made between bytes and pages. This patch
> ensures it is bytes on both side of the comparison.
> 
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> ---
> 
> --- a/kernel/dma-coherent.c
> +++ b/kernel/dma-coherent.c
> @@ -118,7 +118,7 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
>  	mem = dev->dma_mem;
>  	if (!mem)
>  		return 0;
> -	if (unlikely(size > mem->size))
> +	if (unlikely(size > mem->size << PAGE_SHIFT))
>   		return 0;
>  
>  	pageno = bitmap_find_free_region(mem->bitmap, mem->size, order);
> 
What is more concerning is that the change that introduced this:

commit 58c6d3dfe436eb8cfb451981d8fdc9044eaf42da
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Tue Jan 6 14:43:10 2009 -0800

    dma-coherent: catch oversized requests to dma_alloc_from_coherent()

    Prevent passing an order to bitmap_find_free_region() that is larger than
    the actual bitmap can represent.

    These requests can come from device drivers that have no idea how big the
    dma region is and need to rely on dma_alloc_from_coherent() to sort it out
    for them.

    Reported-by: Guennadi Liakhovetski <lg@denx.de>
    Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
...

Claims to fix a problem that doesn't exist anywhere in-tree today, and was
obviously never tested. This looks like a sanity thing for drivers that derive
their coherent pool from passed in platform device resources.

It is equally impressive that the author of this patch modified a code path
that is only hit by platforms that provide dma_declare_coherent_memory() (sh,
arm, mips, and x86_32) and subsequently failed to Cc the primary users of the
interface.

I'll add your patch to my queue and send it off to Linus later today, thanks.

Return-Path: <linux-kernel-owner+w=401wt.eu-S932350AbZKDRf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbZKDRf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932297AbZKDRfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:35:23 -0500
Received: from [95.166.99.235] ([95.166.99.235]:39580 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932256AbZKDRfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:35:20 -0500
Date: Wed, 4 Nov 2009 18:35:24 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Horton <phorton@bitbox.co.uk>, ecashin@coraid.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] prevent AoE causing cache aliases
Message-ID: <20091104173524.GE8742@kernel.dk>
References: <20091022142228.GA18986@bitbox.co.uk> <20091103163755.57d3530c.akpm@linux-foundation.org> <4AF15D6A.5020403@bitbox.co.uk> <20091104073438.7d2fa27a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104073438.7d2fa27a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04 2009, Andrew Morton wrote:
> On Wed, 04 Nov 2009 10:54:34 +0000 Peter Horton <phorton@bitbox.co.uk> wrote:
> 
> > Andrew Morton wrote:
> > > On Thu, 22 Oct 2009 15:22:28 +0100
> > > phorton@bitbox.co.uk (Peter Horton) wrote:
> > > 
> > >> To: ecashin@coraid.com
> > > 
> > > Have you heard back from Ed on this?
> > >
> > 
> > No.
> > 
> > >> Cc: linux-kernel@vger.kernel.org
> > >> Subject: [PATCH] prevent AoE causing cache aliases
> > >> Date: 	Thu, 22 Oct 2009 15:22:28 +0100
> > >> Sender: linux-kernel-owner@vger.kernel.org
> > >> User-Agent: Mutt/1.5.9i
> > >>
> > >> This patch prevents the AoE block driver from creating cache aliases of
> > >> page cache pages on machines with virtually indexed caches.
> > >>
> > >> Building kernels on an AT91SAM9G20 board without this patch fails with
> > >> segmentation faults after a couple of passes.
> > >>
> > >>
> > >> Index: linux-2.6.31/drivers/block/aoe/aoecmd.c
> > >> ===================================================================
> > >> --- linux-2.6.31.orig/drivers/block/aoe/aoecmd.c	2009-09-09 23:13:59.000000000 +0100
> > >> +++ linux-2.6.31/drivers/block/aoe/aoecmd.c	2009-10-22 10:24:50.000000000 +0100
> > >> @@ -735,6 +735,21 @@
> > >>  	part_stat_unlock();
> > >>  }
> > >>  
> > >> +/*
> > >> + * Ensure we don't create aliases in VI caches
> > >> + */
> > >> +static inline void
> > >> +killalias(struct bio *bio)
> > >> +{
> > >> +	struct bio_vec *bv;
> > >> +	int i;
> > >> +
> > >> +	if (bio_data_dir(bio) == READ)
> > >> +		__bio_for_each_segment(bv, bio, i, 0) {
> > >> +			flush_dcache_page(bv->bv_page);
> > >> +		}
> > >> +}
> > >> +
> > >>  void
> > >>  aoecmd_ata_rsp(struct sk_buff *skb)
> > >>  {
> > >> @@ -853,8 +868,12 @@
> > >>  
> > >>  	if (buf && --buf->nframesout == 0 && buf->resid == 0) {
> > >>  		diskstats(d->gd, buf->bio, jiffies - buf->stime, buf->sector);
> > >> -		n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
> > >> -		bio_endio(buf->bio, n);
> > >> +		if (buf->flags & BUFFL_FAIL)
> > >> +			bio_endio(buf->bio, -EIO);
> > >> +		else {
> > >> +			killalias(buf->bio);
> > >> +			bio_endio(buf->bio, 0);
> > >> +		}
> > >>  		mempool_free(buf, d->bufpool);
> > >>  	}
> > > 
> > > Looks OK.
> > > 
> > > This bugfix will cause a pointless __bio_for_each_segment() busywait
> > > loop to be executed on architectures for which flush_dcache_page() is a
> > > no-op.
> > > 
> > > We don't have infrastructure to fix that.
> > 
> > Couldn't we add a flag to the bio that users could set to indicate that 
> > they are not house trained with respect to the D-cache (i.e non-DMA 
> > drivers). Architectures that needed to could then flush the relevant 
> > pages in the bio_endio() path somewhere. At the moment all the non-DMA 
> > block drivers need to be aware of the cache aliasing issue which means 
> > this problem keeps arising ...
> > 
> 
> Could.  We'll need to change each arch _somehow_.  Even if it's a
> matter of adding `#define i_am_not_house_trained' to the troublesome
> ones or something, then ifdeffing existing code.
> 
> I was thinking that a general bio_flush_dcache_pages() in block core
> (or in each arch) would be a suitable way to handle this but I was
> unable to find other drivers which needed it after a brief search.

Indeed, we should have such a helper. I can't find any ARCH define that
tells us when we need to do this. Easiest is probably to grep in arch/
for non-empty definitions of flush_dcache_page() and add such a define.

I'll hack one up.

-- 
Jens Axboe


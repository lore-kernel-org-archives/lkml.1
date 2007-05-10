Return-Path: <linux-kernel-owner+w=401wt.eu-S1761211AbXEJKw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761211AbXEJKw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbXEJKwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:52:39 -0400
Received: from brick.kernel.dk ([80.160.20.94]:9213 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045AbXEJKwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:52:38 -0400
Date: Thu, 10 May 2007 12:52:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/13] SCSI: support for allocating large scatterlists
Message-ID: <20070510105208.GN4629@kernel.dk>
References: <11787925152319-git-send-email-jens.axboe@oracle.com> <11787925161084-git-send-email-jens.axboe@oracle.com> <20070510034804.3caa9fa9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510034804.3caa9fa9.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10 2007, Andrew Morton wrote:
> On Thu, 10 May 2007 12:21:53 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > This is what enables large commands. If we need to allocate an
> > sgtable that doesn't fit in a single page, allocate several
> > SCSI_MAX_SG_SEGMENTS sized tables and chain them together.
> > 
> > We default to the safe setup of NOT chaining, for now.
> > 
> > ...
> >
> > +/*
> > + * Should fit within a single page, and must be a power-of-2.
> > + */
> > +#define SCSI_MAX_SG_SEGMENTS	128
> 
> But what units is it in?  Bytes?  sizeof(void*)?

sg elements. It's not new, just juggled around a bit. The comment is a
bit stale now though, it doesn't have to be a pow-of-2. Ideally we just
want to make sure that sizeof(struct scatterlist) * SCSI_MAX_SG_SEGMENTS
<= PAGE_SIZE to avoid 2^1 allocations.

> > +struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
> > +{
> > +	struct scsi_host_sg_pool *sgp;
> > +	struct scatterlist *sgl, *prev, *ret;
> > +	unsigned int index;
> > +	int this, left;
> > +
> > +	BUG_ON(!cmd->use_sg);
> > +
> > +	left = cmd->use_sg;
> > +	ret = prev = NULL;
> > +	do {
> > +		this = left;
> > +		if (this > SCSI_MAX_SG_SEGMENTS) {
> > +			this = SCSI_MAX_SG_SEGMENTS;
> > +			index = SG_MEMPOOL_NR - 1;
> > +		} else
> > +			index = scsi_sgtable_index(this);
> > +
> > +		left -= this;
> > +
> > +		/*
> > +		 * if we have more entries after this round, reserve a slot
> > +		 * for the chain pointer.
> > +		 */
> > +		if (left)
> > +			left++;
> > +
> > +		sgp = scsi_sg_pools + index;
> > +
> > +		sgl = mempool_alloc(sgp->pool, gfp_mask);
> > +		if (unlikely(!sgl))
> > +			goto enomem;
> > +
> > +		memset(sgl, 0, sizeof(*sgl) * sgp->size);
> > +
> > +		/*
> > +		 * first loop through, set initial index and return value
> > +		 */
> > +		if (!ret) {
> > +			cmd->sglist_len = index;
> > +			ret = sgl;
> > +		}
> > +
> > +		/*
> > +		 * chain previous sglist, if any. we know the previous
> > +		 * sglist must be the biggest one, or we would not have
> > +		 * ended up doing another loop.
> > +		 */
> > +		if (prev)
> > +			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
> > +
> > +		/*
> > +		 * don't allow subsequent mempool allocs to sleep, it would
> > +		 * violate the mempool principle.
> > +		 */
> > +		gfp_mask &= ~__GFP_WAIT;
> 
> hrm.
> 
> Might want to set __GFP_HIGH here too.

Agree, I did consider that (clear wait, set ATOMIC to get the __HIGH).

-- 
Jens Axboe


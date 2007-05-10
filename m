Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbXEJKsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbXEJKsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbXEJKsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:48:25 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756823AbXEJKsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:48:25 -0400
Date: Thu, 10 May 2007 03:48:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/13] SCSI: support for allocating large scatterlists
Message-Id: <20070510034804.3caa9fa9.akpm@linux-foundation.org>
In-Reply-To: <11787925161084-git-send-email-jens.axboe@oracle.com>
References: <11787925152319-git-send-email-jens.axboe@oracle.com>
	<11787925161084-git-send-email-jens.axboe@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 12:21:53 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> This is what enables large commands. If we need to allocate an
> sgtable that doesn't fit in a single page, allocate several
> SCSI_MAX_SG_SEGMENTS sized tables and chain them together.
> 
> We default to the safe setup of NOT chaining, for now.
> 
> ...
>
> +/*
> + * Should fit within a single page, and must be a power-of-2.
> + */
> +#define SCSI_MAX_SG_SEGMENTS	128

But what units is it in?  Bytes?  sizeof(void*)?

> +struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
> +{
> +	struct scsi_host_sg_pool *sgp;
> +	struct scatterlist *sgl, *prev, *ret;
> +	unsigned int index;
> +	int this, left;
> +
> +	BUG_ON(!cmd->use_sg);
> +
> +	left = cmd->use_sg;
> +	ret = prev = NULL;
> +	do {
> +		this = left;
> +		if (this > SCSI_MAX_SG_SEGMENTS) {
> +			this = SCSI_MAX_SG_SEGMENTS;
> +			index = SG_MEMPOOL_NR - 1;
> +		} else
> +			index = scsi_sgtable_index(this);
> +
> +		left -= this;
> +
> +		/*
> +		 * if we have more entries after this round, reserve a slot
> +		 * for the chain pointer.
> +		 */
> +		if (left)
> +			left++;
> +
> +		sgp = scsi_sg_pools + index;
> +
> +		sgl = mempool_alloc(sgp->pool, gfp_mask);
> +		if (unlikely(!sgl))
> +			goto enomem;
> +
> +		memset(sgl, 0, sizeof(*sgl) * sgp->size);
> +
> +		/*
> +		 * first loop through, set initial index and return value
> +		 */
> +		if (!ret) {
> +			cmd->sglist_len = index;
> +			ret = sgl;
> +		}
> +
> +		/*
> +		 * chain previous sglist, if any. we know the previous
> +		 * sglist must be the biggest one, or we would not have
> +		 * ended up doing another loop.
> +		 */
> +		if (prev)
> +			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
> +
> +		/*
> +		 * don't allow subsequent mempool allocs to sleep, it would
> +		 * violate the mempool principle.
> +		 */
> +		gfp_mask &= ~__GFP_WAIT;

hrm.

Might want to set __GFP_HIGH here too.

> +		prev = sgl;
> +	} while (left);
> +
> +	/*
> +	 * ->use_sg may get modified after dma mapping has potentially
> +	 * shrunk the number of segments, so keep a copy of it for free.
> +	 */
> +	cmd->__use_sg = cmd->use_sg;
> +	return ret;
> +enomem:
> +	if (ret) {
> +		/*
> +		 * Free entries chained off ret. Since we were trying to
> +		 * allocate another sglist, we know that all entries are of
> +		 * the max size.
> +		 */
> +		sgp = scsi_sg_pools + SG_MEMPOOL_NR - 1;
> +		prev = &ret[SCSI_MAX_SG_SEGMENTS - 1];
> +
> +		while ((sgl = sg_chain_ptr(ret)) != NULL) {
> +			ret = &sgl[SCSI_MAX_SG_SEGMENTS - 1];
> +			mempool_free(sgl, sgp->pool);
> +		}
> +
> +		mempool_free(prev, sgp->pool);
> +	}
> +	return NULL;
>  }


Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXBLEnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXBLEnj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 23:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932965AbXBLEnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 23:43:39 -0500
Received: from brick.kernel.dk ([62.242.22.158]:17414 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821AbXBLEni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 23:43:38 -0500
Date: Mon, 12 Feb 2007 05:43:39 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>
Subject: Re: [PATCH 7/8] lguest: trivial guest block driver
Message-ID: <20070212044339.GJ3685@kernel.dk>
References: <1171251578.10409.17.camel@localhost.localdomain> <1171251698.10409.20.camel@localhost.localdomain> <1171251770.10409.23.camel@localhost.localdomain> <1171251894.10409.26.camel@localhost.localdomain> <1171251965.10409.28.camel@localhost.localdomain> <1171252113.10409.30.camel@localhost.localdomain> <1171252219.10409.33.camel@localhost.localdomain> <1171252321.10409.36.camel@localhost.localdomain> <1171252405.10409.39.camel@localhost.localdomain> <1171252474.10409.42.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171252474.10409.42.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12 2007, Rusty Russell wrote:
> +static irqreturn_t lgb_irq(int irq, void *_bd)
> +{
> +	struct blockdev *bd = _bd;
> +	unsigned long flags;
> +
> +	if (!bd->req) {
> +		pr_debug("No work!\n");
> +		return IRQ_NONE;
> +	}
> +
> +	if (!bd->lb_page->result) {
> +		pr_debug("No result!\n");
> +		return IRQ_NONE;
> +	}
> +
> +	spin_lock_irqsave(&bd->lock, flags);
> +	end_request(bd->req, bd->lb_page->result == 1);
> +	bd->req = NULL;
> +	bd->dma.used_len = 0;
> +	blk_start_queue(bd->disk->queue);
> +	spin_unlock_irqrestore(&bd->lock, flags);
> +	return IRQ_HANDLED;
> +}

You are using the old-style end request handling. So while I generally
discourage use of end_request(), you seem to have a bigger problem here:

> +static unsigned int req_to_dma(struct request *req, struct lguest_dma *dma)
> +{
> +	unsigned int i = 0, idx, len = 0;
> +	struct bio *bio;
> +
> +	rq_for_each_bio(bio, req) {
> +		struct bio_vec *bvec;
> +		bio_for_each_segment(bvec, bio, idx) {
> +			BUG_ON(i == LGUEST_MAX_DMA_SECTIONS);
> +			BUG_ON(!bvec->bv_len);
> +			dma->addr[i] = page_to_phys(bvec->bv_page)
> +				+ bvec->bv_offset;
> +			dma->len[i] = bvec->bv_len;
> +			len += bvec->bv_len;
> +			i++;
> +		}
> +	}
> +	if (i < LGUEST_MAX_DMA_SECTIONS)
> +		dma->len[i] = 0;
> +	return len;
> +}

Here you map the entire request (lets call that segment A..Z), but
end_request() only completes the first chunk of the request. So
elv_next_request() will retrieve the same request again, and you'll then
map B..Z and repeat that transfer. So unless I'm missing some other part
here (just read it over quickly), you are re-doing large parts of a
merged request several times.

So: don't use end_request(). Add some driver helper that does:

static void lgb_end_request(struct blockdev *bd)
{
        int uptodate = bd->lb_page->result == 1;
        struct request *rq = bd->req;

        end_that_request_first(rq, uptodate, req->hard_nr_sectors);
        add_disk_randomness(rq->rq_disk);
        blkdev_dequeue_request(rq);
        end_that_request_last(rq, uptodate);
}

We could probably even make that a block layer helper, I'm sure others
could be cleaned up with that as well. You want to use that helper in
do_lgb_request() as well.

-- 
Jens Axboe


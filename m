Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbZHJKT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbZHJKT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 06:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbZHJKT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 06:19:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbZHJKT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 06:19:26 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] Initialize mempool and elevator only for request-based dm devices
Date: Mon, 10 Aug 2009 15:51:11 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org
References: <200908081026.01097.knikanth@suse.de> <20090808162156.GA7432@redhat.com>
In-Reply-To: <20090808162156.GA7432@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908101551.12047.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 August 2009 21:51:59 Mike Snitzer wrote:
> On Sat, Aug 08 2009 at 12:56am -0400,
>
> Nikanth Karthikesan <knikanth@suse.de> wrote:
> > Intialize the request_queue and elevator only when the device is marked
> > as a request-based device. This avoids unnecessary creation of mempool
> > for requests. Also we wrongly initialize the elevator even for bio-based
> > devices. As the /sys/block/dm-*/queue/scheduler is exported for
> > device-mapper devices, it is possible to confuse with scheduler options
> > for bio-based devices where scheduler is not at all used.
> >
> > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
>
> I like how this clearly splits out request-based DM queue initialization.
>

Thanks.

> More comments below.
>
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 8a311ea..b01dfbe 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -2203,7 +2199,25 @@ int dm_swap_table(struct mapped_device *md, struct
> > dm_table *table) goto out;
> >  	}
> >
> > -	__unbind(md);
> > +	if (md->map)
> > +		__unbind(md);
> > +	else {
> > +	/* new device is being marked as either request-based or bio-based */
> > +		if (dm_table_request_based(table)) {
> > +			/* Initialize queue for request-based dm */
> > +			r = blk_init_allocated_queue(md->queue, dm_request_fn,
> > +								 NULL);
> > +			if (r)
> > +				goto out;
> > +			md->saved_make_request_fn = md->queue->make_request_fn;
> > +			blk_queue_make_request(md->queue, dm_request);
>
> This blk_queue_make_request() is redundant as it was already established
> in alloc_dev().  The fact that its behavior is now altered as a result
> of the md->saved_make_request_fn assignment doesn't change the fact that
> the queue will be using dm_request().  Am I missing something?
>

blk_init_allocated_queue() would reset it to __make_request(). So we need to 
initialize it again. I would add a comment in v2 of the patch.

> Also, I think the code should be cleaned up as follows:
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index b01dfbe..1b8aa43 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2199,25 +2199,18 @@ int dm_swap_table(struct mapped_device *md, struct
> dm_table *table) goto out;
>  	}
>
> -	if (md->map)
> -		__unbind(md);
> -	else {
> -	/* new device is being marked as either request-based or bio-based */
> -		if (dm_table_request_based(table)) {
> -			/* Initialize queue for request-based dm */
> -			r = blk_init_allocated_queue(md->queue, dm_request_fn,
> -								 NULL);
> -			if (r)
> -				goto out;
> -			md->saved_make_request_fn = md->queue->make_request_fn;
> -			blk_queue_make_request(md->queue, dm_request);
> -			blk_queue_softirq_done(md->queue, dm_softirq_done);
> -			blk_queue_prep_rq(md->queue, dm_prep_fn);
> -			blk_queue_lld_busy(md->queue, dm_lld_busy);
> -
> -		}
> +	if (!md->map && dm_table_request_based(table)) {
> +		/* Initialize queue for request-based dm */
> +		r = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
> +		if (r)
> +			goto out;
> +		md->saved_make_request_fn = md->queue->make_request_fn;
> +		blk_queue_softirq_done(md->queue, dm_softirq_done);
> +		blk_queue_prep_rq(md->queue, dm_prep_fn);
> +		blk_queue_lld_busy(md->queue, dm_lld_busy);
>  	}
>
> +	__unbind(md);
>  	r = __bind(md, table, &limits);
>
>  out:

I thought of this. But personally, I did not prefer this, as this makes it 
clear that we do __unbind() only on not new devices. But, yes it needs more 
level of nesting and looks ugly. Changed in v2 of the patch.

Thanks
Nikanth


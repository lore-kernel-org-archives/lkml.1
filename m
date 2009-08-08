Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbZHHQWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbZHHQWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 12:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZHHQWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 12:22:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59996 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbZHHQWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 12:22:10 -0400
Date: Sat, 8 Aug 2009 12:21:59 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Initialize mempool and elevator only for
	request-based dm devices
Message-ID: <20090808162156.GA7432@redhat.com>
References: <200908081026.01097.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908081026.01097.knikanth@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 08 2009 at 12:56am -0400,
Nikanth Karthikesan <knikanth@suse.de> wrote:

> Intialize the request_queue and elevator only when the device is marked as
> a request-based device. This avoids unnecessary creation of mempool for
> requests. Also we wrongly initialize the elevator even for bio-based devices.
> As the /sys/block/dm-*/queue/scheduler is exported for device-mapper devices,
> it is possible to confuse with scheduler options for bio-based devices where
> scheduler is not at all used.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

I like how this clearly splits out request-based DM queue initialization.

More comments below.

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 8a311ea..b01dfbe 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2203,7 +2199,25 @@ int dm_swap_table(struct mapped_device *md, struct dm_table *table)
>  		goto out;
>  	}
>  
> -	__unbind(md);
> +	if (md->map)
> +		__unbind(md);
> +	else {
> +	/* new device is being marked as either request-based or bio-based */
> +		if (dm_table_request_based(table)) {
> +			/* Initialize queue for request-based dm */
> +			r = blk_init_allocated_queue(md->queue, dm_request_fn,
> +								 NULL);
> +			if (r)
> +				goto out;
> +			md->saved_make_request_fn = md->queue->make_request_fn;
> +			blk_queue_make_request(md->queue, dm_request);

This blk_queue_make_request() is redundant as it was already established
in alloc_dev().  The fact that its behavior is now altered as a result
of the md->saved_make_request_fn assignment doesn't change the fact that
the queue will be using dm_request().  Am I missing something?

Also, I think the code should be cleaned up as follows:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b01dfbe..1b8aa43 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2199,25 +2199,18 @@ int dm_swap_table(struct mapped_device *md, struct dm_table *table)
 		goto out;
 	}
 
-	if (md->map)
-		__unbind(md);
-	else {
-	/* new device is being marked as either request-based or bio-based */
-		if (dm_table_request_based(table)) {
-			/* Initialize queue for request-based dm */
-			r = blk_init_allocated_queue(md->queue, dm_request_fn,
-								 NULL);
-			if (r)
-				goto out;
-			md->saved_make_request_fn = md->queue->make_request_fn;
-			blk_queue_make_request(md->queue, dm_request);
-			blk_queue_softirq_done(md->queue, dm_softirq_done);
-			blk_queue_prep_rq(md->queue, dm_prep_fn);
-			blk_queue_lld_busy(md->queue, dm_lld_busy);
-
-		}
+	if (!md->map && dm_table_request_based(table)) {
+		/* Initialize queue for request-based dm */
+		r = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
+		if (r)
+			goto out;
+		md->saved_make_request_fn = md->queue->make_request_fn;
+		blk_queue_softirq_done(md->queue, dm_softirq_done);
+		blk_queue_prep_rq(md->queue, dm_prep_fn);
+		blk_queue_lld_busy(md->queue, dm_lld_busy);
 	}
 
+	__unbind(md);
 	r = __bind(md, table, &limits);
 
 out:

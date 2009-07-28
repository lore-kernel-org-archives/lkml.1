Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836AbZG1JbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbZG1JbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 05:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbZG1JbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 05:31:00 -0400
Received: from wayne.mcbone.net ([62.104.198.72]:37550 "EHLO wayne.mcbone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbZG1JbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 05:31:00 -0400
Date: Tue, 28 Jul 2009 11:30:57 +0200
From: Jens Rosenboom <jens.rosenboom@freenet.ag>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops when writing to /sys/block/ram0/queue/max_sectors_kb
Message-ID: <20090728093057.GJ21919@bo.mcbone.net>
References: <1248363032.7237.48.camel@fnki-nb00130> <20090728070711.GN4148@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728070711.GN4148@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 09:07:11AM +0200, Jens Axboe wrote:
[...]
> Looks like this will hit nonrot/merge/etc store functions after we
> exposed these sysfs knobs for non-request_fn drivers too. Can you try
> the below? Should fix all of them up.
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 4b45435..a0c340d 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -575,13 +575,6 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
>  		return NULL;
>  	}
>  
> -	/*
> -	 * if caller didn't supply a lock, they get per-queue locking with
> -	 * our embedded lock
> -	 */
> -	if (!lock)
> -		lock = &q->__queue_lock;
> -
>  	q->request_fn		= rfn;
>  	q->prep_rq_fn		= NULL;
>  	q->unplug_fn		= generic_unplug_device;
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index bd582a7..8a3ea3b 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -165,6 +165,13 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
>  	blk_set_default_limits(&q->limits);
>  
>  	/*
> +	 * If the caller didn't supply a lock, fall back to our embedded
> +	 * per-queue locks
> +	 */
> +	if (!q->queue_lock)
> +		q->queue_lock = &q->__queue_lock;
> +
> +	/*
>  	 * by default assume old behaviour and bounce for any highmem page
>  	 */
>  	blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH);

Works for me, no more Oopses.

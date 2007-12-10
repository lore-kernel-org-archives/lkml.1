Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbXLJNWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbXLJNWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 08:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbXLJNWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 08:22:09 -0500
Received: from brick.kernel.dk ([87.55.233.238]:21586 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbXLJNWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 08:22:08 -0500
Date: Mon, 10 Dec 2007 14:19:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Message-ID: <20071210131901.GI5008@kernel.dk>
References: <200712051603.02183.phillips@phunq.net> <200712100427.58288.phillips@phunq.net> <20071210123244.GG5008@kernel.dk> <200712100504.15865.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712100504.15865.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10 2007, Daniel Phillips wrote:
> On Monday 10 December 2007 04:32, Jens Axboe wrote:
> > I honestly don't know how to make this any clearer than I already did
> > above.
> 
> Sure you do, you could cut out the rhetoric and save lots of bandwidth 
> thereby.

I spent 3 mail explaining it as clearly as I could. So you're welcome
for the review and the reminder of why it's impossible to have a normal
conversation with you.

> Yes, the q = bdev_get_queue(bio->bi_bdev) needs to be repeated inside 
> the submission loop, that was a flaw, thanks for the catch.

Precisely. So forgive me for thinking this patch hasn't seen very varied
testing, that's 2 errors (one simple, one bad - broken was NOT a gross
exageration, thanks) in very few lines.

> 
> Regards,
> 
> Daniel

> --- 2.6.24-rc3-mm.clean/block/ll_rw_blk.c	2007-12-04 14:45:25.000000000 -0800
> +++ 2.6.24-rc3-mm/block/ll_rw_blk.c	2007-12-10 04:49:56.000000000 -0800
> @@ -3210,9 +3210,9 @@ static inline int bio_check_eod(struct b
>   */
>  static inline void __generic_make_request(struct bio *bio)
>  {
> -	struct request_queue *q;
> +	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
>  	sector_t old_sector;
> -	int ret, nr_sectors = bio_sectors(bio);
> +	int nr_sectors = bio_sectors(bio);
>  	dev_t old_dev;
>  	int err = -EIO;
>  
> @@ -3221,6 +3221,13 @@ static inline void __generic_make_reques
>  	if (bio_check_eod(bio, nr_sectors))
>  		goto end_io;
>  
> +	if (q && q->metric && !bio->bi_queue) {
> +		int need = bio->bi_throttle = q->metric(bio);
> +		bio->bi_queue = q;
> +		/* FIXME: potential race if atomic_sub is called in the middle of condition check */
> +		wait_event(q->throttle_wait, atomic_read(&q->available) >= need);
> +		atomic_sub(need, &q->available);
> +	}
>  	/*
>  	 * Resolve the mapping until finished. (drivers are
>  	 * still free to implement/resolve their own stacking
> @@ -3231,10 +3238,9 @@ static inline void __generic_make_reques
>  	 */
>  	old_sector = -1;
>  	old_dev = 0;
> -	do {
> +	while (1) {
>  		char b[BDEVNAME_SIZE];
>  
> -		q = bdev_get_queue(bio->bi_bdev);
>  		if (!q) {
>  			printk(KERN_ERR
>  			       "generic_make_request: Trying to access "
> @@ -3282,8 +3288,10 @@ end_io:
>  			goto end_io;
>  		}
>  
> -		ret = q->make_request_fn(q, bio);
> -	} while (ret);
> +		if (!q->make_request_fn(q, bio))
> +			return;
> +		q = bdev_get_queue(bio->bi_bdev);
> +	}

break here please.

> --- 2.6.24-rc3-mm.clean/include/linux/bio.h	2007-12-04 14:39:31.000000000 -0800
> +++ 2.6.24-rc3-mm/include/linux/bio.h	2007-12-04 23:31:41.000000000 -0800
> @@ -111,6 +111,9 @@ struct bio {
>  	bio_end_io_t		*bi_end_io;
>  	atomic_t		bi_cnt;		/* pin count */
>  
> +	struct request_queue	*bi_queue;	/* for throttling */
> +	unsigned		bi_throttle;	/* throttle metric */
> +

I still wish there was a way around this, you are bloating the bio by
about 15% (yeah I know you rambled on about this, but still). Better
placement would help, so there's still low hanging fruit available.

-- 
Jens Axboe


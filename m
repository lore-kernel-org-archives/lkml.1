Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbXLJKvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbXLJKvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 05:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXLJKu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 05:50:56 -0500
Received: from brick.kernel.dk ([87.55.233.238]:14259 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbXLJKuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 05:50:55 -0500
Date: Mon, 10 Dec 2007 11:47:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Message-ID: <20071210104749.GC5008@kernel.dk>
References: <200712051603.02183.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712051603.02183.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05 2007, Daniel Phillips wrote:
> --- 2.6.24-rc3-mm.clean/block/ll_rw_blk.c	2007-12-04 14:45:25.000000000 -0800
> +++ 2.6.24-rc3-mm/block/ll_rw_blk.c	2007-12-04 14:01:18.000000000 -0800
> @@ -3210,7 +3210,7 @@ static inline int bio_check_eod(struct b
>   */
>  static inline void __generic_make_request(struct bio *bio)
>  {
> -	struct request_queue *q;
> +	request_queue_t *q = bdev_get_queue(bio->bi_bdev);
>  	sector_t old_sector;
>  	int ret, nr_sectors = bio_sectors(bio);
>  	dev_t old_dev;
> @@ -3221,6 +3221,13 @@ static inline void __generic_make_reques
>  	if (bio_check_eod(bio, nr_sectors))
>  		goto end_io;
>  
> +	if (q && q->metric && !bio->bi_queue) {
> +		int need = bio->bi_throttle = q->metric(bio);
> +		bio->bi_queue = q;
> +		/* FIXME: potential race if atomic_sub is called in the middle of condition check */
> +		wait_event_interruptible(q->throttle_wait, atomic_read(&q->available) >= need);
> +		atomic_sub(need, &q->available);
> +	}
>  	/*
>  	 * Resolve the mapping until finished. (drivers are
>  	 * still free to implement/resolve their own stacking
> @@ -3234,7 +3241,6 @@ static inline void __generic_make_reques
>  	do {
>  		char b[BDEVNAME_SIZE];
>  
> -		q = bdev_get_queue(bio->bi_bdev);
>  		if (!q) {
>  			printk(KERN_ERR
>  			       "generic_make_request: Trying to access "

Ehm, this patch is so broken it's not even funny - did you even compile?
You would have noticed the warning on request_queue_t, surely. The big
problem is the last hunk here though, how would that work on stacked
devices? Clue: ->bi_bdev is not const, it can change after a call to
->make_request_fn().

-- 
Jens Axboe


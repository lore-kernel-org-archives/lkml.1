Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591Ab0AKQ3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab0AKQ3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 11:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635Ab0AKQ3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 11:29:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab0AKQ3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 11:29:41 -0500
Date: Mon, 11 Jan 2010 11:29:33 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] cfq-iosched: rework seeky detection
Message-ID: <20100111162933.GA22899@redhat.com>
References: <1263052757-23436-1-git-send-email-czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263052757-23436-1-git-send-email-czoccolo@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 04:59:17PM +0100, Corrado Zoccolo wrote:
> Current seeky detection is based on average seek lenght.
> This is suboptimal, since the average will not distinguish between:
> * a process doing medium sized seeks
> * a process doing some sequential requests interleaved with larger seeks
> and even a medium seek can take lot of time, if the requested sector
> happens to be behind the disk head in the rotation (50% probability).
> 
> Therefore, we change the seeky queue detection to work as follows:
> * each request can be classified as sequential if it is very close to
>   the current head position, i.e. it is likely in the disk cache (disks
>   usually read more data than requested, and put it in cache for
>   subsequent reads). Otherwise, the request is classified as seeky.
> * an history window of the last 32 requests is kept, storing the
>   classification result.
> * A queue is marked as seeky if more than 1/8 of the last 32 requests
>   were seeky.
> 

Because we are not relying on long term average and looking at only last
32 requests, looks like we will be switching between seeky to non seeky
much more aggressively.

> This patch fixes a regression reported by Yanmin, on mmap 64k random
> reads.

We never changed the seek logic recently. So if it is a regression it must
have been introduced by some other change and we should look and fix that
too.

That's a different thing that seeky queue detection logic change also gave
performance improvement in this specific case.

IIUC, you are saying that doing bigger block size IO on mmapped files, has
few 4K requests one after the other and then a big seek. So in such cases
you would rather mark the cfqq as sync-idle and idle on the queue so that
we can server 16 (64K/4) requests soon and then incur a large seek time.

So these requests strictly come one after the other and request merging takes
place?

> 
> Reported-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> ---
>  block/cfq-iosched.c |   54 +++++++++++++-------------------------------------
>  1 files changed, 14 insertions(+), 40 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index c6d5678..4e203c4 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -133,9 +133,7 @@ struct cfq_queue {
>  	unsigned short ioprio, org_ioprio;
>  	unsigned short ioprio_class, org_ioprio_class;
>  
> -	unsigned int seek_samples;
> -	u64 seek_total;
> -	sector_t seek_mean;
> +	u32 seek_history;
>  	sector_t last_request_pos;
>  	unsigned long seeky_start;
>  
> @@ -1658,22 +1656,13 @@ static inline sector_t cfq_dist_from_last(struct cfq_data *cfqd,
>  		return cfqd->last_position - blk_rq_pos(rq);
>  }
>  
> -#define CFQQ_SEEK_THR		8 * 1024
> -#define CFQQ_SEEKY(cfqq)	((cfqq)->seek_mean > CFQQ_SEEK_THR)
> +#define CFQQ_SEEK_THR		(sector_t)(8 * 100)

What's the rational behind changing CFQQ_SEEK_THR from 8*1024 to 8*100?

Vivek

> +#define CFQQ_SEEKY(cfqq)	(hweight32(cfqq->seek_history) > 32/8)
>  
>  static inline int cfq_rq_close(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  			       struct request *rq, bool for_preempt)
>  {
> -	sector_t sdist = cfqq->seek_mean;
> -
> -	if (!sample_valid(cfqq->seek_samples))
> -		sdist = CFQQ_SEEK_THR;
> -
> -	/* if seek_mean is big, using it as close criteria is meaningless */
> -	if (sdist > CFQQ_SEEK_THR && !for_preempt)
> -		sdist = CFQQ_SEEK_THR;
> -
> -	return cfq_dist_from_last(cfqd, rq) <= sdist;
> +	return cfq_dist_from_last(cfqd, rq) <= CFQQ_SEEK_THR;
>  }
>  
>  static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
> @@ -2971,30 +2960,16 @@ static void
>  cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  		       struct request *rq)
>  {
> -	sector_t sdist;
> -	u64 total;
> -
> -	if (!cfqq->last_request_pos)
> -		sdist = 0;
> -	else if (cfqq->last_request_pos < blk_rq_pos(rq))
> -		sdist = blk_rq_pos(rq) - cfqq->last_request_pos;
> -	else
> -		sdist = cfqq->last_request_pos - blk_rq_pos(rq);
> -
> -	/*
> -	 * Don't allow the seek distance to get too large from the
> -	 * odd fragment, pagein, etc
> -	 */
> -	if (cfqq->seek_samples <= 60) /* second&third seek */
> -		sdist = min(sdist, (cfqq->seek_mean * 4) + 2*1024*1024);
> -	else
> -		sdist = min(sdist, (cfqq->seek_mean * 4) + 2*1024*64);
> +	sector_t sdist = 0;
> +	if (cfqq->last_request_pos) {
> +		if (cfqq->last_request_pos < blk_rq_pos(rq))
> +			sdist = blk_rq_pos(rq) - cfqq->last_request_pos;
> +		else
> +			sdist = cfqq->last_request_pos - blk_rq_pos(rq);
> +	}
>  
> -	cfqq->seek_samples = (7*cfqq->seek_samples + 256) / 8;
> -	cfqq->seek_total = (7*cfqq->seek_total + (u64)256*sdist) / 8;
> -	total = cfqq->seek_total + (cfqq->seek_samples/2);
> -	do_div(total, cfqq->seek_samples);
> -	cfqq->seek_mean = (sector_t)total;
> +	cfqq->seek_history <<= 1;
> +	cfqq->seek_history |= (sdist > CFQQ_SEEK_THR);
>  
>  	/*
>  	 * If this cfqq is shared between multiple processes, check to
> @@ -3032,8 +3007,7 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  		cfq_mark_cfqq_deep(cfqq);
>  
>  	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
> -	    (!cfq_cfqq_deep(cfqq) && sample_valid(cfqq->seek_samples)
> -	     && CFQQ_SEEKY(cfqq)))
> +	    (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
>  		enable_idle = 0;
>  	else if (sample_valid(cic->ttime_samples)) {
>  		if (cic->ttime_mean > cfqd->cfq_slice_idle)
> -- 
> 1.6.4.4

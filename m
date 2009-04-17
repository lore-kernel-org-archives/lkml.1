Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbZDQLiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbZDQLiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 07:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbZDQLh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 07:37:58 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56536 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757436AbZDQLh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 07:37:57 -0400
Date: Fri, 17 Apr 2009 13:37:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH v2] block: simplify I/O stat accounting
Message-ID: <20090417113756.GU4593@kernel.dk>
References: <49E72F19.1030400@redhat.com> <49E8662D.5010607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E8662D.5010607@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17 2009, Jerome Marchand wrote:
> 
> This simplifies I/O stat accounting switching code and separates it
> completely from I/O scheduler switch code.
> 
> Requests are accounted according to the state of their request queue
> at the time of the request allocation. There is no need anymore to
> flush the request queue when switching I/O accounting state.
> 
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  block/blk-core.c       |   10 ++++++----
>  block/blk-merge.c      |    6 +++---
>  block/blk-sysfs.c      |    4 ----
>  block/blk.h            |    7 +------
>  include/linux/blkdev.h |    3 +++
>  5 files changed, 13 insertions(+), 17 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 07ab754..42a646f 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -643,7 +643,7 @@ static inline void blk_free_request(struct request_queue *q, struct request *rq)
>  }
>  
>  static struct request *
> -blk_alloc_request(struct request_queue *q, int rw, int priv, gfp_t gfp_mask)
> +blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
>  {
>  	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
>  
> @@ -652,7 +652,7 @@ blk_alloc_request(struct request_queue *q, int rw, int priv, gfp_t gfp_mask)
>  
>  	blk_rq_init(q, rq);
>  
> -	rq->cmd_flags = rw | REQ_ALLOCED;
> +	rq->cmd_flags = flags | REQ_ALLOCED;
>  
>  	if (priv) {
>  		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
> @@ -744,7 +744,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
>  	struct request_list *rl = &q->rq;
>  	struct io_context *ioc = NULL;
>  	const bool is_sync = rw_is_sync(rw_flags) != 0;
> -	int may_queue, priv;
> +	int may_queue, priv, iostat = 0;
>  
>  	may_queue = elv_may_queue(q, rw_flags);
>  	if (may_queue == ELV_MQUEUE_NO)
> @@ -792,9 +792,11 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
>  	if (priv)
>  		rl->elvpriv++;
>  
> +	if (blk_queue_io_stat(q))
> +		iostat = REQ_IO_STAT;

On second thought, not sure why you add 'iostat' for this. It would be
OK to just do

        if (blk_queue_io_stat(q))
                rw_flags |= REQ_IO_STAT;

since it's just used for the allocation call, and the trace call (which
does & 1 on it anyway).

>  
> -	rq = blk_alloc_request(q, rw_flags, priv, gfp_mask);
> +	rq = blk_alloc_request(q, rw_flags | iostat, priv, gfp_mask);
>  	if (unlikely(!rq)) {
>  		/*
>  		 * Allocation failed presumably due to memory. Undo anything
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 63760ca..6a05270 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -338,9 +338,9 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
>  	return 1;
>  }
>  
> -static void blk_account_io_merge(struct request *req)
> +static void blk_account_io_merge(struct request *req, struct request *next)
>  {
> -	if (blk_do_io_stat(req)) {
> +	if (req->rq_disk && blk_rq_io_stat(next)) {

This at least needs a comment, it's not at all directly clear why we are
checking 'next' for io stat and ->rq_disk in 'req'. Since it's just
called from that one spot, it would be cleaner to do:

        /*
         * 'next' is going away, so update stats accordingly
         */
        if (blk_rq_io_stat(next))
                blk_account_io_merge(req->rq_disk, req->sector);

and have blk_account_io_merge() be more ala:

static void blk_account_io_merge(struct request *req)
{
        struct hd_struct *part;
        int cpu;

        cpu = part_stat_lock();
        part = disk_map_sector_rcu(disk, sector);
        ...
}

>  		struct hd_struct *part;
>  		int cpu;
>  
> @@ -402,7 +402,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
>  
>  	elv_merge_requests(q, req, next);
>  
> -	blk_account_io_merge(req);
> +	blk_account_io_merge(req, next);
>  
>  	req->ioprio = ioprio_best(req->ioprio, next->ioprio);
>  	if (blk_rq_cpu_valid(next))
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index cac4e9f..3ff9bba 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -209,14 +209,10 @@ static ssize_t queue_iostats_store(struct request_queue *q, const char *page,
>  	ssize_t ret = queue_var_store(&stats, page, count);
>  
>  	spin_lock_irq(q->queue_lock);
> -	elv_quiesce_start(q);
> -
>  	if (stats)
>  		queue_flag_set(QUEUE_FLAG_IO_STAT, q);
>  	else
>  		queue_flag_clear(QUEUE_FLAG_IO_STAT, q);
> -
> -	elv_quiesce_end(q);
>  	spin_unlock_irq(q->queue_lock);
>  
>  	return ret;
> diff --git a/block/blk.h b/block/blk.h
> index 5dfc412..79c85f7 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -114,12 +114,7 @@ static inline int blk_cpu_to_group(int cpu)
>  
>  static inline int blk_do_io_stat(struct request *rq)
>  {
> -	struct gendisk *disk = rq->rq_disk;
> -
> -	if (!disk || !disk->queue)
> -		return 0;
> -
> -	return blk_queue_io_stat(disk->queue) && (rq->cmd_flags & REQ_ELVPRIV);
> +	return rq->rq_disk && blk_rq_io_stat(rq);
>  }
>  
>  #endif
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index ba54c83..2755d5c 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -118,6 +118,7 @@ enum rq_flag_bits {
>  	__REQ_COPY_USER,	/* contains copies of user pages */
>  	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
>  	__REQ_NOIDLE,		/* Don't anticipate more IO after this one */
> +	__REQ_IO_STAT,		/* account I/O stat */
>  	__REQ_NR_BITS,		/* stops here */
>  };
>  
> @@ -145,6 +146,7 @@ enum rq_flag_bits {
>  #define REQ_COPY_USER	(1 << __REQ_COPY_USER)
>  #define REQ_INTEGRITY	(1 << __REQ_INTEGRITY)
>  #define REQ_NOIDLE	(1 << __REQ_NOIDLE)
> +#define REQ_IO_STAT	(1 << __REQ_IO_STAT)
>  
>  #define BLK_MAX_CDB	16
>  
> @@ -598,6 +600,7 @@ enum {
>  				 blk_failfast_transport(rq) ||	\
>  				 blk_failfast_driver(rq))
>  #define blk_rq_started(rq)	((rq)->cmd_flags & REQ_STARTED)
> +#define blk_rq_io_stat(rq)	((rq)->cmd_flags & REQ_IO_STAT)
>  
>  #define blk_account_rq(rq)	(blk_rq_started(rq) && (blk_fs_request(rq) || blk_discard_rq(rq))) 
>  

-- 
Jens Axboe


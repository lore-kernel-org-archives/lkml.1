Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZEHN7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZEHN7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 09:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZEHN7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 09:59:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46047 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbZEHN7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 09:59:03 -0400
Date: Fri, 8 May 2009 09:57:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH] io-controller: Add io group reference handling for
	request
Message-ID: <20090508135724.GE7293@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <4A03FF3C.4020506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A03FF3C.4020506@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 05:45:32PM +0800, Gui Jianfeng wrote:
> Hi Vivek,
> 
> This patch adds io group reference handling when allocating
> and removing a request.
> 

Hi Gui,

Thanks for the patch. We were thinking that requests can take a reference
on io queues and io queues can take a reference on io groups. That should
make sure that io groups don't go away as long as active requests are
present.

But there seems to be a small window while allocating the new request
where request gets allocated from a group first and then later it is
mapped to that group and queue is created. IOW, in get_request_wait(), 
we allocate a request from a particular group and set rq->rl, then
drop the queue lock and later call elv_set_request() which again maps
the request to the group saves rq->iog and creates new queue. This window
is troublesome because request can be mapped to a particular group at the
time of allocation and during set_request() it can go to a different
group as queue lock was dropped and group might have disappeared.

In this case probably it might make sense that request also takes a
reference on groups. At the same time it looks too much that request takes
a reference on queue as well as group object. Ideas are welcome on how
to handle it...

Thanks
Vivek
 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  elevator-fq.c |   15 ++++++++++++++-
>  elevator-fq.h |    5 +++++
>  elevator.c    |    2 ++
>  3 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 9500619..e6d6712 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -1968,11 +1968,24 @@ void elv_fq_set_request_io_group(struct request_queue *q, struct request *rq,
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  	BUG_ON(!iog);
>  
> -	/* Store iog in rq. TODO: take care of referencing */
> +	elv_get_iog(iog);
>  	rq->iog = iog;
>  }
>  
>  /*
> + * This request has been serviced. Clean up iog info and drop the reference.
> + */
> +void elv_fq_unset_request_io_group(struct request *rq)
> +{
> +	struct io_group *iog = rq->iog;
> +
> +	if (iog) {
> +		rq->iog = NULL;
> +		elv_put_iog(iog);
> +	}
> +}
> +
> +/*
>   * Find/Create the io queue the rq should go in. This is an optimization
>   * for the io schedulers (noop, deadline and AS) which maintain only single
>   * io queue per cgroup. In this case common layer can just maintain a
> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
> index db3a347..96a28e9 100644
> --- a/block/elevator-fq.h
> +++ b/block/elevator-fq.h
> @@ -512,6 +512,7 @@ static inline struct io_group *ioq_to_io_group(struct io_queue *ioq)
>  extern int io_group_allow_merge(struct request *rq, struct bio *bio);
>  extern void elv_fq_set_request_io_group(struct request_queue *q,
>  					struct request *rq, struct bio *bio);
> +extern void elv_fq_unset_request_io_group(struct request *rq);
>  static inline bfq_weight_t iog_weight(struct io_group *iog)
>  {
>  	return iog->entity.weight;
> @@ -571,6 +572,10 @@ static inline void elv_fq_set_request_io_group(struct request_queue *q,
>  {
>  }
>  
> +static inline void elv_fq_unset_request_io_group(struct request *rq)
> +{
> +}
> +
>  static inline bfq_weight_t iog_weight(struct io_group *iog)
>  {
>  	/* Just root group is present and weight is immaterial. */
> diff --git a/block/elevator.c b/block/elevator.c
> index 44c9fad..d75eec7 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -992,6 +992,8 @@ void elv_put_request(struct request_queue *q, struct request *rq)
>  {
>  	struct elevator_queue *e = q->elevator;
>  
> +	elv_fq_unset_request_io_group(rq);
> +
>  	/*
>  	 * Optimization for noop, deadline and AS which maintain only single
>  	 * ioq per io group
> 

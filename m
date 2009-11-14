Return-Path: <linux-kernel-owner+w=401wt.eu-S1751405AbZKNTJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbZKNTJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 14:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbZKNTJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 14:09:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbZKNTJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 14:09:47 -0500
Date: Sat, 14 Nov 2009 14:09:48 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq-iosched: fix ncq detection code
Message-ID: <20091114190948.GA31708@redhat.com>
References: <200911141433.40440.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911141433.40440.czoccolo@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 14, 2009 at 02:33:40PM +0100, Corrado Zoccolo wrote:
> CFQ's detection of queueing devices assumes a non-queuing device and detects
> if the queue depth reaches a certain threshold.

Hi Corrado,

In cfq_init_queue(), we init hw_tag = 1. So I think we start with the
assumption that device supports NCQ.

>  Under some workloads (e.g.
> synchronous reads), CFQ effectively forces a unit queue depth, thus defeating
> the detection logic.  This leads to poor performance on queuing hardware,
> since the idle window remains enabled.

Is it always the case that NCQ hardware performs better if we don't idle.
I got a rotational disk which supports NCQ but if we don't idle, than it
becomes seek bound and throughput drops.

On SSD also, seeks are cheap but not free. So if workload is less, then
we might prefer to idle and I think that's the purpose of this dynamic
hw_tag thing. If non-idling kind of workload is sufficient, then disable
idling otherwise in case of sync workloads, continue to idle.

In fact, whether device supports NCQ or not, isn't this information
statically available? I do a cat on "/sys/block/<sdd>/device/queue_depth"
and on non queuing hardware it has been set to 1 and on queuing hardware
it has been set to 31 by default after system boot. So I am assuming we
statically have the information about device queuing capability? At least
for the locally connected devices.

> 
> Given this premise, switching to hw_tag = 0 after we have proved at
> least once that the device is NCQ capable is not a good choice.

If it is proven that NCQ always means that idling is not good. Not true
for atleast locally connected media. But is probably true many a times
for SSD and fast storage arrays.

Thanks
Vivek

> 
> The new detection code starts in an indeterminate state, in which CFQ behaves
> as if hw_tag = 1, and then, if for a long observation period we never saw
> large depth, we switch to hw_tag = 0, otherwise we stick to hw_tag = 1,
> without reconsidering it again.
> 
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> ---
>  block/cfq-iosched.c |   24 +++++++++++++++---------
>  1 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 1bcbd8c..6925ab9 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -191,8 +191,14 @@ struct cfq_data {
>  	 */
>  	int rq_queued;
>  	int hw_tag;
> -	int hw_tag_samples;
> -	int rq_in_driver_peak;
> +	/*
> +	 * hw_tag can be
> +	 * -1 => indeterminate, (cfq will behave as if NCQ is present, to allow better detection)
> +	 *  1 => NCQ is present (hw_tag_est_depth is the estimated max depth)
> +	 *  0 => no NCQ
> +	 */
> +	int hw_tag_est_depth;
> +	unsigned int hw_tag_samples;
>  
>  	/*
>  	 * idle window management
> @@ -2527,8 +2533,11 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
>  {
>  	struct cfq_queue *cfqq = cfqd->active_queue;
>  
> -	if (rq_in_driver(cfqd) > cfqd->rq_in_driver_peak)
> -		cfqd->rq_in_driver_peak = rq_in_driver(cfqd);
> +	if (rq_in_driver(cfqd) > cfqd->hw_tag_est_depth)
> +		cfqd->hw_tag_est_depth = rq_in_driver(cfqd);
> +
> +	if (cfqd->hw_tag == 1)
> +		return;
>  
>  	if (cfqd->rq_queued <= CFQ_HW_QUEUE_MIN &&
>  	    rq_in_driver(cfqd) <= CFQ_HW_QUEUE_MIN)
> @@ -2547,13 +2556,10 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
>  	if (cfqd->hw_tag_samples++ < 50)
>  		return;
>  
> -	if (cfqd->rq_in_driver_peak >= CFQ_HW_QUEUE_MIN)
> +	if (cfqd->hw_tag_est_depth >= CFQ_HW_QUEUE_MIN)
>  		cfqd->hw_tag = 1;
>  	else
>  		cfqd->hw_tag = 0;
> -
> -	cfqd->hw_tag_samples = 0;
> -	cfqd->rq_in_driver_peak = 0;
>  }
>  
>  static void cfq_completed_request(struct request_queue *q, struct request *rq)
> @@ -2960,7 +2966,7 @@ static void *cfq_init_queue(struct request_queue *q)
>  	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
>  	cfqd->cfq_slice_idle = cfq_slice_idle;
>  	cfqd->cfq_latency = 1;
> -	cfqd->hw_tag = 1;
> +	cfqd->hw_tag = -1;
>  	cfqd->last_end_sync_rq = jiffies;
>  	return cfqd;
>  }
> -- 
> 1.6.2.5
> 

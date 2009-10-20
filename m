Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbZJTAyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbZJTAyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbZJTAyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:54:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55643 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758105AbZJTAyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:54:43 -0400
Date: Tue, 20 Oct 2009 02:54:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 1/5] cfq-iosched: adapt slice to number of
	processes doing I/O
Message-ID: <20091020005446.GB10727@kernel.dk>
References: <200910192221.03805.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910192221.03805.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19 2009, Corrado Zoccolo wrote:
> When the number of processes performing I/O concurrently increases,
> a fixed time slice per process will cause large latencies.
> 
> This patch, if low_latency mode is enabled,  will scale the time slice
> assigned to each process according to a 300ms target latency.
> 
> In order to keep fairness among processes:
> * The number of active processes is computed using a special form of
> running average, that quickly follows sudden increases (to keep latency low),
> and decrease slowly (to have fairness in spite of rapid decreases of this
> value).
> 
> To safeguard sequential bandwidth, we impose a minimum time slice
> (computed using 2*cfq_slice_idle as base, adjusted according to priority
> and async-ness).

Generally, this looks good. Just one minor style nit:

> +static inline unsigned
> +cfq_get_avg_queues(struct cfq_data *cfqd, bool rt) {
> +	unsigned min_q, max_q;
> +	unsigned mult  = cfq_hist_divisor - 1;
> +	unsigned round = cfq_hist_divisor / 2;
> +	unsigned busy  = rt ? cfqd->busy_rt_queues :
> +		(cfqd->busy_queues - cfqd->busy_rt_queues);
> +	min_q = min(cfqd->busy_queues_avg[rt], busy);
> +	max_q = max(cfqd->busy_queues_avg[rt], busy);
> +	cfqd->busy_queues_avg[rt] = (mult * max_q + min_q + round) /
> +		cfq_hist_divisor;
> +	return cfqd->busy_queues_avg[rt];
> +}

A lot of your code suffers from the specific problem of being largely
unreadable. To me, as the maintainer of that code, that is a maintenance
issue. I already asked you to get rid of the ?: constructs for earlier
patches, this series even takes it to the extreme of doing nested ?:
clauses. Don't do it! It's unreadable.

> @@ -2152,10 +2186,9 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
>  	cfq_log_cfqq(cfqd, cfqq, "insert_request");
>  	cfq_init_prio_data(cfqq, RQ_CIC(rq)->ioc);
>  
> -	cfq_add_rq_rb(rq);
> -
>  	rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
>  	list_add_tail(&rq->queuelist, &cfqq->fifo);
> +	cfq_add_rq_rb(rq);
>  
>  	cfq_rq_enqueued(cfqd, cfqq, rq);

If the fifo vs service tree ordering is now important, you should
comment on why.

-- 
Jens Axboe


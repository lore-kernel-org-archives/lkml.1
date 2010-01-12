Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000Ab0ALPs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0ALPs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 10:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766Ab0ALPs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 10:48:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab0ALPs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 10:48:26 -0500
Date: Tue, 12 Jan 2010 10:48:20 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [RFC]cfq-iosched: quantum check tweak
Message-ID: <20100112154820.GB3065@redhat.com>
References: <20091228033554.GB15242@sli10-desk.sh.intel.com> <4e5e476b0912280102t2278d7a5ld3e8784f52f2be31@mail.gmail.com> <1262829893.4984.13.camel@sli10-desk.sh.intel.com> <4e5e476b1001071344i4f702496y22f33bc2d4bc834d@mail.gmail.com> <20100108171535.GC22219@redhat.com> <4e5e476b1001081235wc2784c1s87c0c70662b5e267@mail.gmail.com> <20100108205948.GH22219@redhat.com> <20100111023409.GE22362@sli10-desk.sh.intel.com> <20100111170339.GC22899@redhat.com> <20100112030756.GB22606@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112030756.GB22606@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 11:07:56AM +0800, Shaohua Li wrote:

[..]
> > > > > > I think this patch breaks the meaning of cfq_quantum? Now we can allow
> > > > > > dispatch of more requests from the same queue. I had kind of liked the
> > > > > > idea of respecting cfq_quantum. Especially it can help in testing. With
> > > > > > this patch cfq_quantum will more or less loose its meaning.
> > > > > cfq_quantum will still be enforced at the end of the slice, so its
> > > > > meaning of how many requests can be still pending when you finish your
> > > > > slice is preserved.
> > > > 
> > > > Not always and it will depend how accurate your approximation of service
> > > > time is. If per request completion time is more than approximation (in
> > > > this case slice_idle), than you will end up with more requests in dispatch
> > > > queue from one cfqq at the time of slice expiry.
> > > we use slice_idle for a long time and no complain. So assume the approximation
> > > of service time is good.
> > 
> > slice_idle is a variable and user can easily change it to 1ms and even 0.
> > In that case you will be theoritically be ready to dispatch 100/1 requests
> > from the cfqq?
> User changing it should know what he does. A less-experienced user can mess a lot
> of things, which we don't care. 
> 

The point is that there is no obivious co-relation between slice_idle and
cfq_quantum. Even an experienced user would not expect that changing
slice_idle silently will enable dispatching more requests from each cfqq.

> > > > > One can argue, instead, that this reduces a bit the effectiveness of
> > > > > preemption on ncq disks.
> > > > > However, I don't think preemption is the solution for low latency,
> > > > > while cfq_quantum reduction is.
> > > > > With this change in place, we could change the default cfq_quantum to
> > > > > a smaller number (ideally 1), to have lowest number of leftovers when
> > > > > the slice finishes, while still driving deep queues at the beginning
> > > > > of the slice.
> > > > 
> > > > I think using cfq_quantum as hard limit might be a better idea as it gives
> > > > more predictable control. Instead of treating it as soft limit and trying
> > > > to meet it at the end of slice expiry based on our approximation of
> > > > predicted completion time.
> > > Current patch has such hard limit too (100ms/8m = 12 for sync io and 40ms/8
> > >  = 5 for async io).
> > 
> > This is software logic driven and not cfq_quantum driven. We can always
> > keep on changing how to approximate service time completions. So a user
> > first needs to read the code, derive internal limits and then do testing?
> > 
> > I think than tunable looses its significance. That's why I am advocating
> > of treating cfq_quantum as hard limit and derive an internal soft limit
> > based on certain % of hard limit and use that as default max queue depth
> > for cfqq.
> > 
> > In this case user knows no matter what, you are not dispatching more than
> > cfq_quantum requests from a queue at a time.
> ok, then the question is which value should cfq_quantum have. I have a test with
> below patch. Its performance still is good. With hard limit 8, speed is 100m/s.
> without hard limit, speed is 102m/s.
> 
> 
> Currently a queue can only dispatch up to 4 requests if there are other queues.
> This isn't optimal, device can handle more requests, for example, AHCI can
> handle 31 requests. I can understand the limit is for fairness, but we could
> do a tweak: if the queue still has a lot of slice left, sounds we could
> ignore the limit.
> Test shows this boost my workload (two thread randread of a SSD) from 78m/s
> to 100m/s.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  block/cfq-iosched.c |   24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/block/cfq-iosched.c
> ===================================================================
> --- linux-2.6.orig/block/cfq-iosched.c
> +++ linux-2.6/block/cfq-iosched.c
> @@ -19,7 +19,7 @@
>   * tunables
>   */
>  /* max queue in one round of service */
> -static const int cfq_quantum = 4;
> +static const int cfq_quantum = 8;
>  static const int cfq_fifo_expire[2] = { HZ / 4, HZ / 8 };
>  /* maximum backwards seek, in KiB */
>  static const int cfq_back_max = 16 * 1024;
> @@ -32,6 +32,8 @@ static int cfq_slice_idle = HZ / 125;
>  static const int cfq_target_latency = HZ * 3/10; /* 300 ms */
>  static const int cfq_hist_divisor = 4;
>  
> +#define CFQ_SOFT_QUANTUM (4)
> +
>  /*
>   * offset from end of service tree
>   */
> @@ -2242,6 +2244,19 @@ static int cfq_forced_dispatch(struct cf
>  	return dispatched;
>  }
>  
> +static inline bool cfq_slice_used_soon(struct cfq_data *cfqd,
> +	struct cfq_queue *cfqq)
> +{
> +	/* the queue hasn't finished any request, can't estimate */
> +	if (cfq_cfqq_slice_new(cfqq) || cfqq->dispatched >= cfqd->cfq_quantum)
> +		return 1;
> +	if (time_after(jiffies + cfqd->cfq_slice_idle * cfqq->dispatched,
> +		cfqq->slice_end))
> +		return 1;
> +
> +	return 0;
> +}
> +
>  static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
>  	unsigned int max_dispatch;
> @@ -2258,7 +2273,10 @@ static bool cfq_may_dispatch(struct cfq_
>  	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
>  		return false;
>  
> -	max_dispatch = cfqd->cfq_quantum;
> +	max_dispatch = cfqd->cfq_quantum / 2;
> +	if (max_dispatch < CFQ_SOFT_QUANTUM)

We don't have to hardcode CFQ_SOFT_QUANTUM or in fact we don't need it. We can
derive the soft limit from hard limit (cfq_quantum). Say soft limit will be
50% of cfq_quantum value.

> +		max_dispatch = min_t(unsigned int, CFQ_SOFT_QUANTUM,
> +			cfqd->cfq_quantum);
>  	if (cfq_class_idle(cfqq))
>  		max_dispatch = 1;
>  
> @@ -2275,7 +2293,7 @@ static bool cfq_may_dispatch(struct cfq_
>  		/*
>  		 * We have other queues, don't allow more IO from this one
>  		 */
> -		if (cfqd->busy_queues > 1)
> +		if (cfqd->busy_queues > 1 && cfq_slice_used_soon(cfqd, cfqq))
>  			return false;

So I guess here we can write something as follows.

		if (cfqd->busy_queues > 1 && cfq_slice_used_soon(cfqd, cfqq))
			return false;

		if (cfqd->busy_queues == 1)
			max_dispatch = -1;
		else
			/*
			 * Normally we start throttling cfqq when cfq_quantum/2
			 * requests have been dispatched. But we can drive
			 * deeper queue depths at the beginning of slice
			 * subjected to upper limit of cfq_quantum.
			 */
			max_dispatch = cfqd->cfq_quantum;

Thanks
Vivek

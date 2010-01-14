Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802Ab0ANLb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0ANLb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738Ab0ANLb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:31:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab0ANLbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:31:25 -0500
Date: Thu, 14 Jan 2010 06:31:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [RFC]cfq-iosched: quantum check tweak
Message-ID: <20100114113103.GB15559@redhat.com>
References: <20100108171535.GC22219@redhat.com> <4e5e476b1001081235wc2784c1s87c0c70662b5e267@mail.gmail.com> <20100108205948.GH22219@redhat.com> <20100111023409.GE22362@sli10-desk.sh.intel.com> <20100111170339.GC22899@redhat.com> <20100112030756.GB22606@sli10-desk.sh.intel.com> <20100112154820.GB3065@redhat.com> <20100113081735.GD10492@sli10-desk.sh.intel.com> <20100113111807.GC3087@redhat.com> <20100114041624.GA10276@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114041624.GA10276@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 12:16:24PM +0800, Shaohua Li wrote:
> On Wed, Jan 13, 2010 at 07:18:07PM +0800, Vivek Goyal wrote:
> > On Wed, Jan 13, 2010 at 04:17:35PM +0800, Shaohua Li wrote:
> > [..]
> > > > >  static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> > > > >  {
> > > > >  	unsigned int max_dispatch;
> > > > > @@ -2258,7 +2273,10 @@ static bool cfq_may_dispatch(struct cfq_
> > > > >  	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
> > > > >  		return false;
> > > > >  
> > > > > -	max_dispatch = cfqd->cfq_quantum;
> > > > > +	max_dispatch = cfqd->cfq_quantum / 2;
> > > > > +	if (max_dispatch < CFQ_SOFT_QUANTUM)
> > > > 
> > > > We don't have to hardcode CFQ_SOFT_QUANTUM or in fact we don't need it. We can
> > > > derive the soft limit from hard limit (cfq_quantum). Say soft limit will be
> > > > 50% of cfq_quantum value.
> > > I'm hoping this doesn't give user a surprise. Say cfq_quantum sets to 7, then we
> > > start doing throttling from 3 requests. Adding the CFQ_SOFT_QUANTUM gives a compatibility
> > > against old behavior at least. Am I over thinking?
> > >  
> > 
> > I would not worry too much about that. If you are really worried about
> > that, then create one Documentation/block/cfq-iosched.txt and document
> > how cfq_quantum works so that users know that cfq_quantum is upper hard
> > limit and internal soft limit is cfq_quantum/2.
> Good idea. Looks we don't document cfq tunnables, I'll try to do it later.
> 
> Currently a queue can only dispatch up to 4 requests if there are other queues.
> This isn't optimal, device can handle more requests, for example, AHCI can
> handle 31 requests. I can understand the limit is for fairness, but we could
> do a tweak: if the queue still has a lot of slice left, sounds we could
> ignore the limit.

Hi Shaohua,

This looks much better. Though usage of "slice_idle" as measure of service
times, I find little un-intutive. Especially, I do some testing with
slice_idle=0, in that case, we will be allowing dispatch of 8 requests
from each queue even if slice is about to expire.

But I guess that's fine for the time being as upper limit is still
controlld by cfq_quantum.

> Test shows this boost my workload (two thread randread of a SSD) from 78m/s
> to 100m/s.

Are these deep queue random reads (with higher iodepths, using libaio)?

Have you done similar test on some slower NCQ rotational hardware also and
seen the impact on throughput and *max latency* of readers, especially in
the presence of buffered writers.

Thanks
Vivek

> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  block/cfq-iosched.c |   30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
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
> @@ -2215,6 +2215,19 @@ static int cfq_forced_dispatch(struct cf
>  	return dispatched;
>  }
>  
> +static inline bool cfq_slice_used_soon(struct cfq_data *cfqd,
> +	struct cfq_queue *cfqq)
> +{
> +	/* the queue hasn't finished any request, can't estimate */
> +	if (cfq_cfqq_slice_new(cfqq))
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
> @@ -2231,7 +2244,7 @@ static bool cfq_may_dispatch(struct cfq_
>  	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
>  		return false;
>  
> -	max_dispatch = cfqd->cfq_quantum;
> +	max_dispatch = max_t(unsigned int, cfqd->cfq_quantum / 2, 1);
>  	if (cfq_class_idle(cfqq))
>  		max_dispatch = 1;
>  
> @@ -2248,13 +2261,22 @@ static bool cfq_may_dispatch(struct cfq_
>  		/*
>  		 * We have other queues, don't allow more IO from this one
>  		 */
> -		if (cfqd->busy_queues > 1)
> +		if (cfqd->busy_queues > 1 && cfq_slice_used_soon(cfqd, cfqq))
>  			return false;
>  
>  		/*
>  		 * Sole queue user, no limit
>  		 */
> -		max_dispatch = -1;
> +		if (cfqd->busy_queues == 1)
> +			max_dispatch = -1;
> +		else
> +			/*
> +			 * Normally we start throttling cfqq when cfq_quantum/2
> +			 * requests have been dispatched. But we can drive
> +			 * deeper queue depths at the beginning of slice
> +			 * subjected to upper limit of cfq_quantum.
> +			 * */
> +			max_dispatch = cfqd->cfq_quantum;
>  	}
>  
>  	/*

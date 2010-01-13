Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971Ab0AMIRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab0AMIRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509Ab0AMIRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:17:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:34837 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab0AMIRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:17:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,267,1262592000"; 
   d="scan'208";a="483579288"
Date: Wed, 13 Jan 2010 16:17:35 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [RFC]cfq-iosched: quantum check tweak
Message-ID: <20100113081735.GD10492@sli10-desk.sh.intel.com>
References: <4e5e476b0912280102t2278d7a5ld3e8784f52f2be31@mail.gmail.com>
 <1262829893.4984.13.camel@sli10-desk.sh.intel.com>
 <4e5e476b1001071344i4f702496y22f33bc2d4bc834d@mail.gmail.com>
 <20100108171535.GC22219@redhat.com>
 <4e5e476b1001081235wc2784c1s87c0c70662b5e267@mail.gmail.com>
 <20100108205948.GH22219@redhat.com>
 <20100111023409.GE22362@sli10-desk.sh.intel.com>
 <20100111170339.GC22899@redhat.com>
 <20100112030756.GB22606@sli10-desk.sh.intel.com>
 <20100112154820.GB3065@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112154820.GB3065@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 11:48:20PM +0800, Vivek Goyal wrote:
> On Tue, Jan 12, 2010 at 11:07:56AM +0800, Shaohua Li wrote:
> 
> [..]
> > > > > > > I think this patch breaks the meaning of cfq_quantum? Now we can allow
> > > > > > > dispatch of more requests from the same queue. I had kind of liked the
> > > > > > > idea of respecting cfq_quantum. Especially it can help in testing. With
> > > > > > > this patch cfq_quantum will more or less loose its meaning.
> > > > > > cfq_quantum will still be enforced at the end of the slice, so its
> > > > > > meaning of how many requests can be still pending when you finish your
> > > > > > slice is preserved.
> > > > > 
> > > > > Not always and it will depend how accurate your approximation of service
> > > > > time is. If per request completion time is more than approximation (in
> > > > > this case slice_idle), than you will end up with more requests in dispatch
> > > > > queue from one cfqq at the time of slice expiry.
> > > > we use slice_idle for a long time and no complain. So assume the approximation
> > > > of service time is good.
> > > 
> > > slice_idle is a variable and user can easily change it to 1ms and even 0.
> > > In that case you will be theoritically be ready to dispatch 100/1 requests
> > > from the cfqq?
> > User changing it should know what he does. A less-experienced user can mess a lot
> > of things, which we don't care. 
> > 
> 
> The point is that there is no obivious co-relation between slice_idle and
> cfq_quantum. Even an experienced user would not expect that changing
> slice_idle silently will enable dispatching more requests from each cfqq.
Agree slice_idle hasn't relationship with cfq_quantum. Yes, there are more requests
dispatched, but it shouldn't impact user experience. If it does, then the patch fails.
 
> >  1 file changed, 21 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6/block/cfq-iosched.c
> > ===================================================================
> > --- linux-2.6.orig/block/cfq-iosched.c
> > +++ linux-2.6/block/cfq-iosched.c
> > @@ -19,7 +19,7 @@
> >   * tunables
> >   */
> >  /* max queue in one round of service */
> > -static const int cfq_quantum = 4;
> > +static const int cfq_quantum = 8;
> >  static const int cfq_fifo_expire[2] = { HZ / 4, HZ / 8 };
> >  /* maximum backwards seek, in KiB */
> >  static const int cfq_back_max = 16 * 1024;
> > @@ -32,6 +32,8 @@ static int cfq_slice_idle = HZ / 125;
> >  static const int cfq_target_latency = HZ * 3/10; /* 300 ms */
> >  static const int cfq_hist_divisor = 4;
> >  
> > +#define CFQ_SOFT_QUANTUM (4)
> > +
> >  /*
> >   * offset from end of service tree
> >   */
> > @@ -2242,6 +2244,19 @@ static int cfq_forced_dispatch(struct cf
> >  	return dispatched;
> >  }
> >  
> > +static inline bool cfq_slice_used_soon(struct cfq_data *cfqd,
> > +	struct cfq_queue *cfqq)
> > +{
> > +	/* the queue hasn't finished any request, can't estimate */
> > +	if (cfq_cfqq_slice_new(cfqq) || cfqq->dispatched >= cfqd->cfq_quantum)
> > +		return 1;
> > +	if (time_after(jiffies + cfqd->cfq_slice_idle * cfqq->dispatched,
> > +		cfqq->slice_end))
> > +		return 1;
> > +
> > +	return 0;
> > +}
> > +
> >  static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> >  {
> >  	unsigned int max_dispatch;
> > @@ -2258,7 +2273,10 @@ static bool cfq_may_dispatch(struct cfq_
> >  	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
> >  		return false;
> >  
> > -	max_dispatch = cfqd->cfq_quantum;
> > +	max_dispatch = cfqd->cfq_quantum / 2;
> > +	if (max_dispatch < CFQ_SOFT_QUANTUM)
> 
> We don't have to hardcode CFQ_SOFT_QUANTUM or in fact we don't need it. We can
> derive the soft limit from hard limit (cfq_quantum). Say soft limit will be
> 50% of cfq_quantum value.
I'm hoping this doesn't give user a surprise. Say cfq_quantum sets to 7, then we
start doing throttling from 3 requests. Adding the CFQ_SOFT_QUANTUM gives a compatibility
against old behavior at least. Am I over thinking?
 
> > +		max_dispatch = min_t(unsigned int, CFQ_SOFT_QUANTUM,
> > +			cfqd->cfq_quantum);
> >  	if (cfq_class_idle(cfqq))
> >  		max_dispatch = 1;
> >  
> > @@ -2275,7 +2293,7 @@ static bool cfq_may_dispatch(struct cfq_
> >  		/*
> >  		 * We have other queues, don't allow more IO from this one
> >  		 */
> > -		if (cfqd->busy_queues > 1)
> > +		if (cfqd->busy_queues > 1 && cfq_slice_used_soon(cfqd, cfqq))
> >  			return false;
> 
> So I guess here we can write something as follows.
> 
> 		if (cfqd->busy_queues > 1 && cfq_slice_used_soon(cfqd, cfqq))
> 			return false;
> 
> 		if (cfqd->busy_queues == 1)
> 			max_dispatch = -1;
> 		else
> 			/*
> 			 * Normally we start throttling cfqq when cfq_quantum/2
> 			 * requests have been dispatched. But we can drive
> 			 * deeper queue depths at the beginning of slice
> 			 * subjected to upper limit of cfq_quantum.
> 			 */
> 			max_dispatch = cfqd->cfq_quantum;
ok.

Thanks,
Shaohua

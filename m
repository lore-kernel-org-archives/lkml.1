Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723Ab0ANNtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab0ANNtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 08:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756704Ab0ANNtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 08:49:05 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51530 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab0ANNtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 08:49:03 -0500
Date: Thu, 14 Jan 2010 14:49:02 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Corrado Zoccolo <czoccolo@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [RFC]cfq-iosched: quantum check tweak
Message-ID: <20100114134902.GR13771@kernel.dk>
References: <4e5e476b1001081235wc2784c1s87c0c70662b5e267@mail.gmail.com> <20100108205948.GH22219@redhat.com> <20100111023409.GE22362@sli10-desk.sh.intel.com> <20100111170339.GC22899@redhat.com> <20100112030756.GB22606@sli10-desk.sh.intel.com> <20100112154820.GB3065@redhat.com> <20100113081735.GD10492@sli10-desk.sh.intel.com> <20100113111807.GC3087@redhat.com> <20100114041624.GA10276@sli10-desk.sh.intel.com> <20100114113103.GB15559@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114113103.GB15559@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14 2010, Vivek Goyal wrote:
> On Thu, Jan 14, 2010 at 12:16:24PM +0800, Shaohua Li wrote:
> > On Wed, Jan 13, 2010 at 07:18:07PM +0800, Vivek Goyal wrote:
> > > On Wed, Jan 13, 2010 at 04:17:35PM +0800, Shaohua Li wrote:
> > > [..]
> > > > > >  static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> > > > > >  {
> > > > > >  	unsigned int max_dispatch;
> > > > > > @@ -2258,7 +2273,10 @@ static bool cfq_may_dispatch(struct cfq_
> > > > > >  	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
> > > > > >  		return false;
> > > > > >  
> > > > > > -	max_dispatch = cfqd->cfq_quantum;
> > > > > > +	max_dispatch = cfqd->cfq_quantum / 2;
> > > > > > +	if (max_dispatch < CFQ_SOFT_QUANTUM)
> > > > > 
> > > > > We don't have to hardcode CFQ_SOFT_QUANTUM or in fact we don't need it. We can
> > > > > derive the soft limit from hard limit (cfq_quantum). Say soft limit will be
> > > > > 50% of cfq_quantum value.
> > > > I'm hoping this doesn't give user a surprise. Say cfq_quantum sets to 7, then we
> > > > start doing throttling from 3 requests. Adding the CFQ_SOFT_QUANTUM gives a compatibility
> > > > against old behavior at least. Am I over thinking?
> > > >  
> > > 
> > > I would not worry too much about that. If you are really worried about
> > > that, then create one Documentation/block/cfq-iosched.txt and document
> > > how cfq_quantum works so that users know that cfq_quantum is upper hard
> > > limit and internal soft limit is cfq_quantum/2.
> > Good idea. Looks we don't document cfq tunnables, I'll try to do it later.
> > 
> > Currently a queue can only dispatch up to 4 requests if there are other queues.
> > This isn't optimal, device can handle more requests, for example, AHCI can
> > handle 31 requests. I can understand the limit is for fairness, but we could
> > do a tweak: if the queue still has a lot of slice left, sounds we could
> > ignore the limit.
> 
> Hi Shaohua,
> 
> This looks much better. Though usage of "slice_idle" as measure of service
> times, I find little un-intutive. Especially, I do some testing with
> slice_idle=0, in that case, we will be allowing dispatch of 8 requests
> from each queue even if slice is about to expire.

I agree this is problematic, but I also think we need to do something
about the control of queuing depth. For most users, keeping it low is
what they want - performance doesn't change much with higher depths, you
only pay a latency cost when switching to a new queue. And they don't
want that.

But for other hardware, driving up the queue depth to what the hardware
supports (potentially) can be a big win, and CFQ definitely needs to be
able to do that.

Write caches are again problematic in this area... For reads and writes
on write through caching, just looking at what this cfqq has already
dispatched and completed in this slice would be sufficient. It could
even be carried over to the next slice as a seed value, so you could
dispatch more earlier. What we want to avoid is stuffing the device
queue with tons of writes that complete immediately, only to move the
pentalty of those requests into the slices of other queues.

-- 
Jens Axboe


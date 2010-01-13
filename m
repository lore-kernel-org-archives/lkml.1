Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741Ab0AMLSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab0AMLSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 06:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506Ab0AMLSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 06:18:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab0AMLSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:18:13 -0500
Date: Wed, 13 Jan 2010 06:18:07 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [RFC]cfq-iosched: quantum check tweak
Message-ID: <20100113111807.GC3087@redhat.com>
References: <1262829893.4984.13.camel@sli10-desk.sh.intel.com> <4e5e476b1001071344i4f702496y22f33bc2d4bc834d@mail.gmail.com> <20100108171535.GC22219@redhat.com> <4e5e476b1001081235wc2784c1s87c0c70662b5e267@mail.gmail.com> <20100108205948.GH22219@redhat.com> <20100111023409.GE22362@sli10-desk.sh.intel.com> <20100111170339.GC22899@redhat.com> <20100112030756.GB22606@sli10-desk.sh.intel.com> <20100112154820.GB3065@redhat.com> <20100113081735.GD10492@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113081735.GD10492@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 04:17:35PM +0800, Shaohua Li wrote:
[..]
> > >  static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> > >  {
> > >  	unsigned int max_dispatch;
> > > @@ -2258,7 +2273,10 @@ static bool cfq_may_dispatch(struct cfq_
> > >  	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
> > >  		return false;
> > >  
> > > -	max_dispatch = cfqd->cfq_quantum;
> > > +	max_dispatch = cfqd->cfq_quantum / 2;
> > > +	if (max_dispatch < CFQ_SOFT_QUANTUM)
> > 
> > We don't have to hardcode CFQ_SOFT_QUANTUM or in fact we don't need it. We can
> > derive the soft limit from hard limit (cfq_quantum). Say soft limit will be
> > 50% of cfq_quantum value.
> I'm hoping this doesn't give user a surprise. Say cfq_quantum sets to 7, then we
> start doing throttling from 3 requests. Adding the CFQ_SOFT_QUANTUM gives a compatibility
> against old behavior at least. Am I over thinking?
>  

I would not worry too much about that. If you are really worried about
that, then create one Documentation/block/cfq-iosched.txt and document
how cfq_quantum works so that users know that cfq_quantum is upper hard
limit and internal soft limit is cfq_quantum/2.

Thanks
Vivek

> > > +		max_dispatch = min_t(unsigned int, CFQ_SOFT_QUANTUM,
> > > +			cfqd->cfq_quantum);
> > >  	if (cfq_class_idle(cfqq))
> > >  		max_dispatch = 1;
> > >  
> > > @@ -2275,7 +2293,7 @@ static bool cfq_may_dispatch(struct cfq_
> > >  		/*
> > >  		 * We have other queues, don't allow more IO from this one
> > >  		 */
> > > -		if (cfqd->busy_queues > 1)
> > > +		if (cfqd->busy_queues > 1 && cfq_slice_used_soon(cfqd, cfqq))
> > >  			return false;
> > 
> > So I guess here we can write something as follows.
> > 
> > 		if (cfqd->busy_queues > 1 && cfq_slice_used_soon(cfqd, cfqq))
> > 			return false;
> > 
> > 		if (cfqd->busy_queues == 1)
> > 			max_dispatch = -1;
> > 		else
> > 			/*
> > 			 * Normally we start throttling cfqq when cfq_quantum/2
> > 			 * requests have been dispatched. But we can drive
> > 			 * deeper queue depths at the beginning of slice
> > 			 * subjected to upper limit of cfq_quantum.
> > 			 */
> > 			max_dispatch = cfqd->cfq_quantum;
> ok.
> 
> Thanks,
> Shaohua

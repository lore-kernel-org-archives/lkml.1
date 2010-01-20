Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790Ab0ATB3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab0ATB3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 20:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469Ab0ATB3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 20:29:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:9153 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218Ab0ATB3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 20:29:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,306,1262592000"; 
   d="scan'208";a="532721466"
Subject: Re: fio mmap randread 64k more than 40% regression with 2.6.33-rc1
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100119214046.GB4992@redhat.com>
References: <4e5e476b0912310234mf9ccaadm771c637a3d107d18@mail.gmail.com>
	 <1262340730.19773.47.camel@localhost>
	 <4e5e476b1001010832o24f6a0efudbfc36598bfc7c5e@mail.gmail.com>
	 <1262435612.19773.80.camel@localhost>
	 <4e5e476b1001021052u51a90a91qb2fbb4089498a3ca@mail.gmail.com>
	 <1262593090.29897.14.camel@localhost>
	 <4e5e476b1001041028v1f204834r1fa97e732a094210@mail.gmail.com>
	 <4e5e476b1001160827n6dc73b35vee8b46e541134c2@mail.gmail.com>
	 <1263783999.12893.2.camel@localhost>
	 <4e5e476b1001191210s37423e4av6673225d5078a88e@mail.gmail.com>
	 <20100119214046.GB4992@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 09:29:35 +0800
Message-ID: <1263950975.7958.9.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 13:40 -0800, Vivek Goyal wrote:
> On Tue, Jan 19, 2010 at 09:10:33PM +0100, Corrado Zoccolo wrote:
> > On Mon, Jan 18, 2010 at 4:06 AM, Zhang, Yanmin
> > <yanmin_zhang@linux.intel.com> wrote:
> > > On Sat, 2010-01-16 at 17:27 +0100, Corrado Zoccolo wrote:
> > >> Hi Yanmin
> > >> On Mon, Jan 4, 2010 at 7:28 PM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> > >> > Hi Yanmin,
> > >> >> When low_latency=1, we get the biggest number with kernel 2.6.32.
> > >> >> Comparing with low_latency=0's result, the prior one is about 4% better.
> > >> > Ok, so 2.6.33 + corrado (with low_latency =0) is comparable with
> > >> > fastest 2.6.32, so we can consider the first part of the problem
> > >> > solved.
> > >> >
> > >> I think we can return now to your full script with queue merging.
> > >> I'm wondering if (in arm_slice_timer):
> > >> -       if (cfqq->dispatched)
> > >> +      if (cfqq->dispatched || (cfqq->new_cfqq && rq_in_driver(cfqd)))
> > >>                return;
> > >> gives the same improvement you were experiencing just reverting to rq_in_driver.
> > > I did a quick testing against 2.6.33-rc1. With the new method, fio mmap randread 46k
> > > has about 20% improvement. With just checking rq_in_driver(cfqd), it has
> > > about 33% improvement.
> > >
> > Jeff, do you have an idea why in arm_slice_timer, checking
> > rq_in_driver instead of cfqq->dispatched gives so much improvement in
> > presence of queue merging, while it doesn't have noticeable effect
> > when there are no merges?
> 
> Performance improvement because of replacing cfqq->dispatched with
> rq_in_driver() is really strange. This will mean we will do even lesser
> idling on the cfqq. That means faster cfqq switching and that should mean more
> seeks (for this test case) and reduce throughput. This is just opposite to your approach of treating a random read mmap queue as sync where we will idle on
> the queue.
I used to look at the issue, but not fully understand it. Some
interesting finding:
the cfqq->dispatched cause cfq_select_queue frequently switch queues.
it appears frequent switch can make we could quickly switch to
sequential requests in the workload. without the cfqq->dispatched, we
dispatch queue1 request, M requests from other queues, queue1 request.
with it, we dispatch queue1 request, N requests from other queues,
queue1 request. It appears M < N from blktrace, which cause we have less
seeky. I don't see any other obvious difference from blktrace in the two
cases.

Thanks,
Shaohua


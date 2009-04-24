Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbZDXGj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbZDXGj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZDXGjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:39:46 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48902 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbZDXGjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:39:45 -0400
Date: Fri, 24 Apr 2009 08:39:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Aaron Carroll <aaronc@cse.unsw.edu.au>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Reduce latencies for syncronous writes and high I/O priority
	requests in deadline IO scheduler
Message-ID: <20090424063944.GA4593@kernel.dk>
References: <4e5e476b0904221407v7f43c058l8fc61198a2e4bb6e@mail.gmail.com> <49F05699.2070006@cse.unsw.edu.au> <4e5e476b0904230910r685e8300oa2323e8985c97a00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0904230910r685e8300oa2323e8985c97a00@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23 2009, Corrado Zoccolo wrote:
> >> * minimum batch timespan (time quantum): partners with fifo_batch to
> >> improve throughput, by sending more consecutive requests together. A
> >> given number of requests will not always take the same time (due to
> >> amount of seek needed), therefore fifo_batch must be tuned for worst
> >> cases, while in best cases, having longer batches would give a
> >> throughput boost.
> >> * batch start request is chosen fifo_batch/3 requests before the
> >> expired one, to improve fairness for requests with lower start sector,
> >> that otherwise have higher probability to miss a deadline than
> >> mid-sector requests.
> >
> > I don't like the rest of it.  I use deadline because it's a simple,
> > no surprises, no bullshit scheduler with reasonably good performance
> > in all situations.  Is there some reason why CFQ won't work for you?
> 
> I actually like CFQ, and use it almost everywhere, and switch to
> deadline only when submitting an heavy-duty workload (having a SysRq
> combination to switch I/O schedulers could sometimes be very handy).
> 
> However, on SSDs it's not optimal, so I'm developing this to overcome
> those limitations.

I find your solution quite confusing - the statement is that it CFQ
isn't optimal on SSD, so you modify deadline? ;-)

Most of the "CFQ doesn't work well on SSD" statements are mostly wrong.
Now, you seem to have done some testing, so when you say that you
probably have actually done some testing that tells you that this is the
case. But lets attempt to fix that issue, then!

One thing you pointed out is that CFQ doesn't treat the device as a
"real" SSD unless it does queueing. This is very much on purpose, for
two reasons:

1) I have never seen a non-queueing SSD that actually performs well for
   reads-vs-write situations, so CFQ still does idling for those.
2) It's a problem that is going away. SSD that are coming out today and
   in the future WILL definitely do queuing. We can attribute most of
   the crap behaviour to the lacking jmicron flash controller, which
   also has a crappy SATA interface.

What I am worried about in the future is even faster SSD devices. CFQ is
already down a percent or two when we are doing 100k iops and such, this
problem will only get worse. So I'm very much interested in speeding up
CFQ for such devices, which I think will mainly be slimming down the IO
path and bypassing much of the (unneeded) complexity for them. The last
thing I want is to have to tell people to use deadline or noop on SSD
devices.

> In the meantime, I wanted to overcome also deadline limitations, i.e.
> the high latencies on fsync/fdatasync.

This is very much something you could pull out of the patchset and we
could include without much questioning.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbZIIJKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbZIIJKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZIIJKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:10:07 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53016 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZIIJKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:10:06 -0400
Date: Wed, 9 Sep 2009 11:10:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090909091009.GR18599@kernel.dk>
References: <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk> <20090907141458.GD24507@elte.hu> <20090907173846.GB18599@kernel.dk> <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252486344.28645.18.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09 2009, Mike Galbraith wrote:
> On Wed, 2009-09-09 at 08:13 +0200, Ingo Molnar wrote:
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Tue, Sep 08 2009, Peter Zijlstra wrote:
> > > > On Tue, 2009-09-08 at 11:13 +0200, Jens Axboe wrote:
> > > > > And here's a newer version.
> > > > 
> > > > I tinkered a bit with your proglet and finally found the 
> > > > problem.
> > > > 
> > > > You used a single pipe per child, this means the loop in 
> > > > run_child() would consume what it just wrote out until it got 
> > > > force preempted by the parent which would also get woken.
> > > > 
> > > > This results in the child spinning a while (its full quota) and 
> > > > only reporting the last timestamp to the parent.
> > > 
> > > Oh doh, that's not well thought out. Well it was a quick hack :-) 
> > > Thanks for the fixup, now it's at least usable to some degree.
> > 
> > What kind of latencies does it report on your box?
> > 
> > Our vanilla scheduler default latency targets are:
> > 
> >   single-core: 20 msecs
> >     dual-core: 40 msecs
> >     quad-core: 60 msecs
> >     opto-core: 80 msecs
> > 
> > You can enable CONFIG_SCHED_DEBUG=y and set it directly as well via 
> > /proc/sys/kernel/sched_latency_ns:
> > 
> >    echo 10000000 > /proc/sys/kernel/sched_latency_ns
> 
> He would also need to lower min_granularity, otherwise, it'd be larger
> than the whole latency target.
> 
> I'm testing right now, and one thing that is definitely a problem is the
> amount of sleeper fairness we're giving.  A full latency is just too
> much short term fairness in my testing.  While sleepers are catching up,
> hogs languish.  That's the biggest issue going on.
> 
> I've also been doing some timings of make -j4 (looking at idle time),
> and find that child_runs_first is mildly detrimental to fork/exec load,
> as are buddies.
> 
> I'm running with the below at the moment.  (the kthread/workqueue thing
> is just because I don't see any reason for it to exist, so consider it
> to be a waste of perfectly good math;)

Using latt, it seems better than -rc9. The below are entries logged
while running make -j128 on a 64 thread box. I did two runs on each, and
latt is using 8 clients.

-rc9
        Max                23772 usec
        Avg                 1129 usec
        Stdev               4328 usec
        Stdev mean           117 usec

        Max                32709 usec
        Avg                 1467 usec
        Stdev               5095 usec
        Stdev mean           136 usec

-rc9 + patch

        Max                11561 usec
        Avg                 1532 usec
        Stdev               1994 usec
        Stdev mean            48 usec

        Max                 9590 usec
        Avg                 1550 usec
        Stdev               2051 usec
        Stdev mean            50 usec

max latency is way down, and much smaller variation as well.


-- 
Jens Axboe


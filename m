Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbXKAQz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbXKAQz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbXKAQzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:55:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50036 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXKAQzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:55:20 -0400
Subject: Re: [PATCH 2/6] sched: make sched_slice() group scheduling savvy
From: Peter Zijlstra <peterz@infradead.org>
To: vatsa@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <20071101163120.GB20788@linux.vnet.ibm.com>
References: <20071031211030.310581000@chello.nl>
	 <20071031211248.796653000@chello.nl>
	 <20071101113138.GA20788@linux.vnet.ibm.com>
	 <1193917912.27652.258.camel@twins> <1193918299.27652.260.camel@twins>
	 <1193918598.27652.262.camel@twins> <1193919608.27652.277.camel@twins>
	 <20071101163120.GB20788@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 17:55:15 +0100
Message-Id: <1193936115.27652.319.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 22:01 +0530, Srivatsa Vaddagiri wrote:
> On Thu, Nov 01, 2007 at 01:20:08PM +0100, Peter Zijlstra wrote:
> > On Thu, 2007-11-01 at 13:03 +0100, Peter Zijlstra wrote:
> > > On Thu, 2007-11-01 at 12:58 +0100, Peter Zijlstra wrote:
> > > 
> > > > > sched_slice() is about lantecy, its intended purpose is to ensure each
> > > > > task is ran exactly once during sched_period() - which is
> > > > > sysctl_sched_latency when nr_running <= sysctl_sched_nr_latency, and
> > > > > otherwise linearly scales latency.
> > > 
> > > The thing that got my brain in a twist is what to do about the non-leaf
> > > nodes, for those it seems I'm not doing the right thing - I think.
> > 
> > Ok, suppose a tree like so:
> > 
> > 
> > level 2                   cfs_rq
> >                        A           B
> > 
> > level 1             cfs_rqA     cfs_rqB
> >                      A0        B0 - B99
> > 
> > 
> > So for sake of determinism, we want to impose a period in which all
> > level 1 tasks will have ran (at least) once.
> 
> Peter,
> 	I fail to see why this requirement to "determine a period in
> which all level 1 tasks will have ran (at least) once" is essential.

Because it gives a steady feel to things. For humans its most essential
that things run in a predicable fashion. So no only does it matter how
much time a task gets, it also very much matters when it gets that.

It contributes to the feeling of gradual slow down. 

> I am visualizing each of the groups to be similar to Xen-like partitions
> which are given fair timeslices by the hypervisor (Linux kernel in this
> case). How each partition (group in this case) manages the allocated
> timeslice(s) to provide fairness to tasks within that partition/group should not
> (IMHO) depend on other groups and esp. how many tasks other groups has.

Agreed, I've realised this since my last mail, one group should not
influence another in such a fashion, in this respect you don't want to
flatten it like I did.

> For ex: before this patch, fair time would be allocated to group and
> their tasks as below:
> 
>     A0       B0-B9     A0    B10-B19     A0     B20-B29
>  |--------|--------|--------|--------|--------|--------|-----//--| 
>  0       10ms	   20ms	   30ms     40ms     50ms     60ms
> 
> i.e during the first 10ms allocated to group B, B0-B9 run,
>     during the next  10ms allocated to group B, B10-B19 run etc
> 
> What's wrong with this scheme?

What made me start tinkering here is that the nested level is again
distributing wall-time without being aware of the fraction it gets from
the upper levels.

So if we have two groups, A and B, and B is selected for 1/2 of period,
then Bn will again divide period, even though in reality it will only
have p/2.

So I guess, I need a top down traversal, not a bottom up traversal to
get this fixed up... I'll ponder this.

> By letting __sched_period() be determined for each group independently,
> we are building stronger isolation between them, which is good IMO
> (imagine a rogue container that does a fork bomb).

Agreed.

> > Index: linux-2.6/kernel/sched_fair.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched_fair.c
> > +++ linux-2.6/kernel/sched_fair.c
> > @@ -341,7 +341,7 @@ static u64 sched_slice(struct cfs_rq *cf
> >  		do_div(slice, cfs_rq->load.weight);
> >  	}
> > 
> > -	return slice;
> > +	return min_t(u64, sysctl_sched_latency, slice);

> which seems to be more or less giving what we already have w/o the
> patch?

Well, its basically giving up on overload, admittedly not very nice.


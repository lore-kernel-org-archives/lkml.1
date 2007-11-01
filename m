Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbXKAQTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbXKAQTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXKAQSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:18:55 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60083 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbXKAQSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:18:54 -0400
Date: Thu, 1 Nov 2007 22:01:20 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH 2/6] sched: make sched_slice() group scheduling savvy
Message-ID: <20071101163120.GB20788@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071031211030.310581000@chello.nl> <20071031211248.796653000@chello.nl> <20071101113138.GA20788@linux.vnet.ibm.com> <1193917912.27652.258.camel@twins> <1193918299.27652.260.camel@twins> <1193918598.27652.262.camel@twins> <1193919608.27652.277.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193919608.27652.277.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 01:20:08PM +0100, Peter Zijlstra wrote:
> On Thu, 2007-11-01 at 13:03 +0100, Peter Zijlstra wrote:
> > On Thu, 2007-11-01 at 12:58 +0100, Peter Zijlstra wrote:
> > 
> > > > sched_slice() is about lantecy, its intended purpose is to ensure each
> > > > task is ran exactly once during sched_period() - which is
> > > > sysctl_sched_latency when nr_running <= sysctl_sched_nr_latency, and
> > > > otherwise linearly scales latency.
> > 
> > The thing that got my brain in a twist is what to do about the non-leaf
> > nodes, for those it seems I'm not doing the right thing - I think.
> 
> Ok, suppose a tree like so:
> 
> 
> level 2                   cfs_rq
>                        A           B
> 
> level 1             cfs_rqA     cfs_rqB
>                      A0        B0 - B99
> 
> 
> So for sake of determinism, we want to impose a period in which all
> level 1 tasks will have ran (at least) once.

Peter,
	I fail to see why this requirement to "determine a period in
which all level 1 tasks will have ran (at least) once" is essential.

I am visualizing each of the groups to be similar to Xen-like partitions
which are given fair timeslices by the hypervisor (Linux kernel in this
case). How each partition (group in this case) manages the allocated
timeslice(s) to provide fairness to tasks within that partition/group should not
(IMHO) depend on other groups and esp. how many tasks other groups has.

For ex: before this patch, fair time would be allocated to group and
their tasks as below:

    A0       B0-B9     A0    B10-B19     A0     B20-B29
 |--------|--------|--------|--------|--------|--------|-----//--| 
 0       10ms	   20ms	   30ms     40ms     50ms     60ms

i.e during the first 10ms allocated to group B, B0-B9 run,
    during the next  10ms allocated to group B, B10-B19 run etc

What's wrong with this scheme?

By letting __sched_period() be determined for each group independently,
we are building stronger isolation between them, which is good IMO
(imagine a rogue container that does a fork bomb).

> Now what sched_slice() does is calculate the weighted proportion of the
> given period for each task to run, so that each task runs exactly once.
> 
> Now level 2, can introduce these large weight differences, which in this
> case result in 'lumps' of time.
> 
> In the given example above the weight difference is 1:100, which is
> already at the edges of what regular nice levels could do.
> 
> How about limiting the max output of sched_slice() to
> sysctl_sched_latency in order to break up these large stretches of time?
> 
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -341,7 +341,7 @@ static u64 sched_slice(struct cfs_rq *cf
>  		do_div(slice, cfs_rq->load.weight);
>  	}
> 
> -	return slice;
> +	return min_t(u64, sysctl_sched_latency, slice);

Hmm, going back to the previous example I cited, this will lead to:

	sched_slice(grp A) = min(20ms, 500ms) = 20ms
	sched_slice(A0) = min(20ms, 500ms) = 20ms

	sched_slice(grp B) = min(20ms, 500ms) = 20ms
	sched_slice(B0) = min(20ms, 0.5ms) = 0.5ms

Fairness between groups and tasks would be obtained as below:

     A0     B0-B39     A0     B40-B79    A0
 |--------|--------|--------|--------|--------|
 0     20ms       40ms      60ms     80ms

which seems to be more or less giving what we already have w/o the
patch?

-- 
Regards,
vatsa

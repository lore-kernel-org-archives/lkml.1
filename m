Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896AbYKRMbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbYKRMbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 07:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYKRMbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 07:31:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:55350 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbYKRMbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 07:31:01 -0500
Subject: Re: busted CFS group load balancer?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ken Chen <kenchen@google.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <b040c32a0811172333k5a89ccfy6438bf66d32dca5d@mail.gmail.com>
References: <20081115011452.GA28135@google.com>
	 <49218FB4.6090805@nortel.com>
	 <b040c32a0811171204p4ce6d706j3ee2c018d0f33548@mail.gmail.com>
	 <4921DFD8.9060509@nortel.com>
	 <1226985548.29743.6.camel@lappy.programming.kicks-ass.net>
	 <b040c32a0811172333k5a89ccfy6438bf66d32dca5d@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 13:30:43 +0100
Message-Id: <1227011444.29743.15.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-17 at 23:33 -0800, Ken Chen wrote:
> On Mon, Nov 17, 2008 at 9:19 PM, Peter Zijlstra wrote:
> > Note that with larger cpu count and/or lower group weight we'll quickly
> > run into numerical trouble...
> >
> > I would recommend trying this with the minimum weight in the order of
> > 8-16 times number of cpus on your system.
> >
> > There is only so much one can do with 10 bit fixed precision math :/
> 
> That is probably one of the many problems.  I also found that the
> updates to the per-cpu task_group's sched_entity load weight
> (tg->se[cpu]->load.weight) is very problematic and very erratic.
> 
> The total rq_weight is calculated at one beginning of tg_shares_up(),
> 
>         for_each_cpu_mask(i, sd->span) {
>                 rq_weight += tg->cfs_rq[i]->load.weight;
>                 shares += tg->cfs_rq[i]->shares;
>         }
> 
> However, the scaling of per-cpu se->load.weight in function
> __update_group_shares_cpu() takes another lookup of
> tg->cfs_rq[cpu]->load.weight at a different time.
> cfs_rq[cpu].load.weight aren't always consistent across these two
> times.  Due to these inconsistency of value taken on per cpu cfs_rq,
> I've see tg->se[cpu]->load.weight jumping all over the place.  In our
> environment, the cpu loads are very dynamic.  Process
> queuing/dequeuing at high rate.

Ok, if your load values are very unstable in the order of the
load-balance interval then you're hosed too, the same is true for the
normal smp load-balancer.

The cgroup load-balancer makes that even more problematic.

Again, there's just very little you can do about that, except increase
the coupling between cpus and thereby increase the overhead. Try
decreasing 
sysctl_sched_shares_ratelimit.


> I'm also very troubled with this calculation in __update_group_shares_cpu():
> 
>         shares = (sd_shares * rq_weight) / (sd_rq_weight + 1);
> 
> Won't you have rounding problem here?  value 'shares' will gradually
> decrease for each iteration of __update_group_shares_cpu()?

Yes it will, however at the top of the sched-domain tree its reset. 

        if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
                shares = tg->shares;




Return-Path: <linux-kernel-owner+w=401wt.eu-S932709AbZDCPMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbZDCPMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761453AbZDCPL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:11:58 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:36450 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759951AbZDCPL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:11:56 -0400
Date: Fri, 3 Apr 2009 20:41:43 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH v2 1/2] sched: Nominate idle load balancer from a
	semi-idle package.
Message-ID: <20090403151143.GA7641@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090402123607.14569.33649.stgit@sofia.in.ibm.com> <20090402123829.14569.67639.stgit@sofia.in.ibm.com> <87hc16kyk5.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hc16kyk5.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Thanks for the review.
On Fri, Apr 03, 2009 at 09:04:42AM +0200, Andi Kleen wrote:
> Gautham R Shenoy <ego@in.ibm.com> writes:
> >
> > Improve the algorithm to nominate the idle load balancer from a semi idle
> > cores/packages thereby increasing the probability of the cores/packages being
> > in deeper sleep states for longer duration.
> 
> The basic patch looks good.
> 
> In theory you could also look for a nearby nohz balancer in the end
> to optimize traffic on the interconnect of a larger NUMA system, 
> but it's probably not worth it.

The algorithm does this already, since it starts off with it's own
sched_group in the power-aware sched_domain, and moves to it's
sibling-groups. The sibling groups are linked in the order of
their proximity.
> 
> >
> > The algorithm is activated only when sched_mc/smt_power_savings != 0.
> 
> But it seems to me that this check could be dropped and doing it
> unconditionally, because idle balancing doesn't need much memory
> bandwith or cpu power, so always putting it nearby is good.

Well, right now, a new idle load balancer is nominated when the current
idle load balancer picks up a task. At this point, if the user is
concerned about performance as opposed to energy savings, we wouldn't
want to iterate over the domain hierarchy to find the best idle load
balancer, would we ? Because that might cause latency in running the job
that is queued on our runqueue.

Actually this can be optimized. We can have the current idle-load
balancer nominate the ilb as the first_cpu(nohz._cpu_mask). And this
idle load balancer at the end of the sched_tick can see if there's a
more power-efficient idle load balancer.

Let me see if this gives any benefit over the patches that I've posted.
> 
> -Ani
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.

-- 
Thanks and Regards
gautham

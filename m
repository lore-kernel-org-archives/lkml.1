Return-Path: <linux-kernel-owner+w=401wt.eu-S932531AbXGXUkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbXGXUkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932432AbXGXUkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:40:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424AbXGXUkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:40:01 -0400
Message-ID: <46A66393.5000705@redhat.com>
Date: Tue, 24 Jul 2007 16:39:47 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Tong Li <tong.n.li@intel.com>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <46A53C88.6060006@redhat.com> <Pine.LNX.4.64.0707240954560.8026@tongli.jf.intel.com> <46A64002.8080103@redhat.com> <46A6576A.9020506@nortel.com>
In-Reply-To: <46A6576A.9020506@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Chris Snook wrote:
> 
>> Concerns aside, I agree that fairness is important, and I'd really 
>> like to see a test case that demonstrates the problem.
> 
> One place that might be useful is the case of fairness between resource 
> groups, where the load balancer needs to consider each group separately.

You mean like the CFS group scheduler patches?  I don't see how this patch is 
related to that, besides working on top of it.

> Now it may be the case that trying to keep the load of each class within 
> X% of the other cpus is sufficient, but it's not trivial.

I agree.  My suggestion is that we try being fair from the bottom-up, rather 
than top-down.  If most of the rebalancing is local, we can minimize expensive 
locking and cross-node migrations, and scale very nicely on large NUMA boxes.

> Consider the case where you have a resource group that is allocated 50% 
> of each cpu in a dual cpu system, and only have a single task in that 
> group.  This means that in order to make use of the full group 
> allocation, that task needs to be load-balanced to the other cpu as soon 
> as it gets scheduled out.  Most load-balancers can't handle that kind of 
> granularity, but I have guys in our engineering team that would really 
> like this level of performance.

Divining the intentions of the administrator is an AI-complete problem and we're 
not going to try to solve that in the kernel.  An intelligent administrator 
could also allocate 50% of each CPU to a resource group containing all the 
*other* processes.  Then, when the other processes are scheduled out, your 
single task will run on whichever CPU is idle.  This will very quickly 
equilibrate to the scheduling ping-pong you seem to want.  The scheduler 
deliberately avoids this kind of migration by default because it hurts cache and 
TLB performance, so if you want to override this very sane default behavior, 
you're going to have to explicitly configure it yourself.

> We currently use CKRM on an SMP machine, but the only way we can get 
> away with it is because our main app is affined to one cpu and just 
> about everything else is affined to the other.

If you're not explicitly allocating resources, you're just low-latency, not 
truly realtime.  Realtime requires guaranteed resources, so messing with 
affinities is a necessary evil.

> We have another SMP box that would benefit from group scheduling, but we 
> can't use it because the load balancer is not nearly good enough.

Which scheduler?  Have you tried the CFS group scheduler patches?

	-- Chris

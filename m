Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbYLOMFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbYLOMFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 07:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYLOMFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 07:05:21 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:56722 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbYLOMFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 07:05:19 -0500
Date: Mon, 15 Dec 2008 17:35:37 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>
Subject: Re: [RFC PATCH v5 2/7] sched: favour lower logical cpu number for
	sched_mc balance
Message-ID: <20081215120537.GP5457@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Gregory Haskins <gregory.haskins@gmail.com>
References: <20081211173831.2020.57550.stgit@drishya.in.ibm.com> <20081211174247.2020.63646.stgit@drishya.in.ibm.com> <20081215061209.GB18403@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081215061209.GB18403@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2008-12-15 11:42:09]:

> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2008-12-11 23:12:48]:
> 
> > Just in case two groups have identical load, prefer to move load to lower
> > logical cpu number rather than the present logic of moving to higher logical
> > number.
> > 
> > find_busiest_group() tries to look for a group_leader that has spare capacity
> > to take more tasks and freeup an appropriate least loaded group.  Just in case
> > there is a tie and the load is equal, then the group with higher logical number
> > is favoured.  This conflicts with user space irqbalance daemon that will move
> > interrupts to lower logical number if the system utilisation is very low.
> >
> 
> This patch will work well with irqbalance only when irqbalance decides
> to switch to power mode and if the interrupt rate is high and

At power save mode irqbalance will move interrupts to cpu0.  At this
point the system utilisation is very very low.  When cpu0's
utilisation increases with all other packages being idle, then
sched_mc kernel side logic will also consolidate to cpu0.  

> irqbalance is in performance mode and sched_mc > 1, what is the impact
> of this patch?

This will be different workload characteristics.  If the interrupt
rate is high but the over all system utilisation is low, then
interrupts will get routed to any cpu decided by irqbalancer while
kernel will independently choose a package for tasks to run.  However
if the network traffic is very high, then that will drive up the
overall system utilisation as well and hence the opportunity to save
power will also reduce.

At this point we have an approximate convergence of user space
irqbalancer and kernel side decision to the same CPU package.  This
can go wrong for some corner cases or network intensive workloads.
Having the user space and kernel communicate on the cpu to consolidate
tasks and interrupts will improve the power savings.  Timer and
interrupts need to be consolidated and coordinated with the sched_mc
based task consolidation. 

> > Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> > ---
> > 
> >  kernel/sched.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 322cd2a..6bea99b 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -3264,7 +3264,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
> >  		 */
> >  		if ((sum_nr_running < min_nr_running) ||
> >  		    (sum_nr_running == min_nr_running &&
> > -		     first_cpu(group->cpumask) <
> > +		     first_cpu(group->cpumask) >
> >  		     first_cpu(group_min->cpumask))) {
> 
> The first_cpu logic worries me a bit. This has existed for a while
> already, but with the topology I see on my system, I find the cpu
> numbers interleaved on my system (0,2,4 and 6) belong to one core and
> odd numbers to the other.
> 
> So for a topology like (assume dual core, dual socket)
> 
>             0-3
>           /     \
>         0-1     2-3
>        /   \   /   \
>       0     1 2     3
> 
> 
> If group_min is the domain with (2-3) and we are looking at
> group(0-1). first_cpu of (0-1) is 0 and (2-3) is 2, how does changing
> "<" to ">" help push the tasks to the lower ordered group? In the case
> described above group_min continues to be (2-3).
> 
> Shouldn't the check be if (first_cpu(group->cpumask) <=
> first_cpu(group_min->cpumask)?

Cpu number are set in cpumask starting from the right most bit.  cpu
mask for group 0-1 will be 0x03 and 2-3 will be 0xC0.  first_cpu()
should get us the index of first LSB bit set.  As you have explained,
if the 'load' is equal in both the group, one task each, then
group_min will be group 2-3 with my change.  group_min is the group
from which task are pulled and group_leader is the group to which
the tasks should be moved for power savings.

I have reversed the comparison in the group_leader selection as well.
Without this patch, at equal load, the recommendation from
find_busiest_group will be 0-1 ==> 2-3, while with this change the
group leader will become 0-1 and group_min will be 2-3 and the
direction will be 2-3 ==> 0-1.
 
> 
> >  			group_min = group;
> >  			min_nr_running = sum_nr_running;
> > @@ -3280,7 +3280,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
> >  		if (sum_nr_running <= group_capacity - 1) {
> >  			if (sum_nr_running > leader_nr_running ||
> >  			    (sum_nr_running == leader_nr_running &&
> > -			     first_cpu(group->cpumask) >
> > +			     first_cpu(group->cpumask) <
> >  			      first_cpu(group_leader->cpumask))) {
> >  				group_leader = group;
> >  				leader_nr_running = sum_nr_running;
> > 
> >
> 
> All these changes are good, I would like to see additional statistics
> that show how many decisions were taken due to new power aware
> balancing logic, so that I spot the bad and corner cases based on the
> statistics I see.

I had traced all these decisions during initial development.  This
situation happens more often when we have exactly half load of long
running threads in the system.  Like ebizzy with 2 threads in a dual
socket dual core system that you just described. This change in
decision will help consolidate the workload to group 0-1 as compared
to 2-3 in most cases. The consolidation decision can be favoring 2-3
also if there were other small bursty tasks running in the system that
will make the find_busiest group suggest consolidation of 0-1 ==> 2-3.

This exact condition of first_cpu() > xxx is important only when the
nr_running is equal in both groups and after one of two load balance
iterations, the system would consolidated the task and this decision
point will not be hit.

Thanks for the detailed review.

--Vaidy

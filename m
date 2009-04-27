Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZD0HCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZD0HCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 03:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZD0HCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 03:02:38 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55865 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbZD0HCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 03:02:37 -0400
Date: Mon, 27 Apr 2009 12:31:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Saving power by cpu evacuation using
	sched_mc=n
Message-ID: <20090427070126.GC4454@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090426204029.17495.46609.stgit@drishya.in.ibm.com> <20090427035216.GD10087@elte.hu> <20090427054325.GB6440@dirshya.in.ibm.com> <20090427055347.GA20739@elte.hu> <20090427063903.GC6440@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090427063903.GC6440@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2009-04-27 12:09:03]:

> * Ingo Molnar <mingo@elte.hu> [2009-04-27 07:53:47]:
> 
> > 
> > * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> > 
> > > > > --------------------------------------------------------
> > > > > sched_mc	No Cores	Performance	AvgPower	
> > > > > 		used		Records/sec	(Watts)
> > > > > --------------------------------------------------------
> > > > > 0		8		1.00x		1.00y
> > > > > 1		8		1.02x		1.01y
> > > > > 2		8		0.83x		1.01y
> > > > > 3		7		0.86x		0.97y
> > > > > 4		6		0.76x		0.92y
> > > > > 5		4		0.72x		0.82y
> > > > > --------------------------------------------------------
> > > > 
> > > > Looks like we want the kernel default to be sched_mc=1 ?
> > > 
> > > Hi Ingo,
> > > 
> > > Yes, sched_mc wins for a simple cpu bound workload like this.  But 
> > > the challenge is that the best settings depends on the workload 
> > > and the system configuration.  This leads me to think that the 
> > > default setting should be left with the distros where we can 
> > > factor in various parameters and choose the right default from 
> > > user space.
> > > 
> > > 
> > > > Regarding the values for 2...5 - is the AvgPower column time 
> > > > normalized or workload normalized?
> > > 
> > > The AvgPower is time normalised, just the power value divided by 
> > > the baseline at sched_mc=0.
> > >  
> > > > If it's time normalized then it appears there's no power win 
> > > > here at all: we'd be better off by throttling the workload 
> > > > directly (by injecting sleeps or something like that), right?
> > > 
> > > Yes, there is no power win when comparing with peak benchmark 
> > > throughput in this case.  However more complex workload setup may 
> > > not show similar characteristics because they are not dependent 
> > > only on CPU bandwidth for their peak performance.
> > > 
> > > * Reduction in cpu bandwidth may not directly translate to performance
> > >   reduction on complex workloads
> > > * Even if there is degradation, the system may still meet the design
> > >   objectives.  20-30% increase in response time over a 1 second
> > >   nominal value may be acceptable in most cases
> > 
> > But ... we could probably get a _better_ (near linear) slowdown by 
> > injecting wait cycles into the workload.
> 
> We have advantages when complete cpu packages are not used as opposed
> to just injecting idle time in all cores. 
> 
> > I.e. we should only touch balancing if there's a _genuine_ power 
> > saving: i.e. less power is used for the same throughput.
> 
> Load balancer knows the cpu package topology and in essence knows the
> most power efficient combinations of cores to use.  If we have to
> schedule on 4 cores in a 8 core system, the load balancer can pick the
> right combination.
> 
> > The numbers in the table show a plain slowdown: doing fewer 
> > transactions means less power used. But that is trivial to achieve 
> > for a CPU-bound workload: throttle the workload. I.e. inject less 
> > work, save power.
> 
> Agreed, this example does not show the best use case for this
> feature, however we can easily experimentally verify that targeted
> evacuation of cores can provide better performance-per-watt as
> compared to plain throttling to reduce utilisation.
>

We have throttling in the form of P-states so that infrastructure
already exists, albeit in hardware. We want to go one step further
with targetted evacuation.
 
> > And if we want to throttle 'transparently', from the kernel, we 
> > should do it not via an artificial open-ended scale of 
> > sched_mc=2,3,4,5... - we should do it via a _percentage_ value.
> 
> Yes we want to transparently throttle from the kernel at a core level
> granularity.
> 
> Having a percentage value that can take discrete steps based on the
> number of cores in the system is a good idea.  I will switch the
> parameter to percentage in the next iteration.
> 
> > I.e. a system setting that says "at most utilize the system 80% of 
> > its peak capacity". That can be implemented by the kernel injecting 
> > small delays or by intentionally not scheduling on certain CPUs (but 
> > not delaying tasks - forcing them to other cpus in essence).
> 
> Advances in hardware power management like very low power deep sleep
> states and further package level power savings when all cores are idle
> changes the above assumption.
> 
> Uniformly adding delays on all CPUs provide far less power savings as
> compared to not using one core or one complete package.  Evacuating
> core/package essentially shuts them off as compared to very short
> bursts of idle times.
> 
> If we can accumulate all such idle times to a single core, with little
> effect on fairness, we get better power savings for the same amount of
> idle time or utilisation.
> 
> Agreed that this is a coarse granularity compared to injecting delay,
> but this will become practical as the core density increase in the
> enterprise processor design.

Apart from increasing core density, per-core power management is becoming
more mature, so evacuating cores is becoming an attractive
proposition.

-- 
	Balbir

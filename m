Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYAILHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYAILHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 06:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYAILHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 06:07:25 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:51867 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYAILHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 06:07:24 -0500
Date: Wed, 9 Jan 2008 16:43:02 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: discuss@LessWatts.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de,
       Arjan van de Ven <arjan@infradead.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Chanda Sethia <chanda.sethia@in.ibm.com>
Subject: Re: Analysis of sched_mc_power_savings
Message-ID: <20080109111302.GC7793@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
	discuss@LessWatts.org,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
	venkatesh.pallipadi@intel.com, tglx@linutronix.de,
	Arjan van de Ven <arjan@infradead.org>,
	Gautham R Shenoy <ego@in.ibm.com>,
	Chanda Sethia <chanda.sethia@in.ibm.com>
References: <20080108173815.GA7793@dirshya.in.ibm.com> <20080108212400.GA8903@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080108212400.GA8903@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Siddha, Suresh B <suresh.b.siddha@intel.com> [2008-01-08 13:24:00]:

> On Tue, Jan 08, 2008 at 11:08:15PM +0530, Vaidyanathan Srinivasan wrote:
> > Hi,
> > 
> > The following experiments were conducted on a two socket dual core
> > intel processor based machine in order to understand the impact of
> > sched_mc_power_savings scheduler heuristics.
> 
> Thanks for these experiments. sched_mc_power_savings is mainly for
> the reasonably long(which can be caught by periodic load balance) running
> light load(when number of tasks < number of logical cpus).  This tunable
> will minimize the number of packages carrying load, enabling the other
> completely idle packages to go to the available deepest P and C states.

Hi Suresh,

Thanks for the explanation.  I tried few more experiments based on
your comments and found that in a long running CPU intensive job, the
heuristics did help to get the load on the same package.

> > 
> > The scheduler heuristics for multi core system
> > /sys/devices/system/cpu/sched_mc_power_savings should ideally extend
> > the cpu tickless idle time atleast on few CPU in an SMP machine.
> 
> Not really. Ideally sched_mc_power_savings re-distributes the load(in
> the scenarios mentioned above) to different logical cpus in the system, so
> as to minimize the busy packages in the system.

But the problem is we will not be able get longer idle time and goto
lower sleep states on other packages if we are not able to move the
short bursts of daemon jobs to busy packages.

We are looking at various means to increase uninterrupted CPU idle
times on atleast some of the CPUs in an under-utilised SMP machine.
 
> > Experiment 1:
> > -------------
> ...
> > Observations with sched_mc_power_savings=1:
> > 
> > * No major impact of sched_mc_power_savings on CPU0 and CPU1
> > * Significant idle time improvement on CPU2
> > * However, significant idle time reduction on CPU3
> 
> In your setup, CPU0 and 3 are the core siblings? If so, this is probably
> expected. Previously there was some load distribution happening between
> packages. With sched_mc_power_savings, load is now getting distributed
> between cores in the same package. But on my systems, typically CPU0 and 2
> are core siblings. I will let you confirm your system topology, before we
> come to conclusions.

No, in contrary to your observation, on my machine, CPU0 and CPU1 are
siblings on the first package while CPU2 and CPU3 are in the second
package.

> > Experiment 2:
> > -------------
> ...
> > 
> > Observations with sched_mc_power_savings=1:
> > 
> > * No major impact of sched_mc_power_savings on CPU0 and CPU1
> > * Good idle time improvement on CPU2 and CPU3
> 
> I would have expected similar results like in experiment-1. CPU3 data
> seems almost same with and without sched_mc_power_savings. Atleast the
> data is not significantly different as in other cases like CPU2 for ex.

There is a general improvement in idle time in this experiment as
compared to the first experiment.  So if sched_mc will not impact
short running tasks (daemons and other event managers in idle system),
then the observation on experiment-1 may be just a random
redistribution of tasks over time.

> > Please review the experiment and comment on how the effectiveness of
> > sched_mc_power_savings can be analysed.  
> 
> While we should see a no change or a simple redistribution(to minimize 
> busy packages) in your experiments, for evaluating sched_mc_power_savings,
> we can also use some lightly loaded system (like kernel-compilation or
> specjbb with 2 threads on  a DP with dual-core, for example and see how the
> load is distributed with and without MC power savings.)

I have tried running two CPU intensive threads.  With sched_mc turned
ON, they were scheduled on CPU0-1 or CPU2-3.  With sched_mc turned
OFF, I can see that they were scheduled arbitrarily.  

Later I added random usleep() to make them consume less CPU, in that
case the scheduling was very random.  The two threads with random
sleeps were scheduled on any of the 4 CPUs and the sched_mc parameter
had no effect is consolidating the threads to one package.  Addition
of sleeps makes the threads very short run and not CPU intensive.

This completely validates your explanation of consolidating only 'long
running' jobs.

How do we take this technique to the next step where we can
consolidate short running jobs as well?  Did you face any difficulty
biasing the CPU for short running jobs?

> Similarly it will be interesting to see how this data varies with and without
> tickless.

I am sure tickless has very significant impact on the idle time.
I will get you more data on this comparison.
 
> For some loads which can't be caught by periodic load balancer, we may
> not see any difference. But atleast we should not see any scheduling
> anomalies.

True, we did not see any scheduling anomalies yet.  

Thanks,
Vaidy

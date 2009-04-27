Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZD0Fn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZD0Fn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 01:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZD0Fns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 01:43:48 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:35985 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbZD0Fnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 01:43:47 -0400
Date: Mon, 27 Apr 2009 11:13:25 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Saving power by cpu evacuation using
	sched_mc=n
Message-ID: <20090427054325.GB6440@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090426204029.17495.46609.stgit@drishya.in.ibm.com> <20090427035216.GD10087@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090427035216.GD10087@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2009-04-27 05:52:16]:

> 
> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > Test results for ebizzy 8 threads at various sched_mc settings has 
> > been summarised with relative values below. The test platform is 
> > dual socket quad core x86 system (pre-Nehalem).
> > 
> > --------------------------------------------------------
> > sched_mc	No Cores	Performance	AvgPower	
> > 		used		Records/sec	(Watts)
> > --------------------------------------------------------
> > 0		8		1.00x		1.00y
> > 1		8		1.02x		1.01y
> > 2		8		0.83x		1.01y
> > 3		7		0.86x		0.97y
> > 4		6		0.76x		0.92y
> > 5		4		0.72x		0.82y
> > --------------------------------------------------------
> 
> Looks like we want the kernel default to be sched_mc=1 ?

Hi Ingo,

Yes, sched_mc wins for a simple cpu bound workload like this.  But the
challenge is that the best settings depends on the workload and the
system configuration.  This leads me to think that the default setting
should be left with the distros where we can factor in various
parameters and choose the right default from user space.


> Regarding the values for 2...5 - is the AvgPower column time 
> normalized or workload normalized?

The AvgPower is time normalised, just the power value divided by the
baseline at sched_mc=0.
 
> If it's time normalized then it appears there's no power win here at 
> all: we'd be better off by throttling the workload directly (by 
> injecting sleeps or something like that), right?

Yes, there is no power win when comparing with peak benchmark
throughput in this case.  However more complex workload setup may not
show similar characteristics because they are not dependent only on
CPU bandwidth for their peak performance.

* Reduction in cpu bandwidth may not directly translate to performance
  reduction on complex workloads
* Even if there is degradation, the system may still meet the design
  objectives.  20-30% increase in response time over a 1 second
  nominal value may be acceptable in most cases
* End user can tie application priority to such tunable where we can
  get power savings from low priority applications  
* Reducing average power consumption at a given point may save money
  to datacenter managers based on differential power cost
* Reducing average power reduces heat and provides greater savings
  from cooling infrastructure
* This framework can be used for thermal leveling on larger
  under-utilised machines to keep the overall temperature low and save
  leakage power  

Here, we would like end users and datacenter management software to
have fine grain steps to trade performance for power savings rather
than switching off servers and reducing application availability.

Your suggestion of throttling applications to achieve the same goal is
valid, but has the following limitations:

* The framework will be application dependent and the level of
  throttling required to evacuate cores is variable
* We get best power savings when the granularity of control is at
  a core level first and at a package level next (perhaps node level
  also)
* Throttled applications may still not choose the most power efficient
  combination of cores to run
* Having a framework to evacuate core in the OS helps in providing the
  right granularity of control  

The overall objective is to let users pick the right number cores to
run the job and allow the kernel to choose the most power efficient
combination of cores to run the job.

sched_mc={1,2} will allow the kernel to pick the most power efficient
combination of cores to run the workload while sched_mc={3,4,5} lets
the user control the number of cores to use or evacuate.

--Vaidy


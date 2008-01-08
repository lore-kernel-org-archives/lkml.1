Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbYAHVY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbYAHVY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYAHVYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:24:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:17313 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbYAHVYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:24:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,259,1196668800"; 
   d="scan'208";a="251190755"
Date: Tue, 8 Jan 2008 13:24:00 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: discuss@LessWatts.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de,
       Arjan van de Ven <arjan@infradead.org>, suresh.b.siddha@intel.com,
       Gautham R Shenoy <ego@in.ibm.com>,
       Chanda Sethia <chanda.sethia@in.ibm.com>
Cc: svaidy@linux.vnet.ibm.com
Subject: Re: Analysis of sched_mc_power_savings
Message-ID: <20080108212400.GA8903@linux-os.sc.intel.com>
References: <20080108173815.GA7793@dirshya.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108173815.GA7793@dirshya.in.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 11:08:15PM +0530, Vaidyanathan Srinivasan wrote:
> Hi,
> 
> The following experiments were conducted on a two socket dual core
> intel processor based machine in order to understand the impact of
> sched_mc_power_savings scheduler heuristics.

Thanks for these experiments. sched_mc_power_savings is mainly for
the reasonably long(which can be caught by periodic load balance) running
light load(when number of tasks < number of logical cpus).  This tunable
will minimize the number of packages carrying load, enabling the other
completely idle packages to go to the available deepest P and C states.

> 
> The scheduler heuristics for multi core system
> /sys/devices/system/cpu/sched_mc_power_savings should ideally extend
> the cpu tickless idle time atleast on few CPU in an SMP machine.

Not really. Ideally sched_mc_power_savings re-distributes the load(in
the scenarios mentioned above) to different logical cpus in the system, so
as to minimize the busy packages in the system.

> Experiment 1:
> -------------
...
> Observations with sched_mc_power_savings=1:
> 
> * No major impact of sched_mc_power_savings on CPU0 and CPU1
> * Significant idle time improvement on CPU2
> * However, significant idle time reduction on CPU3

In your setup, CPU0 and 3 are the core siblings? If so, this is probably
expected. Previously there was some load distribution happening between
packages. With sched_mc_power_savings, load is now getting distributed
between cores in the same package. But on my systems, typically CPU0 and 2
are core siblings. I will let you confirm your system topology, before we
come to conclusions.

> Experiment 2:
> -------------
...
> 
> Observations with sched_mc_power_savings=1:
> 
> * No major impact of sched_mc_power_savings on CPU0 and CPU1
> * Good idle time improvement on CPU2 and CPU3

I would have expected similar results like in experiment-1. CPU3 data
seems almost same with and without sched_mc_power_savings. Atleast the
data is not significantly different as in other cases like CPU2 for ex.

> Please review the experiment and comment on how the effectiveness of
> sched_mc_power_savings can be analysed.  

While we should see a no change or a simple redistribution(to minimize 
busy packages) in your experiments, for evaluating sched_mc_power_savings,
we can also use some lightly loaded system (like kernel-compilation or
specjbb with 2 threads on  a DP with dual-core, for example and see how the
load is distributed with and without MC power savings.)

Similarly it will be interesting to see how this data varies with and without
tickless.

For some loads which can't be caught by periodic load balancer, we may
not see any difference. But atleast we should not see any scheduling
anomalies.

thanks,
suresh

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbYH3Vnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbYH3Vnn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbYH3Vnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:43:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48598 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbYH3Vne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:43:34 -0400
Subject: Re: sched_mc_power_savings broken with CGROUPS+CPUSETS
From: Peter Zijlstra <peterz@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Max Krasnyansky <maxk@qualcomm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20080830204251.GB6124@dirshya.in.ibm.com>
References: <20080829131514.GS4801@dirshya.in.ibm.com>
	 <1220016237.17355.48.camel@twins> <48B85C44.6050901@qualcomm.com>
	 <1220095613.8426.22.camel@twins> <20080830204251.GB6124@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Sat, 30 Aug 2008 23:43:26 +0200
Message-Id: <1220132606.8426.46.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-31 at 02:12 +0530, Vaidyanathan Srinivasan wrote:
> * Peter Zijlstra <peterz@infradead.org> [2008-08-30 13:26:53]:
> 
> [snipped]
> 
> > 
> > I don't think iterating the domains and setting the flag is sufficient.
> > Look at this crap (found in arch/x86/kernel/smpboot.c):
> > 
> > cpumask_t cpu_coregroup_map(int cpu)
> > {
> >         struct cpuinfo_x86 *c = &cpu_data(cpu);
> >         /*
> >          * For perf, we return last level cache shared map.
> >          * And for power savings, we return cpu_core_map
> >          */
> >         if (sched_mc_power_savings || sched_smt_power_savings)
> >                 return per_cpu(cpu_core_map, cpu);
> >         else
> >                 return c->llc_shared_map;
> > }
> > 
> > which means we'll actually end up building different domain/group
> > configurations depending on power savings settings.
> 
> The above code helps a quad-core CPU to be treated as two dual core
> for performance when sched_mc_power_savings=0 and they will be treated
> as one quad core package if sched_mc_power_savings=1 since the power
> control (voltage control) is per quad core socket.
> 
> On a dual socket machine with two quad core cpus, 
> 
> sched_mc_power_savings=0 will build:
> 
> CPU0 attaching sched-domain:
>  domain 0: span 0,2 level MC
>   groups: 0 2
>   domain 1: span 0-7 level CPU
>    groups: 0,2 1,5 3-4 6-7
> 
> while sched_mc_power_savings=1 will build:
> 
> CPU0 attaching sched-domain:
>  domain 0: span 0,2-4 level MC
>   groups: 0 2 3 4
>   domain 1: span 0-7 level CPU
>    groups: 0,2-4 1,5-7
> 
> Last level cache (llc_shared_map) is used to build this map
> differently based on power savings settings.

Same for my dual-core Opteron 12xx, due to this code it normally
generates CPU level domains, because its not sharing cache.

> Do you think such detailed documentation around this code will help?

I realized what its good for, I'm just not sure I agree with it. I'm
feeling there is something wrong with this, just can't quite put my
finger on it.

I'm just feeling the domain structure should be invariant to such things
- its the same hardware after all, whether we schedule to optimize for
power or performance.


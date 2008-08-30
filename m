Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbYH3UjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbYH3UjZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 16:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYH3UjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 16:39:15 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:57398 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbYH3UjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 16:39:14 -0400
Date: Sun, 31 Aug 2008 02:12:51 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Max Krasnyansky <maxk@qualcomm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: sched_mc_power_savings broken with CGROUPS+CPUSETS
Message-ID: <20080830204251.GB6124@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Gregory Haskins <ghaskins@novell.com>
References: <20080829131514.GS4801@dirshya.in.ibm.com> <1220016237.17355.48.camel@twins> <48B85C44.6050901@qualcomm.com> <1220095613.8426.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1220095613.8426.22.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2008-08-30 13:26:53]:

[snipped]

> 
> I don't think iterating the domains and setting the flag is sufficient.
> Look at this crap (found in arch/x86/kernel/smpboot.c):
> 
> cpumask_t cpu_coregroup_map(int cpu)
> {
>         struct cpuinfo_x86 *c = &cpu_data(cpu);
>         /*
>          * For perf, we return last level cache shared map.
>          * And for power savings, we return cpu_core_map
>          */
>         if (sched_mc_power_savings || sched_smt_power_savings)
>                 return per_cpu(cpu_core_map, cpu);
>         else
>                 return c->llc_shared_map;
> }
> 
> which means we'll actually end up building different domain/group
> configurations depending on power savings settings.

The above code helps a quad-core CPU to be treated as two dual core
for performance when sched_mc_power_savings=0 and they will be treated
as one quad core package if sched_mc_power_savings=1 since the power
control (voltage control) is per quad core socket.

On a dual socket machine with two quad core cpus, 

sched_mc_power_savings=0 will build:

CPU0 attaching sched-domain:
 domain 0: span 0,2 level MC
  groups: 0 2
  domain 1: span 0-7 level CPU
   groups: 0,2 1,5 3-4 6-7

while sched_mc_power_savings=1 will build:

CPU0 attaching sched-domain:
 domain 0: span 0,2-4 level MC
  groups: 0 2 3 4
  domain 1: span 0-7 level CPU
   groups: 0,2-4 1,5-7

Last level cache (llc_shared_map) is used to build this map
differently based on power savings settings.

Do you think such detailed documentation around this code will help?

--Vaidy

[snipped]


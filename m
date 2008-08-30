Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbYH3L10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbYH3L10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 07:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYH3L1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 07:27:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:55677 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYH3L1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 07:27:17 -0400
Subject: Re: sched_mc_power_savings broken with CGROUPS+CPUSETS
From: Peter Zijlstra <peterz@infradead.org>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <48B85C44.6050901@qualcomm.com>
References: <20080829131514.GS4801@dirshya.in.ibm.com>
	 <1220016237.17355.48.camel@twins>  <48B85C44.6050901@qualcomm.com>
Content-Type: text/plain
Date: Sat, 30 Aug 2008 13:26:53 +0200
Message-Id: <1220095613.8426.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-29 at 13:29 -0700, Max Krasnyansky wrote:
> Peter Zijlstra wrote:
> > On Fri, 2008-08-29 at 18:45 +0530, Vaidyanathan Srinivasan wrote:
> >> Hi,
> >>
> >> sched_mc_power_savings seems to be broken with CGROUPS+CPUSETS.
> >> When CONFIG_CPUSETS=y the attached BUG_ON() is being hit.
> >>
> >> I added a BUG_ON to check if SD_POWERSAVINGS_BALANCE is set at
> >> SD_LV_CPU whenever sched_mc_power_savings is set.
> >>
> >> This BUG is hit when config CONFIG_CPUSETS (depends on CONFIG_CGROUPS)
> >> is just compiled in while this is never hit when they are compiled
> >> out.  The fact that SD_POWERSAVINGS_BALANCE being cleared even when
> >> sched_mc_power_savings = 1 completely breaks the
> >> sched_mc_power_savings heuristics.
> >>
> >> To recreate the problem,
> >> Have sched_mc power savings enabled CONFIG_SCHED_MC=y
> >> Add this BUG_ON()
> >>
> >> echo 1 > /sys/devices/system/cpu/sched_mc_power_savings
> >>
> >> Try these these on a multi core x86 box.
> >>
> >> sched_mc_power_savings seems to be broken from 2.6.26-rc1, but
> >> I do not have a confirmation that the root cause is same in all
> >> successive versions. sched_mc_power_savings works perfect in
> >> 2.6.25.
> >>
> >> Please help me root cause the issue.  Please point me to changes that
> >> may potential cause this bug.
> > 
> > I'm still greatly mistified by all that power savings code.
> > 
> > Its hard to read and utterly hard to comprehend - I've been about to rip
> > the whole stuff out on several occasions. But so far tried to carefully
> > thread around it maintaining its operation even though not fully
> > understood.
> > 
> > Someone with clue - preferably the authors of the code in question -
> > should enlighten us with a patch that adds some comments as to the
> > intent of said lines of code.
> 
> I do not fully understand how balancing is affected by the MC stuff but I can
> explain how the mc power saving settings are applied to the domains and the
> overall mechanism for that.
> Here a quote from one of my emails to Paul
> 	
> > Max wrote:
> > ...
> > Those things (mc_power and topology updates) have to update domain flags based
> > on the mc/smt power and current topology settings.
> > This is done in the
> >   __rebuild_sched_domains()
> >        ...
> >        SD_INIT(sd, ALLNODES);
> >        ...
> >        SD_INIT(sd, MC);
> >        ...
> > 
> > SD_INIT(sd,X) uses one of SD initializers defined in the include/linux/topology.h
> > For example SD_CPU_INIT() includes BALANCE_FOR_PKG_POWER which expands to
> > 
> > #define BALANCE_FOR_PKG_POWER   \
> >         ((sched_mc_power_savings || sched_smt_power_savings) ?  \
> >          SD_POWERSAVINGS_BALANCE : 0)
> > 
> > Yes it's kind convoluted :). Anyway, the point is that we need to rebuild the
> > domains when those settings change. We could probably write a simpler version
> > that just iterates existing domains and updates the flags. Maybe some other dat :)

I don't think iterating the domains and setting the flag is sufficient.
Look at this crap (found in arch/x86/kernel/smpboot.c):

cpumask_t cpu_coregroup_map(int cpu)
{
        struct cpuinfo_x86 *c = &cpu_data(cpu);
        /*
         * For perf, we return last level cache shared map.
         * And for power savings, we return cpu_core_map
         */
        if (sched_mc_power_savings || sched_smt_power_savings)
                return per_cpu(cpu_core_map, cpu);
        else
                return c->llc_shared_map;
}

which means we'll actually end up building different domain/group
configurations depending on power savings settings.

> As I explained in the previous reply I missed the fact the logic that avoids
> redundant rebuilds in partition_sched_domains() will prevent
> arch_reinit_sched_domains() from doing the actual rebuild and hence will not
> apply the SD_POWERSAVINGS_BALANCE until something changes in cpuset setup.
> 
> btw I can certainly attest to the fact that powersaving code is very hard to
> read and comprehend :)

Yeah - I was primarity hinting at the sched_group and find_*_group()
fudge, esp find_busiest_group() is an utter nightmare.

I'm still struggeling to understand _why_ we need those group things to
begin with, why aren't the child domains good enough?




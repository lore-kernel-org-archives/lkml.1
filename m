Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYH2UaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYH2UaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 16:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYH2UaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 16:30:04 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46945 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYH2UaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 16:30:01 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5373"; a="6152053"
Message-ID: <48B85C44.6050901@qualcomm.com>
Date: Fri, 29 Aug 2008 13:29:56 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: sched_mc_power_savings broken with CGROUPS+CPUSETS
References: <20080829131514.GS4801@dirshya.in.ibm.com> <1220016237.17355.48.camel@twins>
In-Reply-To: <1220016237.17355.48.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2008-08-29 at 18:45 +0530, Vaidyanathan Srinivasan wrote:
>> Hi,
>>
>> sched_mc_power_savings seems to be broken with CGROUPS+CPUSETS.
>> When CONFIG_CPUSETS=y the attached BUG_ON() is being hit.
>>
>> I added a BUG_ON to check if SD_POWERSAVINGS_BALANCE is set at
>> SD_LV_CPU whenever sched_mc_power_savings is set.
>>
>> This BUG is hit when config CONFIG_CPUSETS (depends on CONFIG_CGROUPS)
>> is just compiled in while this is never hit when they are compiled
>> out.  The fact that SD_POWERSAVINGS_BALANCE being cleared even when
>> sched_mc_power_savings = 1 completely breaks the
>> sched_mc_power_savings heuristics.
>>
>> To recreate the problem,
>> Have sched_mc power savings enabled CONFIG_SCHED_MC=y
>> Add this BUG_ON()
>>
>> echo 1 > /sys/devices/system/cpu/sched_mc_power_savings
>>
>> Try these these on a multi core x86 box.
>>
>> sched_mc_power_savings seems to be broken from 2.6.26-rc1, but
>> I do not have a confirmation that the root cause is same in all
>> successive versions. sched_mc_power_savings works perfect in
>> 2.6.25.
>>
>> Please help me root cause the issue.  Please point me to changes that
>> may potential cause this bug.
> 
> I'm still greatly mistified by all that power savings code.
> 
> Its hard to read and utterly hard to comprehend - I've been about to rip
> the whole stuff out on several occasions. But so far tried to carefully
> thread around it maintaining its operation even though not fully
> understood.
> 
> Someone with clue - preferably the authors of the code in question -
> should enlighten us with a patch that adds some comments as to the
> intent of said lines of code.

I do not fully understand how balancing is affected by the MC stuff but I can
explain how the mc power saving settings are applied to the domains and the
overall mechanism for that.
Here a quote from one of my emails to Paul
	
> Max wrote:
> ...
> Those things (mc_power and topology updates) have to update domain flags based
> on the mc/smt power and current topology settings.
> This is done in the
>   __rebuild_sched_domains()
>        ...
>        SD_INIT(sd, ALLNODES);
>        ...
>        SD_INIT(sd, MC);
>        ...
> 
> SD_INIT(sd,X) uses one of SD initializers defined in the include/linux/topology.h
> For example SD_CPU_INIT() includes BALANCE_FOR_PKG_POWER which expands to
> 
> #define BALANCE_FOR_PKG_POWER   \
>         ((sched_mc_power_savings || sched_smt_power_savings) ?  \
>          SD_POWERSAVINGS_BALANCE : 0)
> 
> Yes it's kind convoluted :). Anyway, the point is that we need to rebuild the
> domains when those settings change. We could probably write a simpler version
> that just iterates existing domains and updates the flags. Maybe some other dat :)

As I explained in the previous reply I missed the fact the logic that avoids
redundant rebuilds in partition_sched_domains() will prevent
arch_reinit_sched_domains() from doing the actual rebuild and hence will not
apply the SD_POWERSAVINGS_BALANCE until something changes in cpuset setup.

btw I can certainly attest to the fact that powersaving code is very hard to
read and comprehend :)

Max

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbYH2URS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbYH2URS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 16:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYH2URG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 16:17:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5338 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYH2URF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 16:17:05 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5373"; a="6151672"
Message-ID: <48B8593E.7050205@qualcomm.com>
Date: Fri, 29 Aug 2008 13:17:02 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: sched_mc_power_savings broken with CGROUPS+CPUSETS
References: <20080829131514.GS4801@dirshya.in.ibm.com>
In-Reply-To: <20080829131514.GS4801@dirshya.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan wrote:
> Hi,
> 
> sched_mc_power_savings seems to be broken with CGROUPS+CPUSETS.
> When CONFIG_CPUSETS=y the attached BUG_ON() is being hit.
> 
> I added a BUG_ON to check if SD_POWERSAVINGS_BALANCE is set at
> SD_LV_CPU whenever sched_mc_power_savings is set.
> 
> This BUG is hit when config CONFIG_CPUSETS (depends on CONFIG_CGROUPS)
> is just compiled in while this is never hit when they are compiled
> out.  The fact that SD_POWERSAVINGS_BALANCE being cleared even when
> sched_mc_power_savings = 1 completely breaks the
> sched_mc_power_savings heuristics.
> 
> To recreate the problem,
> Have sched_mc power savings enabled CONFIG_SCHED_MC=y
> Add this BUG_ON()
> 
> echo 1 > /sys/devices/system/cpu/sched_mc_power_savings
> 
> Try these these on a multi core x86 box.
> 
> sched_mc_power_savings seems to be broken from 2.6.26-rc1, but
> I do not have a confirmation that the root cause is same in all
> successive versions. sched_mc_power_savings works perfect in
> 2.6.25.
> 
> Please help me root cause the issue.  Please point me to changes that
> may potential cause this bug.

That's my fault. I redid domain rebuild/hotplug handling awhile ago and missed
the fact that partition_sched_domains() is trying to avoid unnecessary domain
rebuilds. Primary issue at the time was circular locking issues and the the
testing that I was doing then was exercising a bunch of different scenarios
(ie cpu up/down, cpuset create/destroy, mcpowersave on/off) and I did not
notice that mcpowersave did not actually trigger domain rebuilds.

Anyway, I sent you guys a patch that should fix this issue.
Please confirm.

Max

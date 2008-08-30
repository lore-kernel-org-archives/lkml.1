Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYH3T7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYH3T7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYH3T7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:59:07 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:53890 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYH3T7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:59:04 -0400
Date: Sun, 31 Aug 2008 01:32:41 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: sched_mc_power_savings broken with CGROUPS+CPUSETS
Message-ID: <20080830200241.GA6124@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Max Krasnyansky <maxk@qualcomm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Gautham R Shenoy <ego@in.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <20080829131514.GS4801@dirshya.in.ibm.com> <48B8593E.7050205@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <48B8593E.7050205@qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Max Krasnyansky <maxk@qualcomm.com> [2008-08-29 13:17:02]:

> Vaidyanathan Srinivasan wrote:
> > Hi,
> > 
> > sched_mc_power_savings seems to be broken with CGROUPS+CPUSETS.
> > When CONFIG_CPUSETS=y the attached BUG_ON() is being hit.
> > 
> > I added a BUG_ON to check if SD_POWERSAVINGS_BALANCE is set at
> > SD_LV_CPU whenever sched_mc_power_savings is set.
> > 
> > This BUG is hit when config CONFIG_CPUSETS (depends on CONFIG_CGROUPS)
> > is just compiled in while this is never hit when they are compiled
> > out.  The fact that SD_POWERSAVINGS_BALANCE being cleared even when
> > sched_mc_power_savings = 1 completely breaks the
> > sched_mc_power_savings heuristics.
> > 
> > To recreate the problem,
> > Have sched_mc power savings enabled CONFIG_SCHED_MC=y
> > Add this BUG_ON()
> > 
> > echo 1 > /sys/devices/system/cpu/sched_mc_power_savings
> > 
> > Try these these on a multi core x86 box.
> > 
> > sched_mc_power_savings seems to be broken from 2.6.26-rc1, but
> > I do not have a confirmation that the root cause is same in all
> > successive versions. sched_mc_power_savings works perfect in
> > 2.6.25.
> > 
> > Please help me root cause the issue.  Please point me to changes that
> > may potential cause this bug.
> 
> That's my fault. I redid domain rebuild/hotplug handling awhile ago and missed
> the fact that partition_sched_domains() is trying to avoid unnecessary domain
> rebuilds. Primary issue at the time was circular locking issues and the the
> testing that I was doing then was exercising a bunch of different scenarios
> (ie cpu up/down, cpuset create/destroy, mcpowersave on/off) and I did not
> notice that mcpowersave did not actually trigger domain rebuilds.
> 
> Anyway, I sent you guys a patch that should fix this issue.
> Please confirm.

Hi Max,

Thank you very much for identifying the source of the problem.  I will
test your patch and report.

My BUG_ON() may still fail during the window of change.  I will watch
out for that.

--Vaidy

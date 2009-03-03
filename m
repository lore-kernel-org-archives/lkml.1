Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbZCCPXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbZCCPXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbZCCPXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:23:40 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37734 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529AbZCCPXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:23:38 -0500
Date: Tue, 3 Mar 2009 20:55:04 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, efault@gmx.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] sched: Extend sched_mc/smt_power_savings
	framework
Message-ID: <20090303152504.GH4708@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090303114648.605.86920.stgit@sofia.in.ibm.com> <1236082917.5330.4195.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1236082917.5330.4195.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-03-03 13:21:57]:

> On Tue, 2009-03-03 at 17:21 +0530, Gautham R Shenoy wrote:
> 
> > Background
> > ------------------------------------------------------------------
> > On machines with on-chip memory controller, each physical CPU
> > package forms a NUMA node and the CPU level sched_domain will have
> > only one group.  This prevents any form of power saving balance across
> > these nodes.  Enabling the sched_mc_power_savings tunable to work as
> > designed on these new single CPU NUMA node machines will help task
> > consolidation and save power as we did in other multi core multi
> > socket platforms.
> > 
> > Consolidation across NODES have implications of cross-node memory
> > access and other NUMA locality issues.  Even under such constraints
> > there could be scope for power savings vs performance tradeoffs and
> > hence making the sched_mc_powersavings work as expected on these
> > platform is justified.
> > 
> > sched_mc/smt_power_savings is still a tunable and power savings benefits
> > and performance would vary depending on the workload and the system
> > topology and hardware features.
> > 
> > The patch series has been tested on a 2-Socket Quad-core Dual threaded
> > box with kernbench as the workload, varying the number of threads.
> > 
> 
> > +------------------------------------------------------------------------+
> > |Test: make -j8                                                          |
> > +-----------+----------+--------+---------+-------------+----------------+
> > | sched_smt | sched_mc | %Power | Time    | % Package 0 | % Package 1    |
> > |           |          |        |         |     idle    |   idle         |
> > +-----------+----------+--------+---------+-------------+----------------+
> > |           |          |        |         |Core0: 18.17 |Core4: 33.38    |
> > |           |          |        |         +-------------+----------------+
> > |           |          |        |         |Core1: 34.62 |Core5: 19.58    |
> > |     0     |    0     |  100   |  63.82  +-------------+----------------+
> > |           |          |        |         |Core2: 31.99 |Core6: 32.35    |
> > |           |          |        |         +-------------+----------------+
> > |           |          |        |         |Core3: 34.59 |Core7: 29.99    |
> > +-----------+----------+--------+---------+-------------+----------------+
> 
> > +-----------+----------+--------+---------+-------------+----------------+
> > |           |          |        |         |Core0: 16.65 |Core4: 79.04    |
> > |           |          |        |         +-------------+----------------+
> > |           |          |        |         |Core1: 26.74 |Core5: 50.98    |
> > |     2     |    2     |  89.58 |  82.83  +-------------+----------------+
> > |           |          |        |         |Core2: 30.42 |Core6: 81.33    |
> > |           |          |        |         +-------------+----------------+
> > |           |          |        |         |Core3: 35.57 |Core7: 90.03    |
> > +-----------+----------+--------+---------+-------------+----------------+
> 
> So while we take longer (~20s) we save about 10% in power?

Yes that is correct. Since we are consolidating on sibling threads the
performance goes down.  Also this degradation is very much workload
dependent.  If the workloads can benefit a lot from sibling threads,
then we will be able to save power with modest performance
degradation.

This tunable is mainly focusing on power savings.  If performance
improves, then it is a bonus :)
 
> It would be good to mention something about how power usage is measured.

Power usage is measured by computing the energy consumed over the
benchmark duration and then finding average power by dividing
energy/time.  The relative power consumption is for the entire system.

> Furthermore, do we really need those separate mc/smt power savings
> settings? -- It appears to me we ought to consolidate some of that and
> provide a single knob to save power.

Yes, having one sched_power_savings will definitely help.  However,
mapping the various combination of settings to a single knob that will
provide consistent behavior across workloads and system configuration
is a challenge.
 
> > ---
> > 
> > Gautham R Shenoy (3):
> >       sched: Fix sd_parent_degenerate for SD_POWERSAVINGS_BALANCE.
> >       sched: Fix the wakeup nomination for sched_mc/smt_power_savings.
> >       sched: code cleanup - sd_power_saving_flags(), sd_balance_for_mc/package_power()
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> A few nits on patch #2, please follow up with incremental cleanups.

Thanks for the review comments and ack.

--Vaidy


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZCCMW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZCCMW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 07:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZCCMWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 07:22:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:35164 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZCCMWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 07:22:19 -0500
Subject: Re: [PATCH v2 0/3] sched: Extend sched_mc/smt_power_savings
 framework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, efault@gmx.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090303114648.605.86920.stgit@sofia.in.ibm.com>
References: <20090303114648.605.86920.stgit@sofia.in.ibm.com>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 13:21:57 +0100
Message-Id: <1236082917.5330.4195.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 17:21 +0530, Gautham R Shenoy wrote:

> Background
> ------------------------------------------------------------------
> On machines with on-chip memory controller, each physical CPU
> package forms a NUMA node and the CPU level sched_domain will have
> only one group.  This prevents any form of power saving balance across
> these nodes.  Enabling the sched_mc_power_savings tunable to work as
> designed on these new single CPU NUMA node machines will help task
> consolidation and save power as we did in other multi core multi
> socket platforms.
> 
> Consolidation across NODES have implications of cross-node memory
> access and other NUMA locality issues.  Even under such constraints
> there could be scope for power savings vs performance tradeoffs and
> hence making the sched_mc_powersavings work as expected on these
> platform is justified.
> 
> sched_mc/smt_power_savings is still a tunable and power savings benefits
> and performance would vary depending on the workload and the system
> topology and hardware features.
> 
> The patch series has been tested on a 2-Socket Quad-core Dual threaded
> box with kernbench as the workload, varying the number of threads.
> 

> +------------------------------------------------------------------------+
> |Test: make -j8                                                          |
> +-----------+----------+--------+---------+-------------+----------------+
> | sched_smt | sched_mc | %Power | Time    | % Package 0 | % Package 1    |
> |           |          |        |         |     idle    |   idle         |
> +-----------+----------+--------+---------+-------------+----------------+
> |           |          |        |         |Core0: 18.17 |Core4: 33.38    |
> |           |          |        |         +-------------+----------------+
> |           |          |        |         |Core1: 34.62 |Core5: 19.58    |
> |     0     |    0     |  100   |  63.82  +-------------+----------------+
> |           |          |        |         |Core2: 31.99 |Core6: 32.35    |
> |           |          |        |         +-------------+----------------+
> |           |          |        |         |Core3: 34.59 |Core7: 29.99    |
> +-----------+----------+--------+---------+-------------+----------------+

> +-----------+----------+--------+---------+-------------+----------------+
> |           |          |        |         |Core0: 16.65 |Core4: 79.04    |
> |           |          |        |         +-------------+----------------+
> |           |          |        |         |Core1: 26.74 |Core5: 50.98    |
> |     2     |    2     |  89.58 |  82.83  +-------------+----------------+
> |           |          |        |         |Core2: 30.42 |Core6: 81.33    |
> |           |          |        |         +-------------+----------------+
> |           |          |        |         |Core3: 35.57 |Core7: 90.03    |
> +-----------+----------+--------+---------+-------------+----------------+

So while we take longer (~20s) we save about 10% in power?

It would be good to mention something about how power usage is measured.

Furthermore, do we really need those separate mc/smt power savings
settings? -- It appears to me we ought to consolidate some of that and
provide a single knob to save power.

> ---
> 
> Gautham R Shenoy (3):
>       sched: Fix sd_parent_degenerate for SD_POWERSAVINGS_BALANCE.
>       sched: Fix the wakeup nomination for sched_mc/smt_power_savings.
>       sched: code cleanup - sd_power_saving_flags(), sd_balance_for_mc/package_power()

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

A few nits on patch #2, please follow up with incremental cleanups.


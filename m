Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbZBPQvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbZBPQvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZBPQvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:51:11 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:58659 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZBPQvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:51:10 -0500
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH 0/3] sched: Extend sched_mc/smt_power_savings framework.
To: linux-kernel@vger.kernel.org, svaidy@linux.vnet.ibm.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, ego@in.ibm.com
Cc: balbir@in.ibm.com, dipankar@in.ibm.com, efault@gmx.de, andi@firstfloor.org
Date: Mon, 16 Feb 2009 22:21:00 +0530
Message-ID: <20090216164719.12804.37013.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patch series extends the existing
sched_smt/mc_power_savings framework to work on platforms that
have onchip memory controller making each cpu package a 'node'

On such machines with on-chip memory controller, each physical CPU
package forms a NUMA node and the CPU level sched_domain will have
only one group.  This prevents any form of power saving balance across
these nodes.  Enabling the sched_mc/smt_power_savings tunable to work as
designed on these new single CPU NUMA node machines will help task
consolidation and save power as we did in other multi core multi
socket platforms.

Consolidation across NODES have implications of cross-node memory
access and other NUMA locality issues.  Even under such constraints
there could be scope for power savings vs performance tradeoffs and
hence making the sched_mc/smt_powersavings work as expected on these
platform is justified.

sched_mc/smt_power_savings is still a tunable and power savings benefits
and performance would vary depending on the workload and the system
topology and hardware features.

The patch series has been tested on a 2-Socket Quad-core Dual threaded
box with kernbench as the workload, varying the number of threads.

The following results shows the average of 3 iterations of each of the runs.

|-----------------------------------------------------------------------------|
|   testname                            | avg-time elapsed | % power consumed |
|-----------------------------------------------------------------------------|
|   pm_kernbench.smt-0-mc-0_threads=4   |   95.28s         |   100.00         |
|   pm_kernbench.smt-0-mc-1_threads=4   |   98.06s         |   100.98         |
|   pm_kernbench.smt-0-mc-2_threads=4   |   99.14s         |   101.98         |
|   pm_kernbench.smt-1-mc-1_threads=4   |  137.62s         |    92.68         |
|   pm_kernbench.smt-1-mc-2_threads=4   |  142.75s         |    91.89         |
|   pm_kernbench.smt-2-mc-2_threads=4   |  142.63s         |    92.30         |
|-----------------------------------------------------------------------------|
|   pm_kernbench.smt-0-mc-0_threads=6   |   66.25s         |   100.00         |
|   pm_kernbench.smt-0-mc-1_threads=6   |   71.18s         |    99.25         |
|   pm_kernbench.smt-0-mc-2_threads=6   |   69.43s         |   100.12         |
|   pm_kernbench.smt-1-mc-1_threads=6   |   96.46s         |    91.40         |
|   pm_kernbench.smt-1-mc-2_threads=6   |   99.51s         |    90.49         |
|   pm_kernbench.smt-2-mc-2_threads=6   |   99.35s         |    89.94         |
|-----------------------------------------------------------------------------|
|   pm_kernbench.smt-0-mc-0_threads=7   |   58.20s         |   100.00         |
|   pm_kernbench.smt-0-mc-1_threads=7   |   62.59s         |    98.12         |
|   pm_kernbench.smt-0-mc-2_threads=7   |   60.73s         |    99.17         |
|   pm_kernbench.smt-1-mc-1_threads=7   |   83.70s         |    90.47         |
|   pm_kernbench.smt-1-mc-2_threads=7   |   83.31s         |    88.98         |
|   pm_kernbench.smt-2-mc-2_threads=7   |   83.69s         |    89.51         |
|-----------------------------------------------------------------------------|
|   pm_kernbench.smt-0-mc-0_threads=8   |   54.08s         |   100.00         |
|   pm_kernbench.smt-0-mc-1_threads=8   |   57.98s         |    97.65         |
|   pm_kernbench.smt-0-mc-2_threads=8   |   55.79s         |    99.28         |
|   pm_kernbench.smt-1-mc-1_threads=8   |   74.31s         |    90.39         |
|   pm_kernbench.smt-1-mc-2_threads=8   |   76.03s         |    89.88         |
|   pm_kernbench.smt-2-mc-2_threads=8   |   76.59s         |    90.14         |
|-----------------------------------------------------------------------------|
|   pm_kernbench.smt-0-mc-0_threads=9   |   51.67s         |   100.00         |
|   pm_kernbench.smt-0-mc-1_threads=9   |   54.64s         |    97.38         |
|   pm_kernbench.smt-0-mc-2_threads=9   |   52.78s         |    98.81         |
|   pm_kernbench.smt-1-mc-1_threads=9   |   65.91s         |    91.33         |
|   pm_kernbench.smt-1-mc-2_threads=9   |   66.93s         |    91.36         |
|   pm_kernbench.smt-2-mc-2_threads=9   |   67.18s         |    90.99         |
|-----------------------------------------------------------------------------|


Thoughts on this approach?

---

Gautham R Shenoy (3):
      sched: Fix sd_parent_degenerate for SD_POWERSAVINGS_BALANCE.
      sched: Fix the wakeup nomination for sched_mc/smt_power_savings.
      sched: code cleanup - sd_power_saving_flags(), sd_balance_for_mc/package_power()


 include/linux/sched.h    |   47 ++++++++++++++--------------------------
 include/linux/topology.h |    6 ++---
 kernel/sched.c           |   54 +++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched_fair.c      |    2 +-
 4 files changed, 71 insertions(+), 38 deletions(-)

--
Thanks and Regards
gautham.

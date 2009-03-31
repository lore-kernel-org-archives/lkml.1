Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbZCaKuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbZCaKuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZCaKuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:50:24 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:56193 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZCaKuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:50:22 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH v4 0/5] sched: Extend sched_mc/smt_power_savings framework.
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>
Date: Tue, 31 Mar 2009 16:20:12 +0530
Message-ID: <20090331104829.16414.11385.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the iteration number 4 of the patchset which extends the
sched_mc_power_savings enhancements to benefit sched_smt_power_savings
as well. This is intended to work on platforms that have on-chip
memory controllers making each of the cpu-package a 'node'.

The patch-series is against linux-2.6-tip master, as on March 30th.

In addition to providing power savings, on such platforms,
this patchset fixes the inconsistent behavior of
sched_smt_power_savings while running odd number of pairs of tasks.

Ideally, when sched_smt_power_savings is enabled, we would like to see
the tasks running on sibling threads to take advantage of the
cache-sharing. However, in the case when there
are only 2 threads running, and sched_smt_power_savings is enabled,
the current load balancer doesn't pull them from across packages
onto a single core.

Changes from V3 (Found here: --> http://lkml.org/lkml/2009/3/6/23)
- Rebased and Retested against linux-2.6-tip master as on Mar 30th.
- Dropped the patch which added comments for find_busiest_group. That
  has been sent as a seperate series.

Changes from V2: (Found here:  --> http://lkml.org/lkml/2009/3/3/109)
- Patches have been split up in an incremental manner for easy review.
- Fixed comments for some variables.
- Renamed some variables to better reflect their usage.

Changes from V1: (Found here: --> http://lkml.org/lkml/2009/2/16/221)
- Added comments to explain power-saving part in find_busiest_group()
- Added comments for the different sched_domain levels.

Background
------------------------------------------------------------------
On machines with on-chip memory controller, each physical CPU
package forms a NUMA node and the CPU level sched_domain will have
only one group.  This prevents any form of power saving balance across
these nodes.  Enabling the sched_mc_power_savings tunable to work as
designed on these new single CPU NUMA node machines will help task
consolidation and save power as we did in other multi core multi
socket platforms.

Consolidation across NODES have implications of cross-node memory
access and other NUMA locality issues.  Even under such constraints
there could be scope for power savings vs performance tradeoffs and
hence making the sched_mc_powersavings work as expected on these
platform is justified.

sched_mc/smt_power_savings is still a tunable and power savings benefits
and performance would vary depending on the workload and the system
topology and hardware features.

The results of this patch series tested with kernbench on a
2-Socket Quad-core Dual threaded box, varying the number of threads is
as follows:

+------------------------------------------------------------------------+
|Test: make -j4                                                          |
+-----------+----------+--------+---------+-------------+----------------+
| sched_smt | sched_mc | %Power | Time    | % Package 0 | % Package 1    |
|           |          |        |  (s)    |     idle    |   idle         |
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 37.44 |Core4: 70.50    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 59.89 |Core5: 20.08    |
|     0     |    0     |  100   |  107.45 +-------------+----------------+
|           |          |        |         |Core2: 57.63 |Core6: 62.80    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 64.78 |Core7: 65.07    |
+-----------+----------+--------+---------+-------------+----------------+
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 13.41 |Core4: 98.06    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 28.56 |Core5: 60.64    |
|     0     |    2     |  99.89 |  109.95 +-------------+----------------+
|           |          |        |         |Core2: 28.49 |Core6: 98.30    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 31.49 |Core7: 99.77    |
+-----------+----------+--------+---------+-------------+----------------+
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 35.05 |Core4: 41.78    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 78.28 |Core5: 32.15    |
|     2     |    2     |  95.84 |  137.73 +-------------+----------------+
|           |          |        |         |Core2: 93.45 |Core6: 87.49    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 97.70 |Core7: 90.47    |
+-----------+----------+--------+---------+-------------+----------------+

+------------------------------------------------------------------------+
|Test: make -j6                                                          |
+-----------+----------+--------+---------+-------------+----------------+
| sched_smt | sched_mc | %Power | Time    | % Package 0 | % Package 1    |
|           |          |        |  (s)    |     idle    |   idle         |
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 25.50 |Core4: 39.22    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 46.47 |Core5: 20.71    |
|     0     |    0     |  100   |   76.06 +-------------+----------------+
|           |          |        |         |Core2: 45.20 |Core6: 42.30    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 46.50 |Core7: 47.29    |
+-----------+----------+--------+---------+-------------+----------------+
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 17.00 |Core4: 52.38    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 42.08 |Core5: 26.21    |
|     0     |    2     |  98.99 |   79.53 +-------------+----------------+
|           |          |        |         |Core2: 46.47 |Core6: 58.16    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 43.39 |Core7: 54.36    |
+-----------+----------+--------+---------+-------------+----------------+
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 63.85 |Core4: 21.55    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 93.35 |Core5: 18.76    |
|     2     |    2     |  92.16 |  100.22 +-------------+----------------+
|           |          |        |         |Core2: 96.02 |Core6: 36.76    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 99.01 |Core7: 64.32    |
+-----------+----------+--------+---------+-------------+----------------+

+------------------------------------------------------------------------+
|Test: make -j8                                                          |
+-----------+----------+--------+---------+-------------+----------------+
| sched_smt | sched_mc | %Power | Time    | % Package 0 | % Package 1    |
|           |          |        |  (s)    |     idle    |   idle         |
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 19.34 |Core4: 34.01    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 36.06 |Core5: 21.02    |
|     0     |    0     |  100   |   62.67 +-------------+----------------+
|           |          |        |         |Core2: 31.60 |Core6: 32.32    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 34.89 |Core7: 36.48    |
+-----------+----------+--------+---------+-------------+----------------+
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 17.53 |Core4: 35.30    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 37.05 |Core5: 22.93    |
|     0     |    2     |  99.20 |   64.08 +-------------+----------------+
|           |          |        |         |Core2: 36.96 |Core6: 35.07    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 36.09 |Core7: 37.38    |
+-----------+----------+--------+---------+-------------+----------------+
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 11.58 |Core4: 91.99    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 18.51 |Core5: 58.37    |
|     2     |    2     |  90.20 |   80.87 +-------------+----------------+
|           |          |        |         |Core2: 22.62 |Core6: 97.68    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 21.83 |Core7: 99.80    |
+-----------+----------+--------+---------+-------------+----------------+

---

Gautham R Shenoy (5):
      sched: Fix sd_parent_degenerate for SD_POWERSAVINGS_BALANCE.
      sched: Arbitrate the nomination of preferred_wakeup_cpu
      sched: Rename the variable sched_mc_preferred_wakeup_cpu
      sched: Record the current active power savings level
      sched: code cleanup - sd_power_saving_flags(), sd_balance_for_*_power()


 include/linux/sched.h    |   66 ++++++++++++++++++-----------------
 include/linux/topology.h |    6 +--
 kernel/sched.c           |   86 ++++++++++++++++++++++++++++++++++++++++------
 kernel/sched_fair.c      |    4 +-
 4 files changed, 112 insertions(+), 50 deletions(-)

-- 
Thanks and Regards
gautham.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbZCRJWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbZCRJWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbZCRJWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:22:25 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:54763 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbZCRJWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:22:23 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH v3 0/6] sched: Extend sched_mc/smt_framework
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>
Date: Wed, 18 Mar 2009 14:52:17 +0530
Message-ID: <20090318092054.24787.18730.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am reposting the iteration 3 of the patch series that extends the existing
sched_smt_/mc_power_savings framework to work on platforms
that have on-chip memory controllers making each of the cpu-package
a 'node'. I have rebased this patch series against 2.6.29-rc8.

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

The patch series has been tested on a 2-Socket Quad-core Dual threaded
box with kernbench as the workload, varying the number of threads.


+------------------------------------------------------------------------+
|Test: make -j4                                                          |
+-----------+----------+--------+---------+-------------+----------------+
| sched_smt | sched_mc | %Power | Time    | % Package 0 | % Package 1    |
|           |          |        |  (s)    |     idle    |   idle         |
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 35.34 |Core4: 62.01    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 58.34 |Core5: 17.41    |
|     0     |    0     |  100   |  107.84 +-------------+----------------+
|           |          |        |         |Core2: 63.97 |Core6: 60.29    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 68.64 |Core7: 61.46    |
+-----------+----------+--------+---------+-------------+----------------+
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 34.28 |Core4: 18.26    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 99.19 |Core5: 18.54    |
|     0     |    2     |  99.89 |  109.91 +-------------+----------------+
|           |          |        |         |Core2: 99.89 |Core6: 21.54    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 99.91 |Core7: 23.21    |
+-----------+----------+--------+---------+-------------+----------------+
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 20.17 |Core4: 69.30    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 50.22 |Core5: 55.97    |
|     2     |    2     |  95.03 |  139.95 +-------------+----------------+
|           |          |        |         |Core2: 83.95 |Core6: 92.70    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 88.95 |Core7: 95.58    |
+-----------+----------+--------+---------+-------------+----------------+

+------------------------------------------------------------------------+
|Test: make -j6                                                          |
+-----------+----------+--------+---------+-------------+----------------+
| sched_smt | sched_mc | %Power | Time    | % Package 0 | % Package 1    |
|           |          |        |  (s)    |     idle    |   idle         |
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 25.35 |Core4: 41.07    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 43.84 |Core5: 19.95    |
|     0     |    0     |  100   |  77.67  +-------------+----------------+
|           |          |        |         |Core2: 43.23 |Core6: 42.82    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 47.66 |Core7: 45.96    |
+-----------+----------+--------+---------+-------------+----------------+
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 24.13 |Core4: 41.80    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 51.51 |Core5: 23.61    |
|     0     |    2     |  99.41 |  81.50  +-------------+----------------+
|           |          |        |         |Core2: 55.43 |Core6: 38.67    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 57.79 |Core7: 38.84    |
+-----------+----------+--------+---------+-------------+----------------+
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0:  7.75 |Core4: 94.45    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 19.04 |Core5: 67.42    |
|     2     |    2     |  93.32 | 100.39  +-------------+----------------+
|           |          |        |         |Core2: 28.29 |Core6: 96.90    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 66.63 |Core7: 99.86    |
+-----------+----------+--------+---------+-------------+----------------+

+------------------------------------------------------------------------+
|Test: make -j8                                                          |
+-----------+----------+--------+---------+-------------+----------------+
| sched_smt | sched_mc | %Power | Time    | % Package 0 | % Package 1    |
|           |          |        |  (s)    |     idle    |   idle         |
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 18.17 |Core4: 33.38    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 34.62 |Core5: 19.58    |
|     0     |    0     |  100   |  63.82  +-------------+----------------+
|           |          |        |         |Core2: 31.99 |Core6: 32.35    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 34.59 |Core7: 29.99    |
+-----------+----------+--------+---------+-------------+----------------+
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 15.20 |Core4: 41.41    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 28.45 |Core5: 21.32    |
|     0     |    2     |  99.17 |  65.65  +-------------+----------------+
|           |          |        |         |Core2: 31.14 |Core6: 41.26    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 30.52 |Core7: 42.95    |
+-----------+----------+--------+---------+-------------+----------------+
+-----------+----------+--------+---------+-------------+----------------+
|           |          |        |         |Core0: 16.65 |Core4: 79.04    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core1: 26.74 |Core5: 50.98    |
|     2     |    2     |  89.58 |  82.83  +-------------+----------------+
|           |          |        |         |Core2: 30.42 |Core6: 81.33    |
|           |          |        |         +-------------+----------------+
|           |          |        |         |Core3: 35.57 |Core7: 90.03    |
+-----------+----------+--------+---------+-------------+----------------+


---

Gautham R Shenoy (6):
      sched: Fix sd_parent_degenerate for SD_POWERSAVINGS_BALANCE.
      sched: Arbitrate the nomination of preferred_wakeup_cpu
      sched: Rename the variable sched_mc_preferred_wakeup_cpu
      sched: Add Comments at the beginning of find_busiest_group.
      sched: Record the current active power savings level
      sched: code cleanup - sd_power_saving_flags(), sd_balance_for_*_power()


 include/linux/sched.h    |   66 +++++++++++++++++----------------
 include/linux/topology.h |    6 +--
 kernel/sched.c           |   92 +++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched_fair.c      |    4 +-
 4 files changed, 123 insertions(+), 45 deletions(-)

-- 
Thanks and Regards
gautham.

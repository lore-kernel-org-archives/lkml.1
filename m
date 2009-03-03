Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbZCCLv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbZCCLv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZCCLvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:51:49 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:49992 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZCCLvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:51:48 -0500
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH v2 0/3] sched: Extend sched_mc/smt_power_savings framework
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>
Cc: "Dipankar Sarma" <dipankar@in.ibm.com>, efault@gmx.de, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2009 17:21:38 +0530
Message-ID: <20090303114648.605.86920.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the second iteration of the patch series that extends the existing
sched_smt_/mc_power_savings framework to work on platforms
that have on-chip memory controllers making each of the cpu-package
a 'node'.

Original posting can be found here --> http://lkml.org/lkml/2009/2/16/221

Based on Peter's review comments, I have added additional comments at
appropriate places that help us understand the reason behind doing
certain things in the name of power-aware-load balancing.

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
+-----------+----------+--------+ --------+-------------+----------------+

+------------------------------------------------------------------------+
|Test: make -j6                                                          |
+-----------+----------+--------+---------+-------------+----------------+
| sched_smt | sched_mc | %Power | Time    | % Package 0 | % Package 1    |
|           |          |        |         |     idle    |   idle         |
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
|           |          |        |         |     idle    |   idle         |
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

Gautham R Shenoy (3):
      sched: Fix sd_parent_degenerate for SD_POWERSAVINGS_BALANCE.
      sched: Fix the wakeup nomination for sched_mc/smt_power_savings.
      sched: code cleanup - sd_power_saving_flags(), sd_balance_for_mc/package_power()


 include/linux/sched.h    |   66 ++++++++++++++++++-----------------
 include/linux/topology.h |    6 +--
 kernel/sched.c           |   88 +++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched_fair.c      |    2 +
 4 files changed, 119 insertions(+), 43 deletions(-)


Thoughts ?
-- 
Thanks and Regards
gautham.

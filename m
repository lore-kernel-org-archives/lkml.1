Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbZDBMim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbZDBMim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbZDBMid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:38:33 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:42246 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbZDBMib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:38:31 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH v2 0/2] sched: Nominate a power-efficient ILB.
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>, Andi Kleen <andi@firstfloor.org>
Date: Thu, 02 Apr 2009 18:08:24 +0530
Message-ID: <20090402123607.14569.33649.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset improves the idle-load balancer nomination logic, by taking
into consideration the system topology into consideration.

An idle-load balancer is an idle-cpu which does not turn off it's sched_ticks
and performs load-balancing on behalf of the other idle CPUs. Currently,
this idle load balancer is nominated as the first_cpu(nohz.cpu_mask)

The drawback of the current method is that the CPU numbering in the
cores/packages need not necessarily be sequential. For example, on a
two-socket, Quad core system, the CPU numbering can be as follows:

|-------------------------------|  |-------------------------------|
|               |               |  |               |               |
|     0         |      2        |  |     1         |      3        |
|-------------------------------|  |-------------------------------|
|               |               |  |               |               |
|     4         |      6        |  |     5         |      7        |
|-------------------------------|  |-------------------------------|

Now, the other power-savings settings such as the sched_mc/smt_power_savings
and the power-aware IRQ balancer try to balance tasks/IRQs by taking
the system topology into consideration, with the intention of keeping
as many "power-domains" (cores/packages) in the low-power state.

The current idle-load-balancer nomination does not necessarily align towards
this policy. For eg, we could be having tasks and interrupts largely running
on the first package with the intention of keeping the second package idle.
Hence, CPU 0 may be busy. The first_cpu in the nohz.cpu_mask happens to be CPU1,
which in-turn becomes nominated as the idle-load balancer. CPU1 being from
the 2nd package, would in turn prevent the 2nd package from going into a
deeper sleep state.

Instead the role of the idle-load balancer could have been assumed by an
idle CPU from the first package, thereby helping the second package go
completely idle.

This patchset has been tested with 2.6.29-tip-master on a Two-Socket
Quad core system with the topology as mentioned above.

|----------------------------------------------------------------------------|
|       With Patchset + sched_mc_power_savings = 1                           |
|----------------------------------------------------------------------------|
|make -j2 options| time taken |  LOC timer interrupts |  LOC timer interrupts|
|                |            |  on Package 0         |  on Package 1        |
|----------------------------------------------------------------------------|
|taskset -c 0,2  |            |  CPU0     | CPU2      | CPU1      |  CPU3    |
|                | 221.675s   |  55421    | 55530     | 587       |  579     |
|                |            |----------------------------------------------|
|                |            |  CPU4     | CPU6      | CPU5      |  CPU7    |
|                |            |  54335    | 642       | 734       |  533     |
|----------------------------------------------------------------------------|
|taskset -c 1,3  |            |  CPU0     | CPU2      | CPU1      |  CPU3    |
|                | 221.806s   |  1241     | 553       | 55566     |  55555   |
|                |            |----------------------------------------------|
|                |            |  CPU4     | CPU6      | CPU5      |  CPU7    |
|                |            |  567      | 632       | 54332     |  561     |
|----------------------------------------------------------------------------|

We see here that the idle load balancer is chosen from the package which is
busy. In the first case, it's CPU4 and in the second case it's CPU5.

|----------------------------------------------------------------------------|
|        Without Patchset + sched_mc_power_savings = 1                       |
|----------------------------------------------------------------------------|
|make -j2 options| time taken |  LOC timer interrupts |  LOC timer interrupts|
|                |            |  on Package 0         |  on Package 1        |
|----------------------------------------------------------------------------|
|taskset -c 0,2  |            |  CPU0     | CPU2      | CPU1      |  CPU3    |
|                | 221.727s   |  55100    | 55134     | 55134     |  14591   |
|                |            |----------------------------------------------|
|                |            |  CPU4     | CPU6      | CPU5      |  CPU7    |
|                |            |  1590     | 856       | 613       |  598     |
|----------------------------------------------------------------------------|
|taskset -c 1,3  |            |  CPU0     | CPU2      | CPU1      |  CPU3    |
|                | 221.500s   |  43444    | 12918     | 54766     |  55170   |
|                |            |----------------------------------------------|
|                |            |  CPU4     | CPU6      | CPU5      |  CPU7    |
|                |            |  653      | 777       | 1008      |  585     |
|----------------------------------------------------------------------------|

Here, we see that the idle load balancer is chosen from the other package,
despite choosing sched_mc_power_savings = 1. In the first case, we have
CPU1 and CPU3 sharing the responsibility among themselves. In the second case,
it's CPU0 and CPU2, which assume that role.

Thoughts ?

---

Gautham R Shenoy (2):
      sched: Nominate a power-efficient ilb in select_nohz_balancer()
      sched: Nominate idle load balancer from a semi-idle package.


 kernel/sched.c |  127 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 117 insertions(+), 10 deletions(-)

-- 
Thanks and Regards
gautham.

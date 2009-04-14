Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbZDNEzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbZDNEzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 00:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbZDNEzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 00:55:35 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:36169 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZDNEzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 00:55:35 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC PATCH v2 0/2] sched: Nominate a power-efficient ILB
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Balbir Singh" <balbir@in.ibm.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 14 Apr 2009 10:25:25 +0530
Message-ID: <20090414045356.7645.33369.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the second iteration of the patchset which aims at improving
the idle-load balancer nomination logic, by taking the system topology
into consideration.

Changes from v1 (found here: http://lkml.org/lkml/2009/4/2/246)
o Fixed the kernel-doc style comments.
o Renamed a variable to better reflect it's usage.

Background
======================================
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

This patchset has been tested with 2.6.30-rc1 on a Two-Socket
Quad core system with the topology as mentioned above.

|----------------------------------------------------------------------------|
|       With Patchset + sched_mc_power_savings = 1                           |
|----------------------------------------------------------------------------|
|make -j2 options| time taken |  LOC timer interrupts |  LOC timer interrupts|
|                |            |  on Package 0         |  on Package 1        |
|----------------------------------------------------------------------------|
|taskset -c 0,2  |            |  CPU0     | CPU2      | CPU1      |  CPU3    |
|                | 227.234s   |  56969    | 57080     | 1003      |  588     |
|                |            |----------------------------------------------|
|                |            |  CPU4     | CPU6      | CPU5      |  CPU7    |
|                |            |  55995    | 703       | 583       |  600     |
|----------------------------------------------------------------------------|
|taskset -c 1,3  |            |  CPU0     | CPU2      | CPU1      |  CPU3    |
|                | 227.136s   |  1109     | 611       | 57074     |  57091   |
|                |            |----------------------------------------------|
|                |            |  CPU4     | CPU6      | CPU5      |  CPU7    |
|                |            |  709      | 637       | 56133     |  587     |
|----------------------------------------------------------------------------|

We see here that the idle load balancer is chosen from the package which is
busy. In the first case, it's CPU4 and in the second case it's CPU5.

|----------------------------------------------------------------------------|
|       With Patchset + sched_mc_power_savings = 1                           |
|----------------------------------------------------------------------------|
|make -j2 options| time taken |  LOC timer interrupts |  LOC timer interrupts|
|                |            |  on Package 0         |  on Package 1        |
|----------------------------------------------------------------------------|
|taskset -c 0,2  |            |  CPU0     | CPU2      | CPU1      |  CPU3    |
|                | 228.786s   |  59094    | 61994     | 13984     |  43652   |
|                |            |----------------------------------------------|
|                |            |  CPU4     | CPU6      | CPU5      |  CPU7    |
|                |            |  1827     | 734       | 748       |  760     |
|----------------------------------------------------------------------------|
|taskset -c 1,3  |            |  CPU0     | CPU2      | CPU1      |  CPU3    |
|                | 228.435s   |  57013    | 876       | 58596     |  61633   |
|                |            |----------------------------------------------|
|                |            |  CPU4     | CPU6      | CPU5      |  CPU7    |
|                |            |  772      | 1133      | 850       |  910     |
|----------------------------------------------------------------------------|

Here, we see that the idle load balancer is chosen from the other package,
despite choosing sched_mc_power_savings = 1. In the first case, we have
CPU1 and CPU3 sharing the responsibility among themselves. In the second case,
it's CPU0 and CPU6, which assume that role.

---

Gautham R Shenoy (2):
      sched: Nominate a power-efficient ilb in select_nohz_balancer()
      sched: Nominate idle load balancer from a semi-idle package.


 kernel/sched.c |  145 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 135 insertions(+), 10 deletions(-)

-- 
Thanks and Regards
gautham.

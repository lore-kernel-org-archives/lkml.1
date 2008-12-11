Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbYLKRjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbYLKRjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 12:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbYLKRjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 12:39:09 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:60017 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbYLKRjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 12:39:08 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v5 0/7] Tunable sched_mc_power_savings=n
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Thu, 11 Dec 2008 23:12:07 +0530
Message-ID: <20081211173831.2020.57550.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The existing power saving loadbalancer CONFIG_SCHED_MC attempts to run
the workload in the system on minimum number of CPU packages and tries
to keep rest of the CPU packages idle for longer duration. Thus
consolidating workloads to fewer packages help other packages to be in
idle state and save power.  The current implementation is very
conservative and does not work effectively across different workloads.
Initial idea of tunable sched_mc_power_savings=n was proposed to
enable tuning of the power saving load balancer based on the system
configuration, workload characteristics and end user requirements.

The power savings and performance of the given workload in an under
utilised system can be controlled by setting values of 0, 1 or 2 to
/sys/devices/system/cpu/sched_mc_power_savings with 0 being highest
performance and least power savings and level 2 indicating maximum
power savings even at the cost of slight performance degradation.

Please refer to the following discussions and article for details.

[1]Making power policy just work
http://lwn.net/Articles/287924/ 

[2][RFC v1] Tunable sched_mc_power_savings=n
http://lwn.net/Articles/287882/
                                                                                                               
[3][RFC PATCH v2 0/7] Tunable sched_mc_power_savings=n                                                                                                   
http://lwn.net/Articles/297306/

[4][RFC PATCH v3 0/5] Tunable sched_mc_power_savings=n
http://lkml.org/lkml/2008/11/10/260

[5][RFC PATCH v4 0/7] Tunable sched_mc_power_savings=n
http://lkml.org/lkml/2008/11/21/47

The following series of patch demonstrates the basic framework for
tunable sched_mc_power_savings.

This version of the patch incorporates comments and feedback received
on the previous post.  Thanks to Peter Zijlstra and others for the
review and comments.

Changes from v4:
----------------

* Conditionally added SD_BALANCE_NEWIDLE flag to MC and CPU level
  domain to help task consolidation when sched_mc > 0
  Removing this flag significantly reduces the number load_balance
  calls and considerably slows down task consolidation and in effect
  power savings.

  Ingo and Mike Galbraith removed this flag to improve performance for
  select benchmarks.  I have added the flags only when power savings
  is requested and restore to full performance mode if sched_mc=0

* Fixed few whitespace issues
* Patch series against 2.6.28-rc8 kernel

Changes from v3:
----------------

* Fixed the locking code with double_lock_balance() in
  active-balance-newidle.patch

* Moved sched_mc_preferred_wakeup_cpu to root_domain structure so that
  each partitioned sched domain will get independent nominated cpu

* More comments in active-balance-newidle.patch

* Reverted sched MC level and CPU level fine tuning in v2.6.28-rc4 for
  now.  These affect consolidation since SD_BALANCE_NEWIDLE is
  removed.  I will rework the tuning in the next iteration to
  selectively enable them at sched_mc=2

* Patch series on 2.6.28-rc6 kernel  

Changes from v2:
----------------

* Fixed locking order issue in active-balance new-idle
* Moved the wakeup biasing code to wake_idle() function and preserve
  wake_affine function.  Previous version would break wake affine in
  order to aggressively consolidate tasks  
* Removed sched_mc_preferred_wakeup_cpu global variable and moved to
  doms_cur/dattr_cur and added a per_cpu pointer to appropriate
  storage in partitioned sched domain.  This changed is needed to
  preserve functionality in case of partitioned sched domains
* Patch on 2.6.28-rc3 kernel  

Results:
--------

Basic functionality of the code has not changed and the power vs
performance benefits for kernbench are similar to the ones posted
earlier.

KERNBENCH Runs: make -j4 on a x86 8 core, dual socket quad core cpu
package system

SchedMC Run Time     Package Idle    Energy  Power
0	81.28	     52.43% 53.53%  1.00x J 1.00y W
1	80.71	     37.35% 68.91%  0.96x J 0.97y W
2	76.05	     23.81% 82.65%  0.92x J 0.98y W

*** This is RFC code and not for inclusion ***

Please feel free to test, and let me know your comments and feedback.

Thanks,
Vaidy

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

---

Gautham R Shenoy (1):
      sched: Framework for sched_mc/smt_power_savings=N

Vaidyanathan Srinivasan (6):
      sched: idle_balance() does not call load_balance_newidle()
      sched: add SD_BALANCE_NEWIDLE at MC and CPU level for sched_mc>0
      sched: activate active load balancing in new idle cpus
      sched: bias task wakeups to preferred semi-idle packages
      sched: nominate preferred wakeup cpu
      sched: favour lower logical cpu number for sched_mc balance


 include/linux/sched.h    |   21 +++++++++++
 include/linux/topology.h |    6 ++-
 kernel/sched.c           |   88 +++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched_fair.c      |   17 +++++++++
 4 files changed, 124 insertions(+), 8 deletions(-)

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYKJSdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYKJSdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbYKJSdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:33:01 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:49544 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbYKJSdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:33:00 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 0/5] Tunable sched_mc_power_savings=n
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
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Tue, 11 Nov 2008 00:02:54 +0530
Message-ID: <20081110181526.562.69941.stgit@drishya.in.ibm.com>
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

The following series of patch demonstrates the basic framework for
tunable sched_mc_power_savings.

This version of the patch incorporates comments and feedback received
on the previous post.  Thanks to Peter Zijlstra for the review and
comments.

Changes from v2:
----------------

* Fixed locking order issue in active-balance-new-idle
* Moved the wakeup biasing code to wake_idle() function and preserve
  wake_affine function.  Previous version would break wake_affine in
  order to aggressively consolidate tasks  
* Removed sched_mc_preferred_wakeup_cpu global variable and moved to
  doms_cur/dattr_cur and added a per_cpu pointer to appropriate
  storage in partitioned sched domain.  This changed is needed to
  preserve functionality in case of partitioned sched domains
* Patch on 2.6.28-rc3 kernel  

Notes:
------

* The patch has been tested on x86 with basic cpusets and kernbench.  
  Correct functionality in the case of partitioned sched domain need 
  to be analysed.

Results:
--------

Basic functionality of the code has not changed and the power vs
performance benefits for kernbench are similar to the ones posted
earlier.

KERNBENCH Runs: make -j4 on a x86 8 core, dual socket quad core cpu
package system

SchedMC Run Time     Package Idle    Energy  Power
0	81.61s       53.07% 52.81%  1.00x J 1.00y W
1	81.52s       40.83% 65.45%  0.96x J 0.96y W 
2	74.66s       22.20% 83.94%  0.90x J 0.98y W

*** This is RFC code and not for inclusion ***

Please feel free to test, and let me know your comments and feedback.

Thanks,
Vaidy

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

---

Gautham R Shenoy (1):
      sched: Framework for sched_mc/smt_power_savings=N

Vaidyanathan Srinivasan (4):
      sched: activate active load balancing in new idle cpus
      sched: bias task wakeups to preferred semi-idle packages
      sched: nominate preferred wakeup cpu
      sched: favour lower logical cpu number for sched_mc balance


 include/linux/sched.h |   12 +++++++
 kernel/sched.c        |   89 ++++++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched_fair.c   |   17 +++++++++
 3 files changed, 112 insertions(+), 6 deletions(-)

-- 

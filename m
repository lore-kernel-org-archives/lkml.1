Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbZEMNLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbZEMNLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZEMNLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:11:14 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37199 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZEMNLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:11:13 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 0/2] Saving power by cpu evacuation
	sched_max_capacity_pct=n
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 13 May 2009 18:41:00 +0530
Message-ID: <20090513130541.21440.33364.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The idea of extending sched_mc_powersavings tunable for cpu evacuation
was discussed at http://lwn.net/Articles/330309/ 

The summary of the discussion is as follows:

* Using sched_mc=3,4,5 to evacuate 1,2,4 cores is completely
  non-intuitive and broken interface.  Ingo wanted to see if we can
  model a global percentile tunable that would map to core throttling.

* Peter Zijlstra wanted more justifications for throttling at the core
  level.  Throttling may be a resource management problem rather than
  scheduler/load balancer

* CPU hotplug and cpuset/cgroup based cpu throttling are viable
  alternatives to this approach.  

Changes in v2:

* Created a percentage knob sched_max_capacity_pct=n
  Defaults to 100, can be set to 75 or 50 to evacuate cores

* This patch is still a hack for discussion and has many
  limitations.

v1: http://lkml.org/lkml/2009/4/26/202

Into and parts from previous post for quick reference:
------------------------------------------------------

Objective:
----------

* Framework to evacuate tasks from cpus in order to force the cpu
  cores to stay at idle.  Forcefully idling cores and packages can
  reduce power consumption.

* Fast response time and low OS overhead to moved tasks away from
  selected cpu packages.  CPU hotplug is too heavyweight for this
  purpose

Use cases:
---------

* Ability to throttle the number of cores used in the system along
  with other power saving controls like cpufreq governors can enable
  the system to operate at a more power efficient operating point and
  still meet the design objectives.
 
* Facilitate thermal management by evacuating cores from hot cpu
  packages

Alternatives:
-------------

* CPU hotplug: Heavy weight and slow.  Setting up and tear down of
  data structures involved.  May need new fast or light weight
  notifications

* CPUSets: Exclusive CPU sets and partitioned sched domains involve
  rebuilding sched domains and relatively heavy weight for the purpose

The following patch is against 2.6.30-rc5 and will work only in an
under utilised system (No of tasks <= number of cores).

Test results for ebizzy 8 threads at various sched_max_capacity_pct
settings. The test platform is dual socket quad core x86 system
(pre-Nehalem).

This is an interesting characteristics of the ebizzy benchmark where
the following command line improved in performance as we evacuated
cores!  Perhaps cross-cache traffic... I will verify that next time.

ebizzy -s 4096 -t 8 -S 30

sched_mc_power_savings was set to 2 in the experiment

-----------------------------------------------------------------
sched_max_capacity_pct	No Cores	Performance	AvgPower	
			used		Records/sec	(Watts)
-----------------------------------------------------------------
100			8		1.00x		1.00y
 87			7		1.03x		0.98y
 75			6		1.06x		0.95y
 62			5		1.26x		0.91y
 50			4		1.15x		0.86y
-----------------------------------------------------------------
		
There were wide run variation with ebizzy.  The purpose of the above
data is to justify use of core evacuation for power vs performance
trade-offs.  The patch does not yet work for kernbench and other
complex workloads/benchmarks. I even tried SPECjbb and did not get the
expected CPU utilisation at various settings to reduce power
consumption.  The utilisation/power was much lower than expected.

ToDo:
-----

* Identify good benchmark to demonstrate benefits of cpu evacuation

* Make the core evacuation predictable under different system load
  conditions and workload characteristics.  This is turning out to be
  a major challenge in this approach.

* Enhance framework to control which particular packages/cores will be
  evacuated, this is needed for thermal management.  The
  CPU hotplug/cpuset approach will solve this problem.

I can experiment with different benchmarks/platforms and post results
while the framework is being discussed.

Please let me know you comments and suggestions.

Thanks,
Vaidy

---

Vaidyanathan Srinivasan (2):
      sched: loadbalancer hacks for forced packing of tasks
      sched: add sched_max_capacity_pct


 kernel/sched.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 64 insertions(+), 1 deletions(-)


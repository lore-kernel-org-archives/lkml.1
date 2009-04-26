Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZDZUqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZDZUqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 16:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZDZUq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 16:46:26 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:43241 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbZDZUqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 16:46:24 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 0/3] Saving power by cpu evacuation using sched_mc=n
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
Date: Mon, 27 Apr 2009 02:16:32 +0530
Message-ID: <20090426204029.17495.46609.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The sched_mc_powersavings tunable can be set to {0,1,2} to enable
aggressive task consolidation to less number of cpu packages and save
power.  Under certain conditions, sched_mc=2 may provide better
performance in a underutilised system by keeping the group of tasks on
a single cpu package facilitating cache sharing and reduced off-chip
traffic.

Extending this concept further, the following patch series tries to
implement sched_mc={3,4,5} where CPUs/cores are forced to be idle and
thereby save power at the cost of performance.  Some of the cpu
packages in the system are overloaded with tasks while other packages
can have free cpus.  This patch is a hack to discuss the idea and
requirements.

Objective:
----------

* Framework to evacuate tasks from cpus in order to force the cpu
  cores to stay at idle

* Interrupts can be moved using user space irqbalancer daemons, while
  timer migration framework is being discussed:
  http://lkml.org/lkml/2009/4/16/45

* Forcefully idling cpu cores in a system will reduce the power
  consumption of the system and also cool cpu packages for thermal 
  management

Requirements:
------------

* Fast response time and low OS overhead to moved tasks away from
  selected cpu packages.  CPU hotplug is too heavyweight for this
  purpose

Use cases:
---------

* Enabling the right number of cpus to run the given workload can
  provide good power vs performance tradeoffs.

* Ability to throttle the number of cores uses in the system along
  with other power saving controls like cpufreq governors can enable
  the system to operate at a more power efficient operating point and
  still meet the design objectives.
 
* Facilitate thermal management by evacuating cores from hot cpu packages

Alternatives:
-------------

* CPU hotplug: Heavy weight and slow.  Setting up and tear down of
  data structures involved.  May need new fast or light weight
  notifications

* CPUSets: Exclusive CPU sets and partitioned sched domains involve
  rebuilding sched domains and relatively heavy weight for the purpose

The following patch is against 2.6.30-rc3 and will work only in
an under utilised system (Tasks <= number of cores).

Test results for ebizzy 8 threads at various sched_mc settings has been 
summarised with relative values below. The test platform is dual socket 
quad core x86 system (pre-Nehalem).

--------------------------------------------------------
sched_mc	No Cores	Performance	AvgPower	
		used		Records/sec	(Watts)
--------------------------------------------------------
0		8		1.00x		1.00y
1		8		1.02x		1.01y
2		8		0.83x		1.01y
3		7		0.86x		0.97y
4		6		0.76x		0.92y
5		4		0.72x		0.82y
--------------------------------------------------------
		
There were wide run variation with ebizzy.  The purpose of the above
data is to justify use of core evacuation for power vs performance
trade-offs.

ToDo:
-----

* Make the core evacuation predictable under different system load
  conditions and workload characteristics
* Enhance framework to control which packages/cores will be
  evacuated, this is needed for thermal management

I can experiment with different benchmarks/platforms and post results
while the framework is being discussed.

Please let me know you comments and suggestions.

Thanks,
Vaidy

---

Vaidyanathan Srinivasan (3):
      sched: loadbalancer hacks for forced packing of tasks
      sched: threshold helper functions
      sched: add more levels of sched_mc


 include/linux/sched.h |    4 ++++
 kernel/sched.c        |   35 ++++++++++++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 1 deletions(-)

-- 

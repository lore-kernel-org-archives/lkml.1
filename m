Return-Path: <linux-kernel-owner+w=401wt.eu-S1752594AbYIHNMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbYIHNMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYIHNMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:12:24 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:33287 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYIHNMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:12:23 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 0/7] Tunable sched_mc_power_savings=n
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Mon, 08 Sep 2008 18:44:39 +0530
Message-ID: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
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

Please refer to the following discussions and article for details.

Making power policy just work
http://lwn.net/Articles/287924/ 
[RFC v1] Tunable sched_mc_power_savings=n
http://lwn.net/Articles/287882/

The following series of patch demonstrates the basic framework for
tunable sched_mc_power_savings.

The power savings and performance of the given workload in an under
utilised system can be controlled by setting values of 0, 1 or 2 to
/sys/devices/system/cpu/sched_mc_power_savings with 0 being highest
performance and least power savings and level 2 indicating maximum
power savings even at the cost of slight performance degradation.

enum powersavings_balance_level {
	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
	POWERSAVINGS_BALANCE_BASIC,	/* Fill one thread/core/package 
					 * first for long running threads 
					 */ 
	POWERSAVINGS_BALANCE_WAKEUP,	/* Also bias task wakeups to semi-idle
					 * cpu package for power savings
					 */
	MAX_POWERSAVINGS_BALANCE_LEVELS
};

sched_mc_power_savings values of 0 and 1 are implemented and available
in the default kernel.  The new level of 2 support task wakeup biasing
that helps in consolidating very short running bursty jobs in an
almost idle system.  This level of task consolidation packs most
workloads to one cpu package and extends the tickless idle time for
unused cpu packages.

Changes from default kernels's power save balance implementation:

* Nominate wakeup cpu during power saving load balance operation
* Use the nominated cpu for power efficient wakeup cpu selection
* Perform active load balance for newly idle cpu for aggressive task
  consolidation.
* This patch is against 2.6.27-rc5 with two fixes for basic
  sched_mc_power_saving balance bugs in mainline kernel. (They have
  already been independently posted in LKML)

Results:
--------

sched_mc_power_saving=2 is expected to provide power and/or energy
savings when the overall system utilisation is less than ~50%.  At
higher system utilisation in the case of a small two socket system, the
opportunity for power savings decrease and hence this level may not
provide any further benefit compared to sched_mc_power_saving=1.

KERNBENCH Runs: make -j4 on a x86 8 cpu, dual socket quad core cpu
package

SchedMC Run Time     Package Idle    Energy  Power
0	76.88s      51.634% 53.809%  1.00x J 1.00y W
1	78.50s      42.020% 64.687%  0.97x J 0.95y W 
2	73.31s      17.305% 87.765%  0.92x J 0.97y W

The above test run has normalised power and energy values for
a 4 job make on an 8 cpu system.  Typical system utilisation will be
~50%.  The package idle percentage are the idle time of each of the
quad core cpu package in the test system.  Energy and average power
for the test duration has been measured and normalised.

sched_mc=0 is the baseline reference run.  In this particular system
setup, sched_mc=1 actually degraded performance by making the jobs
jump cpus.  While sched_mc=2 was able to consolidate better due to
task wakeup biasing and thereby improving performance for this
particular test.  sched_mc=2 wins by least energy and maximum
performance.  The average power is higher than sched_mc=1 (but still
less than baseline run) because the ondemand governor would have
increased the cpu frequency based on utilisation. The cpu package idle
percentage given an indication of the level of consolidation that was
obtained.  This info is from /proc/stat snapshot on all cpus and
averaged for all cores in a package (after taking care of topology). 

SPECjbb runs: 2 warehouse on x86 8 cpu, dual socket quad core cpu
package, average system utilisation around ~25%

SchedMC SPECjbb OPS     Watts   
0	1.00x		1.00y	
1	0.98x		0.98y	
2	0.95x		0.95y	

We can see a linear reduction in performance and average power
consumed.  sched_mc tunable can be used to trade performance for
average power consumed for this workload.

However the results are not as good for 4 warehouse in the same system
where the system utilisation is slightly above 50%
SchedMC	SPECjbb ops	 Package Idle	Power
0	1.00x		48.483% 51.306%	1.00z
1	0.92x		21.398% 79.095% 0.93z
2	0.84x		28.778% 93.282% 0.92z

There is significant reduction in performance for a marginal 1%
reduction in power for sched_mc=2.

These results are illustrative of basic idea and possibilities with the
tunable sched_mc_power_savings settings.  More work needs to be done
to tune the various heuristics for different workloads.  The power and
performance tradoffs are machine configuration dependent and hence
more experimentation is needed in order to get the correct design.

Processor power saving features like deep sleep states on server
processors will significantly improve power savings (proportional to
package idle time).  This technique is primarily intended for multi
socket systems with multi-core cpus where the power (voltage) control
is at a per socket level.

I will post more experimental data for different workloads and
benchmarks.  

Please let me know your comments and suggestions.

Thanks,
Vaidy
---

Gautham R Shenoy (2):
      sched: Framework for sched_mc/smt_power_savings=N
      sched: Fix __load_balance_iterator() for cfq with only one task.

Max Krasnyansky (1):
      sched: arch_reinit_sched_domains() must destroy domains to force rebuild

Vaidyanathan Srinivasan (4):
      sched: activate active load balancing in new idle cpus
      sched: bias task wakeups to preferred semi-idle packages
      sched: nominate preferred wakeup cpu
      sched: favour lower logical cpu number for sched_mc balance


 include/linux/cpuset.h |    2 +
 include/linux/sched.h  |   11 +++++++
 kernel/sched.c         |   79 +++++++++++++++++++++++++++++++++++++++++-------
 kernel/sched_fair.c    |   15 +++++++++
 4 files changed, 94 insertions(+), 13 deletions(-)

-- 

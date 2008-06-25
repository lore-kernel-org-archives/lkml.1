Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbYFYTJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbYFYTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYFYTJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:09:18 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:50675 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753419AbYFYTJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:09:16 -0400
Date: Thu, 26 Jun 2008 00:41:00 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC v1] Tunable sched_mc_power_savings=n
Message-ID: <20080625191100.GI21892@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Dipankar Sarma <dipankar@in.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The existing power saving loadbalancer CONFIG_SCHED_MC attempts to run
the workload in the system on minimum number of CPU packages and tries
to keep rest of the CPU packages idle for longer duration. Thus
consolidating workloads to fewer packages help other packages to be in
idle state and save power.

echo 1 > /sys/devices/system/cpu/sched_mc_power_savings is used to
turn on this feature.

When enabled, this tunable would influence the loadbalancer decision
in find_busiest_group().  Two parameters are extracted at the this
time.  group_leader is the group that is almost full and has just
enough capacity to pull few (one) tasks while group_min is the group
that has too few tasks and if we can move them to group_leader, then
this group can go completely idle.

The default criteria to select group_leader and group_min would catch
long running threads on various packages and pull them to single
package.  The group_capacity limits the number of tasks that is being
pulled and we are expected to have one task per core in a package and
all the core in a package are loaded.

This default criteria for selection when sched_mc_power_savings=1 has
a good balance of power savings and least performance impact.  The
conservative approach taken towards consolidation makes the selection
criteria workload dependent.  Long running steady state workloads are
placed correct, but not bursty workload.  

The idea being proposed is to enhance the tunable with varied degrees
of consolidation that can work best for different workload
characteristics.  echo 2 > /sys/.../sched_mc_power_savings could
enable more aggressive consolidation than the default.

I am presently working on different criteria that can help consolidate
different types of workload with varied degrees of power savings and
performance impact.  

Advantages:

* Enterprise workloads on large hardware configurations may need
  aggressive consolidation strategy
* Performance impact on server is different from desktop or laptops.
  Interactivity is less of a concern on large enterprise servers while
  workload response times and performance per watt is more significant
* Aggressive power savings even with marginal performance penalty is
  is a useful tunable for servers since it may provide good
  performance-per-watt at low utilisation
* This tunable can influence other parts of scheduler like wakeup
  biasing for overall task consolidation  

Proposed changes:

* Add more values to sched_mc_power_savings tunable (bit flags?)
* Enable different consolidation strategy based on the value
* Evaluate different strategy against different workloads and design
  heuristics for auto tuning
* Modify selection of group_leader by changing the spare capacity
  evaluation 
* Increase group capacity of the group leader to avoid pulling tasks
  away from group_leader within a short time
* Choose different load_idx while evaluating and selecting the load
* Use the sched_mc_power_savings settings outside of load balancer
  like in task wakeup biasing
* Design power saving loadbalancer in combination with process wakeup
  biasing in order to consolidate bursty and short running jobs to
  less CPU packages in an idle or under-utilised system.

Disadvantages:

* More tunable settings will lead to sub-optimal performance if not
  exploited correctly.  Once the tunable criteria is established and
  we have good heuristics, we can have a default setting that can
  automatically choose the right technique.

I will send the changes in criteria and their impact in subsequent
RFCs.  I would like to solicit feedback on the overall idea and inputs
from people who have already attempted similar changes.

Thanks,
Vaidy



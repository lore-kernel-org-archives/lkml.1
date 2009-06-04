Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZFDFiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZFDFiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbZFDFhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:37:50 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42928 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbZFDFhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:37:48 -0400
Date: Thu, 4 Jun 2009 11:06:49 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: [RFC] CPU hard limits
Message-ID: <20090604053649.GA3701@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an RFC about the CPU hard limits feature where I have explained
the need for the feature, the proposed plan and the issues around it.
Before I come up with an implementation for hard limits, I would like to
know community's thoughts on this scheduler enhancement and any feedback
and suggestions.

Regards,
Bharata.

1. CPU hard limit
2. Need for hard limiting CPU resource
3. Granularity of enforcing CPU hard limits
4. Existing solutions
5. Specifying hard limits
6. Per task group vs global bandwidth period
7. Configuring
8. Throttling of tasks
9. Group scheduler hierarchy considerations
10. SMP considerations
11. Starvation
12. Hard limit and fairness

1. CPU hard limit
-----------------
CFS is a proportional share scheduler which tries to divide the CPU time
proportionately between tasks or groups of tasks (task group/cgroup) depending
on the priority/weight of the task or shares assigned to groups of tasks.
In CFS, a task/task group can get more than its share of CPU if there are
enough idle CPU cycles available in the system, due to the work conserving
nature of the scheduler.

However there are scenarios (Sec 2) where giving more than the desired
CPU share to a task/task group is not acceptable. In those scenarios, the
scheduler needs to put a hard stop on the CPU resource consumption of
task/task group if it exceeds a preset limit. This is usually achieved by
throttling the task/task group when it fully consumes its allocated CPU time.

2. Need for hard limiting CPU resource
--------------------------------------
- Pay-per-use: In enterprise systems that cater to multiple clients/customers
  where a customer demands a certain share of CPU resources and pays only
  that, CPU hard limits will be useful to hard limit the customer's job
  to consume only the specified amount of CPU resource.
- In container based virtualization environments running multiple containers,
  hard limits will be useful to ensure a container doesn't exceed its
  CPU entitlement.
- Hard limits can be used to provide guarantees.

3. Granularity of enforcing CPU hard limits
-------------------------------------------
Conceptually, hard limits can either be enforced for individual tasks or
groups of tasks.  However enforcing limits per task would be too fine
grained and would be a lot of work on the part of the system administrator
in terms of setting limits for every task. Based on the current understanding
of the users of this feature,  it is felt that hard limiting is more useful
at task group level than the individual tasks level. Hence in the subsequent
paragraphs, the concept of hard limit as applicable to task group/cgroup
is discussed.

4. Existing solutions
---------------------
- Both Linux-VServer and OpenVZ virtualization solutions support CPU hard
  limiting.
- Per task limit can be enforced using rlimits, but it is not rate based.

5. Specifying hard limits
-------------------------
CPU time consumed by a task group is generally measured over a
time period (called bandwidth period) and the task group gets throttled
when its CPU time reaches a limit (hard limit) within a bandwidth period.
The task group remains throttled until the bandwidth period gets
renewed at which time additional CPU time becomes available
to the tasks in the system.

When a task group's hard limit is specified as a ratio X/Y, it means that
the group will get throttled if its CPU time consumption exceeds X seconds
in a bandwidth period of Y seconds.

Specifying the hard limit as X/Y requires us to specify the bandwidth
period also.

Is having a uniform/same bandwidth period for all the groups an option ?
If so, we could even specify the hard limit as a percentage, like
30% of a uniform bandwidth period.

6. Per task group vs global bandwidth period
--------------------------------------------
The bandwidth period can either be per task group or global. With global
bandwidth period, the runtimes of all the task groups need to be
replenished when the period ends. Though this appears conceptually simple,
the implementation might not scale. Instead if every task group maintains its
bandwidth period separately, the refresh cycles of each group will happen
independent of each other. Moreover different groups might prefer different
bandwidth periods. Hence the first implementation will have per task group
bandwidth period.

Timers can be used to trigger bandwidth refresh cycles. (similar to rt group
sched)

7. Configuring
--------------
- User could set the hard limit (X and/or Y) through the cgroup fs.
- When the scheduler supports hard limiting, should it be enabled
  for all tasks groups of the system ? Or should user have an option
  to enable hard limiting per group ?
- When hard limiting is enabled for a group, should the limit be
  set to a default to start with ? Or should the user set the limit
  and the bandwidth before enabling the hard limiting ?
- What should be a sane default value for the bandwidth period ?

8. Throttling of tasks
----------------------
Task group can be taken off the runqueue when it hits the limit and enqueued
back when the bandwidth period is refreshed. This method would require us to
maintain the throttled tasks list separately for every group.

Under heavy throttling, there could be tasks being dequeued and enqueued
back at bandwidth refresh times leading to frequent variations in the
runqueue load. This might unduly stress the load balancer.

Note: A group (entity) can't be dequeued unless all tasks under it are
dequeued. So there can be false/failed attempts to run tasks of a throttled
group until all the tasks from the throttled group are dequeued.

9. Group scheduler hierarchy considerations
-------------------------------------------
Since the group scheduler is hierarchical in nature, should there be any
relation between the hard limit values of the parent task group
and the values of its child groups ? Should the hard limit values set for
child groups be compatible with the parent's hard limit ? For eg, consider
a group A having hard limit as X/Y has two children A1 and A2. Should the
limits for A1 (X1/Y) and A2 (X2/Y) be set so that X1/Y+X2/Y <= X/Y ?

Or should child groups set their limits independently of parent ? In this
case, even if the child still has CPU time left before it hits the limit,
it could get throttled because its parent got throttled. I would think that
this method will lead to easier implementation.

AFAICS, rt group scheduler needs EDF to support different bandwidth periods
for different groups (Ref: Documentation/scheduler/sched-rt-group.txt). I
don't think the same requirement is applicable to non-rt groups. This is
because with hard limits we are not guaranteeing the CPU time for a group,
instead we are just specifying the max time which a group can run within a
bandwidth period.

10. SMP considerations
----------------------
Hard limits could be enforced for the system as a whole or for individual
CPUS.

When it is enforced per CPU, a task group on a CPU will be throttled if
it reaches its hard limit on that CPU. This can lead to unfairness if
the same task group on other CPUs has runtimes still left and it is not
being utilized.

If enforced system wide, then a task group will be throttled when sum of the
run times of its tasks running on different CPUs reach the limit.

Could we use a hybrid method where a task group that reaches its limit on a CPU
could draw the group bandwidth from another CPU where there are no runnable
tasks belonging to that group ?

RT group scheduling borrows runtime from other CPUs when runtimes are balanced.

11. Starvation
---------------
When a task group that holds a shared resource (like a lock) is throttled,
another group which needs the same shared resource will not be able to
make progress even when the CPU has idle cycles to spare. This will lead
to starvation and unfairness. This situation could be avoided by some of
the methods like

- Disabling throttling when a group is holding a lock.
- Inheriting runtime from the group which faces starvation.

The first implementation will not address this problem of starvation.

12. Hard limits and fairness
----------------------------
Hard limits are set independent of group shares. The hard limit setting
by the user may be such that it may not be possible for the scheduler to
meet fairness and also enforce hard limits. Hard limiting takes precedence.

Return-Path: <linux-kernel-owner+w=401wt.eu-S934423AbZFPFi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934423AbZFPFi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbZFPFip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:38:45 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:43496 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785AbZFPFin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:38:43 -0400
Subject: [RFD PATCH 0/4] cpu: Bulk CPU Hotplug support.
To: linux-kernel@vger.kernel.org
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Balbir Singh <balbir@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Paul E McKenney <paulmck@us.ibm.com>, Nathan Lynch <ntl@pobox.com>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Date: Tue, 16 Jun 2009 11:08:39 +0530
Message-ID: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

(NOTE: This is an RFD. Patches are not for inclusion)

The current CPU-Hotplug infrastructure enables us to hotplug one CPU at any
given time. However, with newer machines which have multiple-cores and
multi-threads, it makes much sense to change the unit of hotplug to a core or
a package. We might want to evacuate a core or a package to reduce the avg
power/to manage the temperature of the system/to dynamically provision
cores/packages to a running system. But performing a series of CPU-Hotplug
is relatively slower.

Currently on a ppc64 box with 16 CPUs, the time taken for
a individual cpu-hotplug operation is as follows.

	# time echo 0 > /sys/devices/system/cpu/cpu2/online
	real    0m0.025s
	user    0m0.000s
	sys     0m0.002s

	# time echo 1 > /sys/devices/system/cpu/cpu2/online
	real    0m0.021s
	user    0m0.000s
	sys     0m0.000s

(The online time used to be ~200ms. It has been reduced after applying patch 1
of the series which reduces the polling interval from 200ms to 1ms.)

Of the this, the time taken for sending the notifications and performing
the actual cpu-hotplug operation (detailed profile is appended at the end of
the text) is:

	12.645925 ms on the offline path.
	21.019581 ms on the online path.

(The 10ms discrepancy that we observe in the total time taken for cpu-offline
Vs the time accounted for notifiers and cpu-hotplug operation is because of a
synchronize_sched() performed after clearing the active_cpu_mask.)

So, of the accounted time, a major chunk of time is consumed by
cpuset_track_online_cpus() while handling CPU_DEAD and CPU_ONLINE
notifications.

	11.320205 ms: cpuset_track_online_cpus      : CPU_DEAD
	12.767882 ms: cpuset_track_online_cpus      : CPU_ONLINE

cpuset_trace_online_cpus() among other things performs the task of rebuilding
the sched_domains for every online CPU in the system.

The operations performed within the cpuset_track_online_cpus()
depends only on the cpu_online_map and not on the CPU which has been
hotplugged. The other notifiers which behave similarly are
 - ratelimit_handler(),
 - vmstat_cpuup_callback()
 - vmscan: cpu_callback()

Thus if we bunch up multiple cpu-offlines/onlines, we can reduce the overall
time taken by optimizing notifiers such as these, so that they can
perform the necessary functions only once, after the completion of the
CPU-Hotplug operation. This would cut down the CPU hotplug time substantially.

The whole approach would require the Cpu-Hotplug notifiers to work on
cpumask_t instead of cpu. A similar proposal has been once proposed before by
Shaohua Li (http://lkml.org/lkml/2006/5/8/18)

In this patch series, we extend the existing cpu online/offline
interface to enable the user to offline/online a bunch of CPUs
at the same time.

The proposed interface to do so are the sysfs file:
	/sys/devices/system/cpu/online
	/sys/devices/system/cpu/online

The usage is:
	echo 4,6,7 > /sys/devices/system/cpu/offline
	echo 5 > /sys/devices/system/cpu/offline
	echo 4-7 > /sys/devices/system/cpu/online

As of now, this patch series does no optimizations to the CPU-Hotplug core
but serially hotplugs the CPUs in the list provided by the user.

The interface provided in this patch series has been tested on a
16-way ppc64 box.


Still TODO:
- Enhance the subsystem notifiers to work on a cpumask_var_t instead of a cpu
  id.

- Optimize the subsystem notifiers to reduce the time consumed while
  handling CPU_[DOWN_PREPARE/DEAD/UP_PREPARE/ONLINE] events for the
  cpumask_var_t.

- Define the Rollback Semantics for the notifiers which fail to handle
  a CPU_* event correctly.

- Send the kobject-events for the corresponding device entries of each of the
  CPUs present in the list to maintain ABI compatibility.

Any feedback is much appreciated

---

Gautham R Shenoy (4):
      cpu: measure time taken by subsystem notifiers during cpu-hotplug
      cpu: Define new functions cpu_down_mask and cpu_up_mask
      cpu: sysfs interface for hotplugging bunch of CPUs.
      powerpc: cpu: Reduce the polling interval in __cpu_up()


 arch/powerpc/kernel/smp.c      |    5 +-
 drivers/base/cpu.c             |   76 ++++++++++++++++++++++++++++--
 include/linux/cpu.h            |    2 +
 include/trace/notifier_trace.h |   32 ++++++++++++
 kernel/cpu.c                   |  103 ++++++++++++++++++++++++++++++----------
 kernel/notifier.c              |   23 +++++++--
 6 files changed, 203 insertions(+), 38 deletions(-)
 create mode 100644 include/trace/notifier_trace.h

--
Thanks and Regards
gautham


****************** Cpu-Hotplug profile ********************************

=============================================================================
statistics for CPU_DOWN_PREPARE
=============================================================================
      379 ns: buffer_cpu_notify             : CPU_DOWN_PREPARE
      457 ns: topology_cpu_callback         : CPU_DOWN_PREPARE
      504 ns: flow_cache_cpu                : CPU_DOWN_PREPARE
      517 ns: cpu_callback                  : CPU_DOWN_PREPARE
      533 ns: hotplug_cfd                   : CPU_DOWN_PREPARE
      546 ns: dev_cpu_callback              : CPU_DOWN_PREPARE
      547 ns: timer_cpu_notify              : CPU_DOWN_PREPARE
      562 ns: page_alloc_cpu_notify         : CPU_DOWN_PREPARE
      564 ns: cpuset_track_online_cpus      : CPU_DOWN_PREPARE
      594 ns: blk_cpu_notify                : CPU_DOWN_PREPARE
      623 ns: hotplug_hrtick                : CPU_DOWN_PREPARE
      623 ns: radix_tree_callback           : CPU_DOWN_PREPARE
      715 ns: remote_softirq_cpu_notify     : CPU_DOWN_PREPARE
      777 ns: rb_cpu_notify                 : CPU_DOWN_PREPARE
      777 ns: sysfs_cpu_notify              : CPU_DOWN_PREPARE
      807 ns: rcu_cpu_notify                : CPU_DOWN_PREPARE
      820 ns: ratelimit_handler             : CPU_DOWN_PREPARE
      822 ns: pageset_cpuup_callback        : CPU_DOWN_PREPARE
      898 ns: cpu_callback                  : CPU_DOWN_PREPARE
      898 ns: relay_hotcpu_callback         : CPU_DOWN_PREPARE
      929 ns: hrtimer_cpu_notify            : CPU_DOWN_PREPARE
      930 ns: cpu_callback                  : CPU_DOWN_PREPARE
     1096 ns: cpu_numa_callback             : CPU_DOWN_PREPARE
     1096 ns: percpu_counter_hotcpu_callback: CPU_DOWN_PREPARE
     1111 ns: slab_cpuup_callback           : CPU_DOWN_PREPARE
     1139 ns: update_runtime                : CPU_DOWN_PREPARE
     1143 ns: rcu_barrier_cpu_hotplug       : CPU_DOWN_PREPARE
     2725 ns: workqueue_cpu_callback        : CPU_DOWN_PREPARE
     2852 ns: migration_call                : CPU_DOWN_PREPARE
     4497 ns: vmstat_cpuup_callback         : CPU_DOWN_PREPARE
=========================================================================
Total time for CPU_DOWN_PREPARE = .030481000 ms
=========================================================================
=============================================================================
statistics for CPU_DYING
=============================================================================
      349 ns: cpu_callback                  : CPU_DYING
      349 ns: hotplug_hrtick                : CPU_DYING
      349 ns: remote_softirq_cpu_notify     : CPU_DYING
      351 ns: timer_cpu_notify              : CPU_DYING
      363 ns: vmstat_cpuup_callback         : CPU_DYING
      364 ns: rb_cpu_notify                 : CPU_DYING
      365 ns: blk_cpu_notify                : CPU_DYING
      365 ns: cpu_callback                  : CPU_DYING
      365 ns: cpu_numa_callback             : CPU_DYING
      365 ns: cpuset_track_online_cpus      : CPU_DYING
      365 ns: dev_cpu_callback              : CPU_DYING
      365 ns: hotplug_cfd                   : CPU_DYING
      365 ns: page_alloc_cpu_notify         : CPU_DYING
      365 ns: radix_tree_callback           : CPU_DYING
      365 ns: relay_hotcpu_callback         : CPU_DYING
      365 ns: topology_cpu_callback         : CPU_DYING
      365 ns: update_runtime                : CPU_DYING
      366 ns: pageset_cpuup_callback        : CPU_DYING
      367 ns: sysfs_cpu_notify              : CPU_DYING
      378 ns: flow_cache_cpu                : CPU_DYING
      380 ns: rcu_cpu_notify                : CPU_DYING
      381 ns: buffer_cpu_notify             : CPU_DYING
      381 ns: cpu_callback                  : CPU_DYING
      383 ns: slab_cpuup_callback           : CPU_DYING
      455 ns: ratelimit_handler             : CPU_DYING
      502 ns: workqueue_cpu_callback        : CPU_DYING
      699 ns: percpu_counter_hotcpu_callback: CPU_DYING
     1370 ns: rcu_barrier_cpu_hotplug       : CPU_DYING
     1583 ns: migration_call                : CPU_DYING
     2971 ns: hrtimer_cpu_notify            : CPU_DYING
=========================================================================
Total time for CPU_DYING = .016356000 ms
=========================================================================
=============================================================================
statistics for CPU_DOWN_CANCELED
=============================================================================
=========================================================================
Total time for CPU_DOWN_CANCELED = 0 ms
=========================================================================
=============================================================================
statistics for __stop_machine
=============================================================================
   556214 ns: __stop_machine                :
=========================================================================
Total time for __stop_machine = .556214000 ms
=========================================================================
=============================================================================
statistics for CPU_DEAD
=============================================================================
      352 ns: update_runtime                : CPU_DEAD
      363 ns: rb_cpu_notify                 : CPU_DEAD
      364 ns: relay_hotcpu_callback         : CPU_DEAD
      367 ns: hotplug_cfd                   : CPU_DEAD
      396 ns: cpu_callback                  : CPU_DEAD
      411 ns: hotplug_hrtick                : CPU_DEAD
      426 ns: rcu_barrier_cpu_hotplug       : CPU_DEAD
      489 ns: remote_softirq_cpu_notify     : CPU_DEAD
      517 ns: ratelimit_handler             : CPU_DEAD
      533 ns: workqueue_cpu_callback        : CPU_DEAD
      626 ns: dev_cpu_callback              : CPU_DEAD
      867 ns: cpu_numa_callback             : CPU_DEAD
     1430 ns: rcu_cpu_notify                : CPU_DEAD
     1827 ns: blk_cpu_notify                : CPU_DEAD
     1933 ns: buffer_cpu_notify             : CPU_DEAD
     2194 ns: pageset_cpuup_callback        : CPU_DEAD
     2613 ns: vmstat_cpuup_callback         : CPU_DEAD
     2902 ns: radix_tree_callback           : CPU_DEAD
     4373 ns: hrtimer_cpu_notify            : CPU_DEAD
     5799 ns: timer_cpu_notify              : CPU_DEAD
     9468 ns: flow_cache_cpu                : CPU_DEAD
    12579 ns: cpu_callback                  : CPU_DEAD
    13855 ns: cpu_callback                  : CPU_DEAD
    25095 ns: topology_cpu_callback         : CPU_DEAD
    29020 ns: page_alloc_cpu_notify         : CPU_DEAD
    66894 ns: percpu_counter_hotcpu_callback: CPU_DEAD
   118473 ns: slab_cpuup_callback           : CPU_DEAD
   153415 ns: sysfs_cpu_notify              : CPU_DEAD
   159933 ns: migration_call                : CPU_DEAD
 11320205 ns: cpuset_track_online_cpus      : CPU_DEAD
=========================================================================
Total time for CPU_DEAD = 11.937719000 ms
=========================================================================
=============================================================================
statistics for CPU_POST_DEAD
=============================================================================
      332 ns: remote_softirq_cpu_notify     : CPU_POST_DEAD
      334 ns: hotplug_hrtick                : CPU_POST_DEAD
      334 ns: hrtimer_cpu_notify            : CPU_POST_DEAD
      334 ns: radix_tree_callback           : CPU_POST_DEAD
      334 ns: relay_hotcpu_callback         : CPU_POST_DEAD
      334 ns: topology_cpu_callback         : CPU_POST_DEAD
      334 ns: update_runtime                : CPU_POST_DEAD
      335 ns: buffer_cpu_notify             : CPU_POST_DEAD
      348 ns: pageset_cpuup_callback        : CPU_POST_DEAD
      348 ns: slab_cpuup_callback           : CPU_POST_DEAD
      349 ns: rcu_barrier_cpu_hotplug       : CPU_POST_DEAD
      350 ns: cpu_callback                  : CPU_POST_DEAD
      350 ns: flow_cache_cpu                : CPU_POST_DEAD
      350 ns: rb_cpu_notify                 : CPU_POST_DEAD
      350 ns: sysfs_cpu_notify              : CPU_POST_DEAD
      350 ns: timer_cpu_notify              : CPU_POST_DEAD
      351 ns: page_alloc_cpu_notify         : CPU_POST_DEAD
      352 ns: cpuset_track_online_cpus      : CPU_POST_DEAD
      365 ns: hotplug_cfd                   : CPU_POST_DEAD
      365 ns: vmstat_cpuup_callback         : CPU_POST_DEAD
      366 ns: cpu_callback                  : CPU_POST_DEAD
      367 ns: cpu_numa_callback             : CPU_POST_DEAD
      368 ns: cpu_callback                  : CPU_POST_DEAD
      395 ns: blk_cpu_notify                : CPU_POST_DEAD
      396 ns: rcu_cpu_notify                : CPU_POST_DEAD
      397 ns: dev_cpu_callback              : CPU_POST_DEAD
      442 ns: migration_call                : CPU_POST_DEAD
      563 ns: percpu_counter_hotcpu_callback: CPU_POST_DEAD
      778 ns: ratelimit_handler             : CPU_POST_DEAD
    94184 ns: workqueue_cpu_callback        : CPU_POST_DEAD
=========================================================================
Total time for CPU_POST_DEAD = .105155000 ms
=========================================================================
=============================================================================
statistics for CPU_UP_PREPARE
=============================================================================
      334 ns: hotplug_hrtick                : CPU_UP_PREPARE
      336 ns: update_runtime                : CPU_UP_PREPARE
      350 ns: flow_cache_cpu                : CPU_UP_PREPARE
      350 ns: radix_tree_callback           : CPU_UP_PREPARE
      365 ns: cpuset_track_online_cpus      : CPU_UP_PREPARE
      365 ns: page_alloc_cpu_notify         : CPU_UP_PREPARE
      365 ns: sysfs_cpu_notify              : CPU_UP_PREPARE
      367 ns: hrtimer_cpu_notify            : CPU_UP_PREPARE
      381 ns: buffer_cpu_notify             : CPU_UP_PREPARE
      381 ns: rb_cpu_notify                 : CPU_UP_PREPARE
      383 ns: cpu_callback                  : CPU_UP_PREPARE
      410 ns: rcu_barrier_cpu_hotplug       : CPU_UP_PREPARE
      413 ns: remote_softirq_cpu_notify     : CPU_UP_PREPARE
      426 ns: blk_cpu_notify                : CPU_UP_PREPARE
      475 ns: vmstat_cpuup_callback         : CPU_UP_PREPARE
      518 ns: hotplug_cfd                   : CPU_UP_PREPARE
      594 ns: percpu_counter_hotcpu_callback: CPU_UP_PREPARE
      731 ns: ratelimit_handler             : CPU_UP_PREPARE
      805 ns: relay_hotcpu_callback         : CPU_UP_PREPARE
     1007 ns: dev_cpu_callback              : CPU_UP_PREPARE
     1690 ns: rcu_cpu_notify                : CPU_UP_PREPARE
     1875 ns: timer_cpu_notify              : CPU_UP_PREPARE
     2083 ns: pageset_cpuup_callback        : CPU_UP_PREPARE
     5016 ns: cpu_numa_callback             : CPU_UP_PREPARE
     6944 ns: topology_cpu_callback         : CPU_UP_PREPARE
     7064 ns: slab_cpuup_callback           : CPU_UP_PREPARE
    20964 ns: cpu_callback                  : CPU_UP_PREPARE
    36301 ns: cpu_callback                  : CPU_UP_PREPARE
    38337 ns: migration_call                : CPU_UP_PREPARE
   139963 ns: workqueue_cpu_callback        : CPU_UP_PREPARE
=========================================================================
Total time for CPU_UP_PREPARE = .269593000 ms
=========================================================================
=============================================================================
statistics for CPU_UP_CANCELED
=============================================================================
=========================================================================
Total time for CPU_UP_CANCELED = 0 ms
=========================================================================
=============================================================================
statistics for __cpu_up
=============================================================================
  7881152 ns: __cpu_up                      :
=========================================================================
Total time for __cpu_up = 7.881152000 ms
=========================================================================
=============================================================================
statistics for CPU_STARTING
=============================================================================
      318 ns: cpu_callback                  : CPU_STARTING
      334 ns: hotplug_cfd                   : CPU_STARTING
      334 ns: hotplug_hrtick                : CPU_STARTING
      334 ns: hrtimer_cpu_notify            : CPU_STARTING
      336 ns: remote_softirq_cpu_notify     : CPU_STARTING
      336 ns: topology_cpu_callback         : CPU_STARTING
      348 ns: cpu_callback                  : CPU_STARTING
      348 ns: flow_cache_cpu                : CPU_STARTING
      349 ns: cpu_callback                  : CPU_STARTING
      349 ns: update_runtime                : CPU_STARTING
      350 ns: dev_cpu_callback              : CPU_STARTING
      350 ns: rb_cpu_notify                 : CPU_STARTING
      351 ns: sysfs_cpu_notify              : CPU_STARTING
      352 ns: cpuset_track_online_cpus      : CPU_STARTING
      365 ns: vmstat_cpuup_callback         : CPU_STARTING
      381 ns: blk_cpu_notify                : CPU_STARTING
      393 ns: page_alloc_cpu_notify         : CPU_STARTING
      395 ns: timer_cpu_notify              : CPU_STARTING
      396 ns: relay_hotcpu_callback         : CPU_STARTING
      396 ns: slab_cpuup_callback           : CPU_STARTING
      397 ns: cpu_numa_callback             : CPU_STARTING
      397 ns: pageset_cpuup_callback        : CPU_STARTING
      397 ns: radix_tree_callback           : CPU_STARTING
      410 ns: buffer_cpu_notify             : CPU_STARTING
      410 ns: rcu_cpu_notify                : CPU_STARTING
      412 ns: rcu_barrier_cpu_hotplug       : CPU_STARTING
      426 ns: percpu_counter_hotcpu_callback: CPU_STARTING
      549 ns: ratelimit_handler             : CPU_STARTING
      549 ns: workqueue_cpu_callback        : CPU_STARTING
      592 ns: migration_call                : CPU_STARTING
=========================================================================
Total time for CPU_STARTING = .011654000 ms
=========================================================================
=============================================================================
statistics for CPU_ONLINE
=============================================================================
      334 ns: hotplug_cfd                   : CPU_ONLINE
      334 ns: relay_hotcpu_callback         : CPU_ONLINE
      334 ns: remote_softirq_cpu_notify     : CPU_ONLINE
      335 ns: hrtimer_cpu_notify            : CPU_ONLINE
      349 ns: topology_cpu_callback         : CPU_ONLINE
      352 ns: flow_cache_cpu                : CPU_ONLINE
      352 ns: slab_cpuup_callback           : CPU_ONLINE
      365 ns: dev_cpu_callback              : CPU_ONLINE
      365 ns: rb_cpu_notify                 : CPU_ONLINE
      379 ns: pageset_cpuup_callback        : CPU_ONLINE
      381 ns: page_alloc_cpu_notify         : CPU_ONLINE
      381 ns: rcu_cpu_notify                : CPU_ONLINE
      381 ns: timer_cpu_notify              : CPU_ONLINE
      395 ns: hotplug_hrtick                : CPU_ONLINE
      410 ns: blk_cpu_notify                : CPU_ONLINE
      426 ns: rcu_barrier_cpu_hotplug       : CPU_ONLINE
      455 ns: cpu_numa_callback             : CPU_ONLINE
      459 ns: radix_tree_callback           : CPU_ONLINE
      473 ns: buffer_cpu_notify             : CPU_ONLINE
      504 ns: ratelimit_handler             : CPU_ONLINE
      639 ns: percpu_counter_hotcpu_callback: CPU_ONLINE
      791 ns: update_runtime                : CPU_ONLINE
     1052 ns: cpu_callback                  : CPU_ONLINE
     1282 ns: cpu_callback                  : CPU_ONLINE
     1845 ns: cpu_callback                  : CPU_ONLINE
     2502 ns: vmstat_cpuup_callback         : CPU_ONLINE
     4332 ns: migration_call                : CPU_ONLINE
    14505 ns: workqueue_cpu_callback        : CPU_ONLINE
    54588 ns: sysfs_cpu_notify              : CPU_ONLINE
 12767882 ns: cpuset_track_online_cpus      : CPU_ONLINE
=========================================================================
Total time for CPU_ONLINE = 12.857182000 ms
=========================================================================


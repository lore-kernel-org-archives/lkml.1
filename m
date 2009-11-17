Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZKQOdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZKQOdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZKQOdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:33:23 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38627 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbZKQOdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:33:23 -0500
Date: Tue, 17 Nov 2009 20:03:06 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: [RFC v4 PATCH 0/7] CFS Hard limits - v4
Message-ID: <20091117143306.GK17335@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the v4 post of hard limits feature for CFS group scheduler. This
version mainly adds cpu hotplug support for CFS runtime balancing.

Changes
-------
RFC v4:
- Reclaim runtimes lent to other cpus when a cpu goes
  offline. (Kamalesh Babulal)
- Fixed a few bugs.
- Some cleanups.

RFC v3:
- http://lkml.org/lkml/2009/11/9/65
- Till v2, I was updating rq->nr_running when tasks go and come back on
  runqueue during throttling and unthrottling. Don't do this.
- With the above change, quite a bit of code simplification is achieved.
  Runtime related fields of cfs_rq are now being protected by per cfs_rq
  lock instead of per rq lock. With this it looks more similar to rt.
- Remove the control file cpu.cfs_hard_limit which enabled/disabled hard limits
  for groups. Now hard limits is enabled by having a non-zero runtime.
- Don't explicitly prevent movement of tasks into throttled groups during
  load balancing as throttled entities are anyway prevented from being
  enqueued in enqueue_task_fair().
- Moved to 2.6.32-rc6

RFC v2:
- http://lkml.org/lkml/2009/9/30/115
- Upgraded to 2.6.31.
- Added CFS runtime borrowing.
- New locking scheme
    The hard limit specific fields of cfs_rq (cfs_runtime, cfs_time and
    cfs_throttled) were being protected by rq->lock. This simple scheme will
    not work when runtime rebalancing is introduced where it will be required
    to look at these fields on other CPU's which requires us to acquire
    rq->lock of other CPUs. This will not be feasible from update_curr().
    Hence introduce a separate lock (rq->runtime_lock) to protect these
    fields of all cfs_rq under it.
- Handle the task wakeup in a throttled group correctly.
- Make CFS_HARD_LIMITS dependent on CGROUP_SCHED (Thanks to Andrea Righi)

RFC v1:
- First version of the patches with minimal features was posted at
  http://lkml.org/lkml/2009/8/25/128

RFC v0:
- The CFS hard limits proposal was first posted at
  http://lkml.org/lkml/2009/6/4/24

Testing and Benchmark numbers
-----------------------------
Some numbers from simple benchmarks to sanity-check that hard limits
patches are not causing any major regressions.

- hackbench (hackbench -pipe N)
  (hackbench was run as part of a group under root group)
  -----------------------------------------------------------------------
				Time
	-----------------------------------------------------------------
  N	CFS_HARD_LIMTS=n	CFS_HARD_LIMTS=y	CFS_HARD_LIMITS=y
				(infinite runtime)	(BW=450000/500000)
  -----------------------------------------------------------------------
  10	0.574			0.614			0.674
  20	1.086			1.154			1.232
  50	2.689			2.487			2.714
  100	4.897			4.771			5.439
  -----------------------------------------------------------------------
  - BW = Bandwidth = runtime/period
  - Infinite runtime means no hard limiting

- lmbench (lat_ctx -N 5 -s <size_in_kb> N)

  (i) size_in_kb = 1024
  -----------------------------------------------------------------------
				Context switch time (us)
	-----------------------------------------------------------------
  N	CFS_HARD_LIMTS=n	CFS_HARD_LIMTS=y	CFS_HARD_LIMITS=y
				(infinite runtime)	(BW=450000/500000)
  -----------------------------------------------------------------------
  10	237.14			248.83			69.71
  100	251.97			234.74			254.73
  500	248.39			252.73			252.66
  -----------------------------------------------------------------------

  (ii) size_in_kb = 2048
  -----------------------------------------------------------------------
				Context switch time (us)
	-----------------------------------------------------------------
  N	CFS_HARD_LIMTS=n	CFS_HARD_LIMTS=y	CFS_HARD_LIMITS=y
				(infinite runtime)	(BW=450000/500000)
  -----------------------------------------------------------------------
  10	541.39			538.68			419.03
  100	504.52			504.22			491.20
  500	495.26			494.11			497.12
  -----------------------------------------------------------------------

- kernbench

Average Optimal load -j 96 Run (std deviation):
------------------------------------------------------------------------------
	CFS_HARD_LIMTS=n	CFS_HARD_LIMTS=y	CFS_HARD_LIMITS=y
				(infinite runtime)	(BW=450000/500000)
------------------------------------------------------------------------------
Elapsd	234.965 (10.1328)	235.93 (8.0893)		270.74 (5.11945)
User	796.605 (62.1617)	787.105 (80.3486)	880.54 (9.33381)
System	802.715 (7.62968)	838.565 (14.5593)	868.23 (10.8894)
% CPU	680 (0)			688.5 (16.2635)		645.5 (4.94975)
CtxSwt	535452 (23273.7)	536321 (27946.3)	567430 (9579.88)
Sleeps	614784 (19538.8)	610256 (17570.2)	626286 (2390.73)
------------------------------------------------------------------------------

Patches description
-------------------
This post has the following patches:

1/7 sched: Rename sched_rt_period_mask() and use it in CFS also
2/7 sched: Bandwidth initialization for fair task groups
3/7 sched: Enforce hard limits by throttling
4/7 sched: Unthrottle the throttled tasks
5/7 sched: Add throttle time statistics to /proc/sched_debug
6/7 sched: CFS runtime borrowing
7/7 sched: Hard limits documentation

 Documentation/scheduler/sched-cfs-hard-limits.txt |   48 ++
 include/linux/sched.h                               |    6 
 init/Kconfig                                        |   13 
 kernel/sched.c                                      |  339 ++++++++++++++
 kernel/sched_debug.c                                |   17 
 kernel/sched_fair.c                                 |  464 +++++++++++++++++++-
 kernel/sched_rt.c                                   |   45 -
 7 files changed, 869 insertions(+), 63 deletions(-)

Regards,
Bharata.

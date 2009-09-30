Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZI3MvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZI3MvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZI3MvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:51:08 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42016 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbZI3MvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:51:06 -0400
Date: Wed, 30 Sep 2009 18:19:20 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: [RFC v2 PATCH 0/8] CFS Hard limits - v2
Message-ID: <20090930124919.GA19951@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the v2 post of hard limits feature for CFS group scheduler. This
RFC post mainly adds runtime borrowing feature and has a new locking scheme
to protect CFS runtime related fields.

It would be nice to have some comments on this set!

Changes
-------

RFC v2:
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
- This patchset has seen very minimal testing on 24way machine and is expected
  to have bugs. I need to test this under more test scenarios.
- I have run a few common benchmarks to see if my patches introduce any visible
  overhead. I am aware that the number of runs or the combinations I have
  used may not be ideal, but the intention in this early stage is to catch any
  serious regressions that the patches would have introduced.
- I plan to get numbers from more benchmarks in future releases. Any inputs
  on specific benchmarks to try would be helpful.

- hackbench (hackbench -pipe N)
  (hackbench was run as part of a group under root group)
  -----------------------------------------------------------------------
				Time
	-----------------------------------------------------------------
  N	CFS_HARD_LIMTS=n	CFS_HARD_LIMTS=y	CFS_HARD_LIMITS=y
				(infinite runtime)	(BW=450000/500000)
  -----------------------------------------------------------------------
  10	0.475			0.384			0.253
  20	0.610			0.670			0.692
  50	1.250			1.201			1.295
  100	1.981			2.174			1.583
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
  10	315.87			330.19			317.04
  100	675.52			699.90			698.50
  500	775.01			772.86			772.30
  -----------------------------------------------------------------------

  (ii) size_in_kb = 2048
  -----------------------------------------------------------------------
				Context switch time (us)
	-----------------------------------------------------------------
  N	CFS_HARD_LIMTS=n	CFS_HARD_LIMTS=y	CFS_HARD_LIMITS=y
				(infinite runtime)	(BW=450000/500000)
  -----------------------------------------------------------------------
  10	1319.01			1332.16			1328.09
  100	1400.77			1372.67			1382.27
  500	1479.40			1524.57			1615.84
  -----------------------------------------------------------------------

- kernbench

Average Half load -j 12 Run (std deviation):
------------------------------------------------------------------------------
	CFS_HARD_LIMTS=n	CFS_HARD_LIMTS=y	CFS_HARD_LIMITS=y
				(infinite runtime)	(BW=450000/500000)
------------------------------------------------------------------------------
Elapsd	5.716 (0.278711)	6.06 (0.479322)		5.41 (0.360694)
User	20.464 (2.22087)	22.978 (3.43738)	18.486 (2.60754)
System	14.82 (1.52086)		16.68 (2.3438)		13.514 (1.77074)
% CPU	615.2 (41.1667)		651.6 (43.397)		588.4 (42.0214)
CtxSwt	2727.8 (243.19)		3030.6 (425.338)	2536 (302.498)
Sleeps	4981.4 (442.337)	5532.2 (847.27)		4554.6 (510.532)
------------------------------------------------------------------------------

Average Optimal load -j 96 Run (std deviation):
------------------------------------------------------------------------------
	CFS_HARD_LIMTS=n	CFS_HARD_LIMTS=y	CFS_HARD_LIMITS=y
				(infinite runtime)	(BW=450000/500000)
------------------------------------------------------------------------------
Elapsd	4.826 (0.276641)	4.776 (0.291599)	5.13 (0.50448)
User	21.278 (2.67999)	22.138 (3.2045)		21.988 (5.63116)
System	19.213 (5.38314)	19.796 (4.32574)	20.407 (8.53682)
% CPU	778.3 (184.522)		786.1 (154.295)		803.1 (244.865)
CtxSwt	2906.5 (387.799)	3052.1 (397.15)		3030.6 (765.418)
Sleeps	4576.6 (565.383)	4796 (990.278)		4576.9 (625.933)
------------------------------------------------------------------------------

Average Maximal load -j Run (std deviation):
------------------------------------------------------------------------------
	CFS_HARD_LIMTS=n	CFS_HARD_LIMTS=y	CFS_HARD_LIMITS=y
				(infinite runtime)	(BW=450000/500000)
------------------------------------------------------------------------------
Elapsd	5.13 (0.530236)		5.062 (0.0408656)	4.94 (0.229891)
User	22.7293 (4.37921)	22.9973 (2.86311)	22.5507 (4.78016)
System	21.966 (6.81872)	21.9713 (4.72952)	22.0287 (7.39655)
% CPU	860 (202.295)		859.8 (164.415)		864.467 (218.721)
CtxSwt	3154.27 (659.933)	3172.93 (370.439)	3127.2 (657.224)
Sleeps	4602.6 (662.155)	4676.67 (813.274)	4489.2 (542.859)
------------------------------------------------------------------------------

Features TODO
-------------
- CFS runtime borrowing still needs some work, especially need to handle
  runtime redistribution when a CPU goes offline.
- Bandwidth inheritance support (long term, not under consideration currently)
- This implementation doesn't work for user group scheduler. Since user group
  scheduler will eventually go away, I don't plan to work on this.

Implementation TODO
-------------------
- It is possible to share some of the bandwidth handling code with RT, but
  the intention of this post is to show the changes associated with hard limits.
  Hence the sharing/cleanup will be done down the line when this patchset
  itself becomes more accepatable.
- When a dequeued entity is enqueued back, I don't change its vruntime. The
  entity might get undue advantage due to its old (lower) vruntime. Need to
  address this.

Patches description
-------------------
This post has the following patches:

1/8 sched: Rename sched_rt_period_mask() and use it in CFS also
2/8 sched: Maintain aggregated tasks count in cfs_rq at each hierarchy level
3/8 sched: Bandwidth initialization for fair task groups
4/8 sched: Enforce hard limits by throttling
5/8 sched: Unthrottle the throttled tasks
6/8 sched: Add throttle time statistics to /proc/sched_debug
7/8 sched: CFS runtime borrowing
8/8 sched: Hard limits documentation

 Documentation/scheduler/sched-cfs-hard-limits.txt |   52 ++
 include/linux/sched.h                               |    9 
 init/Kconfig                                        |   13 
 kernel/sched.c                                      |  427 +++++++++++++++++++
 kernel/sched_debug.c                                |   21 
 kernel/sched_fair.c                                 |  432 +++++++++++++++++++-
 kernel/sched_rt.c                                   |   22 -
 7 files changed, 932 insertions(+), 44 deletions(-)

Regards,
Bharata.

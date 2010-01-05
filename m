Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255Ab0AEH5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0AEH5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 02:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222Ab0AEH5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 02:57:35 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40006 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab0AEH5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 02:57:32 -0500
Date: Tue, 5 Jan 2010 13:27:03 +0530
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
Subject: [RFC v5 PATCH 0/8] CFS Hard limits - v5
Message-ID: <20100105075703.GE27899@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the v5 post of CFS hard limits. In this patchset, I have
pulled out bandwidth and runtime handling code from RT into sched.c
so that the same code can be used by CFS hard limits.

Also I have addressed the review comments given by Peter Zijlstra for v4.

Changes
-------
RFC v5:
- Make RT bandwidth and runtime handing code generic and use it in CFS also.
- Remove the *_locked() version from sched_fair.c by simplifying the locking.
  This fixes the unlock imbalance bug seen by Jarek Dylag who observed it while
  using CFS hard limits with Linux vserver.

RFC v4:
- http://lkml.org/lkml/2009/11/17/191
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

Patches description
-------------------
This post has the following patches:

1/8 sched: Rename struct rt_bandwidth to sched_bandwidth
2/8 sched: Make rt bandwidth timer and runtime related code generic
3/8 sched: Bandwidth initialization for fair task groups
4/8 sched: Enforce hard limits by throttling
5/8 sched: Unthrottle the throttled tasks
6/8 sched: Add throttle time statistics to /proc/sched_debug
7/8 sched: CFS runtime borrowing
8/8 sched: Hard limits documentation

 Documentation/scheduler/sched-cfs-hard-limits.txt   |   48 +
 include/linux/sched.h                               |    6 
 init/Kconfig                                        |   13 
 kernel/sched.c                                      |  591 +++++++++++++++++---
 kernel/sched_debug.c                                |   23 
 kernel/sched_fair.c                                 |  354 +++++++++++
 kernel/sched_rt.c                                   |  268 +--------
 7 files changed, 964 insertions(+), 339 deletions(-)

Regards,
Bharata.

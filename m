Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZKIJIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZKIJIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbZKIJIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:08:46 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:33816 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZKIJIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:08:44 -0500
Date: Mon, 9 Nov 2009 14:38:38 +0530
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
Subject: [RFC v3 PATCH 0/7] CFS Hard limits - v3
Message-ID: <20091109090838.GD23472@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[sorry for the double post of 0/7 mail, I missed the CC list earlier]

Hi,

Here is the v3 post of hard limits feature for CFS group scheduler. This
post mostly addresses the comments received during v2.

If the approach taken in v3 is found to be acceptable, I would like to
start merging some common code with rt starting from next post.

As last time, this is lightly tested I know there are bugs in this version
which I am working on.

Changes
-------
RFC v3:
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

1/7 sched: Rename sched_rt_period_mask() and use it in CFS also
2/7 sched: Bandwidth initialization for fair task groups
3/7 sched: Enforce hard limits by throttling
4/7 sched: Unthrottle the throttled tasks
5/7 sched: Add throttle time statistics to /proc/sched_debug
6/7 sched: CFS runtime borrowing
7/7 sched: Hard limits documentation

 Documentation/scheduler/sched-cfs-hard-limits.txt |   48 +++
 include/linux/sched.h                               |    6 
 init/Kconfig                                        |   13 
 kernel/sched.c                                      |  316 +++++++++++++++++++-
 kernel/sched_debug.c                                |   17 +
 kernel/sched_fair.c                                 |  288 +++++++++++++++++-
 kernel/sched_rt.c                                   |   19 -
 7 files changed, 674 insertions(+), 33 deletions(-)

Regards,
Bharata.

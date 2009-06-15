Return-Path: <linux-kernel-owner+w=401wt.eu-S933656AbZFOSyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656AbZFOSyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758409AbZFOSym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:54:42 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54914 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752212AbZFOSyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:54:41 -0400
Date: Mon, 15 Jun 2009 20:55:43 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/8] Use EDF to throttle RT task groups
Message-ID: <cover.1245092261.git.fabio@helm.retis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces a group level EDF scheduler to extend the
current throttling mechanism, in order to make it support generic
period assignments.  With this patch, the rt_runtime and rt_period
parameters can be used to specify arbitrary CPU reservations for
RT tasks.

The first two patches fix two problems of the current implementation.

This is an early RFC, I'm interested in having an idea of what people
think about this feature, if it's worth working on it, what can be
improved in the design, etc.

The main design issues involved:

  - It is no more possible to specify RUNTIME_INF for a task group
    when throttling is enabled.  Rationale: supporting both throttled
    and unthrottled groups would have required too much extra complexity
    (I didn't find anything simpler than two parallel runqueues, one for
    throttled and one for unthrottled groups).

  - Since it is not easy to mix tasks and groups on the same scheduler
    queue (tasks have no deadlines), the bandwidth reserved to the tasks
    in a group is controlled with two additional cgroup attributes:
    rt_task_runtime_us and rt_task_period_us.  These attrinutes control,
    within a cgroup, how much bandwidth is reserved to the tasks it
    contains.

  - Shared resources are still handled using boosting.  When a group
    contains a task inside a critical section it is scheduled according
    the highest priority among the ones of the tasks it contains.
    In this way, the same group has two modes: when it is not boosted
    it is scheduled according to its deadline; when it is boosted, it
    is scheduled according its priority.  Boosted groups are always
    favored over non-boosted ones.

  - The old priority array is now gone.  To use only a single data
    structure for entities using both priorities and deadlines (due
    to boosting), the only possible choice was to use an rb-tree;
    the function used to order the keys takes into account the
    prioritization described above (boosted tasks, ordered by
    priority are favored to non-boosted tasks, ordered by increasing
    deadline).

  - Given that the various rt_rq's belonging to the same task group
    are activated independently, there is the need of a timer per
    each rt_rq.

The patchset is against sched-devel, and (temporarily) depends on
CONFIG_RT_GROUP_SCHED.

Any kind of feedback is welcome.

Fabio Checconi (8):
  Fix rt_rq->pushable_tasks initialization in init_rt_rq()
  Fix hrtick handling
  Replace struct prio_array with an RB tree
  Remove the balancing logic
  Use EDF to throttle RT tasks hierarchically
  Modify the curr/next priority tracking
  Reprogram timers only when necessary
  Use hrtick when available

 include/linux/init_task.h |    1 -
 include/linux/sched.h     |    2 +-
 kernel/sched.c            |  553 +++++++++++++++++++++++++------------
 kernel/sched_debug.c      |    4 +-
 kernel/sched_rt.c         |  672 +++++++++++++++++++++++++++------------------
 5 files changed, 781 insertions(+), 451 deletions(-)

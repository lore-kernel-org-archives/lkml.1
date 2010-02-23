Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab0BWSsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:48:31 -0500
Received: from ms01.sssup.it ([193.205.80.99]:56181 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753297Ab0BWSsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:48:30 -0500
From: Fabio Checconi <fchecconi@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org,
       Fabio Checconi <fchecconi@gmail.com>
Subject: [PATCH 0/3] sched: use EDF to throttle RT task groups v2
Date: Tue, 23 Feb 2010 19:56:32 +0100
Message-Id: <cover.1266931410.git.fabio@helm.retis>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces a group level EDF scheduler extending the
throttling mechanism, in order to make it support generic period
assignments.  With this patch, the runtime and period parameters
can be used to specify arbitrary CPU reservations for RT tasks.

>From the previous post [1] I've integrated Peter's suggestions, using
a multi-level hierarchy to do admission control, but a one-level only
equivalent hierarchy for scheduling, and I've not removed the bandwidth
migration mechanism, trying to adapt it to EDF scheduling.  In this
version tasks are still inserted into priority arrays and only groups
are kept in a per-rq edf tree.

The main design issues involved:

  - Since it is not easy to mix tasks and groups on the same scheduler
    queue (tasks have no deadlines), the bandwidth reserved to the tasks
    in a group is controlled with two additional cgroup attributes:
    rt_task_runtime_us and rt_task_period_us.  These attributes control,
    within a cgroup, how much bandwidth is reserved to the tasks it
    contains.  The old attributes, rt_runtime_us and rt_period_us, are
    still there, and control the bandwidth assigned to the cgroup.  They
    are used only for admission control.

  - Shared resources are still handled using boosting.  When a group
    contains a task inside a critical section it is scheduled according
    the highest priority among the ones of the tasks it contains.
    In this way, the same group has two modes: when it is not boosted
    it is scheduled according to its deadline; when it is boosted, it
    is scheduled according its priority.  Boosted groups are always
    favored over non-boosted ones.

  - Given that the various rt_rq's belonging to the same task group
    are activated independently, there is the need of a timer per
    each rt_rq.

  - While balancing the bandwidth assigned to a cgroup on various cpus
    we have to make sure that utilization for the rt_rq's on each cpu
    does not exceed the global utilization limit for RT tasks.  

Please note that these patches target a completely different usage
scenario from Dario's work on SCHED_DEADLINE.  SCHED_DEADLINE is about
deadline scheduling for tasks, introducing a new user-visible scheduling
policy; this patchset is about using throttling to provide real-time
guarantees to SCHED_RR and SCHED_FIFO tasks on a per-group basis.  The
two patchsets do not overlap in functionality, both aim at improving
the predictability of the system; we'll want to work on sharing parts of
the code, but now, after discussing with Dario, we think it's too early
to do that.

The patchset is against tip, it should compile (and hopefully work) on
all the combinations of CONFIG_{SMP/RT_GROUP_SCHED}, but the work was
focused on the SMP & RT_GROUP_SCHED case, I've  only compile- or boot-
tested the other configs.

As usual, feedback welcome.

[1] http://lkml.org/lkml/2009/6/15/510

Fabio Checconi (3):
  sched: use EDF to schedule groups
  sched: enforce per-cpu utilization limits on runtime balancing
  sched: make runtime balancing code more EDF-friendly

 include/linux/sched.h |    8 +-
 kernel/sched.c        |  467 +++++++++++---------
 kernel/sched_rt.c     | 1159 +++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 1161 insertions(+), 473 deletions(-)


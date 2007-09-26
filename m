Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbXIZLOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbXIZLOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbXIZLOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:14:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50368 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbXIZLOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:14:10 -0400
Date: Wed, 26 Sep 2007 13:13:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Subject: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8, v2.6.22.8,
	v2.6.21.7, v2.6.20.20
Message-ID: <20070926111357.GA10655@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

By popular demand, here is release -v22 of the CFS scheduler. It is a 
full backport of the latest & greatest sched-devel.git code to 
v2.6.23-rc8, v2.6.22.8, v2.6.21.7 and v2.6.20.20. The patches can be 
downloaded from the usual place:

    http://people.redhat.com/mingo/cfs-scheduler/

This is the first time the development version of the scheduler has been 
fed back into the stable backport series, so there's many changes since 
v20.5:

 15 files changed, 1103 insertions(+), 840 deletions(-)

Even if CFS v20.5 worked well for you, please try this release too, with 
a good focus on interactivity testing - because, unless some major 
showstopper is found, this codebase is intended for a v2.6.24 upstream 
merge.

( Even a quick, subjective report of: "checked this patch, it didnt
  crash and it feels like v20.5" or "laggier than v20.5" or "feels 
  better than v20.5" is useful to us and enables us to judge the general 
  direction of interactivity. )

The changes in v22 consist of lots of mostly small enhancements, 
speedups, interactivity improvements, debug enhancements and tidy-ups - 
many of which can be user-visible. (These enhancements have been 
contributed by many people - see the changelog below and the git tree 
for detailed credits.)

The biggest individual new feature is per UID group scheduling, written 
by Srivatsa Vaddagiri, which can be enabled via the 
CONFIG_FAIR_USER_SCHED=y .config option. With this feature enabled, each 
user gets a fair share of the CPU time, regardless of how many tasks 
each user is running.

For example, it took me 0.1 seconds to log in over ssh as root on a 
testbox that was running a kernel with per UID group scheduling enabled:

  $ time ssh root@testbox /bin/true

  real    0m0.125s
  user    0m0.013s
  sys     0m0.011s

Which testbox had a system load of 1000.17 at this time, due to a rogue 
runaway workload of one thousand (!) non-reniced infinite loops:

  top - 14:34:05 up 30 min,  3 users,  load average: 1000.17, 839.23, 444.57
  Tasks: 1131 total, 1002 running, 129 sleeping,   0 stopped,   0 zombie
  Cpu(s): 30.8%us,  0.2%sy,  0.0%ni, 68.2%id,  0.8%wa,  0.0%hi,  0.0%si
  Mem:   2048992k total,   157688k used,  1891304k free,    18308k buffers
  Swap:  4096564k total,        0k used,  4096564k free,    25464k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  3633 root      20   0  2892 1576  724 R    7  0.1   0:00.06 top
  2427 mingo     20   0  1576  244  196 R    2  0.0   0:01.14 loop
  2429 mingo     20   0  1576  244  196 R    2  0.0   0:01.14 loop

To the root user, the box was fully usable an interactivity was 
excellent - i was easily able to kill off those runaway tasks.

( The /proc/root_user_cpu_share tunable also allows the root uid to have
  higher weight than other uids. Unit of the tunable is 0.1%, a weight
  of 100% is 1024, the default weight of the root uid is 200%. )

See the detailed shortlog below for a description of the other changes, 
or pull the sched-devel.git tree for all the 83 commits:

  git-pull git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

Also, as usual, any sort of feedback, bugreport, fix and suggestion is 
more than welcome!

	Ingo

------------------>
Dmitry Adamushko (9):
      sched: clean up struct load_stat
      sched: clean up schedstat block in dequeue_entity()
      sched: sched_setscheduler() fix
      sched: add set_curr_task() calls
      sched: do not keep current in the tree and get rid of sched_entity::fair_key
      sched: optimize task_new_fair()
      sched: simplify sched_class::yield_task()
      sched: rework enqueue/dequeue_entity() to get rid of set_curr_task()
      sched: yield fix

Hiroshi Shimamoto (1):
      sched: clean up sched_fork()

Matthias Kaehlcke (1):
      sched: use list_for_each_entry_safe() in __wake_up_common()

Mike Galbraith (2):
      sched: fix SMP migration latencies
      sched: fix formatting of /proc/sched_debug

Peter Zijlstra (12):
      sched: simplify SCHED_FEAT_* code
      sched: new task placement for vruntime
      sched: simplify adaptive latency
      sched: clean up new task placement
      sched: add tree based averages
      sched: handle vruntime overflow
      sched: better min_vruntime tracking
      sched: add vslice
      sched debug: check spread
      sched: max_vruntime() simplification
      sched: clean up min_vruntime use
      sched: speed up and simplify vslice calculations

S.Caglar Onur (1):
      sched debug: BKL usage statistics, fix

Srivatsa Vaddagiri (12):
      sched: group-scheduler core
      sched: revert recent removal of set_curr_task()
      sched: fix minor bug in yield
      sched: print nr_running and load in /proc/sched_debug
      sched: print &rq->cfs stats
      sched: clean up code under CONFIG_FAIR_GROUP_SCHED
      sched: add fair-user scheduler
      sched: group scheduler wakeup latency fix
      sched: group scheduler SMP migration fix
      sched: group scheduler, fix coding style issues
      sched: group scheduler, fix bloat
      sched: group scheduler, fix latency

Ingo Molnar (44):
      sched: fix new-task method
      sched: resched task in task_new_fair()
      sched: small sched_debug cleanup
      sched: debug: track maximum 'slice'
      sched: uniform tunings
      sched: use constants if !CONFIG_SCHED_DEBUG
      sched: remove stat_gran
      sched: remove precise CPU load
      sched: remove precise CPU load calculations #2
      sched: track cfs_rq->curr on !group-scheduling too
      sched: cleanup: simplify cfs_rq_curr() methods
      sched: uninline __enqueue_entity()/__dequeue_entity()
      sched: speed up update_load_add/_sub()
      sched: clean up calc_weighted()
      sched: introduce se->vruntime
      sched: move sched_feat() definitions
      sched: optimize vruntime based scheduling
      sched: simplify check_preempt() methods
      sched: wakeup granularity fix
      sched: add se->vruntime debugging
      sched: add more vruntime statistics
      sched: debug: update exec_clock only when SCHED_DEBUG
      sched: remove wait_runtime limit
      sched: remove wait_runtime fields and features
      sched: x86: allow single-depth wchan output
      sched: fix delay accounting performance regression
      sched: prettify /proc/sched_debug output
      sched: enhance debug output
      sched: kernel/sched_fair.c whitespace cleanups
      sched: fair-group sched, cleanups
      sched: enable CONFIG_FAIR_GROUP_SCHED=y by default
      sched debug: BKL usage statistics
      sched: remove unneeded tunables
      sched debug: print settings
      sched debug: more width for parameter printouts
      sched: entity_key() fix
      sched: remove condition from set_task_cpu()
      sched: remove last_min_vruntime effect
      sched: undo some of the recent changes
      sched: fix place_entity()
      sched: fix sched_fork()
      sched: remove set_leftmost()
      sched: clean up schedstats, cnt -> count
      sched: cleanup, remove stale comment

 arch/i386/Kconfig       |   11 
 fs/proc/base.c          |    2 
 include/linux/sched.h   |   56 ++-
 init/Kconfig            |   21 +
 kernel/delayacct.c      |    2 
 kernel/sched.c          |  577 ++++++++++++++++++++++++-------------
 kernel/sched_debug.c    |  246 ++++++++++------
 kernel/sched_fair.c     |  733 ++++++++++++++++++------------------------------
 kernel/sched_idletask.c |    5 
 kernel/sched_rt.c       |   12 
 kernel/sched_stats.h    |   28 -
 kernel/sysctl.c         |   31 --
 kernel/user.c           |   43 ++
 13 files changed, 963 insertions(+), 804 deletions(-)

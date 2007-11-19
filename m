Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbXKSPSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbXKSPSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbXKSPSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:18:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37741 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296AbXKSPSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:18:09 -0500
Date: Mon, 19 Nov 2007 16:17:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Subject: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8,
	v2.6.22.13, v2.6.21.7
Message-ID: <20071119151756.GA25446@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


By popular demand, here is release -v24 of the CFS scheduler patch.

It is a full backport of the latest & greatest scheduler code to 
v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7. The patches can be 
downloaded from the usual place:

    http://people.redhat.com/mingo/cfs-scheduler/

There's tons of changes since v22 was released:

    36 files changed, 2359 insertions(+), 1082 deletions(-)

that's 187 individual commits from 32 authors.

So even if CFS v22 worked well for you, please try this release too and 
report regressions (if any).

There are countless improvements in -v24 (see the shortlog further below 
for details), but here are a few highlights:

 - improved interactivity via Peter Ziljstra's "virtual slices" feature.
   As load increases, the scheduler shortens the virtual timeslices that 
   tasks get, so that applications observe the same constant latency for 
   getting on the CPU. (This goes on until the slices reach a minimum 
   granularity value)

 - CONFIG_FAIR_USER_SCHED is now available across all backported 
   kernels and the per user weights are configurable via 
   /sys/kernel/uids/. Group scheduling got refined all around.

 - performance improvements

 - bugfixes

99% of these changes are already upstream in Linus's git tree and they 
will be released as part of v2.6.24. (there are 4 pending commits that 
are in the small 2.6.24-rc3-v24 patch.)

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome!

	Ingo

------------------>
Adrian Bunk (3):
      sched: make kernel/sched.c:account_guest_time() static
      sched: proper prototype for kernel/sched.c:migration_init()
      sched: make sched_nr_latency static

Alexey Dobriyan (1):
      sched: uninline scheduler

Andi Kleen (5):
      sched: cleanup: remove unnecessary gotos
      sched: cleanup: refactor common code of sleep_on / wait_for_completion
      sched: cleanup: refactor normalize_rt_tasks
      sched: remove stale comment from sched_group_set_shares()
      sched: fix return value of wait_for_completion_interruptible()

Arjan van de Ven (1):
      Make scheduler debug file operations const

Balbir Singh (1):
      sched: fix delay accounting regression

Christian Borntraeger (1):
      sched: fix accounting of interrupts during guest execution on s390

Cliff Wickman (1):
      hotplug cpu: migrate a task within its cpuset

Dhaval Giani (1):
      sched: group scheduling, sysfs tunables

Dmitry Adamushko (16):
      sched: clean up struct load_stat
      sched: clean up schedstat block in dequeue_entity()
      sched: sched_setscheduler() fix
      sched: add set_curr_task() calls
      sched: do not keep current in the tree and get rid of sched_entity::fair_key
      sched: optimize task_new_fair()
      sched: simplify sched_class::yield_task()
      sched: rework enqueue/dequeue_entity() to get rid of set_curr_task()
      sched: yield fix
      sched: fix __pick_next_entity()
      sched: tidy up SCHED_RR
      sched: cleanup, remove calc_weighted()
      sched: cleanup, make dequeue_entity() and update_stats_wait_end() similar
      sched: fix group scheduling for SCHED_BATCH
      sched: fix __set_task_cpu() SMP race
      sched: remove activate_idle_task()

Eric Dumazet (1):
      sched: cleanup, use NSEC_PER_MSEC and NSEC_PER_SEC

Eugene Teo (1):
      Fix tsk->exit_state usage

Gautham R Shenoy (1):
      sched: fix rt ptracer monopolizing CPU

Hiroshi Shimamoto (1):
      sched: clean up sched_fork()

Ingo Molnar (80):
      sched: fix sysctl_sched_child_runs_first flag
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
      sched: wakeup granularity increase
      sched: add se->vruntime debugging
      sched: remove SCHED_FEAT_SKIP_INITIAL
      sched: add more vruntime statistics
      sched: debug: update exec_clock only when SCHED_DEBUG
      sched: remove wait_runtime limit
      sched: remove wait_runtime fields and features
      sched: fix delay accounting performance regression
      sched: prettify /proc/sched_debug output
      sched: enhance debug output
      sched: kernel/sched_fair.c whitespace cleanups
      sched debug: BKL usage statistics
      sched: remove unneeded tunables
      sched debug: print settings
      sched debug: more width for parameter printouts
      sched: entity_key() fix
      sched: remove condition from set_task_cpu()
      sched: remove last_min_vruntime effect
      sched: undo some of the recent changes
      sched: fix sign check error in place_entity()
      sched: fix sched_fork()
      sched: remove set_leftmost()
      sched: clean up schedstats, cnt -> count
      sched: cleanup, remove stale comment
      sched: mark scheduling classes as const
      sched: whitespace cleanups
      sched: vslice fixups for non-0 nice levels
      sched: optimize schedule() a bit on SMP
      sched: tweak wakeup granularity
      sched: run sched_domain_debug() if CONFIG_SCHED_DEBUG=y
      sched: break out if printing a warning in sched_domain_debug()
      sched: style cleanup
      sched: kfree(NULL) is valid
      sched: cleanup: rename SCHED_FEAT_USE_TREE_AVG to SCHED_FEAT_TREE_AVG
      sched: cleanup: rename task_grp to task_group
      sched: cleanup: function prototype cleanups
      sched: fix: move the CPU check into ->task_new_fair()
      sched: update comment
      sched: clean up is_migration_thread()
      sched: do not normalize kernel threads via SysRq-N
      sched: do not wakeup-preempt with SCHED_BATCH tasks
      sched: speed up context-switches a bit
      sched: reintroduce cache-hot affinity
      sched: debug: increase width of debug line
      sched: debug, improve migration statistics
      sched: allow the immediate migration of cache-cold tasks
      sched: affine sync wakeups
      sched: sync wakeups preempt too
      sched: cleanup, fix spacing
      sched: cleanup, make struct rq comments more consistent
      sched: add KERN_CONT annotation
      sched: fix fastcall mismatch in completion APIs
      sched: clean up sched_domain_debug()
      sched: fix style of swap() macro in kernel/sched_fair.c
      sched: fix style in kernel/sched.c
      sched: reintroduce SMP tunings again
      sched: turn off PREEMPT_RESTRICT
      sched: remove PREEMPT_RESTRICT
      sched: wakeup preemption fix
      sched: clean up the wakeup preempt check
      sched: clean up the wakeup preempt check, #2
      sched: reorder SCHED_FEAT_ bits

James Bottomley (1):
      sched: fix incorrect assumption that cpu 0 exists

Ken Chen (2):
      sched: fix improper load balance across sched domain
      sched: reduce schedstat variable overhead a bit

Laurent Vivier (2):
      sched: guest CPU accounting: maintain stats in account_system_time()
      sched: don't clear PF_VCPU in scheduler

Matthias Kaehlcke (1):
      sched: use list_for_each_entry_safe() in __wake_up_common()

Michael Neuling (2):
      Add scaled time to taskstats based process accounting
      kernel/sched.c: remove bogus comment from account_user_time

Mike Galbraith (3):
      sched: fix SMP migration latencies
      sched: fix formatting of /proc/sched_debug
      sched: prevent wakeup over-scheduling

Milton Miller (7):
      sched: domain sysctl fixes: use kcalloc()
      sched: domain sysctl fixes: use for_each_online_cpu()
      sched: domain sysctl fixes: unregister the sysctl table before domains
      sched: domain sysctl fixes: do not crash on allocation failure
      sched: domain sysctl fixes: add terminator comment
      sched: more robust sd-sysctl entry freeing
      sched: fix sched_domain sysctl registration again

Oleg Nesterov (3):
      do CPU_DEAD migrating under read_lock(tasklist) instead of write_lock_irq(tasklist)
      migration_call(CPU_DEAD): use spin_lock_irq() instead of task_rq_lock()
      sched: fix SCHED_FIFO tasks & FAIR_GROUP_SCHED

Paul E. McKenney (1):
      sched: export cpu_clock()

Paul Jackson (2):
      cpuset: remove sched domain hooks from cpusets
      cpuset sched_load_balance flag

Paul Menage (4):
      Task Control Groups: example CPU accounting subsystem
      Fix cpusets update_cpumask
      sched: clean up some control group code
      sched: report CPU usage in CFS cgroup directories

Pavel Emelyanov (3):
      pid namespaces: changes to show virtual ids to user
      Uninline find_task_by_xxx set of functions
      Use helpers to obtain task pid in printks

Peter Williams (2):
      sched: reduce balance-tasks overhead
      sched: isolate SMP balancing code a bit more

Peter Zijlstra (21):
      sched: simplify SCHED_FEAT_* code
      sched: new task placement for vruntime
      sched: simplify adaptive latency
      sched: clean up new task placement
      sched: add tree based averages
      sched: handle vruntime 64-bit overflow
      sched: better min_vruntime tracking
      sched: add vslice
      sched debug: check spread
      sched: max_vruntime() simplification
      sched: clean up min_vruntime use
      sched: speed up and simplify vslice calculations
      sched: another wakeup_granularity fix
      sched: disable sleeper_fairness on SCHED_BATCH
      sched: disable forced preemption by default
      sched: activate task_hot() only on fair-scheduled tasks
      sched: fix unconditional irq lock
      sched: fix vslice
      sched: documentation: place_entity() comments
      sched: reintroduce the sched_min_granularity tunable
      sched: avoid large irq-latencies in smp-balancing

S.Caglar Onur (1):
      sched debug: BKL usage statistics, fix

Satyam Sharma (1):
      sched: use show_regs() to improve __schedule_bug() output

Srivatsa Vaddagiri (16):
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
      sched: fix new task startup crash
      Hook up group scheduler with control groups
      sched: move rcu_head to task_group struct
      sched: fix copy_namespace() <-> sched_fork() dependency in do_fork

Zou Nan hai (1):
      sched: some proc entries are missed in sched_domain sys_ctl debug code


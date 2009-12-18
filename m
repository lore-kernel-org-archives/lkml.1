Return-Path: <linux-kernel-owner+w=401wt.eu-S1752285AbZLRM6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbZLRM6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 07:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbZLRM6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 07:58:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:45282 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbZLRM5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 07:57:42 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, peterz@infradead.org, johannes@sipsolutions.net,
       andi@firstfloor.org
Subject: 
Date: Fri, 18 Dec 2009 21:57:41 +0900
Message-Id: <1261141088-2014-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [RFC PATCHSET] concurrency managed workqueue, take#2

Hello, all.

This is the second take of cmwq (concurrency managed workqueue).  It's
on top of linus#master 55639353a0035052d9ea6cfe4dde0ac7fcbb2c9f
(v2.6.33-rc1).  Git tree is available at

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-cmwq

Quilt series is available at

  http://master.kernel.org/~tj/patches/review-cmwq.tar.gz


ISSUES FROM THE FIRST RFC AND THEIR RESOLUTIONS
===============================================

The first RFC round[1] was in October.  Several issues were raised but
there was no objection against the basic design.  Issued raised there
and later are

A. Hackish scheduler notification implemented by overriding scheduler
   class needs to be made generic.

B. Scheduler local wake up function needs to be reimplemented and
   share code path with try_to_wake_up().

C. Dual-colored workqueue flushing scheme may become a scalability
   issue.

D. There are users which end up issuing too many concurrent works
   unless throttled somehow (xfs).

E. Single thread workqueue is broken.  Works queued to a single thread
   workqueue require strict ordering.

F. The patch to actually implement cmwq is too large and needs to be
   split.

A, B are scheduler related and will be discussed further later with
other unresolved issues.

C is solved by implementing multi colored flush.  It has two
properties which make it resistant to scalability issues.  First, 14
flushes can be in progress simultaneously.  Second, when all the
colors are used up, new flushers don't wait in line and get processed
one by one.  All the overflowed ones get assigned the same color and
processed in batch when a color frees up, so throughput will increase
along with congestion.

D is solved by introducing max_active per cpu_workqueue_struct.  If
the number of active (running or pending for execution) works goes
over the max, works are put on to delayed_works list; thus giving
workqueues the ability to throttle concurrency.  The original
freeze/thaw implementation is replaced with max_active based one
(max_active is temporarily quenched to zero while frozen), so the
increase in the overall complexity isn't too great.

E also is implemented using max_active.  SINGLE_THREAD flag is
replaced with SINGLE_CPU.  CWQs dynamically arbitrate which CWQ is
gonna serve SINGLE_CPU workqueue using atomic accesses to
wq->single_cpu so that only one CWQ is active at any given time.
Combined with max_active set to one, this results in the same queuing
and execution behavior as single thread workqueues without requiring
dedicated thread.

F is solved by introducing workers, gcwqs, trustee, shared worklist
and concurrency managed worker pool in separate steps.  Although
logics which are gradually added carry superfluous parts which will
only be fully useful after complete implementation, each step achieves
pretty good execution coverage of new logics and should be useful as
review and bisection step.


UN/HALF-RESOLVED ISSUES
=======================

A. After a couple of tries, scheduler notification is currently
   implemented as generalized version of preempt_notifiers which used
   to be used only by kvm.  Two more notifications - wakeup and sleep
   - were added.  Ingo was unsatisfied with the fact that there now
   are three different notification-like mechanisms living around the
   scheduler code and refused to accept the new notifiers unless all
   the scheduler notification mechanisms are unified.

   To prevent having cmwq patches floating too long without a stable
   branch to be tested in linux-next, it was agreed to do this in the
   following stages[2].

   1. Apply patches which don't change scheduler behavior but will
      reduce conflicts to sched tree.

   2. Create a new sched branch which will contain the new notifiers.
      This branch will be stable and will end up in linux-next but
      won't be pushed to Linus unless the notification mechanisms are
      unified.

   3. Base cmwq branch on top of the devel branch created in #2 and
      publish it to linux-next for testing.

   4. Unify scheduler notification mechanisms in the sched devel
      branch and when it's done push it and cmwq to Linus.

B. set_cpus_allowed_ptr() doesn't move threads bound with
   kthread_bind() or to CPUs which don't have active set.  Active
   state encloses online state and used by scheduler to prevent
   scheduling threads on a dying CPU unless strictly necessary.

   However, it's desirable to have PF_THREAD_BOUND for kworkers during
   usual operation and new and rescue workers need to be able to
   migrate to CPUs in CPU_DOWN_PREPARE state to guarantee forward
   progress to wq/work flushes from DOWN_PREPARE callbacks.  Also, if
   a CPU comes back online, left running workers need to be rebound to
   the CPU ignoring PF_THREAD_BOUND restriction.

   Using kthread_bind() isn't feasible because kthread_bind() isn't
   synchronized against cpu online state and is allowed to put a
   thread on a dead cpu.

   Originally, force_cpus_allowed() was added which bypasses
   PF_THREAD_BOUND and active check.  The current version adds
   __set_cpus_allowed() function which takes @force param to do about
   the same thing (new version properly checks online state so it will
   never put a task on a dead cpu).  This is still temporary.

   I think the cleanest solution here would be making sure that nobody
   depends on kthread_bind() being able to put a task on a dead cpu
   and then allowing kthread_bind() to bind a task to cpus which are
   online by calling __set_cpus_allowed().  So, the interface visible
   outside will be set_cpus_allowed_ptr() for regular cases and
   kthread_bind() for kthreads.  I'll be happy to pursue this path if
   it can be agreed on.

C. While discussing issue B [3], Peter Zijlstra objected to the
   basic design of cmwq.  Peter's objections are...

   o1. It isn't a generic worker pool mechanism in that it can't serve
       cpu-intensive workloads because all works are affined to local
       cpus.

   o2. Allowing long (> 5s for example) running works isn't a good
       idea and by not allowing long running works, the need to
       migrate back workers when cpu comes back online can be removed.

   o3. It's a fork-fest.

   My rationales for each are

   r1. The first design goal of cmwq is solving the issues the current
       workqueue implementation has including hard to detect
       deadlocks, unexpectedly long latencies caused by long running
       works which share the workqueue and excessive number of worker
       threads necessitated by each workqueue having its own workers.

       cmwq solves these issues quite efficiently without depending on
       fragile and complex heuristics.  Concurrency is managed to
       minimal yet sufficient level, workers are reused as much as
       possible and only necessary number of workers are created and
       maintained.

       cmwq is cpu affine because its target workloads are not cpu
       intensive.  Most works are context hungry not cpu cycle hungry
       and as such providing the necessary context (or concurrency)
       from the local CPU is the most efficient way to serve them.

       The second design goal is to unify different async mechanisms
       in kernel.  Although cmwq wouldn't be able to serve CPU cycle
       intensive workload, most in-kernel async mechanisms are there
       to provide context and concurrency and they all can be
       converted to use cmwq.

       Async workloads which need to burn large amount of CPU cycles
       such as encryption and IO checksumming have pretty different
       requirements and worker pool designed to serve them would
       probably require fair amount of heuristics to determine the
       appropriate level of concurrency.  Workqueue API may be
       extended to cover such workloads by providing an anonymous CPU
       for those works to bind to but the underlying operation would
       be fairly different.  If this is something necessary, let's
       pursue it but I don't think it's exclusive with cmwq.

   r2. The only thing necessary to support long running works is the
       ability to rebind workers to the cpu if it comes back online
       and allowing long running works will allow most existing worker
       pools to be served by cmwq and also make CPU down/up latencies
       more predictable.

   r3. I don't think there is any way to implement shared worker pool
       without forking when more concurrency is required and the
       actual amount of forking would be low as cmwq scales the number
       of idle workers to keep according to the current concurrency
       level and uses rather long timeout (5min) for idlers.

We know what to do about A.  I'm pretty sure B can be solved one way
or another.  So, the biggest problem here is that whether the basic
design of cmwq itself is agreed on.  Being the author, I'm probably
pretty biased but I really think it's a good solution for the problems
it tries to solve and many other developers seem to agree on that
according to the first RFC round.  So, let's discuss.  If I missed
some points of the objection, please go ahead and add.


CHANGES FROM THE LAST RFC TAKE[1] AND PREP PATCHSET[4]
======================================================

* All scheduler related parts - notification, forced task migration
  and wake up from notification are re-done.  This part is still in
  flux and likely to change further.

* Barrier works are now uncolored.  They don't participate in
  workqueue flushing and don't contribute to the active count.  This
  change is necessary to enable max_active throttling.

* max_active throttling is added and freezing is reimplemented using
  it.  Fixed limit on total number of workers is removed.  It's now
  regulated by max_active.

* Singlethread workqueue is un-removed and works properly.  It's
  implemented as SINGLE_CPU workqueue with max_active == 1.

* The monster patch to implement cmwq is split into logical steps.

This patchset contains the following 27 patches.

 0001-sched-rename-preempt_notifiers-to-sched_notifiers-an.patch
 0002-sched-refactor-try_to_wake_up.patch
 0003-sched-implement-__set_cpus_allowed.patch
 0004-sched-make-sched_notifiers-unconditional.patch
 0005-sched-add-wakeup-sleep-sched_notifiers-and-allow-NUL.patch
 0006-sched-implement-try_to_wake_up_local.patch
 0007-acpi-use-queue_work_on-instead-of-binding-workqueue-.patch
 0008-stop_machine-reimplement-without-using-workqueue.patch
 0009-workqueue-misc-cosmetic-updates.patch
 0010-workqueue-merge-feature-parameters-into-flags.patch
 0011-workqueue-define-both-bit-position-and-mask-for-work.patch
 0012-workqueue-separate-out-process_one_work.patch
 0013-workqueue-temporarily-disable-workqueue-tracing.patch
 0014-workqueue-kill-cpu_populated_map.patch
 0015-workqueue-update-cwq-alignement.patch
 0016-workqueue-reimplement-workqueue-flushing-using-color.patch
 0017-workqueue-introduce-worker.patch
 0018-workqueue-reimplement-work-flushing-using-linked-wor.patch
 0019-workqueue-implement-per-cwq-active-work-limit.patch
 0020-workqueue-reimplement-workqueue-freeze-using-max_act.patch
 0021-workqueue-introduce-global-cwq-and-unify-cwq-locks.patch
 0022-workqueue-implement-worker-states.patch
 0023-workqueue-reimplement-CPU-hotplugging-support-using-.patch
 0024-workqueue-make-single-thread-workqueue-shared-worker.patch
 0025-workqueue-use-shared-worklist-and-pool-all-workers-p.patch
 0026-workqueue-implement-concurrency-managed-dynamic-work.patch
 0027-workqueue-increase-max_active-of-keventd-and-kill-cu.patch

0001-0006 are scheduler related changes.

0007-0008 changes two unusual users.  After the change, acpi creates
per-cpu workers which weren't necessary before but in the end it won't
be doing anything suboptimal.  stop_machine won't use workqueue from
this point on.

0009-0013 do misc preparations.  0007-0013 stayed about the same from
the previous round.

0014 kills cpu_populated_map, creates workers for all possible workers
and simplifies CPU hotplugging.

0015-0024 introduces new constructs step by step and reimplements
workqueue features so that they can be used with shared worker pool.

0025 makes all workqueues share per-cpu worklist and pool their
workers.  At this stage, all the pieces other than concurrency managed
worker pool is there.

0026 implements concurrency managed worker pool.  Even after this,
there is no visible behavior different to workqueue users as all
workqueues still have max_active of 1.

0027 increases max_active of keventd.  This patch isn't signed off
yet.  lockdep annotations need to be updated.

Each feature of cmwq has been verified using test scenarios (well, I
tried, at least).  In a reply, I'll attach the source of the test
module I used.

Things to do from here are...

* Hopefully, establish a stable tree.

* Audit workqueue users, drop unnecessary workqueues and make them use
  keventd.

* Restore workqueue tracing.

* Replace various in-kernel async mechanisms which are there to
  provide context and concurrency.

Diffstat follows.

 arch/ia64/kernel/smpboot.c   |    2 
 arch/ia64/kvm/Kconfig        |    1 
 arch/powerpc/kvm/Kconfig     |    1 
 arch/s390/kvm/Kconfig        |    1 
 arch/x86/kernel/smpboot.c    |    2 
 arch/x86/kvm/Kconfig         |    1 
 drivers/acpi/osl.c           |   41 
 include/linux/kvm_host.h     |    4 
 include/linux/preempt.h      |   48 
 include/linux/sched.h        |   71 +
 include/linux/stop_machine.h |    6 
 include/linux/workqueue.h    |   88 +
 init/Kconfig                 |    4 
 init/main.c                  |    2 
 kernel/power/process.c       |   21 
 kernel/sched.c               |  329 +++--
 kernel/stop_machine.c        |  151 ++
 kernel/trace/Kconfig         |    4 
 kernel/workqueue.c           | 2640 +++++++++++++++++++++++++++++++++++++------
 virt/kvm/kvm_main.c          |   26 
 20 files changed, 2783 insertions(+), 660 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/896268
[2] http://patchwork.kernel.org/patch/63119/
[3] http://thread.gmane.org/gmane.linux.kernel/921267
[4] http://thread.gmane.org/gmane.linux.kernel/917570

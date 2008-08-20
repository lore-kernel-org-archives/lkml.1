Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbYHTOUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbYHTOUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYHTOUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:20:10 -0400
Received: from ms01.sssup.it ([193.205.80.99]:49419 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751656AbYHTOUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:20:08 -0400
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Aug 2008 10:20:07 EDT
From: claudio@evidence.eu.com
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl,
       Claudio Scordino <claudio@evidence.eu.com>
Subject: [PATCH 1/1] New documentation about CFS.
Date: Wed, 20 Aug 2008 15:18:45 +0200
Message-Id: <1219238325-23964-1-git-send-email-claudio@evidence.eu.com>
X-Mailer: git-send-email 1.5.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Claudio Scordino <claudio@evidence.eu.com>


Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
---
 Documentation/scheduler/sched-design-CFS.txt |  371 +++++++++++++++-----------
 1 files changed, 218 insertions(+), 153 deletions(-)

diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
index 88bcb87..df601f4 100644
--- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -1,151 +1,218 @@
+                      =============
+                      CFS Scheduler
+                      =============
+
+
+1.  OVERVIEW
+
+CFS stands for "Completely Fair Scheduler," and is the new "desktop" process
+scheduler implemented by Ingo Molnar and merged in Linux 2.6.23.  It is the
+replacement for the previous vanilla scheduler's SCHED_OTHER interactivity
+code.
+
+80% of CFS's design can be summed up in a single sentence: CFS basically models
+an "ideal, precise multi-tasking CPU" on real hardware.
+
+"Ideal multi-tasking CPU" is a (non-existent  :-)) CPU that has 100% physical
+power and which can run each task at precise equal speed, in parallel, each at
+1/nr_running speed.  For example: if there are 2 tasks running, then it runs
+each at 50% physical power --- i.e., actually in parallel.
+
+On real hardware, we can run only a single task at once, so we have to
+introduce the concept of "virtual runtime."  The virtual runtime of a task
+specifies when its next timeslice would start execution on the ideal
+multi-tasking CPU described above.  In practice, the virtual runtime of a task
+is its actual runtime normalized to the total number of running tasks.
+
+
+
+2.  FEW IMPLEMENTATION DETAILS
+
+In CFS the virtual runtime is expressed and tracked via the per-task
+p->se.vruntime (nanosec-unit) value.  This way, it's possible to accurately
+timestamp and measure the "expected CPU time" a task should have gotten.
+
+[ small detail: on "ideal" hardware, at any time all tasks would have the same
+  p->se.vruntime value --- i.e., tasks would execute simultaneously and no task
+  would ever get "out of balance" from the "ideal" share of CPU time.  ]
+
+CFS's task picking logic is based on this p->se.vruntime value and it is thus
+very simple: it always tries to run the task with the smallest p->se.vruntime
+value (i.e., the task which executed least so far).  CFS always tries to split
+up CPU time between runnable tasks as close to "ideal multitasking hardware" as
+possible.
+
+Most of the rest of CFS's design just falls out of this really simple concept,
+with a few add-on embellishments like nice levels, multiprocessing and various
+algorithm variants to recognize sleepers.
+
+
+
+3.  THE RBTREE
+
+CFS's design is quite radical: it does not use the old data structures for the
+runqueues, but it uses a time-ordered rbtree to build a "timeline" of future
+task execution, and thus has no "array switch" artifacts (by which both the
+previous vanilla scheduler and RSDL/SD are affected).
+
+CFS also maintains the rq->cfs.min_vruntime value, which is a monotonic
+increasing value tracking the smallest vruntime among all tasks in the
+runqueue.  The total amount of work done by the system is tracked using
+min_vruntime; that value is used to place newly activated entities on the left
+side of the tree as much as possible.
+
+The total number of running tasks in the runqueue is accounted through the
+rq->cfs.load value, which is the sum of the weights of the tasks queued on the
+runqueue.
+
+CFS maintains a time-ordered rbtree, where all runnable tasks are sorted by the
+p->se.vruntime key (there is a subtraction using rq->cfs.min_vruntime to
+account for possible wraparounds).  CFS picks the "leftmost" task from this
+tree and sticks to it.
+As the system progresses forwards, the executed tasks are put into the tree
+more and more to the right --- slowly but surely giving a chance for every task
+to become the "leftmost task" and thus get on the CPU within a deterministic
+amount of time.
+
+Summing up, CFS works like this: it runs a task a bit, and when the task
+schedules (or a scheduler tick happens) the task's CPU usage is "accounted
+for": the (small) time it just spent using the physical CPU is added to
+p->se.vruntime.  Once p->se.vruntime gets high enough so that another task
+becomes the "leftmost task" of the time-ordered rbtree it maintains (plus a
+small amount of "granularity" distance relative to the leftmost task so that we
+do not over-schedule tasks and trash the cache), then the new leftmost task is
+picked and the current task is preempted.
+
+
+
+4.  SOME FEATURES OF CFS
+
+CFS uses nanosecond granularity accounting and does not rely on any jiffies or
+other HZ detail.  Thus the CFS scheduler has no notion of "timeslices" in the
+way the previous scheduler had, and has no heuristics whatsoever.  There is
+only one central tunable (you have to switch on CONFIG_SCHED_DEBUG):
+
+   /proc/sys/kernel/sched_granularity_ns
+
+which can be used to tune the scheduler from "desktop" (i.e., low latencies) to
+"server" (i.e., good batching) workloads.  It defaults to a setting suitable
+for desktop workloads.  SCHED_BATCH is handled by the CFS scheduler module too.
+
+Due to its design, the CFS scheduler is not prone to any of the "attacks" that
+exist today against the heuristics of the stock scheduler: fiftyp.c, thud.c,
+chew.c, ring-test.c, massive_intr.c all work fine and do not impact
+interactivity and produce the expected behavior.
+
+The CFS scheduler has a much stronger handling of nice levels and SCHED_BATCH
+than the previous vanilla scheduler: both types of workloads are isolated much
+more aggressively.
+
+SMP load-balancing has been reworked/sanitized: the runqueue-walking
+assumptions are gone from the load-balancing code now, and iterators of the
+scheduling modules are used.  The balancing code got quite a bit simpler as a
+result.
 
-This is the CFS scheduler.
-
-80% of CFS's design can be summed up in a single sentence: CFS basically
-models an "ideal, precise multi-tasking CPU" on real hardware.
-
-"Ideal multi-tasking CPU" is a (non-existent  :-))  CPU that has 100%
-physical power and which can run each task at precise equal speed, in
-parallel, each at 1/nr_running speed. For example: if there are 2 tasks
-running then it runs each at 50% physical power - totally in parallel.
-
-On real hardware, we can run only a single task at once, so while that
-one task runs, the other tasks that are waiting for the CPU are at a
-disadvantage - the current task gets an unfair amount of CPU time. In
-CFS this fairness imbalance is expressed and tracked via the per-task
-p->wait_runtime (nanosec-unit) value. "wait_runtime" is the amount of
-time the task should now run on the CPU for it to become completely fair
-and balanced.
-
-( small detail: on 'ideal' hardware, the p->wait_runtime value would
-  always be zero - no task would ever get 'out of balance' from the
-  'ideal' share of CPU time. )
-
-CFS's task picking logic is based on this p->wait_runtime value and it
-is thus very simple: it always tries to run the task with the largest
-p->wait_runtime value. In other words, CFS tries to run the task with
-the 'gravest need' for more CPU time. So CFS always tries to split up
-CPU time between runnable tasks as close to 'ideal multitasking
-hardware' as possible.
-
-Most of the rest of CFS's design just falls out of this really simple
-concept, with a few add-on embellishments like nice levels,
-multiprocessing and various algorithm variants to recognize sleepers.
-
-In practice it works like this: the system runs a task a bit, and when
-the task schedules (or a scheduler tick happens) the task's CPU usage is
-'accounted for': the (small) time it just spent using the physical CPU
-is deducted from p->wait_runtime. [minus the 'fair share' it would have
-gotten anyway]. Once p->wait_runtime gets low enough so that another
-task becomes the 'leftmost task' of the time-ordered rbtree it maintains
-(plus a small amount of 'granularity' distance relative to the leftmost
-task so that we do not over-schedule tasks and trash the cache) then the
-new leftmost task is picked and the current task is preempted.
-
-The rq->fair_clock value tracks the 'CPU time a runnable task would have
-fairly gotten, had it been runnable during that time'. So by using
-rq->fair_clock values we can accurately timestamp and measure the
-'expected CPU time' a task should have gotten. All runnable tasks are
-sorted in the rbtree by the "rq->fair_clock - p->wait_runtime" key, and
-CFS picks the 'leftmost' task and sticks to it. As the system progresses
-forwards, newly woken tasks are put into the tree more and more to the
-right - slowly but surely giving a chance for every task to become the
-'leftmost task' and thus get on the CPU within a deterministic amount of
-time.
-
-Some implementation details:
-
- - the introduction of Scheduling Classes: an extensible hierarchy of
-   scheduler modules. These modules encapsulate scheduling policy
-   details and are handled by the scheduler core without the core
-   code assuming about them too much.
-
- - sched_fair.c implements the 'CFS desktop scheduler': it is a
-   replacement for the vanilla scheduler's SCHED_OTHER interactivity
-   code.
-
-   I'd like to give credit to Con Kolivas for the general approach here:
-   he has proven via RSDL/SD that 'fair scheduling' is possible and that
-   it results in better desktop scheduling. Kudos Con!
-
-   The CFS patch uses a completely different approach and implementation
-   from RSDL/SD. My goal was to make CFS's interactivity quality exceed
-   that of RSDL/SD, which is a high standard to meet :-) Testing
-   feedback is welcome to decide this one way or another. [ and, in any
-   case, all of SD's logic could be added via a kernel/sched_sd.c module
-   as well, if Con is interested in such an approach. ]
-
-   CFS's design is quite radical: it does not use runqueues, it uses a
-   time-ordered rbtree to build a 'timeline' of future task execution,
-   and thus has no 'array switch' artifacts (by which both the vanilla
-   scheduler and RSDL/SD are affected).
-
-   CFS uses nanosecond granularity accounting and does not rely on any
-   jiffies or other HZ detail. Thus the CFS scheduler has no notion of
-   'timeslices' and has no heuristics whatsoever. There is only one
-   central tunable (you have to switch on CONFIG_SCHED_DEBUG):
-
-         /proc/sys/kernel/sched_granularity_ns
-
-   which can be used to tune the scheduler from 'desktop' (low
-   latencies) to 'server' (good batching) workloads. It defaults to a
-   setting suitable for desktop workloads. SCHED_BATCH is handled by the
-   CFS scheduler module too.
-
-   Due to its design, the CFS scheduler is not prone to any of the
-   'attacks' that exist today against the heuristics of the stock
-   scheduler: fiftyp.c, thud.c, chew.c, ring-test.c, massive_intr.c all
-   work fine and do not impact interactivity and produce the expected
-   behavior.
-
-   the CFS scheduler has a much stronger handling of nice levels and
-   SCHED_BATCH: both types of workloads should be isolated much more
-   agressively than under the vanilla scheduler.
-
-   ( another detail: due to nanosec accounting and timeline sorting,
-     sched_yield() support is very simple under CFS, and in fact under
-     CFS sched_yield() behaves much better than under any other
-     scheduler i have tested so far. )
-
- - sched_rt.c implements SCHED_FIFO and SCHED_RR semantics, in a simpler
-   way than the vanilla scheduler does. It uses 100 runqueues (for all
-   100 RT priority levels, instead of 140 in the vanilla scheduler)
-   and it needs no expired array.
-
- - reworked/sanitized SMP load-balancing: the runqueue-walking
-   assumptions are gone from the load-balancing code now, and
-   iterators of the scheduling modules are used. The balancing code got
-   quite a bit simpler as a result.
-
-
-Group scheduler extension to CFS
-================================
-
-Normally the scheduler operates on individual tasks and strives to provide
-fair CPU time to each task. Sometimes, it may be desirable to group tasks
-and provide fair CPU time to each such task group. For example, it may
-be desirable to first provide fair CPU time to each user on the system
-and then to each task belonging to a user.
-
-CONFIG_FAIR_GROUP_SCHED strives to achieve exactly that. It lets
-SCHED_NORMAL/BATCH tasks be be grouped and divides CPU time fairly among such
-groups. At present, there are two (mutually exclusive) mechanisms to group
-tasks for CPU bandwidth control purpose:
-
-	- Based on user id (CONFIG_FAIR_USER_SCHED)
-		In this option, tasks are grouped according to their user id.
-	- Based on "cgroup" pseudo filesystem (CONFIG_FAIR_CGROUP_SCHED)
-		This options lets the administrator create arbitrary groups
-		of tasks, using the "cgroup" pseudo filesystem. See
-		Documentation/cgroups.txt for more information about this
-		filesystem.
 
-Only one of these options to group tasks can be chosen and not both.
 
-Group scheduler tunables:
+5.  SCHEDULING CLASSES
 
-When CONFIG_FAIR_USER_SCHED is defined, a directory is created in sysfs for
-each new user and a "cpu_share" file is added in that directory.
+The new CFS scheduler has been designed in such a way to introduce "Scheduling
+Classes," an extensible hierarchy of scheduler modules.  These modules
+encapsulate scheduling policy details and are handled by the scheduler core
+without the core code assuming too much about them.
+
+sched_fair.c implements the CFS scheduler described above.
+
+sched_rt.c implements SCHED_FIFO and SCHED_RR semantics, in a simpler way than
+the previous vanilla scheduler did.  It uses 100 runqueues (for all 100 RT
+priority levels, instead of 140 in the previous scheduler) and it needs no
+expired array.
+
+Scheduling classes are implemented through the sched_class structure, which
+contains hooks to functions that must be called whenever an interesting event
+occurs.
+
+This is the (partial) list of the hooks:
+
+ - enqueue_task(...)
+
+   Called when a task enters a runnable state.
+   It puts the scheduling entity (task) into the red-black tree and
+   increments the nr_running variable.
+
+ - dequeue_tree(...)
+
+   When a task is no longer runnable, this function is called to keep the
+   corresponding scheduling entity out of the red-black tree.  It decrements
+   the nr_running variable.
+
+ - yield_task(...)
+	
+   This function is basically just a dequeue followed by an enqueue, unless the
+   compat_yield sysctl is turned on; in that case, it places the scheduling
+   entity at the right-most end of the red-black tree.
+	
+ - check_preempt_curr(...)
+   
+   This function checks if a task that entered the runnable state should
+   preempt the currently running task.
+
+ - pick_next_task(...)
+
+   This function chooses the most appropriate task eligible to run next. 
+
+ - set_curr_task(...)
+	
+   This function is called when a task changes its scheduling class or changes
+   its task group. 
+
+ - task_tick(...)
+
+   This function is mostly called from time tick functions; it might lead to
+   process switch.  This drives the running preemption. 
+
+ - task_new(...)
+
+   The core scheduler gives the scheduling module an opportunity to manage new
+   task startup.  The CFS scheduling module uses it for group scheduling, while
+   the scheduling module for a real-time task does not use it.
+
+
+
+6.  GROUP SCHEDULER EXTENSIONS TO CFS
+
+Normally, the scheduler operates on individual tasks and strives to provide
+fair CPU time to each task.  Sometimes, it may be desirable to group tasks and
+provide fair CPU time to each such task group.  For example, it may be
+desirable to first provide fair CPU time to each user on the system and then to
+each task belonging to a user.
+
+CONFIG_GROUP_SCHED strives to achieve exactly that.  It lets tasks to be
+grouped and divides CPU time fairly among such groups. 
+
+CONFIG_RT_GROUP_SCHED permits to group real-time (i.e., SCHED_FIFO and
+SCHED_RR) tasks.
+
+CONFIG_FAIR_GROUP_SCHED permits to group CFS (i.e., SCHED_NORMAL and
+SCHED_BATCH) tasks.
+
+At present, there are two (mutually exclusive) mechanisms to group tasks for
+CPU bandwidth control purposes:
+
+ - Based on user id (CONFIG_USER_SCHED)
+   
+   With this option, tasks are grouped according to their user id.
+
+ - Based on "cgroup" pseudo filesystem (CONFIG_CGROUP_SCHED)
+   
+   This options needs CONFIG_CGROUPS to be defined, and lets the administrator
+   create arbitrary groups of tasks, using the "cgroup" pseudo filesystem.  See
+   Documentation/cgroups.txt for more information about this filesystem.
+
+Only one of these options to group tasks can be chosen and not both.
+
+When CONFIG_USER_SCHED is defined, a directory is created in sysfs for each new
+user and a "cpu_share" file is added in that directory.
 
 	# cd /sys/kernel/uids
 	# cat 512/cpu_share		# Display user 512's CPU share
@@ -155,16 +222,14 @@ each new user and a "cpu_share" file is added in that directory.
 	2048
 	#
 
-CPU bandwidth between two users are divided in the ratio of their CPU shares.
-For ex: if you would like user "root" to get twice the bandwidth of user
-"guest", then set the cpu_share for both the users such that "root"'s
-cpu_share is twice "guest"'s cpu_share
-
+CPU bandwidth between two users is divided in the ratio of their CPU shares.
+For example: if you would like user "root" to get twice the bandwidth of user
+"guest," then set the cpu_share for both the users such that "root"'s cpu_share
+is twice "guest"'s cpu_share.
 
-When CONFIG_FAIR_CGROUP_SCHED is defined, a "cpu.shares" file is created
-for each group created using the pseudo filesystem. See example steps
-below to create task groups and modify their CPU share using the "cgroups"
-pseudo filesystem
+When CONFIG_CGROUP_SCHED is defined, a "cpu.shares" file is created for each
+group created using the pseudo filesystem.  See example steps below to create
+task groups and modify their CPU share using the "cgroups" pseudo filesystem.
 
 	# mkdir /dev/cpuctl
 	# mount -t cgroup -ocpu none /dev/cpuctl
-- 
1.5.4.3


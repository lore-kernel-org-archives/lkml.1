Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbXI1LD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbXI1LD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 07:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbXI1LDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 07:03:20 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:24100 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbXI1LDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 07:03:19 -0400
Date: Fri, 28 Sep 2007 15:02:56 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Uninline scheduler
Message-ID: <20070928110253.GA6756@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* save ~300 bytes
* activate_idle_task() was moved to avoid a warning

bloat-o-meter output:

add/remove: 6/0 grow/shrink: 0/16 up/down: 438/-733 (-295)		<===
function                                     old     new   delta
__enqueue_entity                               -     165    +165
finish_task_switch                             -     110    +110
update_curr_rt                                 -      79     +79
__load_balance_iterator                        -      32     +32
__task_rq_unlock                               -      28     +28
find_process_by_pid                            -      24     +24
do_sched_setscheduler                        133     123     -10
sys_sched_rr_get_interval                    176     165     -11
sys_sched_getparam                           156     145     -11
normalize_rt_tasks                           482     470     -12
sched_getaffinity                            112      99     -13
sys_sched_getscheduler                        86      72     -14
sched_setaffinity                            226     212     -14
sched_setscheduler                           666     642     -24
load_balance_start_fair                       33       9     -24
load_balance_next_fair                        33       9     -24
dequeue_task_rt                              133      67     -66
put_prev_task_rt                              97      28     -69
schedule_tail                                133      50     -83
schedule                                     682     594     -88
enqueue_entity                               499     366    -133
task_new_fair                                317     180    -137

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 kernel/sched.c      |   46 +++++++++++++++++++++++-----------------------
 kernel/sched_fair.c |    8 +++-----
 kernel/sched_rt.c   |    2 +-
 3 files changed, 27 insertions(+), 29 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -529,7 +529,7 @@ repeat_lock_task:
 	return rq;
 }
 
-static inline void __task_rq_unlock(struct rq *rq)
+static void __task_rq_unlock(struct rq *rq)
 	__releases(rq->lock)
 {
 	spin_unlock(&rq->lock);
@@ -544,7 +544,7 @@ static inline void task_rq_unlock(struct rq *rq, unsigned long *flags)
 /*
  * this_rq_lock - lock this runqueue and disable interrupts.
  */
-static inline struct rq *this_rq_lock(void)
+static struct rq *this_rq_lock(void)
 	__acquires(rq->lock)
 {
 	struct rq *rq;
@@ -951,20 +951,6 @@ static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
 }
 
 /*
- * activate_idle_task - move idle task to the _front_ of runqueue.
- */
-static inline void activate_idle_task(struct task_struct *p, struct rq *rq)
-{
-	update_rq_clock(rq);
-
-	if (p->state == TASK_UNINTERRUPTIBLE)
-		rq->nr_uninterruptible--;
-
-	enqueue_task(rq, p, 0);
-	inc_nr_running(p, rq);
-}
-
-/*
  * deactivate_task - remove a task from the runqueue.
  */
 static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
@@ -1173,7 +1159,7 @@ void kick_process(struct task_struct *p)
  * We want to under-estimate the load of migration sources, to
  * balance conservatively.
  */
-static inline unsigned long source_load(int cpu, int type)
+static unsigned long source_load(int cpu, int type)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
@@ -1188,7 +1174,7 @@ static inline unsigned long source_load(int cpu, int type)
  * Return a high guess at the load of a migration-target cpu weighted
  * according to the scheduling class and "nice" value.
  */
-static inline unsigned long target_load(int cpu, int type)
+static unsigned long target_load(int cpu, int type)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
@@ -1799,7 +1785,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
  * with the lock held can cause deadlocks; see schedule() for
  * details.)
  */
-static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
+static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	__releases(rq->lock)
 {
 	struct mm_struct *mm = rq->prev_mm;
@@ -3032,7 +3018,7 @@ static DEFINE_SPINLOCK(balancing);
  *
  * Balancing parameters are set up in arch_init_sched_domains.
  */
-static inline void rebalance_domains(int cpu, enum cpu_idle_type idle)
+static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 {
 	int balance = 1;
 	struct rq *rq = cpu_rq(cpu);
@@ -4137,7 +4123,7 @@ struct task_struct *idle_task(int cpu)
  * find_process_by_pid - find a process with a matching PID value.
  * @pid: the pid in question.
  */
-static inline struct task_struct *find_process_by_pid(pid_t pid)
+static struct task_struct *find_process_by_pid(pid_t pid)
 {
 	return pid ? find_task_by_pid(pid) : current;
 }
@@ -4908,7 +4894,7 @@ cpumask_t nohz_cpu_mask = CPU_MASK_NONE;
  *
  * This idea comes from the SD scheduler of Con Kolivas:
  */
-static inline void sched_init_granularity(void)
+static void sched_init_granularity(void)
 {
 	unsigned int factor = 1 + ilog2(num_online_cpus());
 	const unsigned long limit = 100000000;
@@ -5172,6 +5158,20 @@ static void migrate_live_tasks(int src_cpu)
 }
 
 /*
+ * activate_idle_task - move idle task to the _front_ of runqueue.
+ */
+static void activate_idle_task(struct task_struct *p, struct rq *rq)
+{
+	update_rq_clock(rq);
+
+	if (p->state == TASK_UNINTERRUPTIBLE)
+		rq->nr_uninterruptible--;
+
+	enqueue_task(rq, p, 0);
+	inc_nr_running(p, rq);
+}
+
+/*
  * Schedules idle task to be the next runnable task on current CPU.
  * It does so by boosting its priority to highest possible and adding it to
  * the _front_ of the runqueue. Used by CPU offline code.
@@ -6511,7 +6511,7 @@ int in_sched_functions(unsigned long addr)
 		&& addr < (unsigned long)__sched_text_end);
 }
 
-static inline void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
+static void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
 {
 	cfs_rq->tasks_timeline = RB_ROOT;
 	cfs_rq->fair_clock = 1;
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -163,8 +163,7 @@ static inline struct task_struct *task_of(struct sched_entity *se)
 /*
  * Enqueue an entity into the rb-tree:
  */
-static inline void
-__enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
 	struct rb_node *parent = NULL;
@@ -716,8 +715,7 @@ __check_preempt_curr_fair(struct cfs_rq *cfs_rq, struct sched_entity *se,
 		resched_task(rq_of(cfs_rq)->curr);
 }
 
-static inline void
-set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static void set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	/*
 	 * Any task has to be enqueued before it get to execute on
@@ -1031,7 +1029,7 @@ static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
  * achieve that by always pre-iterating before returning
  * the current task:
  */
-static inline struct task_struct *
+static struct task_struct *
 __load_balance_iterator(struct cfs_rq *cfs_rq, struct rb_node *curr)
 {
 	struct task_struct *p;
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -7,7 +7,7 @@
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
  */
-static inline void update_curr_rt(struct rq *rq)
+static void update_curr_rt(struct rq *rq)
 {
 	struct task_struct *curr = rq->curr;
 	u64 delta_exec;


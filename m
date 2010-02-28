Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936562Ab0B1TRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:17:37 -0500
Received: from ms01.sssup.it ([193.205.80.99]:42298 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936423Ab0B1TRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:17:33 -0500
Subject: [RFC][PATCH 02/11] sched: SCHED_DEADLINE policy implementation.
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>, Henrik Austad <henrik@austad.us>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@retis.sssup.it>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>,
       Nicola Manica <nicola.manica@gmail.com>,
       Luca Abeni <luca.abeni@unitn.it>
In-Reply-To: <1267383976.13676.79.camel@Palantir>
References: <1267383976.13676.79.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3SmJY3FcHHoXs0/Rfd1j"
Date: Sun, 28 Feb 2010 20:17:19 +0100
Message-ID: <1267384639.13676.87.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3SmJY3FcHHoXs0/Rfd1j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add a scheduling class, in sched_dl.c and a new policy called
SCHED_DEADLINE. It basically is an implementation of the Earliest
Deadline First (EDF) scheduling algorithm, augmented with a mechanism
(called Constant Bandwidth Server, CBS) that make it possible to
isolate the behaviour of tasks between each other.

The typical -deadline task will be made up of a computation phase
(instance) which is activated on a periodic or sporadic fashion. The
expected (maximum) duration of such computation is called the task's
runtime; the time interval by which each instance need to be completed
is called the task's relative deadline. The task's absolute deadline
is dynamically calculated as the time instant a task (better, an
instance) activates plus the relative deadline.

The EDF algorithms selects the task with the smallest absolute
deadline as the one to be executed first, while the CBS ensures each
task to run for at most the its runtime every (relative) deadline
length time interval, avoiding any interference between different
tasks (bandwidth isolation).
Thanks to this feature, also tasks that do not strictly comply with
the computational model sketched above can effectively use the new
policy.

This patch:
 - defines the new scheduling policy and all the new data structures
   needed for its core implementation (e.g., task parameters storage,
   runqueues, etc.), and takes care of their initialization;
 - implements the core logic of the scheduling algorithm in the new
   scheduling class file;
 - provides all the glue code between the new scheduling class and
   the core scheduler and narrows the interactions between sched_dl
   and the other existing scheduling classes.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Michael Trimarchi <trimarchimichael@yahoo.it>
Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
---
 include/linux/sched.h |   61 +++++
 kernel/fork.c         |   12 +
 kernel/hrtimer.c      |    2 +-
 kernel/sched.c        |   58 ++++-
 kernel/sched_dl.c     |  606 +++++++++++++++++++++++++++++++++++++++++++++=
++++
 kernel/sched_fair.c   |    2 +-
 kernel/sched_rt.c     |    2 +-
 7 files changed, 731 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d1de995..cd24a7a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -38,6 +38,7 @@
 #define SCHED_BATCH		3
 /* SCHED_ISO: reserved but not implemented yet */
 #define SCHED_IDLE		5
+#define SCHED_DEADLINE		6
 /* Can be ORed in to make sure the process is reverted back to SCHED_NORMA=
L on fork */
 #define SCHED_RESET_ON_FORK     0x40000000
=20
@@ -1228,6 +1229,53 @@ struct sched_rt_entity {
 #endif
 };
=20
+/*
+ * Scheduler internal flags.
+ *
+ * These values are only known by the scheduler and are intended to not
+ * be exported to userspace. On the other hand, bits lower than the 16th
+ * are reserved for the userspace to use them to (try to) affect the
+ * scheduler behaviour, and that's why we start from 0x10000.
+ *
+ *  @DL_NEW        tells us that a new instance arrived and that we must
+ *                 start executing it with full runtime and with absolute
+ *                 deadline just dl_deadline away from that time;
+ *  @DL_THROTTLED  tells us that the last instance exhausted the runtime
+ *                 and that the task is waiting for a replenishment to
+ *                 be performed at the next firing of dl_timer.
+ */
+#define DL_NEW			0x00010000
+#define DL_THROTTLED		0x00020000
+
+struct sched_dl_entity {
+	struct rb_node	rb_node;
+	int nr_cpus_allowed;
+
+	/*
+	 * Original parameters. They are copied here  from sched_param_ex
+	 * during sched_setscheduler_ex(), and will remain the same until the
+	 * next sched_setscheduler_ex().
+	 */
+	u64 dl_runtime;		/* maximum runtime for each instance 	*/
+	u64 dl_deadline;	/* relative deadline of each instance	*/
+
+	/*
+	 * Actual scheduling parameters. They are initialized with the
+	 * values above, but they are updated by the scheduler accordingly
+	 * to the task behaviour. Note that the remaining runtime could
+	 * be < 0 in case we are in overrun.
+	 */
+	s64 runtime;		/* remaining runtime for this instance	*/
+	u64 deadline;		/* absolute deadline for this instance	*/
+	unsigned int flags;
+
+	/*
+	 * Bandwidth enforcement timer. In fact, since each task has its
+	 * own bandwidth to be enforced, we need one timer per task.
+	 */
+	struct hrtimer dl_timer;
+};
+
 struct rcu_node;
=20
 struct task_struct {
@@ -1250,6 +1298,7 @@ struct task_struct {
 	const struct sched_class *sched_class;
 	struct sched_entity se;
 	struct sched_rt_entity rt;
+	struct sched_dl_entity dl;
=20
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
@@ -1603,6 +1652,18 @@ static inline int rt_task(struct task_struct *p)
 	return rt_prio(p->prio);
 }
=20
+static inline int dl_policy(int policy)
+{
+	if (unlikely(policy =3D=3D SCHED_DEADLINE))
+		return 1;
+	return 0;
+}
+
+static inline int dl_task(struct task_struct *p)
+{
+	return dl_policy(p->policy);
+}
+
 static inline struct pid *task_pid(struct task_struct *task)
 {
 	return task->pids[PIDTYPE_PID].pid;
diff --git a/kernel/fork.c b/kernel/fork.c
index f88bd98..10d3753 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -937,6 +937,16 @@ SYSCALL_DEFINE1(set_tid_address, int __user *, tidptr)
 	return task_pid_vnr(current);
 }
=20
+static void init_task_dl_entity(struct task_struct *p)
+{
+	RB_CLEAR_NODE(&p->dl.rb_node);
+	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+
+	p->dl.dl_runtime =3D p->dl.runtime =3D 0;
+	p->dl.dl_deadline =3D p->dl.deadline =3D 0;
+	p->dl.flags =3D 0;
+}
+
 static void rt_mutex_init_task(struct task_struct *p)
 {
 	raw_spin_lock_init(&p->pi_lock);
@@ -1025,6 +1035,8 @@ static struct task_struct *copy_process(unsigned long=
 clone_flags,
=20
 	ftrace_graph_init_task(p);
=20
+	init_task_dl_entity(p);
+
 	rt_mutex_init_task(p);
=20
 #ifdef CONFIG_PROVE_LOCKING
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0086628..e59c2de 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1571,7 +1571,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct =
timespec __user *rmtp,
 	unsigned long slack;
=20
 	slack =3D current->timer_slack_ns;
-	if (rt_task(current))
+	if (dl_task(current) || rt_task(current))
 		slack =3D 0;
=20
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
diff --git a/kernel/sched.c b/kernel/sched.c
index 532dcf1..c5ee6f9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -131,6 +131,11 @@ static inline int task_has_rt_policy(struct task_struc=
t *p)
 	return rt_policy(p->policy);
 }
=20
+static inline int task_has_dl_policy(struct task_struct *p)
+{
+	return dl_policy(p->policy);
+}
+
 /*
  * This is the priority-queue data structure of the RT scheduling class:
  */
@@ -482,6 +487,14 @@ struct rt_rq {
 #endif
 };
=20
+struct dl_rq {
+	/* runqueue is an rbtree, ordered by deadline */
+	struct rb_root rb_root;
+	struct rb_node *rb_leftmost;
+
+	unsigned long dl_nr_running;
+};
+
 #ifdef CONFIG_SMP
=20
 /*
@@ -544,6 +557,7 @@ struct rq {
=20
 	struct cfs_rq cfs;
 	struct rt_rq rt;
+	struct dl_rq dl;
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
@@ -1838,11 +1852,12 @@ static inline void __set_task_cpu(struct task_struc=
t *p, unsigned int cpu)
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
+#include "sched_dl.c"
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
 #endif
=20
-#define sched_class_highest (&rt_sched_class)
+#define sched_class_highest (&dl_sched_class)
 #define for_each_class(class) \
    for (class =3D sched_class_highest; class; class =3D class->next)
=20
@@ -1858,7 +1873,7 @@ static void dec_nr_running(struct rq *rq)
=20
 static void set_load_weight(struct task_struct *p)
 {
-	if (task_has_rt_policy(p)) {
+	if (task_has_dl_policy(p) || task_has_rt_policy(p)) {
 		p->se.load.weight =3D prio_to_weight[0] * 2;
 		p->se.load.inv_weight =3D prio_to_wmult[0] >> 1;
 		return;
@@ -1930,7 +1945,12 @@ static inline int normal_prio(struct task_struct *p)
 {
 	int prio;
=20
-	if (task_has_rt_policy(p))
+	if (task_has_dl_policy(p)) {
+		/*
+		 * FIXME: horrible hack here... Deadline inheritance needed!!
+		 */
+		prio =3D -(1<<7);
+	} else if (task_has_rt_policy(p))
 		prio =3D MAX_RT_PRIO-1 - p->rt_priority;
 	else
 		prio =3D __normal_prio(p);
@@ -2589,7 +2609,8 @@ void sched_fork(struct task_struct *p, int clone_flag=
s)
 	 * Revert to default priority/policy on fork if requested.
 	 */
 	if (unlikely(p->sched_reset_on_fork)) {
-		if (p->policy =3D=3D SCHED_FIFO || p->policy =3D=3D SCHED_RR) {
+		if (p->policy =3D=3D SCHED_DEADLINE ||
+		    p->policy =3D=3D SCHED_FIFO || p->policy =3D=3D SCHED_RR) {
 			p->policy =3D SCHED_NORMAL;
 			p->normal_prio =3D p->static_prio;
 		}
@@ -2612,7 +2633,14 @@ void sched_fork(struct task_struct *p, int clone_fla=
gs)
 	 */
 	p->prio =3D current->normal_prio;
=20
-	if (!rt_prio(p->prio))
+	/*
+	 * FIXME: deadline inheritance needed here!!
+	 */
+	if (dl_task(p))
+		p->sched_class =3D &dl_sched_class;
+	else if (rt_prio(p->prio))
+		p->sched_class =3D &rt_sched_class;
+	else
 		p->sched_class =3D &fair_sched_class;
=20
 	if (p->sched_class->task_fork)
@@ -6071,7 +6099,12 @@ void rt_mutex_setprio(struct task_struct *p, int pri=
o)
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
=20
-	if (rt_prio(prio))
+	/*
+	 * FIXME: deadline inheritance needed here!!
+	 */
+	if (dl_task(p))
+		p->sched_class =3D &dl_sched_class;
+	else if (rt_prio(prio))
 		p->sched_class =3D &rt_sched_class;
 	else
 		p->sched_class =3D &fair_sched_class;
@@ -6108,9 +6141,9 @@ void set_user_nice(struct task_struct *p, long nice)
 	 * The RT priorities are set via sched_setscheduler(), but we still
 	 * allow the 'normal' nice value to be set - but as expected
 	 * it wont have any effect on scheduling until the task is
-	 * SCHED_FIFO/SCHED_RR:
+	 * SCHED_DEADLINE, SCHED_FIFO or SCHED_RR:
 	 */
-	if (task_has_rt_policy(p)) {
+	if (task_has_dl_policy(p) || task_has_rt_policy(p)) {
 		p->static_prio =3D NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
@@ -6298,7 +6331,8 @@ recheck:
 		reset_on_fork =3D !!(policy & SCHED_RESET_ON_FORK);
 		policy &=3D ~SCHED_RESET_ON_FORK;
=20
-		if (policy !=3D SCHED_FIFO && policy !=3D SCHED_RR &&
+		if (policy !=3D SCHED_DEADLINE &&
+				policy !=3D SCHED_FIFO && policy !=3D SCHED_RR &&
 				policy !=3D SCHED_NORMAL && policy !=3D SCHED_BATCH &&
 				policy !=3D SCHED_IDLE)
 			return -EINVAL;
@@ -9415,6 +9449,11 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct r=
q *rq)
 #endif
 }
=20
+static void init_dl_rq(struct dl_rq *dl_rq, struct rq *rq)
+{
+	dl_rq->rb_root =3D RB_ROOT;
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq=
,
 				struct sched_entity *se, int cpu, int add,
@@ -9573,6 +9612,7 @@ void __init sched_init(void)
 		rq->calc_load_update =3D jiffies + LOAD_FREQ;
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
+		init_dl_rq(&rq->dl, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.shares =3D init_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
new file mode 100644
index 0000000..7585227
--- /dev/null
+++ b/kernel/sched_dl.c
@@ -0,0 +1,606 @@
+/*
+ * Deadline Scheduling Class (SCHED_DEADLINE)
+ *
+ * Earliest Deadline First (EDF) + Constant Bandwidth Server (CBS).
+ *
+ * Tasks that periodically executes their instances for less than their
+ * runtime won't miss any of their deadlines.
+ * Tasks that are not periodic or sporadic or that tries to execute more
+ * than their reserved bandwidth will be slowed down (and may potentially
+ * miss some of their deadlines), and won't affect any other task.
+ *
+ * Copyright (C) 2010 Dario Faggioli <raistlin@linux.it>,
+ *                    Michael Trimarchi <trimarchimichael@yahoo.it>,
+ *                    Fabio Checconi <fabio@gandalf.sssup.it>
+ */
+
+static const struct sched_class dl_sched_class;
+
+static inline struct task_struct *dl_task_of(struct sched_dl_entity *dl_se=
)
+{
+	return container_of(dl_se, struct task_struct, dl);
+}
+
+static inline struct rq *rq_of_dl_rq(struct dl_rq *dl_rq)
+{
+	return container_of(dl_rq, struct rq, dl);
+}
+
+static inline struct dl_rq *dl_rq_of_se(struct sched_dl_entity *dl_se)
+{
+	struct task_struct *p =3D dl_task_of(dl_se);
+	struct rq *rq =3D task_rq(p);
+
+	return &rq->dl;
+}
+
+static inline int on_dl_rq(struct sched_dl_entity *dl_se)
+{
+	return !RB_EMPTY_NODE(&dl_se->rb_node);
+}
+
+static inline int dl_time_before(u64 a, u64 b)
+{
+	return (s64)(a - b) < 0;
+}
+
+static void enqueue_dl_entity(struct sched_dl_entity *dl_se);
+static void dequeue_dl_entity(struct sched_dl_entity *dl_se);
+static void check_dl_preempt_curr(struct task_struct *p, struct rq *rq);
+
+/*
+ * We are being explicitly informed that a new task instance is starting,
+ * and this means that:
+ *  - the absolute deadline of the task has to be placed at
+ *    current time + relative deadline;
+ *  - the runtime of the task has to be set to the maximum value.
+ *
+ * The capability of specifying such event is useful whenever a -deadline
+ * task wants to (try to!) synchronize its behaviour with the scheduler's
+ * one, and to (try to!) reconcile itself with its own scheduling
+ * parameters.
+ */
+static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
+	struct rq *rq =3D rq_of_dl_rq(dl_rq);
+
+	WARN_ON(!(dl_se->flags & DL_NEW) || dl_se->flags & DL_THROTTLED);
+
+	dl_se->deadline =3D rq->clock + dl_se->dl_deadline;
+	dl_se->runtime =3D dl_se->dl_runtime;
+	dl_se->flags &=3D ~DL_NEW;
+}
+
+/*
+ * Pure Earliest Deadline First (EDF) scheduling does not deal with the
+ * possibility of a task lasting more than what it declared, and thus
+ * exhausting its runtime.
+ *
+ * Here we are interested in making runtime overrun possible, but we do
+ * not want a task which is misbehaving to affect the scheduling of all
+ * other tasks.
+ * Therefore, a budgeting strategy called Constant Bandwidth Server (CBS)
+ * is used, in order to confine each task within its own bandwidth.
+ *
+ * This function deals exactly with that, and ensures that when the runtim=
e
+ * of a task is replenished, its deadline is also postponed. That results
+ * in "priority unboosting" for the overrunning task, and makes it impossi=
ble
+ * for it to cause unexpected interfere to other tasks in the system.
+ */
+static void replenish_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
+	struct rq *rq =3D rq_of_dl_rq(dl_rq);
+
+	/*
+	 * We Keep moving the deadline away until we get some
+	 * available runtime for the task. This ensures correct
+	 * handling of situations where the runtime overrun is
+	 * arbitrary large.
+	 */
+	while (dl_se->runtime <=3D 0) {
+		dl_se->deadline +=3D dl_se->dl_deadline;
+		dl_se->runtime +=3D dl_se->dl_runtime;
+	}
+
+	WARN_ON(dl_se->runtime > dl_se->dl_runtime);
+	WARN_ON(dl_time_before(dl_se->deadline, rq->clock));
+}
+
+/*
+ * Here we check if --at time t-- a task (which is probably being
+ * [re]activated or, in general, enqueued) can use its remaining runtime
+ * and its current deadline _without_ exceeding the bandwidth it is
+ * assigned (function returns true if it can).
+ *
+ * For this to hold, we must check if:
+ *   runtime / (deadline - t) < dl_runtime / dl_deadline .
+ */
+static bool dl_check_bandwidth(struct sched_dl_entity *dl_se, u64 t)
+{
+	u64 left, right;
+
+	/*
+	 * left and right are the two sides of the equation above,
+	 * after a bit of shuffling to use multiplications instead
+	 * of divisions.
+	 */
+	left =3D dl_se->dl_deadline * dl_se->runtime;
+	right =3D (dl_se->deadline - t) * dl_se->dl_runtime;
+
+	return dl_time_before(left, right);
+}
+
+/*
+ * When a -deadline task is queued back on the runqueue, its runtime and
+ * deadline might need updating.
+ *
+ * The policy here is that we update the deadline of the task only if:
+ *  - the current deadline is in the past,
+ *  - using the remaining remaining with the current deadline would make
+ *    the task exceed its bandwidth.
+ */
+static void update_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
+	struct rq *rq =3D rq_of_dl_rq(dl_rq);
+
+	/*
+	 * The arrival of a new task (or of a new task instance) needs
+	 * special treatment. The actual scheduling parameters have to be
+	 * "renewed" instead of recalculatetd accordingly to the bandwidth
+	 * enforcement rule.
+	 */
+	if (dl_se->flags & DL_NEW) {
+		setup_new_dl_entity(dl_se);
+		return;
+	}
+
+	if (dl_time_before(dl_se->deadline, rq->clock))
+		goto update;
+
+	if (!dl_check_bandwidth(dl_se, rq->clock)) {
+update:
+		dl_se->deadline =3D rq->clock + dl_se->dl_deadline;
+		dl_se->runtime =3D dl_se->dl_runtime;
+	}
+}
+
+/*
+ * If the task depleted all its runtime, and if we want it to sleep
+ * while waiting for some new execution time to become available to it,
+ * we set the bandwidth enforcement timer to the replenishment instant
+ * and try to activate it.
+ *
+ * Notice that it is important for the caller to know if the timer
+ * actually started of if it did not because the replenishment instant
+ * already passed.
+ */
+static int start_dl_timer(struct sched_dl_entity *dl_se, u64 wakeup)
+{
+	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
+	struct rq *rq =3D rq_of_dl_rq(dl_rq);
+	ktime_t now, act;
+	ktime_t soft, hard;
+	unsigned long range;
+	s64 delta;
+
+	/*
+	 * Arm the timer to fire at wakeup, tying to compensate for
+	 * the fact that wakeup is actually coming from rq->clock and
+	 * not from hrtimer's time base reading.
+	 */
+	act =3D ns_to_ktime(wakeup);
+	now =3D hrtimer_cb_get_time(&dl_se->dl_timer);
+	delta =3D ktime_to_ns(now) - rq->clock;
+	act =3D ktime_add_ns(act, delta);
+
+	hrtimer_set_expires(&dl_se->dl_timer, act);
+
+	soft =3D hrtimer_get_softexpires(&dl_se->dl_timer);
+	hard =3D hrtimer_get_expires(&dl_se->dl_timer);
+	range =3D ktime_to_ns(ktime_sub(hard, soft));
+	__hrtimer_start_range_ns(&dl_se->dl_timer, soft,
+				 range, HRTIMER_MODE_ABS, 0);
+
+	return hrtimer_active(&dl_se->dl_timer);
+}
+
+/*
+ * This is the bandwidth enforcement timer callback. If here, we know
+ * the task is not on its dl_rq, since the fact that the timer was running
+ * means the task is throttled and needs a runtime replenishment.
+ *
+ * However, what we actually do depends on the fact the task is active,
+ * --i.e., it is on its rq-- or has been removed from there by a call to
+ * dequeue_task_dl(). In fact, in the former case we must issue the runtim=
e
+ * replenishment and add the task back to the dl_rq; in the latter, we jus=
t
+ * do nothing but clearing the DL_THROTTLED flag, so that the runtime and
+ * deadline updating and the queueing back to dl_rq will be done by the
+ * next call to enqueue_task_dl().
+ */
+static enum hrtimer_restart dl_timer(struct hrtimer *timer)
+{
+	unsigned long flags;
+	struct sched_dl_entity *dl_se =3D container_of(timer,
+						     struct sched_dl_entity,
+						     dl_timer);
+	struct task_struct *p =3D dl_task_of(dl_se);
+	struct rq *rq =3D task_rq_lock(p, &flags);
+
+	/*
+	 * We need to take care of a possible races here. In fact, the
+	 * task might have changed its scheduling policy to something
+	 * different from SCHED_DEADLINE (through sched_setscheduler()).
+	 */
+	if (!dl_task(p))
+		goto unlock;
+
+	dl_se->flags &=3D ~DL_THROTTLED;
+	if (p->se.on_rq) {
+		replenish_dl_entity(dl_se);
+		enqueue_dl_entity(dl_se);
+		check_dl_preempt_curr(p, rq);
+	}
+unlock:
+	task_rq_unlock(rq, &flags);
+
+	return HRTIMER_NORESTART;
+}
+
+static void init_dl_timer(struct sched_dl_entity *dl_se)
+{
+	struct hrtimer *timer =3D &dl_se->dl_timer;
+
+	if (hrtimer_active(timer)) {
+		hrtimer_try_to_cancel(timer);
+		return;
+	}
+
+	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	timer->function =3D dl_timer;
+}
+
+static
+int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
+{
+	int dmiss =3D dl_time_before(dl_se->deadline, rq->clock);
+	int rorun =3D dl_se->runtime <=3D 0;
+
+	if (!rorun && !dmiss)
+		return 0;
+
+	/*
+	 * If we are beyond our current deadline and we are still
+	 * executing, then we have already used some of the runtime of
+	 * the next instance. Thus, if we do not account that, we are
+	 * stealing bandwidth from the system at each deadline miss!
+	 */
+	if (dmiss)
+		dl_se->runtime -=3D rq->clock - dl_se->deadline;
+
+	dequeue_dl_entity(dl_se);
+	if (!start_dl_timer(dl_se, dl_se->deadline)) {
+		if (!rorun)
+			dl_se->runtime =3D 0;
+		replenish_dl_entity(dl_se);
+		enqueue_dl_entity(dl_se);
+	} else
+		dl_se->flags |=3D DL_THROTTLED;
+
+	return 1;
+}
+
+static void update_curr_dl(struct rq *rq)
+{
+	struct task_struct *curr =3D rq->curr;
+	struct sched_dl_entity *dl_se =3D &curr->dl;
+	u64 delta_exec;
+
+	if (!task_has_dl_policy(curr) || !on_dl_rq(dl_se))
+		return;
+
+	delta_exec =3D rq->clock - curr->se.exec_start;
+	if (unlikely((s64)delta_exec < 0))
+		delta_exec =3D 0;
+
+	schedstat_set(curr->se.exec_max, max(curr->se.exec_max, delta_exec));
+
+	curr->se.sum_exec_runtime +=3D delta_exec;
+	account_group_exec_runtime(curr, delta_exec);
+
+	curr->se.exec_start =3D rq->clock;
+	cpuacct_charge(curr, delta_exec);
+
+	dl_se->runtime -=3D delta_exec;
+	if (dl_runtime_exceeded(rq, dl_se))
+		resched_task(curr);
+}
+
+static void enqueue_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
+	struct rb_node **link =3D &dl_rq->rb_root.rb_node;
+	struct rb_node *parent =3D NULL;
+	struct sched_dl_entity *entry;
+	int leftmost =3D 1;
+
+	BUG_ON(!RB_EMPTY_NODE(&dl_se->rb_node));
+
+	while (*link) {
+		parent =3D *link;
+		entry =3D rb_entry(parent, struct sched_dl_entity, rb_node);
+		if (dl_time_before(dl_se->deadline, entry->deadline))
+			link =3D &parent->rb_left;
+		else {
+			link =3D &parent->rb_right;
+			leftmost =3D 0;
+		}
+	}
+
+	if (leftmost)
+		dl_rq->rb_leftmost =3D &dl_se->rb_node;
+
+	rb_link_node(&dl_se->rb_node, parent, link);
+	rb_insert_color(&dl_se->rb_node, &dl_rq->rb_root);
+
+	dl_rq->dl_nr_running++;
+}
+
+static void dequeue_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
+
+	if (RB_EMPTY_NODE(&dl_se->rb_node))
+		return;
+
+	if (dl_rq->rb_leftmost =3D=3D &dl_se->rb_node) {
+		struct rb_node *next_node;
+
+		next_node =3D rb_next(&dl_se->rb_node);
+		dl_rq->rb_leftmost =3D next_node;
+	}
+
+	rb_erase(&dl_se->rb_node, &dl_rq->rb_root);
+	RB_CLEAR_NODE(&dl_se->rb_node);
+
+	dl_rq->dl_nr_running--;
+}
+
+static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
+				   int sync)
+{
+	if (dl_task(p) &&
+	    dl_time_before(p->dl.deadline, rq->curr->dl.deadline))
+		resched_task(rq->curr);
+}
+
+/*
+ * There are a few cases where we must check if a -deadline task p should
+ * preempt the current task of a given rq (e.g., inside the bandwidth
+ * enforcement timer callback).
+ */
+static void check_dl_preempt_curr(struct task_struct *p, struct rq *rq)
+{
+	if (!dl_task(rq->curr) ||
+	    dl_time_before(p->dl.deadline, rq->curr->dl.deadline))
+		resched_task(rq->curr);
+}
+
+static void
+enqueue_task_dl(struct rq *rq, struct task_struct *p, int wakeup)
+{
+	struct sched_dl_entity *dl_se =3D &p->dl;
+
+	BUG_ON(on_dl_rq(dl_se));
+
+	/*
+	 * If the task is DL_THROTTLED, we do nothing. In fact,
+	 * if it exhausted its budget it needs a replenishment and,
+	 * since it now is on its rq, the bandwidth timer callback
+	 * (which clearly has not run yet) will take care of this.
+	 */
+	if (dl_se->flags & DL_THROTTLED)
+		return;
+
+	update_dl_entity(dl_se);
+	enqueue_dl_entity(dl_se);
+}
+
+static void
+dequeue_task_dl(struct rq *rq, struct task_struct *p, int sleep)
+{
+	struct sched_dl_entity *dl_se =3D &p->dl;
+
+	if (!on_dl_rq(dl_se))
+		return;
+
+	update_curr_dl(rq);
+	dequeue_dl_entity(dl_se);
+}
+
+static void yield_task_dl(struct rq *rq)
+{
+}
+
+#ifdef CONFIG_SCHED_HRTICK
+static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
+{
+	struct sched_dl_entity *dl_se =3D &p->dl;
+	s64 delta;
+
+	delta =3D dl_se->dl_runtime - dl_se->runtime;
+
+	if (delta > 10000)
+		hrtick_start(rq, delta);
+}
+#else
+static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
+{
+}
+#endif
+
+static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
+						   struct dl_rq *dl_rq)
+{
+	struct rb_node *left =3D dl_rq->rb_leftmost;
+
+	if (!left)
+		return NULL;
+
+	return rb_entry(left, struct sched_dl_entity, rb_node);
+}
+
+struct task_struct *pick_next_task_dl(struct rq *rq)
+{
+	struct sched_dl_entity *dl_se;
+	struct task_struct *p;
+	struct dl_rq *dl_rq;
+
+	dl_rq =3D &rq->dl;
+
+	if (likely(!dl_rq->dl_nr_running))
+		return NULL;
+
+	dl_se =3D pick_next_dl_entity(rq, dl_rq);
+	BUG_ON(!dl_se);
+
+	p =3D dl_task_of(dl_se);
+	p->se.exec_start =3D rq->clock;
+#ifdef CONFIG_SCHED_HRTICK
+	if (hrtick_enabled(rq))
+		start_hrtick_dl(rq, p);
+#endif
+	return p;
+}
+
+static void put_prev_task_dl(struct rq *rq, struct task_struct *p)
+{
+	update_curr_dl(rq);
+	p->se.exec_start =3D 0;
+}
+
+static void task_tick_dl(struct rq *rq, struct task_struct *p, int queued)
+{
+	update_curr_dl(rq);
+
+#ifdef CONFIG_SCHED_HRTICK
+	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0)
+		start_hrtick_dl(rq, p);
+#endif
+}
+
+static void task_fork_dl(struct task_struct *p)
+{
+	/*
+	 * The child of a -deadline task will be SCHED_DEADLINE, but
+	 * with zero runtime and in DL_THROTTLED and !DL_NEW internal state.
+	 * This means the parent (or some other task) must call
+	 * sched_setscheduler_ex() on it, or it won't ever start.
+	 */
+	p->dl.flags |=3D DL_THROTTLED;
+	p->dl.flags &=3D ~DL_NEW;
+}
+
+static void task_dead_dl(struct task_struct *p)
+{
+	/*
+	 * We are not holding any lock here, so it is safe to
+	 * wait for the bandwidth timer to be removed.
+	 */
+	hrtimer_cancel(&p->dl.dl_timer);
+}
+
+static void set_curr_task_dl(struct rq *rq)
+{
+	struct task_struct *p =3D rq->curr;
+
+	p->se.exec_start =3D rq->clock;
+}
+
+static void switched_from_dl(struct rq *rq, struct task_struct *p,
+			     int running)
+{
+	if (hrtimer_active(&p->dl.dl_timer))
+		hrtimer_try_to_cancel(&p->dl.dl_timer);
+}
+
+static void switched_to_dl(struct rq *rq, struct task_struct *p,
+			   int running)
+{
+	init_dl_timer(&p->dl);
+	check_dl_preempt_curr(p, rq);
+}
+
+static void prio_changed_dl(struct rq *rq, struct task_struct *p,
+			    int oldprio, int running)
+{
+	switched_to_dl(rq, p, running);
+}
+
+#ifdef CONFIG_SMP
+static int select_task_rq_dl(struct task_struct *p,
+				   int sd_flag, int flags)
+{
+	return task_cpu(p);
+}
+
+static unsigned long
+load_balance_dl(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		 unsigned long max_load_move,
+		 struct sched_domain *sd, enum cpu_idle_type idle,
+		 int *all_pinned, int *this_best_prio)
+{
+	/* Don't dare touching SCHED_DEADLINE tasks! */
+	return 0;
+}
+
+static int
+move_one_task_dl(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		  struct sched_domain *sd, enum cpu_idle_type idle)
+{
+	return 0;
+}
+
+static void set_cpus_allowed_dl(struct task_struct *p,
+				 const struct cpumask *new_mask)
+{
+	int weight =3D cpumask_weight(new_mask);
+
+	BUG_ON(!dl_task(p));
+
+	cpumask_copy(&p->cpus_allowed, new_mask);
+	p->dl.nr_cpus_allowed =3D weight;
+}
+#endif
+
+static const struct sched_class dl_sched_class =3D {
+	.next			=3D &rt_sched_class,
+	.enqueue_task		=3D enqueue_task_dl,
+	.dequeue_task		=3D dequeue_task_dl,
+	.yield_task		=3D yield_task_dl,
+
+	.check_preempt_curr	=3D check_preempt_curr_dl,
+
+	.pick_next_task		=3D pick_next_task_dl,
+	.put_prev_task		=3D put_prev_task_dl,
+
+#ifdef CONFIG_SMP
+	.select_task_rq		=3D select_task_rq_dl,
+
+	.load_balance           =3D load_balance_dl,
+	.move_one_task		=3D move_one_task_dl,
+	.set_cpus_allowed       =3D set_cpus_allowed_dl,
+#endif
+
+	.set_curr_task		=3D set_curr_task_dl,
+	.task_tick		=3D task_tick_dl,
+	.task_fork              =3D task_fork_dl,
+	.task_dead		=3D task_dead_dl,
+
+	.prio_changed           =3D prio_changed_dl,
+	.switched_from		=3D switched_from_dl,
+	.switched_to		=3D switched_to_dl,
+};
+
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8fe7ee8..7c31185 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1707,7 +1707,7 @@ static void check_preempt_wakeup(struct rq *rq, struc=
t task_struct *p, int wake_
 	int sync =3D wake_flags & WF_SYNC;
 	int scale =3D cfs_rq->nr_running >=3D sched_nr_latency;
=20
-	if (unlikely(rt_prio(p->prio)))
+	if (unlikely(dl_task(p) || rt_prio(p->prio)))
 		goto preempt;
=20
 	if (unlikely(p->sched_class !=3D &fair_sched_class))
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index f48328a..84eee27 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1004,7 +1004,7 @@ static void check_preempt_equal_prio(struct rq *rq, s=
truct task_struct *p)
  */
 static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, in=
t flags)
 {
-	if (p->prio < rq->curr->prio) {
+	if (dl_task(p) || p->prio < rq->curr->prio) {
 		resched_task(rq->curr);
 		return;
 	}
--=20
1.7.0

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-3SmJY3FcHHoXs0/Rfd1j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuKwT4ACgkQk4XaBE3IOsRIAwCgmqVeX1S0LWQzKxPp+qQW0hrB
e5kAn0qnOqJoqS1CxZFg00vHYfDZHfSj
=agzS
-----END PGP SIGNATURE-----

--=-3SmJY3FcHHoXs0/Rfd1j--


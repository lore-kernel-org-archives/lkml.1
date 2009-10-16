Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbZJPPlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbZJPPlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760431AbZJPPk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:40:59 -0400
Received: from ms01.sssup.it ([193.205.80.99]:49611 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754697AbZJPPk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:40:57 -0400
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: core of the scheduling class
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1255707324.6228.448.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ngGHltNG2C03FgjOYeS1"
Date: Fri, 16 Oct 2009 17:40:14 +0200
Message-Id: <1255707614.6228.453.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ngGHltNG2C03FgjOYeS1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This commit introduces a new scheduling policy (SCHED_DEADLINE), implemente=
d
in a new scheduling class (sched_deadline.c).

As of now, it implements the popular Earliest Deadline First (EDF) real-tim=
e
scheduling algorithm.
It basically means each (instance of each) task has a deadline, indicating =
the
time instant by which its computation has to be completed. The scheduler
always picks the task with the earliest deadline as the next to be executed=
.

Some more logic is added in order to avoid tasks interfering between each
others, i.e., a deadline miss of task A should not affect the capability of
task B to meet its own deadline.

Open issues:
 - this implementation is ``fully partitioned'', which means each task has =
to
   be bound to one processor at any given time. Turning it into ``global
   scheduling'' (i.e., migrations are allowed) is work in progress;
 - proper dealing with critical sections/rt-mutexes is also missing, and
   is also work in progress.

Signed-off-by: Raistlin <raistlin@linux.it>
---
 include/linux/sched.h   |   36 ++++
 kernel/hrtimer.c        |    2 +-
 kernel/sched.c          |   44 ++++-
 kernel/sched_deadline.c |  513 +++++++++++++++++++++++++++++++++++++++++++=
++++
 kernel/sched_fair.c     |    2 +-
 kernel/sched_rt.c       |    2 +-
 6 files changed, 587 insertions(+), 12 deletions(-)
 create mode 100644 kernel/sched_deadline.c

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ac9837c..20e1a6a 100644
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
@@ -159,6 +160,7 @@ extern unsigned long get_parent_ip(unsigned long addr);
=20
 struct seq_file;
 struct cfs_rq;
+struct dl_rq;
 struct task_group;
 #ifdef CONFIG_SCHED_DEBUG
 extern void proc_sched_show_task(struct task_struct *p, struct seq_file *m=
);
@@ -1218,6 +1220,27 @@ struct sched_rt_entity {
 #endif
 };
=20
+#define DL_NEW			0x00000001
+#define DL_THROTTLED		0x00000002
+#define DL_BOOSTED		0x00000004
+
+struct sched_dl_entity {
+	struct rb_node	rb_node;
+	/* actual scheduling parameters */
+	s64		runtime;
+	u64		deadline;
+	unsigned int	flags;
+
+	/* original parameters taken from sched_param_ex */
+	u64		sched_runtime;
+	u64		sched_deadline;
+	u64		sched_period;
+	u64		bw;
+
+	int		nr_cpus_allowed;
+	struct hrtimer	dl_timer;
+};
+
 struct rcu_node;
=20
 struct task_struct {
@@ -1240,6 +1263,7 @@ struct task_struct {
 	const struct sched_class *sched_class;
 	struct sched_entity se;
 	struct sched_rt_entity rt;
+	struct sched_dl_entity dl;
=20
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
@@ -1583,6 +1607,18 @@ static inline int rt_task(struct task_struct *p)
 	return rt_prio(p->prio);
 }
=20
+static inline int deadline_policy(int policy)
+{
+	if (unlikely(policy =3D=3D SCHED_DEADLINE))
+		return 1;
+	return 0;
+}
+
+static inline int deadline_task(struct task_struct *p)
+{
+	return deadline_policy(p->policy);
+}
+
 static inline struct pid *task_pid(struct task_struct *task)
 {
 	return task->pids[PIDTYPE_PID].pid;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 3e1c36e..bf6a3b1 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1537,7 +1537,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct =
timespec __user *rmtp,
 	unsigned long slack;
=20
 	slack =3D current->timer_slack_ns;
-	if (rt_task(current))
+	if (deadline_task(current) || rt_task(current))
 		slack =3D 0;
=20
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
diff --git a/kernel/sched.c b/kernel/sched.c
index e886895..adf1414 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -131,6 +131,11 @@ static inline int task_has_rt_policy(struct task_struc=
t *p)
 	return rt_policy(p->policy);
 }
=20
+static inline int task_has_deadline_policy(struct task_struct *p)
+{
+	return deadline_policy(p->policy);
+}
+
 /*
  * This is the priority-queue data structure of the RT scheduling class:
  */
@@ -481,6 +486,14 @@ struct rt_rq {
 #endif
 };
=20
+struct dl_rq {
+	unsigned long dl_nr_running;
+
+	/* runqueue is an rbtree, ordered by deadline */
+	struct rb_root rb_root;
+	struct rb_node *rb_leftmost;
+};
+
 #ifdef CONFIG_SMP
=20
 /*
@@ -545,6 +558,7 @@ struct rq {
=20
 	struct cfs_rq cfs;
 	struct rt_rq rt;
+	struct dl_rq dl;
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
@@ -1818,11 +1832,12 @@ static void calc_load_account_active(struct rq *thi=
s_rq);
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
+#include "sched_deadline.c"
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
 #endif
=20
-#define sched_class_highest (&rt_sched_class)
+#define sched_class_highest (&deadline_sched_class)
 #define for_each_class(class) \
    for (class =3D sched_class_highest; class; class =3D class->next)
=20
@@ -1838,7 +1853,7 @@ static void dec_nr_running(struct rq *rq)
=20
 static void set_load_weight(struct task_struct *p)
 {
-	if (task_has_rt_policy(p)) {
+	if (task_has_deadline_policy(p) || task_has_rt_policy(p)) {
 		p->se.load.weight =3D prio_to_weight[0] * 2;
 		p->se.load.inv_weight =3D prio_to_wmult[0] >> 1;
 		return;
@@ -2523,7 +2538,8 @@ void sched_fork(struct task_struct *p, int clone_flag=
s)
 	 * Revert to default priority/policy on fork if requested.
 	 */
 	if (unlikely(p->sched_reset_on_fork)) {
-		if (p->policy =3D=3D SCHED_FIFO || p->policy =3D=3D SCHED_RR) {
+		if (deadline_policy(p->policy) ||
+		    p->policy =3D=3D SCHED_FIFO || p->policy =3D=3D SCHED_RR) {
 			p->policy =3D SCHED_NORMAL;
 			p->normal_prio =3D p->static_prio;
 		}
@@ -5966,10 +5982,14 @@ void rt_mutex_setprio(struct task_struct *p, int pr=
io)
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
=20
-	if (rt_prio(prio))
-		p->sched_class =3D &rt_sched_class;
-	else
-		p->sched_class =3D &fair_sched_class;
+	if (deadline_task(p))
+		p->sched_class =3D &deadline_sched_class;
+	else {
+		if (rt_prio(prio))
+			p->sched_class =3D &rt_sched_class;
+		else
+			p->sched_class =3D &fair_sched_class;
+	}
=20
 	p->prio =3D prio;
=20
@@ -6003,9 +6023,9 @@ void set_user_nice(struct task_struct *p, long nice)
 	 * The RT priorities are set via sched_setscheduler(), but we still
 	 * allow the 'normal' nice value to be set - but as expected
 	 * it wont have any effect on scheduling until the task is
-	 * SCHED_FIFO/SCHED_RR:
+	 * SCHED_DEADLINE, SCHED_FIFO or SCHED_RR:
 	 */
-	if (task_has_rt_policy(p)) {
+	if (unlikely(task_has_deadline_policy(p) || task_has_rt_policy(p))) {
 		p->static_prio =3D NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
@@ -9259,6 +9279,11 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct r=
q *rq)
 #endif
 }
=20
+static void init_deadline_rq(struct dl_rq *dl_rq, struct rq *rq)
+{
+	dl_rq->rb_root =3D RB_ROOT;
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq=
,
 				struct sched_entity *se, int cpu, int add,
@@ -9417,6 +9442,7 @@ void __init sched_init(void)
 		rq->calc_load_update =3D jiffies + LOAD_FREQ;
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
+		init_deadline_rq(&rq->dl, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.shares =3D init_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
diff --git a/kernel/sched_deadline.c b/kernel/sched_deadline.c
new file mode 100644
index 0000000..5430c48
--- /dev/null
+++ b/kernel/sched_deadline.c
@@ -0,0 +1,513 @@
+/*
+ * Deadline Scheduling Class (SCHED_DEADLINE policy)
+ *
+ * This scheduling class implements the Earliest Deadline First (EDF)
+ * scheduling algorithm, suited for hard and soft real-time tasks.
+ *
+ * The strategy used to confine each task inside its bandwidth reservation
+ * is the Constant Bandwidth Server (CBS) scheduling, a slight variation o=
n
+ * EDF that makes this possible.
+ *
+ * Correct behavior, i.e., no task missing any deadline, is only guarantee=
d
+ * if the task's parameters are:
+ *  - correctly assigned, so that the system is not overloaded,
+ *  - respected during actual execution.
+ * However, thanks to bandwidth isolation, overruns and deadline misses
+ * remains local, and does not affect any other task in the system.
+ *
+ * Copyright (C) 2009 Dario Faggioli, Michael Trimarchi
+ */
+
+static const struct sched_class deadline_sched_class;
+
+static inline struct task_struct *deadline_task_of(struct sched_dl_entity =
*dl_se)
+{
+	return container_of(dl_se, struct task_struct, dl);
+}
+
+static inline struct rq *rq_of_deadline_rq(struct dl_rq *dl_rq)
+{
+	return container_of(dl_rq, struct rq, dl);
+}
+
+static inline struct dl_rq *deadline_rq_of_se(struct sched_dl_entity *dl_s=
e)
+{
+	struct task_struct *p =3D deadline_task_of(dl_se);
+	struct rq *rq =3D task_rq(p);
+
+	return &rq->dl;
+}
+
+/*
+ * FIXME:
+ *  This is broken for now, correct implementation of a BWI/PEP
+ *  solution is needed here!
+ */
+static inline int deadline_se_boosted(struct sched_dl_entity *dl_se)
+{
+	struct task_struct *p =3D deadline_task_of(dl_se);
+
+	return p->prio !=3D p->normal_prio;
+}
+
+static inline int on_deadline_rq(struct sched_dl_entity *dl_se)
+{
+	return !RB_EMPTY_NODE(&dl_se->rb_node);
+}
+
+#define for_each_leaf_deadline_rq(dl_rq, rq) \
+	for (dl_rq =3D &rq->dl; dl_rq; dl_rq =3D NULL)
+
+static inline int deadline_time_before(u64 a, u64 b)
+{
+	return (s64)(a - b) < 0;
+}
+
+static inline u64 deadline_max_deadline(u64 a, u64 b)
+{
+	s64 delta =3D (s64)(b - a);
+	if (delta > 0)
+		a =3D b;
+
+	return a;
+}
+
+static void enqueue_deadline_entity(struct sched_dl_entity *dl_se);
+static void dequeue_deadline_entity(struct sched_dl_entity *dl_se);
+static void check_deadline_preempt_curr(struct task_struct *p, struct rq *=
rq);
+
+/*
+ * setup a new SCHED_DEADLINE task instance.
+ */
+static inline void setup_new_deadline_entity(struct sched_dl_entity *dl_se=
)
+{
+	struct dl_rq *dl_rq =3D deadline_rq_of_se(dl_se);
+	struct rq *rq =3D rq_of_deadline_rq(dl_rq);
+
+	dl_se->flags &=3D ~DL_NEW;
+	dl_se->deadline =3D max(dl_se->deadline, rq->clock) +
+			      dl_se->sched_deadline;
+	dl_se->runtime =3D dl_se->sched_runtime;
+}
+
+/*
+ * gives a SCHED_DEADLINE task that run out of runtime the possibility
+ * of restarting executing, with a refilled runtime and a new
+ * (postponed) deadline.
+ */
+static void replenish_deadline_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq =3D deadline_rq_of_se(dl_se);
+	struct rq *rq =3D rq_of_deadline_rq(dl_rq);
+
+	/*
+	 * Keep moving the deadline and replenishing runtime by the
+	 * proper amount until the runtime becomes positive.
+	 */
+	while (dl_se->runtime < 0) {
+		dl_se->deadline +=3D dl_se->sched_deadline;
+		dl_se->runtime +=3D dl_se->sched_runtime;
+	}
+
+	WARN_ON(dl_se->runtime > dl_se->sched_runtime);
+	WARN_ON(deadline_time_before(dl_se->deadline, rq->clock));
+}
+
+static void update_deadline_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq =3D deadline_rq_of_se(dl_se);
+	struct rq *rq =3D rq_of_deadline_rq(dl_rq);
+	u64 left, right;
+
+	if (dl_se->flags & DL_NEW) {
+		setup_new_deadline_entity(dl_se);
+		return;
+	}
+
+	/*
+	 * Update the deadline of the task only if:
+	 * - the budget has been completely exhausted;
+	 * - using the ramaining budget, with the current deadline, would
+	 *   make the task exceed its bandwidth;
+	 * - the deadline itself is in the past.
+	 *
+	 * For the second condition to hold, we check if:
+	 *  runtime / (deadline - rq->clock) >=3D sched_runtime / sched_deadline
+	 *
+	 * Which basically says if, in the time left before the current
+	 * deadline, the tasks overcome its expected runtime by using the
+	 * residual budget (left and right are the two sides of the equation,
+	 * after a bit of shuffling to use multiplications instead of
+	 * divisions).
+	 */
+	if (deadline_time_before(dl_se->deadline, rq->clock))
+		goto update;
+
+	left =3D dl_se->sched_deadline * dl_se->runtime;
+	right =3D (dl_se->deadline - rq->clock) * dl_se->sched_runtime;
+
+	if (deadline_time_before(right, left)) {
+update:
+		dl_se->deadline =3D rq->clock + dl_se->sched_deadline;
+		dl_se->runtime =3D dl_se->sched_runtime;
+	}
+}
+
+/*
+ * the task just depleted its runtime, so we try to post the
+ * replenishment timer to fire at the next absolute deadline.
+ *
+ * In fact, the task was allowed to execute for at most sched_runtime
+ * over each period of sched_deadline length.
+ */
+static int start_deadline_timer(struct sched_dl_entity *dl_se, u64 wakeup)
+{
+	struct dl_rq *dl_rq =3D deadline_rq_of_se(dl_se);
+	struct rq *rq =3D rq_of_deadline_rq(dl_rq);
+	ktime_t now, act;
+	s64 delta;
+
+	act =3D ns_to_ktime(wakeup);
+	now =3D hrtimer_cb_get_time(&dl_se->dl_timer);
+	delta =3D ktime_to_ns(now) - rq->clock;
+	act =3D ktime_add_ns(act, delta);
+
+	hrtimer_set_expires(&dl_se->dl_timer, act);
+	hrtimer_start_expires(&dl_se->dl_timer, HRTIMER_MODE_ABS);
+
+	return hrtimer_active(&dl_se->dl_timer);
+}
+
+static enum hrtimer_restart deadline_timer(struct hrtimer *timer)
+{
+	struct sched_dl_entity *dl_se =3D container_of(timer,
+						     struct sched_dl_entity,
+						     dl_timer);
+	struct task_struct *p =3D deadline_task_of(dl_se);
+	struct dl_rq *dl_rq =3D deadline_rq_of_se(dl_se);
+	struct rq *rq =3D rq_of_deadline_rq(dl_rq);
+
+	spin_lock(&rq->lock);
+
+	/*
+	 * the task might have changed scheduling policy
+	 * through setscheduler_ex, in what case we just do nothing.
+	 */
+	if (!deadline_task(p))
+		goto unlock;
+
+	/*
+	 * the task can't be enqueued any the SCHED_DEADLINE runqueue,
+	 * and needs to be enqueued back there --with its new deadline--
+	 * only if it is active.
+	 */
+	dl_se->flags &=3D ~DL_THROTTLED;
+	if (p->se.on_rq) {
+		replenish_deadline_entity(dl_se);
+		enqueue_deadline_entity(dl_se);
+		check_deadline_preempt_curr(p, rq);
+	}
+unlock:
+	spin_unlock(&rq->lock);
+
+	return HRTIMER_NORESTART;
+}
+
+static
+int deadline_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se=
)
+{
+	if (dl_se->runtime >=3D 0 || deadline_se_boosted(dl_se))
+		return 0;
+
+	dequeue_deadline_entity(dl_se);
+	if (!start_deadline_timer(dl_se, dl_se->deadline)) {
+		replenish_deadline_entity(dl_se);
+		enqueue_deadline_entity(dl_se);
+	} else
+		dl_se->flags |=3D DL_THROTTLED;
+
+	return 1;
+}
+
+static void update_curr_deadline(struct rq *rq)
+{
+	struct task_struct *curr =3D rq->curr;
+	struct sched_dl_entity *dl_se =3D &curr->dl;
+	u64 delta_exec;
+
+	if (!deadline_task(curr) || !on_deadline_rq(dl_se))
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
+	if (deadline_runtime_exceeded(rq, dl_se))
+		resched_task(curr);
+}
+
+static void enqueue_deadline_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq =3D deadline_rq_of_se(dl_se);
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
+		if (!deadline_time_before(entry->deadline, dl_se->deadline))
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
+static void dequeue_deadline_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq =3D deadline_rq_of_se(dl_se);
+
+	if (RB_EMPTY_NODE(&dl_se->rb_node))
+		return;
+
+	if (dl_rq->rb_leftmost =3D=3D &dl_se->rb_node) {
+		struct rb_node *next_node;
+		struct sched_dl_entity *next;
+
+		next_node =3D rb_next(&dl_se->rb_node);
+		dl_rq->rb_leftmost =3D next_node;
+
+		if (next_node)
+			next =3D rb_entry(next_node, struct sched_dl_entity,
+					rb_node);
+	}
+
+	rb_erase(&dl_se->rb_node, &dl_rq->rb_root);
+	RB_CLEAR_NODE(&dl_se->rb_node);
+
+	dl_rq->dl_nr_running--;
+}
+
+static void check_preempt_curr_deadline(struct rq *rq, struct task_struct =
*p,
+				   int sync)
+{
+	if (deadline_task(p) &&
+	    deadline_time_before(p->dl.deadline, rq->curr->dl.deadline))
+		resched_task(rq->curr);
+}
+
+/*
+ * there are a few cases where is important to check if a SCHED_DEADLINE
+ * task p should preempt the current task of a runqueue (e.g., inside the
+ * replenishment timer code).
+ */
+static void check_deadline_preempt_curr(struct task_struct *p, struct rq *=
rq)
+{
+	if (!deadline_task(rq->curr) ||
+	    deadline_time_before(p->dl.deadline, rq->curr->dl.deadline))
+		resched_task(rq->curr);
+}
+
+static void
+enqueue_task_deadline(struct rq *rq, struct task_struct *p, int wakeup)
+{
+	struct sched_dl_entity *dl_se =3D &p->dl;
+
+	BUG_ON(on_deadline_rq(dl_se));
+
+	/*
+	 * Only enqueue entities with some remaining runtime.
+	 */
+	if (dl_se->flags & DL_THROTTLED)
+		return;
+
+	update_deadline_entity(dl_se);
+	enqueue_deadline_entity(dl_se);
+}
+
+static void
+dequeue_task_deadline(struct rq *rq, struct task_struct *p, int sleep)
+{
+	struct sched_dl_entity *dl_se =3D &p->dl;
+
+	if (!on_deadline_rq(dl_se))
+		return;
+
+	update_curr_deadline(rq);
+	dequeue_deadline_entity(dl_se);
+}
+
+static void yield_task_deadline(struct rq *rq)
+{
+}
+
+#ifdef CONFIG_SCHED_HRTICK
+static void start_hrtick_deadline(struct rq *rq, struct task_struct *p)
+{
+	struct sched_dl_entity *dl_se =3D &p->dl;
+	s64 delta;
+
+	delta =3D dl_se->sched_runtime - dl_se->runtime;
+
+	if (delta > 10000)
+		hrtick_start(rq, delta);
+}
+#else
+static void start_hrtick_deadline(struct rq *rq, struct task_struct *p)
+{
+}
+#endif
+
+static struct sched_dl_entity *pick_next_deadline_entity(struct rq *rq,
+							 struct dl_rq *dl_rq)
+{
+	struct rb_node *left =3D dl_rq->rb_leftmost;
+
+	if (!left)
+		return NULL;
+
+	return rb_entry(left, struct sched_dl_entity, rb_node);
+}
+
+struct task_struct *pick_next_task_deadline(struct rq *rq)
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
+	dl_se =3D pick_next_deadline_entity(rq, dl_rq);
+	BUG_ON(!dl_se);
+
+	p =3D deadline_task_of(dl_se);
+	p->se.exec_start =3D rq->clock;
+#ifdef CONFIG_SCHED_HRTICK
+	if (hrtick_enabled(rq))
+		start_hrtick_deadline(rq, p);
+#endif
+	return p;
+}
+
+static void put_prev_task_deadline(struct rq *rq, struct task_struct *p)
+{
+	update_curr_deadline(rq);
+	p->se.exec_start =3D 0;
+}
+
+static void task_tick_deadline(struct rq *rq, struct task_struct *p, int q=
ueued)
+{
+	update_curr_deadline(rq);
+
+#ifdef CONFIG_SCHED_HRTICK
+	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0)
+		start_hrtick_deadline(rq, p);
+#endif
+}
+
+static void set_curr_task_deadline(struct rq *rq)
+{
+	struct task_struct *p =3D rq->curr;
+
+	p->se.exec_start =3D rq->clock;
+}
+
+static void prio_changed_deadline(struct rq *rq, struct task_struct *p,
+			     int oldprio, int running)
+{
+	check_deadline_preempt_curr(p, rq);
+}
+
+static void switched_to_deadline(struct rq *rq, struct task_struct *p,
+			    int running)
+{
+	check_deadline_preempt_curr(p, rq);
+}
+
+#ifdef CONFIG_SMP
+static int select_task_rq_deadline(struct task_struct *p,
+				   int sd_flag, int flags)
+{
+	return task_cpu(p);
+}
+
+static unsigned long
+load_balance_deadline(struct rq *this_rq, int this_cpu, struct rq *busiest=
,
+		 unsigned long max_load_move,
+		 struct sched_domain *sd, enum cpu_idle_type idle,
+		 int *all_pinned, int *this_best_prio)
+{
+	/* for now, don't touch SCHED_DEADLINE tasks */
+	return 0;
+}
+
+static int
+move_one_task_deadline(struct rq *this_rq, int this_cpu, struct rq *busies=
t,
+		  struct sched_domain *sd, enum cpu_idle_type idle)
+{
+	return 0;
+}
+
+static void set_cpus_allowed_deadline(struct task_struct *p,
+				 const struct cpumask *new_mask)
+{
+	int weight =3D cpumask_weight(new_mask);
+
+	BUG_ON(!deadline_task(p));
+
+	cpumask_copy(&p->cpus_allowed, new_mask);
+	p->dl.nr_cpus_allowed =3D weight;
+}
+#endif
+
+static const struct sched_class deadline_sched_class =3D {
+	.next			=3D &rt_sched_class,
+	.enqueue_task		=3D enqueue_task_deadline,
+	.dequeue_task		=3D dequeue_task_deadline,
+	.yield_task		=3D yield_task_deadline,
+
+	.check_preempt_curr	=3D check_preempt_curr_deadline,
+
+	.pick_next_task		=3D pick_next_task_deadline,
+	.put_prev_task		=3D put_prev_task_deadline,
+
+#ifdef CONFIG_SMP
+	.select_task_rq		=3D select_task_rq_deadline,
+
+	.load_balance           =3D load_balance_deadline,
+	.move_one_task		=3D move_one_task_deadline,
+	.set_cpus_allowed       =3D set_cpus_allowed_deadline,
+#endif
+
+	.set_curr_task		=3D set_curr_task_deadline,
+	.task_tick		=3D task_tick_deadline,
+
+	.prio_changed           =3D prio_changed_deadline,
+	.switched_to		=3D switched_to_deadline,
+};
+
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4e777b4..8144cb4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1571,7 +1571,7 @@ static void check_preempt_wakeup(struct rq *rq, struc=
t task_struct *p, int wake_
=20
 	update_curr(cfs_rq);
=20
-	if (unlikely(rt_prio(p->prio))) {
+	if (unlikely(deadline_task(p) || rt_prio(p->prio))) {
 		resched_task(curr);
 		return;
 	}
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a4d790c..65cef57 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1004,7 +1004,7 @@ static void check_preempt_equal_prio(struct rq *rq, s=
truct task_struct *p)
  */
 static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, in=
t flags)
 {
-	if (p->prio < rq->curr->prio) {
+	if (deadline_task(p) || p->prio < rq->curr->prio) {
 		resched_task(rq->curr);
 		return;
 	}
--=20
1.6.0.4

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-ngGHltNG2C03FgjOYeS1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrYk94ACgkQk4XaBE3IOsSY5gCgmqVFqBj8kgQbvZ72CPYqBrUG
b50AoIVg38EDRwXQPvWVadimotTPd4YG
=POnY
-----END PGP SIGNATURE-----

--=-ngGHltNG2C03FgjOYeS1--


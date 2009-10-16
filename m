Return-Path: <linux-kernel-owner+w=401wt.eu-S932822AbZJPPr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822AbZJPPr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759252AbZJPPr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:47:29 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54642 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755686AbZJPPr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:47:27 -0400
Subject: [RFC 10/12][PATCH] SCHED_DEADLINE: group bandwidth management code
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qan1MnDs+qmA1/Jk9Cp7"
Date: Fri, 16 Oct 2009 17:46:44 +0200
Message-Id: <1255708004.6228.466.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qan1MnDs+qmA1/Jk9Cp7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

CPU Container Groups support for SCHED_DEADLINE is introduced by this commi=
t.

CGroups, if configured, have a SCHED_DEADLINE bandwidth, and it is enforced
that the sum of the bandwidths of entities (tasks and groups) belonging to
a group stays below its own bandwidth.

Signed-off-by: Raistlin <raistlin@linux.it>
---
 init/Kconfig            |   14 ++
 kernel/sched.c          |  419 +++++++++++++++++++++++++++++++++++++++++++=
++++
 kernel/sched_deadline.c |    4 +
 kernel/sched_debug.c    |    3 +-
 4 files changed, 439 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 09c5c64..17318ca 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -454,6 +454,20 @@ config RT_GROUP_SCHED
 	  realtime bandwidth for them.
 	  See Documentation/scheduler/sched-rt-group.txt for more information.
=20
+config DEADLINE_GROUP_SCHED
+	bool "Group scheduling for SCHED_DEADLINE"
+	depends on EXPERIMENTAL
+	depends on GROUP_SCHED
+	depends on CGROUPS
+	depends on !USER_SCHED
+	default n
+	help
+	  This feature lets you explicitly specify, in terms of runtime
+	  and period, the bandwidth of a task control group. This means
+	  tasks (and other groups) can be added to it only up to such
+	  ``bandwidth cap'', which might be useful for avoiding or
+	  controlling oversubscription.
+
 choice
 	depends on GROUP_SCHED
 	prompt "Basis for grouping tasks"
diff --git a/kernel/sched.c b/kernel/sched.c
index d8b6354..a8ebfa2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -232,6 +232,18 @@ static void destroy_rt_bandwidth(struct rt_bandwidth *=
rt_b)
 }
 #endif
=20
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+struct dl_bandwidth {
+	spinlock_t		lock;
+	/* runtime and period that determine the bandwidth of the group */
+	u64			runtime_max;
+	u64			period;
+	u64			bw;
+	/* accumulator of the total allocated bandwidth in a group */
+	u64			total_bw;
+};
+#endif
+
 /*
  * sched_domains_mutex serializes calls to arch_init_sched_domains,
  * detach_destroy_domains and partition_sched_domains.
@@ -271,6 +283,12 @@ struct task_group {
 	struct rt_bandwidth rt_bandwidth;
 #endif
=20
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+	struct dl_rq **dl_rq;
+
+	struct dl_bandwidth dl_bandwidth;
+#endif
+
 	struct rcu_head rcu;
 	struct list_head list;
=20
@@ -305,6 +323,10 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct cfs_rq, in=
it_tg_cfs_rq);
 static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rt_rq, init_rt_rq);
 #endif /* CONFIG_RT_GROUP_SCHED */
+
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct dl_rq, init_dl_rq);
+#endif /* CONFIG_DEADLINE_GROUP_SCHED */
 #else /* !CONFIG_USER_SCHED */
 #define root_task_group init_task_group
 #endif /* CONFIG_USER_SCHED */
@@ -492,6 +514,10 @@ struct dl_rq {
 	/* runqueue is an rbtree, ordered by deadline */
 	struct rb_root rb_root;
 	struct rb_node *rb_leftmost;
+
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+	struct rq *rq;
+#endif
 };
=20
 #ifdef CONFIG_SMP
@@ -895,8 +921,10 @@ static inline u64 global_deadline_runtime(void)
  * locking for the system wide deadline bandwidth management.
  */
 static DEFINE_MUTEX(deadline_constraints_mutex);
+#ifndef CONFIG_DEADLINE_GROUP_SCHED
 static DEFINE_SPINLOCK(__sysctl_sched_deadline_lock);
 static u64 __sysctl_sched_deadline_total_bw;
+#endif
=20
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
@@ -2634,6 +2662,72 @@ static unsigned long to_ratio(u64 period, u64 runtim=
e)
 	return div64_u64(runtime << 20, period);
 }
=20
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+static inline
+void __deadline_clear_task_bw(struct task_struct *p, u64 tsk_bw)
+{
+	struct task_group *tg =3D task_group(p);
+
+	tg->dl_bandwidth.total_bw -=3D tsk_bw;
+}
+
+static inline
+void __deadline_add_task_bw(struct task_struct *p, u64 tsk_bw)
+{
+	struct task_group *tg =3D task_group(p);
+
+	tg->dl_bandwidth.total_bw +=3D tsk_bw;
+}
+
+/*
+ * update the total allocated bandwidth for a group, if a new -deadline
+ * task arrives, leaves, or stays but modifies its bandwidth.
+ */
+static int __deadline_check_task_bw(struct task_struct *p, int policy,
+				    struct sched_param_ex *param_ex)
+{
+	struct task_group *tg =3D task_group(p);
+	u64 bw, tsk_bw =3D 0;
+	int ret =3D 0;
+
+	spin_lock(&tg->dl_bandwidth.lock);
+
+	bw =3D tg->dl_bandwidth.bw;
+	if (bw <=3D 0)
+		goto unlock;
+
+	if (deadline_policy(policy))
+		tsk_bw =3D to_ratio(timespec_to_ns(&param_ex->sched_deadline),
+				  timespec_to_ns(&param_ex->sched_runtime));
+
+	/*
+	 * Either if a task, enters, leave, or stays -deadline but changes
+	 * its parameters, we need to update accordingly the total allocated
+	 * bandwidth of the control group it is inside, provided the new state
+	 * is consistent!
+	 */
+	if (task_has_deadline_policy(p) && !deadline_policy(policy)) {
+		__deadline_clear_task_bw(p, p->dl.bw);
+		ret =3D 1;
+		goto unlock;
+	} else if (task_has_deadline_policy(p) && deadline_policy(policy) &&
+		   bw >=3D tg->dl_bandwidth.total_bw - p->dl.bw + tsk_bw) {
+		__deadline_clear_task_bw(p, p->dl.bw);
+		__deadline_add_task_bw(p, tsk_bw);
+		ret =3D 1;
+		goto unlock;
+	} else if (deadline_policy(policy) && !task_has_deadline_policy(p) &&
+		   bw >=3D tg->dl_bandwidth.total_bw + tsk_bw) {
+		__deadline_add_task_bw(p, tsk_bw);
+		ret =3D 1;
+		goto  unlock;
+	}
+unlock:
+	spin_unlock(&tg->dl_bandwidth.lock);
+
+	return ret;
+}
+#else /* !CONFIG_DEADLINE_GROUP_SCHED */
 static inline
 void __deadline_clear_task_bw(struct task_struct *p, u64 tsk_bw)
 {
@@ -2693,6 +2787,7 @@ unlock:
=20
 	return ret;
 }
+#endif /* CONFIG_DEADLINE_GROUP_SCHED */
=20
 /*
  * wake_up_new_task - wake up a newly created task for the first time.
@@ -9624,6 +9719,10 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct r=
q *rq)
 static void init_deadline_rq(struct dl_rq *dl_rq, struct rq *rq)
 {
 	dl_rq->rb_root =3D RB_ROOT;
+
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+	dl_rq->rq =3D rq;
+#endif
 }
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -9685,6 +9784,22 @@ static void init_tg_rt_entry(struct task_group *tg, =
struct rt_rq *rt_rq,
 }
 #endif
=20
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+void init_tg_deadline_entry(struct task_group *tg, struct dl_rq *dl_rq,
+			    struct sched_dl_entity *dl_se, int cpu, int add,
+			    struct sched_dl_entity *parent)
+{
+	struct rq *rq =3D cpu_rq(cpu);
+
+	tg->dl_rq[cpu] =3D &rq->dl;
+
+	spin_lock_init(&tg->dl_bandwidth.lock);
+	tg->dl_bandwidth.runtime_max =3D 0;
+	tg->dl_bandwidth.period =3D 0;
+	tg->dl_bandwidth.bw =3D tg->dl_bandwidth.total_bw =3D 0;
+}
+#endif
+
 void __init sched_init(void)
 {
 	int i, j;
@@ -9696,6 +9811,9 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 	alloc_size +=3D 2 * nr_cpu_ids * sizeof(void **);
 #endif
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+	alloc_size +=3D 2 * nr_cpu_ids * sizeof(void **);
+#endif
 #ifdef CONFIG_USER_SCHED
 	alloc_size *=3D 2;
 #endif
@@ -9739,6 +9857,10 @@ void __init sched_init(void)
 		ptr +=3D nr_cpu_ids * sizeof(void **);
 #endif /* CONFIG_USER_SCHED */
 #endif /* CONFIG_RT_GROUP_SCHED */
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+		init_task_group.dl_rq =3D (struct dl_rq **)ptr;
+		ptr +=3D nr_cpu_ids * sizeof(void **);
+#endif /* CONFIG_DEADLINE_GROUP_SCHED */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 		for_each_possible_cpu(i) {
 			per_cpu(load_balance_tmpmask, i) =3D (void *)ptr;
@@ -9845,6 +9967,19 @@ void __init sched_init(void)
 #endif
 #endif
=20
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+#ifdef CONFIG_CGROUP_SCHED
+		init_tg_deadline_entry(&init_task_group, &rq->dl,
+				       NULL, i, 1, NULL);
+#elif defined CONFIG_USER_SCHED
+		init_tg_deadline_entry(&root_task_group, &rq->dl,
+				       NULL, i, 0, NULL);
+		init_tg_deadline_entry(&init_task_group,
+				       &per_cpu(init_dl_rq, i),
+				       NULL, i, 1, NULL);
+#endif
+#endif /* CONFIG_DEADLINE_GROUP_SCHED */
+
 		for (j =3D 0; j < CPU_LOAD_IDX_MAX; j++)
 			rq->cpu_load[j] =3D 0;
 #ifdef CONFIG_SMP
@@ -10229,11 +10364,76 @@ static inline void unregister_rt_sched_group(stru=
ct task_group *tg, int cpu)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
=20
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+static void free_deadline_sched_group(struct task_group *tg)
+{
+	kfree(tg->dl_rq);
+}
+
+int alloc_deadline_sched_group(struct task_group *tg, struct task_group *p=
arent)
+{
+	struct rq *rq;
+	int i;
+
+	tg->dl_rq =3D kzalloc(sizeof(struct dl_rq *) * nr_cpu_ids, GFP_KERNEL);
+	if (!tg->dl_rq)
+		return 0;
+
+	for_each_possible_cpu(i) {
+		rq =3D cpu_rq(i);
+		init_tg_deadline_entry(tg, &rq->dl, NULL, i, 0, NULL);
+	}
+
+	return 1;
+}
+
+int sched_deadline_can_attach(struct cgroup *cgrp, struct task_struct *tsk=
)
+{
+	struct task_group *tg =3D container_of(cgroup_subsys_state(cgrp,
+					     cpu_cgroup_subsys_id),
+					     struct task_group, css);
+	u64 tg_bw =3D tg->dl_bandwidth.bw;
+	u64 tsk_bw =3D tsk->dl.bw;
+
+	if (!deadline_task(tsk))
+		return 1;
+
+	/*
+	 * Check for available free bandwidth for the task
+	 * in the group.
+	 */
+	if (tg_bw < tsk_bw + tg->dl_bandwidth.total_bw)
+		return 0;
+
+	return 1;
+}
+#else /* !CONFIG_DEADLINE_GROUP_SCHED */
+static inline void free_deadline_sched_group(struct task_group *tg)
+{
+}
+
+static inline
+int alloc_deadline_sched_group(struct task_group *tg, struct task_group *p=
arent)
+{
+	return 1;
+}
+#endif /* CONFIG_DEADLINE_GROUP_SCHED */
+static inline
+void register_deadline_sched_group(struct task_group *tg, int cpu)
+{
+}
+
+static inline
+void unregister_deadline_sched_group(struct task_group *tg, int cpu)
+{
+}
+
 #ifdef CONFIG_GROUP_SCHED
 static void free_sched_group(struct task_group *tg)
 {
 	free_fair_sched_group(tg);
 	free_rt_sched_group(tg);
+	free_deadline_sched_group(tg);
 	kfree(tg);
 }
=20
@@ -10254,10 +10454,14 @@ struct task_group *sched_create_group(struct task=
_group *parent)
 	if (!alloc_rt_sched_group(tg, parent))
 		goto err;
=20
+	if (!alloc_deadline_sched_group(tg, parent))
+		goto err;
+
 	spin_lock_irqsave(&task_group_lock, flags);
 	for_each_possible_cpu(i) {
 		register_fair_sched_group(tg, i);
 		register_rt_sched_group(tg, i);
+		register_deadline_sched_group(tg, i);
 	}
 	list_add_rcu(&tg->list, &task_groups);
=20
@@ -10287,11 +10491,27 @@ void sched_destroy_group(struct task_group *tg)
 {
 	unsigned long flags;
 	int i;
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+	struct task_group *parent =3D tg->parent;
=20
 	spin_lock_irqsave(&task_group_lock, flags);
+
+	/*
+	 * If a deadline group goes away, its parent group
+	 * (if any), ends up with some free bandwidth that
+	 * it might use for other groups/tasks.
+	 */
+	spin_lock(&parent->dl_bandwidth.lock);
+	if (tg->dl_bandwidth.bw && parent)
+		parent->dl_bandwidth.total_bw -=3D tg->dl_bandwidth.bw;
+	spin_unlock(&parent->dl_bandwidth.lock);
+#else
+	spin_lock_irqsave(&task_group_lock, flags);
+#endif
 	for_each_possible_cpu(i) {
 		unregister_fair_sched_group(tg, i);
 		unregister_rt_sched_group(tg, i);
+		unregister_deadline_sched_group(tg, i);
 	}
 	list_del_rcu(&tg->list);
 	list_del_rcu(&tg->siblings);
@@ -10672,6 +10892,113 @@ static int sched_rt_global_constraints(void)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
=20
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+/* Must be called with tasklist_lock held */
+static inline int tg_has_deadline_tasks(struct task_group *tg)
+{
+	struct task_struct *g, *p;
+
+	do_each_thread(g, p) {
+		if (deadline_task(p) && task_group(p) =3D=3D tg)
+			return 1;
+	} while_each_thread(g, p);
+
+	return 0;
+}
+
+static inline
+void tg_set_deadline_bandwidth(struct task_group *tg, u64 r, u64 p, u64 bw=
)
+{
+	assert_spin_locked(&tg->dl_bandwidth.lock);
+
+	tg->dl_bandwidth.runtime_max =3D r;
+	tg->dl_bandwidth.period =3D p;
+	tg->dl_bandwidth.bw =3D bw;
+}
+
+/*
+ * Here we check if the new group parameters are schedulable in the
+ * system. This depends on these new parameters and on the free bandwidth
+ * either in the parent group or in the whole system.
+ */
+static int __deadline_schedulable(struct task_group *tg,
+				  u64 runtime_max, u64 period)
+{
+	struct task_group *parent =3D tg->parent;
+	u64 bw, old_bw, parent_bw;
+	int ret =3D 0;
+
+	/*
+	 * Note that we allow runtime > period, since it makes sense to
+	 * assign more than 100% bandwidth to a group on SMP machine.
+	 */
+	mutex_lock(&deadline_constraints_mutex);
+	spin_lock_irq(&tg->dl_bandwidth.lock);
+
+	bw =3D period <=3D 0 ? 0 : to_ratio(period, runtime_max);
+	if (bw < tg->dl_bandwidth.total_bw) {
+		ret =3D -EINVAL;
+		goto unlock_tg;
+	}
+
+	/*
+	 * The root group has no parent, but its assigned bandwidth has
+	 * to stay below the global bandwidth value given by
+	 * sysctl_sched_deadline_runtime / sysctl_sched_deadline_period.
+	 */
+	if (!parent) {
+		/* root group */
+		if (sysctl_sched_deadline_period <=3D 0)
+			parent_bw =3D 0;
+		else
+			parent_bw =3D to_ratio(sysctl_sched_deadline_period,
+					     sysctl_sched_deadline_runtime);
+		if (parent_bw >=3D bw)
+			tg_set_deadline_bandwidth(tg, runtime_max, period, bw);
+		else
+			ret =3D -EINVAL;
+	} else {
+		/* non-root groups */
+		spin_lock(&parent->dl_bandwidth.lock);
+		parent_bw =3D parent->dl_bandwidth.bw;
+		old_bw =3D tg->dl_bandwidth.bw;
+
+		if (parent_bw >=3D parent->dl_bandwidth.total_bw -
+				 old_bw + bw) {
+			tg_set_deadline_bandwidth(tg, runtime_max, period, bw);
+			parent->dl_bandwidth.total_bw -=3D old_bw;
+			parent->dl_bandwidth.total_bw +=3D bw;
+		} else
+			ret =3D -EINVAL;
+		spin_unlock(&parent->dl_bandwidth.lock);
+	}
+unlock_tg:
+	spin_unlock_irq(&tg->dl_bandwidth.lock);
+	mutex_unlock(&deadline_constraints_mutex);
+
+	return ret;
+}
+
+static int sched_deadline_global_constraints(void)
+{
+	struct task_group *tg =3D &init_task_group;
+	u64 bw;
+	int ret =3D 1;
+
+	spin_lock_irq(&tg->dl_bandwidth.lock);
+	if (sysctl_sched_deadline_period <=3D 0)
+		bw =3D 0;
+	else
+		bw =3D to_ratio(global_deadline_period(),
+			      global_deadline_runtime());
+
+	if (bw < tg->dl_bandwidth.bw)
+		ret =3D 0;
+	spin_unlock_irq(&tg->dl_bandwidth.lock);
+
+	return ret;
+}
+#else /* !CONFIG_DEADLINE_GROUP_SCHED */
 static int sched_deadline_global_constraints(void)
 {
 	u64 bw;
@@ -10690,6 +11017,7 @@ static int sched_deadline_global_constraints(void)
=20
 	return ret;
 }
+#endif /* CONFIG_DEADLINE_GROUP_SCHED */
=20
 int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
@@ -10784,9 +11112,15 @@ cpu_cgroup_destroy(struct cgroup_subsys *ss, struc=
t cgroup *cgrp)
 static int
 cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
+#if defined(CONFIG_RT_GROUP_SCHED) || defined(CONFIG_DEADLINE_GROUP_SCHED)
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (!sched_rt_can_attach(cgroup_tg(cgrp), tsk))
 		return -EINVAL;
+#endif
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+	if (!sched_deadline_can_attach(cgrp, tsk))
+		return -EINVAL;
+#endif
 #else
 	/* We don't support RT-tasks being in separate groups */
 	if (tsk->sched_class !=3D &fair_sched_class)
@@ -10822,6 +11156,29 @@ cpu_cgroup_attach(struct cgroup_subsys *ss, struct=
 cgroup *cgrp,
 		  struct cgroup *old_cont, struct task_struct *tsk,
 		  bool threadgroup)
 {
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+	struct task_group *tg =3D container_of(cgroup_subsys_state(cgrp,
+					     cpu_cgroup_subsys_id),
+					     struct task_group, css);
+	struct task_group *old_tg =3D container_of(cgroup_subsys_state(old_cont,
+						 cpu_cgroup_subsys_id),
+						 struct task_group, css);
+
+	/*
+	 * An amount of bandwidth equal to the bandwidth of tsk
+	 * is freed in the former group of tsk, and declared occupied
+	 * in the new one.
+	 */
+	spin_lock_irq(&tg->dl_bandwidth.lock);
+	tg->dl_bandwidth.total_bw +=3D tsk->dl.bw;
+
+	if (old_tg) {
+		spin_lock(&old_tg->dl_bandwidth.lock);
+		old_tg->dl_bandwidth.total_bw -=3D tsk->dl.bw;
+		spin_unlock(&old_tg->dl_bandwidth.lock);
+	}
+	spin_unlock_irq(&tg->dl_bandwidth.lock);
+#endif
 	sched_move_task(tsk);
 	if (threadgroup) {
 		struct task_struct *c;
@@ -10872,6 +11229,56 @@ static u64 cpu_rt_period_read_uint(struct cgroup *=
cgrp, struct cftype *cft)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
=20
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+static int cpu_deadline_runtime_write_uint(struct cgroup *cgrp,
+					   struct cftype *cftype,
+					   u64 dl_runtime_us)
+{
+	struct task_group *tg =3D cgroup_tg(cgrp);
+
+	return __deadline_schedulable(tg, dl_runtime_us * NSEC_PER_USEC,
+				      tg->dl_bandwidth.period);
+}
+
+static u64 cpu_deadline_runtime_read_uint(struct cgroup *cgrp,
+					  struct cftype *cft)
+{
+	struct task_group *tg =3D cgroup_tg(cgrp);
+	u64 runtime;
+
+	spin_lock_irq(&tg->dl_bandwidth.lock);
+	runtime =3D tg->dl_bandwidth.runtime_max;
+	spin_unlock_irq(&tg->dl_bandwidth.lock);
+	do_div(runtime, NSEC_PER_USEC);
+
+	return runtime;
+}
+
+static int cpu_deadline_period_write_uint(struct cgroup *cgrp,
+					  struct cftype *cftype,
+					  u64 dl_period_us)
+{
+	struct task_group *tg =3D cgroup_tg(cgrp);
+
+	return __deadline_schedulable(tg, tg->dl_bandwidth.runtime_max,
+				      dl_period_us * NSEC_PER_USEC);
+}
+
+static u64 cpu_deadline_period_read_uint(struct cgroup *cgrp,
+					 struct cftype *cft)
+{
+	struct task_group *tg =3D cgroup_tg(cgrp);
+	u64 period;
+
+	spin_lock_irq(&tg->dl_bandwidth.lock);
+	period =3D tg->dl_bandwidth.period;
+	spin_unlock_irq(&tg->dl_bandwidth.lock);
+	do_div(period, NSEC_PER_USEC);
+
+	return period;
+}
+#endif /* CONFIG_DEADLINE_GROUP_SCHED */
+
 static struct cftype cpu_files[] =3D {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
@@ -10892,6 +11299,18 @@ static struct cftype cpu_files[] =3D {
 		.write_u64 =3D cpu_rt_period_write_uint,
 	},
 #endif
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+	{
+		.name =3D "deadline_runtime_us",
+		.read_u64 =3D cpu_deadline_runtime_read_uint,
+		.write_u64 =3D cpu_deadline_runtime_write_uint,
+	},
+	{
+		.name =3D "deadline_period_us",
+		.read_u64 =3D cpu_deadline_period_read_uint,
+		.write_u64 =3D cpu_deadline_period_write_uint,
+	},
+#endif
 };
=20
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *co=
nt)
diff --git a/kernel/sched_deadline.c b/kernel/sched_deadline.c
index 82c0192..a14b928 100644
--- a/kernel/sched_deadline.c
+++ b/kernel/sched_deadline.c
@@ -15,6 +15,10 @@
  * However, thanks to bandwidth isolation, overruns and deadline misses
  * remains local, and does not affect any other task in the system.
  *
+ * Groups, if configured, have bandwidth as well, and it is enforced that
+ * the sum of the bandwidths of entities (tasks and groups) belonging to
+ * a group stays below its own bandwidth.
+ *
  * Copyright (C) 2009 Dario Faggioli, Michael Trimarchi
  */
=20
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 809ba55..27ab926 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -146,7 +146,8 @@ static void print_rq(struct seq_file *m, struct rq *rq,=
 int rq_cpu)
 }
=20
 #if defined(CONFIG_CGROUP_SCHED) && \
-	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
+	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED) || \
+	 defined(CONFIG_DEADLINE_GROUP_SCHED))
 static void task_group_path(struct task_group *tg, char *buf, int buflen)
 {
 	/* may be NULL if the underlying cgroup isn't fully-created yet */
--=20
1.6.0.4


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-qan1MnDs+qmA1/Jk9Cp7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrYlWQACgkQk4XaBE3IOsSgxgCeKGQPbebYtyvQtfQFjalFck75
l3IAn2FCaDcNQ3tmPA7jOvXzNzM9ugOL
=xM7p
-----END PGP SIGNATURE-----

--=-qan1MnDs+qmA1/Jk9Cp7--


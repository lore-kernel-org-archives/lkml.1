Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbZIYFfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbZIYFfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 01:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZIYFfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 01:35:18 -0400
Received: from ms01.sssup.it ([193.205.80.99]:41794 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750936AbZIYFfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 01:35:13 -0400
Subject: Re: massive_intr on CFS, BFS, and EDF
From: Raistlin <raistlin@linux.it>
To: sat <takeuchi_satoru@jp.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <4ABC068A.6070704@jp.fujitsu.com>
References: <4ABC068A.6070704@jp.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mI5ep1no9cpGb4+6epdo"
Date: Fri, 25 Sep 2009 07:35:11 +0200
Message-Id: <1253856911.1594.1.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mI5ep1no9cpGb4+6epdo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-09-25 at 08:53 +0900, sat wrote:
> Hi,
>=20
Hi,

> I tried massive_intr, a process scheduler's fairness and throughtput test=
ing
> program for massive interactive processes, on vanilla 2.6.31, 2.6.31-bfs2=
11
> (with BFS) and 2.6.31-edf(latest linus tree + EDF patch).
>=20
Hey, thanks a lot, that's interesting!

> CFS and BFS look good. CFS has better fairness, and BFS has better throug=
hput.
> EDF looks unfair and is unstable. I tested 3 times and the tendency was t=
he
> same.
>=20
>   NOTE:
>=20
>   - BFS patch is applied to 2.6.31, but EDF patch is applied to latest li=
nus
>     tree, so they can't compare strictly. This report is just FYI.
>=20
>   - EDF kernel shows some strange behavior as follows:
>=20
>      * aptitude(debian package management tool) stacks on the way
>      * oocalc doesn't start
>=20
>   - I dont't subscribe lkml now. So if you reply, pleas CC me.
>=20
Ok... I have to run now, but I'll look carefully at the results when
I'll be back.

In the meanwhile, if you want and have time, here's a new version of the
patch, which solves some BUGs, in case you want to you give it another
try...

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 89f7ead..e851625 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -391,6 +391,9 @@
 #define __NR_pwritev			(__NR_SYSCALL_BASE+362)
 #define __NR_rt_tgsigqueueinfo		(__NR_SYSCALL_BASE+363)
 #define __NR_perf_event_open		(__NR_SYSCALL_BASE+364)
+#define __NR_sched_setscheduler_ex	(__NR_SYSCALL_BASE+365)
+#define __NR_sched_setparam_ex		(__NR_SYSCALL_BASE+366)
+#define __NR_sched_getparam_ex		(__NR_SYSCALL_BASE+367)
=20
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index fafce1b..42ad362 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -374,6 +374,9 @@
 		CALL(sys_pwritev)
 		CALL(sys_rt_tgsigqueueinfo)
 		CALL(sys_perf_event_open)
+/* 365 */	CALL(sys_sched_setscheduler_ex)
+		CALL(sys_sched_setparam_ex)
+		CALL(sys_sched_getparam_ex)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 74619c4..fde92c2 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -832,4 +832,7 @@ ia32_sys_call_table:
 	.quad compat_sys_pwritev
 	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 	.quad sys_perf_event_open
+	.quad sys_sched_setscheduler_ex
+	.quad sys_sched_setparam_ex
+	.quad sys_sched_getparam_ex
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd=
_32.h
index 6fb3c20..a83163f 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -342,6 +342,9 @@
 #define __NR_pwritev		334
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
+#define __NR_sched_setscheduler_ex	337
+#define __NR_sched_setparam_ex	338
+#define __NR_sched_getparam_ex	339
=20
 #ifdef __KERNEL__
=20
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd=
_64.h
index 8d3ad0a..a11831c 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -661,6 +661,12 @@ __SYSCALL(__NR_pwritev, sys_pwritev)
 __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 #define __NR_perf_event_open			298
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
+#define __NR_sched_setscheduler_ex		299
+__SYSCALL(__NR_sched_setscheduler_ex, sys_sched_setscheduler_ex)
+#define __NR_sched_setparam_ex		230
+__SYSCALL(__NR_sched_setparam_ex, sys_sched_setparam_ex)
+#define __NR_sched_getparam_ex		231
+__SYSCALL(__NR_sched_getparam_ex, sys_sched_getparam_ex)
=20
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_t=
able_32.S
index 0157cd2..38f056c 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -336,3 +336,6 @@ ENTRY(sys_call_table)
 	.long sys_pwritev
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_event_open
+	.long sys_sched_setscheduler_ex
+	.long sys_sched_setparam_ex
+	.long sys_sched_getparam_ex
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 848d1f2..feb5ecb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -38,6 +38,7 @@
 #define SCHED_BATCH		3
 /* SCHED_ISO: reserved but not implemented yet */
 #define SCHED_IDLE		5
+#define SCHED_EDF		6
 /* Can be ORed in to make sure the process is reverted back to SCHED_NORMA=
L on fork */
 #define SCHED_RESET_ON_FORK     0x40000000
=20
@@ -94,6 +95,19 @@ struct sched_param {
=20
 #include <asm/processor.h>
=20
+/*
+ * For an typical EDF periodic or sporadic task we need a runtime
+ * and period (equal to deadline) specification in the sched_param
+ * structure.
+ * However, the original struct sched_param can't be modified, for binary
+ * compatibility issues, and thus this new one is created.
+ */
+struct sched_param_ex {
+	int sched_priority;
+	struct timespec sched_period;
+	struct timespec sched_runtime;
+};
+
 struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
@@ -151,12 +165,15 @@ extern unsigned long get_parent_ip(unsigned long addr=
);
=20
 struct seq_file;
 struct cfs_rq;
+struct edf_rq;
 struct task_group;
 #ifdef CONFIG_SCHED_DEBUG
 extern void proc_sched_show_task(struct task_struct *p, struct seq_file *m=
);
 extern void proc_sched_set_task(struct task_struct *p);
 extern void
 print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq);
+extern void
+print_edf_rq(struct seq_file *m, int cpu, struct edf_rq *edf_rq);
 #else
 static inline void
 proc_sched_show_task(struct task_struct *p, struct seq_file *m)
@@ -169,6 +186,10 @@ static inline void
 print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 {
 }
+static inline void
+print_edf_rq(struct seq_file *m, int cpu, struct edf_rq *edf_rq)
+{
+}
 #endif
=20
 extern unsigned long long time_sync_thresh;
@@ -1194,6 +1215,29 @@ struct sched_entity {
 #endif
 };
=20
+#define EDF_NEW		1
+#define EDF_ENDED	2
+#define EDF_RUNNING	4
+#define EDF_THROTTLED	8
+
+struct sched_edf_entity {
+	struct rb_node	rb_node;
+	/* actual scheduling parameters */
+	u64		deadline;
+	s64		runtime;
+	unsigned int	edf_flags;
+
+	/* original parameters taken from sched_param_ex */
+	u64		runtime_max;
+	u64		period;
+#ifdef CONFIG_EDF_GROUP_SCHED
+	u64		bw;
+#endif
+
+	int		nr_cpus_allowed;
+	struct hrtimer	edf_timer;
+};
+
 struct sched_rt_entity {
 	struct list_head run_list;
 	unsigned long timeout;
@@ -1231,6 +1275,7 @@ struct task_struct {
 	unsigned int rt_priority;
 	const struct sched_class *sched_class;
 	struct sched_entity se;
+	struct sched_edf_entity edf;
 	struct sched_rt_entity rt;
=20
 #ifdef CONFIG_PREEMPT_NOTIFIERS
@@ -1576,6 +1621,18 @@ static inline int rt_task(struct task_struct *p)
 	return rt_prio(p->prio);
 }
=20
+static inline int edf_policy(int policy)
+{
+	if (unlikely(policy =3D=3D SCHED_EDF))
+		return 1;
+	return 0;
+}
+
+static inline int edf_task(struct task_struct *p)
+{
+	return edf_policy(p->policy);
+}
+
 static inline struct pid *task_pid(struct task_struct *task)
 {
 	return task->pids[PIDTYPE_PID].pid;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a990ace..dad0b33 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -33,6 +33,7 @@ struct pollfd;
 struct rlimit;
 struct rusage;
 struct sched_param;
+struct sched_param_ex;
 struct semaphore;
 struct sembuf;
 struct shmid_ds;
@@ -390,11 +391,17 @@ asmlinkage long sys_clock_nanosleep(clockid_t which_c=
lock, int flags,
 asmlinkage long sys_nice(int increment);
 asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_setscheduler_ex(pid_t pid, int policy,
+					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_setparam(pid_t pid,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_setparam_ex(pid_t pid,
+					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_getscheduler(pid_t pid);
 asmlinkage long sys_sched_getparam(pid_t pid,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_getparam_ex(pid_t pid,
+					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 					unsigned long __user *user_mask_ptr);
 asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
diff --git a/init/Kconfig b/init/Kconfig
index c7bac39..2ec22ee 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -454,6 +454,20 @@ config RT_GROUP_SCHED
 	  realtime bandwidth for them.
 	  See Documentation/scheduler/sched-rt-group.txt for more information.
=20
+config EDF_GROUP_SCHED
+	bool "Group scheduling for SCHED_EDF"
+	depends on EXPERIMENTAL
+	depends on GROUP_SCHED
+	depends on CGROUPS
+	depends on !USER_SCHED
+	select CPUSETS
+	default n
+	help
+	  This feature lets you explicitly specify, in terms of runtime
+	  and period, the bandwidth of a task control group. This means
+	  tasks and other control groups can be added, until such bandwidth
+	  limit is reached, after that they will fail.
+
 choice
 	depends on GROUP_SCHED
 	prompt "Basis for grouping tasks"
diff --git a/kernel/fork.c b/kernel/fork.c
index 51ad0b0..56d5a8b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1226,6 +1226,18 @@ static struct task_struct *copy_process(unsigned lon=
g clone_flags,
 		p->parent_exec_id =3D current->self_exec_id;
 	}
=20
+	/*
+	 * In case an EDF task is forking, both parent and child get half
+	 * the bandwidth of the parent (via dividing runtime by 2).
+	 * This make it a lot easier to deal with control group bandwidth, and
+	 * also prevent an heavily spawning task to exhaust the system (or
+	 * a control group, if enabled) bandwidht.
+	 */
+	if (edf_task(p->real_parent)) {
+		p->real_parent->edf.runtime_max /=3D 2;
+		p->edf.runtime_max =3D p->real_parent->edf.runtime_max;
+	}
+
 	spin_lock(&current->sighand->siglock);
=20
 	/*
diff --git a/kernel/sched.c b/kernel/sched.c
index 2f76e06..d50d42e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -131,6 +131,11 @@ static inline int task_has_rt_policy(struct task_struc=
t *p)
 	return rt_policy(p->policy);
 }
=20
+static inline int task_has_edf_policy(struct task_struct *p)
+{
+	return edf_policy(p->policy);
+}
+
 /*
  * This is the priority-queue data structure of the RT scheduling class:
  */
@@ -227,6 +232,16 @@ static void destroy_rt_bandwidth(struct rt_bandwidth *=
rt_b)
 }
 #endif
=20
+struct edf_bandwidth {
+	spinlock_t		lock;
+	/* runtime and period that determine the bandwidth of the group */
+	u64			runtime_max;
+	u64			period;
+	u64			bw;
+	/* accumulator for the actual allocated bandwidth in a group */
+	u64			total_bw;
+};
+
 /*
  * sched_domains_mutex serializes calls to arch_init_sched_domains,
  * detach_destroy_domains and partition_sched_domains.
@@ -259,6 +274,11 @@ struct task_group {
 	unsigned long shares;
 #endif
=20
+#ifdef CONFIG_EDF_GROUP_SCHED
+	struct edf_bandwidth edf_bandwidth;
+	struct edf_rq **edf_rq;
+#endif
+
 #ifdef CONFIG_RT_GROUP_SCHED
 	struct sched_rt_entity **rt_se;
 	struct rt_rq **rt_rq;
@@ -296,6 +316,10 @@ static DEFINE_PER_CPU(struct sched_entity, init_sched_=
entity);
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct cfs_rq, init_tg_cfs_rq);
 #endif /* CONFIG_FAIR_GROUP_SCHED */
=20
+#ifdef CONFIG_EDF_GROUP_SCHED
+static DEFINE_PER_CPU(struct edf_rq, init_edf_rq) ____cacheline_aligned_in=
_smp;
+#endif
+
 #ifdef CONFIG_RT_GROUP_SCHED
 static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rt_rq, init_rt_rq);
@@ -447,6 +471,18 @@ struct cfs_rq {
 #endif
 };
=20
+struct edf_rq {
+	unsigned long edf_nr_running;
+
+	/* as in CFS, the runqueue is based on an rbtree, deadline ordered */
+	struct rb_root rb_root;
+	struct rb_node *rb_leftmost;
+
+#ifdef CONFIG_EDF_GROUP_SCHED
+	struct rq *rq;
+#endif
+};
+
 /* Real-Time classes' related field in a runqueue: */
 struct rt_rq {
 	struct rt_prio_array active;
@@ -544,6 +580,7 @@ struct rq {
 	u64 nr_migrations_in;
=20
 	struct cfs_rq cfs;
+	struct edf_rq edf;
 	struct rt_rq rt;
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -1816,7 +1853,9 @@ static void calc_load_account_active(struct rq *this_=
rq);
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
+#include "sched_edf.c"
 #include "sched_rt.c"
+
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
 #endif
@@ -1837,7 +1876,7 @@ static void dec_nr_running(struct rq *rq)
=20
 static void set_load_weight(struct task_struct *p)
 {
-	if (task_has_rt_policy(p)) {
+	if (task_has_rt_policy(p) || task_has_edf_policy(p)) {
 		p->se.load.weight =3D prio_to_weight[0] * 2;
 		p->se.load.inv_weight =3D prio_to_wmult[0] >> 1;
 		return;
@@ -2523,7 +2562,8 @@ void sched_fork(struct task_struct *p, int clone_flag=
s)
 	 * Revert to default priority/policy on fork if requested.
 	 */
 	if (unlikely(p->sched_reset_on_fork)) {
-		if (p->policy =3D=3D SCHED_FIFO || p->policy =3D=3D SCHED_RR)
+		if (p->policy =3D=3D SCHED_FIFO || p->policy =3D=3D SCHED_RR ||
+		    edf_policy(p->policy))
 			p->policy =3D SCHED_NORMAL;
=20
 		if (p->normal_prio < DEFAULT_PRIO)
@@ -2541,8 +2581,12 @@ void sched_fork(struct task_struct *p, int clone_fla=
gs)
 		p->sched_reset_on_fork =3D 0;
 	}
=20
-	if (!rt_prio(p->prio))
-		p->sched_class =3D &fair_sched_class;
+	if (!rt_prio(p->prio)) {
+		if (edf_policy(p->policy))
+			p->sched_class =3D &edf_sched_class;
+		else
+			p->sched_class =3D &fair_sched_class;
+	}
=20
 #ifdef CONFIG_SMP
 	cpu =3D p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
@@ -2565,6 +2609,68 @@ void sched_fork(struct task_struct *p, int clone_fla=
gs)
 	put_cpu();
 }
=20
+#if defined(CONFIG_RT_GROUP_SCHED) || defined(CONFIG_EDF_GROUP_SCHED)
+static unsigned long to_ratio(u64 period, u64 runtime)
+{
+	if (runtime =3D=3D RUNTIME_INF)
+		return 1ULL << 20;
+
+	return div64_u64(runtime << 20, period);
+}
+
+#ifdef CONFIG_EDF_GROUP_SCHED
+static inline
+void __edf_tg_clear_task_bw(struct task_group *tg, u64 tsk_bw)
+{
+	tg->edf_bandwidth.total_bw -=3D tsk_bw;
+}
+
+static inline
+void __edf_tg_add_task_bw(struct task_group *tg, u64 tsk_bw)
+{
+	tg->edf_bandwidth.total_bw +=3D tsk_bw;
+}
+
+static inline
+int __edf_check_task_tg_bw(struct task_struct *p, struct task_group *tg,
+			   int policy, struct sched_param_ex *param_ex)
+{
+	u64 tg_bw =3D tg->edf_bandwidth.bw;
+	u64 bw =3D p->edf.bw;
+	u64 new_bw =3D 0;
+
+	if (tg->edf_bandwidth.bw <=3D 0)
+		return 0;
+
+	if (edf_policy(policy))
+		new_bw =3D to_ratio(timespec_to_ns(&param_ex->sched_period),
+				  timespec_to_ns(&param_ex->sched_runtime));
+
+	/*
+	 * Either if a task, enters, leave, or stays SCHED_EDF but changing
+	 * its parameters, we need to update accordingly the allocated
+	 * bandwidth of the control group it is inside.
+	 */
+	if (task_has_edf_policy(p) && !edf_policy(policy)) {
+		__edf_tg_clear_task_bw(tg, bw);
+		return 1;
+	} else if (task_has_edf_policy(p) && edf_policy(policy) &&
+		   tg_bw >=3D tg->edf_bandwidth.total_bw - bw + new_bw) {
+		__edf_tg_clear_task_bw(tg, bw);
+		__edf_tg_add_task_bw(tg, new_bw);
+		return 1;
+	} else if (edf_policy(policy) && !task_has_edf_policy(p) &&
+		   tg_bw >=3D tg->edf_bandwidth.total_bw + new_bw) {
+		__edf_tg_add_task_bw(tg, new_bw);
+		return 1;
+	}
+
+	return 0;
+}
+#endif /* CONFIG_EDF_GROUP_SCHED */
+
+#endif /* CONFIG_RT_GROUP_SCHED || CONFIG_EDF_GROUP_SCHED */
+
 /*
  * wake_up_new_task - wake up a newly created task for the first time.
  *
@@ -2582,6 +2688,17 @@ void wake_up_new_task(struct task_struct *p, unsigne=
d long clone_flags)
 	update_rq_clock(rq);
=20
 	p->prio =3D effective_prio(p);
+	if (edf_task(p)) {
+		struct sched_edf_entity *edf_se =3D &p->edf;
+
+		/*
+		 * If the new task we are waking up is EDF,
+		 * some initialization is needed
+		 */
+		RB_CLEAR_NODE(&edf_se->rb_node);
+		edf_se->edf_flags =3D EDF_NEW;
+		init_edf_timer(&edf_se->edf_timer);
+	}
=20
 	if (!p->sched_class->task_new || !current->se.on_rq) {
 		activate_task(rq, p, 0);
@@ -2725,6 +2842,23 @@ static void finish_task_switch(struct rq *rq, struct=
 task_struct *prev)
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state =3D=3D TASK_DEAD)) {
+#ifdef CONFIG_EDF_GROUP_SCHED
+		if (edf_task(prev)) {
+			struct task_group *tg =3D task_group(prev);
+			unsigned long flags;
+
+			/*
+			 * When an EDF task dies, we need to drain its
+			 * bandwidth from the cgroup it was accomodating hime,
+			 * to make space for new tasks.
+			 */
+			spin_lock_irqsave(&tg->edf_bandwidth.lock, flags);
+			__edf_tg_clear_task_bw(tg, prev->edf.bw);
+			spin_unlock_irqrestore(&tg->edf_bandwidth.lock, flags);
+
+			hrtimer_cancel(&prev->edf.edf_timer);
+		}
+#endif
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
@@ -5964,8 +6098,12 @@ void rt_mutex_setprio(struct task_struct *p, int pri=
o)
=20
 	if (rt_prio(prio))
 		p->sched_class =3D &rt_sched_class;
-	else
-		p->sched_class =3D &fair_sched_class;
+	else {
+		if (!edf_task(p))
+			p->sched_class =3D &fair_sched_class;
+		else
+			p->sched_class =3D &edf_sched_class;
+	}
=20
 	p->prio =3D prio;
=20
@@ -5999,9 +6137,9 @@ void set_user_nice(struct task_struct *p, long nice)
 	 * The RT priorities are set via sched_setscheduler(), but we still
 	 * allow the 'normal' nice value to be set - but as expected
 	 * it wont have any effect on scheduling until the task is
-	 * SCHED_FIFO/SCHED_RR:
+	 * SCHED_EDF, SCHED_FIFO or SCHED_RR:
 	 */
-	if (task_has_rt_policy(p)) {
+	if (unlikely(task_has_rt_policy(p) || task_has_edf_policy(p))) {
 		p->static_prio =3D NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
@@ -6148,6 +6286,9 @@ __setscheduler(struct rq *rq, struct task_struct *p, =
int policy, int prio)
 	case SCHED_IDLE:
 		p->sched_class =3D &fair_sched_class;
 		break;
+	case SCHED_EDF:
+		p->sched_class =3D &edf_sched_class;
+		break;
 	case SCHED_FIFO:
 	case SCHED_RR:
 		p->sched_class =3D &rt_sched_class;
@@ -6161,6 +6302,23 @@ __setscheduler(struct rq *rq, struct task_struct *p,=
 int policy, int prio)
 	set_load_weight(p);
 }
=20
+static void
+__setscheduler_ex(struct rq *rq, struct task_struct *p, int policy,
+		  struct sched_param_ex *param_ex)
+{
+	struct sched_edf_entity *edf_se =3D &p->edf;
+
+	RB_CLEAR_NODE(&edf_se->rb_node);
+	edf_se->edf_flags =3D EDF_NEW;
+
+	edf_se->runtime_max =3D timespec_to_ns(&param_ex->sched_runtime);
+	edf_se->period =3D timespec_to_ns(&param_ex->sched_period);
+#ifdef CONFIG_EDF_GROUP_SCHED
+	edf_se->bw =3D to_ratio(edf_se->period, edf_se->runtime_max);
+#endif
+	init_edf_timer(&edf_se->edf_timer);
+}
+
 /*
  * check the target process has a UID that matches the current process's
  */
@@ -6178,7 +6336,9 @@ static bool check_same_owner(struct task_struct *p)
 }
=20
 static int __sched_setscheduler(struct task_struct *p, int policy,
-				struct sched_param *param, bool user)
+				struct sched_param *param,
+				struct sched_param_ex *param_ex,
+				bool user)
 {
 	int retval, oldprio, oldpolicy =3D -1, on_rq, running;
 	unsigned long flags;
@@ -6198,6 +6358,7 @@ recheck:
 		policy &=3D ~SCHED_RESET_ON_FORK;
=20
 		if (policy !=3D SCHED_FIFO && policy !=3D SCHED_RR &&
+				policy !=3D SCHED_EDF &&
 				policy !=3D SCHED_NORMAL && policy !=3D SCHED_BATCH &&
 				policy !=3D SCHED_IDLE)
 			return -EINVAL;
@@ -6212,6 +6373,13 @@ recheck:
 	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
 	    (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
 		return -EINVAL;
+	if (edf_policy(policy) && param_ex->sched_priority !=3D 0)
+		return -EINVAL;
+	if (edf_policy(policy) && (param_ex =3D=3D NULL ||
+	    timespec_to_ns(&param_ex->sched_period) =3D=3D 0 ||
+	    timespec_to_ns(&param_ex->sched_period) <
+	    timespec_to_ns(&param_ex->sched_runtime)))
+		return -EINVAL;
 	if (rt_policy(policy) !=3D (param->sched_priority !=3D 0))
 		return -EINVAL;
=20
@@ -6285,6 +6453,24 @@ recheck:
 		spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
+#ifdef CONFIG_EDF_GROUP_SCHED
+	/*
+	 * If EDF tasks are involved, check tha bandwidth of  its group,
+	 * and do not allow setting the task EDF if there is not enough.
+	 */
+	if (edf_policy(policy) || edf_task(p)) {
+		struct task_group *tg =3D task_group(p);
+
+		spin_lock(&tg->edf_bandwidth.lock);
+		if (!__edf_check_task_tg_bw(p, tg, policy, param_ex)) {
+			spin_unlock(&tg->edf_bandwidth.lock);
+			__task_rq_unlock(rq);
+			spin_unlock_irqrestore(&p->pi_lock, flags);
+			return -EPERM;
+		}
+		spin_unlock(&tg->edf_bandwidth.lock);
+	}
+#endif
 	update_rq_clock(rq);
 	on_rq =3D p->se.on_rq;
 	running =3D task_current(rq, p);
@@ -6297,6 +6483,8 @@ recheck:
=20
 	oldprio =3D p->prio;
 	__setscheduler(rq, p, policy, param->sched_priority);
+	if (edf_policy(policy))
+		__setscheduler_ex(rq, p, policy, param_ex);
=20
 	if (running)
 		p->sched_class->set_curr_task(rq);
@@ -6324,10 +6512,17 @@ recheck:
 int sched_setscheduler(struct task_struct *p, int policy,
 		       struct sched_param *param)
 {
-	return __sched_setscheduler(p, policy, param, true);
+	return __sched_setscheduler(p, policy, param, NULL, true);
 }
 EXPORT_SYMBOL_GPL(sched_setscheduler);
=20
+int sched_setscheduler_ex(struct task_struct *p, int policy,
+			  struct sched_param *param,
+			  struct sched_param_ex *param_ex)
+{
+	return __sched_setscheduler(p, policy, param, param_ex, true);
+}
+
 /**
  * sched_setscheduler_nocheck - change the scheduling policy and/or RT pri=
ority of a thread from kernelspace.
  * @p: the task in question.
@@ -6342,7 +6537,7 @@ EXPORT_SYMBOL_GPL(sched_setscheduler);
 int sched_setscheduler_nocheck(struct task_struct *p, int policy,
 			       struct sched_param *param)
 {
-	return __sched_setscheduler(p, policy, param, false);
+	return __sched_setscheduler(p, policy, param, NULL, false);
 }
=20
 static int
@@ -6367,6 +6562,33 @@ do_sched_setscheduler(pid_t pid, int policy, struct =
sched_param __user *param)
 	return retval;
 }
=20
+static int
+do_sched_setscheduler_ex(pid_t pid, int policy,
+			 struct sched_param_ex __user *param_ex)
+{
+	struct sched_param lparam;
+	struct sched_param_ex lparam_ex;
+	struct task_struct *p;
+	int retval;
+
+	if (!param_ex || pid < 0)
+		return -EINVAL;
+	if (copy_from_user(&lparam_ex, param_ex,
+	    sizeof(struct sched_param_ex)))
+		return -EFAULT;
+
+	rcu_read_lock();
+	retval =3D -ESRCH;
+	p =3D find_process_by_pid(pid);
+	if (p !=3D NULL) {
+		lparam.sched_priority =3D lparam_ex.sched_priority;
+		retval =3D sched_setscheduler_ex(p, policy, &lparam, &lparam_ex);
+	}
+	rcu_read_unlock();
+
+	return retval;
+}=09
+
 /**
  * sys_sched_setscheduler - set/change the scheduler policy and RT priorit=
y
  * @pid: the pid in question.
@@ -6384,6 +6606,22 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int,=
 policy,
 }
=20
 /**
+ * sys_sched_setscheduler_ex - set/change the scheduler policy and EDF dea=
dline
+ * @pid: the pid in question.
+ * @policy: new policy (should be SCHED_EDF).
+ * @param: structure containg the extended EDF parameters.
+ */
+SYSCALL_DEFINE3(sched_setscheduler_ex, pid_t, pid, int, policy,
+		struct sched_param_ex __user *, param_ex)
+{
+	if (policy < 0)
+		return -EINVAL;
+
+	return do_sched_setscheduler_ex(pid, policy, param_ex);
+}
+
+
+/**
  * sys_sched_setparam - set/change the RT priority of a thread
  * @pid: the pid in question.
  * @param: structure containing the new RT priority.
@@ -6393,6 +6631,12 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct s=
ched_param __user *, param)
 	return do_sched_setscheduler(pid, -1, param);
 }
=20
+SYSCALL_DEFINE2(sched_setparam_ex, pid_t, pid,
+		struct sched_param_ex __user *, param_ex)
+{
+	return do_sched_setscheduler_ex(pid, -1, param_ex);
+}
+
 /**
  * sys_sched_getscheduler - get the policy (scheduling class) of a thread
  * @pid: the pid in question.
@@ -6457,6 +6701,44 @@ out_unlock:
 	return retval;
 }
=20
+SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
+		struct sched_param_ex __user *, param_ex)
+{
+	struct sched_param_ex lp;
+	struct task_struct *p;
+	int retval;
+
+	if (!param_ex || pid < 0)
+		return -EINVAL;
+
+	read_lock(&tasklist_lock);
+	p =3D find_process_by_pid(pid);
+	retval =3D -ESRCH;
+	if (!p)
+		goto out_unlock;
+
+	retval =3D security_task_getscheduler(p);
+	if (retval)
+		goto out_unlock;
+
+	lp.sched_priority =3D p->rt_priority;
+	lp.sched_runtime =3D ns_to_timespec(p->edf.runtime_max);
+	lp.sched_period =3D ns_to_timespec(p->edf.period);
+	read_unlock(&tasklist_lock);
+
+	/*
+	 * This one might sleep, we cannot do it with a spinlock held ...
+	 */
+	retval =3D copy_to_user(param_ex, &lp, sizeof(*param_ex)) ? -EFAULT : 0;
+
+	return retval;
+
+out_unlock:
+	read_unlock(&tasklist_lock);
+	return retval;
+
+}
+
 long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 {
 	cpumask_var_t cpus_allowed, new_mask;
@@ -9222,6 +9504,14 @@ static void init_cfs_rq(struct cfs_rq *cfs_rq, struc=
t rq *rq)
 	cfs_rq->min_vruntime =3D (u64)(-(1LL << 20));
 }
=20
+static void init_edf_rq(struct edf_rq *edf_rq, struct rq *rq)
+{
+	edf_rq->rb_root =3D RB_ROOT;
+#ifdef CONFIG_EDF_GROUP_SCHED
+	edf_rq->rq =3D rq;
+#endif
+}
+
 static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 {
 	struct rt_prio_array *array;
@@ -9287,6 +9577,22 @@ static void init_tg_cfs_entry(struct task_group *tg,=
 struct cfs_rq *cfs_rq,
 }
 #endif
=20
+#ifdef CONFIG_EDF_GROUP_SCHED
+void init_tg_edf_entry(struct task_group *tg, struct edf_rq *edf_rq,
+		struct sched_edf_entity *edf_se, int cpu, int add,
+		struct sched_edf_entity *parent)
+{
+	struct rq *rq =3D cpu_rq(cpu);
+
+	tg->edf_rq[cpu] =3D &rq->edf;
+
+	spin_lock_init(&tg->edf_bandwidth.lock);
+	tg->edf_bandwidth.runtime_max =3D 0;
+	tg->edf_bandwidth.period =3D 0;
+	tg->edf_bandwidth.total_bw =3D 0;
+}
+#endif
+
 #ifdef CONFIG_RT_GROUP_SCHED
 static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 		struct sched_rt_entity *rt_se, int cpu, int add,
@@ -9328,6 +9634,10 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 	alloc_size +=3D 2 * nr_cpu_ids * sizeof(void **);
 #endif
+#ifdef CONFIG_EDF_GROUP_SCHED
+	alloc_size +=3D 2 * nr_cpu_ids * sizeof(void **);
+#endif
+
 #ifdef CONFIG_USER_SCHED
 	alloc_size *=3D 2;
 #endif
@@ -9356,6 +9666,10 @@ void __init sched_init(void)
 		ptr +=3D nr_cpu_ids * sizeof(void **);
 #endif /* CONFIG_USER_SCHED */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
+#ifdef CONFIG_EDF_GROUP_SCHED
+		init_task_group.edf_rq =3D (struct edf_rq **)ptr;
+		ptr +=3D nr_cpu_ids * sizeof(void **);
+#endif /* CONFIG_EDF_GROUP_SCHED */
 #ifdef CONFIG_RT_GROUP_SCHED
 		init_task_group.rt_se =3D (struct sched_rt_entity **)ptr;
 		ptr +=3D nr_cpu_ids * sizeof(void **);
@@ -9415,6 +9729,7 @@ void __init sched_init(void)
 		rq->calc_load_active =3D 0;
 		rq->calc_load_update =3D jiffies + LOAD_FREQ;
 		init_cfs_rq(&rq->cfs, rq);
+		init_edf_rq(&rq->edf, rq);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.shares =3D init_task_group_load;
@@ -9462,6 +9777,13 @@ void __init sched_init(void)
 #endif
 #endif /* CONFIG_FAIR_GROUP_SCHED */
=20
+#ifdef CONFIG_EDF_GROUP_SCHED
+#ifdef CONFIG_CGROUP_SCHED
+		init_tg_edf_entry(&init_task_group, &rq->edf,
+				  NULL, i, 1, NULL);
+#endif
+#endif
+
 		rq->rt.rt_runtime =3D def_rt_bandwidth.rt_runtime;
 #ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
@@ -9772,6 +10094,68 @@ static inline void unregister_fair_sched_group(stru=
ct task_group *tg, int cpu)
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
=20
+#ifdef CONFIG_EDF_GROUP_SCHED
+static void free_edf_sched_group(struct task_group *tg)
+{
+	kfree(tg->edf_rq);
+}
+
+int alloc_edf_sched_group(struct task_group *tg, struct task_group *parent=
)
+{
+	struct rq *rq;
+	int i;
+
+	tg->edf_rq =3D kzalloc(sizeof(struct edf_rq*) * nr_cpu_ids, GFP_KERNEL);
+	if (!tg->edf_rq)
+		return 0;
+
+	for_each_possible_cpu(i) {
+		rq =3D cpu_rq(i);
+		init_tg_edf_entry(tg, &rq->edf, NULL, i, 0, NULL);
+	}
+
+	return 1;
+}
+
+int sched_edf_can_attach(struct cgroup *cgrp, struct task_struct *tsk)
+{
+	struct task_group *tg =3D container_of(cgroup_subsys_state(cgrp,
+					     cpu_cgroup_subsys_id),
+					     struct task_group, css);
+	u64 tg_bw =3D tg->edf_bandwidth.bw;
+	u64 tsk_bw =3D tsk->edf.bw;
+
+	if (!edf_task(tsk))
+		return 1;
+
+	/*
+	 * Check if the requested group has enough free space
+	 * for this particular task.
+	 */
+	if (tg_bw < tsk_bw + tg->edf_bandwidth.total_bw)
+		return 0;
+
+	return 1;
+}
+#else
+static inline void free_edf_sched_group(struct task_group *tg)
+{
+}
+
+static inline
+int alloc_edf_sched_group(struct task_group *tg, struct task_group *parent=
)
+{
+	return 1;
+}
+#endif
+static inline void register_edf_sched_group(struct task_group *tg, int cpu=
)
+{
+}
+
+static inline void unregister_edf_sched_group(struct task_group *tg, int c=
pu)
+{
+}
+
 #ifdef CONFIG_RT_GROUP_SCHED
 static void free_rt_sched_group(struct task_group *tg)
 {
@@ -9864,6 +10248,7 @@ static inline void unregister_rt_sched_group(struct =
task_group *tg, int cpu)
 static void free_sched_group(struct task_group *tg)
 {
 	free_fair_sched_group(tg);
+	free_edf_sched_group(tg);
 	free_rt_sched_group(tg);
 	kfree(tg);
 }
@@ -9882,12 +10267,16 @@ struct task_group *sched_create_group(struct task_=
group *parent)
 	if (!alloc_fair_sched_group(tg, parent))
 		goto err;
=20
+	if (!alloc_edf_sched_group(tg, parent))
+		goto err;
+
 	if (!alloc_rt_sched_group(tg, parent))
 		goto err;
=20
 	spin_lock_irqsave(&task_group_lock, flags);
 	for_each_possible_cpu(i) {
 		register_fair_sched_group(tg, i);
+		register_edf_sched_group(tg, i);
 		register_rt_sched_group(tg, i);
 	}
 	list_add_rcu(&tg->list, &task_groups);
@@ -9918,12 +10307,31 @@ void sched_destroy_group(struct task_group *tg)
 {
 	unsigned long flags;
 	int i;
+#ifdef CONFIG_EDF_GROUP_SCHED
+	struct task_group *parent =3D tg->parent;
+	u64 tg_bw =3D tg->edf_bandwidth.bw;
=20
 	spin_lock_irqsave(&task_group_lock, flags);
+
+	/*
+	 * If an EDF group goes away, its parent group
+	 * (if any), ends up with some free bandwidth that
+	 * it might use for other groups/tasks.
+	 */
+	spin_lock(&parent->edf_bandwidth.lock);
+	if (tg_bw && parent)
+		parent->edf_bandwidth.total_bw -=3D tg_bw;
+	spin_unlock(&parent->edf_bandwidth.lock);
+#else
+	spin_lock_irqsave(&task_group_lock, flags);
+#endif
+
 	for_each_possible_cpu(i) {
 		unregister_fair_sched_group(tg, i);
+		unregister_edf_sched_group(tg, i);
 		unregister_rt_sched_group(tg, i);
 	}
+
 	list_del_rcu(&tg->list);
 	list_del_rcu(&tg->siblings);
 	spin_unlock_irqrestore(&task_group_lock, flags);
@@ -10069,14 +10477,6 @@ unsigned long sched_group_shares(struct task_group=
 *tg)
  */
 static DEFINE_MUTEX(rt_constraints_mutex);
=20
-static unsigned long to_ratio(u64 period, u64 runtime)
-{
-	if (runtime =3D=3D RUNTIME_INF)
-		return 1ULL << 20;
-
-	return div64_u64(runtime << 20, period);
-}
-
 /* Must be called with tasklist_lock held */
 static inline int tg_has_rt_tasks(struct task_group *tg)
 {
@@ -10380,9 +10780,15 @@ static int
 cpu_cgroup_can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		      struct task_struct *tsk)
 {
+#if defined(CONFIG_RT_GROUP_SCHED) || defined(CONFIG_EDF_GROUP_SCHED)
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (!sched_rt_can_attach(cgroup_tg(cgrp), tsk))
 		return -EINVAL;
+#endif
+#ifdef CONFIG_EDF_GROUP_SCHED
+	if (!sched_edf_can_attach(cgrp, tsk))
+		return -EINVAL;
+#endif
 #else
 	/* We don't support RT-tasks being in separate groups */
 	if (tsk->sched_class !=3D &fair_sched_class)
@@ -10396,6 +10802,30 @@ static void
 cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			struct cgroup *old_cont, struct task_struct *tsk)
 {
+#ifdef CONFIG_EDF_GROUP_SCHED
+	struct task_group *tg =3D container_of(cgroup_subsys_state(cgrp,
+					     cpu_cgroup_subsys_id),
+					     struct task_group, css);
+	struct task_group *old_tg =3D container_of(cgroup_subsys_state(old_cont,
+						 cpu_cgroup_subsys_id),
+						 struct task_group, css);
+	u64 tsk_bw =3D tsk->edf.bw;
+
+	/*
+	 * An amount of bandwidth equal to the bandwidth of tsk
+	 * is freed in the former group of tsk, and declared occupied
+	 * in the new one.
+	 */
+	spin_lock_irq(&tg->edf_bandwidth.lock);
+	tg->edf_bandwidth.total_bw +=3D tsk_bw;
+	spin_unlock_irq(&tg->edf_bandwidth.lock);
+
+	if (old_tg) {
+		spin_lock_irq(&old_tg->edf_bandwidth.lock);
+		old_tg->edf_bandwidth.total_bw -=3D tsk_bw;
+		spin_unlock_irq(&old_tg->edf_bandwidth.lock);
+	}
+#endif
 	sched_move_task(tsk);
 }
=20
@@ -10438,6 +10868,100 @@ static u64 cpu_rt_period_read_uint(struct cgroup =
*cgrp, struct cftype *cft)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
=20
+#ifdef CONFIG_EDF_GROUP_SCHED
+/*
+ * We allow runtime_max > period, since it makes sense to
+ * assign more than 100% bandwidth to a group, if on an SMP
+ * machine.
+ */
+static int __edf_schedulable(struct task_group *tg,
+			     u64 runtime_max, u64 period)
+{
+	struct task_group *parent =3D tg->parent;
+	u64 old_bw =3D tg->edf_bandwidth.bw;
+	u64 parent_bw =3D parent ? parent->edf_bandwidth.bw : 0;
+	u64 bw =3D period > 0 ? to_ratio(period, runtime_max) : 0;
+	int ret =3D 0;
+
+	if (bw < tg->edf_bandwidth.total_bw)
+		return -EINVAL;
+
+	if (parent) {
+		/*
+		 * All we need to do is check if the parent group is able
+		 * to accomodate the new bandwidth of this group or not,
+		 * given its actual allocated bandwidth, e.g., to other
+		 * groups or tasks.
+		 */
+		if (parent_bw < parent->edf_bandwidth.total_bw -
+		    old_bw + bw)
+			return -EINVAL;
+
+		spin_lock_irq(&parent->edf_bandwidth.lock);
+		parent->edf_bandwidth.total_bw -=3D old_bw;
+		parent->edf_bandwidth.total_bw +=3D bw;
+		spin_unlock_irq(&parent->edf_bandwidth.lock);
+	}
+
+	if (!ret) {
+		spin_lock_irq(&tg->edf_bandwidth.lock);
+		tg->edf_bandwidth.runtime_max =3D runtime_max;
+		tg->edf_bandwidth.period =3D period;
+		tg->edf_bandwidth.bw =3D bw;
+		spin_unlock_irq(&tg->edf_bandwidth.lock);
+	}
+
+	return ret;
+}
+
+static int cpu_edf_runtime_write_uint(struct cgroup *cgrp,
+				      struct cftype *cftype,
+				      u64 edf_runtime_us)
+{
+	struct task_group *tg =3D cgroup_tg(cgrp);
+
+	return __edf_schedulable(tg,
+				 edf_runtime_us * NSEC_PER_USEC,
+				 tg->edf_bandwidth.period);
+}
+
+static u64 cpu_edf_runtime_read_uint(struct cgroup *cgrp, struct cftype *c=
ft)
+{
+	struct task_group *tg =3D cgroup_tg(cgrp);
+	u64 runtime;
+
+	spin_lock_irq(&tg->edf_bandwidth.lock);
+	runtime =3D tg->edf_bandwidth.runtime_max;
+	spin_unlock_irq(&tg->edf_bandwidth.lock);
+	do_div(runtime, NSEC_PER_USEC);
+
+	return runtime;
+}
+
+static int cpu_edf_period_write_uint(struct cgroup *cgrp, struct cftype *c=
ftype,
+		u64 edf_period_us)
+{
+	struct task_group *tg =3D cgroup_tg(cgrp);
+
+	return __edf_schedulable(tg,
+				 tg->edf_bandwidth.runtime_max,
+				 edf_period_us * NSEC_PER_USEC);
+}
+
+static u64 cpu_edf_period_read_uint(struct cgroup *cgrp, struct cftype *cf=
t)
+{
+	struct task_group *tg =3D cgroup_tg(cgrp);
+	u64 period;
+
+	spin_lock_irq(&tg->edf_bandwidth.lock);
+	period =3D tg->edf_bandwidth.period;
+	spin_unlock_irq(&tg->edf_bandwidth.lock);
+	do_div(period, NSEC_PER_USEC);
+
+	return period;
+}
+#endif
+
 static struct cftype cpu_files[] =3D {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
@@ -10458,6 +10982,19 @@ static struct cftype cpu_files[] =3D {
 		.write_u64 =3D cpu_rt_period_write_uint,
 	},
 #endif
+#ifdef CONFIG_EDF_GROUP_SCHED
+	{
+		.name =3D "edf_runtime_us",
+		.read_u64 =3D cpu_edf_runtime_read_uint,
+		.write_u64 =3D cpu_edf_runtime_write_uint,
+	},
+	{
+		.name =3D "edf_period_us",
+		.read_u64 =3D cpu_edf_period_read_uint,
+		.write_u64 =3D cpu_edf_period_write_uint,
+	},
+#endif
+
 };
=20
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *co=
nt)
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index efb8440..1252a43 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -146,7 +146,8 @@ static void print_rq(struct seq_file *m, struct rq *rq,=
 int rq_cpu)
 }
=20
 #if defined(CONFIG_CGROUP_SCHED) && \
-	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
+	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED) || \
+	 defined(CONFIG_EDF_GROUP_SCHED))
 static void task_group_path(struct task_group *tg, char *buf, int buflen)
 {
 	/* may be NULL if the underlying cgroup isn't fully-created yet */
@@ -218,6 +219,38 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct =
cfs_rq *cfs_rq)
 #endif
 }
=20
+void print_edf_rq(struct seq_file *m, int cpu, struct edf_rq *edf_rq)
+{
+	s64 min_deadline =3D -1, max_deadline =3D -1;
+	struct rq *rq =3D &per_cpu(runqueues, cpu);
+	struct sched_edf_entity *last;
+	unsigned long flags;
+
+	SEQ_printf(m, "\nedf_rq[%d]:\n", cpu);
+
+	spin_lock_irqsave(&rq->lock, flags);
+	if (edf_rq->rb_leftmost)
+		min_deadline =3D (rb_entry(edf_rq->rb_leftmost,
+					 struct sched_edf_entity,
+					 rb_node))->deadline;
+	last =3D __pick_edf_last_entity(edf_rq);
+	if (last)
+		max_deadline =3D last->deadline;
+	spin_unlock_irqrestore(&rq->lock, flags);
+
+#define P(x) \
+	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(x))
+#define PN(x) \
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(x))
+
+	P(edf_rq->edf_nr_running);
+	PN(min_deadline);
+	PN(max_deadline);
+
+#undef PN
+#undef P
+}
+
 void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 {
 #if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_RT_GROUP_SCHED)
@@ -300,6 +333,7 @@ static void print_cpu(struct seq_file *m, int cpu)
 #undef P
 #endif
 	print_cfs_stats(m, cpu);
+	print_edf_stats(m, cpu);
 	print_rt_stats(m, cpu);
=20
 	print_rq(m, rq, cpu);
diff --git a/kernel/sched_edf.c b/kernel/sched_edf.c
new file mode 100644
index 0000000..25dde69
--- /dev/null
+++ b/kernel/sched_edf.c
@@ -0,0 +1,548 @@
+/*
+ * Earliest Deadline Firsf (EDF) Scheduling Class (SCHED_EDF policy)
+ *
+ * Earliest Deadline First scheduling for periodic or sporadic tasks.
+ *
+ * An EDF task specifies:
+ *  - a maximum runtime,
+ *  - a period or minimum interarrival time.
+ * The scheduler, on its turn:
+ *  - schedule the task according to its deadline d=3Dt+period,
+ *  - enforces the task to not overcame its bandwidth B=3Druntime_max/peri=
od.
+ *
+ * At the end of each instance of a periodic job (or sporadic activation),
+ * the task may inform the scheduler about such event, by calling
+ * sched_yield(), and then suspending until next activation time.
+ *
+ * The strategy used to confine each task inside its bandwidth reservation
+ * is the Constant Bandwidth Server (CBS) scheduling, a slight variation o=
n
+ * EDF that makes this possible.
+ *
+ * Correct behavior, i.e., no EDF task misses its deadline, is only
+ * guaranteed if the parameters of all the EDF entities in the system are
+ * assigned so to result in a schedulable solution.
+ * However, thanks to bandwidth isolation, overruns and deadline misses
+ * remains local to a single task, and does not affect any other task in
+ * the system.
+ *
+ * Groups, if configured, have bandwidth as well, and it is enforced that
+ * the sum of the bandwidths of entities (tasks and groups) belonging to
+ * a group stays below its own bandwidth.
+ *
+ * Copyright (C) 2009 Dario Faggioli, Michael Trimarchi
+ */
+
+static const struct sched_class edf_sched_class;
+
+static inline struct task_struct *edf_task_of(struct sched_edf_entity *edf=
_se)
+{
+	return container_of(edf_se, struct task_struct, edf);
+}
+
+static inline struct rq *rq_of_edf_rq(struct edf_rq *edf_rq)
+{
+	return container_of(edf_rq, struct rq, edf);
+}
+
+static inline struct edf_rq *edf_rq_of_se(struct sched_edf_entity *edf_se)
+{
+	struct task_struct *p =3D edf_task_of(edf_se);
+	struct rq *rq =3D task_rq(p);
+
+	return &rq->edf;
+}
+
+static inline int edf_se_boosted(struct sched_edf_entity *edf_se)
+{
+	struct task_struct *p =3D edf_task_of(edf_se);
+
+	return p->prio !=3D p->normal_prio;
+}
+
+static inline int on_edf_rq(struct sched_edf_entity *edf_se)
+{
+	return !RB_EMPTY_NODE(&edf_se->rb_node);
+}
+
+#define for_each_leaf_edf_rq(edf_rq, rq) \
+        for (edf_rq =3D &rq->edf; edf_rq; edf_rq =3D NULL)
+
+static inline int edf_time_before(u64 a, u64 b)
+{
+	return (s64)(a - b) < 0;
+}
+
+static inline u64 edf_max_deadline(u64 a, u64 b)
+{
+	s64 delta =3D (s64)(b - a);
+	if (delta > 0)
+		a =3D b;
+
+	return a;
+}
+
+static inline void __edf_new_to_running(struct sched_edf_entity *edf_se)
+{
+	struct edf_rq *edf_rq =3D edf_rq_of_se(edf_se);
+	struct rq *rq =3D rq_of_edf_rq(edf_rq);
+
+	edf_se->edf_flags &=3D ~EDF_NEW;
+	edf_se->edf_flags |=3D EDF_RUNNING;
+
+	edf_se->runtime =3D edf_se->runtime_max;
+	edf_se->deadline =3D rq->clock + edf_se->period;
+}
+
+static void enqueue_edf_entity(struct sched_edf_entity *edf_se);
+static void dequeue_edf_entity(struct sched_edf_entity *edf_se);
+static void check_edf_preempt_curr(struct task_struct *p, struct rq *rq);
+
+static void update_edf_params(struct sched_edf_entity *edf_se)
+{
+	struct edf_rq *edf_rq =3D edf_rq_of_se(edf_se);
+	struct rq *rq =3D rq_of_edf_rq(edf_rq);
+	u64 left, right;
+
+	if (edf_se->edf_flags & EDF_NEW) {
+		__edf_new_to_running(edf_se);
+		return;
+	}
+	if (edf_se->edf_flags & EDF_ENDED) {
+		edf_se->edf_flags &=3D ~EDF_ENDED;
+		edf_se->runtime =3D edf_se->runtime > 0 ? 0 : edf_se->runtime;
+		goto update;
+	}
+
+	if (edf_se->runtime < 0)
+		goto update;
+
+	/*
+	 * Update the deadline to the current time only if:
+	 * - the budget has been completely exhausted;
+	 * - using the ramaining budget, with the current deadline, would
+	 *   make the task exceed its bandwidth;
+	 * - the deadline itself is in the past.
+	 *
+	 * For the second condition to hold, we check if:
+	 *  runtime / (deadline - rq->clock) >=3D runtime_max / period
+	 *
+	 * Which basically says if, in the time left before the current
+	 * deadline, the tasks overcome its expected runtime by using the
+	 * residual budget (left and right are the two sides of the equation,
+	 * after a bit of shuffling to use multiplications instead of
+	 * divisions).
+	 */
+	left =3D edf_se->period * edf_se->runtime;
+	right =3D (edf_se->deadline - rq->clock) * edf_se->runtime_max;
+
+	if (edf_time_before(edf_se->deadline, rq->clock) ||
+	    edf_time_before(right, left)) {
+update:
+		edf_se->deadline =3D max(edf_se->deadline, rq->clock);
+		/*
+		 * Keep moving the deadline and replenishing runtime by the
+		 * proper amount at least until the runtime becomes positive.
+		 */
+		while (edf_se->runtime < 0) {
+			edf_se->deadline +=3D edf_se->period;
+			edf_se->runtime +=3D edf_se->runtime_max;
+		}
+		/*
+		 * Avoid giving the entity more than its maximum runtime,
+		 * which would be wrong!
+		 */
+		if (edf_se->runtime > edf_se->runtime_max)
+			edf_se->runtime =3D edf_se->runtime_max;
+	}
+}
+
+static int start_edf_timer(struct sched_edf_entity *edf_se)
+{
+	struct edf_rq *edf_rq =3D edf_rq_of_se(edf_se);
+	struct rq *rq =3D rq_of_edf_rq(edf_rq);
+	ktime_t now, act;
+	s64 delta;
+
+	act =3D ns_to_ktime(edf_se->deadline);
+	now =3D hrtimer_cb_get_time(&edf_se->edf_timer);
+	delta =3D ktime_to_ns(now) - rq->clock;
+	if (delta < 0)
+		act =3D ktime_sub_ns(act, -delta);
+	else
+		act =3D ktime_add_ns(act, delta);
+
+	hrtimer_set_expires(&edf_se->edf_timer, act);
+
+	hrtimer_start_expires(&edf_se->edf_timer, HRTIMER_MODE_ABS);
+
+	return hrtimer_active(&edf_se->edf_timer);
+}
+
+static enum hrtimer_restart edf_timer(struct hrtimer *timer)
+{
+	struct sched_edf_entity *edf_se =3D container_of(timer,
+						       struct sched_edf_entity,
+						       edf_timer);
+	struct task_struct *p =3D edf_task_of(edf_se);
+	struct edf_rq *edf_rq =3D edf_rq_of_se(edf_se);
+	struct rq *rq =3D rq_of_edf_rq(edf_rq);
+
+	spin_lock(&rq->lock);
+	if (!edf_task(p))
+		goto unlock;
+
+	BUG_ON(on_edf_rq(edf_se));
+
+	edf_se->edf_flags &=3D ~EDF_THROTTLED;
+	if (p->se.on_rq) {
+		update_edf_params(edf_se);
+		enqueue_edf_entity(edf_se);
+		check_edf_preempt_curr(edf_task_of(edf_se), rq);
+	}
+unlock:
+	spin_unlock(&rq->lock);
+
+	return HRTIMER_NORESTART;
+}
+
+static void init_edf_timer(struct hrtimer *timer)
+{
+	if (hrtimer_active(timer)) {
+		hrtimer_try_to_cancel(timer);
+		return;
+	}
+
+	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	timer->function =3D edf_timer;
+}
+
+static int edf_runtime_exceeded(struct sched_edf_entity *edf_se)
+{
+	if (edf_se->runtime > 0 || edf_se_boosted(edf_se))
+		return 0;
+
+	BUG_ON(hrtimer_active(&edf_se->edf_timer));
+
+	dequeue_edf_entity(edf_se);
+	if (!start_edf_timer(edf_se)) {
+		update_edf_params(edf_se);
+		enqueue_edf_entity(edf_se);
+	} else
+		edf_se->edf_flags |=3D EDF_THROTTLED;
+
+	return 1;
+}
+
+static void update_curr_edf(struct rq *rq)
+{
+	struct task_struct *curr =3D rq->curr;
+	struct sched_edf_entity *edf_se =3D &curr->edf;
+	u64 delta_exec;
+
+	if (!edf_task(curr) || !on_edf_rq(edf_se))
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
+	edf_se->runtime -=3D delta_exec;
+	/*
+	 * If we exhausted our runtime it has to be replenished
+	 * either immediately or after one (or more) CBS period(s).
+	 */
+	if (edf_runtime_exceeded(edf_se))
+		resched_task(curr);
+}
+
+static void enqueue_edf_entity(struct sched_edf_entity *edf_se)
+{
+	struct edf_rq *edf_rq =3D edf_rq_of_se(edf_se);
+	struct rb_node **link =3D &edf_rq->rb_root.rb_node;
+	struct rb_node *parent =3D NULL;
+	struct sched_edf_entity *entry;
+	int leftmost =3D 1;
+
+	BUG_ON(!RB_EMPTY_NODE(&edf_se->rb_node));
+
+	while (*link) {
+		parent =3D *link;
+		entry =3D rb_entry(parent, struct sched_edf_entity, rb_node);
+		if (!edf_time_before(entry->deadline, edf_se->deadline))
+			link =3D &parent->rb_left;
+		else {
+			link =3D &parent->rb_right;
+			leftmost =3D 0;
+		}
+	}
+
+	if (leftmost)
+		edf_rq->rb_leftmost =3D &edf_se->rb_node;
+
+	rb_link_node(&edf_se->rb_node, parent, link);
+	rb_insert_color(&edf_se->rb_node, &edf_rq->rb_root);
+
+	edf_rq->edf_nr_running++;
+}
+
+static void dequeue_edf_entity(struct sched_edf_entity *edf_se)
+{
+	struct edf_rq *edf_rq =3D edf_rq_of_se(edf_se);
+
+	if (RB_EMPTY_NODE(&edf_se->rb_node))
+		return;
+
+	if (edf_rq->rb_leftmost =3D=3D &edf_se->rb_node) {
+		struct rb_node *next_node;
+		struct sched_edf_entity *next;
+
+		next_node =3D rb_next(&edf_se->rb_node);
+		edf_rq->rb_leftmost =3D next_node;
+
+		if (next_node)
+			next =3D rb_entry(next_node, struct sched_edf_entity,
+					rb_node);
+	}
+
+	rb_erase(&edf_se->rb_node, &edf_rq->rb_root);
+	RB_CLEAR_NODE(&edf_se->rb_node);
+
+	edf_rq->edf_nr_running--;
+}
+
+static void check_preempt_curr_edf(struct rq *rq, struct task_struct *p,
+				   int sync)
+{
+	if (unlikely(rt_prio(p->prio)))
+		goto resched;
+
+	if (unlikely(p->sched_class !=3D &edf_sched_class))
+		return;
+
+	if (edf_time_before(p->edf.deadline, rq->curr->edf.deadline))
+resched:
+		resched_task(rq->curr);
+}
+
+static void check_edf_preempt_curr(struct task_struct *p, struct rq *rq)
+{
+	if (rt_prio(rq->curr->prio))
+		return;
+
+	if (rq->curr->sched_class !=3D &edf_sched_class ||
+	    edf_time_before(p->edf.deadline, rq->curr->edf.deadline))
+		//if (!task_running(p);
+		resched_task(rq->curr);
+}=09
+
+static void
+enqueue_task_edf(struct rq *rq, struct task_struct *p, int wakeup)
+{
+	struct sched_edf_entity *edf_se =3D &p->edf;
+
+	BUG_ON(on_edf_rq(edf_se));
+
+	/*
+	 * Only enqueue entities with some remaining runtime.
+	 */
+	if (edf_se->edf_flags & EDF_THROTTLED)
+		return;
+
+	update_edf_params(edf_se);
+	enqueue_edf_entity(edf_se);
+}
+
+static void
+dequeue_task_edf(struct rq *rq, struct task_struct *p, int sleep)
+{
+	struct sched_edf_entity *edf_se =3D &p->edf;
+
+	if (!on_edf_rq(edf_se))
+		return;
+
+	update_curr_edf(rq);
+	dequeue_edf_entity(edf_se);
+}
+
+static void yield_task_edf(struct rq *rq)
+{
+	struct task_struct *p =3D rq->curr;
+	struct sched_edf_entity *edf_se =3D &p->edf;
+
+	edf_se->edf_flags |=3D EDF_ENDED;
+}
+
+#ifdef CONFIG_SCHED_HRTICK
+static void start_hrtick_edf(struct rq *rq, struct task_struct *p)
+{
+	struct sched_edf_entity *edf_se =3D &p->edf;
+	s64 delta;
+
+	delta =3D edf_se->runtime_max - edf_se->runtime;
+
+	if (delta > 10000)
+		hrtick_start(rq, delta);
+}
+#else
+static void start_hrtick_edf(struct rq *rq, struct task_struct *p)
+{
+}
+#endif
+
+static struct sched_edf_entity *__pick_edf_last_entity(struct edf_rq *edf_=
rq)
+{
+	struct rb_node *last =3D rb_last(&edf_rq->rb_root);
+
+	if (!last)
+		return NULL;
+
+	return rb_entry(last, struct sched_edf_entity, rb_node);
+}
+
+static struct sched_edf_entity *pick_next_edf_entity(struct rq *rq,
+						     struct edf_rq *edf_rq)
+{
+	struct rb_node *left =3D edf_rq->rb_leftmost;
+
+	if (!left)
+		return NULL;
+
+	return rb_entry(left, struct sched_edf_entity, rb_node);
+}
+
+struct task_struct *pick_next_task_edf(struct rq *rq)
+{
+	struct sched_edf_entity *edf_se;
+	struct edf_rq *edf_rq =3D &rq->edf;
+	struct task_struct *p;
+
+	BUG_ON(edf_rq->edf_nr_running < 0);
+
+	if (!edf_rq->edf_nr_running)
+		return NULL;
+
+	edf_se =3D pick_next_edf_entity(rq, edf_rq);
+	BUG_ON(!edf_se);
+
+	p =3D edf_task_of(edf_se);
+	p->se.exec_start =3D rq->clock;
+#ifdef CONFIG_SCHED_HRTICK
+	if (hrtick_enabled(rq))
+		start_hrtick_edf(rq, p);
+#endif
+	return p;
+}
+
+static void put_prev_task_edf(struct rq *rq, struct task_struct *p)
+{
+	update_curr_edf(rq);
+	p->se.exec_start =3D 0;
+}
+
+static void task_tick_edf(struct rq *rq, struct task_struct *p, int queued=
)
+{
+	update_curr_edf(rq);
+}
+
+static void set_curr_task_edf(struct rq *rq)
+{
+	struct task_struct *p =3D rq->curr;
+
+	p->se.exec_start =3D rq->clock;
+}
+
+static void prio_changed_edf(struct rq *rq, struct task_struct *p,
+			     int oldprio, int running)
+{
+	check_edf_preempt_curr(p, rq);
+}
+
+static void switched_to_edf(struct rq *rq, struct task_struct *p,
+			    int running)
+{
+	check_edf_preempt_curr(p, rq);
+}
+
+#ifdef CONFIG_SMP
+static int select_task_rq_edf(struct task_struct *p, int sd_flag, int flag=
s)
+{
+	return task_cpu(p);
+}
+
+static unsigned long
+load_balance_edf(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		 unsigned long max_load_move,
+		 struct sched_domain *sd, enum cpu_idle_type idle,
+		 int *all_pinned, int *this_best_prio)
+{
+        /* for now, don't touch EDF tasks */
+        return 0;
+}
+
+static int
+move_one_task_edf(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		  struct sched_domain *sd, enum cpu_idle_type idle)
+{
+	return 0;
+}
+
+static void set_cpus_allowed_edf(struct task_struct *p,
+				 const struct cpumask *new_mask)
+{
+	int weight =3D cpumask_weight(new_mask);
+
+	BUG_ON(!edf_task(p));
+
+	cpumask_copy(&p->cpus_allowed, new_mask);
+	p->edf.nr_cpus_allowed =3D weight;
+}
+#endif
+
+static const struct sched_class edf_sched_class =3D {
+	.next			=3D &fair_sched_class,
+	.enqueue_task		=3D enqueue_task_edf,
+	.dequeue_task		=3D dequeue_task_edf,
+	.yield_task		=3D yield_task_edf,
+
+	.check_preempt_curr	=3D check_preempt_curr_edf,
+
+	.pick_next_task		=3D pick_next_task_edf,
+	.put_prev_task		=3D put_prev_task_edf,
+
+#ifdef CONFIG_SMP
+	.select_task_rq		=3D select_task_rq_edf,
+
+	.load_balance           =3D load_balance_edf,
+	.move_one_task		=3D move_one_task_edf,
+	.set_cpus_allowed       =3D set_cpus_allowed_edf,
+#endif
+
+	.set_curr_task		=3D set_curr_task_edf,
+	.task_tick		=3D task_tick_edf,
+
+	.prio_changed           =3D prio_changed_edf,
+	.switched_to		=3D switched_to_edf,
+};
+
+#ifdef CONFIG_SCHED_DEBUG
+void print_edf_rq(struct seq_file *m, int cpu, struct edf_rq *edf_rq);
+
+static void print_edf_stats(struct seq_file *m, int cpu)
+{
+	struct edf_rq *edf_rq =3D &cpu_rq(cpu)->edf;
+
+	rcu_read_lock();
+	for_each_leaf_edf_rq(edf_rq, cpu_rq(cpu))
+		print_edf_rq(m, cpu, edf_rq);
+	rcu_read_unlock();
+}
+#endif /* CONFIG_SCHED_DEBUG */
+
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ecc637a..cae7fb8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1571,10 +1571,8 @@ static void check_preempt_wakeup(struct rq *rq, stru=
ct task_struct *p, int wake_
=20
 	update_curr(cfs_rq);
=20
-	if (unlikely(rt_prio(p->prio))) {
+	if (rt_prio(p->prio) || task_has_edf_policy(p))
 		resched_task(curr);
-		return;
-	}
=20
 	if (unlikely(p->sched_class !=3D &fair_sched_class))
 		return;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a4d790c..4511fc9 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1746,7 +1746,7 @@ unsigned int get_rr_interval_rt(struct task_struct *t=
ask)
 }
=20
 static const struct sched_class rt_sched_class =3D {
-	.next			=3D &fair_sched_class,
+	.next			=3D &edf_sched_class,
 	.enqueue_task		=3D enqueue_task_rt,
 	.dequeue_task		=3D dequeue_task_rt,
 	.yield_task		=3D yield_task_rt,
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_w=
akeup.c
index 26185d7..d32aaf0 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -24,6 +24,7 @@ static int __read_mostly	tracer_enabled;
=20
 static struct task_struct	*wakeup_task;
 static int			wakeup_cpu;
+static int			wakeup_edf;
 static int			wakeup_current_cpu;
 static unsigned			wakeup_prio =3D -1;
 static int			wakeup_rt;
@@ -214,6 +215,9 @@ probe_wakeup(struct rq *rq, struct task_struct *p, int =
success)
 	tracing_record_cmdline(p);
 	tracing_record_cmdline(current);
=20
+	if (wakeup_edf && !edf_task(p))
+		return;
+
 	if ((wakeup_rt && !rt_task(p)) ||
 			p->prio >=3D wakeup_prio ||
 			p->prio >=3D current->prio)
@@ -340,12 +344,21 @@ static int __wakeup_tracer_init(struct trace_array *t=
r)
=20
 static int wakeup_tracer_init(struct trace_array *tr)
 {
+	wakeup_edf =3D 0;
+	wakeup_rt =3D 0;
+	return __wakeup_tracer_init(tr);
+}
+
+static int wakeup_edf_tracer_init(struct trace_array *tr)
+{
+	wakeup_edf =3D 1;
 	wakeup_rt =3D 0;
 	return __wakeup_tracer_init(tr);
 }
=20
 static int wakeup_rt_tracer_init(struct trace_array *tr)
 {
+	wakeup_edf =3D 0;
 	wakeup_rt =3D 1;
 	return __wakeup_tracer_init(tr);
 }
@@ -384,6 +397,20 @@ static struct tracer wakeup_tracer __read_mostly =3D
 #endif
 };
=20
+static struct tracer wakeup_edf_tracer __read_mostly =3D
+{
+	.name		=3D "wakeup_edf",
+	.init		=3D wakeup_edf_tracer_init,
+	.reset		=3D wakeup_tracer_reset,
+	.start		=3D wakeup_tracer_start,
+	.stop		=3D wakeup_tracer_stop,
+	.wait_pipe	=3D poll_wait_pipe,
+	.print_max	=3D 1,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest    =3D trace_selftest_startup_wakeup,
+#endif
+};
+
 static struct tracer wakeup_rt_tracer __read_mostly =3D
 {
 	.name		=3D "wakeup_rt",
@@ -406,6 +433,10 @@ __init static int init_wakeup_tracer(void)
 	if (ret)
 		return ret;
=20
+	ret =3D register_tracer(&wakeup_edf_tracer);
+	if (ret)
+		return ret;
+
 	ret =3D register_tracer(&wakeup_rt_tracer);
 	if (ret)
 		return ret;

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-mI5ep1no9cpGb4+6epdo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq8VokACgkQk4XaBE3IOsTw/wCfbjTvG0pABV9nFPxc3d+/BMRr
1GMAn2Vzs4Kzto6qddoGty051wGPOY8z
=ZVWM
-----END PGP SIGNATURE-----

--=-mI5ep1no9cpGb4+6epdo--


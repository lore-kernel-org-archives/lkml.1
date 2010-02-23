Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0BWBIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:08:52 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36565 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab0BWBFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:05:13 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/21] sched: use lockdep-based checking on rcu_dereference()
Date: Mon, 22 Feb 2010 17:04:50 -0800
Message-Id: <1266887105-1528-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100223010435.GA666@linux.vnet.ibm.com>
References: <20100223010435.GA666@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the rcu_dereference() usages to take advantage of the new
lockdep-based checking.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/cgroup.h |    5 ++++-
 include/linux/cred.h   |    2 +-
 init/main.c            |    2 ++
 kernel/cgroup.c        |   12 ++++++++++++
 kernel/exit.c          |   14 +++++++++++---
 kernel/fork.c          |    1 +
 kernel/notifier.c      |    6 +++---
 kernel/pid.c           |    2 +-
 kernel/sched.c         |   11 ++++++++---
 9 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 0008dee..c9bbcb2 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -28,6 +28,7 @@ struct css_id;
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
 extern void cgroup_lock(void);
+extern int cgroup_lock_is_held(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
 extern void cgroup_fork(struct task_struct *p);
@@ -486,7 +487,9 @@ static inline struct cgroup_subsys_state *cgroup_subsys_state(
 static inline struct cgroup_subsys_state *task_subsys_state(
 	struct task_struct *task, int subsys_id)
 {
-	return rcu_dereference(task->cgroups->subsys[subsys_id]);
+	return rcu_dereference_check(task->cgroups->subsys[subsys_id],
+				     rcu_read_lock_held() ||
+				     cgroup_lock_is_held());
 }
 
 static inline struct cgroup* task_cgroup(struct task_struct *task,
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 4e3387a..4db09f8 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -280,7 +280,7 @@ static inline void put_cred(const struct cred *_cred)
  * task or by holding tasklist_lock to prevent it from being unlinked.
  */
 #define __task_cred(task) \
-	((const struct cred *)(rcu_dereference((task)->real_cred)))
+	((const struct cred *)(rcu_dereference_check((task)->real_cred, rcu_read_lock_held() || lockdep_is_held(&tasklist_lock))))
 
 /**
  * get_task_cred - Get another task's objective credentials
diff --git a/init/main.c b/init/main.c
index dac44a9..ea6280c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -416,7 +416,9 @@ static noinline void __init_refok rest_init(void)
 	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
+	rcu_read_lock();
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
+	rcu_read_unlock();
 	unlock_kernel();
 
 	/*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1fbcc74..1b1373c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -166,6 +166,18 @@ static DEFINE_SPINLOCK(hierarchy_id_lock);
  */
 static int need_forkexit_callback __read_mostly;
 
+#ifdef CONFIG_PROVE_LOCKING
+int cgroup_lock_is_held(void)
+{
+	return lockdep_is_held(&cgroup_mutex);
+}
+#else /* #ifdef CONFIG_PROVE_LOCKING */
+int cgroup_lock_is_held(void)
+{
+	return mutex_is_locked(&cgroup_mutex);
+}
+#endif /* #else #ifdef CONFIG_PROVE_LOCKING */
+
 /* convenient tests for these bits */
 inline int cgroup_is_removed(const struct cgroup *cgrp)
 {
diff --git a/kernel/exit.c b/kernel/exit.c
index 546774a..45ed043 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -85,7 +85,9 @@ static void __exit_signal(struct task_struct *tsk)
 	BUG_ON(!sig);
 	BUG_ON(!atomic_read(&sig->count));
 
-	sighand = rcu_dereference(tsk->sighand);
+	sighand = rcu_dereference_check(tsk->sighand,
+					rcu_read_lock_held() ||
+					lockdep_is_held(&tasklist_lock));
 	spin_lock(&sighand->siglock);
 
 	posix_cpu_timers_exit(tsk);
@@ -170,8 +172,10 @@ void release_task(struct task_struct * p)
 repeat:
 	tracehook_prepare_release_task(p);
 	/* don't need to get the RCU readlock here - the process is dead and
-	 * can't be modifying its own credentials */
+	 * can't be modifying its own credentials. But shut RCU-lockdep up */
+	rcu_read_lock();
 	atomic_dec(&__task_cred(p)->user->processes);
+	rcu_read_unlock();
 
 	proc_flush_task(p);
 
@@ -473,9 +477,11 @@ static void close_files(struct files_struct * files)
 	/*
 	 * It is safe to dereference the fd table without RCU or
 	 * ->file_lock because this is the last reference to the
-	 * files structure.
+	 * files structure.  But use RCU to shut RCU-lockdep up.
 	 */
+	rcu_read_lock();
 	fdt = files_fdtable(files);
+	rcu_read_unlock();
 	for (;;) {
 		unsigned long set;
 		i = j * __NFDBITS;
@@ -521,10 +527,12 @@ void put_files_struct(struct files_struct *files)
 		 * at the end of the RCU grace period. Otherwise,
 		 * you can free files immediately.
 		 */
+		rcu_read_lock();
 		fdt = files_fdtable(files);
 		if (fdt != &files->fdtab)
 			kmem_cache_free(files_cachep, files);
 		free_fdtable(fdt);
+		rcu_read_unlock();
 	}
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 5b2959b..e01ec3e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -86,6 +86,7 @@ int max_threads;		/* tunable limit on nr_threads */
 DEFINE_PER_CPU(unsigned long, process_counts) = 0;
 
 __cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
+EXPORT_SYMBOL_GPL(tasklist_lock);
 
 int nr_processes(void)
 {
diff --git a/kernel/notifier.c b/kernel/notifier.c
index acd24e7..2488ba7 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -78,10 +78,10 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
 	int ret = NOTIFY_DONE;
 	struct notifier_block *nb, *next_nb;
 
-	nb = rcu_dereference(*nl);
+	nb = rcu_dereference_raw(*nl);
 
 	while (nb && nr_to_call) {
-		next_nb = rcu_dereference(nb->next);
+		next_nb = rcu_dereference_raw(nb->next);
 
 #ifdef CONFIG_DEBUG_NOTIFIERS
 		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
@@ -309,7 +309,7 @@ int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 	 * racy then it does not matter what the result of the test
 	 * is, we re-check the list after having taken the lock anyway:
 	 */
-	if (rcu_dereference(nh->head)) {
+	if (rcu_dereference_raw(nh->head)) {
 		down_read(&nh->rwsem);
 		ret = notifier_call_chain(&nh->head, val, v, nr_to_call,
 					nr_calls);
diff --git a/kernel/pid.c b/kernel/pid.c
index 2e17c9c..b08e697 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -367,7 +367,7 @@ struct task_struct *pid_task(struct pid *pid, enum pid_type type)
 	struct task_struct *result = NULL;
 	if (pid) {
 		struct hlist_node *first;
-		first = rcu_dereference(pid->tasks[type].first);
+		first = rcu_dereference_check(pid->tasks[type].first, rcu_read_lock_held() || lockdep_is_held(&tasklist_lock));
 		if (first)
 			result = hlist_entry(first, struct task_struct, pids[(type)].node);
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index c535cc4..ad419d9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -645,6 +645,11 @@ static inline int cpu_of(struct rq *rq)
 #endif
 }
 
+#define for_each_domain_rd(p) \
+	rcu_dereference_check((p), \
+			      rcu_read_lock_sched_held() || \
+			      lockdep_is_held(&sched_domains_mutex))
+
 /*
  * The domain tree (rq->sd) is protected by RCU's quiescent state transition.
  * See detach_destroy_domains: synchronize_sched for details.
@@ -653,7 +658,7 @@ static inline int cpu_of(struct rq *rq)
  * preempt-disabled sections.
  */
 #define for_each_domain(cpu, __sd) \
-	for (__sd = rcu_dereference(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
+	for (__sd = for_each_domain_rd(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
 
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
 #define this_rq()		(&__get_cpu_var(runqueues))
@@ -1531,7 +1536,7 @@ static unsigned long target_load(int cpu, int type)
 
 static struct sched_group *group_of(int cpu)
 {
-	struct sched_domain *sd = rcu_dereference(cpu_rq(cpu)->sd);
+	struct sched_domain *sd = rcu_dereference_sched(cpu_rq(cpu)->sd);
 
 	if (!sd)
 		return NULL;
@@ -4877,7 +4882,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 
 static inline int on_null_domain(int cpu)
 {
-	return !rcu_dereference(cpu_rq(cpu)->sd);
+	return !rcu_dereference_sched(cpu_rq(cpu)->sd);
 }
 
 /*
-- 
1.6.6


Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0AECFo (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 4 Jan 2010 21:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264Ab0AECET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:04:19 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55605 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab0AECEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:04:14 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/8] sched: use lockdep-based checking on rcu_dereference()
Date: Mon,  4 Jan 2010 18:04:08 -0800
Message-Id: <12626570513684-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20100105020345.GA32114@linux.vnet.ibm.com>
References: <20100105020345.GA32114@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Update the rcu_dereference() usages to take advantage of the new
lockdep-based checking.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/cgroup.h |    2 +-
 include/linux/cred.h   |    2 +-
 init/main.c            |    2 ++
 kernel/exit.c          |   14 +++++++++++---
 kernel/fork.c          |    1 +
 kernel/notifier.c      |    6 +++---
 kernel/pid.c           |    2 +-
 kernel/sched.c         |    6 +++---
 8 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 0008dee..d4c95c9 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -486,7 +486,7 @@ static inline struct cgroup_subsys_state *cgroup_subsys_state(
 static inline struct cgroup_subsys_state *task_subsys_state(
 	struct task_struct *task, int subsys_id)
 {
-	return rcu_dereference(task->cgroups->subsys[subsys_id]);
+	return rcu_dereference_sched(task->cgroups->subsys[subsys_id]);
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
index 5988deb..ae2338e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -427,7 +427,9 @@ static noinline void __init_refok rest_init(void)
 	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
+	rcu_read_lock();
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
+	rcu_read_unlock();
 	unlock_kernel();
 
 	/*
diff --git a/kernel/exit.c b/kernel/exit.c
index e61891f..ddc7cfe 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -84,7 +84,9 @@ static void __exit_signal(struct task_struct *tsk)
 	BUG_ON(!sig);
 	BUG_ON(!atomic_read(&sig->count));
 
-	sighand = rcu_dereference(tsk->sighand);
+	sighand = rcu_dereference_check(tsk->sighand,
+					rcu_read_lock_held() ||
+					lock_is_held(&tasklist_lock));
 	spin_lock(&sighand->siglock);
 
 	posix_cpu_timers_exit(tsk);
@@ -169,8 +171,10 @@ void release_task(struct task_struct * p)
 repeat:
 	tracehook_prepare_release_task(p);
 	/* don't need to get the RCU readlock here - the process is dead and
-	 * can't be modifying its own credentials */
+	 * can't be modifying its own credentials. But shut RCU-lockdep up */
+	rcu_read_lock();
 	atomic_dec(&__task_cred(p)->user->processes);
+	rcu_read_unlock();
 
 	proc_flush_task(p);
 
@@ -474,9 +478,11 @@ static void close_files(struct files_struct * files)
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
@@ -522,10 +528,12 @@ void put_files_struct(struct files_struct *files)
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
index 4c20fff..545e024 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -85,6 +85,7 @@ int max_threads;		/* tunable limit on nr_threads */
 DEFINE_PER_CPU(unsigned long, process_counts) = 0;
 
 __cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
+EXPORT_SYMBOL_GPL(tasklist_lock);
 
 int nr_processes(void)
 {
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 61d5aa5..fea84bc 100644
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
index d3f722d..3a39e0a 100644
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
index e69fee4..1fd1c63 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -652,7 +652,7 @@ static inline int cpu_of(struct rq *rq)
  * preempt-disabled sections.
  */
 #define for_each_domain(cpu, __sd) \
-	for (__sd = rcu_dereference(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
+	for (__sd = rcu_dereference_sched(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
 
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
 #define this_rq()		(&__get_cpu_var(runqueues))
@@ -1528,7 +1528,7 @@ static unsigned long target_load(int cpu, int type)
 
 static struct sched_group *group_of(int cpu)
 {
-	struct sched_domain *sd = rcu_dereference(cpu_rq(cpu)->sd);
+	struct sched_domain *sd = rcu_dereference_sched(cpu_rq(cpu)->sd);
 
 	if (!sd)
 		return NULL;
@@ -4813,7 +4813,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 
 static inline int on_null_domain(int cpu)
 {
-	return !rcu_dereference(cpu_rq(cpu)->sd);
+	return !rcu_dereference_sched(cpu_rq(cpu)->sd);
 }
 
 /*
-- 
1.5.2.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936030Ab0COJMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 05:12:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935997Ab0COJM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 05:12:29 -0400
Date: Mon, 15 Mar 2010 10:10:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Ben Blum <bblum@google.com>, Jiri Slaby <jirislaby@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] make select_fallback_rq() cpuset friendly
Message-ID: <20100315091027.GA9155@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce cpuset_cpus_allowed_fallback() helper to fix the cpuset problems
with select_fallback_rq(). It can be called from any context and can't use
any cpuset locks including task_lock(). It is called when the task doesn't
have online cpus in ->cpus_allowed but ttwu/etc must be able to find a
suitable cpu.

I am not proud of this patch. Everything which needs such a fact comment
can't be good even if correct. But I'd prefer to not change the locking
rules in the code I hardly understand, and in any case I believe this
simple change make the code much more correct compared to deadlocks we
currently have.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/cpuset.h |    7 +++++++
 kernel/sched.c         |    4 +---
 kernel/cpuset.c        |   42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 3 deletions(-)

--- 34-rc1/include/linux/cpuset.h~6_FALLBACK_CPUSETS	2010-03-15 09:40:16.000000000 +0100
+++ 34-rc1/include/linux/cpuset.h	2010-03-15 09:42:08.000000000 +0100
@@ -21,6 +21,7 @@ extern int number_of_cpusets;	/* How man
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
+extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -101,6 +102,12 @@ static inline void cpuset_cpus_allowed(s
 	cpumask_copy(mask, cpu_possible_mask);
 }
 
+static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
+{
+	cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
+	return cpumask_any(cpu_active_mask);
+}
+
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 {
 	return node_possible_map;
--- 34-rc1/kernel/sched.c~6_FALLBACK_CPUSETS	2010-03-15 09:41:51.000000000 +0100
+++ 34-rc1/kernel/sched.c	2010-03-15 09:42:08.000000000 +0100
@@ -2292,9 +2292,7 @@ static int select_fallback_rq(int cpu, s
 
 	/* No more Mr. Nice Guy. */
 	if (unlikely(dest_cpu >= nr_cpu_ids)) {
-		cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
-		dest_cpu = cpumask_any(cpu_active_mask);
-
+		dest_cpu = cpuset_cpus_allowed_fallback(p);
 		/*
 		 * Don't tell them about moving exiting tasks or
 		 * kernel threads (both mm NULL), since they never
--- 34-rc1/kernel/cpuset.c~6_FALLBACK_CPUSETS	2010-03-15 09:40:16.000000000 +0100
+++ 34-rc1/kernel/cpuset.c	2010-03-15 09:42:08.000000000 +0100
@@ -2146,6 +2146,48 @@ void cpuset_cpus_allowed(struct task_str
 	mutex_unlock(&callback_mutex);
 }
 
+int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
+{
+	const struct cpuset *cs;
+	int cpu;
+
+	rcu_read_lock();
+	cs = task_cs(tsk);
+	if (cs)
+		cpumask_copy(&tsk->cpus_allowed, cs->cpus_allowed);
+	rcu_read_unlock();
+
+	/*
+	 * We own tsk->cpus_allowed, nobody can change it under us.
+	 *
+	 * But we used cs && cs->cpus_allowed lockless and thus can
+	 * race with cgroup_attach_task() or update_cpumask() and get
+	 * the wrong tsk->cpus_allowed. However, both cases imply the
+	 * subsequent cpuset_change_cpumask()->set_cpus_allowed_ptr()
+	 * which takes task_rq_lock().
+	 *
+	 * If we are called after it dropped the lock we must see all
+	 * changes in tsk_cs()->cpus_allowed. Otherwise we can temporary
+	 * set any mask even if it is not right from task_cs() pov,
+	 * the pending set_cpus_allowed_ptr() will fix things.
+	 */
+
+	cpu = cpumask_any_and(&tsk->cpus_allowed, cpu_active_mask);
+	if (cpu >= nr_cpu_ids) {
+		/*
+		 * Either tsk->cpus_allowed is wrong (see above) or it
+		 * is actually empty. The latter case is only possible
+		 * if we are racing with remove_tasks_in_empty_cpuset().
+		 * Like above we can temporary set any mask and rely on
+		 * set_cpus_allowed_ptr() as synchronization point.
+		 */
+		cpumask_copy(&tsk->cpus_allowed, cpu_possible_mask);
+		cpu = cpumask_any(cpu_active_mask);
+	}
+
+	return cpu;
+}
+
 void cpuset_init_current_mems_allowed(void)
 {
 	nodes_setall(current->mems_allowed);


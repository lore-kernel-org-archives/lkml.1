Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab0CCPrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:47:15 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48887 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab0CCPrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:47:11 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@lst.de>
Subject: [PATCH tip/core/rcu 1/4] rcu: use wrapper function instead of exporting tasklist_lock
Date: Wed,  3 Mar 2010 07:46:56 -0800
Message-Id: <1267631219-8713-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100303154638.GA8576@linux.vnet.ibm.com>
References: <20100303154638.GA8576@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lockdep-RCU commit d11c563d exported tasklist_lock, which is not a good
thing.  This patch instead exports a function that uses lockdep to check
whether tasklist_lock is held.

Suggested-by: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/cred.h  |    2 +-
 include/linux/sched.h |    4 ++++
 kernel/exit.c         |    2 +-
 kernel/fork.c         |    9 ++++++++-
 kernel/pid.c          |    4 +++-
 5 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 4db09f8..52507c3 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -280,7 +280,7 @@ static inline void put_cred(const struct cred *_cred)
  * task or by holding tasklist_lock to prevent it from being unlinked.
  */
 #define __task_cred(task) \
-	((const struct cred *)(rcu_dereference_check((task)->real_cred, rcu_read_lock_held() || lockdep_is_held(&tasklist_lock))))
+	((const struct cred *)(rcu_dereference_check((task)->real_cred, rcu_read_lock_held() || lockdep_tasklist_lock_is_held())))
 
 /**
  * get_task_cred - Get another task's objective credentials
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0eef87b..a47af20 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -258,6 +258,10 @@ extern spinlock_t mmlist_lock;
 
 struct task_struct;
 
+#ifdef CONFIG_PROVE_RCU
+extern int lockdep_tasklist_lock_is_held(void);
+#endif /* #ifdef CONFIG_PROVE_RCU */
+
 extern void sched_init(void);
 extern void sched_init_smp(void);
 extern asmlinkage void schedule_tail(struct task_struct *prev);
diff --git a/kernel/exit.c b/kernel/exit.c
index 45ed043..fed3a4d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -87,7 +87,7 @@ static void __exit_signal(struct task_struct *tsk)
 
 	sighand = rcu_dereference_check(tsk->sighand,
 					rcu_read_lock_held() ||
-					lockdep_is_held(&tasklist_lock));
+					lockdep_tasklist_lock_is_held());
 	spin_lock(&sighand->siglock);
 
 	posix_cpu_timers_exit(tsk);
diff --git a/kernel/fork.c b/kernel/fork.c
index 17bbf09..8691c54 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -86,7 +86,14 @@ int max_threads;		/* tunable limit on nr_threads */
 DEFINE_PER_CPU(unsigned long, process_counts) = 0;
 
 __cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
-EXPORT_SYMBOL_GPL(tasklist_lock);
+
+#ifdef CONFIG_PROVE_RCU
+int lockdep_tasklist_lock_is_held(void)
+{
+	return lockdep_is_held(&tasklist_lock);
+}
+EXPORT_SYMBOL_GPL(lockdep_tasklist_lock_is_held);
+#endif /* #ifdef CONFIG_PROVE_RCU */
 
 int nr_processes(void)
 {
diff --git a/kernel/pid.c b/kernel/pid.c
index b08e697..b606440 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -367,7 +367,9 @@ struct task_struct *pid_task(struct pid *pid, enum pid_type type)
 	struct task_struct *result = NULL;
 	if (pid) {
 		struct hlist_node *first;
-		first = rcu_dereference_check(pid->tasks[type].first, rcu_read_lock_held() || lockdep_is_held(&tasklist_lock));
+		first = rcu_dereference_check(pid->tasks[type].first,
+					      rcu_read_lock_held() ||
+					      lockdep_tasklist_lock_is_held());
 		if (first)
 			result = hlist_entry(first, struct task_struct, pids[(type)].node);
 	}
-- 
1.6.6


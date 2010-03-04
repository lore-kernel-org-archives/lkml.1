Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab0CDQcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:32:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:48462 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575Ab0CDQcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:32:21 -0500
Date: Thu, 4 Mar 2010 16:31:45 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, hch@lst.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, hch@lst.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1267631219-8713-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267631219-8713-1-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Use wrapper function instead of exporting tasklist_lock
Message-ID: <tip-db1466b3e1bd1727375cdbfcbea4bcce2f860f61@git.kernel.org>
Git-Commit-ID: db1466b3e1bd1727375cdbfcbea4bcce2f860f61
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Mar 2010 16:31:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db1466b3e1bd1727375cdbfcbea4bcce2f860f61
Gitweb:     http://git.kernel.org/tip/db1466b3e1bd1727375cdbfcbea4bcce2f860f61
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 3 Mar 2010 07:46:56 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Mar 2010 11:46:14 +0100

rcu: Use wrapper function instead of exporting tasklist_lock

Lockdep-RCU commit d11c563d exported tasklist_lock, which is not
a good thing.  This patch instead exports a function that uses
lockdep to check whether tasklist_lock is held.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: Christoph Hellwig <hch@lst.de>
LKML-Reference: <1267631219-8713-1-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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

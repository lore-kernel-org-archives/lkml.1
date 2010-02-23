Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0BWBFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:05:23 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36562 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab0BWBFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:05:13 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/21] rcu: integrate rcu_dereference_check() message into lockdep
Date: Mon, 22 Feb 2010 17:04:47 -0800
Message-Id: <1266887105-1528-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100223010435.GA666@linux.vnet.ibm.com>
References: <20100223010435.GA666@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make rcu_dereference_check() print the list of held locks in addition
to the stack dump to ease debugging.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/lockdep.h  |    4 ++++
 include/linux/rcupdate.h |    4 ++--
 kernel/lockdep.c         |   18 ++++++++++++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 9ccf0e2..10206a8 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -534,4 +534,8 @@ do {									\
 # define might_lock_read(lock) do { } while (0)
 #endif
 
+#ifdef CONFIG_PROVE_RCU
+extern void lockdep_rcu_dereference(const char *file, const int line);
+#endif
+
 #endif /* __LINUX_LOCKDEP_H */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 839d296..1a4de31 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -182,8 +182,8 @@ static inline int rcu_read_lock_sched_held(void)
  */
 #define rcu_dereference_check(p, c) \
 	({ \
-		if (debug_locks) \
-			WARN_ON_ONCE(!(c)); \
+		if (debug_locks && !(c)) \
+			lockdep_rcu_dereference(__FILE__, __LINE__); \
 		rcu_dereference_raw(p); \
 	})
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 5feaddc..a44c1b2 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3809,3 +3809,21 @@ void lockdep_sys_exit(void)
 		lockdep_print_held_locks(curr);
 	}
 }
+
+void lockdep_rcu_dereference(const char *file, const int line)
+{
+	struct task_struct *curr = current;
+
+	if (!debug_locks_off())
+		return;
+	printk("\n==============================================\n");
+	printk(  "[ BUG: Unsafe rcu_dereference_check() usage! ]\n");
+	printk(  "----------------------------------------------\n");
+	printk("%s:%d invoked rcu_dereference_check() without protection!\n",
+			file, line);
+	printk("\nother info that might help us debug this:\n\n");
+	lockdep_print_held_locks(curr);
+	printk("\nstack backtrace:\n");
+	dump_stack();
+}
+EXPORT_SYMBOL_GPL(lockdep_rcu_dereference);
-- 
1.6.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab0BYKMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:12:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:40844 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498Ab0BYKM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:12:27 -0500
Date: Thu, 25 Feb 2010 10:09:48 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1266887105-1528-3-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1266887105-1528-3-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Integrate rcu_dereference_check() message into lockdep
Message-ID: <tip-0632eb3d7563d6a76d49a3860b6352d800c92854@git.kernel.org>
Git-Commit-ID: 0632eb3d7563d6a76d49a3860b6352d800c92854
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:09:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0632eb3d7563d6a76d49a3860b6352d800c92854
Gitweb:     http://git.kernel.org/tip/0632eb3d7563d6a76d49a3860b6352d800c92854
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 22 Feb 2010 17:04:47 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 09:41:01 +0100

rcu: Integrate rcu_dereference_check() message into lockdep

Make rcu_dereference_check() print the list of held locks in
addition to the stack dump to ease debugging.

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
LKML-Reference: <1266887105-1528-3-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index c62ec14..672c436 100644
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

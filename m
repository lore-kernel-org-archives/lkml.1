Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186AbZLOXOg (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 15 Dec 2009 18:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761599AbZLOXOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:14:23 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36474 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762190AbZLOXCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:02:46 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 14/18] rcu: lockdep check for exiting to user space as RCU reader
Date: Tue, 15 Dec 2009 15:02:37 -0800
Message-Id: <12609181612244-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091215230213.GA9093@linux.vnet.ibm.com>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Proposed for 2.6.34, not for inclusion.

It is illegal to return to user-space execution while running within an
RCU read-side critical section.  It turns out that CONFIG_TREE_PREEMPT_RCU
has enough information lying around to detect this, so add the checks
to lockdep (CONFIG_PROVE_LOCKING).

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutiny.h |    4 ++++
 include/linux/rcutree.h |    1 +
 kernel/lockdep.c        |   10 ++++++++++
 kernel/rcutree_plugin.h |   22 ++++++++++++++++++++++
 4 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index b524590..c32b16d 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -29,6 +29,10 @@
 
 void rcu_sched_qs(int cpu);
 void rcu_bh_qs(int cpu);
+static inline int rcu_read_lock_held(void)
+{
+	return 0;
+}
 
 #define __rcu_read_lock()	preempt_disable()
 #define __rcu_read_unlock()	preempt_enable()
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 564a025..8cd4ac1 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -37,6 +37,7 @@ extern void rcu_bh_qs(int cpu);
 extern int rcu_needs_cpu(int cpu);
 extern void rcu_scheduler_starting(void);
 extern int rcu_expedited_torture_stats(char *page);
+extern int rcu_read_lock_held(void);
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 9af5672..a912634 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3799,4 +3799,14 @@ void lockdep_sys_exit(void)
 				curr->comm, curr->pid);
 		lockdep_print_held_locks(curr);
 	}
+	if (unlikely(rcu_read_lock_held())) {
+		if (!debug_locks_off())
+			return;
+		printk("\n================================================\n");
+		printk(  "[ BUG: returning to user space as RCU reader!  ]\n");
+		printk(  "------------------------------------------------\n");
+		printk("%s/%d is leaving the kernel as RCU reader!\n",
+				curr->comm, curr->pid);
+		lockdep_print_held_locks(curr);
+	}
 }
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index e77cdf3..f6258ae 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -310,6 +310,18 @@ void __rcu_read_unlock(void)
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
+/*
+ * Return 1 if the current task is provably within an RCU read-side
+ * critical section.  The bit about checking a running task to see if
+ * it is blocked is a bit strange, but keep in mind that sleep and
+ * wakeup are not atomic operations.
+ */
+int rcu_read_lock_held(void)
+{
+	return ACCESS_ONCE(current->rcu_read_lock_nesting) != 0 ||
+	       (current->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED);
+}
+
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
 /*
@@ -761,6 +773,16 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
+/*
+ * Return 1 if the current task is provably within an RCU read-side
+ * critical section.  But without preemptible RCU, we never can be
+ * sure, so always return 0.
+ */
+int rcu_read_lock_held(void)
+{
+	return 0;
+}
+
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
 /*
-- 
1.5.2.5


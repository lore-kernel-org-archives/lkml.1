Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZCGK4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZCGK4m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 05:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbZCGK4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 05:56:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49882 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbZCGK4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 05:56:18 -0500
Message-ID: <49B2526C.5070503@cn.fujitsu.com>
Date: Sat, 07 Mar 2009 18:54:36 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu_barrier VS cpu_hotplug: make rcu_barrier can be called
 on CPU_DEAD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cpu hotplug notifier_call for CPU_DEAD are very complex, some notifier_call
may call rcu_barrier(), if this notifier_call is called earlier than
rcu_cpu_notify(), it is buggy.

_cpu_down() -->
	some_cpu_hotplug_notify() -->
		case CPU_DEAD: rcu_barrier()
	rcu_cpu_notify() -->
		rcu_offline_cpu()

When rcu_barrier() is called, rcu_barrier() does not know how to finish
his work: rcu callbacks in dead cpu have not been migrated to online cpu,
so rcu_barrier() cannot wait for these rcu callbacks, but rcu_barrier()
should wait for all queued rcu callbacks.

This patch ensure that rcu_cpu_notify() is called earlier than 
any other notifier_call.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index b86fa2f..f7ae5a3 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -238,6 +238,12 @@ static inline int notifier_to_errno(int ret)
 #define CPU_DYING_FROZEN	(CPU_DYING | CPU_TASKS_FROZEN)
 #define CPU_STARTING_FROZEN	(CPU_STARTING | CPU_TASKS_FROZEN)
 
+/* Register at highest priority so that task migration (migrate_all_tasks)
+ * and rcu callbacks migration happens before everything else.
+ */
+#define CPUHOTPLUG_TASK_MIGRATE_PRIORITY	10
+#define CPUHOTPLUG_RCU_MIGRATE_PRIORITY		11
+
 /* Hibernation and suspend events */
 #define PM_HIBERNATION_PREPARE	0x0001 /* Going to hibernate */
 #define PM_POST_HIBERNATION	0x0002 /* Hibernation finished */
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 654c640..040b894 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -764,6 +764,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 
 static struct notifier_block __cpuinitdata rcu_nb = {
 	.notifier_call	= rcu_cpu_notify,
+	.priority	= CPUHOTPLUG_RCU_MIGRATE_PRIORITY,
 };
 
 /*
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 5d59e85..8ffcbf0 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1407,6 +1407,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 
 static struct notifier_block __cpuinitdata rcu_nb = {
 	.notifier_call = rcu_cpu_notify,
+	.priority = CPUHOTPLUG_RCU_MIGRATE_PRIORITY,
 };
 
 void __init __rcu_init(void)
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 97ce315..fcef06c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1503,6 +1503,7 @@ do { \
 
 static struct notifier_block __cpuinitdata rcu_nb = {
 	.notifier_call	= rcu_cpu_notify,
+	.priority	= CPUHOTPLUG_RCU_MIGRATE_PRIORITY,
 };
 
 void __init __rcu_init(void)
diff --git a/kernel/sched.c b/kernel/sched.c
index 8e2558c..56f225e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6740,12 +6740,9 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
-/* Register at highest priority so that task migration (migrate_all_tasks)
- * happens before everything else.
- */
 static struct notifier_block __cpuinitdata migration_notifier = {
 	.notifier_call = migration_call,
-	.priority = 10
+	.priority = CPUHOTPLUG_TASK_MIGRATE_PRIORITY,
 };
 
 static int __init migration_init(void)


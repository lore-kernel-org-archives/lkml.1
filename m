Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbYB0WdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbYB0WdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbYB0Wc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:32:57 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:60039 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYB0Wc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:32:56 -0500
Message-Id: <20080227222542.826578000@chello.nl>
References: <20080227222103.673194000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 27 Feb 2008 23:21:07 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, Max Krasnyanskiy <maxk@qualcomm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 4/4] kthread: system set kthread affinities
Content-Disposition: inline; filename=cpuset-system-kthread.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep the affinities of unbound kthreads within the system set.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/kthread.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/kthread.c
===================================================================
--- linux-2.6.orig/kernel/kthread.c
+++ linux-2.6/kernel/kthread.c
@@ -13,6 +13,8 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/cpumask.h>
+#include <linux/cpuset.h>
 #include <asm/semaphore.h>
 
 #define KTHREAD_NICE_LEVEL (-5)
@@ -107,7 +109,7 @@ static void create_kthread(struct kthrea
 		 */
 		sched_setscheduler(create->result, SCHED_NORMAL, &param);
 		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed(create->result, CPU_MASK_ALL);
+		set_cpus_allowed(create->result, cpu_system_map);
 	}
 	complete(&create->done);
 }
@@ -232,7 +234,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
-	set_cpus_allowed(tsk, CPU_MASK_ALL);
+	set_cpus_allowed(tsk, cpu_system_map);
 
 	current->flags |= PF_NOFREEZE;
 
@@ -260,3 +262,47 @@ int kthreadd(void *unused)
 
 	return 0;
 }
+
+#ifdef CONFIG_CPUSETS
+static int system_kthread_notifier(struct notifier_block *nb,
+		unsigned long action, void *cpus)
+{
+	cpumask_t *new_system_map = (cpumask_t *)cpus;
+	struct task_struct *g, *t;
+
+again:
+	rcu_read_lock();
+	do_each_thread(g, t) {
+		if (t->parent != kthreadd_task && t != kthreadd_task)
+			continue;
+
+		if (cpus_match_system(t->cpus_allowed) &&
+		    !cpus_equal(t->cpus_allowed, *new_system_map)) {
+			/*
+			 * What is holding a ref on t->usage here?!
+			 */
+			get_task_struct(t);
+			rcu_read_unlock();
+			set_cpus_allowed(t, *new_system_map);
+			put_task_struct(t);
+			goto again;
+		}
+	} while_each_thread(g, t);
+	rcu_read_unlock();
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block fn_system_kthread_notifier = {
+	.notifier_call = system_kthread_notifier,
+};
+
+static int __init init_kthread(void)
+{
+	blocking_notifier_chain_register(&system_map_notifier,
+			&fn_system_kthread_notifier);
+	return 0;
+}
+
+module_init(init_kthread);
+#endif

--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbZKSJA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbZKSJA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 04:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbZKSJA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 04:00:56 -0500
Received: from ozlabs.org ([203.10.76.45]:46583 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409AbZKSJAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 04:00:55 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911191930.59400.rusty@rustcorp.com.au>
Date: Thu, 19 Nov 2009 19:30:59 +1030
Subject: [PATCH 3/6] cpumask: truncate task_struct.cpus_allowed for CONFIG_CPUMASK_OFFSTACK
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turns cpus_allowed into a bitmap, and truncate it to nr_cpu_ids if
CONFIG_CPUMASK_OFFSTACK is set.

I do this rather than the classic [0] dangling array trick, because of
INIT_TASK and references to sizeof(struct task_struct).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/init_task.h |    2 +-
 include/linux/sched.h     |    7 +++++--
 kernel/fork.c             |   19 ++++++++++++++++++-
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -130,7 +130,7 @@ extern struct cred init_cred;
 	.static_prio	= MAX_PRIO-20,					\
 	.normal_prio	= MAX_PRIO-20,					\
 	.policy		= SCHED_NORMAL,					\
-	.cpus_allowed	= CPU_MASK_ALL,					\
+	.cpus_allowed	= CPU_BITS_ALL,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
 	.se		= {						\
diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1256,7 +1256,6 @@ struct task_struct {
 #endif
 
 	unsigned int policy;
-	cpumask_t cpus_allowed;
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	int rcu_read_lock_nesting;
@@ -1544,10 +1543,14 @@ struct task_struct {
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
 	unsigned long stack_start;
+
+	/* This has to go at the end: if CONFIG_CPUMASK_OFFSTACK=y, only
+	 * nr_cpu_ids bits will actually be allocated. */
+	DECLARE_BITMAP(cpus_allowed, CONFIG_NR_CPUS);
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
-#define tsk_cpumask(tsk) (&(tsk)->cpus_allowed)
+#define tsk_cpumask(tsk) (to_cpumask((tsk)->cpus_allowed))
 
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -183,9 +183,26 @@ void __init fork_init(unsigned long memp
 #ifndef ARCH_MIN_TASKALIGN
 #define ARCH_MIN_TASKALIGN	L1_CACHE_BYTES
 #endif
+	unsigned int task_size;
+
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	/*
+	 * Restrict task_struct allocations so cpus_allowed is only
+	 * nr_cpu_ids long.  cpus_allowed must be a NR_CPUS bitmap at
+	 * end for this to work.
+	 */
+	BUILD_BUG_ON(offsetof(struct task_struct, cpus_allowed)
+		     + BITS_TO_LONGS(CONFIG_NR_CPUS)*sizeof(long)
+		     != sizeof(struct task_struct));
+	task_size = offsetof(struct task_struct, cpus_allowed) +
+		BITS_TO_LONGS(nr_cpu_ids) * sizeof(long);
+#else
+	task_size = sizeof(struct task_struct);
+#endif /* CONFIG_CPUMASK_OFFSTACK */
+
 	/* create a slab on which task_structs can be allocated */
 	task_struct_cachep =
-		kmem_cache_create("task_struct", sizeof(struct task_struct),
+		kmem_cache_create("task_struct", task_size,
 			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
 #endif
 


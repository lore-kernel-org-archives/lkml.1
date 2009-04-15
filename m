Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbZDODVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbZDODVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZDODVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:21:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52064 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbZDODVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:21:13 -0400
Message-ID: <49E5521E.5010105@cn.fujitsu.com>
Date: Wed, 15 Apr 2009 11:18:54 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] rcupdate: use struct ref_completion
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Cleanup

The comment in _rcu_barrier() is a little mysterious,
this fix uses the generic waiting-multi-events APIs instead.


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 2c7b845..82f1dc4 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -53,9 +53,8 @@ enum rcu_barrier {
 };
 
 static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
-static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
-static struct completion rcu_barrier_completion;
+static struct ref_completion rcu_barrier_completion;
 int rcu_scheduler_active __read_mostly;
 
 /*
@@ -96,8 +95,7 @@ EXPORT_SYMBOL_GPL(synchronize_rcu);
 
 static void rcu_barrier_callback(struct rcu_head *notused)
 {
-	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
-		complete(&rcu_barrier_completion);
+	ref_completion_put(&rcu_barrier_completion);
 }
 
 /*
@@ -108,7 +106,7 @@ static void rcu_barrier_func(void *type)
 	int cpu = smp_processor_id();
 	struct rcu_head *head = &per_cpu(rcu_barrier_head, cpu);
 
-	atomic_inc(&rcu_barrier_cpu_count);
+	ref_completion_get(&rcu_barrier_completion);
 	switch ((enum rcu_barrier)type) {
 	case RCU_BARRIER_STD:
 		call_rcu(head, rcu_barrier_callback);
@@ -133,21 +131,12 @@ static void _rcu_barrier(enum rcu_barrier type)
 	BUG_ON(in_interrupt());
 	/* Take cpucontrol mutex to protect against CPU hotplug */
 	mutex_lock(&rcu_barrier_mutex);
-	init_completion(&rcu_barrier_completion);
-	/*
-	 * Initialize rcu_barrier_cpu_count to 1, then invoke
-	 * rcu_barrier_func() on each CPU, so that each CPU also has
-	 * incremented rcu_barrier_cpu_count.  Only then is it safe to
-	 * decrement rcu_barrier_cpu_count -- otherwise the first CPU
-	 * might complete its grace period before all of the other CPUs
-	 * did their increment, causing this function to return too
-	 * early.
-	 */
-	atomic_set(&rcu_barrier_cpu_count, 1);
+
+	ref_completion_get_init(&rcu_barrier_completion);
 	on_each_cpu(rcu_barrier_func, (void *)type, 1);
-	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
-		complete(&rcu_barrier_completion);
-	wait_for_completion(&rcu_barrier_completion);
+	ref_completion_put_init(&rcu_barrier_completion);
+	ref_completion_wait(&rcu_barrier_completion);
+
 	mutex_unlock(&rcu_barrier_mutex);
 	wait_migrated_callbacks();
 }



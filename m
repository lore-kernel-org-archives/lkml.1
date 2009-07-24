Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbZGXJub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbZGXJub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 05:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZGXJua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 05:50:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51688 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbZGXJu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 05:50:29 -0400
Message-ID: <4A6983D8.8090805@cn.fujitsu.com>
Date: Fri, 24 Jul 2009 17:50:16 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] generic-ipi: make struct call_function_data lockless
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch can remove spinlock from struct call_function_data, the 
reasons are below:

1: add a new interface for cpumask named cpumask_test_and_clear_cpu(),
   it can atomically test and clear specific cpu, we can use it instead
   of cpumask_test_cpu() and cpumask_clear_cpu() and no need data->lock
   to protect those in generic_smp_call_function_interrupt().

2: in smp_call_function_many(), after csd_lock() return, the current's
   cfd_data is deleted from call_function list, so it not have race
   between other cpus, then cfs_data is only used in
   smp_call_function_many() that must disable preemption and not from
   a hardware interrupthandler or from a bottom half handler to call,
   only the correspond cpu can use it, so it not have race in current
   cpu, no need cfs_data->lock to protect it.

3: after 1 and 2, cfs_data->lock is only use to protect cfs_data->refs in
   generic_smp_call_function_interrupt(), so we can define cfs_data->refs
   to atomic_t, and no need cfs_data->lock any more.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/cpumask.h |   12 ++++++++++++
 kernel/smp.c            |   29 ++++++++---------------------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index c5ac87c..a370bd5 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -715,6 +715,18 @@ static inline int cpumask_test_and_set_cpu(int cpu, struct cpumask *cpumask)
 }
 
 /**
+ * cpumask_test_and_clear_cpu - atomically test and clear a cpu in a cpumask
+ * @cpu: cpu number (< nr_cpu_ids)
+ * @cpumask: the cpumask pointer
+ *
+ * test_and_clear_bit wrapper for cpumasks.
+ */
+static inline int cpumask_test_and_clear_cpu(int cpu, struct cpumask *cpumask)
+{
+	return test_and_clear_bit(cpumask_check(cpu), cpumask_bits(cpumask));
+}
+
+/**
  * cpumask_setall - set all cpus (< nr_cpu_ids) in a cpumask
  * @dstp: the cpumask pointer
  */
diff --git a/kernel/smp.c b/kernel/smp.c
index ad63d85..7016996 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -29,8 +29,7 @@ enum {
 
 struct call_function_data {
 	struct call_single_data	csd;
-	spinlock_t		lock;
-	unsigned int		refs;
+	atomic_t		refs;
 	cpumask_var_t		cpumask;
 };
 
@@ -39,9 +38,7 @@ struct call_single_queue {
 	spinlock_t		lock;
 };
 
-static DEFINE_PER_CPU(struct call_function_data, cfd_data) = {
-	.lock			= __SPIN_LOCK_UNLOCKED(cfd_data.lock),
-};
+static DEFINE_PER_CPU(struct call_function_data, cfd_data);
 
 static int
 hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
@@ -191,25 +188,18 @@ void generic_smp_call_function_interrupt(void)
 	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
 		int refs;
 
-		spin_lock(&data->lock);
-		if (!cpumask_test_cpu(cpu, data->cpumask)) {
-			spin_unlock(&data->lock);
+		if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
 			continue;
-		}
-		cpumask_clear_cpu(cpu, data->cpumask);
-		spin_unlock(&data->lock);
 
 		data->csd.func(data->csd.info);
 
-		spin_lock(&data->lock);
-		WARN_ON(data->refs == 0);
-		refs = --data->refs;
+		refs = atomic_sub_return(1, &data->refs);
+		WARN_ON(refs < 0);
 		if (!refs) {
 			spin_lock(&call_function.lock);
 			list_del_rcu(&data->csd.list);
 			spin_unlock(&call_function.lock);
 		}
-		spin_unlock(&data->lock);
 
 		if (refs)
 			continue;
@@ -391,23 +381,20 @@ void smp_call_function_many(const struct cpumask *mask,
 	data = &__get_cpu_var(cfd_data);
 	csd_lock(&data->csd);
 
-	spin_lock_irqsave(&data->lock, flags);
 	data->csd.func = func;
 	data->csd.info = info;
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, data->cpumask);
-	data->refs = cpumask_weight(data->cpumask);
+	atomic_set(&data->refs, cpumask_weight(data->cpumask));
 
-	spin_lock(&call_function.lock);
+	spin_lock_irqsave(&call_function.lock, flags);
 	/*
 	 * Place entry at the _HEAD_ of the list, so that any cpu still
 	 * observing the entry in generic_smp_call_function_interrupt()
 	 * will not miss any other list entries:
 	 */
 	list_add_rcu(&data->csd.list, &call_function.queue);
-	spin_unlock(&call_function.lock);
-
-	spin_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&call_function.lock, flags);
 
 	/*
 	 * Make the list addition visible before sending the ipi.
-- 
1.6.1.2


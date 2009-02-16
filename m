Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZBPQmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZBPQmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZBPQmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:42:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49932 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbZBPQmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:42:08 -0500
Message-Id: <20090216164114.609493567@chello.nl>
References: <20090216163847.431174825@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 16 Feb 2009 17:38:50 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/4] generic-smp: properly allocate the cpumasks
Content-Disposition: inline; filename=smp-proper-cpu-mask.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its not deemed proper to have full cpumasks in data anymore, we have to
dynamically allocate them based on runtime determined dimensions of the
machine in question.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/smp.c |   54 +++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c
+++ linux-2.6/kernel/smp.c
@@ -10,6 +10,7 @@
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
 #include <linux/smp.h>
+#include <linux/cpu.h>
 
 static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
 
@@ -40,7 +41,7 @@ struct call_function_data {
 	spinlock_t lock;
 	unsigned int refs;
 	struct list_head free_list;
-	struct cpumask cpumask;
+	cpumask_var_t cpumask;
 };
 
 struct call_single_queue {
@@ -48,8 +49,41 @@ struct call_single_queue {
 	spinlock_t lock;
 };
 
+static DEFINE_PER_CPU(struct call_function_data, cfd_data);
+
+static int
+hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+	struct call_function_data *cfd = &per_cpu(cfd_data, cpu);
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		if (!alloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
+				cpu_to_node(cpu)))
+			return NOTIFY_BAD;
+		break;
+
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		free_cpumask_var(cfd->cpumask);
+		break;
+	};
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata hotplug_cfd_notifier = {
+	.notifier_call = hotplug_cfd,
+};
+
 static int __cpuinit init_call_single_data(void)
 {
+	void *cpu = (void *)(long)smp_processor_id();
 	int i;
 
 	for_each_possible_cpu(i) {
@@ -58,6 +92,10 @@ static int __cpuinit init_call_single_da
 		spin_lock_init(&q->lock);
 		INIT_LIST_HEAD(&q->list);
 	}
+
+	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
+	register_cpu_notifier(&hotplug_cfd_notifier);
+
 	return 0;
 }
 early_initcall(init_call_single_data);
@@ -116,13 +154,13 @@ void generic_smp_call_function_interrupt
 		LIST_HEAD(free_list);
 		int refs;
 
-		if (!cpumask_test_cpu(cpu, &data->cpumask))
+		if (!cpumask_test_cpu(cpu, data->cpumask))
 			continue;
 
 		data->csd.func(data->csd.info);
 
 		spin_lock(&data->lock);
-		cpumask_clear_cpu(cpu, &data->cpumask);
+		cpumask_clear_cpu(cpu, data->cpumask);
 		WARN_ON(data->refs == 0);
 		data->refs--;
 		refs = data->refs;
@@ -313,8 +351,6 @@ void __smp_call_function_single(int cpu,
 	arch_send_call_function_ipi(*(maskp))
 #endif
 
-static DEFINE_PER_CPU(struct call_function_data, cfd_data);
-
 /**
  * smp_call_function_many(): Run a function on a set of other CPUs.
  * @mask: The set of cpus to run on (only runs on online subset).
@@ -373,9 +409,9 @@ void smp_call_function_many(const struct
 		data->csd.flags |= CSD_FLAG_WAIT;
 	data->csd.func = func;
 	data->csd.info = info;
-	cpumask_and(&data->cpumask, mask, cpu_online_mask);
-	cpumask_clear_cpu(smp_processor_id(), &data->cpumask);
-	data->refs = cpumask_weight(&data->cpumask);
+	cpumask_and(data->cpumask, mask, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), data->cpumask);
+	data->refs = cpumask_weight(data->cpumask);
 
 	spin_lock_irqsave(&call_function.lock, flags);
 	call_function.counter++;
@@ -388,7 +424,7 @@ void smp_call_function_many(const struct
 	smp_mb();
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(&data->cpumask);
+	arch_send_call_function_ipi_mask(data->cpumask);
 
 	/* optionally wait for the CPUs to complete */
 	if (wait)

-- 


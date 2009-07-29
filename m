Return-Path: <linux-kernel-owner+w=401wt.eu-S1751524AbZG2H6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbZG2H6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 03:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZG2H6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 03:58:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58275 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbZG2H6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 03:58:02 -0400
Message-ID: <4A7000FF.6040402@cn.fujitsu.com>
Date: Wed, 29 Jul 2009 15:57:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3 -mm] generic-ipi: fix the race between generic_smp_call_function_*()
 and hotplug_cfd()
References: <4A6983D8.8090805@cn.fujitsu.com> <4A6FFFE9.5070204@cn.fujitsu.com>
In-Reply-To: <4A6FFFE9.5070204@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It have race between generic_smp_call_function_*() and hotplug_cfd()
in many cases, see below examples:

1: hotplug_cfd() can free cfd->cpumask, the system will crash if the
   cpu's cfd still in the call_function list:
  
  
      CPU A:                         CPU B
   
 smp_call_function_many()	    ......
   cpu_down()                      ......
  hotplug_cfd() ->                 ......
 free_cpumask_var(cfd->cpumask)  (receive function IPI interrupte)
                                /* read cfd->cpumask */           
                          generic_smp_call_function_interrupt() ->
                         cpumask_test_and_clear_cpu(cpu, data->cpumask)

                         	CRASH!!!

2: It's not handle call_function list when cpu down, It's will lead to
   dead-wait if other path is waiting this cpu to execute function
   
    CPU A:                           CPU B

 smp_call_function_many(wait=0)					
        ......			    CPU B down
   smp_call_function_many() -->  (cpu down before recevie function
    csd_lock(&data->csd);         IPI interrupte)

    DEAD-WAIT!!!!
       
  So, CPU A will dead-wait in csd_lock(), the same as
  smp_call_function_single()

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/smp.c |  140 ++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 79 insertions(+), 61 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 3035ab8..e52e30c 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -40,57 +40,6 @@ struct call_single_queue {
 
 static DEFINE_PER_CPU(struct call_function_data, cfd_data);
 
-static int
-hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
-{
-	long cpu = (long)hcpu;
-	struct call_function_data *cfd = &per_cpu(cfd_data, cpu);
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
-				cpu_to_node(cpu)))
-			return NOTIFY_BAD;
-		break;
-
-#ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		free_cpumask_var(cfd->cpumask);
-		break;
-#endif
-	};
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __cpuinitdata hotplug_cfd_notifier = {
-	.notifier_call		= hotplug_cfd,
-};
-
-static int __cpuinit init_call_single_data(void)
-{
-	void *cpu = (void *)(long)smp_processor_id();
-	int i;
-
-	for_each_possible_cpu(i) {
-		struct call_single_queue *q = &per_cpu(call_single_queue, i);
-
-		spin_lock_init(&q->lock);
-		INIT_LIST_HEAD(&q->list);
-	}
-
-	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
-	register_cpu_notifier(&hotplug_cfd_notifier);
-
-	return 0;
-}
-early_initcall(init_call_single_data);
-
 /*
  * csd_lock/csd_unlock used to serialize access to per-cpu csd resources
  *
@@ -164,14 +113,10 @@ void generic_exec_single(int cpu, struct call_single_data *data, int wait)
 		csd_lock_wait(data);
 }
 
-/*
- * Invoked by arch to handle an IPI for call function. Must be called with
- * interrupts disabled.
- */
-void generic_smp_call_function_interrupt(void)
+static void
+__generic_smp_call_function_interrupt(int cpu, int run_callbacks)
 {
 	struct call_function_data *data;
-	int cpu = smp_processor_id();
 
 	/*
 	 * Ensure entry is visible on call_function_queue after we have
@@ -210,12 +155,18 @@ void generic_smp_call_function_interrupt(void)
 }
 
 /*
- * Invoked by arch to handle an IPI for call function single. Must be
- * called from the arch with interrupts disabled.
+ * Invoked by arch to handle an IPI for call function. Must be called with
+ * interrupts disabled.
  */
-void generic_smp_call_function_single_interrupt(void)
+void generic_smp_call_function_interrupt(void)
+{
+	__generic_smp_call_function_interrupt(smp_processor_id(), 1);
+}
+
+static void
+__generic_smp_call_function_single_interrupt(int cpu, int run_callbacks)
 {
-	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
+	struct call_single_queue *q = &per_cpu(call_single_queue, cpu);
 	unsigned int data_flags;
 	LIST_HEAD(list);
 
@@ -246,6 +197,15 @@ void generic_smp_call_function_single_interrupt(void)
 	}
 }
 
+/*
+ * Invoked by arch to handle an IPI for call function single. Must be
+ * called from the arch with interrupts disabled.
+ */
+void generic_smp_call_function_single_interrupt(void)
+{
+	__generic_smp_call_function_single_interrupt(smp_processor_id(), 1);
+}
+
 static DEFINE_PER_CPU(struct call_single_data, csd_data);
 
 /*
@@ -456,3 +416,61 @@ void ipi_call_unlock_irq(void)
 {
 	spin_unlock_irq(&call_function.lock);
 }
+
+static int
+hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+	unsigned long flags;
+	struct call_function_data *cfd = &per_cpu(cfd_data, cpu);
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
+				cpu_to_node(cpu)))
+			return NOTIFY_BAD;
+		break;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		local_irq_save(flags);
+		__generic_smp_call_function_interrupt(cpu, 0);
+		__generic_smp_call_function_single_interrupt(cpu, 0);
+		local_irq_restore(flags);
+
+		csd_lock_wait(&cfd->csd);
+		free_cpumask_var(cfd->cpumask);
+		break;
+#endif
+	};
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata hotplug_cfd_notifier = {
+	.notifier_call		= hotplug_cfd,
+};
+
+static int __cpuinit init_call_single_data(void)
+{
+	void *cpu = (void *)(long)smp_processor_id();
+	int i;
+
+	for_each_possible_cpu(i) {
+		struct call_single_queue *q = &per_cpu(call_single_queue, i);
+
+		spin_lock_init(&q->lock);
+		INIT_LIST_HEAD(&q->list);
+	}
+
+	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
+	register_cpu_notifier(&hotplug_cfd_notifier);
+
+	return 0;
+}
+early_initcall(init_call_single_data);
-- 
1.6.1.2






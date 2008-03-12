Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbYCLL6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbYCLL6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 07:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYCLL5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 07:57:16 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25765 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbYCLL5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 07:57:13 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, dgc@sgi.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/7] x86-64: speedup and tweak smp_call_function_single()
Date: Wed, 12 Mar 2008 12:55:35 +0100
Message-Id: <1205322940-20127-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a __smp_call_function_single() that allows passing in the
caller data to avoid an allocation.

It's OK to have interrupts disabled, as long as we don't wait for
the IPI call to finish.

Get rid of the fallback data and pass back an error instead. Callers
that don't want to handle errors must either use wait == 1, or pre-allocate
the data and use the __smp_call_function_single() variant.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/x86/kernel/smp_64.c |  117 +++++++++++++++++++++++----------------------
 include/linux/smp.h      |    8 +++
 2 files changed, 68 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 1196a12..b1a3d3c 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -298,6 +298,8 @@ void smp_send_reschedule(int cpu)
 
 #define CALL_WAIT		0x01
 #define CALL_FALLBACK		0x02
+#define CALL_DATA_ALLOC		0x04
+
 /*
  * Structure and data for smp_call_function(). This is designed to minimise
  * static memory requirements. It also looks cleaner.
@@ -330,23 +332,12 @@ void unlock_ipi_call_lock(void)
 	spin_unlock_irq(&call_lock);
 }
 
-
-struct call_single_data {
-	struct list_head list;
-	void (*func) (void *info);
-	void *info;
-	unsigned int flags;
-};
-
 struct call_single_queue {
 	spinlock_t lock;
 	struct list_head list;
 };
 static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
 
-static unsigned long call_single_fallback_used;
-static struct call_single_data call_single_data_fallback;
-
 int __cpuinit init_smp_call(void)
 {
 	int i;
@@ -416,7 +407,8 @@ int smp_call_function_mask(cpumask_t mask,
 		data = &call_data_fallback;
 		flags |= CALL_FALLBACK;
 		/* XXX: can IPI all to "synchronize" RCU? */
-	}
+	} else
+		flags |= CALL_DATA_ALLOC;
 
 	spin_lock_init(&data->lock);
 	data->func = func;
@@ -446,7 +438,7 @@ int smp_call_function_mask(cpumask_t mask,
 		/* Wait for response */
 		while (data->flags)
 			cpu_relax();
-		if (likely(!(flags & CALL_FALLBACK)))
+		if (flags & CALL_DATA_ALLOC)
 			free_call_data(data);
 		else
 			clear_bit_unlock(0, &call_fallback_used);
@@ -457,6 +449,45 @@ int smp_call_function_mask(cpumask_t mask,
 EXPORT_SYMBOL(smp_call_function_mask);
 
 /*
+ * __smp_call_function_single - Run a function on a specific CPU
+ * @data: Associated data
+ *
+ * Retrurns 0 on success, else a negative status code.
+ *
+ * Does not return until the remote CPU is nearly ready to execute <func>
+ * or is or has executed. Also see smp_call_function_single()
+ */
+void __smp_call_function_single(int cpu, struct call_single_data *data)
+{
+	cpumask_t mask = cpumask_of_cpu(cpu);
+	struct call_single_queue *dst;
+	unsigned long flags;
+	/* prevent preemption and reschedule on another processor */
+	int ipi;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON((data->flags & CALL_WAIT) && irqs_disabled());
+
+	INIT_LIST_HEAD(&data->list);
+	dst = &per_cpu(call_single_queue, cpu);
+
+	spin_lock_irqsave(&dst->lock, flags);
+	ipi = list_empty(&dst->list);
+	list_add_tail(&data->list, &dst->list);
+	spin_unlock_irqrestore(&dst->lock, flags);
+
+	if (ipi)
+		send_IPI_mask(mask, CALL_FUNCTION_SINGLE_VECTOR);
+
+	if (data->flags & CALL_WAIT) {
+		/* Wait for response */
+		while (data->flags)
+			cpu_relax();
+	}
+}
+EXPORT_SYMBOL(__smp_call_function_single);
+
+/*
  * smp_call_function_single - Run a function on a specific CPU
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
@@ -468,68 +499,44 @@ EXPORT_SYMBOL(smp_call_function_mask);
  * Does not return until the remote CPU is nearly ready to execute <func>
  * or is or has executed.
  */
-
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			      int nonatomic, int wait)
 {
+	unsigned long flags;
 	/* prevent preemption and reschedule on another processor */
 	int me = get_cpu();
+	int ret = 0;
 
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
+	WARN_ON(wait && irqs_disabled());
 
 	if (cpu == me) {
-		local_irq_disable();
+		local_irq_save(flags);
 		func(info);
-		local_irq_enable();
+		local_irq_restore(flags);
 	} else {
 		struct call_single_data d;
 		struct call_single_data *data;
-		struct call_single_queue *dst;
-		cpumask_t mask = cpumask_of_cpu(cpu);
-		unsigned int flags = wait ? CALL_WAIT : 0;
-		int ipi;
 
 		if (!wait) {
-			data = kmalloc(sizeof(struct call_single_data), GFP_ATOMIC);
+			data = kmalloc(sizeof(*data), GFP_ATOMIC);
 			if (unlikely(!data)) {
-				while (test_and_set_bit_lock(0, &call_single_fallback_used))
-					cpu_relax();
-				data = &call_single_data_fallback;
-				flags |= CALL_FALLBACK;
+				ret = -ENOMEM;
+				goto out;
 			}
+			data->flags = CALL_DATA_ALLOC;
 		} else {
 			data = &d;
+			data->flags = CALL_WAIT;
 		}
 
 		data->func = func;
 		data->info = info;
-		data->flags = flags;
-		dst = &per_cpu(call_single_queue, cpu);
-
-		local_irq_disable();
-		while (!spin_trylock(&dst->lock)) {
-			local_irq_enable();
-			cpu_relax();
-			local_irq_disable();
-		}
-		ipi = list_empty(&dst->list);
-		list_add_tail(&data->list, &dst->list);
-		spin_unlock(&dst->lock);
-		local_irq_enable();
-
-		if (ipi)
-			send_IPI_mask(mask, CALL_FUNCTION_SINGLE_VECTOR);
-
-		if (wait) {
-			/* Wait for response */
-			while (data->flags)
-				cpu_relax();
-		}
+		__smp_call_function_single(cpu, data);
 	}
-
+out:
 	put_cpu();
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
@@ -626,7 +633,7 @@ asmlinkage void smp_call_function_interrupt(void)
 				smp_wmb();
 				data->flags = 0;
 			} else {
-				if (likely(!(data->flags & CALL_FALLBACK)))
+				if (likely(data->flags & CALL_DATA_ALLOC))
 					free_call_data(data);
 				else
 					clear_bit_unlock(0, &call_fallback_used);
@@ -662,12 +669,8 @@ asmlinkage void smp_call_function_single_interrupt(void)
 		if (data->flags & CALL_WAIT) {
 			smp_wmb();
 			data->flags = 0;
-		} else {
-			if (likely(!(data->flags & CALL_FALLBACK)))
-				kfree(data);
-			else
-				clear_bit_unlock(0, &call_single_fallback_used);
-		}
+		} else if (data->flags & CALL_DATA_ALLOC)
+			kfree(data);
 	}
 	add_pda(irq_call_count, 1);
 	irq_exit();
diff --git a/include/linux/smp.h b/include/linux/smp.h
index c938d26..629a44a 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -49,12 +49,20 @@ extern int __cpu_up(unsigned int cpunum);
  */
 extern void smp_cpus_done(unsigned int max_cpus);
 
+struct call_single_data {
+	struct list_head list;
+	void (*func) (void *info);
+	void *info;
+	unsigned int flags;
+};
+
 /*
  * Call a function on all other processors
  */
 int smp_call_function(void(*func)(void *info), void *info, int retry, int wait);
 int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 				int retry, int wait);
+void __smp_call_function_single(int cpuid, struct call_single_data *data);
 
 /*
  * Call a function on all processors
-- 
1.5.4.GIT


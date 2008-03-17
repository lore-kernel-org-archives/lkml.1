Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYCQQiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYCQQiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYCQQhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:37:55 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:44120 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYCQQhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:37:54 -0400
Message-ID: <47DE9E3F.7010600@hp.com>
Date: Mon, 17 Mar 2008 12:37:19 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, npiggin@suse.de, dgc@sgi.com
Subject: [Patch (block.git) 2/2] Ensure single IPI generation for SMP call
 single
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 arch/ia64/kernel/smp.c   |    8 ++++++--
 arch/x86/kernel/smp_32.c |    8 ++++++--
 arch/x86/kernel/smp_64.c |    8 ++++++--
 include/linux/smp.h      |    1 +
 kernel/smp.c             |   34 ++++++++++++++++++++--------------
 5 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index 04ba9f8..52225bb 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -364,7 +364,8 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 {
 	struct call_single_queue *dst;
 	unsigned long flags;
-	int ipi, wait_done = data->flags & CSD_FLAG_WAIT;
+	int ipi = 0;
+	int wait_done = data->flags & CSD_FLAG_WAIT;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
@@ -373,8 +374,11 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	dst = &per_cpu(call_single_queue, cpu);
 
 	spin_lock_irqsave(&dst->lock, flags);
-	ipi = list_empty(&dst->list);
 	list_add_tail(&data->list, &dst->list);
+	if (!dst->activated) {
+		dst->activated = 1;
+		ipi = 1;
+	}
 	spin_unlock_irqrestore(&dst->lock, flags);
 
 	if (ipi)
diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index be0f6cb..d166f13 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -629,7 +629,8 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	cpumask_t mask = cpumask_of_cpu(cpu);
 	struct call_single_queue *dst;
 	unsigned long flags;
-	int ipi, wait_done = data->flags & CSD_FLAG_WAIT;
+	int ipi = 0;
+	int wait_done = data->flags & CSD_FLAG_WAIT;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
@@ -638,8 +639,11 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	dst = &per_cpu(call_single_queue, cpu);
 
 	spin_lock_irqsave(&dst->lock, flags);
-	ipi = list_empty(&dst->list);
 	list_add_tail(&data->list, &dst->list);
+	if (!dst->activated) {
+		dst->activated = 1;
+		ipi = 1;
+	}
 	spin_unlock_irqrestore(&dst->lock, flags);
 
 	if (ipi)
diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 5bef2a6..fbfcdce 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -449,7 +449,8 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	cpumask_t mask = cpumask_of_cpu(cpu);
 	struct call_single_queue *dst;
 	unsigned long flags;
-	int ipi, wait_done = data->flags & CSD_FLAG_WAIT;
+	int ipi = 0;
+	int wait_done = data->flags & CSD_FLAG_WAIT;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
@@ -458,8 +459,11 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	dst = &per_cpu(call_single_queue, cpu);
 
 	spin_lock_irqsave(&dst->lock, flags);
-	ipi = list_empty(&dst->list);
 	list_add_tail(&data->list, &dst->list);
+	if (!dst->activated) {
+		dst->activated = 1;
+		ipi = 1;
+	}
 	spin_unlock_irqrestore(&dst->lock, flags);
 
 	if (ipi)
diff --git a/include/linux/smp.h b/include/linux/smp.h
index c471d77..1e96f03 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -65,6 +65,7 @@ extern void smp_cpus_done(unsigned int max_cpus);
 struct call_single_queue {
 	spinlock_t lock;
 	struct list_head list;
+	int activated;
 };
 
 /*
diff --git a/kernel/smp.c b/kernel/smp.c
index 7232e1c..f7ec401 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -23,28 +23,34 @@ void __cpuinit generic_init_call_single_data(void)
 
 void generic_smp_call_function_single_interrupt(void)
 {
-	struct call_single_queue *q;
 	unsigned long flags;
 	LIST_HEAD(list);
+	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
 
-	q = &__get_cpu_var(call_single_queue);
 	spin_lock_irqsave(&q->lock, flags);
-	list_replace_init(&q->list, &list);
-	spin_unlock_irqrestore(&q->lock, flags);
+	while (!list_empty(&q->list)) {
+		list_replace_init(&q->list, &list);
+		spin_unlock_irqrestore(&q->lock, flags);
 
-	while (!list_empty(&list)) {
-		struct call_single_data *data;
+		do {
+			struct call_single_data *data;
 
-		data = list_entry(list.next, struct call_single_data, list);
-		list_del(&data->list);
+			data = list_entry(list.next, struct call_single_data,
+						list);
+			list_del(&data->list);
 
-		data->func(data->info);
-		if (data->flags & CSD_FLAG_WAIT) {
-			smp_wmb();
-			data->flags = 0;
-		} else if (data->flags & CSD_FLAG_ALLOC)
-			kfree(data);
+			data->func(data->info);
+			if (data->flags & CSD_FLAG_WAIT) {
+				smp_wmb();
+				data->flags = 0;
+			} else if (data->flags & CSD_FLAG_ALLOC)
+				kfree(data);
+		} while (!list_empty(&list));
+
+		spin_lock_irqsave(&q->lock, flags);
 	}
+	q->activated = 0;
+	spin_unlock_irqrestore(&q->lock, flags);
 }
 
 int generic_smp_call_function_single(int cpu, void (*func) (void *info),
-- 
1.5.2.5



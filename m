Return-Path: <linux-kernel-owner+w=401wt.eu-S934269AbZLFSEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934269AbZLFSEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934226AbZLFSEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:04:13 -0500
Received: from www.tglx.de ([62.245.132.106]:33285 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934190AbZLFSDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:03:48 -0500
Message-Id: <20091206111958.029468469@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:03:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 19/23] smp: Convert smplocks to raw_spinlocks
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline; filename=smp-convert-smplocks-to-core-locks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/smp.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: linux-2.6-tip/kernel/smp.c
===================================================================
--- linux-2.6-tip.orig/kernel/smp.c
+++ linux-2.6-tip/kernel/smp.c
@@ -16,11 +16,11 @@ static DEFINE_PER_CPU(struct call_single
 
 static struct {
 	struct list_head	queue;
-	spinlock_t		lock;
+	raw_spinlock_t		lock;
 } call_function __cacheline_aligned_in_smp =
 	{
 		.queue		= LIST_HEAD_INIT(call_function.queue),
-		.lock		= __SPIN_LOCK_UNLOCKED(call_function.lock),
+		.lock		= __RAW_SPIN_LOCK_UNLOCKED(call_function.lock),
 	};
 
 enum {
@@ -35,7 +35,7 @@ struct call_function_data {
 
 struct call_single_queue {
 	struct list_head	list;
-	spinlock_t		lock;
+	raw_spinlock_t		lock;
 };
 
 static DEFINE_PER_CPU(struct call_function_data, cfd_data);
@@ -80,7 +80,7 @@ static int __cpuinit init_call_single_da
 	for_each_possible_cpu(i) {
 		struct call_single_queue *q = &per_cpu(call_single_queue, i);
 
-		spin_lock_init(&q->lock);
+		raw_spin_lock_init(&q->lock);
 		INIT_LIST_HEAD(&q->list);
 	}
 
@@ -141,10 +141,10 @@ void generic_exec_single(int cpu, struct
 	unsigned long flags;
 	int ipi;
 
-	spin_lock_irqsave(&dst->lock, flags);
+	raw_spin_lock_irqsave(&dst->lock, flags);
 	ipi = list_empty(&dst->list);
 	list_add_tail(&data->list, &dst->list);
-	spin_unlock_irqrestore(&dst->lock, flags);
+	raw_spin_unlock_irqrestore(&dst->lock, flags);
 
 	/*
 	 * The list addition should be visible before sending the IPI
@@ -201,9 +201,9 @@ void generic_smp_call_function_interrupt
 		refs = atomic_dec_return(&data->refs);
 		WARN_ON(refs < 0);
 		if (!refs) {
-			spin_lock(&call_function.lock);
+			raw_spin_lock(&call_function.lock);
 			list_del_rcu(&data->csd.list);
-			spin_unlock(&call_function.lock);
+			raw_spin_unlock(&call_function.lock);
 		}
 
 		if (refs)
@@ -230,9 +230,9 @@ void generic_smp_call_function_single_in
 	 */
 	WARN_ON_ONCE(!cpu_online(smp_processor_id()));
 
-	spin_lock(&q->lock);
+	raw_spin_lock(&q->lock);
 	list_replace_init(&q->list, &list);
-	spin_unlock(&q->lock);
+	raw_spin_unlock(&q->lock);
 
 	while (!list_empty(&list)) {
 		struct call_single_data *data;
@@ -449,14 +449,14 @@ void smp_call_function_many(const struct
 	cpumask_clear_cpu(this_cpu, data->cpumask);
 	atomic_set(&data->refs, cpumask_weight(data->cpumask));
 
-	spin_lock_irqsave(&call_function.lock, flags);
+	raw_spin_lock_irqsave(&call_function.lock, flags);
 	/*
 	 * Place entry at the _HEAD_ of the list, so that any cpu still
 	 * observing the entry in generic_smp_call_function_interrupt()
 	 * will not miss any other list entries:
 	 */
 	list_add_rcu(&data->csd.list, &call_function.queue);
-	spin_unlock_irqrestore(&call_function.lock, flags);
+	raw_spin_unlock_irqrestore(&call_function.lock, flags);
 
 	/*
 	 * Make the list addition visible before sending the ipi.
@@ -501,20 +501,20 @@ EXPORT_SYMBOL(smp_call_function);
 
 void ipi_call_lock(void)
 {
-	spin_lock(&call_function.lock);
+	raw_spin_lock(&call_function.lock);
 }
 
 void ipi_call_unlock(void)
 {
-	spin_unlock(&call_function.lock);
+	raw_spin_unlock(&call_function.lock);
 }
 
 void ipi_call_lock_irq(void)
 {
-	spin_lock_irq(&call_function.lock);
+	raw_spin_lock_irq(&call_function.lock);
 }
 
 void ipi_call_unlock_irq(void)
 {
-	spin_unlock_irq(&call_function.lock);
+	raw_spin_unlock_irq(&call_function.lock);
 }



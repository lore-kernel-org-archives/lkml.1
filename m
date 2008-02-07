Return-Path: <linux-kernel-owner+w=401wt.eu-S1761179AbYBGOTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761179AbYBGOTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759405AbYBGOSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:18:52 -0500
Received: from brick.kernel.dk ([87.55.233.238]:11692 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758027AbYBGOSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:18:50 -0500
Date: Thu, 7 Feb 2008 15:18:47 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Alan.Brunelle@hp.com, arjan@linux.intel.com,
       dgc@sgi.com, npiggin@suse.de
Subject: Re: [PATCH 4/8] x86: add support for remotely triggering the block  softirq
Message-ID: <20080207141847.GK15220@kernel.dk>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <1202375945-29525-5-git-send-email-jens.axboe@oracle.com> <20080207100738.GB7716@elte.hu> <20080207101727.GE15220@kernel.dk> <20080207102534.GB16735@elte.hu> <20080207103136.GG15220@kernel.dk> <20080207103804.GE16735@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207103804.GE16735@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07 2008, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > pick up the threaded softirq patches from -rt, those move all 
> > > softirqs processing into kernel threads. I'd suggest to extend those 
> > > via wakeup-from-remote functionality - it fits the construct quite 
> > > naturally. You should also be able to directly observe any 
> > > performance impact of threaded softirq handlers. (and if you find 
> > > any, let me know so that we can make it faster :-)
> > 
> > I was just considering that, since I knew -rt moved the softirqs into 
> > threads. I'll look into it, but may not post anything until after my 
> > vacation.
> 
> we should more seriously investigate kernel thread scalability for 
> another reason as well: besides -rt, any generic async IO facility we 
> pick up will likely heavily rely on them. Kernel thread scheduling is 
> quite a bit lighter than user task scheduling [no TLB flushes, etc.] - 
> and if it is still not good enough we could probably accelerate them 
> some more. (and everyone will benefit) irq-context softirqs on the other 
> hand are quite rigid and bring in many atomicity assumptions so they are 
> not as natural to program for.

Here's a patch on top of the other patchset that switches blk-softirq.c
to using kernel threads instead. It's pretty simple. Booted tested,
works for me :-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 5ae8345..73c71c7 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -7,6 +7,8 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/kthread.h>
 #include <linux/cpu.h>
 
 #include "blk.h"
@@ -14,41 +16,136 @@
 struct blk_comp {
 	spinlock_t lock;
 	struct list_head list;
-	int dead;
+	struct task_struct *task;
 };
-static DEFINE_PER_CPU(struct blk_comp, blk_cpu_done);
+static DEFINE_PER_CPU(struct blk_comp, blk_irq_data);
+
+static void raise_blk_irq(int cpu)
+{
+	struct blk_comp *bc = &per_cpu(blk_irq_data, cpu);
+
+	wake_up_process(bc->task);
+}
+
+static void blk_done_softirq(struct list_head *list)
+{
+	while (!list_empty(list)) {
+		struct request *rq;
+
+		rq = list_entry(list->next, struct request, donelist);
+		list_del_init(&rq->donelist);
+		rq->q->softirq_done_fn(rq);
+	}
+}
+
+static int blk_irq_thread(void *data)
+{
+	struct blk_comp *bc = data;
+	struct sched_param param = { .sched_priority = MAX_USER_RT_PRIO / 2 };
+
+	sched_setscheduler(current, SCHED_FIFO, &param);
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	while (!kthread_should_stop()) {
+		LIST_HEAD(local_list);
+
+		preempt_disable();
+		smp_mb();
+		if (list_empty(&bc->list)) {
+			preempt_enable_no_resched();
+			schedule();
+			preempt_disable();
+		}
+
+		__set_current_state(TASK_RUNNING);
+		smp_mb();
+		while (!list_empty(&bc->list)) {
+			spin_lock_irq(&bc->lock);
+			list_replace_init(&bc->list, &local_list);
+			spin_unlock_irq(&bc->lock);
+
+
+			blk_done_softirq(&local_list);
+		}
+		preempt_enable();
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
+
+static int create_blk_irq_thread(int cpu)
+{
+	struct blk_comp *bc = &per_cpu(blk_irq_data, cpu);
+	struct task_struct *task;
+
+	spin_lock_init(&bc->lock);
+	INIT_LIST_HEAD(&bc->list);
+	bc->task = NULL;
+
+	task = kthread_create(blk_irq_thread, bc, "blk-irq-%d", cpu);
+	if (IS_ERR(task)) {
+		printk("block: irq thread creation failed\n");
+		return 1;
+	}
+
+	kthread_bind(task, cpu);
+	bc->task = task;
+	return 0;
+}
 
 static int __cpuinit blk_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
 	int cpu = (unsigned long) hcpu;
+	struct task_struct *task;
 	struct blk_comp *bc;
 
 	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		bc = &per_cpu(blk_irq_data, cpu);
+		if (bc->task) {
+			printk("blk: task for %d already there\n", cpu);
+			break;
+		}
+		if (create_blk_irq_thread(cpu))
+			return NOTIFY_BAD;
+		break;
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		raise_blk_irq(cpu);
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		bc = &per_cpu(blk_irq_data, cpu);
+		if (!bc->task);
+			break;
+		kthread_bind(bc->task, any_online_cpu(cpu_online_map));
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN: {
 		/*
 		 * If a CPU goes away, splice its entries to the current CPU
 		 * and trigger a run of the softirq
 		 */
+		struct sched_param param;
 		struct blk_comp *dead;
 
 		local_irq_disable();
-		bc = &__get_cpu_var(blk_cpu_done);
-		dead = &per_cpu(blk_cpu_done, cpu);
+		bc = &__get_cpu_var(blk_irq_data);
+		dead = &per_cpu(blk_irq_data, cpu);
 		double_spin_lock(&bc->lock, &dead->lock, bc < dead);
 		list_splice_init(&dead->list, &bc->list);
-		dead->dead = 1;
 		double_spin_unlock(&bc->lock, &dead->lock, bc < dead);
-		raise_softirq_irqoff(BLOCK_SOFTIRQ);
-		local_irq_enable();
-		break;
-		}
-	case CPU_ONLINE: {
-		local_irq_disable();
-		bc = &per_cpu(blk_cpu_done, cpu);
-		bc->dead = 0;
+
+		param.sched_priority = MAX_RT_PRIO - 1;
+		task = dead->task;
+		sched_setscheduler(task, SCHED_FIFO, &param);
+		dead->task = NULL;
+		raise_blk_irq(smp_processor_id());
 		local_irq_enable();
+		kthread_stop(task);
 		break;
 		}
 	}
@@ -56,35 +153,10 @@ static int __cpuinit blk_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block blk_cpu_notifier __cpuinitdata = {
+static struct notifier_block __cpuinitdata blk_cpu_notifier = {
 	.notifier_call	= blk_cpu_notify,
 };
 
-/*
- * splice the completion data to a local structure and hand off to
- * process_completion_queue() to complete the requests
- */
-static void blk_done_softirq(struct softirq_action *h)
-{
-	struct blk_comp *bc;
-	struct list_head local_list;
-
-	local_irq_disable();
-	bc = &__get_cpu_var(blk_cpu_done);
-	spin_lock(&bc->lock);
-	list_replace_init(&bc->list, &local_list);
-	spin_unlock(&bc->lock);
-	local_irq_enable();
-
-	while (!list_empty(&local_list)) {
-		struct request *rq;
-
-		rq = list_entry(local_list.next, struct request, donelist);
-		list_del_init(&rq->donelist);
-		rq->q->softirq_done_fn(rq);
-	}
-}
-
 /**
  * blk_complete_request - end I/O on a request
  * @req:      the request being processed
@@ -117,11 +189,11 @@ void blk_complete_request(struct request *req)
 
 	if (ccpu == cpu) {
 is_dead:
-		bc = &__get_cpu_var(blk_cpu_done);
+		bc = &__get_cpu_var(blk_irq_data);
 		q->local_complete++;
 	} else {
-		bc = &per_cpu(blk_cpu_done, ccpu);
-		if (unlikely(bc->dead)) {
+		bc = &per_cpu(blk_irq_data, ccpu);
+		if (unlikely(!bc->task)) {
 			ccpu = cpu;
 			goto is_dead;
 		}
@@ -134,30 +206,27 @@ is_dead:
 	list_add_tail(&req->donelist, &bc->list);
 	spin_unlock(&bc->lock);
 
-	if (was_empty) {
-		if (cpu == ccpu)
-			raise_softirq_irqoff(BLOCK_SOFTIRQ);
-		else
-			raise_softirq_on_cpu(ccpu, BLOCK_SOFTIRQ);
-	}
+	if (was_empty)
+		raise_blk_irq(ccpu);
 
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(blk_complete_request);
 
-static int __init blk_softirq_init(void)
+__init int blk_softirq_init(void)
 {
 	int i;
 
 	for_each_possible_cpu(i) {
-		struct blk_comp *bc = &per_cpu(blk_cpu_done, i);
+		void *cpu;
+		int err;
 
-		spin_lock_init(&bc->lock);
-		INIT_LIST_HEAD(&bc->list);
-		bc->dead = 0;
+		cpu = (void *) (long) i;
+		err = blk_cpu_notify(&blk_cpu_notifier, CPU_UP_PREPARE, cpu);
+		BUG_ON(err == NOTIFY_BAD);
+		blk_cpu_notify(&blk_cpu_notifier, CPU_ONLINE, cpu);
 	}
 
-	open_softirq(BLOCK_SOFTIRQ, blk_done_softirq, NULL);
 	register_hotcpu_notifier(&blk_cpu_notifier);
 	return 0;
 }

-- 
Jens Axboe


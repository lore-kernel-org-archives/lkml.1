Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbYFLRm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbYFLRm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbYFLRmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:42:52 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51686 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbYFLRmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:42:51 -0400
Date: Thu, 12 Jun 2008 21:44:33 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueues: insert_work: use "list_head *" instead of "int tail"
Message-ID: <20080612174433.GA12204@tv-sign.ru>
References: <20080612165120.GA12177@tv-sign.ru> <20080612165550.GA12183@tv-sign.ru> <1213290074.31518.136.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213290074.31518.136.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12, Peter Zijlstra wrote:
>
> On Thu, 2008-06-12 at 20:55 +0400, Oleg Nesterov wrote:
> > 
> > This allows us to implement
> > 
> > 	int flush_work(struct work_struct *work)
> > 	{
> > 		struct cpu_workqueue_struct *cwq;
> > 		struct list_head *head;
> > 		struct wq_barrier barr;
> > 
> > 		cwq = get_wq_data(work);
> > 		if (!cwq)
> > 			return 0;
> > 
> > 		head = NULL;
> > 		spin_lock_irq(&cwq->lock);
> > 		if (!list_empty(&work->entry)) {
> > 			smp_rmb();
> > 			/*
> > 			 * ---- FAT COMMENT ----
> > 			 */
> > 			if (cwq == get_wq_data(work))
> > 				head = work->entry.next;
> > 		} else if (cwq->current_work == work) {
> > 			head = cwq->worklist.next;
> > 		}
> > 
> > 		if (head)
> > 			insert_wq_barrier(cwq, &barr, head);
> > 		spin_unlock_irq(&cwq->lock);
> > 
> > 		if (!head)
> > 			return 0;
> > 		wait_for_completion(&barr.done);
> > 		return 1;
> > 	}
> > 
> > suggested by Peter. It only waits for selected work_struct.
> > 
> > I doubt it will have a lot of users though. In most cases we need
> > cancel_work_sync() and nothing more.
> 
> Are there cases where we dynamically allocate work structs and queue
> them and then forget about them? In such cases we'd need something a
> little more complex as we don't have work pointers to flush or cancel.
> 
> Hence that idea of flush context and completions.

Do you mean something like (just for example) below? If yes, then yes
sure, flush_work() is limited. But I can't see how it is possible to
"generalize" this idea.

(hmm... actually, if we add flush_work(), we can speedup schedule_on_each_cpu(),
 instead of flush_workqueue(keventd_wq) we can do

	for_each_online_cpu(cpu)
		flush_work(per_cpu_ptr(works, cpu));

 not sure this really makes sense though).

Oleg.

--- kernel/workqueue.c~	2007-07-28 16:58:17.000000000 +0400
+++ kernel/workqueue.c	2007-08-06 20:33:25.000000000 +0400
@@ -590,25 +590,54 @@ EXPORT_SYMBOL(schedule_delayed_work_on);
  *
  * schedule_on_each_cpu() is very slow.
  */
+
+struct xxx
+{
+	atomic_t count;
+	struct completion done;
+	work_func_t func;
+};
+
+struct yyy
+{
+	struct work_struct work;
+	struct xxx *xxx;
+};
+
+static void yyy_func(struct work_struct *work)
+{
+	struct xxx *xxx = container_of(work, struct yyy, work)->xxx;
+	xxx->func(work);
+
+	if (atomic_dec_and_test(&xxx->count))
+		complete(&xxx->done);
+}
+
 int schedule_on_each_cpu(work_func_t func)
 {
 	int cpu;
-	struct work_struct *works;
+	struct xxx xxx;
+	struct yyy *works;
 
-	works = alloc_percpu(struct work_struct);
+	init_completion(&xxx.done);
+	xxx.func = func;
+
+	works = alloc_percpu(struct yyy);
 	if (!works)
 		return -ENOMEM;
 
 	get_online_cpus();
+	atomic_set(&xxx.count, num_online_cpus());
 	for_each_online_cpu(cpu) {
-		struct work_struct *work = per_cpu_ptr(works, cpu);
+		struct yyy *yyy = per_cpu_ptr(works, cpu);
 
-		INIT_WORK(work, func);
-		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
-		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), work);
+		yyy->xxx = &xxx;
+		INIT_WORK(&yyy->work, yyy_func);
+		set_bit(WORK_STRUCT_PENDING, work_data_bits(&yyy->work));
+		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), &yyy->work);
 	}
-	flush_workqueue(keventd_wq);
 	put_online_cpus();
+	wait_for_completion(&xxx.done);
 	free_percpu(works);
 	return 0;
 }


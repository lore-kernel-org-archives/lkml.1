Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbXHFQi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbXHFQi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 12:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbXHFQiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 12:38:18 -0400
Received: from mail.screens.ru ([213.234.233.54]:60258 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbXHFQiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 12:38:17 -0400
Date: Mon, 6 Aug 2007 20:40:33 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Daniel Walker <dwalker@mvista.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070806164033.GA4021@tv-sign.ru>
References: <1186005598.9513.261.camel@ghaskins-t60p.haskins.net> <20070801222201.GA316@tv-sign.ru> <1186012439.9513.321.camel@ghaskins-t60p.haskins.net> <20070802195049.GA361@tv-sign.ru> <20070806114954.GC1903@elte.hu> <20070806131814.GC91@tv-sign.ru> <1186406963.7182.13.camel@twins> <1186407173.7182.16.camel@twins> <20070806144536.GA232@tv-sign.ru> <1186411921.7182.24.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186411921.7182.24.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06, Peter Zijlstra wrote:
>
> On Mon, 2007-08-06 at 18:45 +0400, Oleg Nesterov wrote:
> > On 08/06, Peter Zijlstra wrote:
> 
> > > > I suspect most of the barrier/flush semantics could be replaced with
> > > > completions from specific work items.
> > 
> > Hm. But this is exactly how it works?
> 
> Yes, barriers work by enqueueing work and waiting for that one work item
> to fall out, thereby knowing that all previous work has been completed.
> 
> My point was that most flushes are there to wait for a previously
> enqueued work item, and might as well wait for that one.
> 
> Let me try to illustrate: a regular pattern is, we enqueue work A and
> then flush the whole queue to ensure A is processed. So instead of
> enqueueing A, then B in the barrier code, and wait for B to pop out, we
> might as well wait for A to begin with.

This is a bit off-topic, but in that particular case we can do

	if (cancel_work_sync(&A))
		A->func(&A);

unless we want to execute ->func() on another CPU of course. It is easy to
implement flush_work() which waits for a single work_strcut, but it is not
so useful when it comes to schedule_on_each_cpu().

But I agree, flush_workqueue() should be avoided if possible. Not sure
it makes sense, but we can do something like below.

Oleg.

--- kernel/workqueue.c~	2007-07-28 16:58:17.000000000 +0400
+++ kernel/workqueue.c	2007-08-06 20:33:25.000000000 +0400
@@ -572,25 +572,54 @@ EXPORT_SYMBOL(schedule_delayed_work_on);
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
 
 	preempt_disable();		/* CPU hotplug */
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
 	preempt_enable();
-	flush_workqueue(keventd_wq);
+	wait_for_completion(&xxx.done);
 	free_percpu(works);
 	return 0;
 }


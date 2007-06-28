Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbXF1Orb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbXF1Orb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbXF1OrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:47:24 -0400
Received: from mail.screens.ru ([213.234.233.54]:35488 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbXF1OrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:47:23 -0400
Date: Thu, 28 Jun 2007 18:47:41 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Thomas Sattler <tsattler@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.22-rc6 spurious hangs
Message-ID: <20070628144741.GA437@tv-sign.ru>
References: <4683BF16.40905@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4683BF16.40905@gmx.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28, Thomas Sattler wrote:
>
> As Ingo told me I run 'echo t > /proc/sysrq-trigger' this time. The
> corresponding part of my syslogs is attached, as well as my kernel config.

xs_connect() and release_dev() are blocked on flush_workqueue(). Perhaps
this is OK, but may be not.

Could you try the patch below? It dumps some info when flush_workqueue()
hangs.

Oleg.

--- OLD/kernel/sched.c~TST	2007-04-05 12:20:35.000000000 +0400
+++ OLD/kernel/sched.c	2007-06-02 15:41:53.000000000 +0400
@@ -4177,6 +4177,20 @@ struct task_struct *idle_task(int cpu)
 	return cpu_rq(cpu)->idle;
 }
 
+struct task_struct *get_cpu_curr(int cpu)
+{
+	unsigned long flags;
+	struct task_struct *curr;
+	struct rq *rq = cpu_rq(cpu);
+
+	spin_lock_irqsave(&rq->lock, flags);
+	curr = rq->curr;
+	get_task_struct(curr);
+	spin_unlock_irqrestore(&rq->lock, flags);
+
+	return curr;
+}
+
 /**
  * find_process_by_pid - find a process with a matching PID value.
  * @pid: the pid in question.
--- OLD/kernel/workqueue.c~TST	2007-06-02 13:34:57.000000000 +0400
+++ OLD/kernel/workqueue.c	2007-06-03 11:28:54.000000000 +0400
@@ -49,6 +49,7 @@ struct cpu_workqueue_struct {
 	struct task_struct *thread;
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
+	int jobs;
 } ____cacheline_aligned;
 
 /*
@@ -253,6 +254,7 @@ static void run_workqueue(struct cpu_wor
 
 		cwq->current_work = work;
 		list_del_init(cwq->worklist.next);
+		cwq->jobs++;
 		spin_unlock_irq(&cwq->lock);
 
 		BUG_ON(get_wq_data(work) != cwq);
@@ -328,6 +330,47 @@ static void insert_wq_barrier(struct cpu
 	insert_work(cwq, &barr->work, tail);
 }
 
+extern struct task_struct *get_cpu_curr(int cpu);
+
+static void flush_wait(struct cpu_workqueue_struct *cwq, struct completion *done)
+{
+	const int cpu = task_cpu(cwq->thread);
+	struct task_struct *curr;
+	struct work_struct *work;
+	int old_pid, state, jobs;
+
+again:
+	state = cwq->thread->state;
+	work = cwq->current_work;
+	jobs = cwq->jobs;
+
+	curr = get_cpu_curr(cpu);
+	old_pid = curr->pid;
+	put_task_struct(curr);
+
+	if (wait_for_completion_timeout(done, HZ * 30))
+		return;
+
+	printk(KERN_ERR "ERR!! %s flush hang: %p %p %d %d %d %d\n", cwq->thread->comm,
+			work, cwq->current_work, jobs, cwq->jobs,
+			state, (int)cwq->thread->state);
+
+	curr = get_cpu_curr(cpu);
+	printk(KERN_ERR "CURR: %d %d %s %ld %ld\n", old_pid, curr->pid,
+			curr->comm, curr->nivcsw, curr->nvcsw);
+	put_task_struct(curr);
+
+	spin_lock_irq(&cwq->lock);
+	list_for_each_entry(work, &cwq->worklist, entry)
+		print_symbol("    %s\n", (unsigned long) work->func);
+	printk("    ----\n");
+	if (cwq->current_work)
+		print_symbol("    %s\n", (unsigned long) cwq->current_work->func);
+	spin_unlock_irq(&cwq->lock);
+
+	goto again;
+}
+
 static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	int active;
@@ -351,7 +394,7 @@ static int flush_cpu_workqueue(struct cp
 		spin_unlock_irq(&cwq->lock);
 
 		if (active)
-			wait_for_completion(&barr.done);
+			flush_wait(cwq, &barr.done);
 	}
 
 	return active;


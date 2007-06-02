Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbXFBUoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbXFBUoi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 16:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbXFBUob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 16:44:31 -0400
Received: from ms-smtp-04.tampabay.rr.com ([65.32.5.134]:32880 "EHLO
	ms-smtp-04.tampabay.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756671AbXFBUoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 16:44:30 -0400
Message-ID: <4661D698.5040009@cfl.rr.com>
Date: Sat, 02 Jun 2007 16:44:08 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Mark Hounschell <markh@compro.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: floppy.c soft lockup
References: <20070531170604.GA79@tv-sign.ru> <465F179D.6080203@compro.net> <20070531192256.GA88@tv-sign.ru> <465F2D96.9060502@compro.net> <20070601110058.GA83@tv-sign.ru> <466028DB.3060509@compro.net> <20070601151605.GA108@tv-sign.ru> <4660534E.6050903@cfl.rr.com> <20070601183642.GA92@tv-sign.ru> <466078FF.2080508@cfl.rr.com> <20070602123030.GA719@tv-sign.ru>
In-Reply-To: <20070602123030.GA719@tv-sign.ru>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 06/01, Mark Hounschell wrote:
>> Oleg Nesterov wrote:
>>> On 06/01, Mark Hounschell wrote:
>>>> Ok the prctl never returned. I just replaced the ioctl with it and added
>>>> a printf before and after. I only get the one before. The thread is hung
>>>> at this point just as if I'd done the ioctl?
>>> Thanks. So we can rule out floppy.c. flush_scheduled_work/flush_workqueue
>>> is broken by this RT application. Imho, this is not the kernel problem.
>>>
>>> Now I am very sure that the initial suspect was correct: cpu starvation.
>>> I can cook a debug patch to be 100% sure tomorrow, which kernel version is
>>> most convenient to you?
>>>
>> 2.6.22-rc3 is fine thanks.
> 
> Please try this patch, it should dump some debug info when flush_workqueue()
> hangs (after 30 seconds). You can use it with or without the previous patch
> I sent. Please wait for a couple of minutes to collect more info.
> 
> Oleg.
> 
> --- OLD/kernel/sched.c~TST	2007-04-05 12:20:35.000000000 +0400
> +++ OLD/kernel/sched.c	2007-06-02 15:41:53.000000000 +0400
> @@ -4177,6 +4177,20 @@ struct task_struct *idle_task(int cpu)
>  	return cpu_rq(cpu)->idle;
>  }
>  
> +struct task_struct *get_cpu_curr(int cpu)
> +{
> +	unsigned long flags;
> +	struct task_struct *curr;
> +	struct rq *rq = cpu_rq(cpu);
> +
> +	spin_lock_irqsave(&rq->lock, flags);
> +	curr = rq->curr;
> +	get_task_struct(curr);
> +	spin_unlock_irqrestore(&rq->lock, flags);
> +
> +	return curr;
> +}
> +
>  /**
>   * find_process_by_pid - find a process with a matching PID value.
>   * @pid: the pid in question.
> --- OLD/kernel/workqueue.c~TST	2007-06-02 13:34:57.000000000 +0400
> +++ OLD/kernel/workqueue.c	2007-06-02 16:18:02.000000000 +0400
> @@ -49,6 +49,7 @@ struct cpu_workqueue_struct {
>  	struct task_struct *thread;
>  
>  	int run_depth;		/* Detect run_workqueue() recursion depth */
> +	int jobs;
>  } ____cacheline_aligned;
>  
>  /*
> @@ -253,6 +254,7 @@ static void run_workqueue(struct cpu_wor
>  
>  		cwq->current_work = work;
>  		list_del_init(cwq->worklist.next);
> +		cwq->jobs++;
>  		spin_unlock_irq(&cwq->lock);
>  
>  		BUG_ON(get_wq_data(work) != cwq);
> @@ -328,7 +330,48 @@ static void insert_wq_barrier(struct cpu
>  	insert_work(cwq, &barr->work, tail);
>  }
>  
> -static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
> +extern struct task_struct *get_cpu_curr(int cpu);
> +
> +static void flush_wait(struct cpu_workqueue_struct *cwq, int cpu, struct completion *done)
> +{
> +	struct task_struct *curr;
> +	struct work_struct *work;
> +	int old_pid, jobs;
> +
> +	if (is_single_threaded(cwq->wq))
> +		cpu = raw_smp_processor_id();
> +
> +again:
> +	work = cwq->current_work;
> +	jobs = cwq->jobs;
> +
> +	curr = get_cpu_curr(cpu);
> +	old_pid = curr->pid;
> +	put_task_struct(curr);
> +
> +	if (wait_for_completion_timeout(done, HZ * 30))
> +		return;
> +
> +	printk(KERN_ERR "ERR!! %s flush hang: %p %p %d %d\n", cwq->thread->comm,
> +			work, cwq->current_work, jobs, cwq->jobs);
> +
> +	curr = get_cpu_curr(cpu);
> +	printk(KERN_ERR "CURR: %d %d %s %ld %ld\n", old_pid, curr->pid,
> +			curr->comm, curr->nivcsw, curr->nvcsw);
> +	put_task_struct(curr);
> +
> +	spin_lock_irq(&cwq->lock);
> +	list_for_each_entry(work, &cwq->worklist, entry)
> +		print_symbol("    %s\n", (unsigned long) work->func);
> +	printk("    ----\n");
> +	if (cwq->current_work)
> +		print_symbol("    %s\n", (unsigned long) cwq->current_work->func);
> +	spin_unlock_irq(&cwq->lock);
> +
> +	goto again;
> +}
> +
> +static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq, int cpu)
>  {
>  	int active;
>  
> @@ -351,7 +394,7 @@ static int flush_cpu_workqueue(struct cp
>  		spin_unlock_irq(&cwq->lock);
>  
>  		if (active)
> -			wait_for_completion(&barr.done);
> +			flush_wait(cwq, cpu, &barr.done);
>  	}
>  
>  	return active;
> @@ -377,7 +420,7 @@ void fastcall flush_workqueue(struct wor
>  
>  	might_sleep();
>  	for_each_cpu_mask(cpu, *cpu_map)
> -		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
> +		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu), cpu);
>  }
>  EXPORT_SYMBOL_GPL(flush_workqueue);
>  
> @@ -748,7 +791,7 @@ static void cleanup_workqueue_thread(str
>  	 * checks list_empty(), and a "normal" queue_work() can't use
>  	 * a dead CPU.
>  	 */
> -	while (flush_cpu_workqueue(cwq))
> +	while (flush_cpu_workqueue(cwq, cpu))
>  		;
>  
>  	kthread_stop(cwq->thread);
> 



Jun  2 16:36:11 harley kernel: ERR!! events/1 flush hang: c201dbc0
c201dbc0 10012 10012
Jun  2 16:36:11 harley kernel: CURR: 7974 7974 vrsx 93 26
Jun  2 16:36:11 harley kernel:     wq_barrier_func+0x0/0x8
Jun  2 16:36:11 harley kernel:     vmstat_update+0x0/0x24
Jun  2 16:36:11 harley kernel:     ----
Jun  2 16:36:11 harley kernel:     cache_reap+0x0/0xf4
Jun  2 16:36:41 harley kernel: ERR!! events/1 flush hang: c201dbc0
c201dbc0 10012 10012
Jun  2 16:36:41 harley kernel: CURR: 7974 7974 vrsx 93 26
Jun  2 16:36:41 harley kernel:     wq_barrier_func+0x0/0x8
Jun  2 16:36:41 harley kernel:     vmstat_update+0x0/0x24
Jun  2 16:36:41 harley kernel:     ----
Jun  2 16:36:41 harley kernel:     cache_reap+0x0/0xf4
Jun  2 16:37:11 harley kernel: ERR!! events/1 flush hang: c201dbc0
c201dbc0 10012 10012
Jun  2 16:37:11 harley kernel: CURR: 7974 7974 vrsx 93 26
Jun  2 16:37:11 harley kernel:     wq_barrier_func+0x0/0x8
Jun  2 16:37:11 harley kernel:     vmstat_update+0x0/0x24
Jun  2 16:37:11 harley kernel:     ----
Jun  2 16:37:11 harley kernel:     cache_reap+0x0/0xf4
Jun  2 16:37:41 harley kernel: ERR!! events/1 flush hang: c201dbc0
c201dbc0 10012 10012
Jun  2 16:37:41 harley kernel: CURR: 7974 7974 vrsx 93 26
Jun  2 16:37:41 harley kernel:     wq_barrier_func+0x0/0x8
Jun  2 16:37:41 harley kernel:     vmstat_update+0x0/0x24
Jun  2 16:37:41 harley kernel:     ----
Jun  2 16:37:41 harley kernel:     cache_reap+0x0/0xf4
Jun  2 16:37:51 harley kernel: RTOM: In int handler for 12 usec.
Jun  2 16:38:11 harley kernel: ERR!! events/1 flush hang: c201dbc0
c201dbc0 10012 10012
Jun  2 16:38:11 harley kernel: CURR: 7974 7974 vrsx 93 26
Jun  2 16:38:11 harley kernel:     wq_barrier_func+0x0/0x8
Jun  2 16:38:11 harley kernel:     vmstat_update+0x0/0x24
Jun  2 16:38:11 harley kernel:     ----
Jun  2 16:38:11 harley kernel:     cache_reap+0x0/0xf4
Jun  2 16:38:41 harley kernel: ERR!! events/1 flush hang: c201dbc0
c201dbc0 10012 10012
Jun  2 16:38:41 harley kernel: CURR: 7974 7974 vrsx 93 26
Jun  2 16:38:41 harley kernel:     wq_barrier_func+0x0/0x8
Jun  2 16:38:41 harley kernel:     vmstat_update+0x0/0x24
Jun  2 16:38:41 harley kernel:     ----
Jun  2 16:38:41 harley kernel:     cache_reap+0x0/0xf4
Jun  2 16:39:11 harley kernel: ERR!! events/1 flush hang: c201dbc0
c201dbc0 10012 10012
Jun  2 16:39:11 harley kernel: CURR: 7974 7974 vrsx 93 26
Jun  2 16:39:11 harley kernel:     wq_barrier_func+0x0/0x8
Jun  2 16:39:11 harley kernel:     vmstat_update+0x0/0x24
Jun  2 16:39:11 harley kernel:     ----
Jun  2 16:39:11 harley kernel:     cache_reap+0x0/0xf4
Jun  2 16:39:41 harley kernel: ERR!! events/1 flush hang: c201dbc0
c201dbc0 10012 10012
Jun  2 16:39:41 harley kernel: CURR: 7974 7974 vrsx 93 26
Jun  2 16:39:41 harley kernel:     wq_barrier_func+0x0/0x8
Jun  2 16:39:41 harley kernel:     vmstat_update+0x0/0x24
Jun  2 16:39:41 harley kernel:     ----
Jun  2 16:39:41 harley kernel:     cache_reap+0x0/0xf4
Jun  2 16:40:11 harley kernel: ERR!! events/1 flush hang: c201dbc0
c201dbc0 10012 10012
Jun  2 16:40:11 harley kernel: CURR: 7974 7974 vrsx 93 26
Jun  2 16:40:11 harley kernel:     wq_barrier_func+0x0/0x8
Jun  2 16:40:11 harley kernel:     vmstat_update+0x0/0x24
Jun  2 16:40:11 harley kernel:     ----
Jun  2 16:40:11 harley kernel:     cache_reap+0x0/0xf4
Jun  2 16:40:41 harley kernel: ERR!! events/1 flush hang: c201dbc0
c201dbc0 10012 10012
Jun  2 16:40:41 harley kernel: CURR: 7974 7974 vrsx 93 26
Jun  2 16:40:41 harley kernel:     wq_barrier_func+0x0/0x8
Jun  2 16:40:41 harley kernel:     vmstat_update+0x0/0x24
Jun  2 16:40:41 harley kernel:     ----
Jun  2 16:40:41 harley kernel:     cache_reap+0x0/0xf4


Regards
Mark

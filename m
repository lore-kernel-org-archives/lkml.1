Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbXHARBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbXHARBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbXHARB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:01:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55079 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbXHARB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:01:26 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gregory Haskins <ghaskins@novell.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1185940340.2636.97.camel@imap.mvista.com>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net>
	 <1185940340.2636.97.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 19:01:03 +0200
Message-Id: <1185987663.12034.99.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(you guys forgot to CC Ingo, Oleg and me)

On Tue, 2007-07-31 at 20:52 -0700, Daniel Walker wrote:

> Here's a simpler version .. uses the plist data structure instead of the
> 100 queues, which makes for a cleaner patch ..
> 
> Signed-off-by: Daniel Walker <dwalker@mvista.com>

looks good, assuming you actually ran the code:

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

small nit below though..

> ---
>  include/linux/workqueue.h |    7 ++++---
>  kernel/power/poweroff.c   |    1 +
>  kernel/sched.c            |    4 ----
>  kernel/workqueue.c        |   40 +++++++++++++++++++++++++---------------
>  4 files changed, 30 insertions(+), 22 deletions(-)
> 
> Index: linux-2.6.22/include/linux/workqueue.h
> ===================================================================
> --- linux-2.6.22.orig/include/linux/workqueue.h
> +++ linux-2.6.22/include/linux/workqueue.h
> @@ -8,6 +8,7 @@
>  #include <linux/timer.h>
>  #include <linux/linkage.h>
>  #include <linux/bitops.h>
> +#include <linux/plist.h>
>  #include <asm/atomic.h>
>  
>  struct workqueue_struct;
> @@ -26,7 +27,7 @@ struct work_struct {
>  #define WORK_STRUCT_PENDING 0		/* T if work item pending execution */
>  #define WORK_STRUCT_FLAG_MASK (3UL)
>  #define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
> -	struct list_head entry;
> +	struct plist_node entry;
>  	work_func_t func;
>  };
>  
> @@ -43,7 +44,7 @@ struct execute_work {
>  
>  #define __WORK_INITIALIZER(n, f) {				\
>  	.data = WORK_DATA_INIT(),				\
> -	.entry	= { &(n).entry, &(n).entry },			\
> +	.entry	= PLIST_NODE_INIT(n.entry, MAX_PRIO),		\
>  	.func = (f),						\
>  	}
>  
> @@ -79,7 +80,7 @@ struct execute_work {
>  #define INIT_WORK(_work, _func)						\
>  	do {								\
>  		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
> -		INIT_LIST_HEAD(&(_work)->entry);			\
> +		plist_node_init(&(_work)->entry, -1);			\
>  		PREPARE_WORK((_work), (_func));				\
>  	} while (0)
>  
> Index: linux-2.6.22/kernel/power/poweroff.c
> ===================================================================
> --- linux-2.6.22.orig/kernel/power/poweroff.c
> +++ linux-2.6.22/kernel/power/poweroff.c
> @@ -8,6 +8,7 @@
>  #include <linux/sysrq.h>
>  #include <linux/init.h>
>  #include <linux/pm.h>
> +#include <linux/sched.h>
>  #include <linux/workqueue.h>
>  #include <linux/reboot.h>
>  
> Index: linux-2.6.22/kernel/sched.c
> ===================================================================
> --- linux-2.6.22.orig/kernel/sched.c
> +++ linux-2.6.22/kernel/sched.c
> @@ -4379,8 +4379,6 @@ long __sched sleep_on_timeout(wait_queue
>  }
>  EXPORT_SYMBOL(sleep_on_timeout);
>  
> -#ifdef CONFIG_RT_MUTEXES
> -
>  /*
>   * rt_mutex_setprio - set the current priority of a task
>   * @p: task
> @@ -4457,8 +4455,6 @@ out_unlock:
>  	task_rq_unlock(rq, &flags);
>  }
>  
> -#endif
> -
>  void set_user_nice(struct task_struct *p, long nice)
>  {
>  	int old_prio, delta, on_rq;
> Index: linux-2.6.22/kernel/workqueue.c
> ===================================================================
> --- linux-2.6.22.orig/kernel/workqueue.c
> +++ linux-2.6.22/kernel/workqueue.c
> @@ -44,7 +44,7 @@ struct cpu_workqueue_struct {
>  
>  	spinlock_t lock;
>  
> -	struct list_head worklist;
> +	struct plist_head worklist;
>  	wait_queue_head_t more_work;
>  	struct work_struct *current_work;
>  
> @@ -127,16 +127,19 @@ struct cpu_workqueue_struct *get_wq_data
>  static void insert_work(struct cpu_workqueue_struct *cwq,
>  				struct work_struct *work, int tail)
>  {
> +	int prio = current->normal_prio;
> +
>  	set_wq_data(work, cwq);
>  	/*
>  	 * Ensure that we get the right work->data if we see the
>  	 * result of list_add() below, see try_to_grab_pending().
>  	 */
>  	smp_wmb();
> -	if (tail)
> -		list_add_tail(&work->entry, &cwq->worklist);
> -	else
> -		list_add(&work->entry, &cwq->worklist);
> +	plist_node_init(&work->entry, prio);
> +	plist_add(&work->entry, &cwq->worklist);

perhaps we ought to handle tail, perhaps not, not sure what the
consequences are.

- Peter

> +
> +	if (prio < cwq->thread->prio)
> +		rt_mutex_setprio(cwq->thread, prio);
>  	wake_up(&cwq->more_work);
>  }
>  
> @@ -168,7 +171,7 @@ int fastcall queue_work(struct workqueue
>  	int ret = 0, cpu = raw_smp_processor_id();
>  
>  	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
> -		BUG_ON(!list_empty(&work->entry));
> +		BUG_ON(!plist_node_empty(&work->entry));
>  		__queue_work(wq_per_cpu(wq, cpu), work);
>  		ret = 1;
>  	}
> @@ -222,7 +225,7 @@ int queue_delayed_work_on(int cpu, struc
>  
>  	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
>  		BUG_ON(timer_pending(timer));
> -		BUG_ON(!list_empty(&work->entry));
> +		BUG_ON(!plist_node_empty(&work->entry));
>  
>  		/* This stores cwq for the moment, for the timer_fn */
>  		set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
> @@ -264,13 +267,17 @@ static void run_workqueue(struct cpu_wor
>  			__FUNCTION__, cwq->run_depth);
>  		dump_stack();
>  	}
> -	while (!list_empty(&cwq->worklist)) {
> -		struct work_struct *work = list_entry(cwq->worklist.next,
> +	while (!plist_head_empty(&cwq->worklist)) {
> +		struct work_struct *work = plist_first_entry(&cwq->worklist,
>  						struct work_struct, entry);
>  		work_func_t f = work->func;
>  
> +		if (likely(cwq->thread->prio != work->entry.prio))
> +			rt_mutex_setprio(cwq->thread, work->entry.prio);
> +
>  		cwq->current_work = work;
> -		list_del_init(cwq->worklist.next);
> +		plist_del(&work->entry, &cwq->worklist);
> +		plist_node_init(&work->entry, MAX_PRIO);
>  		spin_unlock_irq(&cwq->lock);
>  
>  		BUG_ON(get_wq_data(work) != cwq);
> @@ -283,6 +290,7 @@ static void run_workqueue(struct cpu_wor
>  		spin_lock_irq(&cwq->lock);
>  		cwq->current_work = NULL;
>  	}
> +	rt_mutex_setprio(cwq->thread, current->normal_prio);
>  	cwq->run_depth--;
>  	spin_unlock_irq(&cwq->lock);
>  }
> @@ -301,7 +309,7 @@ static int worker_thread(void *__cwq)
>  		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
>  		if (!freezing(current) &&
>  		    !kthread_should_stop() &&
> -		    list_empty(&cwq->worklist))
> +		    plist_head_empty(&cwq->worklist))
>  			schedule();
>  		finish_wait(&cwq->more_work, &wait);
>  
> @@ -354,7 +362,8 @@ static int flush_cpu_workqueue(struct cp
>  
>  		active = 0;
>  		spin_lock_irq(&cwq->lock);
> -		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
> +		if (!plist_head_empty(&cwq->worklist) ||
> +			cwq->current_work != NULL) {
>  			insert_wq_barrier(cwq, &barr, 1);
>  			active = 1;
>  		}
> @@ -413,7 +422,7 @@ static int try_to_grab_pending(struct wo
>  		return ret;
>  
>  	spin_lock_irq(&cwq->lock);
> -	if (!list_empty(&work->entry)) {
> +	if (!plist_node_empty(&work->entry)) {
>  		/*
>  		 * This work is queued, but perhaps we locked the wrong cwq.
>  		 * In that case we must see the new value after rmb(), see
> @@ -421,7 +430,8 @@ static int try_to_grab_pending(struct wo
>  		 */
>  		smp_rmb();
>  		if (cwq == get_wq_data(work)) {
> -			list_del_init(&work->entry);
> +			plist_del(&work->entry, &cwq->worklist);
> +			plist_node_init(&work->entry, MAX_PRIO);
>  			ret = 1;
>  		}
>  	}
> @@ -747,7 +757,7 @@ init_cpu_workqueue(struct workqueue_stru
>  
>  	cwq->wq = wq;
>  	spin_lock_init(&cwq->lock);
> -	INIT_LIST_HEAD(&cwq->worklist);
> +	plist_head_init(&cwq->worklist, NULL);
>  	init_waitqueue_head(&cwq->more_work);
>  
>  	return cwq;
> 



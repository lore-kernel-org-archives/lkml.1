Return-Path: <linux-kernel-owner+w=401wt.eu-S932531AbXBNUJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbXBNUJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932533AbXBNUJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:09:29 -0500
Received: from mail.screens.ru ([213.234.233.54]:60588 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531AbXBNUJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:09:28 -0500
Date: Wed, 14 Feb 2007 23:09:04 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070214200904.GB301@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214144305.GB19789@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214144305.GB19789@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Gautham R Shenoy wrote:
>
> This patch reverts all the recent workqueue hacks added to make it 
> hotplug safe. 

In my opinion these hacks are cleanups :)

Ok. If we use freezer then yes, we can remove cpu_populated_map and just
use for_each_online_cpu(). This is easy and good.

What else you don't like? Why do you want to remove cwq_should_stop() and
restore an ugly (ugly for workqueue.c) kthread_stop/kthread_should_stop() ?

We can restore take_over_works(), although I don't see why this is needed.
But cwq_should_stop() will just work regardless, why do you want to add
this "wait_to_die" ... well, hack :)

> -static DEFINE_MUTEX(workqueue_mutex);
> +static DEFINE_SPINLOCK(workqueue_lock);

No. We can't do this. see below.

>  struct workqueue_struct *__create_workqueue(const char *name,
>  					    int singlethread, int freezeable)
>  {
> @@ -798,17 +756,20 @@ struct workqueue_struct *__create_workqu
>  		INIT_LIST_HEAD(&wq->list);
>  		cwq = init_cpu_workqueue(wq, singlethread_cpu);
>  		err = create_workqueue_thread(cwq, singlethread_cpu);
> +		if (!err)
> +			wake_up_process(cwq->thread);
>  	} else {
> -		mutex_lock(&workqueue_mutex);
> +		spin_lock(&workqueue_lock);
>  		list_add(&wq->list, &workqueues);
> -
> -		for_each_possible_cpu(cpu) {
> +		spin_unlock(&workqueue_lock);
> +		for_each_online_cpu(cpu) {
>  			cwq = init_cpu_workqueue(wq, cpu);
> -			if (err || !(cpu_online(cpu) || cpu == embryonic_cpu))
> -				continue;
>  			err = create_workqueue_thread(cwq, cpu);
> +			if (err)
> +				break;

No, we can't break. We are going to execute destroy_workqueue(), it will
iterate over all cwqs.

> +static void take_over_work(struct workqueue_struct *wq, unsigned int cpu)
> +{
> +	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> +	struct list_head list;
> +	struct work_struct *work;
> +
> +	spin_lock_irq(&cwq->lock);
> +	list_replace_init(&cwq->worklist, &list);
> +
> +	while (!list_empty(&list)) {
> +		work = list_entry(list.next,struct work_struct,entry);
> +		list_del(&work->entry);
> +		__queue_work(per_cpu_ptr(wq->cpu_wq, smp_processor_id()), work);
> +	}
> +
> +	spin_unlock_irq(&cwq->lock);
> +}

I think this is unneeded complication, but ok, should work.

>  static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
>  						unsigned long action,
>  						void *hcpu)
> +	case CPU_UP_CANCELED:
> +		list_for_each_entry(wq, &workqueues, list) {
> +			if (!per_cpu_ptr(wq->cpu_wq, hotcpu)->thread)
> +				continue;
> +			/* Unbind so it can run. */
> +			kthread_bind(per_cpu_ptr(wq->cpu_wq, hotcpu)->thread,
> +				any_online_cpu(cpu_online_map));
> +			cleanup_workqueue_thread(wq, hotcpu);
>  		}
> +		break;
> +
> +	case CPU_DEAD:
> +		list_for_each_entry(wq, &workqueues, list)
> +			take_over_work(wq, hotcpu);
> +		break;
> +
> +	case CPU_DEAD_KILL_THREADS:
> +		list_for_each_entry(wq, &workqueues, list)
> +			cleanup_workqueue_thread(wq, hotcpu);
>  	}

Both CPU_UP_CANCELED and CPU_DEAD_KILL_THREADS runs after thaw_processes(),
this means that workqueue_cpu_callback() is racy wrt create/destroy workqueue,
we should take the mutex, and it can't be spinlock_t.

Oleg.


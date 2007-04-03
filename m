Return-Path: <linux-kernel-owner+w=401wt.eu-S965826AbXDCMnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965826AbXDCMnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 08:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965570AbXDCMnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 08:43:51 -0400
Received: from mail.screens.ru ([213.234.233.54]:40460 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965776AbXDCMnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 08:43:41 -0400
Date: Tue, 3 Apr 2007 15:47:29 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 7/8] Clean up workqueue.c with respect to the freezer based cpu-hotplug
Message-ID: <20070403114729.GA776@tv-sign.ru>
References: <20070402053457.GA9076@in.ibm.com> <20070402054206.GG12962@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402054206.GG12962@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On 04/02, Gautham R Shenoy wrote:
>
> Clean up workqueue.c from the perspective of freezer-based cpu-hotplug.
> This patch

I'll study these patches later, a couple of comments after the quick reading.

>   This means that all non-singlethreaded workqueues *have* to
>   be frozen to avoid any races.

We can't freeze workqueue if some work_struct continuously re-queues itself.
Perhaps this is not a problem (I don't see a good reason for such a behaviour),
but this should be documented.

>  static int worker_thread(void *__cwq)
>  {
>  	struct cpu_workqueue_struct *cwq = __cwq;
> +	int bind_cpu;
>  	DEFINE_WAIT(wait);
>  	struct k_sigaction sa;
>
>  	freezer_exempt(cwq->wq->freeze_exempt_events);
> -
> +	bind_cpu = smp_processor_id();
>  	/*
>  	 * We inherited MPOL_INTERLEAVE from the booting kernel.
>  	 * Set MPOL_DEFAULT to insure node local allocations.
> @@ -308,20 +287,28 @@ static int worker_thread(void *__cwq)
>  	siginitset(&sa.sa.sa_mask, sigmask(SIGCHLD));
>  	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
>
> -	for (;;) {
> +	while (!kthread_should_stop()) {
>  		try_to_freeze();
> -
> +
> +		if (cpu_is_offline(bind_cpu) && !is_single_threaded(cwq->wq))
> +			goto wait_to_die;
> +
>  		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
> -		if (cwq->status == CWQ_RUNNING && list_empty(&cwq->worklist))
> +		if (list_empty(&cwq->worklist))
>  			schedule();
>  		finish_wait(&cwq->more_work, &wait);
>
> -		if (cwq_should_stop(cwq))
> -			break;
> -
>  		run_workqueue(cwq);
>  	}
>
> +wait_to_die:
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	while(!kthread_should_stop()) {
> +		schedule();
> +		set_current_state(TASK_INTERRUPTIBLE);
> +	}
> +	__set_current_state(TASK_RUNNING);
> +
>  	return 0;
>  }

I still think that wait_to_die + bind_cpu is unneeded complication.
Why can't we do the following:

	static int worker_thread(void *__cwq)
	{
		...

		for (;;) {
			try_to_freeze();

			prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
			if (!kthread_should_stop() && list_empty(&cwq->worklist))
				schedule();
			finish_wait(&cwq->more_work, &wait);

			if (kthread_should_stop(cwq))
				break;

			run_workqueue(cwq);
		}

		return 0;
	}

?

>  void fastcall flush_workqueue(struct workqueue_struct *wq)
>  {
> -	const cpumask_t *cpu_map = wq_cpu_map(wq);
>  	int cpu;
>
>  	might_sleep();
> -	for_each_cpu_mask(cpu, *cpu_map)
> +	for_each_online_cpu(cpu)
>  		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
>  }

Hm... I can't understand this change. I believe it is wrong.

> @@ -644,13 +630,6 @@ static int create_workqueue_thread(struc
>  		return PTR_ERR(p);
>
>  	cwq->thread = p;
> -	cwq->status = CWQ_RUNNING;
> -	if (!is_single_threaded(wq))
> -		kthread_bind(p, cpu);
> -
> -	if (is_single_threaded(wq) || cpu_online(cpu))
> -		wake_up_process(p);
> -
>  	return 0;
>  }

Well, this is a matter of taste, but I don't like this change. Now we
should add kthread_bind/wake_up_process calls to __create_workqueue()
and workqueue_cpu_callback(). I won't persist though.

> @@ -680,15 +659,21 @@ static struct workqueue_struct *__create
>  	if (singlethread) {
>  		cwq = init_cpu_workqueue(wq, singlethread_cpu);
>  		err = create_workqueue_thread(cwq, singlethread_cpu);
> +		wake_up_process(cwq->thread);
>  	} else {
>  		mutex_lock(&workqueue_mutex);
>  		list_add(&wq->list, &workqueues);
>
> -		for_each_possible_cpu(cpu) {
> +		for_each_online_cpu(cpu) {

This is wrong. CPU_UP_PREPARE doesn't call init_cpu_workqueue().
Easy to fix, but I personally think is is better to initialize
the whole cpu_possible_map.

>  static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
>  {
> -	struct wq_barrier barr;
> -	int alive = 0;
>
> -	spin_lock_irq(&cwq->lock);
>  	if (cwq->thread != NULL) {
> -		insert_wq_barrier(cwq, &barr, 1);
> -		cwq->status = CWQ_SHOULD_STOP;
> -		alive = 1;
> -	}
> -	spin_unlock_irq(&cwq->lock);
> -
> -	if (alive) {
>  		thaw_process(cwq->thread);
> -		wait_for_completion(&barr.done);
> -
> -		while (unlikely(cwq->status != CWQ_STOPPED))
> -			cpu_relax();
> -		/*
> -		 * Wait until cwq->thread unlocks cwq->lock,
> -		 * it won't touch *cwq after that.
> -		 */
> -		smp_rmb();
> +		kthread_stop(cwq->thread);
>  		cwq->thread = NULL;
> -		spin_unlock_wait(&cwq->lock);
>  	}
>  }

Deadlockable. Suppose that the freezing is in progress, cwq->thread is not
frozen yet. cleanup_workqueue_thread() calls thaw_process(cwq->thread),
then cwq->thread() goes to refrigerator, kthread_stop() blocks forever.

> +static void take_over_work(struct workqueue_struct *wq, unsigned int cpu)
> +{
> +	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> +	struct list_head list;
> +	struct work_struct *work;
> +
> +	spin_lock_irq(&cwq->lock);

This CPU is dead (or cancelled), we don't need cwq->lock.

>  static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
>  						unsigned long action,
>  						void *hcpu)
> @@ -782,11 +768,6 @@ static int __devinit workqueue_cpu_callb
>  	struct cpu_workqueue_struct *cwq;
>  	struct workqueue_struct *wq;
>
> -	switch (action) {
> -	case CPU_UP_PREPARE:
> -		cpu_set(cpu, cpu_populated_map);
> -	}
> -
>  	mutex_lock(&workqueue_mutex);
>  	list_for_each_entry(wq, &workqueues, list) {
>  		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> @@ -799,6 +780,7 @@ static int __devinit workqueue_cpu_callb
>  			return NOTIFY_BAD;
>
>  		case CPU_ONLINE:
> +			kthread_bind(cwq->thread, cpu);
>  			wake_up_process(cwq->thread);
>  			break;
>
> @@ -806,6 +788,7 @@ static int __devinit workqueue_cpu_callb
>  			if (cwq->thread)
>  				wake_up_process(cwq->thread);
>  		case CPU_DEAD:
> +			take_over_work(wq, cpu);
>  			cleanup_workqueue_thread(cwq, cpu);
>  			break;
>  		}

This means that the work_struct on single_threaded wq can't use any of

	__create_workqueue()
	destroy_workqueue()
	flush_workqueue()
	cancel_work_sync()

, they are all racy wrt workqueue_cpu_callback(), and we don't freeze
single_threaded workqueues. This is bad.

Probaly we should:

	- freeze all workqueues, even the single_threaded ones.

	- helper_init() explicitely does __create_workqueue(FE_ALL).
	  this means that we should never use the functions above
	  with this workqueue.

Oleg.


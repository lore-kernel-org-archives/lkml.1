Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbZHYOu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbZHYOu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbZHYOu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:50:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbZHYOuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:50:55 -0400
Date: Tue, 25 Aug 2009 11:50:39 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH -rt] perf_counters: defer poll() wakeups to softirq
Message-ID: <20090825145039.GD16110@ghostprotocols.net>
References: <1251208265.7538.1157.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251208265.7538.1157.camel@twins>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 25, 2009 at 03:51:05PM +0200, Peter Zijlstra escreveu:
> Use timer softirq for wakeups on preempt_rt
> 
> Normally pending work is work that cannot be done from NMI context, such
> as wakeups and disabling the counter. The pending work is a single
> linked list using atomic ops so that it functions from NMI context.
> 
> Normally this is called from IRQ context through use of an self-IPI
> (x86) or upon enabling hard interrupts (powerpc). Architectures that do
> not implement perf_counter_set_pending() nor call
> perf_counter_do_pending() upon leaving NMI context will get a polling
> fallback from the timer softirq.
> 
> However, in -rt we cannot do the wakeup from IRQ context because its a
> wait_queue wakup, which can be O(n), so defer all wakeups to the softirq
> fallback by creating a second pending list that's only processed from
> there.
> 
> [ not tested at all... ]

Thanks a lot, no crashes, tons of samples collected, looks fine after:

[root@hs21xm-2 ~]# uptime
 09:49:48 up 38 min,  3 users,  load average: 2.77, 18.72, 25.09

Will continue testing, but I guess I can give a:

Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/perf_counter.h |    5 +++
>  kernel/perf_counter.c        |   61 +++++++++++++++++++++++++++++++++--------
>  kernel/timer.c               |    2 +-
>  4 files changed, 65 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
> index 972f90d..e61eee1 100644
> --- a/include/linux/perf_counter.h
> +++ b/include/linux/perf_counter.h
> @@ -612,6 +612,9 @@ struct perf_counter {
>  	int				pending_kill;
>  	int				pending_disable;
>  	struct perf_pending_entry	pending;
> +#ifdef CONFIG_PREEMPT_RT
> +	struct perf_pending_entry	pending_softirq;
> +#endif
>  
>  	atomic_t			event_limit;
>  
> @@ -703,6 +706,7 @@ extern void perf_counter_exit_task(struct task_struct *child);
>  extern void perf_counter_free_task(struct task_struct *task);
>  extern void set_perf_counter_pending(void);
>  extern void perf_counter_do_pending(void);
> +extern void perf_counter_do_pending_softirq(void);
>  extern void perf_counter_print_debug(void);
>  extern void __perf_disable(void);
>  extern bool __perf_enable(void);
> @@ -787,6 +791,7 @@ static inline int perf_counter_init_task(struct task_struct *child)	{ return 0;
>  static inline void perf_counter_exit_task(struct task_struct *child)	{ }
>  static inline void perf_counter_free_task(struct task_struct *task)	{ }
>  static inline void perf_counter_do_pending(void)			{ }
> +static inline void perf_counter_do_pending_softirq(void)		{ }
>  static inline void perf_counter_print_debug(void)			{ }
>  static inline void perf_disable(void)					{ }
>  static inline void perf_enable(void)					{ }
> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> index 53abcbe..d3b065d 100644
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -2397,45 +2397,69 @@ static void perf_pending_counter(struct perf_pending_entry *entry)
>  		__perf_counter_disable(counter);
>  	}
>  
> +#ifndef CONFIG_PREEMPT_RT
>  	if (counter->pending_wakeup) {
>  		counter->pending_wakeup = 0;
>  		perf_counter_wakeup(counter);
>  	}
> +#endif
>  }
>  
> +#ifdef CONFIG_PREEMPT_RT
> +static void perf_pending_counter_softirq(struct perf_pending_entry *entry)
> +{
> +	struct perf_counter *counter = container_of(entry,
> +			struct perf_counter, pending_softirq);
> +
> +	if (counter->pending_wakeup) {
> +		counter->pending_wakeup = 0;
> +		perf_counter_wakeup(counter);
> +	}
> +}
> +#endif
> +
>  #define PENDING_TAIL ((struct perf_pending_entry *)-1UL)
>  
>  static DEFINE_PER_CPU(struct perf_pending_entry *, perf_pending_head) = {
>  	PENDING_TAIL,
>  };
>  
> -static void perf_pending_queue(struct perf_pending_entry *entry,
> -			       void (*func)(struct perf_pending_entry *))
> -{
> -	struct perf_pending_entry **head;
> +static DEFINE_PER_CPU(struct perf_pending_entry *, perf_pending_softirq_head) = {
> +	PENDING_TAIL,
> +};
>  
> +static void __perf_pending_queue(struct perf_pending_entry **head,
> +				 struct perf_pending_entry *entry,
> +			         void (*func)(struct perf_pending_entry *))
> +{
>  	if (cmpxchg(&entry->next, NULL, PENDING_TAIL) != NULL)
>  		return;
>  
>  	entry->func = func;
>  
> -	head = &get_cpu_var(perf_pending_head);
> -
>  	do {
>  		entry->next = *head;
>  	} while (cmpxchg(head, entry->next, entry) != entry->next);
> +}
>  
> -	set_perf_counter_pending();
> +static void perf_pending_queue(struct perf_pending_entry *entry,
> +			       void (*func)(struct perf_pending_entry *))
> +{
> +	struct perf_pending_entry **head;
> +       
> +	head = &get_cpu_var(perf_pending_head);
> +	__perf_pending_queue(head, entry, func);
> +	put_cpu_var(perf_pending_head);
>  
> -	put_cpu_var(perf_pending_head);
> +	set_perf_counter_pending();
>  }
>  
> -static int __perf_pending_run(void)
> +static int __perf_pending_run(struct perf_pending_entry **head)
>  {
>  	struct perf_pending_entry *list;
>  	int nr = 0;
>  
> -	list = xchg(&__get_cpu_var(perf_pending_head), PENDING_TAIL);
> +	list = xchg(head, PENDING_TAIL);
>  	while (list != PENDING_TAIL) {
>  		void (*func)(struct perf_pending_entry *);
>  		struct perf_pending_entry *entry = list;
> @@ -2465,7 +2489,8 @@ static inline int perf_not_pending(struct perf_counter *counter)
>  	 * need to wait.
>  	 */
>  	get_cpu();
> -	__perf_pending_run();
> +	__perf_pending_run(&__get_cpu_var(perf_pending_head));
> +	__perf_pending_run(&__get_cpu_var(perf_pending_softirq_head));
>  	put_cpu();
>  
>  	/*
> @@ -2483,7 +2508,13 @@ static void perf_pending_sync(struct perf_counter *counter)
>  
>  void perf_counter_do_pending(void)
>  {
> -	__perf_pending_run();
> +	__perf_pending_run(&__get_cpu_var(perf_pending_head));
> +}
> +
> +void perf_counter_do_pending_softirq(void)
> +{
> +	__perf_pending_run(&__get_cpu_var(perf_pending_head));
> +	__perf_pending_run(&__get_cpu_var(perf_pending_softirq_head));
>  }
>  
>  /*
> @@ -2543,8 +2574,14 @@ static void perf_output_wakeup(struct perf_output_handle *handle)
>  
>  	if (handle->nmi) {
>  		handle->counter->pending_wakeup = 1;
> +#ifndef CONFIG_PREEMPT_RT
>  		perf_pending_queue(&handle->counter->pending,
>  				   perf_pending_counter);
> +#else
> +		__perf_pending_queue(&__get_cpu_var(perf_pending_softirq_head),
> +				     &handle->counter->pending_softirq,
> +				     perf_pending_counter_softirq);
> +#endif
>  	} else
>  		perf_counter_wakeup(handle->counter);
>  }
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 33fc9d1..1dd1456 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1188,7 +1188,7 @@ static void run_timer_softirq(struct softirq_action *h)
>  {
>  	struct tvec_base *base = __get_cpu_var(tvec_bases);
>  
> -	perf_counter_do_pending();
> +	perf_counter_do_pending_softirq();
>  
>  	hrtimer_run_pending();
>  

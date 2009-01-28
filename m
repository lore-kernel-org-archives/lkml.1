Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbZA1IUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbZA1IUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 03:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZA1IU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 03:20:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:52405 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbZA1IU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 03:20:29 -0500
Subject: Re: [PATCH v3] timer: implement lockdep deadlock detection
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1233082650.4455.9.camel@johannes.local>
References: <1233010786.4344.1.camel@johannes.local>
	 <20090126230721.GA6556@elte.hu> <1233046009.4012.3.camel@johannes.local>
	 <20090127132759.GI23121@elte.hu>  <20090127134128.GA24965@elte.hu>
	 <1233079597.4755.2.camel@johannes.local> <1233081027.10992.21.camel@laptop>
	 <1233082650.4455.9.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 09:20:15 +0100
Message-Id: <1233130815.10992.39.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 19:57 +0100, Johannes Berg wrote:
> This modifies the timer code in a way to allow lockdep to detect
> deadlocks resulting from a lock being taken in the timer function
> as well as around the del_timer_sync() call.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Nice, thanks!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
> Ingo, do you want an incremental patch instead?
> 
> v2: fix coding/comment style
> v3: accept freeing timer from timer function, fix init_timer_on_stack
>     in no-lockdep case
> 
>  include/linux/timer.h |  103 ++++++++++++++++++++++++++++++++++++++++++--------
>  kernel/timer.c        |   70 ++++++++++++++++++++++++++++-----
>  2 files changed, 146 insertions(+), 27 deletions(-)
> 
> --- wireless-testing.orig/include/linux/timer.h	2009-01-27 10:12:22.000000000 +0100
> +++ wireless-testing/include/linux/timer.h	2009-01-27 19:52:33.000000000 +0100
> @@ -21,52 +21,125 @@ struct timer_list {
>  	char start_comm[16];
>  	int start_pid;
>  #endif
> +#ifdef CONFIG_LOCKDEP
> +	struct lockdep_map lockdep_map;
> +#endif
>  };
>  
>  extern struct tvec_base boot_tvec_bases;
>  
> -#define TIMER_INITIALIZER(_function, _expires, _data) {		\
> -		.entry = { .prev = TIMER_ENTRY_STATIC },	\
> -		.function = (_function),			\
> -		.expires = (_expires),				\
> -		.data = (_data),				\
> -		.base = &boot_tvec_bases,			\
> +#ifdef CONFIG_LOCKDEP
> +/*
> + * NB: because we have to copy the lockdep_map, setting _key
> + * here is required, otherwise it could get initialised to the
> + * copy of the lockdep_map! We use the function pointer as the
> + * lockdep key here.
> + */
> +#define __TIMER_LOCKDEP_MAP_INITIALIZER(fn, name)		\
> +	.lockdep_map = STATIC_LOCKDEP_MAP_INIT(name, fn),
> +#else
> +#define __TIMER_LOCKDEP_MAP_INITIALIZER(fn, name)
> +#endif
> +
> +#define TIMER_INITIALIZER(_function, _expires, _data) {			\
> +		.entry = { .prev = TIMER_ENTRY_STATIC },		\
> +		.function = (_function),				\
> +		.expires = (_expires),					\
> +		.data = (_data),					\
> +		.base = &boot_tvec_bases,				\
> +		__TIMER_LOCKDEP_MAP_INITIALIZER((_function), #_function)\
>  	}
>  
>  #define DEFINE_TIMER(_name, _function, _expires, _data)		\
>  	struct timer_list _name =				\
>  		TIMER_INITIALIZER(_function, _expires, _data)
>  
> -void init_timer(struct timer_list *timer);
> -void init_timer_deferrable(struct timer_list *timer);
> +void init_timer_key(struct timer_list *timer,
> +		    const char *name,
> +		    struct lock_class_key *key);
> +void init_timer_deferrable_key(struct timer_list *timer,
> +			       const char *name,
> +			       struct lock_class_key *key);
> +
> +#ifdef CONFIG_LOCKDEP
> +#define init_timer(timer)						\
> +	do {								\
> +		static struct lock_class_key __key;			\
> +		init_timer_key((timer), #timer, &__key);		\
> +	} while (0)
> +
> +#define init_timer_deferrable(timer)					\
> +	do {								\
> +		static struct lock_class_key __key;			\
> +		init_timer_deferrable_key((timer), #timer, &__key);	\
> +	} while (0)
> +
> +#define init_timer_on_stack(timer)					\
> +	do {								\
> +		static struct lock_class_key __key;			\
> +		init_timer_on_stack_key((timer), #timer, &__key);	\
> +	} while (0)
> +
> +#define setup_timer(timer, fn, data)					\
> +	do {								\
> +		static struct lock_class_key __key;			\
> +		setup_timer_key((timer), #timer, &__key, (fn), (data));\
> +	} while (0)
> +
> +#define setup_timer_on_stack(timer, fn, data)				\
> +	do {								\
> +		static struct lock_class_key __key;			\
> +		setup_timer_on_stack_key((timer), #timer, &__key,	\
> +					 (fn), (data));			\
> +	} while (0)
> +#else
> +#define init_timer(timer)\
> +	init_timer_key((timer), NULL, NULL)
> +#define init_timer_deferrable(timer)\
> +	init_timer_deferrable_key((timer), NULL, NULL)
> +#define init_timer_on_stack(timer)\
> +	init_timer_on_stack_key((timer), NULL, NULL)
> +#define setup_timer(timer, fn, data)\
> +	setup_timer_key((timer), NULL, NULL, (fn), (data))
> +#define setup_timer_on_stack(timer, fn, data)\
> +	setup_timer_on_stack_key((timer), NULL, NULL, (fn), (data))
> +#endif
>  
>  #ifdef CONFIG_DEBUG_OBJECTS_TIMERS
> -extern void init_timer_on_stack(struct timer_list *timer);
> +extern void init_timer_on_stack_key(struct timer_list *timer,
> +				    const char *name,
> +				    struct lock_class_key *key);
>  extern void destroy_timer_on_stack(struct timer_list *timer);
>  #else
>  static inline void destroy_timer_on_stack(struct timer_list *timer) { }
> -static inline void init_timer_on_stack(struct timer_list *timer)
> +static inline void init_timer_on_stack_key(struct timer_list *timer,
> +					   const char *name,
> +					   struct lock_class_key *key)
>  {
> -	init_timer(timer);
> +	init_timer_key(timer, name, key);
>  }
>  #endif
>  
> -static inline void setup_timer(struct timer_list * timer,
> +static inline void setup_timer_key(struct timer_list * timer,
> +				const char *name,
> +				struct lock_class_key *key,
>  				void (*function)(unsigned long),
>  				unsigned long data)
>  {
>  	timer->function = function;
>  	timer->data = data;
> -	init_timer(timer);
> +	init_timer_key(timer, name, key);
>  }
>  
> -static inline void setup_timer_on_stack(struct timer_list *timer,
> +static inline void setup_timer_on_stack_key(struct timer_list *timer,
> +					const char *name,
> +					struct lock_class_key *key,
>  					void (*function)(unsigned long),
>  					unsigned long data)
>  {
>  	timer->function = function;
>  	timer->data = data;
> -	init_timer_on_stack(timer);
> +	init_timer_on_stack_key(timer, name, key);
>  }
>  
>  /**
> --- wireless-testing.orig/kernel/timer.c	2009-01-27 10:12:22.000000000 +0100
> +++ wireless-testing/kernel/timer.c	2009-01-27 19:50:36.000000000 +0100
> @@ -491,14 +491,18 @@ static inline void debug_timer_free(stru
>  	debug_object_free(timer, &timer_debug_descr);
>  }
>  
> -static void __init_timer(struct timer_list *timer);
> -
> -void init_timer_on_stack(struct timer_list *timer)
> +static void __init_timer(struct timer_list *timer,
> +			 const char *name,
> +			 struct lock_class_key *key);
> +
> +void init_timer_on_stack_key(struct timer_list *timer,
> +			     const char *name,
> +			     struct lock_class_key *key)
>  {
>  	debug_object_init_on_stack(timer, &timer_debug_descr);
> -	__init_timer(timer);
> +	__init_timer(timer, name, key);
>  }
> -EXPORT_SYMBOL_GPL(init_timer_on_stack);
> +EXPORT_SYMBOL_GPL(init_timer_on_stack_key);
>  
>  void destroy_timer_on_stack(struct timer_list *timer)
>  {
> @@ -512,7 +516,9 @@ static inline void debug_timer_activate(
>  static inline void debug_timer_deactivate(struct timer_list *timer) { }
>  #endif
>  
> -static void __init_timer(struct timer_list *timer)
> +static void __init_timer(struct timer_list *timer,
> +			 const char *name,
> +			 struct lock_class_key *key)
>  {
>  	timer->entry.next = NULL;
>  	timer->base = __raw_get_cpu_var(tvec_bases);
> @@ -521,6 +527,7 @@ static void __init_timer(struct timer_li
>  	timer->start_pid = -1;
>  	memset(timer->start_comm, 0, TASK_COMM_LEN);
>  #endif
> +	lockdep_init_map(&timer->lockdep_map, name, key, 0);
>  }
>  
>  /**
> @@ -530,19 +537,23 @@ static void __init_timer(struct timer_li
>   * init_timer() must be done to a timer prior calling *any* of the
>   * other timer functions.
>   */
> -void init_timer(struct timer_list *timer)
> +void init_timer_key(struct timer_list *timer,
> +		    const char *name,
> +		    struct lock_class_key *key)
>  {
>  	debug_timer_init(timer);
> -	__init_timer(timer);
> +	__init_timer(timer, name, key);
>  }
> -EXPORT_SYMBOL(init_timer);
> +EXPORT_SYMBOL(init_timer_key);
>  
> -void init_timer_deferrable(struct timer_list *timer)
> +void init_timer_deferrable_key(struct timer_list *timer,
> +			       const char *name,
> +			       struct lock_class_key *key)
>  {
> -	init_timer(timer);
> +	init_timer_key(timer, name, key);
>  	timer_set_deferrable(timer);
>  }
> -EXPORT_SYMBOL(init_timer_deferrable);
> +EXPORT_SYMBOL(init_timer_deferrable_key);
>  
>  static inline void detach_timer(struct timer_list *timer,
>  				int clear_pending)
> @@ -789,6 +800,15 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
>   */
>  int del_timer_sync(struct timer_list *timer)
>  {
> +#ifdef CONFIG_LOCKDEP
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	lock_map_acquire(&timer->lockdep_map);
> +	lock_map_release(&timer->lockdep_map);
> +	local_irq_restore(flags);
> +#endif
> +
>  	for (;;) {
>  		int ret = try_to_del_timer_sync(timer);
>  		if (ret >= 0)
> @@ -861,10 +881,36 @@ static inline void __run_timers(struct t
>  
>  			set_running_timer(base, timer);
>  			detach_timer(timer, 1);
> +
>  			spin_unlock_irq(&base->lock);
>  			{
>  				int preempt_count = preempt_count();
> +
> +#ifdef CONFIG_LOCKDEP
> +				/*
> +				 * It is permissible to free the timer from
> +				 * inside the function that is called from
> +				 * it, this we need to take into account for
> +				 * lockdep too. To avoid bogus "held lock
> +				 * freed" warnings as well as problems when
> +				 * looking into timer->lockdep_map, make a
> +				 * copy and use that here.
> +				 */
> +				struct lockdep_map lockdep_map =
> +					timer->lockdep_map;
> +#endif
> +				/*
> +				 * Couple the lock chain with the lock chain at
> +				 * del_timer_sync() by acquiring the lock_map
> +				 * around the fn() call here and in
> +				 * del_timer_sync().
> +				 */
> +				lock_map_acquire(&lockdep_map);
> +
>  				fn(data);
> +
> +				lock_map_release(&lockdep_map);
> +
>  				if (preempt_count != preempt_count()) {
>  					printk(KERN_ERR "huh, entered %p "
>  					       "with preempt_count %08x, exited"
> 
> 


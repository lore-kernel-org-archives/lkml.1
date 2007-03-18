Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbXCRIKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbXCRIKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 04:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbXCRIKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 04:10:43 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59296 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbXCRIKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 04:10:41 -0400
Date: Sun, 18 Mar 2007 00:10:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>, tglx@linutronix.de,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Add not_critical_when_idle timer
Message-Id: <20070318001028.15219305.akpm@linux-foundation.org>
In-Reply-To: <20070316220734.GA6109@linux-os.sc.intel.com>
References: <20070316220734.GA6109@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 15:07:35 -0700 Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> 
> Introduce a new kind of timers - not_critical_when_idle timers:
> Timers that work normally when system is busy. But, will not cause CPU to
> come out of idle (just to service this timer), when CPU is idle. Instead,
> this timer will be serviced when CPU eventually wakes up with a subsequent
> critical_when_idle timer.
> 
> The main advantage of this is to avoid unnecessary timer interrupts when
> CPU is idle. If the routine currently called by a timer can wait until next
> event without any issues, this new timer can be used to setup timer event
> for that routine. This, with dynticks, allows CPUs to be lazy, allowing them
> to stay in idle for extended period of time by reducing unnecesary wakeup and
> thereby reducing the power consumption.
> 
> This patch:
> Builds this new timer on top of existing timer infrastructure. It uses
> last bit in 'base' pointer of timer_list structure to store this
> extra information about timer. __next_timer_interrupt() function
> skips over these not_critical_when_idle timers when CPU looks for
> next timer event for which it has to wake up.

Fair enough, I guess.

> This is exported by a new interface add_timer_with_hint() and also a new
> parameter is added to existing add_timer_on() interface.
> 

A few cosmetic and interface things:

> --- linux-2.6.20.orig/kernel/timer.c	2007-03-16 14:13:19.000000000 -0700
> +++ linux-2.6.20/kernel/timer.c	2007-03-16 14:51:15.000000000 -0700
> @@ -74,7 +74,7 @@
>  	tvec_t tv3;
>  	tvec_t tv4;
>  	tvec_t tv5;
> -} ____cacheline_aligned_in_smp;
> +} ____cacheline_aligned;

hm, that's an unrelated bugfix.

> ...
>
> +extern struct tvec_t_base_s boot_tvec_bases;
> +/*
> + * Note that all tvec_bases is 2 byte aligned and lower bit of
> + * base in timer_list is guaranteed to be zero. Use the LSB for
> + * the new flag to indicate whether it is OK to skip timer callback
> + * when CPU is idle.
> + */
> +#define TBASE_FLAG_DELAYED_ON_IDLE		(0x1)
> +
> +#define TBASE_GET_BASE_PTR(x)						\
> +	((struct tvec_t_base_s *)((unsigned long)x &			\
> +	                          (~TBASE_FLAG_DELAYED_ON_IDLE)))
> +
> +#define TBASE_GET_DELAYED_ON_IDLE(x)					\
> +	((unsigned long)x & TBASE_FLAG_DELAYED_ON_IDLE)
> +
> +#define TBASE_SET_DELAYED_ON_IDLE(x)					\
> +	((struct tvec_t_base_s *)((unsigned long)x |			\
> +	                          TBASE_FLAG_DELAYED_ON_IDLE))
> +
> +#define TBASE_CLEAR_DELAYED_ON_IDLE(x)					\
> +	((struct tvec_t_base_s *)((unsigned long)x &			\
> +	                          (~TBASE_FLAG_DELAYED_ON_IDLE)))
> +
> +#define TBASE_MERGE_DELAYED_ON_IDLE(x,f)				\
> +	((f) ? TBASE_SET_DELAYED_ON_IDLE(x) : TBASE_CLEAR_DELAYED_ON_IDLE(x))

Can we implement these as lower-case-named inline functions?  I don't think
there's any reason why they have to be macros?

>  struct timer_list {
>  	struct list_head entry;
>  	unsigned long expires;
> @@ -23,7 +50,6 @@
>  #endif
>  };
>  
> -extern struct tvec_t_base_s boot_tvec_bases;
>  
>  #define TIMER_INITIALIZER(_function, _expires, _data) {		\
>  		.function = (_function),			\
> @@ -62,7 +88,8 @@
>  	return timer->entry.next != NULL;
>  }
>  
> -extern void add_timer_on(struct timer_list *timer, int cpu);
> +extern void add_timer_on(struct timer_list *timer, int cpu,
> +                         int not_critical_when_idle);

That `not_critical_when_idle' is a real mouthful.  Could we just use
"deferrable"?  With a nice comment in a strategic spot which explains what
it's all about?

>  extern int del_timer(struct timer_list * timer);
>  extern int __mod_timer(struct timer_list *timer, unsigned long expires);
>  extern int mod_timer(struct timer_list *timer, unsigned long expires);
> @@ -144,6 +171,16 @@
>  static inline void add_timer(struct timer_list *timer)
>  {
>  	BUG_ON(timer_pending(timer));
> +	timer->base = TBASE_CLEAR_DELAYED_ON_IDLE(timer->base);
> +	__mod_timer(timer, timer->expires);
> +}
> +
> +static inline void add_timer_with_hint(struct timer_list *timer,
> +                                       int not_critical_when_idle)
> +{
> +	BUG_ON(timer_pending(timer));
> +	timer->base = TBASE_MERGE_DELAYED_ON_IDLE(timer->base,
> +	                                          not_critical_when_idle);
>  	__mod_timer(timer, timer->expires);
>  }

I'm not sure I really like the idea of modifying a timer's state when
installing it.  Plus mod_timer() is a superset of add_timer(), and people
might want to use mod_timer().

I think it would be better to specify the type of the timer when we're
initialising it, not when we're installing it.

So would it not be nicer to do:

	setup_deferrable_timer(timer, my_handler, my_data);
	add_timer(timer, whenever);
or
	mod_timer(timer, whenever);

?

> -			add_timer_on(timer, cpu);
> +			add_timer_on(timer, cpu, 0);

OK.



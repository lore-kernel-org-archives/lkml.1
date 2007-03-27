Return-Path: <linux-kernel-owner+w=401wt.eu-S934217AbXC0WWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934217AbXC0WWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934219AbXC0WWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:22:36 -0400
Received: from mail.screens.ru ([213.234.233.54]:38746 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934217AbXC0WWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:22:35 -0400
Date: Wed, 28 Mar 2007 02:22:27 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       davej@codemonkey.org.uk, johnstul@us.ibm.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] Add support for deferrable timers (respun)
Message-ID: <20070327222227.GA279@tv-sign.ru>
References: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net> <20070322140532.GA120@tv-sign.ru> <20070322151817.GA29840@linux-os.sc.intel.com> <20070322161355.GA160@tv-sign.ru> <20070327204344.GA21529@linux-os.sc.intel.com> <20070327211145.GB216@tv-sign.ru> <20070327215542.GA27408@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327215542.GA27408@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27, Venki Pallipadi wrote:
>
> Incremental patch below eliminates this race.
>
> Index: new/kernel/timer.c
> ===================================================================
> --- new.orig/kernel/timer.c	2007-03-26 15:19:35.000000000 -0800
> +++ new/kernel/timer.c	2007-03-27 13:00:33.000000000 -0800
> @@ -96,9 +96,9 @@
>  	return tbase_get_deferrable(timer->base);
>  }
>  
> -static inline struct tvec_t_base_s *timer_get_base(struct timer_list *timer)
> +static inline struct tvec_t_base_s *tbase_get_base(struct tvec_t_base_s *base)
>  {
> -	return ((struct tvec_t_base_s *)((unsigned long)(timer->base) &
> +	return ((struct tvec_t_base_s *)((unsigned long)base &
>  	                                 ~TBASE_DEFERRABLE_FLAG));
>  }
>  
> @@ -368,7 +368,7 @@
>  
>  	for (;;) {
>  		tvec_base_t *prelock_base = timer->base;
> -		base = timer_get_base(timer);
> +		base = tbase_get_base(prelock_base);
>  		if (likely(base != NULL)) {
>  			spin_lock_irqsave(&base->lock, *flags);
>  			if (likely(prelock_base == timer->base))

Looks correct to me... Personally, I'd prefer

	static tvec_base_t *lock_timer_base(struct timer_list *timer,
						unsigned long *flags)
		__acquires(timer->base->lock)
	{
		tvec_base_t *base;

		for (;;) {
			base = timer_get_base(timer);
			if (likely(base != NULL)) {
				spin_lock_irqsave(&base->lock, *flags);
				if (likely(base == timer_get_base(timer))
					return base;
				/* The timer has migrated to another CPU */
				spin_unlock_irqrestore(&base->lock, *flags);
			}
			cpu_relax();
		}
	}

but this is a matter of taste.

A minor nitpick,

> +/* new_base is guaranteed to have last bit not set, in all callers below */
> +static inline void timer_set_base(struct timer_list *timer,
> +                                       struct tvec_t_base_s *old_base,
> +                                       struct tvec_t_base_s *new_base)
> +{
> +       timer->base = (struct tvec_t_base_s *)((unsigned long)(new_base) |
> +                                              tbase_get_deferrable(old_base));
> +}

looks a little bit ugly, but may be this is just me. How about

	void timer_set_base(struct timer_list *timer, struct tvec_t_base_s *new_base)
	{
		timer->base = (struct tvec_t_base_s *)
			((unsigned long)(new_base) | tbase_get_deferrable(timer->base));
	}

__mod_timer:
	-	tvec_base_t *old_base = timer->base;
	-	timer->base = NULL;
	+	timer_set_base(timer, NULL);

?

> +                       /* Make sure that tvec_base is 2 byte aligned */
> +                       if (tbase_get_deferrable(base)) {
> +                               WARN_ON(1);
> +                               kfree(base);
> +                               return -ENOMEM;
> +                       }

Not a comment, but a question: do we really need this?

Oleg.


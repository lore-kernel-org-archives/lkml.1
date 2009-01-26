Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZAZXHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZAZXHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZAZXHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:07:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46991 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbZAZXHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:07:45 -0500
Date: Tue, 27 Jan 2009 00:07:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] timer: implement lockdep deadlock detection
Message-ID: <20090126230721.GA6556@elte.hu>
References: <1233010786.4344.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233010786.4344.1.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Berg <johannes@sipsolutions.net> wrote:

> This modifies the timer code in a way to allow lockdep to detect 
> deadlocks resulting from a lock being taken in the timer function as 
> well as around the del_timer_sync() call.
> 
> Validated with this module, otherwise bootup was clean.

That's a really neat trick ...

Curious: have you hit such a bug recently that motivated you to implement 
it?

> +#ifdef CONFIG_LOCKDEP
> +#define init_timer(timer)						\
> +	do {								\
> +		static struct lock_class_key __key;			\
> +		init_timer_key((timer), #timer, &__key);		\
> +	} while (0)
> +#define init_timer_deferrable(timer)					\
> +	do {								\

(Style detail: please put a newline after each macro block to make them 
stand apart a bit more.)

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

yummie. We have repeat bugs in this area that are rather tricky to find. 
This will trigger them in a debuggable way.

> @@ -861,10 +881,21 @@ static inline void __run_timers(struct t
>  
>  			set_running_timer(base, timer);
>  			detach_timer(timer, 1);
> +
>  			spin_unlock_irq(&base->lock);

Yes, the newline is needed there :-) [seriously]

>  				int preempt_count = preempt_count();
> +
> +				/* Couple the lock chain with the lock chain at
> +				 * del_timer_sync by acquiring the lock_map around
> +				 * the fn() call here and in del_timer_sync.
> +				 */

Please use the standard multi-line comment style:

  /*
   * Comment .....
   * ...... goes here:
   */

Looks good otherwise,

Thanks,

	Ingo

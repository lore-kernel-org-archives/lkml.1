Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbYLZIez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbYLZIez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 03:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYLZIer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 03:34:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45335 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbYLZIeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 03:34:46 -0500
Date: Fri, 26 Dec 2008 09:34:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yang Xi <yangxilkm@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       chyyuu <chyyuu@gmail.com>
Subject: Re: [PATCH 2.6.28-rc4]lock_stat: Add "con-hungry" to show that how
	many person-time fight for the ticket spinlock
Message-ID: <20081226083431.GA755@elte.hu>
References: <d36bb30d0811180300r77c3a13ld0a4881a8261a40@mail.gmail.com> <1227025232.29743.23.camel@lappy.programming.kicks-ass.net> <d36bb30d0811182118x1e394780n8a257fd4c44f4836@mail.gmail.com> <1227112785.29743.37.camel@lappy.programming.kicks-ass.net> <d36bb30d0811200009j742416a6nbc0519ff8d95970b@mail.gmail.com> <1227404426.7685.19975.camel@twins> <d36bb30d0812252324n512f4653of62f8b42684217d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d36bb30d0812252324n512f4653of62f8b42684217d4@mail.gmail.com>
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


* Yang Xi <yangxilkm@gmail.com> wrote:

> Because the lock-stat and lock-dep is so heavy, this statistic result is 
> not very accurate :(

hm, lockdep indeed has to do some non-trivial work - but is that really 
true of pure lockstat too? If you have a workload where you can see that 
it's heavy, you could do an NMI profile on x86 by running kerneltop on 
tip/master:

     http://redhat.com/~mingo/perfcounters/kerneltop.c

You should get a top-alike list of the highest-cost functions. If lockstat 
is heavy, its activities should show up there.

> @@ -34,6 +34,7 @@ config X86
>  	select HAVE_ARCH_TRACEHOOK
>  	select HAVE_GENERIC_DMA_COHERENT if X86_32
>  	select HAVE_EFFICIENT_UNALIGNED_ACCESS
> +	select HAVE_TICKET_SPINLOCK

no fundamental objections against your patch, but i think it needs a 
couple of cleanups first.

For example, this HAVE_TICKET_SPINLOCK distinction is unnecessarily 
exposed to the core kernel, why not just allow architectures to define 
spin_nr_contended():

> +#ifdef CONFIG_HAVE_TICKET_SPINLOCK
> +#define spin_nr_contended(lock) __ticket_spin_nr_contended(&(lock)->raw_lock)
> +#else
> +#define spin_nr_contended(lock) (spin_is_contended(lock) ? 1 : 0)
> +#endif

and do something like this in spinlock.h to give a default definition:

#ifndef spin_nr_contended
# define spin_nr_contended(lock) (spin_is_contended(lock) ? 1 : 0)
#endif

> @@ -2588,7 +2594,6 @@ static int __lock_acquire(struct lockdep_map
> *lock, unsigned int subclass,
> 
>  	if (check == 2 && !mark_irqflags(curr, hlock))
>  		return 0;
> -
>  	/* mark it as used: */
>  	if (!mark_lock(curr, hlock, LOCK_USED))
>  		return 0;
> @@ -2623,7 +2628,6 @@ static int __lock_acquire(struct lockdep_map
> *lock, unsigned int subclass,
> 
>  	if (!validate_chain(curr, lock, hlock, chain_head, chain_key))
>  		return 0;
> -
>  	curr->curr_chain_key = chain_key;
>  	curr->lockdep_depth++;
>  	check_chain_key(curr);
> @@ -3000,6 +3004,13 @@ __lock_contended(struct lockdep_map *lock,

those newlines you removed were there for a reason - they delimit blocks 
of code from each other and make return statements more visible.


> unsigned long ip)
>  	struct lock_class_stats *stats;
>  	unsigned int depth;
>  	int i, point;
> +	spinlock_t *lock_ptr;
> +	unsigned long hungry = 0;

please keep the local variable definitions in their original style, i.e. a 
reverse christmas tree:

>  	struct lock_class_stats *stats;
> +	unsigned long hungry = 0;
> +	spinlock_t *lock_ptr;
>  	unsigned int depth;
>  	int i, point;

> +
> +	if (lock->isticketspinlock) {
> +		lock_ptr = container_of(lock, spinlock_t, dep_map);
> +		hungry = spin_nr_contended(lock_ptr);
> +	}

do we need the ->isticketspinlock distinction? Cannot we call 
spin_nr_contended() for all spinlocks? (it's just that for ticket 
spinlocks we get a real value out of it - for normal spinlocks we only get 
0/1 out of it. But that is not a problem really.)

also, please rename 'hungry' to something more descriptive: for example 
'nr_contended' fits pretty well?

> @@ -3030,9 +3041,16 @@ found_it:
>  		stats->contention_point[point]++;
>  	if (lock->cpu != smp_processor_id())
>  		stats->bounces[bounce_contended + !!hlock->read]++;
> +	stats->bounces[bounce_hungry] += hungry;
> +	if (lock->isticketspinlock) {
> +		if (stats->bounces[bounce_max_hungry] < hungry)
> +			stats->bounces[bounce_max_hungry] = hungry;
> +	}
> +
>  	put_lock_stats(stats);
>  }
> 
> +
>  static void

spurious newline.

	Ingo

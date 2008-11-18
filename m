Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbYKRQV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbYKRQV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYKRQUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:20:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:59478 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbYKRQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:20:41 -0500
Subject: Re: [PATCH 2.6.28-rc4]lock_stat: Add "con-hungry" to show that how
	many person-time fight for the ticket spinlock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yang Xi <yangxilkm@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <d36bb30d0811180300r77c3a13ld0a4881a8261a40@mail.gmail.com>
References: <d36bb30d0811180300r77c3a13ld0a4881a8261a40@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 17:20:32 +0100
Message-Id: <1227025232.29743.23.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-18 at 19:00 +0800, Yang Xi wrote:
> Because the implementation of X86 spinlock adopts ticket lock, we can
> know how many threads are waiting for the lock when there is a
> contention on the spinlock. We add the number of these threads to the
> bounces[bounce_hungry] and name "bounces[bounce_hungry]" as
> "con-hungry". Finally, we can use this number to show that "the number
> of threads waiting for a spinlock/ a contention". From it, we can know
> that whether it is valuable to replace the spinlock  with more
> scalable spinlock since the design principle of scalability spinlock
> is to decrease the cache invalid cost, if the "con-hungry/contentions"
> is not high, we cannot benefit from more scalable spinlocks.
> 
> 
> Signed-off-by: Yang Xi <hiyangxi@gmail.com>

While I like the idea, the code is horrid, please clean this up and try
again.

The lockstat code should not ever need to know about lock implementation
details like which you #ifdeffed in.

> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index 331e5f1..a71398e 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -136,6 +136,7 @@ enum bounce_type {
>         bounce_acquired_read,
>         bounce_contended_write,
>         bounce_contended_read,
> +       bounce_hungry,
>         nr_bounce_types,
> 
>         bounce_acquired = bounce_acquired_write,
> @@ -165,6 +166,7 @@ struct lockdep_map {
>         const char                      *name;
>  #ifdef CONFIG_LOCK_STAT
>         int                             cpu;
> +       int                             isspinlock;
>  #endif

perhaps a bitfield?

>  };
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 06e1571..b3314ed 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -3000,6 +3000,20 @@ __lock_contended(struct lockdep_map *lock,
> unsigned long ip)
>         struct lock_class_stats *stats;
>         unsigned int depth;
>         int i, point;
> +       spinlock_t * lock_ptr;
> +       unsigned long hungry;
> +
> +       if (lock->isspinlock){
> +               lock_ptr = container_of(lock,spinlock_t,dep_map);
> +
> +#if (NR_CPUS < 256)
> +               hungry=(unsigned
> char)((lock_ptr->raw_lock.slock>>8&0xff)-(lock_ptr->raw_lock.slock&0xff));
> +
> +#else
> +               hungry=(unsigned
> short)((lock_ptr->raw_lock.slock>>16&0xffff)-(lock_ptr->raw_lock.slock&0xffff));
> +
> +#endif

Prime example of uglyness that is unacceptable.

> +       }
> 
>         depth = curr->lockdep_depth;
>         if (DEBUG_LOCKS_WARN_ON(!depth))
> @@ -3030,9 +3044,13 @@ found_it:
>                 stats->contention_point[point]++;
>         if (lock->cpu != smp_processor_id())
>                 stats->bounces[bounce_contended + !!hlock->read]++;
> +       if (lock->isspinlock){
> +               stats->bounces[bounce_hungry]+=hungry+1;
> +       }
>         put

superfluous braces.


> diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
> index 9c4b025..2ec34ec 100644
> --- a/lib/spinlock_debug.c
> +++ b/lib/spinlock_debug.c
> @@ -27,6 +27,10 @@ void __spin_lock_init(spinlock_t *lock, const char *name,
>         lock->magic = SPINLOCK_MAGIC;
>         lock->owner = SPINLOCK_OWNER_INIT;
>         lock->owner_cpu = -1;
> +       lock->dep_map.isspinlock = 0;
> +#if ((defined(CONFIG_X86) || defined(CONFIG_X86_64))&&
> defined(CONFIG_LOCK_STAT))
> +       lock->dep_map.isspinlock = 1;
> +#endif

sorry, no, imagine the utter mess this will become when some other arch
adds ticket locks too...


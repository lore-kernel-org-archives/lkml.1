Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYKSQj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYKSQj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYKSQjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:39:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:54138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbYKSQjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:39:51 -0500
Subject: Re: [PATCH 2.6.28-rc4]lock_stat: Add "con-hungry" to show that how
	many person-time fight for the ticket spinlock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yang Xi <yangxilkm@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <d36bb30d0811182118x1e394780n8a257fd4c44f4836@mail.gmail.com>
References: <d36bb30d0811180300r77c3a13ld0a4881a8261a40@mail.gmail.com>
	 <1227025232.29743.23.camel@lappy.programming.kicks-ass.net>
	 <d36bb30d0811182118x1e394780n8a257fd4c44f4836@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 17:39:45 +0100
Message-Id: <1227112785.29743.37.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 13:18 +0800, Yang Xi wrote:
> Thanks. This should be better. I add __ticket_spin_nm_contended in
> x86/include/asm/spinlock.h to return the number of threads
> waiting/holding for the ticket spinlock(Note: The number contains the
> holder). If the spinlock is ticket lock, "spin_nm_contended" will be
> __ticket_spin_nm_contended, otherwise, it will be 0.

Much better indeed, still some comments though :-)

> Signed-off-by: Yang Xi <hiyangxi@gmail.com>
> 
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index d17c919..88c3774 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -172,6 +172,13 @@ static inline int
> __ticket_spin_is_contended(raw_spinlock_t *lock)
>         return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
>  }
> 
> +static inline int __ticket_spin_nm_contended(raw_spinlock_t *lock)
> +{
> +       int tmp = ACCESS_ONCE(lock->slock);
> +
> +       return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) + 1;
> +}
> +
>  #ifdef CONFIG_PARAVIRT
>  /*
>   * Define virtualization-friendly old-style lock byte lock, for use in
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index 331e5f1..5bc0a2f 100644
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
> +       unsigned int                    isspinlock:1;

I of course meant folding cpu and isspinlock into a combined bitfield
(sorry for not being more clear), thereby saving space, this still takes
2*sizeof(int).

We can safely take some bits from the cpu number as there currently are
no plans for a 2g cpu machine, right SGI? :-)

>  #endif
>  };
> 
> diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
> index e0c0fcc..322190d 100644
> --- a/include/linux/spinlock.h
> +++ b/include/linux/spinlock.h
> @@ -127,6 +127,12 @@ do {
>                  \
>  #define spin_is_contended(lock)
> __raw_spin_is_contended(&(lock)->raw_lock)
>  #endif
> 
> +#ifdef TICKET_SHIFT
> +#define spin_nm_contended(lock) __ticket_spin_nm_contended(&(lock)->raw_lock)
> +#else
> +#define spin_nm_contended(lock) (0)
> +#endif

This is a bit icky still, I don't think TICKET_SHIFT is nessecarily the
best macro to check on (other ticket lock implementations might not
define it).

A possible solution is to introduce a Kconfig variable HAVE_TICKET_LOCK
and select that from x86.

Also, may I suggest another name, spin_nr_contended() perhaps?

>  /**
>   * spin_unlock_wait - wait until the spinlock gets unlocked
>   * @lock: the spinlock in question.
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 06e1571..5fe9e8a 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -3000,7 +3000,14 @@ __lock_contended(struct lockdep_map *lock,
> unsigned long ip)
>         struct lock_class_stats *stats;
>         unsigned int depth;
>         int i, point;
> -
> +       spinlock_t * lock_ptr;
> +       unsigned long hungry = 0;

This violates coding style, please run checkpatch.

> +
> +       if (lock->isspinlock) {
> +               lock_ptr = container_of(lock,spinlock_t,dep_map);
> +               hungry = spin_nm_contended(lock_ptr);
> +       }
> +
>         depth = curr->lockdep_depth;
>         if (DEBUG_LOCKS_WARN_ON(!depth))
>                 return;

Hth,

Peter


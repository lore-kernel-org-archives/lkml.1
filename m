Return-Path: <linux-kernel-owner+w=401wt.eu-S1763091AbXJZDgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763091AbXJZDgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXJZDfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:35:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:60653 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbXJZDfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:35:53 -0400
Subject: Re: [interesting] smattering of possible memory ordering bugs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, paulus@samba.org,
       shaggy@austin.ibm.com, adaplas@gmail.com,
       "Morton, Andrew" <akpm@linux-foundation.org>, xfs-masters@oss.sgi.com
In-Reply-To: <200710261209.58519.nickpiggin@yahoo.com.au>
References: <200710261209.58519.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 13:35:17 +1000
Message-Id: <1193369717.7018.56.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Index: linux-2.6/arch/powerpc/mm/hash_native_64.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/mm/hash_native_64.c
> +++ linux-2.6/arch/powerpc/mm/hash_native_64.c
> @@ -113,7 +113,7 @@ static inline void native_lock_hpte(stru
>         unsigned long *word = &hptep->v;
>  
>         while (1) {
> -               if (!test_and_set_bit(HPTE_LOCK_BIT, word))
> +               if (!test_and_set_bit_lock(HPTE_LOCK_BIT, word))
>                         break;
>                 while(test_bit(HPTE_LOCK_BIT, word))
>                         cpu_relax();
> @@ -124,8 +124,7 @@ static inline void native_unlock_hpte(st
>  {
>         unsigned long *word = &hptep->v;
>  
> -       asm volatile("lwsync":::"memory");
> -       clear_bit(HPTE_LOCK_BIT, word);
> +       clear_bit_unlock(HPTE_LOCK_BIT, word);
>  }

Ack.

> Index: linux-2.6/arch/ppc/xmon/start.c
> ===================================================================
> --- linux-2.6.orig/arch/ppc/xmon/start.c
> +++ linux-2.6/arch/ppc/xmon/start.c
> @@ -92,16 +92,15 @@ xmon_write(void *handle, void *ptr, int 
>  {
>         char *p = ptr;
>         int i, c, ct;
> -
> -#ifdef CONFIG_SMP
> -       static unsigned long xmon_write_lock;
> -       int lock_wait = 1000000;
> +       static DEFINE_SPINLOCK(xmon_write_lock);
> +       int lock_udelay = 10000;
>         int locked;
>  
> -       while ((locked = test_and_set_bit(0, &xmon_write_lock)) != 0)
> -               if (--lock_wait == 0)
> +       while (!(locked = spin_trylock(&xmon_write_lock))) {
> +               udelay(1);
> +               if (--lock_udelay == 0)
>                         break;
> -#endif
> +       }
>  
>         if (!scc_initialized)
>                 xmon_init_scc();
> @@ -122,10 +121,9 @@ xmon_write(void *handle, void *ptr, int 
>                 eieio();
>         }
>  
> -#ifdef CONFIG_SMP
> -       if (!locked)
> -               clear_bit(0, &xmon_write_lock);
> -#endif
> +       if (locked)
> +               spin_unlock(&xmon_write_lock);
> +
>         return nb;
>  }

Ah yeah, some dirt in xmon... ;-) ack.

> Index: linux-2.6/drivers/net/ibm_newemac/mal.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/ibm_newemac/mal.c
> +++ linux-2.6/drivers/net/ibm_newemac/mal.c
> @@ -318,7 +318,7 @@ static irqreturn_t mal_rxde(int irq, voi
>  void mal_poll_disable(struct mal_instance *mal, struct mal_commac *commac)
>  {
>         /* Spinlock-type semantics: only one caller disable poll at a time */
> -       while (test_and_set_bit(MAL_COMMAC_POLL_DISABLED, &commac->flags))
> +       while (test_and_set_bit_lock(MAL_COMMAC_POLL_DISABLED, &commac->flags))
>                 msleep(1);
>  
>         /* Synchronize with the MAL NAPI poller */
> @@ -327,8 +327,7 @@ void mal_poll_disable(struct mal_instanc
>  
>  void mal_poll_enable(struct mal_instance *mal, struct mal_commac *commac)
>  {
> -       smp_wmb();
> -       clear_bit(MAL_COMMAC_POLL_DISABLED, &commac->flags);
> +       clear_bit_unlock(MAL_COMMAC_POLL_DISABLED, &commac->flags);
>  
>         /* Feels better to trigger a poll here to catch up with events that
>          * may have happened on this channel while disabled. It will most

Ack.
 
> Index: linux-2.6/include/asm-powerpc/mmu_context.h
> ===================================================================
> --- linux-2.6.orig/include/asm-powerpc/mmu_context.h
> +++ linux-2.6/include/asm-powerpc/mmu_context.h
> @@ -129,7 +129,7 @@ static inline void get_mmu_context(struc
>                 steal_context();
>  #endif
>         ctx = next_mmu_context;
> -       while (test_and_set_bit(ctx, context_map)) {
> +       while (test_and_set_bit_lock(ctx, context_map)) {
>                 ctx = find_next_zero_bit(context_map, LAST_CONTEXT+1, ctx);
>                 if (ctx > LAST_CONTEXT)
>                         ctx = 0;
> @@ -158,7 +158,7 @@ static inline void destroy_context(struc
>  {
>         preempt_disable();
>         if (mm->context.id != NO_CONTEXT) {
> -               clear_bit(mm->context.id, context_map);
> +               clear_bit_unlock(mm->context.id, context_map);
>                 mm->context.id = NO_CONTEXT;
>  #ifdef FEW_CONTEXTS
>                 atomic_inc(&nr_free_contexts);

I don't think the previous code was wrong... it's not a locked section
and we don't care about ordering previous stores. It's an allocation, it
should be fine. In general, bitmap allocators should be allright.

Ignore the FEW_CONTEXTS stuff for now :-) At this point, it's UP only
and will be replaced sooner or later.

> Index: linux-2.6/include/asm-ppc/mmu_context.h
> ===================================================================
> --- linux-2.6.orig/include/asm-ppc/mmu_context.h
> +++ linux-2.6/include/asm-ppc/mmu_context.h
> @@ -128,7 +128,7 @@ static inline void get_mmu_context(struc
>                 steal_context();
>  #endif
>         ctx = next_mmu_context;
> -       while (test_and_set_bit(ctx, context_map)) {
> +       while (test_and_set_bit_lock(ctx, context_map)) {
>                 ctx = find_next_zero_bit(context_map, LAST_CONTEXT+1, ctx);
>                 if (ctx > LAST_CONTEXT)
>                         ctx = 0;
> @@ -157,7 +157,7 @@ static inline void destroy_context(struc
>  {
>         preempt_disable();
>         if (mm->context.id != NO_CONTEXT) {
> -               clear_bit(mm->context.id, context_map);
> +               clear_bit_unlock(mm->context.id, context_map);
>                 mm->context.id = NO_CONTEXT;
>  #ifdef FEW_CONTEXTS
>                 atomic_inc(&nr_free_contexts);

Same as above.

Cheers,
Ben.



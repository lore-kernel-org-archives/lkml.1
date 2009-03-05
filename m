Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZCEWX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZCEWX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 17:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZCEWXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:23:48 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:48910 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbZCEWXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:23:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jIIizBZUw6bEaIVDCMJiz8j4qUmsrT6O9SkcapvJOP1+gYhosnrl5L+ctwsiU9D/KC
         ryDA9MuLl+UjVh9bh3DOHaq94FfnutFp/sj4SOr8KYARXJPacNGRhKCQMfK/67cfLphO
         KjYudpMD7fPfkLsJppCV4tZcND6e6WUuizSH0=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0903042350210.5511@xanadu.home>
References: <alpine.LFD.2.00.0903040014140.5511@xanadu.home>
	 <20090304171429.c013013c.minchan.kim@barrios-desktop>
	 <alpine.LFD.2.00.0903041101170.5511@xanadu.home>
	 <20090305080717.f7832c63.minchan.kim@barrios-desktop>
	 <alpine.LFD.2.00.0903042129140.5511@xanadu.home>
	 <20090305132054.888396da.minchan.kim@barrios-desktop>
	 <alpine.LFD.2.00.0903042350210.5511@xanadu.home>
Date: Fri, 6 Mar 2009 07:23:44 +0900
Message-ID: <28c262360903051423g1fbf5067i9835099d4bf324ae@mail.gmail.com>
Subject: Re: [RFC] atomic highmem kmap page pinning
From: Minchan Kim <minchan.kim@gmail.com>
To: Nicolas Pitre <nico@cam.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 5, 2009 at 1:57 PM, Nicolas Pitre <nico@cam.org> wrote:
> On Thu, 5 Mar 2009, Minchan Kim wrote:
>
>> On Wed, 04 Mar 2009 21:37:43 -0500 (EST)
>> Nicolas Pitre <nico@cam.org> wrote:
>>
>> > My assertion is that the cost is negligible.  This is why I'm asking you
>> > why you think this is a big cost.
>>
>> Of course, I am not sure whether it's big cost or not.
>> But I thought it already is used in many fs, driver.
>> so, whether it's big cost depends on workload type .
>>
>> However, This patch is needed for VIVT and no coherent cache.
>> Is right ?
>>
>> If it is right, it will add unnessary overhead in other architecture
>> which don't have this problem.
>>
>> I think it's not desirable although it is small cost.
>> If we have a other method which avoids unnessary overhead, It would be better.
>> Unfortunately, I don't have any way to solve this, now.
>
> OK.  What about this patch then:

It looks good to me except one thing below.
Reviewed-by: MinChan Kim <minchan.kim@gmail.com>

> From c4db60c3a2395476331b62e08cf1f64fc9af8d54 Mon Sep 17 00:00:00 2001
> From: Nicolas Pitre <nico@cam.org>
> Date: Wed, 4 Mar 2009 22:49:41 -0500
> Subject: [PATCH] atomic highmem kmap page pinning
>
> Most ARM machines have a non IO coherent cache, meaning that the
> dma_map_*() set of functions must clean and/or invalidate the affected
> memory manually before DMA occurs.  And because the majority of those
> machines have a VIVT cache, the cache maintenance operations must be
> performed using virtual
> addresses.
>
> When a highmem page is kunmap'd, its mapping (and cache) remains in place
> in case it is kmap'd again. However if dma_map_page() is then called with
> such a page, some cache maintenance on the remaining mapping must be
> performed. In that case, page_address(page) is non null and we can use
> that to synchronize the cache.
>
> It is unlikely but still possible for kmap() to race and recycle the
> virtual address obtained above, and use it for another page before some
> on-going cache invalidation loop in dma_map_page() is done. In that case,
> the new mapping could end up with dirty cache lines for another page,
> and the unsuspecting cache invalidation loop in dma_map_page() might
> simply discard those dirty cache lines resulting in data loss.
>
> For example, let's consider this sequence of events:
>
>        - dma_map_page(..., DMA_FROM_DEVICE) is called on a highmem page.
>
>        -->     - vaddr = page_address(page) is non null. In this case
>                it is likely that the page has valid cache lines
>                associated with vaddr. Remember that the cache is VIVT.
>
>                -->     for (i = vaddr; i < vaddr + PAGE_SIZE; i += 32)
>                                invalidate_cache_line(i);
>
>        *** preemption occurs in the middle of the loop above ***
>
>        - kmap_high() is called for a different page.
>
>        -->     - last_pkmap_nr wraps to zero and flush_all_zero_pkmaps()
>                  is called.  The pkmap_count value for the page passed
>                  to dma_map_page() above happens to be 1, so the page
>                  is unmapped.  But prior to that, flush_cache_kmaps()
>                  cleared the cache for it.  So far so good.
>
>                - A fresh pkmap entry is assigned for this kmap request.
>                  The Murphy law says this pkmap entry will eventually
>                  happen to use the same vaddr as the one which used to
>                  belong to the other page being processed by
>                  dma_map_page() in the preempted thread above.
>
>        - The kmap_high() caller start dirtying the cache using the
>          just assigned virtual mapping for its page.
>
>        *** the first thread is rescheduled ***
>
>                        - The for(...) loop is resumed, but now cached
>                          data belonging to a different physical page is
>                          being discarded !
>
> And this is not only a preemption issue as ARM can be SMP as well,
> making the above scenario just as likely. Hence the need for some kind
> of pkmap page pinning which can be used in any context, primarily for
> the benefit of dma_map_page() on ARM.
>
> This provides the necessary interface to cope with the above issue if
> ARCH_NEEDS_KMAP_HIGH_GET is defined, otherwise the resulting code is
> unchanged.
>
> Signed-off-by: Nicolas Pitre <nico@marvell.com>
>
> diff --git a/mm/highmem.c b/mm/highmem.c
> index b36b83b..cc61399 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -67,6 +67,25 @@ pte_t * pkmap_page_table;
>
>  static DECLARE_WAIT_QUEUE_HEAD(pkmap_map_wait);
>
> +/*
> + * Most architectures have no use for kmap_high_get(), so let's abstract
> + * the disabling of IRQ out of the locking in that case to save on a
> + * potential useless overhead.
> + */
> +#ifdef ARCH_NEEDS_KMAP_HIGH_GET
> +#define spin_lock_kmap()             spin_lock_irq(&kmap_lock)
> +#define spin_unlock_kmap()           spin_unlock_irq(&kmap_lock)
> +#define spin_lock_kmap_any(flags)    spin_lock_irqsave(&kmap_lock, flags)
> +#define spin_unlock_kmap_any(flags)  spin_unlock_irqrestore(&kmap_lock, flags)
> +#else
> +#define spin_lock_kmap()             spin_lock(&kmap_lock)
> +#define spin_unlock_kmap()           spin_unlock(&kmap_lock)
> +#define spin_lock_kmap_any(flags)    \
> +       do { spin_lock(&kmap_lock); (void)(flags); } while (0)
> +#define spin_unlock_kmap_any(flags)  \
> +       do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
> +#endif
> +
>  static void flush_all_zero_pkmaps(void)
>  {
>        int i;
> @@ -113,9 +132,9 @@ static void flush_all_zero_pkmaps(void)
>  */
>  void kmap_flush_unused(void)
>  {
> -       spin_lock(&kmap_lock);
> +       spin_lock_kmap();
>        flush_all_zero_pkmaps();
> -       spin_unlock(&kmap_lock);
> +       spin_unlock_kmap();
>  }
>
>  static inline unsigned long map_new_virtual(struct page *page)
> @@ -145,10 +164,10 @@ start:
>
>                        __set_current_state(TASK_UNINTERRUPTIBLE);
>                        add_wait_queue(&pkmap_map_wait, &wait);
> -                       spin_unlock(&kmap_lock);
> +                       spin_unlock_kmap();
>                        schedule();
>                        remove_wait_queue(&pkmap_map_wait, &wait);
> -                       spin_lock(&kmap_lock);
> +                       spin_lock_kmap();
>
>                        /* Somebody else might have mapped it while we slept */
>                        if (page_address(page))
> @@ -184,29 +203,59 @@ void *kmap_high(struct page *page)
>         * For highmem pages, we can't trust "virtual" until
>         * after we have the lock.
>         */
> -       spin_lock(&kmap_lock);
> +       spin_lock_kmap();
>        vaddr = (unsigned long)page_address(page);
>        if (!vaddr)
>                vaddr = map_new_virtual(page);
>        pkmap_count[PKMAP_NR(vaddr)]++;
>        BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 2);
> -       spin_unlock(&kmap_lock);
> +       spin_unlock_kmap();
>        return (void*) vaddr;
>  }
>
>  EXPORT_SYMBOL(kmap_high);
>
> +#ifdef ARCH_NEEDS_KMAP_HIGH_GET
> +/**
> + * kmap_high_get - pin a highmem page into memory
> + * @page: &struct page to pin
> + *
> + * Returns the page's current virtual memory address, or NULL if no mapping
> + * exists.  When and only when a non null address is returned then a
> + * matching call to kunmap_high() is necessary.
> + *
> + * This can be called from any context.
> + */
> +void *kmap_high_get(struct page *page)
> +{
> +       unsigned long vaddr, flags;
> +
> +       spin_lock_kmap_any(flags);
> +       vaddr = (unsigned long)page_address(page);
> +       if (vaddr) {
> +               BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 1);
> +               pkmap_count[PKMAP_NR(vaddr)]++;
> +       }
> +       spin_unlock_kmap_any(flags);
> +       return (void*) vaddr;
> +}
> +#endif

Let's add empty function for architecture of no ARCH_NEEDS_KMAP_HIGH_GET,

> +
>  /**
>  * kunmap_high - map a highmem page into memory
>  * @page: &struct page to unmap
> + *
> + * If ARCH_NEEDS_KMAP_HIGH_GET is not defined then this may be called
> + * only from user context.
>  */
>  void kunmap_high(struct page *page)
>  {
>        unsigned long vaddr;
>        unsigned long nr;
> +       unsigned long flags;
>        int need_wakeup;
>
> -       spin_lock(&kmap_lock);
> +       spin_lock_kmap_any(flags);
>        vaddr = (unsigned long)page_address(page);
>        BUG_ON(!vaddr);
>        nr = PKMAP_NR(vaddr);
> @@ -232,7 +281,7 @@ void kunmap_high(struct page *page)
>                 */
>                need_wakeup = waitqueue_active(&pkmap_map_wait);
>        }
> -       spin_unlock(&kmap_lock);
> +       spin_unlock_kmap_any(flags);
>
>        /* do wake-up, if needed, race-free outside of the spin lock */
>        if (need_wakeup)
>



-- 
Kinds regards,
Minchan Kim

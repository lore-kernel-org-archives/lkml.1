Return-Path: <linux-kernel-owner+w=401wt.eu-S932877AbYEHVYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877AbYEHVYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbYEHVYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:24:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:10557 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbYEHVYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:24:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N7sr3io3HCFvkHWWenLyieQFTM0vIWusKbJ2SpuZkumBGANRO2Ox1l2Um6Otnvu/anHfsk+5+EdXENrs23+zjkLD/EbmTEet07mROdvwXoOmbY4OOG1hlrwFK9qQDrvPi1+C/rjMN3xp9M+Enlr3/4MzGTevMKg8sHLThQvD8Gc=
Message-ID: <19f34abd0805081424v2a42d8c6t2ee795287eace3ae@mail.gmail.com>
Date: Thu, 8 May 2008 23:24:41 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/3] slab: add kmemcheck hooks
Cc: mingo@elte.hu, clameter@sgi.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805090003120.28488@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0805090003120.28488@sbz-30.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2008 at 11:03 PM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
>
> Add kmemcheck hooks to SLAB. Note: this only works if you force SLAB to use
> compound pages manually. I didn't change SLAB to use them though as Vegard has
> a fix on the way to make kmemcheck work with non-compound pages.
>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Christoph Lameter <clameter@sgi.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vegard Nossum <vegard.nossum@gmail.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  arch/x86/Kconfig.debug |    2 +-
>  mm/slab.c              |   21 +++++++++++++++++++--
>  2 files changed, 20 insertions(+), 3 deletions(-)
>
> Index: kmemcheck/arch/x86/Kconfig.debug
> ===================================================================
> --- kmemcheck.orig/arch/x86/Kconfig.debug       2008-05-08 23:50:38.000000000 +0300
> +++ kmemcheck/arch/x86/Kconfig.debug    2008-05-08 23:50:46.000000000 +0300
> @@ -247,7 +247,7 @@
>        depends on X86
>        depends on !X86_USE_3DNOW
>        depends on !CC_OPTIMIZE_FOR_SIZE
> -       depends on !DEBUG_PAGEALLOC && SLUB
> +       depends on !DEBUG_PAGEALLOC && (SLUB || SLAB)

I think it would be nicer to put
    depends on SLAB || SLUB
right after the depends on X86_USE_3DNOW.

BTW, this patch should probably say X86_32 instead of X86 there.

>        select FRAME_POINTER
>        select STACKTRACE
>        default n
> Index: kmemcheck/mm/slab.c
> ===================================================================
> --- kmemcheck.orig/mm/slab.c    2008-05-08 23:50:45.000000000 +0300
> +++ kmemcheck/mm/slab.c 2008-05-08 23:50:46.000000000 +0300
> @@ -111,6 +111,8 @@
>  #include       <linux/rtmutex.h>
>  #include       <linux/reciprocal_div.h>
>  #include       <linux/debugobjects.h>
> +#include       <linux/kmemcheck.h>
> +#include       <linux/slub_kmemcheck.h>

slab.c is probably unlikely to be changed anyway, but Andrew suggested
to insert these things not at the end, but somewhere in the middle, as
it is less likely to conflict.

>
>  #include       <asm/cacheflush.h>
>  #include       <asm/tlbflush.h>
> @@ -176,13 +178,13 @@
>                         SLAB_STORE_USER | \
>                         SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
>                         SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
> -                        SLAB_DEBUG_OBJECTS)
> +                        SLAB_DEBUG_OBJECTS | SLAB_NOTRACK)
>  #else
>  # define CREATE_MASK   (SLAB_HWCACHE_ALIGN | \
>                         SLAB_CACHE_DMA | \
>                         SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
>                         SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
> -                        SLAB_DEBUG_OBJECTS)
> +                        SLAB_DEBUG_OBJECTS | SLAB_NOTRACK)
>  #endif
>
>  /*
> @@ -1611,6 +1613,10 @@
>                        NR_SLAB_UNRECLAIMABLE, nr_pages);
>        for (i = 0; i < nr_pages; i++)
>                __SetPageSlab(page + i);
> +
> +       if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK))
> +               kmemcheck_alloc_shadow(cachep, flags, nodeid, page, cachep->gfporder);
> +
>        return page_address(page);
>  }
>
> @@ -1623,6 +1629,9 @@
>        struct page *page = virt_to_page(addr);
>        const unsigned long nr_freed = i;
>
> +       if (kmemcheck_page_is_tracked(page) && !(cachep->flags & SLAB_NOTRACK))
> +               kmemcheck_free_shadow(cachep, page, cachep->gfporder);
> +
>        if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
>                sub_zone_page_state(page_zone(page),
>                                NR_SLAB_RECLAIMABLE, nr_freed);
> @@ -3337,6 +3346,9 @@
>        local_irq_restore(save_flags);
>        ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
>
> +       if (likely(ptr))
> +               kmemcheck_slab_alloc(cachep, flags, ptr, obj_size(cachep));
> +
>        if (unlikely((flags & __GFP_ZERO) && ptr))
>                memset(ptr, 0, obj_size(cachep));
>
> @@ -3391,6 +3403,9 @@
>        objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
>        prefetchw(objp);
>
> +       if (likely(objp))
> +               kmemcheck_slab_alloc(cachep, flags, objp, obj_size(cachep));
> +
>        if (unlikely((flags & __GFP_ZERO) && objp))
>                memset(objp, 0, obj_size(cachep));
>
> @@ -3506,6 +3521,8 @@
>        check_irq_off();
>        objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
>
> +       kmemcheck_slab_free(cachep, objp, obj_size(cachep));
> +
>        /*
>         * Skip calling cache_free_alien() when the platform is not numa.
>         * This will avoid cache misses that happen while accessing slabp (which
>

You probably also want this:

--- a/mm/Makefile
+++ b/mm/Makefile
@@ -27,13 +27,10 @@ obj-$(CONFIG_TINY_SHMEM) += tiny-shmem.o
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
+obj-$(CONFIG_KMEMCHECK) += kmemcheck.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
-
-ifeq ($(CONFIG_KMEMCHECK),y)
-obj-$(CONFIG_SLUB) += slub_kmemcheck.o
-endif

(And put it in the middle to keep Andrew happy.)

Probably needless to say, but this is GREAT work... Such a small patch too...


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

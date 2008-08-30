Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbYH3KuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbYH3KuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 06:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbYH3KuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 06:50:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:57803 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbYH3KuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 06:50:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ShA9flKJPK/dRRUGB2GtX6qGbQpQRnIZ2QHx+WUqgBBG9WsmUFqcee/HaI8m2/A1qm
         uq40saXK/UITLZRvbItPJkda+9AkZOpPT8TdXl0upqRs7sLm+g57NN7vCcqhyJFdgHel
         UvL6UDCIw8WxIK/0f1m5Rmgbro+dD24YjSQBo=
Message-ID: <84144f020808300350i7cb2d23aj6d1ffcbeceaf7e9c@mail.gmail.com>
Date: Sat, 30 Aug 2008 13:50:01 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Steve VanDeBogart" <vandebo-lkml@nerdbox.net>
Subject: Re: [PATCH 5/6] slab: Annotate slab
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       jiayingz@google.com, dkegel@google.com,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Paul E. McKenney" <paulmck@us.ibm.com>
In-Reply-To: <alpine.DEB.1.00.0808291616560.15543@abydos.NerdBox.Net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
	 <alpine.DEB.1.00.0808291616560.15543@abydos.NerdBox.Net>
X-Google-Sender-Auth: 06ef931f345287b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Sat, Aug 30, 2008 at 2:17 AM, Steve VanDeBogart
<vandebo-lkml@nerdbox.net> wrote:
> Valgrind annotations for the slab allocator:  Malloc-like and free-like
> for cache_alloc and free.  Telling Valgrind a region is free-like clears
> all the valid bits, so slabs with constructors need different treatment;
> tell Valgrind about slab objects when first constructed and free them
> when the slab is destroyed.

OK, I'm biased (I'm one of the kmemcheck developers) but these hooks
to SLAB are too ugly to live with. My preferred solution is that you
reuse the kmemcheck annotations
kmemcheck_slab_alloc()/kmemcheck_slab_free() we have:

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=30532cb3c49a2a9fed94127aab26003c52398a51

Maybe making valgrind code a "UML port" (plus some more) of kmemcheck.

> Signed-off-by: Steve VanDeBogart <vandebo-lkml@nerdbox.net>
> ---
>
> Index: linux-2.6.27-rc5/mm/slab.c
> ===================================================================
> --- linux-2.6.27-rc5.orig/mm/slab.c     2008-08-29 14:24:25.000000000 -0700
> +++ linux-2.6.27-rc5/mm/slab.c  2008-08-29 14:24:42.000000000 -0700
> @@ -111,6 +111,7 @@
>  #include       <linux/rtmutex.h>
>  #include       <linux/reciprocal_div.h>
>  #include       <linux/debugobjects.h>
> +#include       <linux/memcheck.h>
>
>  #include       <asm/cacheflush.h>
>  #include       <asm/tlbflush.h>
> @@ -1906,6 +1907,8 @@
>        int i;
>        for (i = 0; i < cachep->num; i++) {
>                void *objp = index_to_obj(cachep, slabp, i);
> +               if (cachep->ctor)
> +                       VALGRIND_FREELIKE_BLOCK(objp, 0);
>
>                if (cachep->flags & SLAB_POISON) {
>  #ifdef CONFIG_DEBUG_PAGEALLOC
> @@ -1932,6 +1935,15 @@
>  #else
>  static void slab_destroy_debugcheck(struct kmem_cache *cachep, struct slab
> *slabp)
>  {
> +#ifdef CONFIG_VALGRIND_SUPPORT
> +       int i;
> +       if (cachep->ctor) {
> +               for (i = 0; i < cachep->num; i++) {
> +                       void *objp = index_to_obj(cachep, slabp, i);
> +                       VALGRIND_FREELIKE_BLOCK(objp, 0);
> +               }
> +       }
> +#endif
>  }
>  #endif
>
> @@ -2635,6 +2647,9 @@
>
>        for (i = 0; i < cachep->num; i++) {
>                void *objp = index_to_obj(cachep, slabp, i);
> +               if (cachep->ctor)
> +                       VALGRIND_MALLOCLIKE_BLOCK(objp, cachep->buffer_size,
> +                                                       0, 0);
>  #if DEBUG
>                /* need to poison the objs? */
>                if (cachep->flags & SLAB_POISON)
> @@ -3466,6 +3481,8 @@
>        objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
>        prefetchw(objp);
>
> +       if (!cachep->ctor)
> +               VALGRIND_MALLOCLIKE_BLOCK(objp, cachep->buffer_size, 0, 0);
>        if (unlikely((flags & __GFP_ZERO) && objp))
>                memset(objp, 0, obj_size(cachep));
>
> @@ -3578,6 +3595,9 @@
>  {
>        struct array_cache *ac = cpu_cache_get(cachep);
>
> +       if (!cachep->ctor)
> +               VALGRIND_FREELIKE_BLOCK(objp, 0);
> +
>        check_irq_off();
>        objp = cache_free_debugcheck(cachep, objp,
> __builtin_return_address(0));

I'm not sure why you want to treat caches with constructor
differently. Sure, the memory regions *are* initialized but from
programmer's point of view you're not supposed to be touching the
memory unless you got it from kmalloc() or kmem_cache_alloc(). Same
goes for kfree() and kmem_cache_free() -- no touchy touchy after you
pass a pointer to either of the functions (unless you're RCU, of
course).

                           Pekka

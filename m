Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbYGQHrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbYGQHrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbYGQHqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:46:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:11508 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbYGQHqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=CupCF+iFkgtAmAPUpy6ATQyT314manAtuXmIwsd/NEhYVnQlfUMI9Mw4snRwO2EJEk
         k7hWvgM0GaXn17I739z/qu4bPuaE0gekaNM6PIC1cILTX9Nrn4tfVW6x1zm+MMLYMdu1
         qQjqgZwmAzrLdkpUL+KY0+ZPpfuhoL7h6kvto=
Message-ID: <84144f020807170046j2fae2f41k7c80dba4e388677b@mail.gmail.com>
Date: Thu, 17 Jul 2008 10:46:51 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [RFC PATCH 3/4] kmemtrace: SLUB hooks.
Cc: cl@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <017a63e6be64502c36ede4733f0cc4e5ede75db2.1216255035.git.eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cover.1216255034.git.eduard.munteanu@linux360.ro>
	 <017a63e6be64502c36ede4733f0cc4e5ede75db2.1216255035.git.eduard.munteanu@linux360.ro>
X-Google-Sender-Auth: ba1dad8ae7e6ad7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 3:46 AM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> This adds hooks for the SLUB allocator, to allow tracing with kmemtrace.
>
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  include/linux/slub_def.h |    9 +++++++-
>  mm/slub.c                |   47 ++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 49 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
> index d117ea2..0cef121 100644
> --- a/include/linux/slub_def.h
> +++ b/include/linux/slub_def.h
> @@ -10,6 +10,7 @@
>  #include <linux/gfp.h>
>  #include <linux/workqueue.h>
>  #include <linux/kobject.h>
> +#include <linux/kmemtrace.h>
>
>  enum stat_item {
>        ALLOC_FASTPATH,         /* Allocation from cpu slab */
> @@ -205,7 +206,13 @@ void *__kmalloc(size_t size, gfp_t flags);
>
>  static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
>  {
> -       return (void *)__get_free_pages(flags | __GFP_COMP, get_order(size));
> +       unsigned int order = get_order(size);
> +       void *ret = (void *) __get_free_pages(flags, order);
> +
> +       kmemtrace_mark_alloc(KMEMTRACE_TYPE_KERNEL, _THIS_IP_, ret,
> +                            size, PAGE_SIZE << order, flags);
> +
> +       return ret;
>  }
>
>  static __always_inline void *kmalloc(size_t size, gfp_t flags)
> diff --git a/mm/slub.c b/mm/slub.c
> index 315c392..a6f930f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -23,6 +23,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/memory.h>
>  #include <linux/math64.h>
> +#include <linux/kmemtrace.h>
>
>  /*
>  * Lock order:
> @@ -1652,14 +1653,25 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
>
>  void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
>  {
> -       return slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
> +       void *ret = slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
> +
> +       kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
> +                            s->objsize, s->size, gfpflags);
> +
> +       return ret;
>  }
>  EXPORT_SYMBOL(kmem_cache_alloc);
>
>  #ifdef CONFIG_NUMA
>  void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
>  {
> -       return slab_alloc(s, gfpflags, node, __builtin_return_address(0));
> +       void *ret = slab_alloc(s, gfpflags, node,
> +                              __builtin_return_address(0));
> +
> +       kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
> +                                 s->objsize, s->size, gfpflags, node);
> +
> +       return ret;
>  }
>  EXPORT_SYMBOL(kmem_cache_alloc_node);
>  #endif
> @@ -1771,6 +1783,8 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
>        page = virt_to_head_page(x);
>
>        slab_free(s, page, x, __builtin_return_address(0));
> +
> +       kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, x);
>  }
>  EXPORT_SYMBOL(kmem_cache_free);
>
> @@ -2676,6 +2690,7 @@ static struct kmem_cache *get_slab(size_t size, gfp_t flags)
>  void *__kmalloc(size_t size, gfp_t flags)
>  {
>        struct kmem_cache *s;
> +       void *ret;
>
>        if (unlikely(size > PAGE_SIZE))
>                return kmalloc_large(size, flags);
> @@ -2685,7 +2700,12 @@ void *__kmalloc(size_t size, gfp_t flags)
>        if (unlikely(ZERO_OR_NULL_PTR(s)))
>                return s;
>
> -       return slab_alloc(s, flags, -1, __builtin_return_address(0));
> +       ret = slab_alloc(s, flags, -1, __builtin_return_address(0));
> +
> +       kmemtrace_mark_alloc(KMEMTRACE_TYPE_KERNEL, _RET_IP_, ret,
> +                            size, (size_t) s->size, (unsigned long) flags);

What are these casts doing here? I think you can just drop them, no?

> +
> +       return ret;
>  }
>  EXPORT_SYMBOL(__kmalloc);
>
> @@ -2704,16 +2724,29 @@ static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
>  void *__kmalloc_node(size_t size, gfp_t flags, int node)
>  {
>        struct kmem_cache *s;
> +       void *ret;
>
> -       if (unlikely(size > PAGE_SIZE))
> -               return kmalloc_large_node(size, flags, node);
> +       if (unlikely(size > PAGE_SIZE)) {
> +               ret = kmalloc_large_node(size, flags, node);
> +
> +               kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KERNEL, _RET_IP_, ret,
> +                                         size, PAGE_SIZE << get_order(size),
> +                                         (unsigned long) flags, node);

Don't cast flags to unsigned long. The kmemtrace core should use gfp_t
as the parameter type.

> +
> +               return ret;
> +       }
>
>        s = get_slab(size, flags);
>
>        if (unlikely(ZERO_OR_NULL_PTR(s)))
>                return s;
>
> -       return slab_alloc(s, flags, node, __builtin_return_address(0));
> +       ret = slab_alloc(s, flags, node, __builtin_return_address(0));
> +
> +       kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KERNEL, _RET_IP_, ret,
> +                                 size, s->size, (unsigned long) flags, node);

Another cast here.

> +
> +       return ret;
>  }
>  EXPORT_SYMBOL(__kmalloc_node);
>  #endif
> @@ -2771,6 +2804,8 @@ void kfree(const void *x)
>                return;
>        }
>        slab_free(page->slab, page, object, __builtin_return_address(0));
> +
> +       kmemtrace_mark_free(KMEMTRACE_TYPE_KERNEL, _RET_IP_, x);
>  }
>  EXPORT_SYMBOL(kfree);
>
> --
> 1.5.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

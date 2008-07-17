Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbYGQHjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbYGQHjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYGQHiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:38:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:6846 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbYGQHiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=wctiAPXBBq6gC3OOSx74B2eaTKhWZFcpK2NZtYYTSW5e+ZhRRobMzPhsaMub6WA5Le
         dHUfp7J57a4gj/ODtGIVQMF0c7Z4QVPwVeKOQG3ZlowBgWl5XkfhxKKRndbpm1LC8ZoT
         T5LHd+l4UeXc7B1kEpJBJwe1KcdMzO0U99hxs=
Message-ID: <84144f020807170038p67614992j256f1507f14d0ba0@mail.gmail.com>
Date: Thu, 17 Jul 2008 10:38:49 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [RFC PATCH 2/4] kmemtrace: SLAB hooks.
Cc: cl@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <99a4b0edd280049b57a400b5934714ad66ea5788.1216255035.git.eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cover.1216255034.git.eduard.munteanu@linux360.ro>
	 <99a4b0edd280049b57a400b5934714ad66ea5788.1216255035.git.eduard.munteanu@linux360.ro>
X-Google-Sender-Auth: dc0aa62e924dc562
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard-Gabriel,

On Thu, Jul 17, 2008 at 3:46 AM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> This adds hooks for the SLAB allocator, to allow tracing with kmemtrace.
>
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  include/linux/slab_def.h |   56 +++++++++++++++++++++++++++++++++++++-----
>  mm/slab.c                |   61 +++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 104 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
> index 39c3a5e..77b8045 100644
> --- a/include/linux/slab_def.h
> +++ b/include/linux/slab_def.h
> @@ -14,6 +14,7 @@
>  #include <asm/page.h>          /* kmalloc_sizes.h needs PAGE_SIZE */
>  #include <asm/cache.h>         /* kmalloc_sizes.h needs L1_CACHE_BYTES */
>  #include <linux/compiler.h>
> +#include <linux/kmemtrace.h>
>
>  /* Size description struct for general caches. */
>  struct cache_sizes {
> @@ -28,8 +29,20 @@ extern struct cache_sizes malloc_sizes[];
>  void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
>  void *__kmalloc(size_t size, gfp_t flags);
>
> +#ifdef CONFIG_KMEMTRACE
> +extern void *kmem_cache_alloc_notrace(struct kmem_cache *cachep, gfp_t flags);
> +#else
> +static inline void *kmem_cache_alloc_notrace(struct kmem_cache *cachep,
> +                                            gfp_t flags)
> +{
> +       return kmem_cache_alloc(cachep, flags);
> +}
> +#endif
> +
>  static inline void *kmalloc(size_t size, gfp_t flags)
>  {
> +       void *ret;
> +
>        if (__builtin_constant_p(size)) {
>                int i = 0;
>
> @@ -50,10 +63,17 @@ static inline void *kmalloc(size_t size, gfp_t flags)
>  found:
>  #ifdef CONFIG_ZONE_DMA
>                if (flags & GFP_DMA)
> -                       return kmem_cache_alloc(malloc_sizes[i].cs_dmacachep,
> -                                               flags);
> +                       ret = kmem_cache_alloc_notrace(
> +                               malloc_sizes[i].cs_dmacachep, flags);
> +               else
>  #endif
> -               return kmem_cache_alloc(malloc_sizes[i].cs_cachep, flags);
> +                       ret = kmem_cache_alloc_notrace(
> +                               malloc_sizes[i].cs_cachep, flags);
> +
> +               kmemtrace_mark_alloc(KMEMTRACE_TYPE_KERNEL, _THIS_IP_, ret,
> +                                    size, malloc_sizes[i].cs_size, flags);

We have malloc_sizes[i].cs_size here as the _allocated_ size (which
seems wrong to be btw).

> +
> +               return ret;
>        }
>        return __kmalloc(size, flags);
>  }
> @@ -62,8 +82,23 @@ found:
>  extern void *__kmalloc_node(size_t size, gfp_t flags, int node);
>  extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
>
> +#ifdef CONFIG_KMEMTRACE
> +extern void *kmem_cache_alloc_node_notrace(struct kmem_cache *cachep,
> +                                          gfp_t flags,
> +                                          int nodeid);
> +#else
> +static inline void *kmem_cache_alloc_node_notrace(struct kmem_cache *cachep,
> +                                                 gfp_t flags,
> +                                                 int nodeid)
> +{
> +       return kmem_cache_alloc_node(cachep, flags, nodeid);
> +}
> +#endif
> +
>  static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
>  {
> +       void *ret;
> +
>        if (__builtin_constant_p(size)) {
>                int i = 0;
>
> @@ -84,11 +119,18 @@ static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
>  found:
>  #ifdef CONFIG_ZONE_DMA
>                if (flags & GFP_DMA)
> -                       return kmem_cache_alloc_node(malloc_sizes[i].cs_dmacachep,
> -                                               flags, node);
> +                       ret = kmem_cache_alloc_node_notrace(
> +                               malloc_sizes[i].cs_dmacachep, flags, node);
> +               else
>  #endif
> -               return kmem_cache_alloc_node(malloc_sizes[i].cs_cachep,
> -                                               flags, node);
> +                       ret = kmem_cache_alloc_node_notrace(
> +                               malloc_sizes[i].cs_cachep, flags, node);
> +
> +               kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KERNEL, _THIS_IP_,
> +                                         ret, size, malloc_sizes[i].cs_size,
> +                                         flags, node);

And here.

> +
> +               return ret;
>        }
>        return __kmalloc_node(size, flags, node);
>  }
>
> +#ifdef CONFIG_KMEMTRACE
> +void *kmem_cache_alloc_node_notrace(struct kmem_cache *cachep,
> +                                   gfp_t flags,
> +                                   int nodeid)
> +{
> +       return __cache_alloc_node(cachep, flags, nodeid,
> +                                 __builtin_return_address(0));
> +}
> +EXPORT_SYMBOL(kmem_cache_alloc_node_notrace);
> +#endif
> +
>  static __always_inline void *
>  __do_kmalloc_node(size_t size, gfp_t flags, int node, void *caller)
>  {
>        struct kmem_cache *cachep;
> +       void *ret;
>
>        cachep = kmem_find_general_cachep(size, flags);
>        if (unlikely(ZERO_OR_NULL_PTR(cachep)))
>                return cachep;
> -       return kmem_cache_alloc_node(cachep, flags, node);
> +       ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
> +
> +       kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KERNEL,
> +                                 (unsigned long) caller, ret,
> +                                 size, cachep->buffer_size, flags, node);

But here we use cachep->buffer_size and...

> +
> +       return ret;
>  }
>
>  #ifdef CONFIG_DEBUG_SLAB
> @@ -3718,6 +3756,7 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
>                                          void *caller)
>  {
>        struct kmem_cache *cachep;
> +       void *ret;
>
>        /* If you want to save a few bytes .text space: replace
>         * __ with kmem_.
> @@ -3727,11 +3766,17 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
>        cachep = __find_general_cachep(size, flags);
>        if (unlikely(ZERO_OR_NULL_PTR(cachep)))
>                return cachep;
> -       return __cache_alloc(cachep, flags, caller);
> +       ret = __cache_alloc(cachep, flags, caller);
> +
> +       kmemtrace_mark_alloc(KMEMTRACE_TYPE_KERNEL,
> +                            (unsigned long) caller, ret,
> +                            size, cachep->buffer_size, flags);

...here as well. Why?

Also,

> diff --git a/mm/slab.c b/mm/slab.c
> index 046607f..e9a61ac 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -111,6 +111,7 @@
>  #include       <linux/rtmutex.h>
>  #include       <linux/reciprocal_div.h>
>  #include       <linux/debugobjects.h>
> +#include       <linux/kmemtrace.h>
>
>  #include       <asm/cacheflush.h>
>  #include       <asm/tlbflush.h>
> @@ -3621,10 +3622,23 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
>  */
>  void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
>  {
> -       return __cache_alloc(cachep, flags, __builtin_return_address(0));
> +       void *ret = __cache_alloc(cachep, flags, __builtin_return_address(0));
> +
> +       kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
> +                            obj_size(cachep), obj_size(cachep), flags);

Here....

> +
> +       return ret;
>  }
>  EXPORT_SYMBOL(kmem_cache_alloc);
>
> +#ifdef CONFIG_KMEMTRACE
> +void *kmem_cache_alloc_notrace(struct kmem_cache *cachep, gfp_t flags)
> +{
> +       return __cache_alloc(cachep, flags, __builtin_return_address(0));
> +}
> +EXPORT_SYMBOL(kmem_cache_alloc_notrace);
> +#endif
> +
>  /**
>  * kmem_ptr_validate - check if an untrusted pointer might be a slab entry.
>  * @cachep: the cache we're checking against
> @@ -3669,20 +3683,44 @@ out:
>  #ifdef CONFIG_NUMA
>  void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
>  {
> -       return __cache_alloc_node(cachep, flags, nodeid,
> -                       __builtin_return_address(0));
> +       void *ret = __cache_alloc_node(cachep, flags, nodeid,
> +                                      __builtin_return_address(0));
> +
> +       kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
> +                                 obj_size(cachep), obj_size(cachep),
> +                                 flags, nodeid);

...and here, we use obj_size().

> +
> +       return ret;
>  }
>  EXPORT_SYMBOL(kmem_cache_alloc_node);

AFAICT, you should always use ->buffer_size as the_allocated_ size. Hmm?

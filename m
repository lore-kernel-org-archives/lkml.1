Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYGQHnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYGQHnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbYGQHnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:43:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:8928 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbYGQHnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:43:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=H+3O/jdTt90YYc9Rh1YNtxoGnszzS0pMOIdE1Go4Wl3EEkgs4zmLhwRjnOZVtRzBFM
         urlIXST2a5GCC5Gkq9XRXIOH9U/RaPYywcWKPqZJI2Q/VVjT7oi7s5j424enF/0llh2I
         RmtU15LXu3ZT7LOPCEl2952Vy25IO08mfzRGU=
Message-ID: <84144f020807170043w725769e5i7c24402613711690@mail.gmail.com>
Date: Thu, 17 Jul 2008 10:43:14 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [RFC PATCH 4/4] kmemtrace: SLOB hooks.
Cc: cl@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Matt Mackall" <mpm@selenic.com>
In-Reply-To: <9e4ab51fe29754243e4577dec4649c5522ddd4f8.1216255036.git.eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cover.1216255034.git.eduard.munteanu@linux360.ro>
	 <9e4ab51fe29754243e4577dec4649c5522ddd4f8.1216255036.git.eduard.munteanu@linux360.ro>
X-Google-Sender-Auth: 178435659d500080
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Adding Matt as cc.]

On Thu, Jul 17, 2008 at 3:46 AM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> This adds hooks for the SLOB allocator, to allow tracing with kmemtrace.
>
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  mm/slob.c |   37 +++++++++++++++++++++++++++++++------
>  1 files changed, 31 insertions(+), 6 deletions(-)
>
> diff --git a/mm/slob.c b/mm/slob.c
> index a3ad667..0335c01 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -65,6 +65,7 @@
>  #include <linux/module.h>
>  #include <linux/rcupdate.h>
>  #include <linux/list.h>
> +#include <linux/kmemtrace.h>
>  #include <asm/atomic.h>
>
>  /*
> @@ -463,27 +464,38 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
>  {
>        unsigned int *m;
>        int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
> +       void *ret;
>
>        if (size < PAGE_SIZE - align) {
>                if (!size)
>                        return ZERO_SIZE_PTR;
>
>                m = slob_alloc(size + align, gfp, align, node);
> +
>                if (!m)
>                        return NULL;
>                *m = size;
> -               return (void *)m + align;
> +               ret = (void *)m + align;
> +
> +               kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KERNEL,
> +                                         _RET_IP_, ret,
> +                                         size, size + align, gfp, node);
>        } else {
> -               void *ret;
> +               unsigned int order = get_order(size);
>
> -               ret = slob_new_page(gfp | __GFP_COMP, get_order(size), node);
> +               ret = slob_new_page(gfp | __GFP_COMP, order, node);
>                if (ret) {
>                        struct page *page;
>                        page = virt_to_page(ret);
>                        page->private = size;
>                }
> -               return ret;
> +
> +               kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KERNEL,
> +                                         _RET_IP_, ret,
> +                                         size, PAGE_SIZE << order, gfp, node);
>        }
> +
> +       return ret;
>  }
>  EXPORT_SYMBOL(__kmalloc_node);
>
> @@ -501,6 +513,8 @@ void kfree(const void *block)
>                slob_free(m, *m + align);
>        } else
>                put_page(&sp->page);
> +
> +       kmemtrace_mark_free(KMEMTRACE_TYPE_KERNEL, _RET_IP_, block);
>  }
>  EXPORT_SYMBOL(kfree);
>
> @@ -569,10 +583,19 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
>  {
>        void *b;
>
> -       if (c->size < PAGE_SIZE)
> +       if (c->size < PAGE_SIZE) {
>                b = slob_alloc(c->size, flags, c->align, node);
> -       else
> +               kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
> +                                         _RET_IP_, b, c->size,
> +                                         SLOB_UNITS(c->size) * SLOB_UNIT,
> +                                         flags, node);
> +       } else {
>                b = slob_new_page(flags, get_order(c->size), node);
> +               kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
> +                                         _RET_IP_, b, c->size,
> +                                         PAGE_SIZE << get_order(c->size),
> +                                         flags, node);
> +       }
>
>        if (c->ctor)
>                c->ctor(c, b);
> @@ -608,6 +631,8 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
>        } else {
>                __kmem_cache_free(b, c->size);
>        }
> +
> +       kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, b);
>  }
>  EXPORT_SYMBOL(kmem_cache_free);
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

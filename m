Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbZGIQoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbZGIQoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 12:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759260AbZGIQop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 12:44:45 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:61185 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174AbZGIQoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 12:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sE2k2c8pi5d/RGQf9tBY97iGu8AW0lKG00LlqIP1Cp43Ob3AEPyvTYrW7qvI0YOliO
         8gYbhFaJDoND5eA+FEID9t8xemUcWrBVI4O3edBrXZbDnKC/XNgifBLfiQJw3ZNM7qvg
         QBAC3lhE2Dqc0WfNgZ43uecUhfqq7BzPDFXEc=
MIME-Version: 1.0
In-Reply-To: <1247156020.27671.40.camel@debian-nb>
References: <1247156020.27671.40.camel@debian-nb>
Date: Thu, 9 Jul 2009 19:44:42 +0300
X-Google-Sender-Auth: e09b27138a2993af
Message-ID: <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com>
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already using 
	mudflap
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Janboe Ye <yuan-bo.ye@motorola.com>
Cc: linux-kernel@vger.kernel.org, vegard.nossum@gmail.com, graydon@redhat.com,
       fche@redhat.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Janboe,

On Thu, Jul 9, 2009 at 7:13 PM, Janboe Ye<yuan-bo.ye@motorola.com> wrote:
> slab debug detects the corruption when it allocates and frees the slab. But if someone write to slab memory when it already freed, slab debug could only report its last free point when slab allocates the same block.
>
> This information is not enough for debugging when system has complex memory usage. gcc mudflap could insert some check point when a memory is writing and it is helpful to check if the address is writing freed.
>
> Because most codes of kernel are drivers, it is most possible that drivers have such problem. So I use mudflap to compile all drivers.
>
> kmemcheck is also helpful to check same issue, and it triggers trap every reading and writing, and it need to analysis the instruct which trigger the trap to get the memory address.
> This heavy depends on the cpu capability. arm has no single-step like x86, so kmemcheck is too heavy to run on real arm system. mudflap way is lighter than kmemcheck for this purpose.
>
> As stack allocation is useless for checking slab, kernel mudflap does not implement alloc which is required by gcc mudflap when codes use variable array. So variable array, such as array[i] which i could not determined by compiler, is not supported.
>
> Thanks a lot for comments!

Yeah, something like this makes sense. Some comments below.

>  arch/arm/include/asm/elf.h |    1 +
>  arch/arm/kernel/module.c   |    1 +
>  drivers/Makefile           |    4 +-
>  include/mf-runtime.h       |   42 ++++++++++++++
>  kernel/Makefile            |    2 +-
>  kernel/mudflap.c           |  132 ++++++++++++++++++++++++++++++++++++++++++++
>  lib/Kconfig.debug          |    7 ++
>  mm/slab.c                  |   53 ++++++++++++++++++
>  8 files changed, 240 insertions(+), 2 deletions(-)

SLAB is (slowly) going away so you might want to port this to SLUB as
well so we can merge both.

> diff --git a/include/mf-runtime.h b/include/mf-runtime.h
> new file mode 100644
> index 0000000..4639d9d
> --- /dev/null
> +++ b/include/mf-runtime.h
> @@ -0,0 +1,42 @@
> +#ifndef _LINUX_MF_RUNTIME
> +#define _LINUX_MF_RUNTIME
> +/*
> + * Copyright (C) 2009 Motorola Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + */
> +
> +#include<linux/kernel.h>
> +
> +#define LOOKUP_CACHE_MASK_DFL 1023
> +#define LOOKUP_CACHE_SIZE_MAX 65536 /* Allows max CACHE_MASK 0xFFFF */
> +#define LOOKUP_CACHE_SHIFT_DFL 2

Newline here, please. Otherwise this get pretty messy.

> +typedef void *__mf_ptr_t;
> +typedef unsigned int __mf_uintptr_t;
> +struct __mf_cache { __mf_uintptr_t low; __mf_uintptr_t high; };

Ditto.

> +void __mf_check(void *ptr, unsigned int sz, int type, const char *location);
> +void __mf_register(void *ptr, size_t sz, int type, const char *name);
> +void __mf_init(void);
> +void __mf_unregister(void *ptr, size_t sz, int type);

Ditto.

> +#ifdef _MUDFLAP
> +#pragma redefine_extname memcpy __mfwrap_memcpy
> +#pragma redefine_extname memset __mfwrap_memset
> +#pragma redefine_extname strcpy __mfwrap_strcpy
> +#pragma redefine_extname strncpy __mfwrap_strncpy
> +#pragma redefine_extname __memzero __mfwrap_memzero
> +#endif /* _MUDFLAP */

Hmm, I don't know mudflap but how is this supposed to work now? Is
someone automatically including the header file or do you need to
include it to get memcpy() and friends redefined?

> diff --git a/kernel/mudflap.c b/kernel/mudflap.c
> new file mode 100644
> index 0000000..d0331c1
> --- /dev/null
> +++ b/kernel/mudflap.c
> @@ -0,0 +1,132 @@
> +/*
> + * kernel/mudflap.c
> + *
> + * Copyright (C) 2009 Motorola Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include<linux/kernel.h>
> +#include<linux/slab.h>
> +#include<linux/module.h>
> +#include<linux/mm.h>
> +#undef DEBUG  /* define this for verbose EDID parsing output */

EDID? Anyway, either make a proper CONFIG_MUDFLAP_DEBUG or turn the
thing into a run-time option that's passed as kernel option at boot.

> +/* Codes to describe the type of access to check */
> +#define __MF_CHECK_READ 0
> +#define __MF_CHECK_WRITE 1
> +
> +typedef void *__mf_ptr_t;
> +typedef unsigned int __mf_uintptr_t;
> +struct __mf_cache { __mf_uintptr_t low; __mf_uintptr_t high; };

Newline

> +#define LOOKUP_CACHE_MASK_DFL 1023
> +#define LOOKUP_CACHE_SIZE_MAX 65536 /* Allows max CACHE_MASK 0xFFFF */
> +#define LOOKUP_CACHE_SHIFT_DFL 2
> +

I wonder if the above should go into mudflap-runtime.h

> +struct __mf_cache __mf_lookup_cache[LOOKUP_CACHE_SIZE_MAX];
> +EXPORT_SYMBOL(__mf_lookup_cache);
> +
> +uintptr_t __mf_lc_mask = LOOKUP_CACHE_MASK_DFL;
> +EXPORT_SYMBOL(__mf_lc_mask);
> +
> +unsigned char __mf_lc_shift = LOOKUP_CACHE_SHIFT_DFL;
> +EXPORT_SYMBOL(__mf_lc_shift);
> +
> +void check_slab_write(void *ptr, unsigned int sz,
> +               int type, const char *location);

You probably want to move this into <linux/slab_def.h>

> +
> +static inline int verify_ptr(unsigned long ptr)
> +{
> +       if (ptr < PAGE_OFFSET ||
> +               (ptr > (unsigned long)high_memory && high_memory != 0))
> +               return -EFAULT;
> +
> +       return 0;
> +}

OK, so what is this function supposed to do?

> +
> +void __mf_check(void *ptr, unsigned int sz, int type, const char *location)
> +{
> +       if (verify_ptr((unsigned long)ptr))
> +               return;
> +       if (type) /* write */
> +               check_slab_write(ptr, sz, type, location);
> +}

So why are we passing type to check_slab_write() as it's clearly
always __MF_CHECK_WRITE? Do we need 'location'? Isn't that obvious
from the stack trace?

> +#ifdef CONFIG_ARM
> +void __mfwrap_memzero(void *ptr, __kernel_size_t n)
> +{
> +       __mf_check(ptr, n, __MF_CHECK_WRITE, "memzero dest");
> +       return __memzero(ptr, n);
> +}
> +EXPORT_SYMBOL(__mfwrap_memzero);
> +#endif

Hmm, is there some HAVE_MEMZERO that we can use here? CONFIG_ARM isn't
really suitable for core code like this so you might want to move that
to arch/arm or do the HAVE_MEMZERO thing.

> diff --git a/mm/slab.c b/mm/slab.c
> index 7b5d4de..bb0d57c 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -4503,3 +4503,56 @@ size_t ksize(const void *objp)
>        return obj_size(virt_to_cache(objp));
>  }
>  EXPORT_SYMBOL(ksize);
> +
> +#ifdef CONFIG_MUDFLAP
> +void check_slab_write(void *ptr, unsigned int sz, int type,
> +               const char *location)
> +{
> +       struct page *page;
> +       struct kmem_cache *cachep;
> +       struct slab *slabp;
> +       char *realobj;
> +       void *objp;
> +       int objnr, size, i = 0, count, free_count = 0;

Newline, please

> +       page = virt_to_page(ptr);
> +       page = compound_head(page);

Why not virt_to_head_page() ?

> +       if (PageSlab(page)) {

You could do

  if (!PageSlab(page))
          return;

to reduce nesting here

> +               cachep = page_get_cache(page);
> +               slabp = page_get_slab(page);
> +               objnr = (unsigned)(ptr - slabp->s_mem) / cachep->buffer_size;
> +               objp = index_to_obj(cachep, slabp, objnr);
> +               size = obj_size(cachep);
> +               count = size - 1;
> +               realobj = (char *)objp + obj_offset(cachep);
> +               while (count--) {
> +                       i++;
> +                       if (realobj[i] == POISON_FREE)
> +                               free_count++;
> +                       else
> +                               break;
> +               }

Hmm, why not use slab_bufctl() and checking whether it's BUFCTL_FREE?

> +
> +               if (i == free_count) {
> +                       printk(KERN_ERR "ptr: %p, sz: %d, location: %s\n",
> +                                       ptr, sz, location);
> +                       printk(KERN_ERR "write to freed object, size %d\n",
> +                                       size);
> +                       i = 0;
> +                       while (size--) {
> +                               printk(KERN_ERR "%x", realobj[i]);
> +                               i++;
> +                       }
> +                       printk(KERN_ERR "%x\n", realobj[i]);
> +                       if (cachep->flags & SLAB_STORE_USER) {
> +                               printk(KERN_ERR "Last user: [<%p>]",
> +                                               *dbg_userword(cachep, objp));
> +                               print_symbol("(%s)",
> +                                   (unsigned long)*dbg_userword(cachep, objp));
> +                               printk("\n");
> +                       }
> +
> +                       dump_stack();
> +               }
> +       }
> +}
> +#endif

                           Pekka

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbZGJHsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbZGJHsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbZGJHsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:48:30 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47976 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZGJHs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:48:29 -0400
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
 using mudflap v2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Janboe Ye <yuan-bo.ye@motorola.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel <linux-kernel@vger.kernel.org>, vegard.nossum@gmail.com,
       graydon@redhat.com, fche@redhat.com, mingo@elte.hu,
       cl@linux-foundation.org
In-Reply-To: <1247181965.8967.10.camel@debian-nb>
References: <1247181965.8967.10.camel@debian-nb>
Date: Fri, 10 Jul 2009 10:48:27 +0300
Message-Id: <1247212107.23169.25.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Janboe!

On Thu, 2009-07-09 at 18:26 -0500, Janboe Ye wrote:
> +#include<linux/kernel.h>
> +
> +#define LOOKUP_CACHE_MASK_DFL 1023
> +#define LOOKUP_CACHE_SIZE_MAX 65536 /* Allows max CACHE_MASK 0xFFFF */
> +#define LOOKUP_CACHE_SHIFT_DFL 2

These are probably too generic names if this is going to be included by
default. Maybe you could just add a KMUDFLAP prefix or something?

> +
> +typedef void *__mf_ptr_t;
> +typedef unsigned int __mf_uintptr_t;
> +struct __mf_cache { __mf_uintptr_t low; __mf_uintptr_t high; };
> +
> +void __mf_check(void *ptr, unsigned int sz, int type, const char *location);
> +void __mf_register(void *ptr, size_t sz, int type, const char *name);
> +void __mf_init(void);
> +void __mf_unregister(void *ptr, size_t sz, int type);
> +
> +#ifdef _MUDFLAP
> +#pragma redefine_extname memcpy __mfwrap_memcpy
> +#pragma redefine_extname memset __mfwrap_memset
> +#pragma redefine_extname strcpy __mfwrap_strcpy
> +#pragma redefine_extname strncpy __mfwrap_strncpy
> +
> +#ifdef CONFIG_ARM
> +#pragma redefine_extname __memzero __mfwrap_memzero
> +#endif
> +
> +#endif /* _MUDFLAP */
> +
> +#endif
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 2093a69..c4c2402 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -22,7 +22,7 @@ CFLAGS_REMOVE_rtmutex-debug.o = -pg
>  CFLAGS_REMOVE_cgroup-debug.o = -pg
>  CFLAGS_REMOVE_sched_clock.o = -pg
>  endif
> -
> +obj-$(CONFIG_MUDFLAP) += mudflap.o
>  obj-$(CONFIG_FREEZER) += freezer.o
>  obj-$(CONFIG_PROFILING) += profile.o
>  obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
> diff --git a/kernel/mudflap.c b/kernel/mudflap.c
> new file mode 100644
> index 0000000..5734dff
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
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include<linux/kernel.h>
> +#include<linux/slab.h>
> +#include<linux/module.h>
> +#include<linux/mm.h>
> +#undef DEBUG
> +
> +#ifdef DEBUG
> +#define DPRINTK(fmt, args...) printk(fmt, ## args)
> +#else
> +#define DPRINTK(fmt, args...)
> +#endif

This is core kernel code so this DEBUG thing needs to go. Check the
previous email for suggestions how to do it.

> +
> +/* Codes to describe the type of access to check */
> +#define __MF_CHECK_READ 0
> +#define __MF_CHECK_WRITE 1
> +
> +typedef void *__mf_ptr_t;
> +typedef unsigned int __mf_uintptr_t;
> +struct __mf_cache { __mf_uintptr_t low; __mf_uintptr_t high; };
> +
> +#define LOOKUP_CACHE_MASK_DFL 1023
> +#define LOOKUP_CACHE_SIZE_MAX 65536 /* Allows max CACHE_MASK 0xFFFF */
> +#define LOOKUP_CACHE_SHIFT_DFL 2

Why are we redefining these here?

> +
> +struct __mf_cache __mf_lookup_cache[LOOKUP_CACHE_SIZE_MAX];
> +EXPORT_SYMBOL(__mf_lookup_cache);
> +
> +uintptr_t __mf_lc_mask = LOOKUP_CACHE_MASK_DFL;
> +EXPORT_SYMBOL(__mf_lc_mask);
> +
> +unsigned char __mf_lc_shift = LOOKUP_CACHE_SHIFT_DFL;
> +EXPORT_SYMBOL(__mf_lc_shift);
> +
> +void check_slab_write(void *ptr, unsigned int sz, const char *location);

This needs to go into <linux/slab_def.h> and <linux/slub_def.h> and
probably renamed to "slab_check_write()"

> +static inline int verify_ptr(unsigned long ptr)
> +{
> +	if (ptr < PAGE_OFFSET ||
> +		(ptr > (unsigned long)high_memory && high_memory != 0))

s/0/NULL/

> +		return -EFAULT;
> +
> +	return 0;
> +}

OTOH, can't we use virt_addr_valid() instead? It should be safe to do
virt_to_head_page() if it passes and the PageSlab check in
check_slab_write() will take care of the rest.

Furthermore, you could just move all this processing to
check_slab_write() and nuke verity_ptr() completely.

> +
> +void __mf_check(void *ptr, unsigned int sz, int type, const char *location)
> +{
> +	if (verify_ptr((unsigned long)ptr))
> +		return;
> +	if (type) /* write */
> +		check_slab_write(ptr, sz, location);
> +}
> +EXPORT_SYMBOL(__mf_check);
> +
> +void *__mfwrap_memset(void *s, int c, size_t count)

Is the __mfwrap prefix mandated by mudflap? Can we use kmudflap or
similar instead?

> +{
> +	__mf_check(s, count, __MF_CHECK_WRITE, "memset dest");
> +	return memset(s, c, count);
> +}
> +EXPORT_SYMBOL(__mfwrap_memset);
> +
> +void *__mfwrap_memcpy(void *dest, const void *src, size_t count)
> +{
> +	__mf_check(dest, count, __MF_CHECK_WRITE, "memcpy dest");
> +	return memcpy(dest, src, count);
> +}
> +EXPORT_SYMBOL(__mfwrap_memcpy);
> +
> +char *__mfwrap_strcpy(char *dest, const char *src)
> +{
> +	size_t n = strlen(src);
> +	 __mf_check(dest, n, __MF_CHECK_WRITE, "strcpy dest");
> +	return strcpy(dest, src);
> +}
> +EXPORT_SYMBOL(__mfwrap_strcpy);
> +
> +void *__mfwrap_strncpy(char *dest, const char *src, size_t count)
> +{
> +	size_t len = strnlen(src, count);
> +	 __mf_check(dest, len, __MF_CHECK_WRITE, "strncpy dest");
> +	return strncpy(dest, src, count);
> +}
> +EXPORT_SYMBOL(__mfwrap_strncpy);
> +
> +#ifdef CONFIG_ARM

Like I said, this doesn't really belong into generic kernel code. Can we
just move this function under arch/arm/kernel?

> +void __mfwrap_memzero(void *ptr, __kernel_size_t n)
> +{
> +	__mf_check(ptr, n, __MF_CHECK_WRITE, "memzero dest");
> +	return __memzero(ptr, n);
> +}
> +EXPORT_SYMBOL(__mfwrap_memzero);
> +#endif
> +
> +void
> +__mf_register(void *ptr, size_t sz, int type, const char *name)
> +{
> +	DPRINTK("ptr: %p, sz: %d, type: %d, %s\n", ptr, sz, type, name);
> +}
> +EXPORT_SYMBOL(__mf_register);
> +
> +void
> +__mf_unregister(void *ptr, size_t sz, int type)
> +{
> +	DPRINTK("ptr: %p, sz: %d, type: %d\n", ptr, sz, type);
> +}
> +EXPORT_SYMBOL(__mf_unregister);
> +
> +void __mf_init(void)
> +{
> +}
> +EXPORT_SYMBOL(__mf_init);
> +
> +int
> +__mf_set_options(const char *optstr)
> +{
> +	return 0;
> +}
> +EXPORT_SYMBOL(__mf_set_options);
> diff --git a/mm/slab.c b/mm/slab.c
> index 7b5d4de..f4433d4 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -4503,3 +4503,41 @@ size_t ksize(const void *objp)
>  	return obj_size(virt_to_cache(objp));
>  }
>  EXPORT_SYMBOL(ksize);
> +
> +#ifdef CONFIG_MUDFLAP
> +void check_slab_write(void *ptr, unsigned int sz, const char *location)

s/sz/size/ and use size_t

> +{
> +	struct page *page;
> +	struct kmem_cache *cachep;
> +	struct slab *slabp;
> +	char *realobj;
> +	void *objp;
> +	int objnr, size;

s/cachep/cache/ and same for slabp and objp too, please.

> +
> +	page = virt_to_head_page(ptr);
> +	if (!PageSlab(page))
> +		return;
> +
> +	cachep = page_get_cache(page);
> +	slabp = page_get_slab(page);
> +	objnr = (unsigned)(ptr - slabp->s_mem) / cachep->buffer_size;

Cast to unsigned long and make obnr unsigned long too?

> +	objp = index_to_obj(cachep, slabp, objnr);
> +	realobj = (char *)objp + obj_offset(cachep);

The char pointer casting looks unnecessary here.

> +	size = obj_size(cachep);
> +	if (slab_bufctl(slabp)[objnr] == BUFCTL_FREE) {

You could do:

  if (slab_bufctl(slabp)[objnr] != BUFCTL_FREE)
          return;

to reduce nesting here.

> +		printk(KERN_ERR "ptr: %p, sz: %d, location: %s\n",
> +				ptr, sz, location);
> +		printk(KERN_ERR "write to freed object, size %d\n",
> +				size);
> +		if (cachep->flags & SLAB_STORE_USER) {
> +			printk(KERN_ERR "Last user: [<%p>]",
> +					*dbg_userword(cachep, objp));
> +			print_symbol("(%s)",
> +				(unsigned long)*dbg_userword(cachep, objp));
> +			printk("\n");
> +		}

It would be nice to clean this up a bit. See below for comments on how
to do it for SLUB.

> +
> +		dump_stack();
> +	}
> +}

don't we need

  EXPORT_SYMBOL(check_slab_write);

here?

> +#endif
> diff --git a/mm/slub.c b/mm/slub.c
> index a9201d8..b3fdd93 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4729,3 +4729,32 @@ static int __init slab_proc_init(void)
>  }
>  module_init(slab_proc_init);
>  #endif /* CONFIG_SLABINFO */
> +
> +#ifdef CONFIG_MUDFLAP
> +void check_slab_write(void *ptr, unsigned int sz, const char *location)
> +{

s/sz/size/g and use size_t

> +	struct page *page;
> +	struct kmem_cache *cachep;

  struct kmem_cache *s;

please

> +	struct slab *slabp;

Hmm? SLUB has no "struct slab"

> +	char *realobj;
> +	void *objp, *start;

s/objp/obj/

> +	int objnr, size;
> +
> +	page = virt_to_head_page(ptr);
> +	if (!PageSlab(page))
> +		return;
> +
> +	cachep = page->slab;
> +	start = page_address(page);
> +	objnr = (unsigned)(ptr - start) / cachep->size;

This looks wee bit fishy to me. You probably want to cast to "(unsigned
long)" and make "objnr" unsigned long.

> +	objp = start + cachep->size * objnr;
> +	if (on_freelist(cachep, page, objp)) {

You could do

  if (!on_freelist(cachep, page, objp))
       return;

to reduce nesting here.

> +		printk(KERN_ERR "ptr: %p, sz: %d, location: %s\n",
> +				ptr, sz, location);
> +		printk(KERN_ERR "write to freed object, size %d\n",
> +				cachep->size);

Can we make this error message more readable? Something like

  printk(KERN_ERR "%s: Write to free'd object %p (size=%d) in %s\n",
         s->name, ptr, size, location);

> +		print_tracking(cachep, objp);
> +		dump_stack();
> +	}
> +}

don't we need

  EXPORT_SYMBOL(check_slab_write);

here?

> +#endif

			Pekka


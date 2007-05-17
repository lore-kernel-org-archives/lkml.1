Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbXEQTew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbXEQTew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbXEQTeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:34:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbXEQTeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:34:44 -0400
Date: Thu, 17 May 2007 12:32:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zou Nan hai <nanhai.zou@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ak@suse.de, suresh.b.siddha@intel.com
Subject: Re: [Patch] Allocate sparsemem memmap above 4G on X86_64
Message-Id: <20070517123216.184104a8.akpm@linux-foundation.org>
In-Reply-To: <1179369607.4103.158.camel@linux-znh>
References: <1179369607.4103.158.camel@linux-znh>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 May 2007 10:40:07 +0800
Zou Nan hai <nanhai.zou@intel.com> wrote:

> On system with huge amount of physical memory. 
> VFS cache and memory memmap may eat all available system memory under
> 4G, then system may fail to allocated swiotlb bounce buffer. 
> 
> There was a fix in arch/x86_64/mm/numa.c, but that fix does not cover
> sparsemem model.
> This patch add fix to sparsemem model.
> 

This seems like something we need in 2.6.22, but this implementation is a
bit ugly-looking.

> 
> diff -Nraup a/include/asm-x86_64/mmzone.h b/include/asm-x86_64/mmzone.h
> --- a/include/asm-x86_64/mmzone.h	2007-05-17 09:38:02.000000000 +0800
> +++ b/include/asm-x86_64/mmzone.h	2007-05-17 09:54:10.000000000 +0800
> @@ -52,5 +52,10 @@ extern int pfn_valid(unsigned long pfn);
>  #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1uL))
>  #endif
>  
> +#define ARCH_HAS_ALLOC_BOOTMEM_HIGH_NODE 1
> +#define alloc_bootmem_high_node(pgdat,size) \
> +({__alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);})
> +
> +
>  #endif
>  #endif
> diff -Nraup a/include/linux/bootmem.h b/include/linux/bootmem.h
> --- a/include/linux/bootmem.h	2007-05-17 09:38:02.000000000 +0800
> +++ b/include/linux/bootmem.h	2007-05-17 09:37:00.000000000 +0800
> @@ -131,5 +131,8 @@ extern void *alloc_large_system_hash(con
>  #endif
>  extern int hashdist;		/* Distribute hashes across NUMA nodes? */
>  
> +#ifndef ARCH_HAS_ALLOC_BOOTMEM_HIGH_NODE
> +#define alloc_bootmem_high_node(pgdat, size) ({NULL;})
> +#endif
>  
>  #endif /* _LINUX_BOOTMEM_H */
> diff -Nraup a/mm/sparse.c b/mm/sparse.c
> --- a/mm/sparse.c	2007-05-17 09:38:03.000000000 +0800
> +++ b/mm/sparse.c	2007-05-17 09:54:27.000000000 +0800
> @@ -219,6 +219,11 @@ static struct page __init *sparse_early_
>  	if (map)
>  		return map;
>  
> +	map = alloc_bootmem_high_node(NODE_DATA(nid),
> +			sizeof(struct page) * PAGES_PER_SECTION);
> +        if (map)
> +                return map;
> +

Please use tabs, not spaces

>  	map = alloc_bootmem_node(NODE_DATA(nid),
>  			sizeof(struct page) * PAGES_PER_SECTION);
>  	if (map)
> 

Please always prefer to use static inline functions rather than macros. 
They are more readable, they are more likely to have comments attached to
them and they provide typechecking.

Please prefer to uninline functions by default.  One reason for this is
that adding inlines to headers increases include complexity.  This code is
all __init anyway, so the possible few bytes of text will get removed.


Try to avoid using the ARCH_HAS_FOO thing.  We have two alternatives:

a) use __attribute__((weak))

b) do:

	extern void foo(void);
	#define foo foo

   then, elsewhere,

	#ifndef foo
	#define foo() bar()
	#endif

Both tricks avoid the introduction of two new symbols into the global
namespace to solve a single problem.


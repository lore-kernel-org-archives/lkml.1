Return-Path: <linux-kernel-owner+w=401wt.eu-S1760621AbZBXVpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbZBXVpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbZBXVpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:45:13 -0500
Received: from cmpxchg.org ([85.214.51.133]:46928 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZBXVpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:45:11 -0500
Date: Tue, 24 Feb 2009 22:46:38 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: hpa@zytor.com, mingo@redhat.com, tj@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/percpu] bootmem: clean up arch-specific bootmem wrapping
Message-ID: <20090224214638.GA2049@cmpxchg.org>
References: <tip-c132937556f56ee4b831ef4b23f1846e05fde102@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-c132937556f56ee4b831ef4b23f1846e05fde102@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 08:23:03PM +0000, Tejun Heo wrote:
> Author:     Tejun Heo <tj@kernel.org>
> AuthorDate: Tue, 24 Feb 2009 11:57:20 +0900
> Commit:     Tejun Heo <tj@kernel.org>
> CommitDate: Tue, 24 Feb 2009 11:57:20 +0900
> 
> bootmem: clean up arch-specific bootmem wrapping
> 
> Impact: cleaner and consistent bootmem wrapping
> 
> By setting CONFIG_HAVE_ARCH_BOOTMEM_NODE, archs can define
> arch-specific wrappers for bootmem allocation.  However, this is done
> a bit strangely in that only the high level convenience macros can be
> changed while lower level, but still exported, interface functions
> can't be wrapped.  This not only is messy but also leads to strange
> situation where alloc_bootmem() does what the arch wants it to do but
> the equivalent __alloc_bootmem() call doesn't although they should be
> able to be used interchangeably.
> 
> This patch updates bootmem such that archs can override / wrap the
> backend function - alloc_bootmem_core() instead of the highlevel
> interface functions to allow simpler and consistent wrapping.  Also,
> HAVE_ARCH_BOOTMEM_NODE is renamed to HAVE_ARCH_BOOTMEM.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@saeurebad.de>

What does this message mean?  That the patch was commited to the -tip
tree?

Well, why not... oh, right, it is broken ;-)

> ---
>  arch/avr32/Kconfig               |    2 +-
>  arch/x86/Kconfig                 |    2 +-
>  arch/x86/include/asm/mmzone_32.h |   43 ++++---------------------------------
>  include/linux/bootmem.h          |   10 +++-----
>  mm/bootmem.c                     |   14 +++++++++--
>  5 files changed, 22 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
> index b189680..05fe305 100644
> --- a/arch/avr32/Kconfig
> +++ b/arch/avr32/Kconfig
> @@ -181,7 +181,7 @@ source "kernel/Kconfig.preempt"
>  config QUICKLIST
>  	def_bool y
>  
> -config HAVE_ARCH_BOOTMEM_NODE
> +config HAVE_ARCH_BOOTMEM
>  	def_bool n
>  
>  config ARCH_HAVE_MEMORY_PRESENT
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d3f6ead..6fd3b23 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1111,7 +1111,7 @@ config NODES_SHIFT
>  	  Specify the maximum number of NUMA Nodes available on the target
>  	  system.  Increases memory reserved to accomodate various tables.
>  
> -config HAVE_ARCH_BOOTMEM_NODE
> +config HAVE_ARCH_BOOTMEM
>  	def_bool y
>  	depends on X86_32 && NUMA
>  
> diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
> index 07f1af4..1e0fa9e 100644
> --- a/arch/x86/include/asm/mmzone_32.h
> +++ b/arch/x86/include/asm/mmzone_32.h
> @@ -93,45 +93,12 @@ static inline int pfn_valid(int pfn)
>  #endif /* CONFIG_DISCONTIGMEM */
>  
>  #ifdef CONFIG_NEED_MULTIPLE_NODES
> -
> -/*
> - * Following are macros that are specific to this numa platform.
> - */
> -#define reserve_bootmem(addr, size, flags) \
> -	reserve_bootmem_node(NODE_DATA(0), (addr), (size), (flags))

With the removal of the #ifdef around the generic reserve_bootmem(),
this will no longer use just node 0, but all numa nodes addr -
addr+size spans.

If it doesn't matter, well, okay.  But the patch description doesn't
say anything about this change.

> -#define alloc_bootmem(x) \
> -	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
> -#define alloc_bootmem_nopanic(x) \
> -	__alloc_bootmem_node_nopanic(NODE_DATA(0), (x), SMP_CACHE_BYTES, \
> -				__pa(MAX_DMA_ADDRESS))
> -#define alloc_bootmem_low(x) \
> -	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES, 0)
> -#define alloc_bootmem_pages(x) \
> -	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
> -#define alloc_bootmem_pages_nopanic(x) \
> -	__alloc_bootmem_node_nopanic(NODE_DATA(0), (x), PAGE_SIZE, \
> -				__pa(MAX_DMA_ADDRESS))
> -#define alloc_bootmem_low_pages(x) \
> -	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, 0)
> -#define alloc_bootmem_node(pgdat, x)					\
> -({									\
> -	struct pglist_data  __maybe_unused			\
> -				*__alloc_bootmem_node__pgdat = (pgdat);	\
> -	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES,	\
> -						__pa(MAX_DMA_ADDRESS));	\
> -})
> -#define alloc_bootmem_pages_node(pgdat, x)				\
> -({									\
> -	struct pglist_data  __maybe_unused			\
> -				*__alloc_bootmem_node__pgdat = (pgdat);	\
> -	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE,		\
> -						__pa(MAX_DMA_ADDRESS));	\
> -})
> -#define alloc_bootmem_low_pages_node(pgdat, x)				\
> +/* always use node 0 for bootmem on this numa platform */
> +#define alloc_bootmem_core(__bdata, size, align, goal, limit)		\
>  ({									\
> -	struct pglist_data  __maybe_unused			\
> -				*__alloc_bootmem_node__pgdat = (pgdat);	\
> -	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, 0);		\
> +	bootmem_data_t __maybe_unused *	__abm_bdata_dummy = (__bdata);	\
> +	__alloc_bootmem_core(NODE_DATA(0)->bdata,			\
> +			     (size), (align), (goal), (limit));		\
>  })
>  #endif /* CONFIG_NEED_MULTIPLE_NODES */
>  
> diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
> index 95837bf..3a87f93 100644
> --- a/include/linux/bootmem.h
> +++ b/include/linux/bootmem.h
> @@ -69,10 +69,9 @@ extern int reserve_bootmem_node(pg_data_t *pgdat,
>  				 unsigned long physaddr,
>  				 unsigned long size,
>  				 int flags);
> -#ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
> -extern int reserve_bootmem(unsigned long addr, unsigned long size, int flags);
> -#endif
> -
> +extern int reserve_bootmem(unsigned long addr,
> +			   unsigned long size,
> +			   int flags);
>  extern void *__alloc_bootmem_nopanic(unsigned long size,
>  			     unsigned long align,
>  			     unsigned long goal);
> @@ -94,7 +93,7 @@ extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
>  				      unsigned long size,
>  				      unsigned long align,
>  				      unsigned long goal);
> -#ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
> +
>  #define alloc_bootmem(x) \
>  	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
>  #define alloc_bootmem_nopanic(x) \
> @@ -113,7 +112,6 @@ extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
>  	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
>  #define alloc_bootmem_low_pages_node(pgdat, x) \
>  	__alloc_bootmem_low_node(pgdat, x, PAGE_SIZE, 0)
> -#endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
>  
>  extern int reserve_bootmem_generic(unsigned long addr, unsigned long size,
>  				   int flags);
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 51a0ccf..d7140c0 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -37,6 +37,16 @@ static struct list_head bdata_list __initdata = LIST_HEAD_INIT(bdata_list);
>  
>  static int bootmem_debug;
>  
> +/*
> + * If an arch needs to apply workarounds to bootmem allocation, it can
> + * set CONFIG_HAVE_ARCH_BOOTMEM and define a wrapper around
> + * __alloc_bootmem_core().
> + */
> +#ifndef CONFIG_HAVE_ARCH_BOOTMEM
> +#define alloc_bootmem_core(bdata, size, align, goal, limit)		\
> +	__alloc_bootmem_core((bdata), (size), (align), (goal), (limit))
> +#endif

Since it only allows macros anyway (__alloc_bootmem_core is local to
bootmem.c), we could just use this in asm/mmzone_32.h:

	#define alloc_bootmem_core(__bdata, size, align, goal, limit)	\
	({								\
		...							\
		alloc_bootmem_core(...);				\
	})

This should work without even renaming alloc_bootmem_core internally,
no?

Or would it be even better to export __alloc_bootmem_core() and allow
static inline wrappers that do nice type checking as well?

	Hannes

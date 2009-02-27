Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbZB0IPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbZB0IPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbZB0IPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:15:24 -0500
Received: from cmpxchg.org ([85.214.51.133]:55678 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbZB0IPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:15:23 -0500
Date: Fri, 27 Feb 2009 09:16:50 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/percpu] bootmem: clean up arch-specific bootmem wrapping
Message-ID: <20090227081650.GA2009@cmpxchg.org>
References: <tip-c132937556f56ee4b831ef4b23f1846e05fde102@kernel.org> <20090224214638.GA2049@cmpxchg.org> <20090224214932.GC12601@elte.hu> <20090224234949.GA1778@cmpxchg.org> <49A4ACAE.4020104@kernel.org> <20090225024316.GA1738@cmpxchg.org> <49A4CE93.3070908@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A4CE93.3070908@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 01:52:35PM +0900, Tejun Heo wrote:
> Commit c132937556f56ee4b831ef4b23f1846e05fde102 tried to clean up
> bootmem arch wrapper but it wasn't quite correct.  Before the commit,
> the followings were broken.
> 
> * Low level interface functions prefixed with __ ignored arch
>   preference.
> 
> * reserve_bootmem(...) can't be mapped into
>   reserve_bootmem_node(NODE_DATA(0)->bdata, ...) because the node is
>   not preference here.  The region specified MUST fall into the
>   specified region; otherwise, it will panic.
> 
> After the commit,
> 
> * If allocation fails for the arch preferred node, it should fallback
>   to whatever is available.  Instead, it simply failed allocation.
> 
> There are too many internal details to allow generic wrapping and
> still keep things simple for archs.  Plus, all that arch wants is a
> way to prefer certain node over another.
> 
> This patch drops the generic wrapping around alloc_bootmem_core() and
> add alloc_bootmem_core() instead.  If necessary, arch can define
> bootmem_arch_referred_node() macro or function which takes all
> allocation information and returns the preferred node.  bootmem
> generic code will always try the preferred node first and then
> fallback to other nodes as usual.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> ---
> It turns out reserve_bootmem() shouldn't be wrapped in the first
> place.  I hope I got it right this time.  Can you please review this
> one?  And I didn't think your comment was rude at all, no worries.

You are right!  Sorry, I missed that.  Yes, reserve_bootmem() operates
on ranges disregarding nodes.

>  arch/x86/include/asm/mmzone_32.h |    8 +-----
>  mm/bootmem.c                     |   45 ++++++++++++++++++++++++++-------------
>  2 files changed, 32 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
> index eeacf67..ede6998 100644
> --- a/arch/x86/include/asm/mmzone_32.h
> +++ b/arch/x86/include/asm/mmzone_32.h
> @@ -92,12 +92,8 @@ static inline int pfn_valid(int pfn)
>  
>  #ifdef CONFIG_NEED_MULTIPLE_NODES
>  /* always use node 0 for bootmem on this numa platform */
> -#define alloc_bootmem_core(__bdata, size, align, goal, limit)		\
> -({									\
> -	bootmem_data_t __maybe_unused *	__abm_bdata_dummy = (__bdata);	\
> -	__alloc_bootmem_core(NODE_DATA(0)->bdata,			\
> -			     (size), (align), (goal), (limit));		\
> -})
> +#define bootmem_arch_preferred_node(__bdata, size, align, goal, limit)	\
> +	(NODE_DATA(0)->bdata)
>  #endif /* CONFIG_NEED_MULTIPLE_NODES */
>  
>  #endif /* _ASM_X86_MMZONE_32_H */
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index d7140c0..daf9271 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -37,16 +37,6 @@ static struct list_head bdata_list __initdata = LIST_HEAD_INIT(bdata_list);
>  
>  static int bootmem_debug;
>  
> -/*
> - * If an arch needs to apply workarounds to bootmem allocation, it can
> - * set CONFIG_HAVE_ARCH_BOOTMEM and define a wrapper around
> - * __alloc_bootmem_core().
> - */
> -#ifndef CONFIG_HAVE_ARCH_BOOTMEM
> -#define alloc_bootmem_core(bdata, size, align, goal, limit)		\
> -	__alloc_bootmem_core((bdata), (size), (align), (goal), (limit))
> -#endif
> -
>  static int __init bootmem_debug_setup(char *buf)
>  {
>  	bootmem_debug = 1;
> @@ -436,9 +426,9 @@ static unsigned long align_off(struct bootmem_data *bdata, unsigned long off,
>  	return ALIGN(base + off, align) - base;
>  }
>  
> -static void * __init __alloc_bootmem_core(struct bootmem_data *bdata,
> -				unsigned long size, unsigned long align,
> -				unsigned long goal, unsigned long limit)
> +static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
> +					unsigned long size, unsigned long align,
> +					unsigned long goal, unsigned long limit)
>  {
>  	unsigned long fallback = 0;
>  	unsigned long min, max, start, sidx, midx, step;
> @@ -538,17 +528,34 @@ find_block:
>  	return NULL;
>  }
>  
> +static void * __init alloc_arch_preferred_bootmem(bootmem_data_t *bdata,
> +					unsigned long size, unsigned long align,
> +					unsigned long goal, unsigned long limit)
> +{
> +#ifdef CONFIG_HAVE_ARCH_BOOTMEM
> +	bootmem_data_t *p_bdata;
> +
> +	p_bdata = bootmem_arch_preferred_node(bdata, size, align, goal, limit);
> +	if (p_bdata)
> +		return alloc_bootmem_core(p_bdata, size, align, goal, limit);
> +#endif
> +	return NULL;
> +}
> +
>  static void * __init ___alloc_bootmem_nopanic(unsigned long size,
>  					unsigned long align,
>  					unsigned long goal,
>  					unsigned long limit)
>  {
>  	bootmem_data_t *bdata;
> +	void *region;
>  
>  restart:
> -	list_for_each_entry(bdata, &bdata_list, list) {
> -		void *region;
> +	region = alloc_arch_preferred_bootmem(NULL, size, align, goal, limit);
> +	if (region)
> +		return region;
>  
> +	list_for_each_entry(bdata, &bdata_list, list) {
>  		if (goal && bdata->node_low_pfn <= PFN_DOWN(goal))
>  			continue;
>  		if (limit && bdata->node_min_pfn >= PFN_DOWN(limit))
> @@ -626,6 +633,10 @@ static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
>  {
>  	void *ptr;
>  
> +	ptr = alloc_arch_preferred_bootmem(bdata, size, align, goal, limit);
> +	if (ptr)
> +		return ptr;
> +
>  	ptr = alloc_bootmem_core(bdata, size, align, goal, limit);
>  	if (ptr)
>  		return ptr;
> @@ -682,6 +693,10 @@ void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
>  {
>  	void *ptr;
>  
> +	ptr = alloc_arch_preferred_bootmem(pgdat->bdata, size, align, goal, 0);
> +	if (ptr)
> +		return ptr;
> +
>  	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
>  	if (ptr)
>  		return ptr;

Well, okay.

It is a bugfix for preferring the arch node even with the __interface.
But it brings ifdeffery/special casing to bootmem that was before in a
header file and is only for a very rare hardware setup, so I don't
think it is a cleanup, rather a necessity.

For now, let's just go with it.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

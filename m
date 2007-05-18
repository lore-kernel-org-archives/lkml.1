Return-Path: <linux-kernel-owner+w=401wt.eu-S1761671AbXERDYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761671AbXERDYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 23:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbXERDYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 23:24:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57838 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757535AbXERDYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 23:24:40 -0400
Date: Thu, 17 May 2007 20:22:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zou Nan hai <nanhai.zou@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ak@suse.de, suresh.b.siddha@intel.com
Subject: Re: [Patch] Allocate sparsemem memmap above 4G on X86_64
Message-Id: <20070517202211.4471b97b.akpm@linux-foundation.org>
In-Reply-To: <1179456777.2633.8.camel@linux-znh>
References: <1179369607.4103.158.camel@linux-znh>
	<20070517123216.184104a8.akpm@linux-foundation.org>
	<1179456777.2633.8.camel@linux-znh>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 May 2007 10:52:57 +0800 Zou Nan hai <nanhai.zou@intel.com> wrote:

> On Fri, 2007-05-18 at 03:32, Andrew Morton wrote:
> > On 17 May 2007 10:40:07 +0800
> > Zou Nan hai <nanhai.zou@intel.com> wrote:
> > 
> > > 
> > Please always prefer to use static inline functions rather than macros. 
> > They are more readable, they are more likely to have comments attached to
> > them and they provide typechecking.
> > 
> > Please prefer to uninline functions by default.  One reason for this is
> > that adding inlines to headers increases include complexity.  This code is
> > all __init anyway, so the possible few bytes of text will get removed.
> > 
> > 
> > Try to avoid using the ARCH_HAS_FOO thing.  We have two alternatives:
> > 
> > a) use __attribute__((weak))
> > 
> > b) do:
> > 
> > 	extern void foo(void);
> > 	#define foo foo
> > 
> >    then, elsewhere,
> > 
> > 	#ifndef foo
> > 	#define foo() bar()
> > 	#endif
> > 
> > Both tricks avoid the introduction of two new symbols into the global
> > namespace to solve a single problem.
>   On systems with huge amount of physical memory, VFS cache and memory
> memmap may eat all available system memory under 4G, then the system may
> fail to allocate swiotlb bounce buffer.
>   There was a fix for this issue in arch/x86_64/mm/numa.c, but that fix
> dose not cover sparsemem model.
>   This patch add fix to sparsemem model by first try to allocate memmap
> above 4G.
> 
> Signed-off-by:	Zou Nan hai <nanhai.zou@intel.com>
> Acked-by:	Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86_64/mm/init.c |    6 ++++++
>  mm/sparse.c           |   11 +++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff -Nraup a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
> --- a/arch/x86_64/mm/init.c	2007-05-19 16:54:46.000000000 +0800
> +++ b/arch/x86_64/mm/init.c	2007-05-19 17:43:47.000000000 +0800
> @@ -761,3 +761,9 @@ int in_gate_area_no_task(unsigned long a
>  {
>  	return (addr >= VSYSCALL_START) && (addr < VSYSCALL_END);
>  }
> +
> +void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
> +{
> +	return __alloc_bootmem_core(pgdat->bdata, size,
> +			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
> +}
> diff -Nraup a/mm/sparse.c b/mm/sparse.c
> --- a/mm/sparse.c	2007-05-19 16:54:48.000000000 +0800
> +++ b/mm/sparse.c	2007-05-19 17:44:01.000000000 +0800
> @@ -209,6 +209,12 @@ static int __meminit sparse_init_one_sec
>  	return 1;
>  }
>  
> +__attribute__((weak))
> +void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
> +{
> +	return NULL;
> +}
> +
>  static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
>  {
>  	struct page *map;
> @@ -219,6 +225,11 @@ static struct page __init *sparse_early_
>  	if (map)
>  		return map;
>  
> +  	map = alloc_bootmem_high_node(NODE_DATA(nid),
> +                       sizeof(struct page) * PAGES_PER_SECTION);
> +	if (map)
> +		return map;
> +
>  	map = alloc_bootmem_node(NODE_DATA(nid),
>  			sizeof(struct page) * PAGES_PER_SECTION);
>  	if (map)

Fair enough.  But we should ensure that there's a prototype in a header
file which is included by both definition sites and by all callers.  So the
compiler checks that everything is consistent:

--- a/include/linux/bootmem.h~x86_64-allocate-sparsemem-memmap-above-4g-fix
+++ a/include/linux/bootmem.h
@@ -59,6 +59,7 @@ extern void *__alloc_bootmem_core(struct
 				  unsigned long align,
 				  unsigned long goal,
 				  unsigned long limit);
+extern void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size);
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
 extern void reserve_bootmem(unsigned long addr, unsigned long size);
_


Andi, does this all look OK for 2.6.22 and for 2.6.21?

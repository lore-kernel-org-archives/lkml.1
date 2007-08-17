Return-Path: <linux-kernel-owner+w=401wt.eu-S1762829AbXHQQWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762829AbXHQQWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbXHQQWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:22:02 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:35223 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbXHQQWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:22:00 -0400
Date: Fri, 17 Aug 2007 12:21:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Simple Performance Counters: SLUB instrumentation
Message-ID: <20070817162154.GB30922@Krystal>
References: <1185924312685-git-send-email-clameter@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1185924312685-git-send-email-clameter@sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:12:33 up 18 days, 16:31,  5 users,  load average: 0.84, 1.86, 2.15
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

A few remarks on these tests:

Why do you printk inside the timing period ? Filling the printk buffers
or outputting on things such as serial console could really hurt your
results.

I hope you run your system with idle=poll and without frequency scaling
at all, because otherwise your cycle count would be completely off on
many AMD and Intel CPUs. You can have a look at this (very rough)
document on the topic: 

http://ltt.polymtl.ca/ > "Notes on AMD and Intel asynchronous TSC
                          architectures (with workarounds)"
http://ltt.polymtl.ca/svn/ltt/branches/poly/doc/developer/tsc.txt

I would be tempted to try running these tests with interrupts disabled,
just to make sure that the timings are not too much modified by
the system load. Especially since you are comparing an algorithm that
disables interrupts with one that doesn't, it would be unfair to say
that the second one is slower just because less interrupts have been
serviced during its execution.

Mathieu

* Christoph Lameter (clameter@sgi.com) wrote:
> With this patch SLUB will perform tests on bootup and display results.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> ---
>  mm/slub.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 92 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 6c6d74f..568b16a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -20,6 +20,7 @@
>  #include <linux/mempolicy.h>
>  #include <linux/ctype.h>
>  #include <linux/kallsyms.h>
> +#include <linux/perf.h>
>  
>  /*
>   * Lock order:
> @@ -152,6 +153,7 @@ static inline void ClearSlabDebug(struct page *page)
>  
>  /* Enable to test recovery from slab corruption on boot */
>  #undef SLUB_RESILIENCY_TEST
> +#undef SLUB_PERFORMANCE_TEST
>  
>  #if PAGE_SHIFT <= 12
>  
> @@ -2870,9 +2872,97 @@ static long validate_slab_cache(struct kmem_cache *s)
>  	return count;
>  }
>  
> -#ifdef SLUB_RESILIENCY_TEST
>  static void resiliency_test(void)
>  {
> +#ifdef SLUB_PERFORMANCE_TEST
> +#define TEST_COUNT 10000
> +	int size, i;
> +	struct pc x;
> +	void **v = kmalloc(TEST_COUNT * sizeof(void *), GFP_KERNEL);
> +
> +	printk(KERN_INFO "SLUB Performance testing\n");
> +	printk(KERN_INFO "========================\n");
> +	printk(KERN_INFO "1. Kmalloc: Repeatedly allocate then free test\n");
> +	for (size = 8; size <= PAGE_SIZE << 2; size <<= 1) {
> +		pc_start(&x);
> +		for(i = 0; i < TEST_COUNT; i++) {
> +			v[i] = kmalloc(size, GFP_KERNEL);
> +		}
> +		printk(KERN_INFO "%i times kmalloc(%d) = ", i, size);
> +		pc_stop_printk(&x);
> +		pc_start(&x);
> +		for(i = 0; i < TEST_COUNT; i++)
> +			kfree(v[i]);
> +		printk(" kfree() = ");
> +		pc_stop_printk(&x);
> +		printk("\n");
> +	}
> +
> +	printk(KERN_INFO "2. Kmalloc: alloc/free test\n");
> +	for (size = 8; size <= PAGE_SIZE << 2; size <<= 1) {
> +		pc_start(&x);
> +		for(i = 0; i < TEST_COUNT; i++)
> +			kfree(kmalloc(size, GFP_KERNEL));
> +		printk(KERN_INFO "%i times kmalloc(%d)/kfree = ", i, size);
> +		pc_stop_printk(&x);
> +		printk("\n");
> +	}
> +	printk(KERN_INFO "3. kmem_cache_alloc: Repeatedly allocate then free test\n");
> +	for (size = 3; size <= PAGE_SHIFT; size ++) {
> +		pc_start(&x);
> +		for(i = 0; i < TEST_COUNT; i++) {
> +			v[i] = kmem_cache_alloc(kmalloc_caches + size, GFP_KERNEL);
> +		}
> +		printk(KERN_INFO "%d times kmem_cache_alloc(%d) = ", i, 1 << size);
> +		pc_stop_printk(&x);
> +		pc_start(&x);
> +		for(i = 0; i < TEST_COUNT; i++)
> +			kmem_cache_free(kmalloc_caches + size, v[i]);
> +		printk(" kmem_cache_free() = ");
> +		pc_stop_printk(&x);
> +		printk("\n");
> +	}
> +
> +	printk(KERN_INFO "4. kmem_cache_alloc: alloc/free test\n");
> +	for (size = 3; size <= PAGE_SHIFT; size++) {
> +		pc_start(&x);
> +		for(i = 0; i < TEST_COUNT; i++)
> +			kmem_cache_free(kmalloc_caches + size,
> +				kmem_cache_alloc(kmalloc_caches + size,
> +							GFP_KERNEL));
> +		printk(KERN_INFO "%d times kmem_cache_alloc(%d)/kmem_cache_free = ", i, 1 << size);
> +		pc_stop_printk(&x);
> +		printk("\n");
> +	}
> +	printk(KERN_INFO "5. kmem_cache_zalloc: Repeatedly allocate then free test\n");
> +	for (size = 3; size <= PAGE_SHIFT; size ++) {
> +		pc_start(&x);
> +		for(i = 0; i < TEST_COUNT; i++) {
> +			v[i] = kmem_cache_zalloc(kmalloc_caches + size, GFP_KERNEL);
> +		}
> +		printk(KERN_INFO "%d times kmem_cache_zalloc(%d) = ", i, 1 << size);
> +		pc_stop_printk(&x);
> +		pc_start(&x);
> +		for(i = 0; i < TEST_COUNT; i++)
> +			kmem_cache_free(kmalloc_caches + size, v[i]);
> +		printk(" kmem_cache_free() = ");
> +		pc_stop_printk(&x);
> +		printk("\n");
> +	}
> +
> +	printk(KERN_INFO "6. kmem_cache_zalloc: alloc/free test\n");
> +	for (size = 3; size <= PAGE_SHIFT; size++) {
> +		pc_start(&x);
> +		for(i = 0; i < TEST_COUNT; i++)
> +			kmem_cache_free(kmalloc_caches + size,
> +				kmem_cache_zalloc(kmalloc_caches + size,
> +							GFP_KERNEL));
> +		printk(KERN_INFO "%d times kmem_cache_zalloc(%d)/kmem_cache_free = ", i, 1 << size);
> +		pc_stop_printk(&x);
> +		printk("\n");
> +	}
> +#endif
> +#ifdef SLUB_RESILIENCY_TEST
>  	u8 *p;
>  
>  	printk(KERN_ERR "SLUB resiliency testing\n");
> @@ -2920,11 +3010,8 @@ static void resiliency_test(void)
>  	p[512] = 0xab;
>  	printk(KERN_ERR "\n3. kmalloc-512: Clobber redzone 0xab->0x%p\n\n", p);
>  	validate_slab_cache(kmalloc_caches + 9);
> -}
> -#else
> -static void resiliency_test(void) {};
>  #endif
> -
> +}
>  /*
>   * Generate lists of code addresses where slabcache objects are allocated
>   * and freed.
> -- 
> 1.5.2.4
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

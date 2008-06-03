Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYFCOA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYFCOA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 10:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYFCOAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 10:00:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49369 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYFCOAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 10:00:14 -0400
Date: Tue, 03 Jun 2008 22:59:16 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH -mm 11/14] bootmem: respect goal more likely
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080603005304.127252672@saeurebad.de>
References: <20080603005017.593345596@saeurebad.de> <20080603005304.127252672@saeurebad.de>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080603225700.9780.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hmm, my ia64 (NUMA) box can't boot up with this patch.
I'll chase its cause deeply tomorrow.

Bye.

> The old node-agnostic code tried allocating on all nodes starting from
> the one with the lowest range.  alloc_bootmem_core retried without the
> goal if it could not satisfy it and so the goal was only respected at
> all when it happened to be on the first (lowest page numbers) node (or
> theoretically if allocations failed on all nodes before to the one
> holding the goal).
> 
> Introduce a non-panicking helper that starts allocating from the node
> holding the goal and falls back only after all these tries failed.
> 
> Make all other allocation helpers benefit from this new helper.
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Yinghai Lu <yhlu.kernel@gmail.com>
> CC: Andi Kleen <andi@firstfloor.org>
> ---
> 
>  mm/bootmem.c |   90 ++++++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 52 insertions(+), 38 deletions(-)
> 
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -408,6 +408,7 @@ static void * __init alloc_bootmem_core(
>  				unsigned long size, unsigned long align,
>  				unsigned long goal, unsigned long limit)
>  {
> +	unsigned long fallback = 0;
>  	unsigned long min, max, start, step;
>  
>  	BUG_ON(!size);
> @@ -441,10 +442,11 @@ static void * __init alloc_bootmem_core(
>  
>  	max -= PFN_DOWN(bdata->node_boot_start);
>  	start -= PFN_DOWN(bdata->node_boot_start);
> +	fallback -= PFN_DOWN(bdata->node_boot_start);
>  
>  	if (bdata->last_success > start) {
> -		/* Set goal here to trigger a retry on failure */
> -		start = goal = ALIGN(bdata->last_success, step);
> +		fallback = start;
> +		start = ALIGN(bdata->last_success, step);
>  	}
>  
>  	while (1) {
> @@ -491,10 +493,39 @@ find_block:
>  		return region;
>  	}
>  
> +	if (fallback) {
> +		start = ALIGN(fallback, step);
> +		fallback = 0;
> +		goto find_block;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void * __init ___alloc_bootmem_nopanic(unsigned long size,
> +					unsigned long align,
> +					unsigned long goal,
> +					unsigned long limit)
> +{
> +	bootmem_data_t *bdata;
> +
> +restart:
> +	list_for_each_entry(bdata, &bdata_list, list) {
> +		void *region;
> +
> +		if (goal && goal < bdata->node_boot_start)
> +			continue;
> +		if (limit && limit < bdata->node_boot_start)
> +			continue;
> +
> +		region = alloc_bootmem_core(bdata, size, align, goal, limit);
> +		if (region)
> +			return region;
> +	}
> +
>  	if (goal) {
>  		goal = 0;
> -		start = 0;
> -		goto find_block;
> +		goto restart;
>  	}
>  
>  	return NULL;
> @@ -514,16 +545,23 @@ find_block:
>   * Returns NULL on failure.
>   */
>  void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
> -				      unsigned long goal)
> +					unsigned long goal)
>  {
> -	bootmem_data_t *bdata;
> -	void *ptr;
> +	return ___alloc_bootmem_nopanic(size, align, goal, 0);
> +}
>  
> -	list_for_each_entry(bdata, &bdata_list, list) {
> -		ptr = alloc_bootmem_core(bdata, size, align, goal, 0);
> -		if (ptr)
> -			return ptr;
> -	}
> +static void * __init ___alloc_bootmem(unsigned long size, unsigned long align,
> +					unsigned long goal, unsigned long limit)
> +{
> +	void *mem = ___alloc_bootmem_nopanic(size, align, goal, limit);
> +
> +	if (mem)
> +		return mem;
> +	/*
> +	 * Whoops, we cannot satisfy the allocation request.
> +	 */
> +	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
> +	panic("Out of memory");
>  	return NULL;
>  }
>  
> @@ -543,16 +581,7 @@ void * __init __alloc_bootmem_nopanic(un
>  void * __init __alloc_bootmem(unsigned long size, unsigned long align,
>  			      unsigned long goal)
>  {
> -	void *mem = __alloc_bootmem_nopanic(size,align,goal);
> -
> -	if (mem)
> -		return mem;
> -	/*
> -	 * Whoops, we cannot satisfy the allocation request.
> -	 */
> -	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
> -	panic("Out of memory");
> -	return NULL;
> +	return ___alloc_bootmem(size, align, goal, 0);
>  }
>  
>  #ifndef ARCH_LOW_ADDRESS_LIMIT
> @@ -575,22 +604,7 @@ void * __init __alloc_bootmem(unsigned l
>  void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
>  				  unsigned long goal)
>  {
> -	bootmem_data_t *bdata;
> -	void *ptr;
> -
> -	list_for_each_entry(bdata, &bdata_list, list) {
> -		ptr = alloc_bootmem_core(bdata, size, align, goal,
> -					ARCH_LOW_ADDRESS_LIMIT);
> -		if (ptr)
> -			return ptr;
> -	}
> -
> -	/*
> -	 * Whoops, we cannot satisfy the allocation request.
> -	 */
> -	printk(KERN_ALERT "low bootmem alloc of %lu bytes failed!\n", size);
> -	panic("Out of low memory");
> -	return NULL;
> +	return ___alloc_bootmem(size, align, goal, ARCH_LOW_ADDRESS_LIMIT);
>  }
>  
>  /**
> 
> -- 
> 

-- 
Yasunori Goto 



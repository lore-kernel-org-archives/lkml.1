Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbZKJIGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbZKJIGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 03:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZKJIF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 03:05:59 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33419 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbZKJIF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 03:05:59 -0500
Message-ID: <4AF91EE0.9090906@cs.helsinki.fi>
Date: Tue, 10 Nov 2009 10:05:52 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       joerg.roedel@amd.com, mingo@elte.hu, akpm@linux-foundation.org,
       hannes@cmpxchg.org, tj@kernel.org
Subject: Re: [PATCH 07/10] bootmem: add free_bootmem_late
References: <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>	<84144f020911091213j393a9761pe13808d1e091e169@mail.gmail.com>	<84144f020911091221n1d025d9bv3915751bf474b47a@mail.gmail.com> <20091110064650H.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091110064650H.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Mon, 9 Nov 2009 22:21:48 +0200
> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
>> On Mon, Nov 9, 2009 at 10:13 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>>>        for (cursor = start; cursor < end; cursor += BITS_PER_LONG) {
>>>> -               unsigned long idx, vec;
>>>> +               unsigned long vec;
>>>>
>>>> -               idx = cursor - start;
>>>> -               vec = ~map[idx / BITS_PER_LONG];
>>>> +               if (map) {
>>>> +                       unsigned long idx = cursor - start;
>>>> +                       vec = ~map[idx / BITS_PER_LONG];
>>>> +               } else {
>>>> +                       if (end - cursor >= BITS_PER_LONG)
>>>> +                               vec = ~0UL;
>>> Why do we need the above?
>> OK, I figured that out. I'm not sure why you want to play tricks with
>> "vec" when you could just add a new helper that calls
>> __free_pages_bootmem() for the full contiguous page range.
> 
> I'm not sure why Chris did that, but yeah, I think that it's cleaner
> to leave free_all_bootmem_core alone.
> 
> There is just one user of free_bootmem_late to free some memory so how
> about the following simple patch instead 7/10?

Looks good to me!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
> index dd97fb8..b10ec49 100644
> --- a/include/linux/bootmem.h
> +++ b/include/linux/bootmem.h
> @@ -53,6 +53,7 @@ extern void free_bootmem_node(pg_data_t *pgdat,
>  			      unsigned long addr,
>  			      unsigned long size);
>  extern void free_bootmem(unsigned long addr, unsigned long size);
> +extern void free_bootmem_late(unsigned long addr, unsigned long size);
>  
>  /*
>   * Flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 94ef2e7..b0b393b 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -196,6 +196,30 @@ static unsigned long __init free_bootmem_pages(unsigned long start,
>  	return count;
>  }
>  
> +/*
> + * free_bootmem_late - free bootmem pages directly to page allocator
> + * @addr: starting address of the range
> + * @size: size of the range in bytes
> + *
> + * This is only useful when the bootmem allocator has already been torn
> + * down, but we are still initializing the system.  Pages are given directly
> + * to the page allocator, no bootmem metadata is updated because it is gone.
> + */
> +void __init free_bootmem_late(unsigned long addr, unsigned long size)
> +{
> +	unsigned long cursor, end;
> +
> +	kmemleak_free_part(__va(addr), size);
> +
> +	cursor = PFN_UP(addr);
> +	end = PFN_DOWN(addr + size);
> +
> +	for (; cursor < end; cursor++) {
> +		__free_pages_bootmem(pfn_to_page(cursor), 0);
> +		totalram_pages++;
> +	}
> +}
> +
>  static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
>  {
>  	struct page *page;
> 
> 


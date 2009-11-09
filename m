Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbZKIUNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbZKIUNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZKIUNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:13:37 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41978 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZKIUNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:13:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UCprlEq6gxZUOGhrqNaE2IEJXHcAsGLsH1d2xLpUDQHkMQzDUEXm3iTqL1GBOX5F/9
         Uj8YRrXwK+HmDmvrO7C78gWN3yZaUeS7ZSV2v8+rRHcQn/Iir489siXGOdZuHlAtss3/
         SkVR+FU4/q80w9vBskhn4wtakaJFN6CNHLBkU=
MIME-Version: 1.0
In-Reply-To: <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 9 Nov 2009 22:13:40 +0200
X-Google-Sender-Auth: 8918fdc02af6b671
Message-ID: <84144f020911091213j393a9761pe13808d1e091e169@mail.gmail.com>
Subject: Re: [PATCH 07/10] bootmem: add free_bootmem_late
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       joerg.roedel@amd.com, mingo@elte.hu,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 8:47 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> @@ -151,7 +151,9 @@ unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
>  *
>  * This will free the pages in the range @start to @end, making them
>  * available to the page allocator.  The @map will be used to skip
> - * reserved pages.  Returns the count of pages freed.
> + * reserved pages.  In the case that @map is NULL, the bootmem allocator
> + * is already free and the range is contiguous.  Returns the count of
> + * pages freed.
>  */
>  static unsigned long __init free_bootmem_pages(unsigned long start,
>                                               unsigned long end,
> @@ -164,13 +166,23 @@ static unsigned long __init free_bootmem_pages(unsigned long start,
>         * If the start is aligned to the machines wordsize, we might
>         * be able to free pages in bulks of that order.
>         */
> -       aligned = !(start & (BITS_PER_LONG - 1));
> +       if (map)
> +               aligned = !(start & (BITS_PER_LONG - 1));
> +       else
> +               aligned = 1;

Why do we need this special casing here? Isn't start always aligned
properly for callers with map == NULL?

>
>        for (cursor = start; cursor < end; cursor += BITS_PER_LONG) {
> -               unsigned long idx, vec;
> +               unsigned long vec;
>
> -               idx = cursor - start;
> -               vec = ~map[idx / BITS_PER_LONG];
> +               if (map) {
> +                       unsigned long idx = cursor - start;
> +                       vec = ~map[idx / BITS_PER_LONG];
> +               } else {
> +                       if (end - cursor >= BITS_PER_LONG)
> +                               vec = ~0UL;

Why do we need the above?

> +                       else
> +                               vec = (1UL << (end - cursor)) - 1;
> +               }
>
>                if (aligned && vec == ~0UL && cursor + BITS_PER_LONG < end) {
>                        int order = ilog2(BITS_PER_LONG);
> @@ -387,6 +399,27 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
>  }
>
>  /**
> + * free_bootmem_late - free bootmem pages directly to page allocator
> + * @addr: starting address of the range
> + * @size: size of the range in bytes
> + *
> + * This is only useful when the bootmem allocator has already been torn
> + * down, but we are still initializing the system.  Pages are given directly
> + * to the page allocator, no bootmem metadata is updated because it is gone.
> + */
> +void __init free_bootmem_late(unsigned long addr, unsigned long size)
> +{
> +       unsigned long start, end;
> +
> +       kmemleak_free_part(__va(addr), size);
> +
> +       start = PFN_UP(addr);
> +       end = PFN_DOWN(addr + size);
> +
> +       totalram_pages += free_bootmem_pages(start, end, NULL);
> +}
> +
> +/**
>  * reserve_bootmem_node - mark a page range as reserved
>  * @pgdat: node the range resides on
>  * @physaddr: starting address of the range
> --
> 1.5.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

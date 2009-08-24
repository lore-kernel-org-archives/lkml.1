Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZHXTny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZHXTny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 15:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZHXTnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 15:43:53 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49907 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbZHXTnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 15:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZU4mkD6ZshLk0dx4FKfCsVylZOIjdAg4e94WIjnti7aAexWZItHV0x28qwLvqWzfXn
         ZdnuQL20Mno3pKjeMrhMFPoVuAIT3e4QPl01TKElt9SsvhQTtdrnW0ANuibe7UCAqQqV
         48aNELvlhUm5+gELMFyfXIG1eUw6m33P6r0vQ=
MIME-Version: 1.0
In-Reply-To: <4A92EBB4.1070101@vflare.org>
References: <200908241007.47910.ngupta@vflare.org>
	 <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com>
	 <4A92EBB4.1070101@vflare.org>
Date: Mon, 24 Aug 2009 22:43:53 +0300
X-Google-Sender-Auth: 242ed19434354fbd
Message-ID: <84144f020908241243y11f10e8eudc758b61527e0e9c@mail.gmail.com>
Subject: Re: [PATCH 1/4] compcache: xvmalloc memory allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ngupta@vflare.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On Mon, Aug 24, 2009 at 10:36 PM, Nitin Gupta<ngupta@vflare.org> wrote:
> On 08/24/2009 11:03 PM, Pekka Enberg wrote:
>
> <snip>
>
>> On Mon, Aug 24, 2009 at 7:37 AM, Nitin Gupta<ngupta@vflare.org>  wrote:
>>>
>>> +/**
>>> + * xv_malloc - Allocate block of given size from pool.
>>> + * @pool: pool to allocate from
>>> + * @size: size of block to allocate
>>> + * @pagenum: page no. that holds the object
>>> + * @offset: location of object within pagenum
>>> + *
>>> + * On success,<pagenum, offset>  identifies block allocated
>>> + * and 0 is returned. On failure,<pagenum, offset>  is set to
>>> + * 0 and -ENOMEM is returned.
>>> + *
>>> + * Allocation requests with size>  XV_MAX_ALLOC_SIZE will fail.
>>> + */
>>> +int xv_malloc(struct xv_pool *pool, u32 size, u32 *pagenum, u32 *offset,
>>> +                                                       gfp_t flags)
>
> <snip>
>
>>
>> What's the purpose of passing PFNs around? There's quite a lot of PFN
>> to struct page conversion going on because of it. Wouldn't it make
>> more sense to return (and pass) a pointer to struct page instead?
>
> PFNs are 32-bit on all archs while for 'struct page *', we require 32-bit or
> 64-bit depending on arch. ramzswap allocates a table entry <pagenum, offset>
> corresponding to every swap slot. So, the size of table will unnecessarily
> increase on 64-bit archs. Same is the argument for xvmalloc free list sizes.
>
> Also, xvmalloc and ramzswap itself does PFN -> 'struct page *' conversion
> only when freeing the page or to get a deferencable pointer.

I still don't see why the APIs have work on PFNs. You can obviously do
the conversion once for store and load. Look at what the code does,
it's converting struct page to PFN just to do the reverse for kmap().
I think that could be cleaned by passing struct page around.

                        Pekka

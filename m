Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbZGRB3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbZGRB3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 21:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbZGRB3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 21:29:46 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:17631 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbZGRB3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 21:29:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TJd+YRFR9DuSe1vqUbk/4qhrk3nPDfF/8p/WRj2V+Wubo/LU+SCRkvls9fgyFUJa5j
         N9+OfwsiLOZ55PYST3VY6+1vip/XFBTCvjwAc4me31aUHoEcYji04bJtfaGA9Ce9fG+3
         MT8Ly8V9gI/faWBLEuYkosDi+IFw23wAfm/W0=
MIME-Version: 1.0
In-Reply-To: <20090717174128.36d00972.akpm@linux-foundation.org>
References: <20090704020949.GA3047@localhost.localdomain>
	 <20090717174128.36d00972.akpm@linux-foundation.org>
Date: Sat, 18 Jul 2009 10:29:44 +0900
Message-ID: <961aa3350907171829i52c095aam610ae2dc3d931080@mail.gmail.com>
Subject: Re: [PATCH] mm: add gfp mask checking for __get_free_pages()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/18 Andrew Morton <akpm@linux-foundation.org>:
> On Sat, 4 Jul 2009 11:09:50 +0900
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> __get_free_pages() with __GFP_HIGHMEM is not safe because the return
>> address cannot represent a highmem page. get_zeroed_page() already has
>> such a debug checking.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>>  mm/page_alloc.c |   24 +++++++++---------------
>>  1 files changed, 9 insertions(+), 15 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index e0f2cdf..4a1a374 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1903,31 +1903,25 @@ EXPORT_SYMBOL(__alloc_pages_nodemask);
>>   */
>>  unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
>>  {
>> -     struct page * page;
>> +     struct page *page;
>> +
>> +     /*
>> +      * __get_free_pages() returns a 32-bit address, which cannot represent
>> +      * a highmem page
>> +      */
>> +     VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
>> +
>>       page = alloc_pages(gfp_mask, order);
>>       if (!page)
>>               return 0;
>>       return (unsigned long) page_address(page);
>>  }
>> -
>>  EXPORT_SYMBOL(__get_free_pages);
>>
>>  unsigned long get_zeroed_page(gfp_t gfp_mask)
>>  {
>> -     struct page * page;
>> -
>> -     /*
>> -      * get_zeroed_page() returns a 32-bit address, which cannot represent
>> -      * a highmem page
>> -      */
>> -     VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
>> -
>> -     page = alloc_pages(gfp_mask | __GFP_ZERO, 0);
>> -     if (page)
>> -             return (unsigned long) page_address(page);
>> -     return 0;
>> +     return __get_free_pages(gfp_mask | __GFP_ZERO, 0);
>>  }
>> -
>>  EXPORT_SYMBOL(get_zeroed_page);
>>
>>  void __pagevec_free(struct pagevec *pvec)
>
> Fair enough.
>
> I suspect we could just delete that VM_BUG_ON() - we can't go and do
> runtime checking for every darn programmer error, and this would be a
> pretty dumb one.

Maybe. But we had such a bug in c51b1a160b63304720d49479986915e4c475a2cf
(xip: fix get_zeroed_page with __GFP_HIGHME). Even the VM code
had it and did not fixed for a long time.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1031028AbXDXCQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031028AbXDXCQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 22:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161024AbXDXCQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 22:16:16 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:44536 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031028AbXDXCQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 22:16:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=6kmNrhinhB5kT4yLvdQda8ydkmOc+bEOYkL6ZV1iFJMjlQWi5wo8cIzFpsVKl9K+bBx0uEowtAez5ABOvrPY5s6ZX+4Eo/zYbp7vI3Uyz3BgYtv/Ml3HluTwkp/XDvTZMd8WIxnfaOOfwKLiXXugi7Sjkbv2k5lElT9+x+WJtjk=  ;
X-YMail-OSG: 7e_QKOgVM1knR.JUGiOcJ_hDci7dK.jJAiaUKjPhEFFGVWq8oweJfO5ODVsi.eAjLJtMW5Jyrw--
Message-ID: <462D6866.8030207@yahoo.com.au>
Date: Tue, 24 Apr 2007 12:16:06 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>,
       jakub@redhat.com, drepper@redhat.com
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com>	<20070420135715.f6e8e091.akpm@linux-foundation.org>	<462932BE.4020005@redhat.com> <20070420150618.179d31a4.akpm@linux-foundation.org> <4629524C.5040302@redhat.com> <462ACA40.8070407@yahoo.com.au> <462B0156.9020407@redhat.com> <462BFAF3.4040509@yahoo.com.au> <462C2DC7.5070709@redhat.com> <462C2F33.8090508@redhat.com> <462C7A6F.9030905@redhat.com> <462C88B1.8080906@yahoo.com.au> <462C8B0A.8060801@redhat.com> <462C8BFF.2050405@yahoo.com.au> <462C8E1D.8000706@redhat.com> <462D5A2E.5060908@yahoo.com.au> <462D643C.5020709@redhat.com>
In-Reply-To: <462D643C.5020709@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> This should fix the MADV_FREE code for PPC's hashed tlb.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
> 
> Nick Piggin wrote:
> 
>>> Nick Piggin wrote:
>>>
>>>>> 3) because of this, we can treat any such accesses as
>>>>>    happening simultaneously with the MADV_FREE and
>>>>>    as illegal, aka undefined behaviour territory and
>>>>>    we do not need to worry about them
>>>>
>>>>
>>>>
>>>> Yes, but I'm wondering if it is legal in all architectures.
>>>
>>>
>>>
>>> It's similar to trying to access memory during an munmap.
>>>
>>> You may be able to for a short time, but it'll come back to
>>> haunt you.
>>
>>
>> The question is whether the architecture specific tlb
>> flushing code will break or not.
> 
> 
> I guess we'll need to call tlb_remove_tlb_entry() inside the
> MADV_FREE code to keep powerpc happy.
> 
> Thanks for pointing this one out.
> 
>>> Even then we do.  Each invocation of zap_pte_range() only touches
>>> one page table page, and it flushes the TLB before releasing the
>>> page table lock.
>>
>>
>> What kernel are you looking at? -rc7 and rc6-mm1 don't, AFAIKS.
> 
> 
> Oh dear.  I see it now...
> 
> The tlb end things inside zap_pte_range() are actually
> noops and the actual tlb flush only happens inside
> zap_page_range().
> 
> I guess the fact that munmap gets the mmap_sem for
> writing should save us, though...

What about an unmap_mapping_range, or another MADV_FREE or
MADV_DONTNEED?

> 
> 
> ------------------------------------------------------------------------
> 
> --- linux-2.6.20.x86_64/mm/memory.c.noppc	2007-04-23 21:50:09.000000000 -0400
> +++ linux-2.6.20.x86_64/mm/memory.c	2007-04-23 21:48:59.000000000 -0400
> @@ -679,6 +679,7 @@ static unsigned long zap_pte_range(struc
>  					}
>  					ptep_test_and_clear_dirty(vma, addr, pte);
>  					ptep_test_and_clear_young(vma, addr, pte);
> +					tlb_remove_tlb_entry(tlb, pte, addr);
>  					SetPageLazyFree(page);
>  					if (PageActive(page))
>  						deactivate_tail_page(page);


-- 
SUSE Labs, Novell Inc.

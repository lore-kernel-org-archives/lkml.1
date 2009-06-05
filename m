Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbZFELDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbZFELDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZFELDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:03:17 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:31379 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZFELDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZqoldRTtwlippDnNnqPXn/AyTXKbUz9w7deuberewVigAPTzBdyW17LYaL0OTZ9irs
         ldUKjj2KEtYoXBk5vgTOm25l/RQX/DQ5G4ulSz/dEzrry2rIWfeOEGZGzeLE/661FjLr
         OnWSQJaUvzsHeMV6f9qMZhDnmpuTFY5AhLphg=
MIME-Version: 1.0
In-Reply-To: <20090603132751.GA1813@cmpxchg.org>
References: <20090602223738.GA15475@cmpxchg.org>
	 <20090602233457.GY1065@one.firstfloor.org>
	 <20090603132751.GA1813@cmpxchg.org>
Date: Fri, 5 Jun 2009 20:03:17 +0900
Message-ID: <28c262360906050403o3b24aa92tf47cab8a3cbc2ab9@mail.gmail.com>
Subject: Re: [patch][v2] swap: virtual swap readahead
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Hannes.

On Wed, Jun 3, 2009 at 10:27 PM, Johannes Weiner<hannes@cmpxchg.org> wrote:
> On Wed, Jun 03, 2009 at 01:34:57AM +0200, Andi Kleen wrote:
>> On Wed, Jun 03, 2009 at 12:37:39AM +0200, Johannes Weiner wrote:
>> > + *
>> > + * Caller must hold down_read on the vma->vm_mm if vma is not NULL.
>> > + */
>> > +struct page *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
>> > +                   struct vm_area_struct *vma, unsigned long addr)
>> > +{
>> > +   unsigned long start, pos, end;
>> > +   unsigned long pmin, pmax;
>> > +   int cluster, window;
>> > +
>> > +   if (!vma || !vma->vm_mm)        /* XXX: shmem case */
>> > +           return swapin_readahead_phys(entry, gfp_mask, vma, addr);
>> > +
>> > +   cluster = 1 << page_cluster;
>> > +   window = cluster << PAGE_SHIFT;
>> > +
>> > +   /* Physical range to read from */
>> > +   pmin = swp_offset(entry) & ~(cluster - 1);
>>
>> Is cluster really properly sign extended on 64bit? Looks a little
>> dubious. long from the start would be safer
>
> Fixed.
>
>> > +   /* Virtual range to read from */
>> > +   start = addr & ~(window - 1);
>>
>> Same.
>
> Fixed.
>
>> > +           pgd = pgd_offset(vma->vm_mm, pos);
>> > +           if (!pgd_present(*pgd))
>> > +                   continue;
>> > +           pud = pud_offset(pgd, pos);
>> > +           if (!pud_present(*pud))
>> > +                   continue;
>> > +           pmd = pmd_offset(pud, pos);
>> > +           if (!pmd_present(*pmd))
>> > +                   continue;
>> > +           pte = pte_offset_map_lock(vma->vm_mm, pmd, pos, &ptl);
>>
>> You could be more efficient here by using the standard mm/* nested loop
>> pattern that avoids relookup of everything in each iteration. I suppose
>> it would mainly make a difference with 32bit highpte where mapping a pte
>> can be somewhat costly. And you would take less locks this way.
>
> I ran into weird problems here.  The above version is actually faster
> in the benchmarks than writing a nested level walker or using
> walk_page_range().  Still digging but it can take some time.  Busy
> week :(
>
>> > +           page = read_swap_cache_async(swp, gfp_mask, vma, pos);
>> > +           if (!page)
>> > +                   continue;
>>
>> That's out of memory, break would be better here because prefetch
>> while oom is usually harmful.
>
> It can also happen due to a race with something releasing the swap
> slot (i.e. swap_duplicate() fails).  But the old version did a break
> too and this patch shouldn't do it differently.  Fixed.

I think it would be better to read fault page earlier than readahead pages.
That's because,
1) Readahead pages would prevent to read fault page due to out-of-memory.
2)  If we can't get the fault page, we don't need extra pages(ie,
readahead pages)
     It's waste of memory or IO bandwidth. It's what you want.
3) If we read fault page at first and meet oom, we can also stop readahead.

-- 
Kinds regards,
Minchan Kim

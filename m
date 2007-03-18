Return-Path: <linux-kernel-owner+w=401wt.eu-S933157AbXCRWVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbXCRWVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 18:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933358AbXCRWVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 18:21:07 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:38259 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157AbXCRWVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 18:21:05 -0400
Date: Sun, 18 Mar 2007 22:21:01 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andy Whitcroft <apw@shadowen.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Bias the location of pages freed for min_free_kbytes in
 the same MAX_ORDER_NR_PAGES blocks
In-Reply-To: <20070318124547.c46b0e69.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703182134450.17822@skynet.skynet.ie>
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
 <200703142006.04547.m.kozlowski@tuxland.pl> <20070314170738.d5d35c06.akpm@linux-foundation.org>
 <20070317182641.GA19447@skynet.ie> <20070318002244.606cfe08.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703181104140.29429@skynet.skynet.ie>
 <20070318101259.f6e524f2.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703181822110.648@skynet.skynet.ie>
 <20070318112820.90be0449.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703181941160.648@skynet.skynet.ie>
 <20070318124547.c46b0e69.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007, Andrew Morton wrote:

> On Sun, 18 Mar 2007 20:08:49 +0000 (GMT) Mel Gorman <mel@csn.ul.ie> wrote:
>
>> On Sun, 18 Mar 2007, Andrew Morton wrote:
>>
>>> On Sun, 18 Mar 2007 19:05:41 +0000 (GMT) Mel Gorman <mel@csn.ul.ie> wrote:
>>>
>>>>> How much additional memory consumption are we expecting here?
>>>>>
>>>>
>>>> Short answer, about 1.5KB on a 1GB system of which 1.3KB is statically
>>>> defined in the 3 struct zones on a 1 node x86 system.
>>>>
>>>> Longer answer that I hopefully have not made any mistakes in - There is
>>>> the zone overhead which is statically sized and a runtime overhead which
>>>> depends on the amount of memory in the system. The additional zone
>>>> overhead is the overhead for additional freelists (larger struct
>>>> free_area) and is as follows;
>>>>
>>>> (MIGRATE_TYPES-1) * sizeof(list_head) * (MAX_ORDER-1)
>>>>
>>>> so, on 32 bit in general, thats
>>>>
>>>> 4 * 8 * 10 = 320 bytes per zone (would be 240 bytes if MIGRATE_RESERVE is
>>>>  				sufficient for higher order allocations
>>>>  				instead of MIGRATE_HIGHALLOC)
>>>>
>>>> on x86 with DMA, Normal and HighMem, thats 1280 bytes. On a NUMA system,
>>>> it's 1280 bytes per node. On 64 bit, it would be double because of the
>>>> larger pointer size. At worst, I guess you are looking at 3KB per node.
>>>
>>> That a very modest overhead - not worth the config option, IMO.
>>>
>>> The runtime overhead might be a concern - is it possible to quantify
>>> it?
>>>
>>
>> Do you mean performance wise or memory wise?
>
> CPU load.  From your earlier email I'd decided memory consumption was a
> non-issue ;)
>

I figured that was the case but thought I would try pin it down more and 
offer storing the overhead in a counter just in case there is a situation 
where it's a problem.

>> Memory-wise,  something like
>>
>> ===
>> FLATMEM Case
>> bits = 0;
>> for_each_zone(zone) {
>>  	bits += (zone->spanned_pages >> (MAX_ORDER-1)) * NR_PAGEBLOCK_BITS);
>> }
>> bytes_consumed = bits / 8;
>>
>> === SPARSEMEM Case, a rough approximation is
>> ((vm_total_pages * PAGE_SIZE) >> SECTION_SIZE_BITS) * 8
>>
>> The consumption could be stored in a zone variable similar to
>> zone->present_pages and visible through /proc/zoneinfo. Would that be
>> useful?
>>
>> Performance wise is harder to quantify. There are three places where
>> issues can show up. The first is with allocation fallbacks where
>> __rmqueue_fallback() is called. Fallbacks are expensive but fallbacks are
>> rare except when the zone is too small which is why I probably should be
>> catching that case explicitly. I used to have a counters patch for
>> fallbacks. I could bring it up to date to use __count_vm_events() to
>> quantify fallbacks if you think it would be useful?
>>
>> The second hotpoint is where the per-cpu lists are searched for a page of
>> the suitable migrate type. An instruction-level profile on x86 when I
>> looked at this on x86 showed about 2-4% of the time spent in
>> get_page_from_freelist() was searching the per-cpu lists for a page of a
>> suitable type. IIRC, something like 85% of the time there was clearing the
>> pages although I'd need to double check this to be 100% sure.
>>
>> The last potential performance hotpoint is where the pageblock flags are
>> read on every free in get_pageblock_flags_group(). There is probably room
>> for optimisation there. I haven't an exact quantification available at the
>> moment but I remember seeing it far down the list of functions time was
>> spent when I was last looking at this.
>
> hm, well.  It'd be good to drill down, quantify and, where needed, fix
> these things.  Because the existence of that config option is quite
> undesirabe.

After my last mail, I turned on my main desktop (Intel(R) Pentium(R) D on 
32 bit) and set it going with 2.6.21-rc3-mm2 with the fix for Mariusz 
applied. I built a kernel while music was playing and I went off watching 
someone else make my dinner - a scientific test to be sure.

4.2% of the time in get_page_from_freelist() is spent in this 
list_for_each_entry;

                 /* Find a page of the appropriate migrate type */
                 list_for_each_entry(page, &pcp->list, lru) {

Something like 3% is spent on one instruction

  84768  0.0334 :c014c535:       lea    0x0(%esi),%esi

Maybe I can avoid some of this by optimistically checking if the first 
entry is suitable before entering into a loop, prefetching data and the 
like.

To put the loop into perspective though, 82% of the time was spent on one 
instruction within __constant_c_and_count_memset() called from 
prep_new_page() here;

2059075  0.8117 :c014c6d8:      rep stos %eax,%es:(%edi)

On architectures with a cheaper prep_new_page(), the list search may be 
more noticable. I'll see can I check what this looks like on ppc64 during 
the week because I believe ppc64 is able to zero pages faster.

__rmqueue_fallback didn't even appear in readprofile or oprofile even 
though it has to have been executed during boot time. I guess it just 
wasn't sampled enough. The overhead should be visible on ia64 with low 
memory machines because MAX_ORDER_NR_PAGES is so ridiculously large there. 
I have access to an IA64 machine with 1GB so I'll experiement with forcing 
allocflags_to_migratetype() to return MIGRATE_UNMOVABLE when 
vm_total_pages < (MAX_ORDER_NR_PAGES * MIGRATE_TYPES).

get_pageblock_flags_group() was the 40th most executed function according 
to oprofile. 70% of the time in that function was spent here;

 	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
                 if (test_bit(bitidx + start_bitidx, bitmap))
                         flags |= value;

This is reading the 3 bits storing values for the MAX_ORDER_NR_PAGES on 
each free. That code was structured to be as generic as possible so that 
additional bits could be added with the minimum of fuss. Maybe based on 
the profile, I should look at making it specific instead. If someone wants 
to add another bit, they can use the get_pageblock_bitmap() and 
pfn_to_bitidx() helpers to make their own specific accessors of their new 
bit.

The small zone one is the one I'm worried about. Once I verify it's a 
problem and fix it if necessary, I'll be happy to get rid of that 
configuration item altogether.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

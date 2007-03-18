Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXCRTFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXCRTFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbXCRTFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:05:45 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:36333 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991AbXCRTFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:05:44 -0400
Date: Sun, 18 Mar 2007 19:05:41 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andy Whitcroft <apw@shadowen.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Bias the location of pages freed for min_free_kbytes in
 the same MAX_ORDER_NR_PAGES blocks
In-Reply-To: <20070318101259.f6e524f2.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703181822110.648@skynet.skynet.ie>
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
 <200703142006.04547.m.kozlowski@tuxland.pl> <20070314170738.d5d35c06.akpm@linux-foundation.org>
 <20070317182641.GA19447@skynet.ie> <20070318002244.606cfe08.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703181104140.29429@skynet.skynet.ie>
 <20070318101259.f6e524f2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007, Andrew Morton wrote:

> On Sun, 18 Mar 2007 11:35:36 +0000 (GMT) Mel Gorman <mel@csn.ul.ie> wrote:
>
>>> But let me leap ahead of myself.
>>>
>>>> CONFIG_PAGE_GROUP_BY_MOBILITY
>>>
>>> Why does this config item exist?  It's not good to have some mysterious
>>> knob which affects mm behaviour at compile time.  We need to make up our
>>> minds and stick with it.
>>>
>>
>> The configuration item exists because there were concerns over the memory
>> footprint and cache line footprint. It was introduced to address that
>> concern and also so that it would be possible to compare the performance
>> behavior of anti-fragmentation. Your comment rang a bell though so I
>> searched the archives to see this comment from Andi Kleen;
>>
>> ===
>> If anything this should be a boot time option or perhaps sysctl, not a
>> config. In general CONFIGs that change runtime behaviour are evil - just
>> makes changing the option more painful, causes problems for distribution
>> users, doesn't make much sense, etc.etc.
>>
>> Also #ifdef as a documentation device is a really really scary concept.
>> Yuck.
>> ===
>>
>> A sysctl would avoid any cache line footprint but not the memory overhead
>> because the freelists in struct zone as those freelists would still exist.
>> I could make the option depend on CONFIG_EMBEDDED for the zone overhead.
>> Would that make sense or would it be preferable to ditch the option
>> altogether?
>>
>> I'll start looking at doing a sysctl so it can be disabled at runtime if
>> necessary. I strongly suspect that it cannot be enabled again once
>> disabled but I don't see that as a problem as such.
>
> How much additional memory consumption are we expecting here?
>

Short answer, about 1.5KB on a 1GB system of which 1.3KB is statically 
defined in the 3 struct zones on a 1 node x86 system.

Longer answer that I hopefully have not made any mistakes in - There is 
the zone overhead which is statically sized and a runtime overhead which 
depends on the amount of memory in the system. The additional zone 
overhead is the overhead for additional freelists (larger struct 
free_area) and is as follows;

(MIGRATE_TYPES-1) * sizeof(list_head) * (MAX_ORDER-1)

so, on 32 bit in general, thats

4 * 8 * 10 = 320 bytes per zone (would be 240 bytes if MIGRATE_RESERVE is
 				sufficient for higher order allocations
 				instead of MIGRATE_HIGHALLOC)

on x86 with DMA, Normal and HighMem, thats 1280 bytes. On a NUMA system, 
it's 1280 bytes per node. On 64 bit, it would be double because of the 
larger pointer size. At worst, I guess you are looking at 3KB per node.

The size of the bitmap for the flags depends on the amount of memory. On 
FLATMEM and DISCONTIG, it's 3 bits per MAX_ORDER_NR_PAGES spanned by the 
zones (note spanned, not present). On a 1GiB system without holes on an 
x86 with MAX_ORDER of 11, that would be 96 bytes. The calculation is more 
complex for sparsemem but will be at least 4 bytes per active section for 
a pointer and another 4 bytes for most bitmaps. I have a patch that uses 
the pointer itself when the bitmap is small enough to be contained in 4 
bytes (which is usually is) so it could be just 4 bytes per active section 
(4 bytes per 16MB on powerpc for example).

> Whether it's runtime or compile-time, the optionality is not good.
>

The main situation where I think it would be desirable to disable 
anti-fragmentation is for zones that are smaller than 
MIGRATE_TYPES*MAX_ORDER_NR_PAGES and this is for performance reasons to 
avoid regularly entering __rmqueue_fallback(). However, that situation 
could be automatically detected and handled by having 
allocflags_to_migratetype() always return MIGRATE_UNMOVABLE for small 
zones and similar for get_pageblock_migratetype(). There would be no need 
for a sysctl.

If a sysctl was available for cases where profiles showed a problem with 
the bitmap for example, it would work by having 
allocflags_to_migratetype() and get_pageblock_migratetype() always return 
MIGRATE_UNMOVABLE so it would not be totally different code paths that are 
being executed in the enabled/disabled cases.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

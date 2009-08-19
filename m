Return-Path: <linux-kernel-owner+w=401wt.eu-S1751644AbZHSKSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbZHSKSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 06:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZHSKSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 06:18:20 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:33899 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbZHSKST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 06:18:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tmpvO3zp/wy2Z5kc+LixzbcmXlxeoJwXJI/usTj6S7yH+uUKuG82omLV0qdK+Cm/fm
         7t0t6OAp/hlHI+xC6N0KimZKY/0xS72nAItV8IT2ZXaFavfTXdE04zbORSnMVHJmp0C3
         uoTV/9imlDBxfNN/aOJ5Qj7DpHtFmwZYqoxyY=
MIME-Version: 1.0
In-Reply-To: <20090819114408.ab9c8a78.minchan.kim@barrios-desktop>
References: <18eba5a10908181841t145e4db1wc2daf90f7337aa6e@mail.gmail.com>
	 <20090819114408.ab9c8a78.minchan.kim@barrios-desktop>
Date: Wed, 19 Aug 2009 19:18:19 +0900
Message-ID: <28c262360908190318i3a9f3915g2366679ae89809aa@mail.gmail.com>
Subject: Re: abnormal OOM killer message
From: Minchan Kim <minchan.kim@gmail.com>
To: =?UTF-8?B?7Jqw7Lap6riw?= <chungki.woo@gmail.com>,
       Nitin Gupta <ngupta@vflare.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, fengguang.wu@intel.com,
       riel@redhat.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com,
       Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 11:44 AM, Minchan Kim<minchan.kim@gmail.com> wrote:
> On Wed, 19 Aug 2009 10:41:51 +0900
> 우충기 <chungki.woo@gmail.com> wrote:
>
>> Hi all~
>> I have got a log message with OOM below. I don't know why this
>> phenomenon was happened.
>> When direct reclaim routine(try_to_free_pages) in __alloc_pages which
>> allocates kernel memory was failed,
>> one last chance is given to allocate memory before OOM routine is executed.
>> And that time, allocator uses ALLOC_WMARK_HIGH to limit watermark.
>> Then, zone_watermark_ok function test this value with current memory
>> state and decide 'can allocate' or 'cannot allocate'.
>>
>> Here is some kernel source code in __alloc_pages function to understand easily.
>> Kernel version is 2.6.18 for arm11. Memory size is 32Mbyte. And I use
>> compcache(0.5.2).
>> -------------------------------------------------------------------------------------------------------------------------------------------------------------
>>         ...
>>         did_some_progress = try_to_free_pages(zonelist->zones,
>> gfp_mask);            <== direct page reclaim
>>
>>         p->reclaim_state = NULL;
>>         p->flags &= ~PF_MEMALLOC;
>>
>>         cond_resched();
>>
>>         if (likely(did_some_progress)) {
>>                 page = get_page_from_freelist(gfp_mask, order,
>>                                                 zonelist, alloc_flags);
>>                 if (page)
>>                         goto got_pg;
>>         } else if ((gfp_mask & __GFP_FS) && !(gfp_mask &
>> __GFP_NORETRY)) {    <== when fail to reclaim
>>                 /*
>>                  * Go through the zonelist yet one more time, keep
>>                  * very high watermark here, this is only to catch
>>                  * a parallel oom killing, we must fail if we're still
>>                  * under heavy pressure.
>>                  */
>>                 page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL,
>> order,  <== this is last chance
>>                                 zonelist,
>> ALLOC_WMARK_HIGH|ALLOC_CPUSET);               <== uses
>> ALLOC_WMARK_HIGH
>>                 if (page)
>>                         goto got_pg;
>>
>>                 out_of_memory(zonelist, gfp_mask, order);
>>                 goto restart;
>>         }
>>         ...
>> -------------------------------------------------------------------------------------------------------------------------------------------------------------
>>
>> In my case, you can see free pages(6804KB) is much more higher than
>> high watermark value(1084KB) in OOM message.
>> And order of allocating is also zero.(order=0)
>> In buddy system, the number of 4kbyte page is 867.
>> So, I think OOM can't be happend.
>>
>
> Yes. I think so.
>
> In that case, even we can also avoid zone defensive algorithm.
>
>> How do you think about this?
>> Is this side effect of compcache?
>
> I don't know compcache well.
> But I doubt it. Let's Cced Nitin.
>
>> Please explain me.
>> Thanks.
>>
>> This is OOM message.
>> -------------------------------------------------------------------------------------------------------------------------------------------------------------
>> oom-killer: gfp_mask=0x201d2, order=0       (==> __GFP_HIGHMEM,
>> __GFP_WAIT, __GFP_IO, __GFP_FS, __GFP_COLD)
>> [<c00246c0>] (dump_stack+0x0/0x14) from [<c006ba68>] (out_of_memory+0x38/0x1d0)
>> [<c006ba30>] (out_of_memory+0x0/0x1d0) from [<c006d4cc>]
>> (__alloc_pages+0x244/0x2c4)
>> [<c006d288>] (__alloc_pages+0x0/0x2c4) from [<c006f054>]
>> (__do_page_cache_readahead+0x12c/0x2d4)
>> [<c006ef28>] (__do_page_cache_readahead+0x0/0x2d4) from [<c006f594>]
>> (do_page_cache_readahead+0x60/0x64)
>> [<c006f534>] (do_page_cache_readahead+0x0/0x64) from [<c006ac24>]
>> (filemap_nopage+0x1b4/0x438)
>>  r7 = C0D8C320  r6 = C1422000  r5 = 00000001  r4 = 00000000
>> [<c006aa70>] (filemap_nopage+0x0/0x438) from [<c0075684>]
>> (__handle_mm_fault+0x398/0xb84)
>> [<c00752ec>] (__handle_mm_fault+0x0/0xb84) from [<c0027614>]
>> (do_page_fault+0xe8/0x224)
>> [<c002752c>] (do_page_fault+0x0/0x224) from [<c0027900>]
>> (do_DataAbort+0x3c/0xa0)
>> [<c00278c4>] (do_DataAbort+0x0/0xa0) from [<c001fde0>]
>> (ret_from_exception+0x0/0x10)
>>  r8 = BE9894B8  r7 = 00000078  r6 = 00000130  r5 = 00000000
>>  r4 = FFFFFFFF
>> Mem-info:
>> DMA per-cpu:
>> cpu 0 hot: high 6, batch 1 used:0
>> cpu 0 cold: high 2, batch 1 used:1
>> DMA32 per-cpu: empty
>> Normal per-cpu: empty
>> HighMem per-cpu: empty
>> Free pages:        6804kB (0kB HighMem)
>> Active:101 inactive:1527 dirty:0 writeback:0 unstable:0 free:1701
>> slab:936 mapped:972 pagetables:379
>> DMA free:6804kB min:724kB low:904kB high:1084kB active:404kB
>> inactive:6108kB present:32768kB pages_scanned:0 all_unreclaimable? no
>> lowmem_reserve[]: 0 0 0 0
>> DMA32 free:0kB min:0kB low:0kB high:0kB active:0kB inactive:0kB
>> present:0kB pages_scanned:0 all_unreclaimable? no
>> lowmem_reserve[]: 0 0 0 0
>> Normal free:0kB min:0kB low:0kB high:0kB active:0kB inactive:0kB
>> present:0kB pages_scanned:0 all_unreclaimable? no
>> lowmem_reserve[]: 0 0 0 0
>> HighMem free:0kB min:128kB low:128kB high:128kB active:0kB
>> inactive:0kB present:0kB pages_scanned:0 all_unreclaimable? no
>> lowmem_reserve[]: 0 0 0 0
>> DMA: 867*4kB 273*8kB 36*16kB 2*32kB 0*64kB 0*128kB 0*256kB 1*512kB
>> 0*1024kB 0*2048kB 0*4096kB = 6804kB
>> DMA32: empty
>> Normal: empty
>> HighMem: empty
>> Swap cache: add 4597, delete 4488, find 159/299, race 0+0
>> Free swap  = 67480kB
>> Total swap = 81916kB
>
> In addition, total swap : 79M??
>
>> Free swap:        67480kB
>> 8192 pages of RAM
>> 1960 free pages
>> 978 reserved pages
>> 936 slab pages
>> 1201 pages shared
>> 109 pages swap cached
>
> free page : 6M
> page table + slab + reserved : 8M
> active + inacive : 6M
>
> Where is 12M?
>
>> Out of Memory: Kill process 47 (rc.local) score 849737 and children.
>> Out of memory: Killed process 49 (CTaskManager).
>> Killed
>> SW image is stopped..
>> script in BOOT is stopped...
>> Starting pid 348, console /dev/ttyS1: '/bin/sh'
>> -sh: id: not found
>> #
>> -------------------------------------------------------------------------------------------------------------------------------------------------------------
>
> As you mentioned, your memory size is 32M and you use compcache.
> How is swap size bigger than your memory size ?
> Is the result of compression of swap pages ?
> Nitin. Could you answer the question?
>
> I can't imagine whey order 0 allocation failed although there are
> many pages in buddy.
>
> What do you mm guys think about this problem ?

I can only think that zonelists set up wrongly or freelist got damaged.
Could you print your zonelist about __GFP_HIGHMEM ?

> --
> Kind regards,
> Minchan Kim
>



-- 
Kind regards,
Minchan Kim

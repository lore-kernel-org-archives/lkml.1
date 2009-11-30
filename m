Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZK3MyC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZK3MyC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:54:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZK3MyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:54:00 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:39662 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZK3Mx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:53:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ovYaNIENQQP7GQWAL5CvQowEVpFC+DHcE+It9ocjuhXJmWH99oG4k4XtDfCRR8Eu9h
         EF8n0YXZzsZ3t5dq39BunX9ymvzpFYoh7+zFLIsCjdRRUW95SRPmknZdZd2CjF7vMFiN
         E8mov1ezik5FLEy7NHo0BUWWEDVTL65biYhGE=
MIME-Version: 1.0
In-Reply-To: <20091130120428.GA23491@csn.ul.ie>
References: <20091126121945.GB13095@csn.ul.ie>
	 <4e5e476b0911271014k1d507a02o60c11723948dcfa@mail.gmail.com>
	 <20091127185234.GQ13095@csn.ul.ie>
	 <200911291611.16434.czoccolo@gmail.com>
	 <20091130120428.GA23491@csn.ul.ie>
Date: Mon, 30 Nov 2009 13:54:04 +0100
Message-ID: <4e5e476b0911300454x74c46852od4c35132f0d4c104@mail.gmail.com>
Subject: Re: [PATCH-RFC] cfq: Disable low_latency by default for 2.6.32
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 1:04 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Sun, Nov 29, 2009 at 04:11:15PM +0100, Corrado Zoccolo wrote:
>> On Fri, Nov 27, 2009 19:52:34, Mel Gorman wrote:
>> : > On Fri, Nov 27, 2009 at 07:14:41PM +0100, Corrado Zoccolo wrote:
>> > > On Fri, Nov 27, 2009 at 4:58 PM, Mel Gorman <mel@csn.ul.ie> wrote:
>> > > > On Fri, Nov 27, 2009 at 01:03:29PM +0100, Corrado Zoccolo wrote:
>> > > >> On Fri, Nov 27, 2009 at 12:44 PM, Mel Gorman <mel@csn.ul.ie> wrote:
>> > > >
>> > > > How would one go about selecting the proper ratio at which to disable
>> > > > the low_latency logic?
>> > >
>> > > Can we measure the dirty ratio when the allocation failures start to
>> > > happen?
>> >
>> > Would the number of dirty pages in the page allocation failure message to
>> > kern.log be enough? You won't get them all because of printk suppress but
>> > it's something. Alternatively, tell me exactly what stats from /proc you
>> > want and I'll stick a monitor on there. Assuming you want nr_dirty vs total
>> > number of pages though, the monitor tends to execute too late to be useful.
>> >
>> Since I wanted to go deeper in the understanding, but my system is healty,
>> I devised a measure of fragmentation, and wanted to chart it to understand
>> what was going wrong. A perl script that produces gnuplot compatible output is provided:
>>
>> use strict;
>> select(STDOUT);
>> $|=1;
>> do {
>> open (my $bf, "< /proc/buddyinfo") or die;
>> open (my $up, "< /proc/uptime") or die;
>> my $now = <$up>;
>> chomp $now;
>> print $now;
>> while(<$bf>) {
>>     next unless /Node (\d+), zone\s+([a-zA-Z]+)\s+(.+)$/;
>>     my ($frag, $tot, $val) = (0,0,1);
>>     map { $frag += $_; $tot += $val * $_; $val <<= 1;} ($3 =~ /\d+/g);
>>     print "\t", $frag/$tot;
>> }
>> print "\n";
>> sleep 1;
>> } while(1);
>>
>> My definition of fragmentation is just the number of fragments / the number of pages:
>> * It is 1 only when all pages are of order 0
>> * it is 2/3 on a random marking of used pages (each page has probability 0.5 of being used)
>> * to be sure that a order k allocation succeeds, the fragmentation should be <= 2^-k
>>
>
> In practice, the ordering of page allocations and frees are not random
> but it's ok for the purposes here.
>
> Also when considering fragmentation, I'd take into account the order of the
> desired allocation as fragmentations at or over that size are not contributing
> to fragmentation in a negative way. I'd usually express it in terms of free
> pages instead of total pages as well to avoid large fluctuations when reclaim
> is working. We can work with this measure for the moment though to avoid
> getting side-tracked on what fragmentation is.
>
>> I observed the mainline kernel during normal usage, and found that:
>> * the fragmentation is very low after boot (< 1%).
>> * it tends to increase when memory is freed, and to decrease when memory is allocated (since the kernel usually performs order 0 allocations).
>> * high memory fragmentation increases first, and only when all high memory is used, normal memory starts to fragment.
>
> All three of these observations are expected.
>
>> * when the page cache is big enough (so memory pressure is high for the allocator), the fragmentation starts to fluctuate a lot, sometimes exceeding 2/3 (up to 0.8).
>
> Again, this is expected. Page cache pages stay resident until
> reclaimed. If they are clean, they are not really contributing to
> fragmentation in any way that matters as they should be quickly found
> and discarded in most cases. In the networking case, it's depending on
> kswapd to find and reclaim the pages fast enough.

If you need an order 5 page, how would kswapd work?
Will it free randomly some order 0 pages until a merge magically happens?
Unless the dirty ratio is really high, there should already be plenty
of contiguous non-dirty pages in the page cache that could be freed,
but if you use an LRU policy to evict, you can go through a lot of
freeing before a merge will happen.

>> * the only way to make the fragmentation return to sane values after it enters fluctuation is to do a sync & drop caches. Even in this case, it will go around 14%, that is still quite high.
>> >
>> > Two major differences. 1, the previous non-high-order tests had also
>> > run sysbench and iozone so the starting conditions are different. I had
>> > disabled those tests to get some of the high-order figures before I went
>> > offline. However, the starting conditions are probably not as important as
>> > the fact that kswapd is working to free order-2 pages and staying awake
>> > until watermarks are reached. kswapd working harder is probably making a
>> > big difference.
>> >
>>
>> From my observation, having run a program that fills page cache before a test has a lot of impact to the fragmentation.
>
> While this is true, during the course of the test, the old page cache
> should be discarded quickly. It's not as abrupt as dropping the page
> cache but the end result should be similar in the majority of cases -
> the exception being when atomic allocations are a major factor.

For my I/O scheduler tests I use an external disk, to be able to
monitor exactly what is happening.
If I don't do a sync & drop cache before starting a test, I usually
see writeback happening on the main disk, even if the only activity on
the machine is writing a sequential file to my external disk. If that
writeback is done in the context of my test process, this will alter
the result.
And with high order allocations, depending on how do you free page
cache, it can be even worse than that.

>
>> On the other hand, I saw that the problems with high order allocations started
>> around 2.6.31, where we didn't have any low_latency patch.
>
> While this is true, there appear to be many sources of the high order
> allocation failures. While low_latency is not the original source, it
> does not appear to have helped either. Even without high-order
> allocations being involved, disabling low_latency performs much better
> in low-memory situations.
Can you try reproducing:
http://lkml.indiana.edu/hypermail/linux/kernel/0911.1/01848.html
in a low memory scenario, to substantiate your claim?

>> After a 1day study of the VM, I found an other way to improve the fragmentation.
>> With the patch below, the fragmentation stays below 2/3 even when memory pressure is high,
>> and decreases overtime, if the system is lightly used, even without dropping caches.
>> Moreover, the precious zones (Normal, DMA) are kept at a lower fragmentation, since high order
>> allocations are usually serviced by the other zones (more likely than with mainline allocator).
>>
>> The idea is to have 2 freelists for each zone.
>> The free_list_0 has the pages that are less likely to cause an higher-order merge, since the buddy of their compound is not free.
>> The free_list_1 contains the other ones.
>> When expanding, we put pages into free_list_1.When freeing, we put them in the proper one by checking the buddy of the compound.
>> And when extracting, we always extract from free_list_0 first,
>
> This is subtle, but as well as increased overhead in the page allocator, I'd
> expect this to break the page-ordering when a caller is allocation many numbers
> of order-0 pages. Some IO controllers get a boost by the pages coming back
> in physically contiguous order which happens if a high-order page is being
> split towards the beginning of the stream of requests. Previous attempts at
> altering how coalescing and splitting to reduce fragmentation with methods
> similar to yours have fallen foul of this.
I took extreme care in not disrupting the page ordering. In fact, I
thought, too, to a single list solution, but it could cause page
reordering (since I would have used add_tail to add to the other
list).

>
>> and fall back on the other if the first is empty.
>> In this way, we keep free longer the pages that are more likely to cause a big merge.
>> Consequently we tend to aggregate the long-living allocations on a subset of the compounds, reducing the fragmentation.
>>
>> It can, though, slow down allocation and reclaim, so someone more knowledgeable than me should have a look.
>>
>> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 6f75617..6427361 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -55,7 +55,8 @@ static inline int get_pageblock_migratetype(struct page *page)
>>  }
>>
>>  struct free_area {
>> -     struct list_head        free_list[MIGRATE_TYPES];
>> +     struct list_head        free_list_0[MIGRATE_TYPES];
>> +     struct list_head        free_list_1[MIGRATE_TYPES];
>>       unsigned long           nr_free;
>>  };
>>
>> diff --git a/kernel/kexec.c b/kernel/kexec.c
>> index f336e21..aee5ef5 100644
>> --- a/kernel/kexec.c
>> +++ b/kernel/kexec.c
>> @@ -1404,13 +1404,15 @@ static int __init crash_save_vmcoreinfo_init(void)
>>       VMCOREINFO_OFFSET(zone, free_area);
>>       VMCOREINFO_OFFSET(zone, vm_stat);
>>       VMCOREINFO_OFFSET(zone, spanned_pages);
>> -     VMCOREINFO_OFFSET(free_area, free_list);
>> +     VMCOREINFO_OFFSET(free_area, free_list_0);
>> +     VMCOREINFO_OFFSET(free_area, free_list_1);
>>       VMCOREINFO_OFFSET(list_head, next);
>>       VMCOREINFO_OFFSET(list_head, prev);
>>       VMCOREINFO_OFFSET(vm_struct, addr);
>>       VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
>>       log_buf_kexec_setup();
>> -     VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
>> +     VMCOREINFO_LENGTH(free_area.free_list_0, MIGRATE_TYPES);
>> +     VMCOREINFO_LENGTH(free_area.free_list_1, MIGRATE_TYPES);
>>       VMCOREINFO_NUMBER(NR_FREE_PAGES);
>>       VMCOREINFO_NUMBER(PG_lru);
>>       VMCOREINFO_NUMBER(PG_private);
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index cdcedf6..5f488d8 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -451,6 +451,8 @@ static inline void __free_one_page(struct page *page,
>>               int migratetype)
>>  {
>>       unsigned long page_idx;
>> +     unsigned long combined_idx;
>> +     bool high_order_free = false;
>>
>>       if (unlikely(PageCompound(page)))
>>               if (unlikely(destroy_compound_page(page, order)))
>> @@ -464,7 +466,6 @@ static inline void __free_one_page(struct page *page,
>>       VM_BUG_ON(bad_range(zone, page));
>>
>>       while (order < MAX_ORDER-1) {
>> -             unsigned long combined_idx;
>>               struct page *buddy;
>>
>>               buddy = __page_find_buddy(page, page_idx, order);
>> @@ -481,8 +482,21 @@ static inline void __free_one_page(struct page *page,
>>               order++;
>>       }
>>       set_page_order(page, order);
>> -     list_add(&page->lru,
>> -             &zone->free_area[order].free_list[migratetype]);
>> +
>> +     if (order < MAX_ORDER-1) {
>> +             struct page *parent_page, *ppage_buddy;
>> +             combined_idx = __find_combined_index(page_idx, order);
>> +             parent_page = page + combined_idx - page_idx;
>
> parent_page is a bad name here. It's not the parent of anything. What I
> think you're looking for is the lowest page of the pair of buddies that
> was last considered for merging.
Right, this should be the combined page, to keep naming consistent
with combined_idx.

>
>> +             ppage_buddy = __page_find_buddy(parent_page, combined_idx, order + 1);
>> +             high_order_free = page_is_buddy(parent_page, ppage_buddy, order + 1);
>> +     }
>
> And you are checking if when one buddy of this pair frees, will it then
> be merged with the next-highest order. If so, you want to delay reusing
> that page for allocation.
Exactly.
If you have two streams of allocations, with different average
lifetime (and with the long lifetime allocations having a slower
rate), this will make very probable that the long lifetime allocations
span a smaller set of compounds.
>
>> +
>> +     if (high_order_free)
>> +             list_add(&page->lru,
>> +                     &zone->free_area[order].free_list_1[migratetype]);
>> +     else
>> +             list_add(&page->lru,
>> +                     &zone->free_area[order].free_list_0[migratetype]);
>
> You could have avoided the extra list to some extent by altering whether
> it was the head or tail of the list the page was added to. It would have
> had a similar effect of the page not being used for longer with slightly
> less overhead.
Right, but the order of insertions at the tail would be reversed.

>>       zone->free_area[order].nr_free++;
>>  }
>>
>> @@ -663,7 +677,7 @@ static inline void expand(struct zone *zone, struct page *page,
>>               high--;
>>               size >>= 1;
>>               VM_BUG_ON(bad_range(zone, &page[size]));
>> -             list_add(&page[size].lru, &area->free_list[migratetype]);
>> +             list_add(&page[size].lru, &area->free_list_1[migratetype]);
>
> I think this here will damage the contiguous ordering of pages being
> returned to callers.
This shouldn't damage the order. In fact, expand always inserts in the
free_list_1, in the same order as the original code inserted in the
free_list. And if we hit expand, then the free_list_0 is empty, so all
allocations will be serviced from free_list_1 in the same order as the
original code.

>
>>               area->nr_free++;
>>               set_page_order(&page[size], high);
>>       }
>> @@ -723,12 +737,19 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
>>
>>       /* Find a page of the appropriate size in the preferred list */
>>       for (current_order = order; current_order < MAX_ORDER; ++current_order) {
>> +             bool fl0, fl1;
>>               area = &(zone->free_area[current_order]);
>> -             if (list_empty(&area->free_list[migratetype]))
>> +             fl0 = list_empty(&area->free_list_0[migratetype]);
>> +             fl1 = list_empty(&area->free_list_1[migratetype]);
>> +             if (fl0 && fl1)
>>                       continue;
>>
>> -             page = list_entry(area->free_list[migratetype].next,
>> -                                                     struct page, lru);
>> +             if (fl0)
>> +                     page = list_entry(area->free_list_1[migratetype].next,
>> +                                       struct page, lru);
>> +             else
>> +                     page = list_entry(area->free_list_0[migratetype].next,
>> +                                       struct page, lru);
>
> By altering whether it's the head or tail free pages are added to, you
> can achieve a similar effect.
>
>>               list_del(&page->lru);
>>               rmv_page_order(page);
>>               area->nr_free--;
>> @@ -792,7 +813,7 @@ static int move_freepages(struct zone *zone,
>>               order = page_order(page);
>>               list_del(&page->lru);
>>               list_add(&page->lru,
>> -                     &zone->free_area[order].free_list[migratetype]);
>> +                     &zone->free_area[order].free_list_0[migratetype]);
>>               page += 1 << order;
>>               pages_moved += 1 << order;
>>       }
>> @@ -845,6 +866,7 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
>>       for (current_order = MAX_ORDER-1; current_order >= order;
>>                                               --current_order) {
>>               for (i = 0; i < MIGRATE_TYPES - 1; i++) {
>> +                     bool fl0, fl1;
>>                       migratetype = fallbacks[start_migratetype][i];
>>
>>                       /* MIGRATE_RESERVE handled later if necessary */
>> @@ -852,11 +874,20 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
>>                               continue;
>>
>>                       area = &(zone->free_area[current_order]);
>> -                     if (list_empty(&area->free_list[migratetype]))
>> +
>> +
>> +                     fl0 = list_empty(&area->free_list_0[migratetype]);
>> +                     fl1 = list_empty(&area->free_list_1[migratetype]);
>> +
>> +                     if (fl0 && fl1)
>>                               continue;
>>
>> -                     page = list_entry(area->free_list[migratetype].next,
>> -                                     struct page, lru);
>> +                     if (fl0)
>> +                             page = list_entry(area->free_list_1[migratetype].next,
>> +                                             struct page, lru);
>> +                     else
>> +                             page = list_entry(area->free_list_0[migratetype].next,
>> +                                             struct page, lru);
>>                       area->nr_free--;
>>
>>                       /*
>> @@ -1061,7 +1092,14 @@ void mark_free_pages(struct zone *zone)
>>               }
>>
>>       for_each_migratetype_order(order, t) {
>> -             list_for_each(curr, &zone->free_area[order].free_list[t]) {
>> +             list_for_each(curr, &zone->free_area[order].free_list_0[t]) {
>> +                     unsigned long i;
>> +
>> +                     pfn = page_to_pfn(list_entry(curr, struct page, lru));
>> +                     for (i = 0; i < (1UL << order); i++)
>> +                             swsusp_set_page_free(pfn_to_page(pfn + i));
>> +             }
>> +             list_for_each(curr, &zone->free_area[order].free_list_1[t]) {
>>                       unsigned long i;
>>
>>                       pfn = page_to_pfn(list_entry(curr, struct page, lru));
>> @@ -2993,7 +3031,8 @@ static void __meminit zone_init_free_lists(struct zone *zone)
>>  {
>>       int order, t;
>>       for_each_migratetype_order(order, t) {
>> -             INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
>> +             INIT_LIST_HEAD(&zone->free_area[order].free_list_0[t]);
>> +             INIT_LIST_HEAD(&zone->free_area[order].free_list_1[t]);
>>               zone->free_area[order].nr_free = 0;
>>       }
>>  }
>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>> index c81321f..613ef1e 100644
>> --- a/mm/vmstat.c
>> +++ b/mm/vmstat.c
>> @@ -468,7 +468,9 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
>>
>>                       area = &(zone->free_area[order]);
>>
>> -                     list_for_each(curr, &area->free_list[mtype])
>> +                     list_for_each(curr, &area->free_list_0[mtype])
>> +                             freecount++;
>> +                     list_for_each(curr, &area->free_list_1[mtype])
>>                               freecount++;
>>                       seq_printf(m, "%6lu ", freecount);
>>               }
>
> No more than the low_latency switch, I think this will help some
> workloads in terms of fragmentation but hurt others that depend on the
> ordering of pages being returned.
Hopefully not, if my considerations above are correct.
> There is a fair amount of overhead
> introduced here as well with branches and a lot of extra lists although
> I believe that could be mitigated.
>
> What are the results if you just alter whether it's the head or tail of
> the list that is used in __free_one_page()?
In that case, it would alter the ordering, but not the one of the
pages returned by expand.
In fact, only the order of the pages returned by free will be
affected, and in that case maybe it is already quite disordered.
If that order is not needed to be kept, I can prepare a new version
with a single list.

BTW, if we only guarantee that pages returned by expand are well
ordered, this patch will increase the ordered-ness of the stream of
allocated pages, since it will increase the probability that
allocations go into expand (since frees will more likely create high
order combined pages). So it will also improve the workloads that
prefer ordered allocations.

>
> --
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
>

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------

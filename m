Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0BSBVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 20:21:13 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36885 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab0BSBVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 20:21:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K+uC8ZVzRmT/sKdiaC/7ptxxKaM6KLjSZQJMTmvWOsUtETfUzN7yYJ3L1vofdZkHUA
         7oaQmxjQt7botS2ErIiGz0CJHDGYY1kTCrIUOTTFDqghPfD8hIPTzMxO5JkPrw+lPthC
         Wye9fhOmojHZ01FX+V9P9jOa0tnXoglMIWeCM=
MIME-Version: 1.0
In-Reply-To: <20100218173437.GA30258@csn.ul.ie>
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie>
	 <1265976059-7459-6-git-send-email-mel@csn.ul.ie>
	 <1266512324.1709.295.camel@barrios-desktop>
	 <20100218173437.GA30258@csn.ul.ie>
Date: Fri, 19 Feb 2010 10:21:10 +0900
Message-ID: <28c262361002181721k2c40854ah638eaaf2254e92a@mail.gmail.com>
Subject: Re: [PATCH 05/12] Memory compaction core
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 2:34 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Fri, Feb 19, 2010 at 01:58:44AM +0900, Minchan Kim wrote:
>> On Fri, 2010-02-12 at 12:00 +0000, Mel Gorman wrote:
>> > +/* Isolate free pages onto a private freelist. Must hold zone->lock */
>> > +static int isolate_freepages_block(struct zone *zone,
>>
>> return type 'int'?
>> I think we can't return signed value.
>>
>
> I don't understand your query. What's wrong with returning int?

It's just nitpick. I mean this functions doesn't return minus value.
Never mind.

>
>> > +                           unsigned long blockpfn,
>> > +                           struct list_head *freelist)
>> > +{
>> > +   unsigned long zone_end_pfn, end_pfn;
>> > +   int total_isolated = 0;
>> > +
>> > +   /* Get the last PFN we should scan for free pages at */
>> > +   zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
>> > +   end_pfn = blockpfn + pageblock_nr_pages;
>> > +   if (end_pfn > zone_end_pfn)
>> > +           end_pfn = zone_end_pfn;
>> > +
>> > +   /* Isolate free pages. This assumes the block is valid */
>> > +   for (; blockpfn < end_pfn; blockpfn++) {
>> > +           struct page *page;
>> > +           int isolated, i;
>> > +
>> > +           if (!pfn_valid_within(blockpfn))
>> > +                   continue;
>> > +
>> > +           page = pfn_to_page(blockpfn);
>> > +           if (!PageBuddy(page))
>> > +                   continue;
>> > +
>> > +           /* Found a free page, break it into order-0 pages */
>> > +           isolated = split_free_page(page);
>> > +           total_isolated += isolated;
>> > +           for (i = 0; i < isolated; i++) {
>> > +                   list_add(&page->lru, freelist);
>> > +                   page++;
>> > +           }
>> > +           blockpfn += isolated - 1;
>
> Incidentally, this line is wrong but will be fixed in line 3. If
> split_free_page() fails, it causes an infinite loop.
>
>> > +   }
>> > +
>> > +   return total_isolated;
>> > +}
>> > +
>> > +/* Returns 1 if the page is within a block suitable for migration to */
>> > +static int suitable_migration_target(struct page *page)
>> > +{
>> > +   /* If the page is a large free page, then allow migration */
>> > +   if (PageBuddy(page) && page_order(page) >= pageblock_order)
>> > +           return 1;
>> > +
>> > +   /* If the block is MIGRATE_MOVABLE, allow migration */
>> > +   if (get_pageblock_migratetype(page) == MIGRATE_MOVABLE)
>> > +           return 1;
>> > +
>> > +   /* Otherwise skip the block */
>> > +   return 0;
>> > +}
>> > +
>> > +/*
>> > + * Based on information in the current compact_control, find blocks
>> > + * suitable for isolating free pages from
>> > + */
>> > +static void isolate_freepages(struct zone *zone,
>> > +                           struct compact_control *cc)
>> > +{
>> > +   struct page *page;
>> > +   unsigned long high_pfn, low_pfn, pfn;
>> > +   unsigned long flags;
>> > +   int nr_freepages = cc->nr_freepages;
>> > +   struct list_head *freelist = &cc->freepages;
>> > +
>> > +   pfn = cc->free_pfn;
>> > +   low_pfn = cc->migrate_pfn + pageblock_nr_pages;
>> > +   high_pfn = low_pfn;
>> > +
>> > +   /*
>> > +    * Isolate free pages until enough are available to migrate the
>> > +    * pages on cc->migratepages. We stop searching if the migrate
>> > +    * and free page scanners meet or enough free pages are isolated.
>> > +    */
>> > +   spin_lock_irqsave(&zone->lock, flags);
>> > +   for (; pfn > low_pfn && cc->nr_migratepages > nr_freepages;
>> > +                                   pfn -= pageblock_nr_pages) {
>> > +           int isolated;
>> > +
>> > +           if (!pfn_valid(pfn))
>> > +                   continue;
>> > +
>> > +           /* Check for overlapping nodes/zones */
>> > +           page = pfn_to_page(pfn);
>> > +           if (page_zone(page) != zone)
>> > +                   continue;
>>
>> We are progressing backward by physical page order in a zone.
>> If we meet crossover between zone, Why are we going backward
>> continuously? Before it happens, migration and free scanner would meet.
>> Am I miss something?
>>
>
> I was considering a situation like the following
>
>
> Node-0     Node-1       Node-0
> DMA        DMA          DMA
> 0-1023     1024-2047    2048-4096
>
> In that case, a PFN scanner can enter a new node and zone but the migrate
> and free scanners have not necessarily met. This configuration is *extremely*
> rare but it happens on messed-up LPAR configurations on POWER.

I don't know such architecture until now.
Thanks for telling me.
How about adding the comment about that?

>
>> > +
>> > +           /* Check the block is suitable for migration */
>> > +           if (!suitable_migration_target(page))
>> > +                   continue;
>>
>> Dumb question.
>> suitable_migration_target considers three type's pages
>>
>> 1. free page and page's order >= pageblock_order
>> 2. free pages and pages's order < pageblock_order with movable page
>> 3. used page with movable
>>
>> I can understand 1 and 2 but can't 3. This function is for gathering
>> free page. How do you handle used page as free one?
>>
>> In addition, as I looked into isolate_freepages_block, it doesn't
>> consider 3 by PageBuddy check.
>>
>> I am confusing. Pz, correct me.
>>
>
> I'm afraid I don't understand your question. At the point
> suitable_migration_target() is called, the only concern is finding a pageblock
> of pages that should be scanned for free pages by isolate_freepages_block().
> What do you mean by "used page with movable" ?

After I looked into code, I understand it.
Thanks.

<snip>
>>> +/* Similar to split_page except the page is already free */
>> Sometime, this function changes pages's type to MIGRATE_MOVABLE.
>> I hope adding comment about that.
>>
>
> There is a comment within the function about it. Do you want it moved to
> here?

If you don't mind, I hope so. :)

That's because you wrote down only "except the page is already free" in
function description. So I thought it's only difference with split_page at first
glance. I think information that setting MIGRATE_MOVABLE is important.

Pz, thinks it as just nitpick.
Thanks, Mel.


-- 
Kind regards,
Minchan Kim

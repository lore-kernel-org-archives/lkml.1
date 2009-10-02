Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbZJBSbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbZJBSbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbZJBSbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:31:46 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49382 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbZJBSbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:31:44 -0400
Date: Fri, 2 Oct 2009 13:31:45 -0500
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Ingo Molnar <mingo@elte.hu>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] mm: add notifier in pageblock isolation for
	balloon drivers
Message-ID: <20091002183145.GA4908@austin.ibm.com>
Mail-Followup-To: Nathan Fontenot <nfont@austin.ibm.com>,
	Mel Gorman <mel@csn.ul.ie>, Ingo Molnar <mingo@elte.hu>,
	Badari Pulavarty <pbadari@us.ibm.com>,
	Brian King <brking@linux.vnet.ibm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@ozlabs.org
References: <20091001195311.GA16667@austin.ibm.com> <4AC520B5.9080600@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC520B5.9080600@austin.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nathan Fontenot (nfont@austin.ibm.com) wrote:
> Robert Jennings wrote:
>> Memory balloon drivers can allocate a large amount of memory which
>> is not movable but could be freed to accommodate memory hotplug remove.
>>
>> Prior to calling the memory hotplug notifier chain the memory in the
>> pageblock is isolated.  If the migrate type is not MIGRATE_MOVABLE the
>> isolation will not proceed, causing the memory removal for that page
>> range to fail.
>>
>> Rather than immediately failing pageblock isolation if the the
>> migrateteype is not MIGRATE_MOVABLE, this patch checks if all of the
>> pages in the pageblock are owned by a registered balloon driver using a
>> notifier chain.  If all of the non-movable pages are owned by a balloon,
>> they can be freed later through the memory notifier chain and the range
>> can still be isolated in set_migratetype_isolate().
>>
>> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
>>
>> ---
>>  drivers/base/memory.c  |   19 +++++++++++++++++++
>>  include/linux/memory.h |   22 ++++++++++++++++++++++
>>  mm/page_alloc.c        |   49 +++++++++++++++++++++++++++++++++++++++++--------
>>  3 files changed, 82 insertions(+), 8 deletions(-)
>>
<snip>
>> Index: b/mm/page_alloc.c
>> ===================================================================
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -48,6 +48,7 @@
>>  #include <linux/page_cgroup.h>
>>  #include <linux/debugobjects.h>
>>  #include <linux/kmemleak.h>
>> +#include <linux/memory.h>
>>  #include <trace/events/kmem.h>
>>   #include <asm/tlbflush.h>
>> @@ -4985,23 +4986,55 @@ void set_pageblock_flags_group(struct pa
>>  int set_migratetype_isolate(struct page *page)
>>  {
>>  	struct zone *zone;
>> -	unsigned long flags;
>> +	unsigned long flags, pfn, iter;
>> +	long immobile = 0;
>> +	struct memory_isolate_notify arg;
>> +	int notifier_ret;
>>  	int ret = -EBUSY;
>>  	int zone_idx;
>>   	zone = page_zone(page);
>>  	zone_idx = zone_idx(zone);
>> +
>> +	pfn = page_to_pfn(page);
>> +	arg.start_addr = (unsigned long)page_address(page);
>> +	arg.nr_pages = pageblock_nr_pages;
>> +	arg.pages_found = 0;
>> +
>>  	spin_lock_irqsave(&zone->lock, flags);
>>  	/*
>>  	 * In future, more migrate types will be able to be isolation target.
>>  	 */
>> -	if (get_pageblock_migratetype(page) != MIGRATE_MOVABLE &&
>> -	    zone_idx != ZONE_MOVABLE)
>> -		goto out;
>> -	set_pageblock_migratetype(page, MIGRATE_ISOLATE);
>> -	move_freepages_block(zone, page, MIGRATE_ISOLATE);
>> -	ret = 0;
>> -out:
>> +	do {
>> +		if (get_pageblock_migratetype(page) == MIGRATE_MOVABLE &&
>> +		    zone_idx == ZONE_MOVABLE) {
>> +			ret = 0;
>> +			break;
>> +		}
>> +
>> +		/*
>> +		 * If all of the pages in a zone are used by a balloon,
>> +		 * the range can be still be isolated.  The balloon will
>> +		 * free these pages from the memory notifier chain.
>> +		 */
>> +		notifier_ret = memory_isolate_notify(MEM_ISOLATE_COUNT, &arg);
>> +		notifier_ret = notifier_to_errno(ret);
>
> Should this be
>
> 		notifier_ret = notifier_to_errno(notifier_ret);
>
> -Nathan

I'll correct this.  Thanks


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbZH1MAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbZH1MAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZH1MAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:00:24 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:57072 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZH1MAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:00:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C8FjGd8zzeYRmJeGlDtlEI5Oh6+ewAoT4POiWHZ3ampwMWbJcde8KHfu0sqCD6c4j3
         drtRL7+y1L+u01zM1aPNIXDzfrXQ6UwumVs3dabA09ZiNIc9iipjLhuX1BFwX/otyneb
         SNFTXZA1VciRCVDvHHvxrIMCaTTs8UC0zDN4Y=
MIME-Version: 1.0
In-Reply-To: <20090828205241.fc8dfa51.minchan.kim@barrios-desktop>
References: <1251449067-3109-1-git-send-email-mel@csn.ul.ie>
	 <1251449067-3109-2-git-send-email-mel@csn.ul.ie>
	 <20090828205241.fc8dfa51.minchan.kim@barrios-desktop>
Date: Fri, 28 Aug 2009 21:00:25 +0900
Message-ID: <28c262360908280500tb47685btc9f36ca81605d55@mail.gmail.com>
Subject: Re: [PATCH 1/2] page-allocator: Split per-cpu list into 
	one-list-per-migrate-type
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 8:52 PM, Minchan Kim<minchan.kim@gmail.com> wrote:
> Hi, Mel.
>
> On Fri, 28 Aug 2009 09:44:26 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
>
>> Currently the per-cpu page allocator searches the PCP list for pages of the
>> correct migrate-type to reduce the possibility of pages being inappropriate
>> placed from a fragmentation perspective. This search is potentially expensive
>> in a fast-path and undesirable. Splitting the per-cpu list into multiple
>> lists increases the size of a per-cpu structure and this was potentially
>> a major problem at the time the search was introduced. These problem has
>> been mitigated as now only the necessary number of structures is allocated
>> for the running system.
>>
>> This patch replaces a list search in the per-cpu allocator with one list per
>> migrate type. The potential snag with this approach is when bulk freeing
>> pages. We round-robin free pages based on migrate type which has little
>> bearing on the cache hotness of the page and potentially checks empty lists
>> repeatedly in the event the majority of PCP pages are of one type.
>>
>> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
>> Acked-by: Nick Piggin <npiggin@suse.de>
>> ---
>>  include/linux/mmzone.h |    5 ++-
>>  mm/page_alloc.c        |  106 ++++++++++++++++++++++++++---------------------
>>  2 files changed, 63 insertions(+), 48 deletions(-)
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 008cdcd..045348f 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -38,6 +38,7 @@
>>  #define MIGRATE_UNMOVABLE     0
>>  #define MIGRATE_RECLAIMABLE   1
>>  #define MIGRATE_MOVABLE       2
>> +#define MIGRATE_PCPTYPES      3 /* the number of types on the pcp lists */
>>  #define MIGRATE_RESERVE       3
>>  #define MIGRATE_ISOLATE       4 /* can't allocate from here */
>>  #define MIGRATE_TYPES         5
>> @@ -169,7 +170,9 @@ struct per_cpu_pages {
>>       int count;              /* number of pages in the list */
>>       int high;               /* high watermark, emptying needed */
>>       int batch;              /* chunk size for buddy add/remove */
>> -     struct list_head list;  /* the list of pages */
>> +
>> +     /* Lists of pages, one per migrate type stored on the pcp-lists */
>> +     struct list_head lists[MIGRATE_PCPTYPES];
>>  };
>>
>>  struct per_cpu_pageset {
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index ac3afe1..65eedb5 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -522,7 +522,7 @@ static inline int free_pages_check(struct page *page)
>>  }
>>
>>  /*
>> - * Frees a list of pages.
>> + * Frees a number of pages from the PCP lists
>>   * Assumes all pages on list are in same zone, and of same order.
>>   * count is the number of pages to free.
>>   *
>> @@ -532,23 +532,36 @@ static inline int free_pages_check(struct page *page)
>>   * And clear the zone's pages_scanned counter, to hold off the "all pages are
>>   * pinned" detection logic.
>>   */
>> -static void free_pages_bulk(struct zone *zone, int count,
>> -                                     struct list_head *list, int order)
>> +static void free_pcppages_bulk(struct zone *zone, int count,
>> +                                     struct per_cpu_pages *pcp)
>>  {
>> +     int migratetype = 0;
>> +
>
> How about caching the last sucess migratetype
> with 'per_cpu_pages->last_alloc_type'?
                                         ^^^^
                                         free
> I think it could prevent a litte spinning empty list.

Anyway, Ignore me.
I didn't see your next patch.

-- 
Kind regards,
Minchan Kim

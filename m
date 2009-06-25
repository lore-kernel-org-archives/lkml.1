Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbZFYOgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbZFYOgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZFYOgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:36:37 -0400
Received: from mail-gx0-f222.google.com ([209.85.217.222]:61421 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZFYOgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:36:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hca50wCtkHKRZLOC0pSy3HgsVsTz5Z394YvQ9oBRuUgSWDf+ObQEvthZC1HGnBr9F7
         Gs4bzwhoHa1duMpT1G1dnNyTDqeJydK7NqTSTcsc3VJyjlSJxGuGMmHjdikEylyEkvEa
         6Mmh7RilCCJyzmYgSH/oiFy5rEJb9DYKHC5og=
MIME-Version: 1.0
In-Reply-To: <4A438522.7040309@redhat.com>
References: <20090625183616.23b55b24.minchan.kim@barrios-desktop>
	 <4A438522.7040309@redhat.com>
Date: Thu, 25 Jun 2009 23:30:11 +0900
Message-ID: <28c262360906250730h7f8240c2mb1411ef147b239b2@mail.gmail.com>
Subject: Re: [PATCH] prevent to reclaim anon page of lumpy reclaim for no swap 
	space
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Juna 25, 2009 at 11:09 PM, Rik van Riel<riel@redhat.com> wrote:
> Minchan Kim wrote:
>>
>> This patch prevent to reclaim anon page in case of no swap space.
>> VM already prevent to reclaim anon page in various place.
>> But it doesnt't prevent it for lumpy reclaim.
>>
>> It shuffles lru list unnecessary so that it is pointless.
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> ---
>>  mm/vmscan.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 026f452..fb401fe 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -830,7 +830,13 @@ int __isolate_lru_page(struct page *page, int mode,
>> int file)
>>         * When this function is being called for lumpy reclaim, we
>>         * initially look into all LRU pages, active, inactive and
>>         * unevictable; only give shrink_page_list evictable pages.
>> +
>> +        * If we don't have enough swap space, reclaiming of anon page
>> +        * is pointless.
>>         */
>> +       if (nr_swap_pages <= 0 && PageAnon(page))
>> +               return ret;
>> +
>
> Should that be something like this:
>
>        if (nr_swap_pages <= 0 && (PageAnon(page) && !PageSwapCache(page)))
>
> We can still reclaim anonymous pages that already have
> a swap slot assigned to them.

Yes. I missed that.
Thanks for careful review. Rik. :)

>
> --
> All rights reversed.
>



-- 
Kinds regards,
Minchan Kim

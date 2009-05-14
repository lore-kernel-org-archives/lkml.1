Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbZENMFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbZENMFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbZENMFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:05:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:19259 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbZENMFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iaVXJB20KhL1u661nZMltowez/M4u+1eXF3AXH9yjBAA3NhTBgbzcnOMB0B1x0XXzo
         RzUsmi2zZ+EF8wNHfeR7INuKQQtXU/BNxL2xsHcYOv5oW3rls8q187mHllM++YVnXdhM
         YUv8+0KSk6O45v5nykqv3TqnPQskSv6E1eSBE=
MIME-Version: 1.0
In-Reply-To: <20090514204033.9B87.A69D9226@jp.fujitsu.com>
References: <20090514201150.8536f86e.minchan.kim@barrios-desktop>
	 <20090514202538.9B81.A69D9226@jp.fujitsu.com>
	 <20090514204033.9B87.A69D9226@jp.fujitsu.com>
Date: Thu, 14 May 2009 21:05:03 +0900
Message-ID: <28c262360905140505h2db7ac3bp5ca10fcf2b4301bb@mail.gmail.com>
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in case 
	of no swap space V2
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 8:44 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> >
>> > Changelog since V2
>> >  o Add new function - can_reclaim_anon : it tests anon_list can be reclaim
>> >
>> > Changelog since V1
>> >  o Use nr_swap_pages <= 0 in shrink_active_list to prevent scanning  of active anon list.
>> >
>> > Now shrink_active_list is called several places.
>> > But if we don't have a swap space, we can't reclaim anon pages.
>> > So, we don't need deactivating anon pages in anon lru list.
>> >
>> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > Cc: Johannes Weiner <hannes@cmpxchg.org>
>> > Cc: Rik van Riel <riel@redhat.com>
>>
>> looks good to me. thanks :)
>
> Grr, my fault.
>
>
>
>>  static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
>>       struct zone *zone, struct scan_control *sc, int priority)
>>  {
>> @@ -1399,7 +1412,7 @@ static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
>>               return 0;
>>       }
>>
>> -     if (lru == LRU_ACTIVE_ANON && inactive_anon_is_low(zone, sc)) {
>> +     if (lru == LRU_ACTIVE_ANON && can_reclaim_anon(zone, sc)) {
>>               shrink_active_list(nr_to_scan, zone, sc, priority, file);
>>               return 0;
>
> you shouldn't do that. if nr_swap_pages==0, get_scan_ratio return anon=0%.
> then, this branch is unnecessary.
>

But, I think at last it can be happen following as.

1515         * Even if we did not try to evict anon pages at all, we want to
1516         * rebalance the anon lru active/inactive ratio.
1517         */
1518        if (inactive_anon_is_low(zone, sc))
1519                shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);


>
>



-- 
Kinds regards,
Minchan Kim

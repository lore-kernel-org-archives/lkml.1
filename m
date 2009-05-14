Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbZENNd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbZENNd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZENNdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:33:16 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:53635 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZENNdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vhaji9XSDy1A28+yjoDuwoW3Iphw7WmaDMvSzZz0xUtFIbSpFlN751YenNIoqjpQ8C
         ndzhQPMzWAnR3/8ywbGLqpupk7ezP3wwrZgLWRMiq4tjfP9dsc56E47kAZCBFJWQSCZ9
         j3VySiiWy1EOoyuSjj9WmL4upoWbQoJ/aWRHE=
MIME-Version: 1.0
In-Reply-To: <4A0C1A41.7040202@redhat.com>
References: <20090514201150.8536f86e.minchan.kim@barrios-desktop>
	 <4A0C1571.2020106@redhat.com>
	 <28c262360905140609y580b6835m759dee08f08a26ab@mail.gmail.com>
	 <4A0C1A41.7040202@redhat.com>
Date: Thu, 14 May 2009 22:33:16 +0900
Message-ID: <28c262360905140633q3a7ace7byec2f47b0f0d2e78d@mail.gmail.com>
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in case 
	of no swap space V2
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 10:18 PM, Rik van Riel <riel@redhat.com> wrote:
> Minchan Kim wrote:
>>
>> HI, Rik
>>
>> Thanks for careful review. :)
>>
>> On Thu, May 14, 2009 at 9:58 PM, Rik van Riel <riel@redhat.com> wrote:
>>>
>>> Minchan Kim wrote:
>>>
>>>> Now shrink_active_list is called several places.
>>>> But if we don't have a swap space, we can't reclaim anon pages.
>>>
>>> If swap space has run out, get_scan_ratio() will return
>>> 0 for the anon scan ratio, meaning we do not scan the
>>> anon lists.
>>
>> I think get_scan_ration can't prevent scanning of anon pages in no
>> swap system(like embedded system).
>> That's because in shrink_zone, you add following as
>>
>>        /*
>>         * Even if we did not try to evict anon pages at all, we want to
>>         * rebalance the anon lru active/inactive ratio.
>>         */
>>        if (inactive_anon_is_low(zone, sc))
>>                shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority,
>> 0);
>
> That's a fair point.
>
> How about we change this to:
>
>        if (inactive_anon_is_low(zone, sc) && nr_swap_pages >= 0)
> That way GCC will statically optimize away this branch on
> systems with CONFIG_SWAP=n.
>
> Does that look reasonable?

Now inactive_anon_is_low called following as.

1. shrink_zone => Looks good since your idea.
2. balance_pgdat => Looks good since aging.
3. shrink_list
shrink_list is called at two places.
1. shrink_zone => It's OK since get_scan_ratio can't prevent it.
2. shrink_all_zones. => It's OK since we can't suspend without swap space.

So, Okay I will do that in next version.
Thanks for good review. Rik :)
Could I add your ack in next version ?

> --
> All rights reversed.
>



-- 
Kinds regards,
Minchan Kim

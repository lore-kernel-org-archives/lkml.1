Return-Path: <linux-kernel-owner+w=401wt.eu-S1761188AbZENNJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188AbZENNJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbZENNJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:09:04 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:52561 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZENNJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:09:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rtYsaERRGteVFM1Dk1lQAPSfuzO6saUK8D9rLLw4Wlf182FniYYEovHcVoYQqHlp3P
         t6sgxr4aece6UwEcCY+kv3YFIrooBZo/FGfOlF1F5CifrE/XOMykVjBLkz+B2n9zpmSy
         D7cftbqPiUXHI67DdIJxjo5hkttE9OlT5gyBY=
MIME-Version: 1.0
In-Reply-To: <4A0C1571.2020106@redhat.com>
References: <20090514201150.8536f86e.minchan.kim@barrios-desktop>
	 <4A0C1571.2020106@redhat.com>
Date: Thu, 14 May 2009 22:09:03 +0900
Message-ID: <28c262360905140609y580b6835m759dee08f08a26ab@mail.gmail.com>
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

HI, Rik

Thanks for careful review. :)

On Thu, May 14, 2009 at 9:58 PM, Rik van Riel <riel@redhat.com> wrote:
> Minchan Kim wrote:
>
>> Now shrink_active_list is called several places.
>> But if we don't have a swap space, we can't reclaim anon pages.
>
> If swap space has run out, get_scan_ratio() will return
> 0 for the anon scan ratio, meaning we do not scan the
> anon lists.

I think get_scan_ration can't prevent scanning of anon pages in no
swap system(like embedded system).
That's because in shrink_zone, you add following as

        /*
         * Even if we did not try to evict anon pages at all, we want to
         * rebalance the anon lru active/inactive ratio.
         */
        if (inactive_anon_is_low(zone, sc))
                shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);

>> So, we don't need deactivating anon pages in anon lru list.
>
> If we are close to running out of swap space, with
> swapins freeing up swap space on a regular basis,
> I believe we do want to do aging on the active
> pages, just so we can pick a decent page to swap
> out next time swap space becomes available.

I agree your opinion.

>> +static int can_reclaim_anon(struct zone *zone, struct scan_control *sc)
>> +{
>> +       return (inactive_anon_is_low(zone, sc) && nr_swap_pages <= 0);
>> +}
>> +
>
> This function name is misleading, because when we do have
> swap space available but inactive_anon_is_low is false,
> we still want to reclaim inactive anon pages!

Indeed. I will rename it.

> What problem did you encounter that you think this patch
> solves?

I thought In embedded system most products don't have swap space.
In such environment, We don't need anon lru list.
I think even scanning of anon list is much bad


> --
> All rights reversed.
>



-- 
Kinds regards,
Minchan Kim

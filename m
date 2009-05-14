Return-Path: <linux-kernel-owner+w=401wt.eu-S1761761AbZENNUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761AbZENNUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbZENNUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:20:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58676 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862AbZENNUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:20:00 -0400
Message-ID: <4A0C1A41.7040202@redhat.com>
Date: Thu, 14 May 2009 09:18:57 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in case
 	of no swap space V2
References: <20090514201150.8536f86e.minchan.kim@barrios-desktop>	 <4A0C1571.2020106@redhat.com> <28c262360905140609y580b6835m759dee08f08a26ab@mail.gmail.com>
In-Reply-To: <28c262360905140609y580b6835m759dee08f08a26ab@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:
> HI, Rik
> 
> Thanks for careful review. :)
> 
> On Thu, May 14, 2009 at 9:58 PM, Rik van Riel <riel@redhat.com> wrote:
>> Minchan Kim wrote:
>>
>>> Now shrink_active_list is called several places.
>>> But if we don't have a swap space, we can't reclaim anon pages.
>> If swap space has run out, get_scan_ratio() will return
>> 0 for the anon scan ratio, meaning we do not scan the
>> anon lists.
> 
> I think get_scan_ration can't prevent scanning of anon pages in no
> swap system(like embedded system).
> That's because in shrink_zone, you add following as
> 
>         /*
>          * Even if we did not try to evict anon pages at all, we want to
>          * rebalance the anon lru active/inactive ratio.
>          */
>         if (inactive_anon_is_low(zone, sc))
>                 shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);

That's a fair point.

How about we change this to:

	if (inactive_anon_is_low(zone, sc) && nr_swap_pages >= 0)

That way GCC will statically optimize away this branch on
systems with CONFIG_SWAP=n.

Does that look reasonable?

-- 
All rights reversed.

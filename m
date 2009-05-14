Return-Path: <linux-kernel-owner+w=401wt.eu-S1760744AbZENM6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744AbZENM6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZENM6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:58:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60960 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbZENM6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:58:36 -0400
Message-ID: <4A0C1571.2020106@redhat.com>
Date: Thu, 14 May 2009 08:58:25 -0400
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
References: <20090514201150.8536f86e.minchan.kim@barrios-desktop>
In-Reply-To: <20090514201150.8536f86e.minchan.kim@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:

> Now shrink_active_list is called several places.
> But if we don't have a swap space, we can't reclaim anon pages.

If swap space has run out, get_scan_ratio() will return
0 for the anon scan ratio, meaning we do not scan the
anon lists.

> So, we don't need deactivating anon pages in anon lru list.

If we are close to running out of swap space, with
swapins freeing up swap space on a regular basis,
I believe we do want to do aging on the active
pages, just so we can pick a decent page to swap
out next time swap space becomes available.

> +static int can_reclaim_anon(struct zone *zone, struct scan_control *sc)
> +{
> +	return (inactive_anon_is_low(zone, sc) && nr_swap_pages <= 0);
> +}
> +

This function name is misleading, because when we do have
swap space available but inactive_anon_is_low is false,
we still want to reclaim inactive anon pages!

What problem did you encounter that you think this patch
solves?

-- 
All rights reversed.

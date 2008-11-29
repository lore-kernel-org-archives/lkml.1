Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbYK2Qrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbYK2Qrm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 11:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYK2Qre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 11:47:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48003 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbYK2Qre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 11:47:34 -0500
Message-ID: <4931721D.7010001@redhat.com>
Date: Sat, 29 Nov 2008 11:47:25 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: skip freeing memory from zones with lots free
References: <20081128060803.73cd59bd@bree.surriel.com> <20081128231933.8daef193.akpm@linux-foundation.org>
In-Reply-To: <20081128231933.8daef193.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>> Index: linux-2.6.28-rc5/mm/vmscan.c
>> ===================================================================
>> --- linux-2.6.28-rc5.orig/mm/vmscan.c	2008-11-28 05:53:56.000000000 -0500
>> +++ linux-2.6.28-rc5/mm/vmscan.c	2008-11-28 06:05:29.000000000 -0500
>> @@ -1510,6 +1510,9 @@ static unsigned long shrink_zones(int pr
>>  			if (zone_is_all_unreclaimable(zone) &&
>>  						priority != DEF_PRIORITY)
>>  				continue;	/* Let kswapd poll it */
>> +			if (zone_watermark_ok(zone, sc->order,
>> +					4*zone->pages_high, high_zoneidx, 0))
>> +				continue;	/* Lots free already */
>>  			sc->all_unreclaimable = 0;
>>  		} else {
>>  			/*
> 
> We already tried this, or something very similar in effect, I think...

Yes, we have a check just like this in balance_pgdat().

It's been there forever with no ill effect.

> commit 26e4931632352e3c95a61edac22d12ebb72038fe
> Author: akpm <akpm>
> Date:   Sun Sep 8 19:21:55 2002 +0000
> 
>     [PATCH] refill the inactive list more quickly
>     
>     Fix a problem noticed by Ed Tomlinson: under shifting workloads the
>     shrink_zone() logic will refill the inactive load too slowly.
>     
>     Bale out of the zone scan when we've reclaimed enough pages.  Fixes a
>     rarely-occurring problem wherein refill_inactive_zone() ends up
>     shuffling 100,000 pages and generally goes silly.

This is not a bale out, this is a "skip zones that have way
too many free pages already".

Kswapd has been doing this for years already.

-- 
All rights reversed.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbYK2RqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbYK2RqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 12:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYK2RqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 12:46:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbYK2RqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 12:46:01 -0500
Date: Sat, 29 Nov 2008 09:45:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: skip freeing memory from zones with lots free
Message-Id: <20081129094537.a224098a.akpm@linux-foundation.org>
In-Reply-To: <4931721D.7010001@redhat.com>
References: <20081128060803.73cd59bd@bree.surriel.com>
	<20081128231933.8daef193.akpm@linux-foundation.org>
	<4931721D.7010001@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 11:47:25 -0500 Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> 
> >> Index: linux-2.6.28-rc5/mm/vmscan.c
> >> ===================================================================
> >> --- linux-2.6.28-rc5.orig/mm/vmscan.c	2008-11-28 05:53:56.000000000 -0500
> >> +++ linux-2.6.28-rc5/mm/vmscan.c	2008-11-28 06:05:29.000000000 -0500
> >> @@ -1510,6 +1510,9 @@ static unsigned long shrink_zones(int pr
> >>  			if (zone_is_all_unreclaimable(zone) &&
> >>  						priority != DEF_PRIORITY)
> >>  				continue;	/* Let kswapd poll it */
> >> +			if (zone_watermark_ok(zone, sc->order,
> >> +					4*zone->pages_high, high_zoneidx, 0))
> >> +				continue;	/* Lots free already */
> >>  			sc->all_unreclaimable = 0;
> >>  		} else {
> >>  			/*
> > 
> > We already tried this, or something very similar in effect, I think...
> 
> Yes, we have a check just like this in balance_pgdat().
> 
> It's been there forever with no ill effect.

This patch affects direct reclaim as well as kswapd.

> > commit 26e4931632352e3c95a61edac22d12ebb72038fe
> > Author: akpm <akpm>
> > Date:   Sun Sep 8 19:21:55 2002 +0000
> > 
> >     [PATCH] refill the inactive list more quickly
> >     
> >     Fix a problem noticed by Ed Tomlinson: under shifting workloads the
> >     shrink_zone() logic will refill the inactive load too slowly.
> >     
> >     Bale out of the zone scan when we've reclaimed enough pages.  Fixes a
> >     rarely-occurring problem wherein refill_inactive_zone() ends up
> >     shuffling 100,000 pages and generally goes silly.
> 
> This is not a bale out, this is a "skip zones that have way
> too many free pages already".

It is similar in effect.

Will this new patch reintroduce the problem which
26e4931632352e3c95a61edac22d12ebb72038fe fixed?

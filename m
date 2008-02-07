Return-Path: <linux-kernel-owner+w=401wt.eu-S1760786AbYBGBVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786AbYBGBVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 20:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758288AbYBGBVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 20:21:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57687 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152AbYBGBVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 20:21:07 -0500
Date: Thu, 07 Feb 2008 10:20:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Cc: kosaki.motohiro@jp.fujitsu.com, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080206193512.77b5f21f@bree.surriel.com>
References: <20080130175439.1AFD.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080206193512.77b5f21f@bree.surriel.com>
Message-Id: <20080207101634.4AC7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik

Welcome back :)

> > I found number of scan pages calculation bug.
> 
> My latest version of get_scan_ratio() works differently, with the
> percentages always adding up to 100.  However, your patch gave me
> the inspiration to (hopefully) find the bug in my version of the
> code.

OK.


> > 2. wrong fraction omission
> > 
> > 	nr[l] = zone->nr_scan[l] * percent[file] / 100;
> > 
> > 	when percent is very small,
> > 	nr[l] become 0.
> 
> This is probably where the problem is.  Kind of.
> 
> I believe that the problem is that we scale nr[l] by the percentage,
> instead of scaling the amount we add to zone->nr_scan[l] by the
> percentage!

Aahh,
you are right.


> Index: linux-2.6.24-rc6-mm1/mm/vmscan.c
> ===================================================================
> --- linux-2.6.24-rc6-mm1.orig/mm/vmscan.c	2008-02-06 19:23:16.000000000 -0500
> +++ linux-2.6.24-rc6-mm1/mm/vmscan.c	2008-02-06 19:22:55.000000000 -0500
> @@ -1275,13 +1275,17 @@ static unsigned long shrink_zone(int pri
>  	for_each_lru(l) {
>  		if (scan_global_lru(sc)) {
>  			int file = is_file_lru(l);
> +			int scan;
>  			/*
>  			 * Add one to nr_to_scan just to make sure that the
> -			 * kernel will slowly sift through the active list.
> +			 * kernel will slowly sift through each list.
>  			 */
> -			zone->nr_scan[l] += (zone_page_state(zone,
> -				NR_INACTIVE_ANON + l) >> priority) + 1;
> -			nr[l] = zone->nr_scan[l] * percent[file] / 100;
> +			scan = zone_page_state(zone, NR_INACTIVE_ANON + l);
> +			scan >>= priority;
> +			scan = (scan * percent[file]) / 100;
> +
> +			zone->nr_scan[l] += scan + 1;
> +			nr[l] = zone->nr_scan[l];
>  			if (nr[l] >= sc->swap_cluster_max)
>  				zone->nr_scan[l] = 0;
>  			else

looks good.
thank you clean up code.


- kosaki



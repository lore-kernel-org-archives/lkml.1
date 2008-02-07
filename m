Return-Path: <linux-kernel-owner+w=401wt.eu-S935179AbYBGArK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935179AbYBGArK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932793AbYBGAfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:35:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765495AbYBGAf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:35:26 -0500
Date: Wed, 6 Feb 2008 19:35:12 -0500
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-ID: <20080206193512.77b5f21f@bree.surriel.com>
In-Reply-To: <20080130175439.1AFD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080108210002.638347207@redhat.com>
	<20080130121152.1AF1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080130175439.1AFD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 17:57:54 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> I found number of scan pages calculation bug.

My latest version of get_scan_ratio() works differently, with the
percentages always adding up to 100.  However, your patch gave me
the inspiration to (hopefully) find the bug in my version of the
code.
 
> 1. wrong calculation order

I do not believe my new code has this problem.  Of course, this
is purely due to luck :)

> 2. wrong fraction omission
> 
> 	nr[l] = zone->nr_scan[l] * percent[file] / 100;
> 
> 	when percent is very small,
> 	nr[l] become 0.

This is probably where the problem is.  Kind of.

I believe that the problem is that we scale nr[l] by the percentage,
instead of scaling the amount we add to zone->nr_scan[l] by the
percentage!

> @@ -1409,7 +1410,11 @@ static unsigned long shrink_zone(int pri
>  			 */
>  			zone->nr_scan[l] += (zone_page_state(zone,
>  				NR_INACTIVE_ANON + l) >> priority) + 1;
> -			nr[l] = zone->nr_scan[l] * percent[file] / 100;
> +			nr[l] = (zone->nr_scan[l] * percent[file] / 100) + 1;
> +			nr_max_scan = zone_page_state(zone, NR_INACTIVE_ANON+l);
> +			if (nr[l] > nr_max_scan)
> +				nr[l] = nr_max_scan;
> +
>  			if (nr[l] >= sc->swap_cluster_max)
>  				zone->nr_scan[l] = 0;
>  			else

With the fix below (against my latest tree), we always add at least one
to zone->nr_scan[l] and always make that increment count later on!

I am still recovering from my trip home (thanks to the airline companies
I spent 25 hours travelling, from door to door), so I may not get around
to actually testing this today:

Index: linux-2.6.24-rc6-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.24-rc6-mm1.orig/mm/vmscan.c	2008-02-06 19:23:16.000000000 -0500
+++ linux-2.6.24-rc6-mm1/mm/vmscan.c	2008-02-06 19:22:55.000000000 -0500
@@ -1275,13 +1275,17 @@ static unsigned long shrink_zone(int pri
 	for_each_lru(l) {
 		if (scan_global_lru(sc)) {
 			int file = is_file_lru(l);
+			int scan;
 			/*
 			 * Add one to nr_to_scan just to make sure that the
-			 * kernel will slowly sift through the active list.
+			 * kernel will slowly sift through each list.
 			 */
-			zone->nr_scan[l] += (zone_page_state(zone,
-				NR_INACTIVE_ANON + l) >> priority) + 1;
-			nr[l] = zone->nr_scan[l] * percent[file] / 100;
+			scan = zone_page_state(zone, NR_INACTIVE_ANON + l);
+			scan >>= priority;
+			scan = (scan * percent[file]) / 100;
+
+			zone->nr_scan[l] += scan + 1;
+			nr[l] = zone->nr_scan[l];
 			if (nr[l] >= sc->swap_cluster_max)
 				zone->nr_scan[l] = 0;
 			else


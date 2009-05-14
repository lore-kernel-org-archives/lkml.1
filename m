Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbZENLoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbZENLoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbZENLoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:44:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57681 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbZENLoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:44:07 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in case of no swap space V2
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090514202538.9B81.A69D9226@jp.fujitsu.com>
References: <20090514201150.8536f86e.minchan.kim@barrios-desktop> <20090514202538.9B81.A69D9226@jp.fujitsu.com>
Message-Id: <20090514204033.9B87.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 May 2009 20:44:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Changelog since V2
> >  o Add new function - can_reclaim_anon : it tests anon_list can be reclaim 
> > 
> > Changelog since V1 
> >  o Use nr_swap_pages <= 0 in shrink_active_list to prevent scanning  of active anon list.
> > 
> > Now shrink_active_list is called several places.
> > But if we don't have a swap space, we can't reclaim anon pages.
> > So, we don't need deactivating anon pages in anon lru list.
> > 
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Rik van Riel <riel@redhat.com>	
> 
> looks good to me. thanks :)

Grr, my fault.



>  static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
>  	struct zone *zone, struct scan_control *sc, int priority)
>  {
> @@ -1399,7 +1412,7 @@ static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
>  		return 0;
>  	}
>  
> -	if (lru == LRU_ACTIVE_ANON && inactive_anon_is_low(zone, sc)) {
> +	if (lru == LRU_ACTIVE_ANON && can_reclaim_anon(zone, sc)) {
>  		shrink_active_list(nr_to_scan, zone, sc, priority, file);
>  		return 0;

you shouldn't do that. if nr_swap_pages==0, get_scan_ratio return anon=0%.
then, this branch is unnecessary.





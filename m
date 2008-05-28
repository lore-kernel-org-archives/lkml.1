Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYE1Fhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYE1Fhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 01:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYE1FhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 01:37:21 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58362 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYE1FhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 01:37:21 -0400
Message-Id: <483CEF78.9050802@mxp.nes.nec.co.jp>
Date: Wed, 28 May 2008 14:36:56 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm 07/16] second chance replacement for anonymous pages
References: <20080523195506.084894989@redhat.com> <20080523195535.302440037@redhat.com>
In-Reply-To: <20080523195535.302440037@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

> @@ -1008,7 +1008,7 @@ static inline int zone_is_near_oom(struc
>  static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
>  			struct scan_control *sc, int priority, int file)
>  {
> -	unsigned long pgmoved;
> +	unsigned long pgmoved = 0;
>  	int pgdeactivate = 0;
>  	unsigned long pgscanned;
>  	LIST_HEAD(l_hold);	/* The pages which were snipped off */
> @@ -1040,13 +1040,25 @@ static void shrink_active_list(unsigned 
>  		cond_resched();
>  		page = lru_to_page(&l_hold);
>  		list_del(&page->lru);
> -		if (page_referenced(page, 0, sc->mem_cgroup))
> +		if (page_referenced(page, 0, sc->mem_cgroup) && file) {
> +			/* Referenced file pages stay active. */
>  			list_add(&page->lru, &l_active);
> -		else
> +		} else {
>  			list_add(&page->lru, &l_inactive);
> +			if (!file)
> +				/* Anonymous pages always get deactivated. */
> +				pgmoved++;
> +		}
>  	}
>  
>  	/*
> +	 * Count the referenced anon pages as rotated, to balance pageout
> +	 * scan pressure between file and anonymous pages in get_sacn_ratio.
> +	 */
> +	if (!file)
> +		zone->recent_rotated_anon += pgmoved;
> +

Shouldn't 'pgmoved' be cleared to 0 before scanning l_hold?
It's used to store the result of sc->isolate_pages() before
scanning l_hold.


Thanks,
Daisuke Nishimura.


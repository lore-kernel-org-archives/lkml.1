Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZK0GCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZK0GCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 01:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZK0GCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 01:02:45 -0500
Received: from sparc.brc.ubc.ca ([137.82.2.12]:49672 "EHLO sparc.brc.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbZK0GCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 01:02:45 -0500
Date: Thu, 26 Nov 2009 21:44:30 -0800 (PST)
From: Vincent Li <macli@brc.ubc.ca>
X-X-Sender: root@kernalhack.brc.ubc.ca
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] vmscan: make lru_index() helper function
In-Reply-To: <20091127091755.A7CF.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0911262138310.14657@kernalhack.brc.ubc.ca>
References: <20091127091357.A7CC.A69D9226@jp.fujitsu.com> <20091127091755.A7CF.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi KOSAKI,

On Fri, 27 Nov 2009, KOSAKI Motohiro wrote:

> Current lru calculation (e.g. LRU_ACTIVE + file * LRU_FILE) is a bit
> ugly.
> To make helper function improve code readability a bit.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/vmscan.c |   25 ++++++++++++++-----------
>  1 files changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a58ff15..7e0245d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -156,6 +156,16 @@ static unsigned long zone_nr_lru_pages(struct zone *zone,
>  	return zone_page_state(zone, NR_LRU_BASE + lru);
>  }
>  
> +static inline enum lru_list lru_index(int active, int file)
> +{
> +	int lru = LRU_BASE;
> +	if (active)
> +		lru += LRU_ACTIVE;
> +	if (file)
> +		lru += LRU_FILE;
> +
> +	return lru;
> +}
>  
> @@ -1373,10 +1378,8 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
>  	 */
>  	reclaim_stat->recent_rotated[file] += nr_rotated;
>  
> -	move_active_pages_to_lru(zone, &l_active,
> -						LRU_ACTIVE + file * LRU_FILE);
> -	move_active_pages_to_lru(zone, &l_inactive,
> -						LRU_BASE   + file * LRU_FILE);
> +	move_active_pages_to_lru(zone, &l_active, lru_index(1, file));
> +	move_active_pages_to_lru(zone, &l_inactive, lru_index(0, file));

How about:
	move_active_pages_to_lru(zone, &l_active, lru_index(LRU_ACTIVE, file));
	move_active_pages_to_lru(zone, &l_inactive, lru_index(LRU_BASE, file));
?


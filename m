Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbZGDRgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbZGDRgc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 13:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZGDRgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 13:36:23 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:58801 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbZGDRgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 13:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DNWHwpgKRsRf1+KFfr1fUQDPa+e6ur9mpKZ02NyOFOgyjYZ5fjRyYniJ7CHFQ20hnp
         23VgFg4ozrtG2rkTwE4sGA39ARgd+V7uoQSdxs7aLo3NryT4teWpMHLYqIlFwkmjlJUr
         aRBN5LoNFcuiX+QyXj2C5pEIBUjag1iXLfYyk=
MIME-Version: 1.0
In-Reply-To: <20090704141818.0afa877a.minchan.kim@gmail.com>
References: <20090704141818.0afa877a.minchan.kim@gmail.com>
Date: Sun, 5 Jul 2009 02:36:25 +0900
X-Google-Sender-Auth: 36a4f4c56aab5d6b
Message-ID: <2f11576a0907041036i3585206bl475cc9f70176a0db@mail.gmail.com>
Subject: Re: [PATCH][mmotm] don't attempt to reclaim anon page in lumpy 
	reclaim when no swap space is available
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/4 Minchan Kim <minchan.kim@gmail.com>:
>
> This patch is based on mmotm 2009-07-02-19-57 reverted
> 'vmscan: don't attempt to reclaim anon page in lumpy reclaim when no swap space is available.'
>
> This verssion is better than old one.
> That's because enough swap space check is done in case of only lumpy reclaim.
> so it can't degrade performance in normal case.
>
> == CUT HERE ==
>
> VM already avoids attempting to reclaim anon pages in various places, But
> it doesn't avoid it for lumpy reclaim.
>
> It shuffles lru list unnecessary so that it is pointless.
>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/vmscan.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 27558aa..977af15 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -930,6 +930,13 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>                        /* Check that we have not crossed a zone boundary. */
>                        if (unlikely(page_zone_id(cursor_page) != zone_id))
>                                continue;
> +                       /*
> +                        * If we don't have enough swap space, reclaiming of anon page
> +                        * which don't already have a swap slot is pointless.
> +                        */
> +                       if (nr_swap_pages <= 0 && (PageAnon(cursor_page) &&
> +                                               !PageSwapCache(cursor_page)))
> +                               continue;
>                        if (__isolate_lru_page(cursor_page, mode, file) == 0) {
>                                list_move(&cursor_page->lru, dst);
>                                mem_cgroup_del_lru(cursor_page);

okey. this is definitely better. thanks.
    Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

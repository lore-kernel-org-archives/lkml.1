Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbZFYOVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbZFYOVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZFYOVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:21:30 -0400
Received: from mail-gx0-f222.google.com ([209.85.217.222]:56022 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZFYOV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DYGD4jv/1AiZJONHSnvz8hFvo+01TH/hxB8lWMIseVzxXOLbbyld9c2NcNRwVURS3q
         Jik8nh5gJ0CMANhi6w3nMzfLQbDwcNcK6nDqLMxhICtotU3LnV4pOd0PJEUlqO1zqqod
         9CWEuZT7Nj8/iMgGmsvlhsiC8BKazPZvt/htU=
MIME-Version: 1.0
In-Reply-To: <20090625183616.23b55b24.minchan.kim@barrios-desktop>
References: <20090625183616.23b55b24.minchan.kim@barrios-desktop>
Date: Thu, 25 Jun 2009 23:14:45 +0900
X-Google-Sender-Auth: 37a2f6b4a3ff1758
Message-ID: <2f11576a0906250714o5d77db11wd32c1c7139753cb5@mail.gmail.com>
Subject: Re: [PATCH] prevent to reclaim anon page of lumpy reclaim for no swap 
	space
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch prevent to reclaim anon page in case of no swap space.
> VM already prevent to reclaim anon page in various place.
> But it doesnt't prevent it for lumpy reclaim.
>
> It shuffles lru list unnecessary so that it is pointless.

NAK.

1. if system have no swap, add_to_swap() never get swap entry.
   eary check don't improve performance so much.
2. __isolate_lru_page() is not only called lumpy reclaim case, but
also be called
    normal reclaim.
3. if system have no swap, anon pages shuffuling doesn't cause any matter.

Then, I don't think this patch's benefit is bigger than side effect.



> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/vmscan.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 026f452..fb401fe 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -830,7 +830,13 @@ int __isolate_lru_page(struct page *page, int mode, int file)
>         * When this function is being called for lumpy reclaim, we
>         * initially look into all LRU pages, active, inactive and
>         * unevictable; only give shrink_page_list evictable pages.
> +
> +        * If we don't have enough swap space, reclaiming of anon page
> +        * is pointless.
>         */
> +       if (nr_swap_pages <= 0 && PageAnon(page))
> +               return ret;
> +
>        if (PageUnevictable(page))
>                return ret;
>
> --
> 1.5.4.3
>
>
>
>
> --
> Kinds Regards
> Minchan Kim
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>

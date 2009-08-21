Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbZHULJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbZHULJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 07:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZHULJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 07:09:17 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:37321 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbZHULJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 07:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tbnAqz5eRTf7bbnUlG9Kl0DfGXNeL8QN3PW4F8/6jH5Xh0HCmmA1ArOl8+mL8LWCj3
         7fnXLFGN4EAdAY+7I41J9RF4iwOaQUoeVa6dE8/ZKMMGh3BfmNVDz8pKEoUhdkWlCppb
         h30v2SRmvy/Bm9v7LZsNBL5JFg+qpp7CDUg/U=
MIME-Version: 1.0
In-Reply-To: <20090820031723.GA25673@localhost>
References: <20090820024929.GA19793@localhost>
	 <20090820025209.GA24387@localhost> <20090820031723.GA25673@localhost>
Date: Fri, 21 Aug 2009 20:09:17 +0900
X-Google-Sender-Auth: 7f82bfa02b4c30a1
Message-ID: <2f11576a0908210409p3f1551a4i194887abbad94e9b@mail.gmail.com>
Subject: Re: [RFC][PATCH] mm: remove unnecessary loop inside 
	shrink_inactive_list()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/20 Wu Fengguang <fengguang.wu@intel.com>:
> shrink_inactive_list() won't be called to scan too much pages
> (unless in hibernation code which is fine) or too few pages (ie.
> batching is taken care of by the callers).  So we can just remove the
> big loop and isolate the exact number of pages requested.
>
> Just a RFC, and a scratch patch to show the basic idea.
> Please kindly NAK quick if you don't like it ;)

Hm, I think this patch taks only cleanups. right?
if so, I don't find any objection reason.




> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/vmscan.c |   32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
>
> --- linux.orig/mm/vmscan.c      2009-08-20 10:16:18.000000000 +0800
> +++ linux/mm/vmscan.c   2009-08-20 10:24:34.000000000 +0800
> @@ -1032,16 +1032,22 @@ int isolate_lru_page(struct page *page)
>  * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
>  * of reclaimed pages
>  */
> -static unsigned long shrink_inactive_list(unsigned long max_scan,
> +static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>                        struct zone *zone, struct scan_control *sc,
>                        int priority, int file)
>  {
>        LIST_HEAD(page_list);
>        struct pagevec pvec;
> -       unsigned long nr_scanned = 0;
> -       unsigned long nr_reclaimed = 0;
> +       unsigned long nr_reclaimed;
>        struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
> -       int lumpy_reclaim = 0;
> +       int lumpy_reclaim;
> +       struct page *page;
> +       unsigned long nr_taken;
> +       unsigned long nr_scan;
> +       unsigned long nr_freed;
> +       unsigned long nr_active;
> +       unsigned int count[NR_LRU_LISTS] = { 0, };
> +       int mode;
>
>        /*
>         * If we need a large contiguous chunk of memory, or have
> @@ -1054,21 +1060,17 @@ static unsigned long shrink_inactive_lis
>                lumpy_reclaim = 1;
>        else if (sc->order && priority < DEF_PRIORITY - 2)
>                lumpy_reclaim = 1;
> +       else
> +               lumpy_reclaim = 0;
> +
> +       mode = lumpy_reclaim ? ISOLATE_BOTH : ISOLATE_INACTIVE;
>
>        pagevec_init(&pvec, 1);
>
>        lru_add_drain();
>        spin_lock_irq(&zone->lru_lock);
> -       do {
> -               struct page *page;
> -               unsigned long nr_taken;
> -               unsigned long nr_scan;
> -               unsigned long nr_freed;
> -               unsigned long nr_active;
> -               unsigned int count[NR_LRU_LISTS] = { 0, };
> -               int mode = lumpy_reclaim ? ISOLATE_BOTH : ISOLATE_INACTIVE;
>
> -               nr_taken = sc->isolate_pages(sc->swap_cluster_max,
> +               nr_taken = sc->isolate_pages(nr_to_scan,
>                             &page_list, &nr_scan, sc->order, mode,
>                                zone, sc->mem_cgroup, 0, file);
>                nr_active = clear_active_flags(&page_list, count);
> @@ -1093,7 +1095,6 @@ static unsigned long shrink_inactive_lis
>
>                spin_unlock_irq(&zone->lru_lock);
>
> -               nr_scanned += nr_scan;
>                nr_freed = shrink_page_list(&page_list, sc, PAGEOUT_IO_ASYNC);
>
>                /*
> @@ -1117,7 +1118,7 @@ static unsigned long shrink_inactive_lis
>                                                        PAGEOUT_IO_SYNC);
>                }
>
> -               nr_reclaimed += nr_freed;
> +               nr_reclaimed = nr_freed;

maybe, nr_freed can be removed perfectly. it have the same meaning as
nr_reclaimed.



>                local_irq_disable();
>                if (current_is_kswapd()) {
>                        __count_zone_vm_events(PGSCAN_KSWAPD, zone, nr_scan);
> @@ -1158,7 +1159,6 @@ static unsigned long shrink_inactive_lis
>                                spin_lock_irq(&zone->lru_lock);
>                        }
>                }
> -       } while (nr_scanned < max_scan);
>        spin_unlock(&zone->lru_lock);
>  done:
>        local_irq_enable();
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>

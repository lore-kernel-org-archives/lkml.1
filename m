Return-Path: <linux-kernel-owner+w=401wt.eu-S1751939AbZI3FOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbZI3FOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 01:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZI3FOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 01:14:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33500 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZI3FOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 01:14:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Larry Woodman <lwoodman@redhat.com>
Subject: Re: RFC [Patch] few useful page reclaim mm tracepoints
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <1254154166.3219.3.camel@dhcp-100-19-198.bos.redhat.com>
References: <1254154166.3219.3.camel@dhcp-100-19-198.bos.redhat.com>
Message-Id: <20090930134322.5EEC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Sep 2009 14:14:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> 
> Here a few mm page reclaim tracepoints that really show what is being
> reclaimed and from where.  mm_get_scanratio reports the number anonymous
> and pagecache pages as well as the percent that will be reclaimed from
> each.  mm_pagereclaim_shrinkactive reports whether it is shrinking
> anonymous or pagecache pages, the number scanned and the number actually
> moved(deactivated).  mm_pagereclaim_shrinkinactive reports whether it is
> shrinking anonymous or pagecache pages, the number scanned and the
> number actually reclaimed.  These three simple mm tracepoints capture
> much of the page reclaim activity.
> 
> ------------------------------------------------------------------------
> 
> # tracer: mm 
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>          kswapd1-549   [004]   149.524509: mm_get_scanratio: 2043329
> anonymous pages, reclaiming 1% - 1312 pagecache pages, reclaiming 99%
>          kswapd1-549   [004]   149.524709: mm_pagereclaim_shrinkactive:
> anonymous, scanned 32, moved 32, priority 12
>          kswapd1-549   [004]   149.524542:
> mm_pagereclaim_shrinkinactive: anonymous, scanned 32, reclaimed 32,
> priority 7

Looks good generally. and I have few comment.




> @@ -1168,6 +1170,8 @@ static unsigned long shrink_inactive_list(unsigned long max_scan,
>  done:
>  	local_irq_enable();
>  	pagevec_release(&pvec);
> +	trace_mm_pagereclaim_shrinkinactive(nr_scanned, nr_reclaimed,
> +						file, priority);
>  	return nr_reclaimed;
>  }

In shrink_inactive list, the pages will become 
 (1) moved to active list
 (2) moved to inactive list again
 (3) moved to unevictable list
 (4) freed

your tracepoint only watch freed pages.
maybe, other moving should be watched too. each moving indicate each different pressure.

Plus, I like more shorter tracepoint name personally.


>  
> @@ -1325,6 +1329,7 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
>  						LRU_BASE   + file * LRU_FILE);
>  
>  	spin_unlock_irq(&zone->lru_lock);
> +	trace_mm_pagereclaim_shrinkactive(pgscanned, pgmoved, file, priority);
>  }

pgmoved don't point meaningful data.
pgmoved mean how much pages isolate from active list. but it doesn't mean
how much pages move to inactive-list although we really need it.


>  static int inactive_anon_is_low_global(struct zone *zone)
> @@ -1491,6 +1496,7 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
>  	/* Normalize to percentages */
>  	percent[0] = 100 * ap / (ap + fp + 1);
>  	percent[1] = 100 - percent[0];
> +	trace_mm_get_scanratio(anon, file, percent[0], percent[1]);
>  }

Maybe bad place.
shrink_zone() have following code.

        if (!sc->may_swap || (nr_swap_pages <= 0)) {
                noswap = 1;
                percent[0] = 0;
                percent[1] = 100;
        } else
                get_scan_ratio(zone, sc, percent);

        (snip)

        for_each_evictable_lru(l) {
                int file = is_file_lru(l);
                unsigned long scan;

                scan = zone_nr_pages(zone, sc, l);
                if (priority || noswap) {
                        scan >>= priority;
                        scan = (scan * percent[file]) / 100;
                }

(1) shrink_zone() often don't call get_scan_ratio().
(2) for some reason, "scan" calculation igure percent[file].

Maybe we should log scan variable or nr[l] variable.




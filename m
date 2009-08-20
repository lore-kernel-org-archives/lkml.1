Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZHTMOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZHTMOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbZHTMOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:14:00 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:60583 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbZHTMN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fJ/ZKbtvQqI7b965MzQVX+KWYirHR7K8asIrHqu7u/JZl0LAUgwhQ0J+pdGCxIJaRl
         Z1p+zdPBaqIiilMl7UQDhNLO3+jKa9OQ9LyR/Y8U1PUEZyUHspWd9PW9uRaueDN1MyfM
         Bla0VBHBqndT8iOACApFLFurxMCu4TanojE+c=
MIME-Version: 1.0
In-Reply-To: <20090820114933.GB7359@localhost>
References: <20090820024929.GA19793@localhost>
	 <20090820121347.8a886e4b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090820040533.GA27540@localhost>
	 <28c262360908200401t41c03ad3n114b24e03b61de08@mail.gmail.com>
	 <20090820114933.GB7359@localhost>
Date: Thu, 20 Aug 2009 21:13:59 +0900
Message-ID: <28c262360908200513y3fee675do4e1f0204ffb8df63@mail.gmail.com>
Subject: Re: [PATCH -v2] mm: do batched scans for mem_cgroup
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 8:49 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> On Thu, Aug 20, 2009 at 07:01:21PM +0800, Minchan Kim wrote:
>> Hi, Wu.
>>
>> On Thu, Aug 20, 2009 at 1:05 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
>> > On Thu, Aug 20, 2009 at 11:13:47AM +0800, KAMEZAWA Hiroyuki wrote:
>> >> On Thu, 20 Aug 2009 10:49:29 +0800
>> >> Wu Fengguang <fengguang.wu@intel.com> wrote:
>> >>
>> >> > For mem_cgroup, shrink_zone() may call shrink_list() with nr_to_scan=1,
>> >> > in which case shrink_list() _still_ calls isolate_pages() with the much
>> >> > larger SWAP_CLUSTER_MAX.  It effectively scales up the inactive list
>> >> > scan rate by up to 32 times.
>> >> >
>> >> > For example, with 16k inactive pages and DEF_PRIORITY=12, (16k >> 12)=4.
>> >> > So when shrink_zone() expects to scan 4 pages in the active/inactive
>> >> > list, it will be scanned SWAP_CLUSTER_MAX=32 pages in effect.
>> >> >
>> >> > The accesses to nr_saved_scan are not lock protected and so not 100%
>> >> > accurate, however we can tolerate small errors and the resulted small
>> >> > imbalanced scan rates between zones.
>> >> >
>> >> > This batching won't blur up the cgroup limits, since it is driven by
>> >> > "pages reclaimed" rather than "pages scanned". When shrink_zone()
>> >> > decides to cancel (and save) one smallish scan, it may well be called
>> >> > again to accumulate up nr_saved_scan.
>> >> >
>> >> > It could possibly be a problem for some tiny mem_cgroup (which may be
>> >> > _full_ scanned too much times in order to accumulate up nr_saved_scan).
>> >> >
>> >> > CC: Rik van Riel <riel@redhat.com>
>> >> > CC: Minchan Kim <minchan.kim@gmail.com>
>> >> > CC: Balbir Singh <balbir@linux.vnet.ibm.com>
>> >> > CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> >> > CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
>> >> > ---
>> >>
>> >> Hmm, how about this ?
>> >> ==
>> >> Now, nr_saved_scan is tied to zone's LRU.
>> >> But, considering how vmscan works, it should be tied to reclaim_stat.
>> >>
>> >> By this, memcg can make use of nr_saved_scan information seamlessly.
>> >
>> > Good idea, full patch updated with your signed-off-by :)
>> >
>> > Thanks,
>> > Fengguang
>> > ---
>> > mm: do batched scans for mem_cgroup
>> >
>> > For mem_cgroup, shrink_zone() may call shrink_list() with nr_to_scan=1,
>> > in which case shrink_list() _still_ calls isolate_pages() with the much
>> > larger SWAP_CLUSTER_MAX.  It effectively scales up the inactive list
>> > scan rate by up to 32 times.
>>
>> Yes. It can scan 32 times pages in only inactive list, not active list.
>
> Yes and no ;)
>
> inactive anon list over scanned => inactive_anon_is_low() == TRUE
>                                => shrink_active_list()
>                                => active anon list over scanned

Why inactive anon list is overscanned in case mem_cgroup ?

in shrink_zone,
1) The vm doesn't accumulate nr[l].
2) Below routine store min value to nr_to_scan.
nr_to_scan = min(nr[l], swap_cluster_max);
ex) if nr[l] = 4, vm calls shrink_active_list with 4 as nr_to_scan.
So I think overscan doesn't occur in active list.

> So the end result may be
>
> - anon inactive  => over scanned
> - anon active    => over scanned (maybe not as much)
> - file inactive  => over scanned
> - file active    => under scanned (relatively)
>
>> > For example, with 16k inactive pages and DEF_PRIORITY=12, (16k >> 12)=4.
>> > So when shrink_zone() expects to scan 4 pages in the active/inactive
>> > list, it will be scanned SWAP_CLUSTER_MAX=32 pages in effect.
>>
>> Active list scan would be scanned in 4,  inactive list  is 32.
>
> Exactly.
>
>> >
>> > The accesses to nr_saved_scan are not lock protected and so not 100%
>> > accurate, however we can tolerate small errors and the resulted small
>> > imbalanced scan rates between zones.
>>
>> Yes.
>>
>> > This batching won't blur up the cgroup limits, since it is driven by
>> > "pages reclaimed" rather than "pages scanned". When shrink_zone()
>> > decides to cancel (and save) one smallish scan, it may well be called
>> > again to accumulate up nr_saved_scan.
>>
>> You mean nr_scan_try_batch logic ?
>> But that logic works for just global reclaim?
>> Now am I missing something?
>>
>> Could you elaborate more? :)
>
> Sorry for the confusion. The above paragraph originates from Balbir's
> concern:
>
>        This might be a concern (although not a big ATM), since we can't
>        afford to miss limits by much. If a cgroup is near its limit and we
>        drop scanning it. We'll have to work out what this means for the end

Why does mem_cgroup drops scanning ?
It's because nr_scan_try_batch? or something ?

Sorry. Still, I can't understand your point. :(

>        user. May be more fundamental look through is required at the priority
>        based logic of exposing how much to scan, I don't know.
>
> Thanks,
> Fengguang
>
>> > It could possibly be a problem for some tiny mem_cgroup (which may be
>> > _full_ scanned too much times in order to accumulate up nr_saved_scan).
>> >
>> > CC: Rik van Riel <riel@redhat.com>
>> > CC: Minchan Kim <minchan.kim@gmail.com>
>> > CC: Balbir Singh <balbir@linux.vnet.ibm.com>
>> > CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
>> > ---
>> >  include/linux/mmzone.h |    6 +++++-
>> >  mm/page_alloc.c        |    2 +-
>> >  mm/vmscan.c            |   20 +++++++++++---------
>> >  3 files changed, 17 insertions(+), 11 deletions(-)
>> >
>> > --- linux.orig/include/linux/mmzone.h   2009-07-30 10:45:15.000000000 +0800
>> > +++ linux/include/linux/mmzone.h        2009-08-20 11:51:08.000000000 +0800
>> > @@ -269,6 +269,11 @@ struct zone_reclaim_stat {
>> >         */
>> >        unsigned long           recent_rotated[2];
>> >        unsigned long           recent_scanned[2];
>> > +
>> > +       /*
>> > +        * accumulated for batching
>> > +        */
>> > +       unsigned long           nr_saved_scan[NR_LRU_LISTS];
>> >  };
>> >
>> >  struct zone {
>> > @@ -323,7 +328,6 @@ struct zone {
>> >        spinlock_t              lru_lock;
>> >        struct zone_lru {
>> >                struct list_head list;
>> > -               unsigned long nr_saved_scan;    /* accumulated for batching */
>> >        } lru[NR_LRU_LISTS];
>> >
>> >        struct zone_reclaim_stat reclaim_stat;
>> > --- linux.orig/mm/vmscan.c      2009-08-20 11:48:46.000000000 +0800
>> > +++ linux/mm/vmscan.c   2009-08-20 12:00:55.000000000 +0800
>> > @@ -1521,6 +1521,7 @@ static void shrink_zone(int priority, st
>> >        enum lru_list l;
>> >        unsigned long nr_reclaimed = sc->nr_reclaimed;
>> >        unsigned long swap_cluster_max = sc->swap_cluster_max;
>> > +       struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
>> >        int noswap = 0;
>> >
>> >        /* If we have no swap space, do not bother scanning anon pages. */
>> > @@ -1540,12 +1541,9 @@ static void shrink_zone(int priority, st
>> >                        scan >>= priority;
>> >                        scan = (scan * percent[file]) / 100;
>> >                }
>> > -               if (scanning_global_lru(sc))
>> > -                       nr[l] = nr_scan_try_batch(scan,
>> > -                                                 &zone->lru[l].nr_saved_scan,
>> > -                                                 swap_cluster_max);
>> > -               else
>> > -                       nr[l] = scan;
>> > +               nr[l] = nr_scan_try_batch(scan,
>> > +                                         &reclaim_stat->nr_saved_scan[l],
>> > +                                         swap_cluster_max);
>> >        }
>> >
>> >        while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
>> > @@ -2128,6 +2126,7 @@ static void shrink_all_zones(unsigned lo
>> >  {
>> >        struct zone *zone;
>> >        unsigned long nr_reclaimed = 0;
>> > +       struct zone_reclaim_stat *reclaim_stat;
>> >
>> >        for_each_populated_zone(zone) {
>> >                enum lru_list l;
>> > @@ -2144,11 +2143,14 @@ static void shrink_all_zones(unsigned lo
>> >                                                l == LRU_ACTIVE_FILE))
>> >                                continue;
>> >
>> > -                       zone->lru[l].nr_saved_scan += (lru_pages >> prio) + 1;
>> > -                       if (zone->lru[l].nr_saved_scan >= nr_pages || pass > 3) {
>> > +                       reclaim_stat = get_reclaim_stat(zone, sc);
>> > +                       reclaim_stat->nr_saved_scan[l] +=
>> > +                                               (lru_pages >> prio) + 1;
>> > +                       if (reclaim_stat->nr_saved_scan[l]
>> > +                                               >= nr_pages || pass > 3) {
>> >                                unsigned long nr_to_scan;
>> >
>> > -                               zone->lru[l].nr_saved_scan = 0;
>> > +                               reclaim_stat->nr_saved_scan[l] = 0;
>> >                                nr_to_scan = min(nr_pages, lru_pages);
>> >                                nr_reclaimed += shrink_list(l, nr_to_scan, zone,
>> >                                                                sc, prio);
>> > --- linux.orig/mm/page_alloc.c  2009-08-20 11:57:54.000000000 +0800
>> > +++ linux/mm/page_alloc.c       2009-08-20 11:58:39.000000000 +0800
>> > @@ -3716,7 +3716,7 @@ static void __paginginit free_area_init_
>> >                zone_pcp_init(zone);
>> >                for_each_lru(l) {
>> >                        INIT_LIST_HEAD(&zone->lru[l].list);
>> > -                       zone->lru[l].nr_saved_scan = 0;
>> > +                       zone->reclaim_stat.nr_saved_scan[l] = 0;
>> >                }
>> >                zone->reclaim_stat.recent_rotated[0] = 0;
>> >                zone->reclaim_stat.recent_rotated[1] = 0;
>> >
>> > --
>> > To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> > the body to majordomo@kvack.org.  For more info on Linux MM,
>> > see: http://www.linux-mm.org/ .
>> > Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>> >
>>
>>
>>
>> --
>> Kind regards,
>> Minchan Kim
>



-- 
Kind regards,
Minchan Kim

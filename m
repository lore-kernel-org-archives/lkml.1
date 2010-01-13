Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940Ab0AMKb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab0AMKb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903Ab0AMKbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:31:55 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:49162 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab0AMKbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:31:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pCQhHFwvRIe7Bk4+sEEFuQwoRW3MP8qKD1JIvlzulAIUp29srBkgWYm49HS0s4bxTH
         eb1UqMUBM0uBhw4j3E4ausOUmQNdgoGKq6FJoLb3ZmyRlgU+NrC9OWbqKG0fd57l0PdY
         SnOVZNubr4xtPmCu6cpnVhG5D03n8JXa35cj0=
MIME-Version: 1.0
In-Reply-To: <20100113171953.B3E5.A69D9226@jp.fujitsu.com>
References: <20100113171734.B3E2.A69D9226@jp.fujitsu.com>
	 <20100113171953.B3E5.A69D9226@jp.fujitsu.com>
Date: Wed, 13 Jan 2010 19:31:52 +0900
Message-ID: <28c262361001130231k29b933der4022f4d1da80b084@mail.gmail.com>
Subject: Re: [PATCH 2/3][v2] vmstat: add anon_scan_ratio field to zoneinfo
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kosaki.

On Wed, Jan 13, 2010 at 5:21 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Changelog
>  from v1
>  - get_anon_scan_ratio don't tak zone->lru_lock anymore
>   because zoneinfo_show_print takes zone->lock.

When I saw this changelog first, I got confused.
That's because there is no relation between lru_lock and lock in zone.
You mean zoneinfo is allowed to have a stale data?
Tend to agree with it.

>
>
> ======================================
> Vmscan folks was asked "why does my system makes so much swap-out?"
> in lkml at several times.
> At that time, I made the debug patch to show recent_anon_{scanned/rorated}
> parameter at least three times.
>
> Thus, its parameter should be showed on /proc/zoneinfo. It help
> vmscan folks debugging.

I support this suggestion.

>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/swap.h |    2 ++
>  mm/vmscan.c          |   50 ++++++++++++++++++++++++++++++++++++--------------
>  mm/vmstat.c          |    7 +++++--
>  3 files changed, 43 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index a2602a8..e95d7ed 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -280,6 +280,8 @@ extern void scan_unevictable_unregister_node(struct node *node);
>  extern int kswapd_run(int nid);
>  extern void kswapd_stop(int nid);
>
> +unsigned long get_anon_scan_ratio(struct zone *zone, struct mem_cgroup *memcg, int swappiness);

Today Andrew said  to me. :)
"The vmscan.c code makes an effort to look nice in an 80-col display."

> +
>  #ifdef CONFIG_MMU
>  /* linux/mm/shmem.c */
>  extern int shmem_unuse(swp_entry_t entry, struct page *page);
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 640486b..0900931 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1493,8 +1493,8 @@ static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
>  * percent[0] specifies how much pressure to put on ram/swap backed
>  * memory, while percent[1] determines pressure on the file LRUs.
>  */
> -static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
> -                                       unsigned long *percent)
> +static void __get_scan_ratio(struct zone *zone, struct scan_control *sc,
> +                            int need_update, unsigned long *percent)
>  {
>        unsigned long anon, file, free;
>        unsigned long anon_prio, file_prio;
> @@ -1535,18 +1535,19 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
>         *
>         * anon in [0], file in [1]
>         */
> -       if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
> -               spin_lock_irq(&zone->lru_lock);
> -               reclaim_stat->recent_scanned[0] /= 2;
> -               reclaim_stat->recent_rotated[0] /= 2;
> -               spin_unlock_irq(&zone->lru_lock);
> -       }
> -
> -       if (unlikely(reclaim_stat->recent_scanned[1] > file / 4)) {
> -               spin_lock_irq(&zone->lru_lock);
> -               reclaim_stat->recent_scanned[1] /= 2;
> -               reclaim_stat->recent_rotated[1] /= 2;
> -               spin_unlock_irq(&zone->lru_lock);

Why do you add new parameter 'need_update'?
Do you see any lru_lock heavy contention? (reclaim VS cat /proc/zoneinfo)
I think maybe not.
I am not sure no locking version is needed.

> +       if (need_update) {
> +               if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
> +                       spin_lock_irq(&zone->lru_lock);
> +                       reclaim_stat->recent_scanned[0] /= 2;
> +                       reclaim_stat->recent_rotated[0] /= 2;
> +                       spin_unlock_irq(&zone->lru_lock);
> +               }
> +               if (unlikely(reclaim_stat->recent_scanned[1] > file / 4)) {
> +                       spin_lock_irq(&zone->lru_lock);
> +                       reclaim_stat->recent_scanned[1] /= 2;
> +                       reclaim_stat->recent_rotated[1] /= 2;
> +                       spin_unlock_irq(&zone->lru_lock);
> +               }
>        }
>
>        /*
> @@ -1572,6 +1573,27 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
>        percent[1] = 100 - percent[0];
>  }
>
> +static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
> +                          unsigned long *percent)
> +{
> +       __get_scan_ratio(zone, sc, 1, percent);
> +}
> +

If we really need this version and your changelog is right,
Let's add 'note'.  ;-)

/* Caller have to hold zone->lock */
> +unsigned long get_anon_scan_ratio(struct zone *zone, struct mem_cgroup *memcg, int swappiness)
> +{
> +       unsigned long percent[2];
> +       struct scan_control sc = {
> +               .may_swap = 1,
> +               .swappiness = swappiness,
> +               .mem_cgroup = memcg,
> +       };
> +
> +       __get_scan_ratio(zone, &sc, 0, percent);
> +
> +       return percent[0];
> +}
> +
> +
>  /*
>  * Smallish @nr_to_scan's are deposited in @nr_saved_scan,
>  * until we collected @swap_cluster_max pages to scan.
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 6051fba..f690117 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -15,6 +15,7 @@
>  #include <linux/cpu.h>
>  #include <linux/vmstat.h>
>  #include <linux/sched.h>
> +#include <linux/swap.h>
>
>  #ifdef CONFIG_VM_EVENT_COUNTERS
>  DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
> @@ -760,11 +761,13 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
>                   "\n  all_unreclaimable: %u"
>                   "\n  prev_priority:     %i"
>                   "\n  start_pfn:         %lu"
> -                  "\n  inactive_ratio:    %u",
> +                  "\n  inactive_ratio:    %u"
> +                  "\n  anon_scan_ratio:   %lu",
>                           zone_is_all_unreclaimable(zone),
>                   zone->prev_priority,
>                   zone->zone_start_pfn,
> -                  zone->inactive_ratio);
> +                  zone->inactive_ratio,
> +                  get_anon_scan_ratio(zone, NULL, vm_swappiness));
>        seq_putc(m, '\n');
>  }
>
> --
> 1.6.5.2
>
>
>
>



-- 
Kind regards,
Minchan Kim

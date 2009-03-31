Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbZCaB0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbZCaB0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 21:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZCaB0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 21:26:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:10679 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbZCaB0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 21:26:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o/JIpyPEBmMKUwIycqPEVrqESHZ799A7ePBlMeZXv0NHEv3mjLiEpdM3CW1XmA8xs7
         KIyyoyuSIiy6Cjsl86azJRUXPfQirl8skImyEYUOlXZ7yWo8S8PlrQOXI27HjC6Y2TRw
         nJkmTdMJQagh2eWos+Jdmeljxk/jxJeLyZCyg=
MIME-Version: 1.0
In-Reply-To: <20090328214636.68FF.A69D9226@jp.fujitsu.com>
References: <20090327151926.f252fba7.nishimura@mxp.nes.nec.co.jp>
	 <20090327153035.35498303.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090328214636.68FF.A69D9226@jp.fujitsu.com>
Date: Tue, 31 Mar 2009 10:26:17 +0900
Message-ID: <28c262360903301826w6429720es8ceb361cfc088b1@mail.gmail.com>
Subject: Re: [PATCH] vmscan: memcg needs may_swap (Re: [patch] vmscan: rename 
	sc.may_swap to may_unmap)
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       Balbir Singh <balbir@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,




On Mon, Mar 30, 2009 at 8:45 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Fri, 27 Mar 2009 15:19:26 +0900
>> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
>>
>> > Added
>> >  Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >  Cc: Balbir Singh <balbir@in.ibm.com>
>> >
>> > I'm sorry for replying to a very old mail.
>> >
>> > > @@ -1713,7 +1713,7 @@ unsigned long try_to_free_mem_cgroup_pag
>> > >  {
>> > >   struct scan_control sc = {
>> > >           .may_writepage = !laptop_mode,
>> > > -         .may_swap = 1,
>> > > +         .may_unmap = 1,
>> > >           .swap_cluster_max = SWAP_CLUSTER_MAX,
>> > >           .swappiness = swappiness,
>> > >           .order = 0,
>> > > @@ -1723,7 +1723,7 @@ unsigned long try_to_free_mem_cgroup_pag
>> > >   struct zonelist *zonelist;
>> > >
>> > >   if (noswap)
>> > > -         sc.may_swap = 0;
>> > > +         sc.may_unmap = 0;
>> > >
>> > >   sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
>> > >                   (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
>> > IIUC, memcg had used may_swap as a flag for "we need to use swap?" as the name indicate.
>> >
>> > Because, when mem+swap hits the limit, trying to swapout pages is meaningless
>> > as it doesn't change mem+swap usage.
>> >
>> Good catch...sigh, I missed this disussion.
>>
>>
>>
>> > What do you think of this patch?
>> > ===
>> > From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>> >
>> > vmscan-rename-scmay_swap-to-may_unmap.patch removed may_swap flag,
>> > but memcg had used it as a flag for "we need to use swap?", as the
>> > name indicate.
>> >
>> > And in current implementation, memcg cannot reclaim mapped file caches
>> > when mem+swap hits the limit.
>> >
>> When mem+swap hits the limit, swap-out anonymous page doesn't reduce the
>> amount of usage of mem+swap, so, swap-out should be avoided.
>>
>> > re-introduce may_swap flag and handle it at shrink_page_list.
>> >
>> > This patch doesn't influence any scan_control users other than memcg.
>> >
>>
>>
>> > Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>>
>> Seems good,
>> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> But hum....Maybe this lru scan work in the same way as the case
>> of !total_swap_pages. (means don't scan anon LRU.)
>> revisit this later.
>
> Well, How about following patch?
>
> So, I have to agree my judgement of may_unmap was wrong.
> You explain memcg can use may_swap instead may_unmap. and I think
> other may_unmap user (zone_reclaim and shrink_all_list) can convert
> may_unmap code to may_swap.
>
> IOW, Nishimura-san, you explain we can remove the branch of the may_unmap
> from shrink_page_list().
> it's really good job. thanks!
>
>
> ========
> Subject: vmswan: reintroduce sc->may_swap
>
> vmscan-rename-scmay_swap-to-may_unmap.patch removed may_swap flag,
> but memcg had used it as a flag for "we need to use swap?", as the
> name indicate.
>
> And in current implementation, memcg cannot reclaim mapped file caches
> when mem+swap hits the limit.
>
> re-introduce may_swap flag and handle it at get_scan_ratio().
> This patch doesn't influence any scan_control users other than memcg.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> --
>  mm/vmscan.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3be6157..00ea4a1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -63,6 +63,9 @@ struct scan_control {
>        /* Can mapped pages be reclaimed? */
>        int may_unmap;
>
> +       /* Can pages be swapped as part of reclaim? */
> +       int may_swap;
> +

Sorry for too late response.
I don't know memcg well.

The memcg managed to use may_swap well with global page reclaim until now.
I think that was because may_swap can represent both meaning.
Do we need each variables really ?

How about using union variable ?
---

struct scan_control {
  /* Incremented by the number of inactive pages that were scanned */
  unsigned long nr_scanned;
...
   union {
    int may_swap; /* memcg: Cap pages be swapped as part of reclaim? */
    int may_unmap /* global: Can mapped pages be reclaimed? */
  };



>        /* This context's SWAP_CLUSTER_MAX. If freeing memory for
>         * suspend, we effectively ignore SWAP_CLUSTER_MAX.
>         * In this context, it doesn't matter that we scan the
> @@ -1379,7 +1382,7 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
>        struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
>
>        /* If we have no swap space, do not bother scanning anon pages. */
> -       if (nr_swap_pages <= 0) {
> +       if (!sc->may_swap || (nr_swap_pages <= 0)) {
>                percent[0] = 0;
>                percent[1] = 100;
>                return;
> @@ -1695,6 +1698,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>                .may_writepage = !laptop_mode,
>                .swap_cluster_max = SWAP_CLUSTER_MAX,
>                .may_unmap = 1,
> +               .may_swap = 1,
>                .swappiness = vm_swappiness,
>                .order = order,
>                .mem_cgroup = NULL,
> @@ -1714,6 +1718,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
>        struct scan_control sc = {
>                .may_writepage = !laptop_mode,
>                .may_unmap = 1,
> +               .may_swap = 1,
>                .swap_cluster_max = SWAP_CLUSTER_MAX,
>                .swappiness = swappiness,
>                .order = 0,
> @@ -1723,7 +1728,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
>        struct zonelist *zonelist;
>
>        if (noswap)
> -               sc.may_unmap = 0;
> +               sc.may_swap = 0;
>
>        sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
>                        (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
> @@ -1763,6 +1768,7 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
>        struct scan_control sc = {
>                .gfp_mask = GFP_KERNEL,
>                .may_unmap = 1,
> +               .may_swap = 1,
>                .swap_cluster_max = SWAP_CLUSTER_MAX,
>                .swappiness = vm_swappiness,
>                .order = order,
> @@ -2109,6 +2115,7 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
>        struct scan_control sc = {
>                .gfp_mask = GFP_KERNEL,
>                .may_unmap = 0,
> +               .may_swap = 1,
>                .swap_cluster_max = nr_pages,
>                .may_writepage = 1,
>                .isolate_pages = isolate_pages_global,
> @@ -2289,6 +2296,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>        struct scan_control sc = {
>                .may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
>                .may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
> +               .may_swap = 1,
>                .swap_cluster_max = max_t(unsigned long, nr_pages,
>                                        SWAP_CLUSTER_MAX),
>                .gfp_mask = gfp_mask,
>
>
>
>
>



-- 
Kinds regards,
Minchan Kim

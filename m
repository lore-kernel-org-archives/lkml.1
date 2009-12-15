Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbZLOAfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbZLOAfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbZLOAfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:35:47 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50079 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZLOAfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:35:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 6/8] Stop reclaim quickly when the task reclaimed enough lots pages
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       lwoodman@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091215091107.219644fe.minchan.kim@barrios-desktop>
References: <20091214213103.BBC0.A69D9226@jp.fujitsu.com> <20091215091107.219644fe.minchan.kim@barrios-desktop>
Message-Id: <20091215092654.CDB3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 15 Dec 2009 09:35:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 14 Dec 2009 21:31:36 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > 
> > From latency view, There isn't any reason shrink_zones() continue to
> > reclaim another zone's page if the task reclaimed enough lots pages.
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  mm/vmscan.c |   16 ++++++++++++----
> >  1 files changed, 12 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 0880668..bf229d3 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1654,7 +1654,7 @@ static void shrink_zone_end(struct zone *zone, struct scan_control *sc)
> >  /*
> >   * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
> >   */
> > -static void shrink_zone(int priority, struct zone *zone,
> > +static int shrink_zone(int priority, struct zone *zone,
> >  			struct scan_control *sc)
> >  {
> >  	unsigned long nr[NR_LRU_LISTS];
> > @@ -1669,7 +1669,7 @@ static void shrink_zone(int priority, struct zone *zone,
> >  
> >  	ret = shrink_zone_begin(zone, sc);
> >  	if (ret)
> > -		return;
> > +		return ret;
> >  
> >  	/* If we have no swap space, do not bother scanning anon pages. */
> >  	if (!sc->may_swap || (nr_swap_pages <= 0)) {
> > @@ -1692,6 +1692,7 @@ static void shrink_zone(int priority, struct zone *zone,
> >  					  &reclaim_stat->nr_saved_scan[l]);
> >  	}
> >  
> > +	ret = 0;
> >  	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
> >  					nr[LRU_INACTIVE_FILE]) {
> >  		for_each_evictable_lru(l) {
> > @@ -1712,8 +1713,10 @@ static void shrink_zone(int priority, struct zone *zone,
> >  		 * with multiple processes reclaiming pages, the total
> >  		 * freeing target can get unreasonably large.
> >  		 */
> > -		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
> > +		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY) {
> > +			ret = -ERESTARTSYS;
> 
> Just nitpick. 
> 
> shrink_zone's return value is matter?
> shrink_zones never handle that. 

shrink_zones() stop vmscan quickly if ret isn't !0.
if we already scanned rather than nr_to_reclaim, we can stop vmscan.


> As a matter of fact, I am worried about this patch. 
> 
> My opinion is we put aside this patch until we can solve Larry's problem.
> We could apply this patch in future.
> 
> I don't want to see the side effect while we focus Larry's problem.
> But If you mind my suggestion, I also will not bother you by this nitpick.
> 
> Thanks for great cleanup and improving VM, Kosaki. :)

I agree with Larry's issue is highest priority.




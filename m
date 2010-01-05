Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305Ab0AECFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab0AECFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347Ab0AECFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:05:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39169 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab0AECFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:05:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/4] vmstat: remove zone->lock from walk_zones_in_node
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100103185957.GB11420@csn.ul.ie>
References: <20091228164451.A687.A69D9226@jp.fujitsu.com> <20100103185957.GB11420@csn.ul.ie>
Message-Id: <20100105105328.96CE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  5 Jan 2010 11:04:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Mon, Dec 28, 2009 at 04:47:22PM +0900, KOSAKI Motohiro wrote:
> > The zone->lock is one of performance critical locks. Then, it shouldn't
> > be hold for long time. Currently, we have four walk_zones_in_node()
> > usage and almost use-case don't need to hold zone->lock.
> > 
> > Thus, this patch move locking responsibility from walk_zones_in_node
> > to its sub function. Also this patch kill unnecessary zone->lock taking.
> > 
> > Cc: Mel Gorman <mel@csn.ul.ie>
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  mm/vmstat.c |    8 +++++---
> >  1 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/vmstat.c b/mm/vmstat.c
> > index 6051fba..a5d45bc 100644
> > --- a/mm/vmstat.c
> > +++ b/mm/vmstat.c
> > @@ -418,15 +418,12 @@ static void walk_zones_in_node(struct seq_file *m, pg_data_t *pgdat,
> >  {
> >  	struct zone *zone;
> >  	struct zone *node_zones = pgdat->node_zones;
> > -	unsigned long flags;
> >  
> >  	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
> >  		if (!populated_zone(zone))
> >  			continue;
> >  
> > -		spin_lock_irqsave(&zone->lock, flags);
> >  		print(m, pgdat, zone);
> > -		spin_unlock_irqrestore(&zone->lock, flags);
> >  	}
> >  }
> >  
> > @@ -455,6 +452,7 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
> >  					pg_data_t *pgdat, struct zone *zone)
> >  {
> >  	int order, mtype;
> > +	unsigned long flags;
> >  
> >  	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
> >  		seq_printf(m, "Node %4d, zone %8s, type %12s ",
> > @@ -468,8 +466,11 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
> >  
> >  			area = &(zone->free_area[order]);
> >  
> > +			spin_lock_irqsave(&zone->lock, flags);
> >  			list_for_each(curr, &area->free_list[mtype])
> >  				freecount++;
> > +			spin_unlock_irqrestore(&zone->lock, flags);
> > +
> 
> It's not clear why you feel this information requires the lock and the
> others do not.

I think above list operation require lock to prevent NULL pointer access. but other parts
doesn't protect anything, because memory-hotplug change them without zone lock.


> For the most part, I agree that the accuracy of the information is
> not critical. Assuming partial writes of the data are not a problem,
> the information is not going to go so badly out of sync that it would be
> noticable, even if the information is out of date within the zone.
> 
> However, inconsistent reads in zoneinfo really could be a problem. I am
> concerned that under heavy allocation load that that "pages free" would
> not match "nr_pages_free" for example. Other examples that adding all the
> counters together may or may not equal the total number of pages in the zone.
> 
> Lets say for example there was a subtle bug related to __inc_zone_page_state()
> that meant that counters were getting slightly out of sync but it was very
> marginal and/or difficult to reproduce. With this patch applied, we could
> not be absolutly sure the counters were correct because it could always have
> raced with someone holding the zone->lock.
> 
> Minimally, I think zoneinfo should be taking the zone lock.

Thanks lots comments. 
hmm.. I'd like to clarily your point. My point is memory-hotplug don't take zone lock,
then zone lock doesn't protect anything. so we have two option

1) Add zone lock to memroy-hotplug
2) Remove zone lock from zoneinfo

I thought (2) is sufficient. Do you mean you prefer to (1)? Or you prefer to ignore rarely event
(of cource, memory hotplug is rarely)?


> Secondly, has increased zone->lock contention due to reading /proc
> really been shown to be a problem? The only situation that I can think
> of is a badly-written monitor program that is copying all of /proc
> instead of the files of interest. If a monitor program is doing
> something like that, it's likely to be incurring performance problems in
> a large number of different areas. If that is not the trigger case, what
> is?

Ah no. I haven't observe such issue. my point is removing meaningless lock.


> >  			seq_printf(m, "%6lu ", freecount);
> >  		}
> >  		seq_putc(m, '\n');
> > @@ -709,6 +710,7 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
> >  							struct zone *zone)
> >  {
> >  	int i;
> > +
> 
> Unnecessary whitespace change.

Ug. thanks, it's my fault.




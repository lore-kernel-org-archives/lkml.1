Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbZFIIpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbZFIIpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbZFIIpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:45:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37277 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbZFIIpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:45:04 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/3] Reintroduce zone_reclaim_interval for when zone_reclaim() scans and fails to avoid CPU spinning at 100% on NUMA
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090609081821.GE18380@csn.ul.ie>
References: <20090609143211.DD64.A69D9226@jp.fujitsu.com> <20090609081821.GE18380@csn.ul.ie>
Message-Id: <20090609173011.DD7F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Jun 2009 17:45:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > > @@ -1192,6 +1192,15 @@ static struct ctl_table vm_table[] = {
> > >  		.extra1		= &zero,
> > >  	},
> > >  	{
> > > +		.ctl_name       = CTL_UNNUMBERED,
> > > +		.procname       = "zone_reclaim_interval",
> > > +		.data           = &zone_reclaim_interval,
> > > +		.maxlen         = sizeof(zone_reclaim_interval),
> > > +		.mode           = 0644,
> > > +		.proc_handler   = &proc_dointvec_jiffies,
> > > +		.strategy       = &sysctl_jiffies,
> > > +	},
> > 
> > hmmm, I think nobody can know proper interval settings on his own systems.
> > I agree with Wu. It can be hidden.
> > 
> 
> For the few users that case, I expect the majority of those will choose
> either 0 or the default value of 30. They might want to alter this while
> setting zone_reclaim_mode if they don't understand the different values
> it can have for example.
> 
> My preference would be that this not exist at all but the
> scan-avoidance-heuristic has to be perfect to allow that.

Ah, I didn't concern interval==0. thanks.
I can ack this now, but please add documentation about interval==0 meaning?




> > > @@ -2414,6 +2426,16 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
> > >  	ret = __zone_reclaim(zone, gfp_mask, order);
> > >  	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
> > >  
> > > +	if (!ret) {
> > > +		/*
> > > +		 * We were unable to reclaim enough pages to stay on node and
> > > +		 * unable to detect in advance that the scan would fail. Allow
> > > +		 * off node accesses for zone_reclaim_inteval jiffies before
> > > +		 * trying zone_reclaim() again
> > > +		 */
> > > +		zone->zone_reclaim_failure = jiffies;
> > 
> > Oops, this simple assignment don't care jiffies round-trip.
> > 
> 
> Here it is just recording the jiffies value. The real smarts with the counter
> use time_before() which I assumed could handle jiffie wrap-arounds. Even
> if it doesn't, the consequence is that one scan will occur that could have
> been avoided around the time of the jiffie wraparound. The value will then
> be reset and it will be fine.

time_before() assume two argument are enough nearly time.
if we use 32bit cpu and HZ=1000, about jiffies wraparound about one month.

Then, 

1. zone reclaim failure occur
2. system works fine for one month
3. jiffies wrap and time_before() makes mis-calculation.

I think.




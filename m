Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbZHTFRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbZHTFRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 01:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZHTFRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 01:17:04 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:60187 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZHTFRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 01:17:02 -0400
Date: Thu, 20 Aug 2009 10:46:56 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH -v2] mm: do batched scans for mem_cgroup
Message-ID: <20090820051656.GB26265@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090820024929.GA19793@localhost> <20090820121347.8a886e4b.kamezawa.hiroyu@jp.fujitsu.com> <20090820040533.GA27540@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090820040533.GA27540@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Wu Fengguang <fengguang.wu@intel.com> [2009-08-20 12:05:33]:

> On Thu, Aug 20, 2009 at 11:13:47AM +0800, KAMEZAWA Hiroyuki wrote:
> > On Thu, 20 Aug 2009 10:49:29 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > For mem_cgroup, shrink_zone() may call shrink_list() with nr_to_scan=1,
> > > in which case shrink_list() _still_ calls isolate_pages() with the much
> > > larger SWAP_CLUSTER_MAX.  It effectively scales up the inactive list
> > > scan rate by up to 32 times.
> > > 
> > > For example, with 16k inactive pages and DEF_PRIORITY=12, (16k >> 12)=4.
> > > So when shrink_zone() expects to scan 4 pages in the active/inactive
> > > list, it will be scanned SWAP_CLUSTER_MAX=32 pages in effect.
> > > 
> > > The accesses to nr_saved_scan are not lock protected and so not 100%
> > > accurate, however we can tolerate small errors and the resulted small
> > > imbalanced scan rates between zones.
> > > 
> > > This batching won't blur up the cgroup limits, since it is driven by
> > > "pages reclaimed" rather than "pages scanned". When shrink_zone()
> > > decides to cancel (and save) one smallish scan, it may well be called
> > > again to accumulate up nr_saved_scan.
> > > 
> > > It could possibly be a problem for some tiny mem_cgroup (which may be
> > > _full_ scanned too much times in order to accumulate up nr_saved_scan).
> > > 
> > > CC: Rik van Riel <riel@redhat.com>
> > > CC: Minchan Kim <minchan.kim@gmail.com>
> > > CC: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > ---
> > 
> > Hmm, how about this ? 
> > ==
> > Now, nr_saved_scan is tied to zone's LRU.
> > But, considering how vmscan works, it should be tied to reclaim_stat.
> > 
> > By this, memcg can make use of nr_saved_scan information seamlessly.
> 
> Good idea, full patch updated with your signed-off-by :)
> 
> Thanks,
> Fengguang
> ---
> mm: do batched scans for mem_cgroup
> 
> For mem_cgroup, shrink_zone() may call shrink_list() with nr_to_scan=1,
> in which case shrink_list() _still_ calls isolate_pages() with the much
> larger SWAP_CLUSTER_MAX.  It effectively scales up the inactive list
> scan rate by up to 32 times.
> 
> For example, with 16k inactive pages and DEF_PRIORITY=12, (16k >> 12)=4.
> So when shrink_zone() expects to scan 4 pages in the active/inactive
> list, it will be scanned SWAP_CLUSTER_MAX=32 pages in effect.
> 
> The accesses to nr_saved_scan are not lock protected and so not 100%
> accurate, however we can tolerate small errors and the resulted small
> imbalanced scan rates between zones.
> 
> This batching won't blur up the cgroup limits, since it is driven by
> "pages reclaimed" rather than "pages scanned". When shrink_zone()
> decides to cancel (and save) one smallish scan, it may well be called
> again to accumulate up nr_saved_scan.
> 
> It could possibly be a problem for some tiny mem_cgroup (which may be
> _full_ scanned too much times in order to accumulate up nr_saved_scan).
>

Looks good to me, how did you test it?

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
 
-- 
	Balbir

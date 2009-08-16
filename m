Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZHPFl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZHPFl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 01:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZHPFl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 01:41:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:38055 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbZHPFl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 01:41:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,389,1246863600"; 
   d="scan'208";a="176245453"
Date: Sun, 16 Aug 2009 13:41:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Avi Kivity <avi@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090816054107.GA15320@localhost>
References: <4A843B72.6030204@redhat.com> <4A843EAE.6070200@redhat.com> <4A846581.2020304@redhat.com> <20090813211626.GA28274@cmpxchg.org> <4A850F4A.9020507@redhat.com> <20090814091055.GA29338@cmpxchg.org> <20090814095106.GA3345@localhost> <4A856467.6050102@redhat.com> <20090815054524.GB11387@localhost> <20090816050902.GR5087@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090816050902.GR5087@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 01:09:03PM +0800, Balbir Singh wrote:
> * Wu Fengguang <fengguang.wu@intel.com> [2009-08-15 13:45:24]:
> 
> > On Fri, Aug 14, 2009 at 09:19:35PM +0800, Rik van Riel wrote:
> > > Wu Fengguang wrote:
> > > > On Fri, Aug 14, 2009 at 05:10:55PM +0800, Johannes Weiner wrote:
> > > 
> > > >> So even with the active list being a FIFO, we keep usage information
> > > >> gathered from the inactive list.  If we deactivate pages in arbitrary
> > > >> list intervals, we throw this away.
> > > > 
> > > > We do have the danger of FIFO, if inactive list is small enough, so
> > > > that (unconditionally) deactivated pages quickly get reclaimed and
> > > > their life window in inactive list is too small to be useful.
> > > 
> > > This one of the reasons why we unconditionally deactivate
> > > the active anon pages, and do background scanning of the
> > > active anon list when reclaiming page cache pages.
> > > 
> > > We want to always move some pages to the inactive anon
> > > list, so it does not get too small.
> > 
> > Right, the current code tries to pull inactive list out of
> > smallish-size state as long as there are vmscan activities.
> > 
> > However there is a possible (and tricky) hole: mem cgroups
> > don't do batched vmscan. shrink_zone() may call shrink_list()
> > with nr_to_scan=1, in which case shrink_list() _still_ calls
> > isolate_pages() with the much larger SWAP_CLUSTER_MAX.
> > 
> > It effectively scales up the inactive list scan rate by 10 times when
> > it is still small, and may thus prevent it from growing up for ever.
> > 
> 
> I think we need to possibly export some scanning data under DEBUG_VM
> to cross verify.

Maybe we can do more general debugging code, but here is a quick patch
for examining the cgroup case. Note that even for the global zones,
max_scan may well not be the multiple of SWAP_CLUSTER_MAX, thus
shrink_inactive_list() will scan a little more in its last loop.

---
 mm/vmscan.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- linux.orig/mm/vmscan.c	2009-08-16 13:24:25.000000000 +0800
+++ linux/mm/vmscan.c	2009-08-16 13:38:32.000000000 +0800
@@ -1043,6 +1043,13 @@ static unsigned long shrink_inactive_lis
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	int lumpy_reclaim = 0;
 
+	if (!scanning_global_lru(sc))
+		printk("shrink inactive %s count=%lu scan=%lu\n",
+		       file ? "file" : "anon",
+		       mem_cgroup_zone_nr_pages(sc->mem_cgroup, zone,
+						LRU_INACTIVE_ANON + !!file),
+		       max_scan);
+
 	/*
 	 * If we need a large contiguous chunk of memory, or have
 	 * trouble getting a small set of contiguous pages, we

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbZHPFvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbZHPFvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 01:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZHPFvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 01:51:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:29468 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbZHPFvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 01:51:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,389,1246863600"; 
   d="scan'208";a="176246409"
Date: Sun, 16 Aug 2009 13:50:46 +0800
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
Message-ID: <20090816055046.GB15320@localhost>
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
> > @@ -1541,11 +1542,11 @@ static void shrink_zone(int priority, st
> >  			scan = (scan * percent[file]) / 100;
> >  		}
> >  		if (scanning_global_lru(sc))
> > -			nr[l] = nr_scan_try_batch(scan,
> > -						  &zone->lru[l].nr_saved_scan,
> > -						  swap_cluster_max);
> > +			saved_scan = &zone->lru[l].nr_saved_scan;
> >  		else
> > -			nr[l] = scan;
> > +			saved_scan = mem_cgroup_get_saved_scan(sc->mem_cgroup,
> > +							       zone, l);
> > +		nr[l] = nr_scan_try_batch(scan, saved_scan, swap_cluster_max);
> >  	}
> >
> 
> This might be a concern (although not a big ATM), since we can't
> afford to miss limits by much. If a cgroup is near its limit and we
> drop scanning it. We'll have to work out what this means for the end
> user. May be more fundamental look through is required at the priority
> based logic of exposing how much to scan, I don't know.

I also had this worry at first. Then dismissed it because the page
reclaim should be driven by "pages reclaimed" rather than "pages
scanned". So when shrink_zone() decides to cancel one smallish scan,
it may well be called again and accumulate up nr_saved_scan.

So it should only be a problem for a very small mem_cgroup (which may
be _full_ scanned too much times in order to accumulate up nr_saved_scan).

Thanks,
Fengguang

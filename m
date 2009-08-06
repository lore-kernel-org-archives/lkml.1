Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbZHFNGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbZHFNGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZHFNGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:06:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:20076 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbZHFNGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:06:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,333,1246863600"; 
   d="scan'208";a="172992097"
Date: Thu, 6 Aug 2009 21:06:31 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090806130631.GB6162@localhost>
References: <20090805024058.GA8886@localhost> <20090805155805.GC23385@random.random> <20090806100824.GO23385@random.random> <4A7AAE07.1010202@redhat.com> <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost> <4A7AC201.4010202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7AC201.4010202@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 07:44:01PM +0800, Avi Kivity wrote:
> On 08/06/2009 01:59 PM, Wu Fengguang wrote:

scheme KEEP_MOST:

>> How about, for every N pages that you scan, evict at least 1 page,
>> regardless of young bit status?  That limits overscanning to a N:1
>> ratio.  With N=250 we'll spend at most 25 usec in order to locate one
>> page to evict.

scheme DROP_CONTINUOUS:

> > This is a quick hack to materialize the idea. It remembers roughly
> > the last 32*SWAP_CLUSTER_MAX=1024 active (mapped) pages scanned,
> > and if _all of them_ are referenced, then the referenced bit is
> > probably meaningless and should not be taken seriously.

> I don't think we should ignore the referenced bit. There could still be 
> a large batch of unreferenced pages later on that we should 
> preferentially swap. If we swap at least 1 page for every 250 scanned, 
> after 4K swaps we will have traversed 1M pages, enough to find them.

I guess both schemes have unacceptable flaws.

For JVM/BIGMEM workload, most pages would be found referenced _all the time_.
So the KEEP_MOST scheme could increase reclaim overheads by N=250 times;
while the DROP_CONTINUOUS scheme is effectively zero cost.

However, the DROP_CONTINUOUS scheme does bring more _indeterminacy_.
It can behave vastly different on single active task and multi ones.
It is short sighted and can be cheated by bursty activities.

> > As a refinement, the static variable 'recent_all_referenced' could be
> > moved to struct zone or made a per-cpu variable.
> 
> Definitely this should be made part of the zone structure, consider the 
> original report where the problem occurs in a 128MB zone (where we can 
> expect many pages to have their referenced bit set).

Good point. Here the cgroup list is highly stressed, while the global
zones are idling.

Thanks,
Fengguang

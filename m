Return-Path: <linux-kernel-owner+w=401wt.eu-S1751900AbZHMBEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbZHMBEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 21:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZHMBEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 21:04:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:58422 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbZHMBEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 21:04:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,371,1246863600"; 
   d="scan'208";a="175227424"
Date: Thu, 13 Aug 2009 09:03:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>, Avi Kivity <avi@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090813010356.GA7619@localhost>
References: <20090806100824.GO23385@random.random> <4A7AD5DF.7090801@redhat.com> <20090807121443.5BE5.A69D9226@jp.fujitsu.com> <20090812074820.GA29631@localhost> <4A82D24D.6020402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A82D24D.6020402@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 10:31:41PM +0800, Rik van Riel wrote:
> Wu Fengguang wrote:
> > On Fri, Aug 07, 2009 at 11:17:22AM +0800, KOSAKI Motohiro wrote:
> >>> Andrea Arcangeli wrote:
> >>>
> >>>> Likely we need a cut-off point, if we detect it takes more than X
> >>>> seconds to scan the whole active list, we start ignoring young bits,
> >>> We could just make this depend on the calculated inactive_ratio,
> >>> which depends on the size of the list.
> >>>
> >>> For small systems, it may make sense to make every accessed bit
> >>> count, because the working set will often approach the size of
> >>> memory.
> >>>
> >>> On very large systems, the working set may also approach the
> >>> size of memory, but the inactive list only contains a small
> >>> percentage of the pages, so there is enough space for everything.
> >>>
> >>> Say, if the inactive_ratio is 3 or less, make the accessed bit
> >>> on the active lists count.
> >> Sound reasonable.
> > 
> > Yes, such kind of global measurements would be much better.
> > 
> >> How do we confirm the idea correctness?
> > 
> > In general the active list tends to grow large on under-scanned LRU.
> > I guess Rik is pretty familiar with typical inactive_ratio values of
> > the large memory systems and may even have some real numbers :)
> > 
> >> Wu, your X focus switching benchmark is sufficient test?
> > 
> > It is a major test case for memory tight desktop.  Jeff presents
> > another interesting one for KVM, hehe.
> > 
> > Anyway I collected the active/inactive list sizes, and the numbers
> > show that the inactive_ratio is roughly 1 when the LRU is scanned
> > actively and may go very high when it is under-scanned.
> 
> inactive_ratio is based on the zone (or cgroup) size.

Ah sorry, my word 'inactive_ratio' means runtime active:inactive ratio.

> For zones it is a fixed value, which is available in
> /proc/zoneinfo

On my 64bit desktop with 4GB memory:

        DMA     inactive_ratio:    1
        DMA32   inactive_ratio:    4
        Normal  inactive_ratio:    1

The biggest zone DMA32 has inactive_ratio=4. But I guess the
referenced bit should not be ignored on this typical desktop
configuration?

Thanks,
Fengguang

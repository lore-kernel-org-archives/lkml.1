Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZHMVRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZHMVRC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:17:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbZHMVRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:17:01 -0400
Received: from cmpxchg.org ([85.214.51.133]:57778 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbZHMVRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:17:00 -0400
Date: Thu, 13 Aug 2009 23:16:26 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
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
Message-ID: <20090813211626.GA28274@cmpxchg.org>
References: <20090806100824.GO23385@random.random> <4A7AD5DF.7090801@redhat.com> <20090807121443.5BE5.A69D9226@jp.fujitsu.com> <20090812074820.GA29631@localhost> <4A82D24D.6020402@redhat.com> <20090813010356.GA7619@localhost> <4A843565.3010104@redhat.com> <4A843B72.6030204@redhat.com> <4A843EAE.6070200@redhat.com> <4A846581.2020304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A846581.2020304@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 10:12:01PM +0300, Avi Kivity wrote:
> On 08/13/2009 07:26 PM, Rik van Riel wrote:
> >>Why do we need to ignore the referenced bit in such cases?  To avoid 
> >>overscanning?
> >
> >
> >Because swapping out anonymous pages tends to be a relatively
> >rare operation, we'll have many gigabytes of anonymous pages
> >that all have the referenced bit set (because there was lots
> >of time between swapout bursts).
> >
> >Ignoring the referenced bit on active anon pages makes no
> >difference on these systems, because all active anon pages
> >have the referenced bit set, anyway.
> >
> >All we need to do is put the pages on the inactive list and
> >give them a chance to get referenced.
> >
> >However, on smaller systems (and cgroups!), the speed at
> >which we can do pageout IO is larger, compared to the amount
> >of memory.  This means we can cycle through the pages more
> >quickly and we may want to count references on the active
> >list, too.
> >
> >Yes, on smaller systems we'll also often end up with bursty
> >swapout loads and all pages referenced - but since we have
> >fewer pages to begin with, it won't hurt as much.
> >
> >I suspect that an inactive_ratio of 3 or 4 might make a
> >good cutoff value.
> >
> 
> Thanks for the explanation.  I think my earlier idea of
> 
> - do not ignore the referenced bit
> - if you see a run of N pages which all have the referenced bit set, do 
> swap one
> 
> has merit.  It means we cycle more quickly (by a factor of N) through 
> the list, looking for unreferenced pages.  If we don't find any we've 
> spent a some more cpu, but if we do find an unreferenced page, we win by 
> swapping a truly unneeded page.

But it also means destroying the LRU order.

Okay, we ignore the referenced bit, but we keep LRU buddies together
which then get reactivated together as well, if they are indeed in
active use.

I could imagine the VM going nuts when you separate them by a
predicate that is rather unrelated to the pages's actual usage
patterns.

After all, the list order is the primary input to selecting pages for
eviction.

It would need actual testing, of course, but I bet Rik's idea of using
the referenced bit always or never is going to show better results.

	Hannes

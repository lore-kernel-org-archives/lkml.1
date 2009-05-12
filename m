Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbZELLpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbZELLpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZELLpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:45:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:17904 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbZELLpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:45:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,182,1241420400"; 
   d="scan'208";a="141847977"
Date: Tue, 12 May 2009 19:44:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm] vmscan: report vm_flags in page_referenced()
Message-ID: <20090512114456.GB5926@localhost>
References: <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins> <20090507121101.GB20934@localhost> <20090507151039.GA2413@cmpxchg.org> <20090507134410.0618b308.akpm@linux-foundation.org> <20090508081608.GA25117@localhost> <20090508125859.210a2a25.akpm@linux-foundation.org> <20090512025153.GB7518@localhost> <1242109389.11251.310.camel@twins> <20090512154413.ca39795e.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512154413.ca39795e.minchan.kim@barrios-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 02:44:13PM +0800, Minchan Kim wrote:
> On Tue, 12 May 2009 08:23:09 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, 2009-05-12 at 10:51 +0800, Wu Fengguang wrote:
> > > @@ -406,6 +408,7 @@ static int page_referenced_anon(struct p
> > >                 if (mem_cont && !mm_match_cgroup(vma->vm_mm, mem_cont))
> > >                         continue;
> > >                 referenced += page_referenced_one(page, vma, &mapcount);
> > > +               *vm_flags |= vma->vm_flags;
> > >                 if (!mapcount)
> > >                         break;
> > >         }
> > 
> > Shouldn't that read:
> > 
> >   if (page_referenced_on(page, vma, &mapcount)) {
> >     referenced++;
> >     *vm_flags |= vma->vm_flags;
> >   }
> > 
> > So that we only add the vma-flags of those vmas that actually have a
> > young bit set?
> > 
> > In which case it'd be more at home in page_referenced_one():
> > 
> > @@ -381,6 +381,8 @@ out_unmap:
> >  	(*mapcount)--;
> >  	pte_unmap_unlock(pte, ptl);
> >  out:
> > +	if (referenced)
> > +		*vm_flags |= vma->vm_flags;
> >  	return referenced;
> >  }
> 
> Good. I am ACK for peter's suggestion.
> It can prevent setting vm_flag for worng vma which don't have the page.

Good suggestions!  I realized now it is a flaky idea to not do that in
page_referenced_one(), hehe.

Thanks,
Fengguang

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762196AbZEHDar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762196AbZEHDar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZEHDai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 23:30:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:29550 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbZEHDah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 23:30:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,314,1239001200"; 
   d="scan'208";a="140528065"
Date: Fri, 8 May 2009 11:30:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
	class citizen
Message-ID: <20090508033004.GB8892@localhost>
References: <20090430181340.6f07421d.akpm@linux-foundation.org> <20090430215034.4748e615@riellaptop.surriel.com> <20090430195439.e02edc26.akpm@linux-foundation.org> <49FB01C1.6050204@redhat.com> <20090501123541.7983a8ae.akpm@linux-foundation.org> <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins> <20090507121101.GB20934@localhost> <20090507151039.GA2413@cmpxchg.org> <1241709466.11251.164.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241709466.11251.164.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 11:17:46PM +0800, Peter Zijlstra wrote:
> On Thu, 2009-05-07 at 17:10 +0200, Johannes Weiner wrote:
> 
> > > @@ -1269,8 +1270,15 @@ static void shrink_active_list(unsigned 
> > >  
> > >  		/* page_referenced clears PageReferenced */
> > >  		if (page_mapping_inuse(page) &&
> > > -		    page_referenced(page, 0, sc->mem_cgroup))
> > > +		    page_referenced(page, 0, sc->mem_cgroup)) {
> > > +			struct address_space *mapping = page_mapping(page);
> > > +
> > >  			pgmoved++;
> > > +			if (mapping && test_bit(AS_EXEC, &mapping->flags)) {
> > > +				list_add(&page->lru, &l_active);
> > > +				continue;
> > > +			}
> > > +		}
> > 
> > Since we walk the VMAs in page_referenced anyway, wouldn't it be
> > better to check if one of them is executable?  This would even work
> > for executable anon pages.  After all, there are applications that cow
> > executable mappings (sbcl and other language environments that use an
> > executable, run-time modified core image come to mind).
> 
> Hmm, like provide a vm_flags mask along to page_referenced() to only
> account matching vmas... seems like a sensible idea.

I'd prefer to make vm_flags an out-param, like this:

-       int page_referenced(struct page *page, int is_locked,
+       int page_referenced(struct page *page, int is_locked, unsigned long *vm_flags,
                                struct mem_cgroup *mem_cont)

which allows reporting more versatile flags and status bits :) 

Thanks,
Fengguang


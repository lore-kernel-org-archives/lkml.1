Return-Path: <linux-kernel-owner+w=401wt.eu-S934173AbYEIANt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934173AbYEIANt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbYEIANi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:13:38 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:41587 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbYEIANf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:13:35 -0400
Date: Fri, 9 May 2008 10:02:49 +1000
From: David Gibson <dwg@au1.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org, dean@arctic.org,
       linux-kernel@vger.kernel.org, wli@holomorphy.com, andi@firstfloor.org,
       kenchen@google.com, agl@us.ibm.com
Subject: Re: [PATCH 0/3] Guarantee faults for processes that call
	mmap(MAP_PRIVATE) on hugetlbfs v2
Message-ID: <20080509000249.GA8552@yookeroo.seuss>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>,
	linux-mm@kvack.org, dean@arctic.org, linux-kernel@vger.kernel.org,
	wli@holomorphy.com, andi@firstfloor.org, kenchen@google.com,
	agl@us.ibm.com
References: <20080507193826.5765.49292.sendpatchset@skynet.skynet.ie> <20080508014822.GE5156@yookeroo.seuss> <20080508111408.GB30870@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508111408.GB30870@shadowen.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 12:14:08PM +0100, Andy Whitcroft wrote:
> On Thu, May 08, 2008 at 11:48:22AM +1000, David Gibson wrote:
> > On Wed, May 07, 2008 at 08:38:26PM +0100, Mel Gorman wrote:
> > > MAP_SHARED mappings on hugetlbfs reserve huge pages at mmap() time.
> > > This guarantees all future faults against the mapping will succeed.
> > > This allows local allocations at first use improving NUMA locality whilst
> > > retaining reliability.
> > > 
> > > MAP_PRIVATE mappings do not reserve pages. This can result in an application
> > > being SIGKILLed later if a huge page is not available at fault time. This
> > > makes huge pages usage very ill-advised in some cases as the unexpected
> > > application failure cannot be detected and handled as it is immediately fatal.
> > > Although an application may force instantiation of the pages using mlock(),
> > > this may lead to poor memory placement and the process may still be killed
> > > when performing COW.
> > > 
> > > This patchset introduces a reliability guarantee for the process which creates
> > > a private mapping, i.e. the process that calls mmap() on a hugetlbfs file
> > > successfully.  The first patch of the set is purely mechanical code move to
> > > make later diffs easier to read. The second patch will guarantee faults up
> > > until the process calls fork(). After patch two, as long as the child keeps
> > > the mappings, the parent is no longer guaranteed to be reliable. Patch
> > > 3 guarantees that the parent will always successfully COW by unmapping
> > > the pages from the child in the event there are insufficient pages in the
> > > hugepage pool in allocate a new page, be it via a static or dynamic pool.
> > 
> > I don't think patch 3 is a good idea.  It's a fair bit of code to
> > implement a pretty bizarre semantic that I really don't think is all
> > that useful.  Patches 1-2 are already sufficient to cover the
> > fork()/exec() case and a fair proportion of fork()/minor
> > frobbing/exit() cases.  If the child also needs to write the hugepage
> > area, chances are it's doing real work and we care about its
> > reliability too.
> 
> Without patch 3 the parent is still vunerable during the period the
> child exists.  Even if that child does nothing with the pages not even
> referencing them, and then execs immediatly.  As soon as we fork any
> reference from the parent will trigger a COW, at which point there may
> be no pages available and the parent will have to be killed.  That is
> regardless of the fact the child is not going to reference the page and
> leave the address space shortly.  With patch 3 on COW if we find no memory
> available the page may be stolen for the parent saving it, and the _risk_
> of reference death moves to the child; the child is killed only should it
> then re-reference the page.

Yes, thinko, sorry.  Forgot that a COW would be triggered even if the
child never wrote the pages.  I see the point of patch 3 now.  Damn,
but it's still a weird semantic to be implementing though.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

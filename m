Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbYEHG6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbYEHG6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbYEHG6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:58:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58017 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757087AbYEHG6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:58:21 -0400
Date: Thu, 8 May 2008 07:56:45 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: David Gibson <dwg@au1.ibm.com>, linux-mm@kvack.org, dean@arctic.org,
       apw@shadowen.org, linux-kernel@vger.kernel.org, wli@holomorphy.com,
       andi@firstfloor.org, kenchen@google.com, agl@us.ibm.com
Subject: Re: [PATCH 0/3] Guarantee faults for processes that call mmap(MAP_PRIVATE) on hugetlbfs v2
Message-ID: <20080508065644.GA25077@csn.ul.ie>
References: <20080507193826.5765.49292.sendpatchset@skynet.skynet.ie> <20080508014822.GE5156@yookeroo.seuss>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080508014822.GE5156@yookeroo.seuss>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/05/08 11:48), David Gibson didst pronounce:
> On Wed, May 07, 2008 at 08:38:26PM +0100, Mel Gorman wrote:
> > MAP_SHARED mappings on hugetlbfs reserve huge pages at mmap() time.
> > This guarantees all future faults against the mapping will succeed.
> > This allows local allocations at first use improving NUMA locality whilst
> > retaining reliability.
> > 
> > MAP_PRIVATE mappings do not reserve pages. This can result in an application
> > being SIGKILLed later if a huge page is not available at fault time. This
> > makes huge pages usage very ill-advised in some cases as the unexpected
> > application failure cannot be detected and handled as it is immediately fatal.
> > Although an application may force instantiation of the pages using mlock(),
> > this may lead to poor memory placement and the process may still be killed
> > when performing COW.
> > 
> > This patchset introduces a reliability guarantee for the process which creates
> > a private mapping, i.e. the process that calls mmap() on a hugetlbfs file
> > successfully.  The first patch of the set is purely mechanical code move to
> > make later diffs easier to read. The second patch will guarantee faults up
> > until the process calls fork(). After patch two, as long as the child keeps
> > the mappings, the parent is no longer guaranteed to be reliable. Patch
> > 3 guarantees that the parent will always successfully COW by unmapping
> > the pages from the child in the event there are insufficient pages in the
> > hugepage pool in allocate a new page, be it via a static or dynamic pool.
> 
> I don't think patch 3 is a good idea.  It's a fair bit of code to
> implement a pretty bizarre semantic that I really don't think is all
> that useful.  Patches 1-2 are already sufficient to cover the
> fork()/exec() case and a fair proportion of fork()/minor
> frobbing/exit() cases. 

True. It would also cover a parent that called MADV_DONTFORK before
fork()ing as the child would not hold references to the page. Patch 1-2
improves the current situation quite a bit.

> If the child also needs to write the hugepage
> area, chances are it's doing real work and we care about its
> reliability too.
> 

The thing is that patch 3 does not prevent the child writing to the mapping as
it only unmaps the pages when the alternative is to kill the parent (i.e. the
original mapper). It enforces that the pool must be large enough if a child is
to do that without failure. I'm guessing that children writing hugepage-backed
mapping is a case very rarely seen in practice but that a parent writing
its mappings before a child exits is relatively common. Without patch 3,
a too-long-lived child can accidently kill its parent simply because the
parent takes the COW. In the unlikely event a child dies because the pool
was too small for COW, a message is printed to kern.log with patch 3.

The unmapping semantic is unusual but it only comes into play when the pool
was too small. I'm biased, but I don't think it is a terrible idea and
closes off an important hole left after patches 1-2.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

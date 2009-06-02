Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbZFBH6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbZFBH6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758948AbZFBH6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:58:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:39199 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759032AbZFBH6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:58:37 -0400
Date: Tue, 2 Jun 2009 09:58:36 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
Message-ID: <20090602075836.GB16201@wotan.suse.de>
References: <alpine.DEB.2.00.0906011828040.6936@chino.kir.corp.google.com> <alpine.DEB.2.00.0906011830490.6936@chino.kir.corp.google.com> <20090601225602.3482cd0d.akpm@linux-foundation.org> <alpine.DEB.2.00.0906020016060.24915@chino.kir.corp.google.com> <1243928095.23657.5633.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243928095.23657.5633.camel@twins>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 09:34:55AM +0200, Peter Zijlstra wrote:
> On Tue, 2009-06-02 at 00:26 -0700, David Rientjes wrote:
> > > I really think/hope/expect that this is unneeded.
> > > 
> > > Do we know of any callsites which do greater-than-order-0 allocations
> > > with GFP_NOFAIL?  If so, we should fix them.
> > > 
> > > Then just ban order>0 && GFP_NOFAIL allocations.
> > > 
> > 
> > That seems like a different topic: banning higher-order __GFP_NOFAIL 
> > allocations or just deprecating __GFP_NOFAIL altogether and slowly 
> > switching users over is a worthwhile effort, but is unrelated.
> > 
> > This patch is necessary because we explicitly deny the oom killer from 
> > being used when the order is greater than PAGE_ALLOC_COSTLY_ORDER because 
> > of an assumption that it won't help.  That assumption isn't always true, 
> > especially for large memory-hogging tasks that have mlocked large chunks 
> > of contiguous memory, for example.  The only thing we do know is that 
> > direct reclaim has not made any progress so we're unlikely to get a 
> > substantial amount of memory freeing in the immediate future.  Such an 
> > instance will simply loop forever without killing that rogue task for a 
> > __GFP_NOFAIL allocation.
> > 
> > So while it's better in the long-term to deprecate the flag as much as 
> > possible and perhaps someday remove it from the page allocator entirely, 
> > we're faced with the current behavior of either looping endlessly or 
> > freeing memory so the kernel allocation may succeed when direct reclaim 
> > has failed, which also makes this a rare instance where the oom killer 
> > will never needlessly kill a task.
> 
> I would really prefer if we do as Andrew suggests. Both will fix this
> problem, so I don't see it as a different topic at all.

Well, his patch, as it stands, is a good one. Because we do have
potential higher order GFP_NOFAIL.

I don't particularly want to add complexity (not a single branch)
to SLQB to handle this (and how does the caller *really* know
anyway? they know the exact object size, the hardware alignment
constraints, the page size, etc. in order to know that all of the
many slab allocators will be able to satisfy it with an order-0
allocation?)


> Eradicating __GFP_NOFAIL is a fine goal, but very hard work (people have
> been wanting to do that for many years). But simply limiting it to
> 0-order allocation should be much(?) easier.

Some of them may be hard work, but I don't think anybody has
been working too hard at it ;) 



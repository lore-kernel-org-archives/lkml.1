Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbZDGURW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbZDGURW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbZDGURN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:17:13 -0400
Received: from cmpxchg.org ([85.214.51.133]:36655 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbZDGURN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:17:13 -0400
Date: Tue, 7 Apr 2009 22:17:08 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [8/16] POISON: Add various poison checks in mm/memory.c
Message-ID: <20090407201708.GA4220@cmpxchg.org>
References: <20090407509.382219156@firstfloor.org> <20090407151005.4E24B1D046D@basil.firstfloor.org> <20090407190330.GB3818@cmpxchg.org> <20090407193145.GU17934@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407193145.GU17934@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 09:31:45PM +0200, Andi Kleen wrote:
> On Tue, Apr 07, 2009 at 09:03:30PM +0200, Johannes Weiner wrote:
> > On Tue, Apr 07, 2009 at 05:10:05PM +0200, Andi Kleen wrote:
> > > 
> > > Bail out early when poisoned pages are found in page fault handling.
> > > Since they are poisoned they should not be mapped freshly
> > > into processes.
> > > 
> > > This is generally handled in the same way as OOM, just a different
> > > error code is returned to the architecture code.
> > > 
> > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > > 
> > > ---
> > >  mm/memory.c |    7 +++++++
> > >  1 file changed, 7 insertions(+)
> > > 
> > > Index: linux/mm/memory.c
> > > ===================================================================
> > > --- linux.orig/mm/memory.c	2009-04-07 16:39:39.000000000 +0200
> > > +++ linux/mm/memory.c	2009-04-07 16:39:39.000000000 +0200
> > > @@ -2560,6 +2560,10 @@
> > >  		goto oom;
> > >  	__SetPageUptodate(page);
> > >  
> > > +	/* Kludge for now until we take poisoned pages out of the free lists */
> > > +	if (unlikely(PagePoison(page)))
> > > +		return VM_FAULT_POISON;
> > > +
> > 
> > When memory_failure() hits a page still on the free list
> 
> It won't free it then. Later on it will take it out of the free lists,
> but that code is not written yet.
> 
> > (!page_count()) then the get_page() in memory_failure() will trigger a
> > VM_BUG.  So either this check is unneeded or it should be
> 
> So no bug
> > get_page_unless_zero() in memory_failure()?
> 
> That's not what this is handling.  The issue is that sometimes
> the process can still freeing it and we need to make sure it 
> never hits the free lists.

I think we missed each other here.  I wasn't talking about _why_ you
take that reference -- that is clear.  But I see these two
possibilities:

  a) memory_failure() is called on a page on the free list, the
  get_page() will trigger a bug because the refcount is 0

  b) if that is not possible, the above check is not needed

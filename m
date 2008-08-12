Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbYHLHdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbYHLHdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 03:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYHLHdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 03:33:10 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:9612 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYHLHdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 03:33:09 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [PATCH 02/30] mm: gfp_to_alloc_flags()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Neil Brown <neilb@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <18593.6448.132048.150818@notabene.brown>
References: <20080724140042.408642539@chello.nl>
	 <20080724141529.408041430@chello.nl>
	 <18593.6448.132048.150818@notabene.brown>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 09:33:05 +0200
Message-Id: <1218526385.10800.165.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-12 at 15:01 +1000, Neil Brown wrote:
> On Thursday July 24, a.p.zijlstra@chello.nl wrote:
> > Factor out the gfp to alloc_flags mapping so it can be used in other places.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  mm/internal.h   |   10 +++++
> >  mm/page_alloc.c |   95 +++++++++++++++++++++++++++++++-------------------------
> >  2 files changed, 64 insertions(+), 41 deletions(-)
> 
> This patch all looks "obviously correct" and a nice factorisation of
> code, except the last little bit:
> 
> > @@ -1618,6 +1627,10 @@ nofail_alloc:
> >  	if (!wait)
> >  		goto nopage;
> >  
> > +	/* Avoid recursion of direct reclaim */
> > +	if (p->flags & PF_MEMALLOC)
> > +		goto nopage;
> > +
> >  	cond_resched();
> >  
> >  	/* We now go into synchronous reclaim */
> > 
> > -- 
> 
> I don't remember seeing it before (though my memory is imperfect) and
> it doesn't seem to fit with the rest of the patch (except spatially).
> 
> There is a test above for PF_MEMALLOC which will result in a "goto"
> somewhere else unless "in_interrupt()".
> There is immediately above a test for "!wait".
> So the only way this test can fire is when in_interrupt and wait.
> But if that happens, then the
> 	might_sleep_if(wait)
> at the top should have thrown a warning...  It really shouldn't happen.
> 
> So it looks like it is useless code:  there is already protection
> against recursion in this case.
> 
> Did I miss something?
> If I did, maybe more text in the changelog entry (or the comment)
> would help.

Ok, so the old code did:

  if (((p->flags & PF_MEMALLOC) || ...) && !in_interrupt) {
    ....
    goto nopage;
  }

which avoid anything that has PF_MEMALLOC set from entering into direct
reclaim, right?

Now, the new code reads:

  if (alloc_flags & ALLOC_NO_WATERMARK) {
  }

Which might be false, even though we have PF_MEMALLOC set -
__GFP_NOMEMALLOC comes to mind.

So we have to stop that recursion from happening.

so we add:

  if (p->flags & PF_MEMALLOC)
    goto nopage;

Now, if it were done before the !wait check, we'd have to consider
atomic contexts, but as those are - as you rightly pointed out - handled
by the !wait case, we can plainly do this check.




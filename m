Return-Path: <linux-kernel-owner+w=401wt.eu-S933157AbXHFSkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbXHFSkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759042AbXHFSkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:40:15 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:49070
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758880AbXHFSkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:40:12 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/10] foundations for reserve-based allocation
Date: Mon, 6 Aug 2007 11:40:04 -0700
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
References: <20070806102922.907530000@chello.nl> <200708061035.18742.phillips@phunq.net> <1186424248.11797.66.camel@lappy>
In-Reply-To: <1186424248.11797.66.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061140.05002.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2007 11:17, Peter Zijlstra wrote:
> lim_{n -> inf} (2^(n+1)/((2^n)+1)) = 2^lim_{n -> inf} ((n+1)-n) = 2^1 
= 2

Glad I asked :-)

> > Patch [3/10] adds a new field to struct page.
>
> No it doesn't.

True.  It is not immediately obvious from the declaration that the 
overloaded field is always freed up before anybody else needs to use 
the union.

> >   I do not think this is
> > necessary.   Allocating a page from reserve does not make it
> > special. All we care about is that the total number of pages taken
> > out of reserve is balanced by the total pages freed by a user of
> > the reserve.
>
> And how do we know a page was taken out of the reserves?
>
> This is done by looking at page->reserve (overload of page->index)
> and this value can be destroyed as soon as its observed. It is in a
> sense an extra return value.

Ah I see.  I used to let alloc_pages fail then repeat the allocation 
with __GFP_MEMALLOC set, which was easy but stupidly repetitious.  Your 
technique is better, though returning the status in the page still 
looks a little funny.  This is really about saving a page flag, no?

> > We do care about slab fragmentation in the sense that a slab page
> > may be pinned in the slab by an unprivileged allocation and so that
> > page may never be returned to the global page reserve.
>
> A slab page obtained from the reseserve will never serve an object to
> an unprivilidged allocation.
>
> >   One way to solve this is
> > to have a per slabpage flag indicating the page came from reserve,
> > and prevent mixing of privileged and unprivileged allocations on
> > such a page.
>
> is done.

Serves me right for not reading that bit.  So the score for that round 
is: peterz 3, phillips 0 ;-)

Regards,

Daniel

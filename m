Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbXJODmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbXJODmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 23:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbXJODmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 23:42:36 -0400
Received: from gw.goop.org ([64.81.55.164]:60957 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbXJODmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 23:42:35 -0400
Message-ID: <4712E1AA.501@goop.org>
Date: Sun, 14 Oct 2007 20:42:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       =?ISO-8859-1?Q?Morten_B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
Subject: Re: Interaction between Xen and XFS: stray RW mappings
References: <470FA7C3.90404@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <4712BB05.1020701@goop.org> <200710151726.08387.nickpiggin@yahoo.com.au>
In-Reply-To: <200710151726.08387.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Yeah, it would be possible. The easiest way would just be to shoot down
> all lazy vmaps (because you're doing the global IPIs anyway, which are
> the expensive thing, at which point you may as well purge the rest of
> your lazy mappings).
>   

Sure.

> If it is sufficiently rare, then it could be the simplest thing to do.
>   

Yes.  If there's some way to tell whether a particular page is in a lazy
mapping then that would help, since we could easily tell whether we need
to do the whole shootdown thing.  I would expect the population of
lazily mapped pages in the whole freepage pool to be pretty small, but
if the allocator tends to return the most recently freed pages you might
hit them fairly regularly (shoving them at the other end of the freelist
might be useful).

> OK, I see. Because even though it is technically safe where we are
> using it (because nothing writes through the mappings after the page
> is freed), a corrupted guest could use the same window to do bad
> things with the pagetables?
>   

That's right.  The hypervisor doesn't trust the guests, so it prevents
them from getting into a state where they can do bad things.

> For Xen -- shouldn't be a big deal. We can have a single Linux mm API
> to call, and we can do the right thing WRT vmap/kamp. I should try to
> merge my current lazy vmap patches which replace the XFS stuff, so we
> can implement such an API and fix your XFS issue?

Sounds good.

>  That's not going to
> happen for at least a cycle or two though, so in the meantime maybe
> an ifdef for that XFS vmap batching code would help?
>   

For now I've proposed a patch to simply eagerly vunmap everything when
CONFIG_XEN is set.  It certainly works, but I don't have a good feel for
how much of a performance hit that imposes on XFS.  A slightly more
subtle change would be to test to see if we're actually running under
Xen before taking the eager path, so at least the performance burden
only affects actual Xen users (and I presume xfs+xen is a fairly rare
combination, or this problem would have turned up earlier, or perhaps
the old xenified kernels have some other workaround for it).

    J

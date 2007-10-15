Return-Path: <linux-kernel-owner+w=401wt.eu-S1763538AbXJOCfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763538AbXJOCfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 22:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbXJOCfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 22:35:11 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:30338 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750751AbXJOCfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 22:35:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=n+YdyyZIfVukjZNrK0Gf1wVlcdlbhXiFw+Odrho/+ogyJTa+n//Jvq/BN8aDAHazrpojiqbSJjVssJwlzgGvOV2BmHIWEdPNZnLyTf51P2BEfNkxYUoj8auagHR/oZcAliIoc7EDv+rD2lAkIQvRI6RFqI3Ac7PVIvH3pF2LDdg=  ;
X-YMail-OSG: zYdii6oVM1mqByk7dn3DrR7zOMT5GrQBx.tg0mEFrNnxRnhEdRJewGhLkplIbrfbi05AvHE4lg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Date: Mon, 15 Oct 2007 17:26:07 +1000
User-Agent: KMail/1.9.5
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten =?iso-8859-1?q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
References: <470FA7C3.90404@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <4712BB05.1020701@goop.org>
In-Reply-To: <4712BB05.1020701@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710151726.08387.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 10:57, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > Yes, as Dave said, vmap (more specifically: vunmap) is very expensive
> > because it generally has to invalidate TLBs on all CPUs.
>
> I see.
>
> > I'm looking at some more general solutions to this (already have some
> > batching / lazy unmapping that replaces the XFS specific one), however
> > they are still likely going to leave vmap mappings around after freeing
> > the page.
>
> Hm.  Could there be a call to shoot down any lazy mappings of a page, so
> the Xen pagetable code could use it on any pagetable page?  Ideally one
> that could be used on any page, but only causes expensive operations
> where needed.

Yeah, it would be possible. The easiest way would just be to shoot down
all lazy vmaps (because you're doing the global IPIs anyway, which are
the expensive thing, at which point you may as well purge the rest of
your lazy mappings).

If it is sufficiently rare, then it could be the simplest thing to do.


> > We _could_ hold on to the pages as well, but that's pretty inefficient.
> > The memory cost of keeping the mappings around tends to be well under
> > 1% the cost of the page itself. OTOH we could also avoid lazy flushes
> > on architectures where it is not costly. Either way, it probably would
> > require an arch hook or even a couple of ifdefs in mm/vmalloc.c for
> > Xen. Although... it would be nice if Xen could take advantage of some
> > of these optimisations as well.
>
> In general the lazy unmappings won't worry Xen.  It's only for the
> specific case of allocating memory for pagetables.  Xen can do a bit of
> extra optimisation for cross-cpu tlb flushes (if the target vcpus are
> not currently running, then you don't need to do anything), but they're
> still an expensive operation, so the optimisation is definitely useful.

OK.


> > What's the actual problem for Xen? Anything that can be changed?
>
> Not easily.  Xen doesn't use shadow pagetables.  Instead, it gives the
> guest domains direct access to the real CPU's pagetable, but makes sure
> they're always mapped RO so that the hypervisor can control updates to
> the pagetables (either by trapping writes or via explicit hypercalls).
> This means that when constructing a new pagetable, Xen will verify that
> all the mappings of pages making up the new pagetable are RO before
> allowing it to be used.  If there are stray RW mappings of those pages,
> pagetable construction will fail.

OK, I see. Because even though it is technically safe where we are
using it (because nothing writes through the mappings after the page
is freed), a corrupted guest could use the same window to do bad
things with the pagetables?


> Aside from XFS, the only other case I've found where there could be
> stray RW mappings is when using high pages which are still in the kmap
> cache; I added an explicit call to flush the kmap cache to handle this.
> If vmap and kmap can be unified (at least the lazy unmap aspects of
> them), then that would be a nice little cleanup.

vmap is slightly harder than kmap in some respects. However it would
be really nice to get vmap fast and general enough to completely
replace all the kmap crud -- that's one goal, but the first thing
I'm doing is to concentrate on just vmap to work out how to make it
as fast as possible.

For Xen -- shouldn't be a big deal. We can have a single Linux mm API
to call, and we can do the right thing WRT vmap/kamp. I should try to
merge my current lazy vmap patches which replace the XFS stuff, so we
can implement such an API and fix your XFS issue? That's not going to
happen for at least a cycle or two though, so in the meantime maybe
an ifdef for that XFS vmap batching code would help?

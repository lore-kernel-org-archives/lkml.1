Return-Path: <linux-kernel-owner+w=401wt.eu-S1764292AbXJOA5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764292AbXJOA5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 20:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbXJOA5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 20:57:42 -0400
Received: from gw.goop.org ([64.81.55.164]:53545 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbXJOA5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 20:57:42 -0400
Message-ID: <4712BB05.1020701@goop.org>
Date: Sun, 14 Oct 2007 17:57:41 -0700
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
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com> <4712A254.4090604@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au>
In-Reply-To: <200710151415.07248.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Yes, as Dave said, vmap (more specifically: vunmap) is very expensive
> because it generally has to invalidate TLBs on all CPUs.
>   

I see.

> I'm looking at some more general solutions to this (already have some
> batching / lazy unmapping that replaces the XFS specific one), however
> they are still likely going to leave vmap mappings around after freeing
> the page.
>   

Hm.  Could there be a call to shoot down any lazy mappings of a page, so
the Xen pagetable code could use it on any pagetable page?  Ideally one
that could be used on any page, but only causes expensive operations
where needed.

> We _could_ hold on to the pages as well, but that's pretty inefficient.
> The memory cost of keeping the mappings around tends to be well under
> 1% the cost of the page itself. OTOH we could also avoid lazy flushes
> on architectures where it is not costly. Either way, it probably would
> require an arch hook or even a couple of ifdefs in mm/vmalloc.c for
> Xen. Although... it would be nice if Xen could take advantage of some
> of these optimisations as well.
>   

In general the lazy unmappings won't worry Xen.  It's only for the
specific case of allocating memory for pagetables.  Xen can do a bit of
extra optimisation for cross-cpu tlb flushes (if the target vcpus are
not currently running, then you don't need to do anything), but they're
still an expensive operation, so the optimisation is definitely useful.

> What's the actual problem for Xen? Anything that can be changed?
>   

Not easily.  Xen doesn't use shadow pagetables.  Instead, it gives the
guest domains direct access to the real CPU's pagetable, but makes sure
they're always mapped RO so that the hypervisor can control updates to
the pagetables (either by trapping writes or via explicit hypercalls). 
This means that when constructing a new pagetable, Xen will verify that
all the mappings of pages making up the new pagetable are RO before
allowing it to be used.  If there are stray RW mappings of those pages,
pagetable construction will fail.

Aside from XFS, the only other case I've found where there could be
stray RW mappings is when using high pages which are still in the kmap
cache; I added an explicit call to flush the kmap cache to handle this. 
If vmap and kmap can be unified (at least the lazy unmap aspects of
them), then that would be a nice little cleanup.

    J

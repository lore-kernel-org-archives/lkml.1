Return-Path: <linux-kernel-owner+w=401wt.eu-S1764059AbXJNW44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764059AbXJNW44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 18:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759226AbXJNW4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 18:56:47 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60713 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759004AbXJNW4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 18:56:46 -0400
Date: Mon, 15 Oct 2007 08:56:18 +1000
From: David Chinner <dgc@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten =?iso-8859-1?B?QsO4Z2Vza292?= 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com, nickpiggin@yahoo.com.au
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071014225618.GN23367404@sgi.com>
References: <470FA7C3.90404@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470FA7C3.90404@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 09:58:43AM -0700, Jeremy Fitzhardinge wrote:
> Hi Dave & other XFS folk,
> 
> I'm tracking down a bug which appears to be a bad interaction between XFS
> and Xen.  It looks like XFS is holding RW mappings on free pages, which Xen
> is trying to get an exclusive RO mapping on so it can turn them into
> pagetables.
> 
> I'm assuming the pages are actually free, and this isn't a use after free
> problem.  From a quick poke around, the most likely pieces of XFS code is
> the stuff in xfs_map.c which creates a virtually contiguous mapping of pages
> with vmap, and seems to delay unmapping them.

You mean xfs_buf.c.

And yes, we delay unmapping pages until we have a batch of them
to unmap. vmap and vunmap do not scale, so this is batching helps
alleviate some of the worst of the problems.

> When pinning a pagetable, Xen tries to eliminate any RW aliases of the pages
> its using.  This is generally trivial because pages returned by
> get_free_page don't have any mappings aside from the normal kernel mapping.
> High pages, when using CONFIG_HIGHPTE, may have a residual kmap mapping, so
> we clear out the kmap cache if we encounter a highpage in the pagetable.
> 
> I guess we could create a special-case interface to do the same thing with
> XFS mappings, but it would be nicer to have something more generic.

*nod*

> Is my analysis correct?  Or should XFS not be holding stray mappings?  Or is
> there already some kind of generic mechanism I can use to get it to release
> its mappings?

The xfsbufd cleans out any stale mappings - it's woken by the memory
shrinker interface (i.e. calls xfsbufd_wakeup()). Otherwise every
64th buffer being vmap()d will flush out stale mappings.

Realistically, if this delayed release of vmaps is a problem for
Xen, then I think that some generic VM solution is needed to this
problem as vmap() is likely to become more common in future (think
large blocks in filesystems). Nick - any comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

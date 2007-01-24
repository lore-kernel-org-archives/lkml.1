Return-Path: <linux-kernel-owner+w=401wt.eu-S932793AbXAXWZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793AbXAXWZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932796AbXAXWZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:25:13 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:46650 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932793AbXAXWZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:25:12 -0500
Date: Thu, 25 Jan 2007 09:24:51 +1100
From: David Chinner <dgc@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       akpm@osdl.org
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
Message-ID: <20070124222451.GM33919298@melbourne.sgi.com>
References: <20070123223702.GF33919298@melbourne.sgi.com> <1169640835.6189.14.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169640835.6189.14.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 01:13:55PM +0100, Peter Zijlstra wrote:
> On Wed, 2007-01-24 at 09:37 +1100, David Chinner wrote:
> > With the recent changes to cancel_dirty_pages(), XFS will
> > dump warnings in the syslog because it can truncate_inode_pages()
> > on dirty mapped pages.
> > 
> > I've determined that this is indeed correct behaviour for XFS
> > as this can happen in the case of races on mmap()d files with
> > direct I/O. In this case when we do a direct I/O read, we
> > flush the dirty pages to disk, then truncate them out of the
> > page cache. Unfortunately, between the flush and the truncate
> > the mmap could dirty the page again. At this point we toss a
> > dirty page that is mapped.
> 
> This sounds iffy, why not just leave the page in the pagecache if its
> mapped anyway?

Because then fsx fails.

> > None of the existing functions for truncating pages or invalidating
> > pages work in this situation. Invalidating a page only works for
> > non-dirty pages with non-dirty buffers, and they only work for
> > whole pages and XFS requires partial page truncation.
> > 
> > On top of that the page invalidation functions don't actually
> > call into the filesystem to invalidate the page and so the filesystem
> > can't actually invalidate the page properly (e.g. do stuff based on
> > private buffer head flags).
> 
> Have you seen the new launder_page() a_op? called from
> invalidate_inode_pages2_range()

No, but we can't use invalidate_inode_pages2_range() because it
doesn't handle partial pages. I tried that first and it left warnings
in the syslog and fsx failed.

> > So that leaves us needing to use truncate semantics and the problem
> > is that none of them unmap pages in a non-racy manner - if they
> > unmap pages they do it separately to the truncate of the page,
> > leading to races with mmap redirtying the page between the unmap and
> > the truncate ofthe page.
> 
> Isn't there still a race where the page fault path doesn't yet lock the
> page and can just reinsert it?

Yes, but it's a tiny race compared to the other mechanisms
available.

> Nick's pagefault rework should rid us of this by always locking the page
> in the fault path.

Yes, and that's what I'm relying on to fix the problem completely.
invalidate_inode_pages2_range() needs this fix as well to be race
free, so it's not like I'm introducing a new problem....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

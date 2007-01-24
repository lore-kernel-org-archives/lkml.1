Return-Path: <linux-kernel-owner+w=401wt.eu-S932845AbXAXWrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbXAXWrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932846AbXAXWrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:47:14 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:47362 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932845AbXAXWrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:47:11 -0500
Date: Thu, 25 Jan 2007 09:46:54 +1100
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@osdl.org
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
Message-ID: <20070124224654.GN33919298@melbourne.sgi.com>
References: <20070123223702.GF33919298@melbourne.sgi.com> <1169640835.6189.14.camel@twins> <45B7627B.8050202@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B7627B.8050202@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 12:43:23AM +1100, Nick Piggin wrote:
> Peter Zijlstra wrote:
> >On Wed, 2007-01-24 at 09:37 +1100, David Chinner wrote:
> >
> >>With the recent changes to cancel_dirty_pages(), XFS will
> >>dump warnings in the syslog because it can truncate_inode_pages()
> >>on dirty mapped pages.
> >>
> >>I've determined that this is indeed correct behaviour for XFS
> >>as this can happen in the case of races on mmap()d files with
> >>direct I/O. In this case when we do a direct I/O read, we
> >>flush the dirty pages to disk, then truncate them out of the
> >>page cache. Unfortunately, between the flush and the truncate
> >>the mmap could dirty the page again. At this point we toss a
> >>dirty page that is mapped.
> >
> >
> >This sounds iffy, why not just leave the page in the pagecache if its
> >mapped anyway?
> 
> And why not just leave it in the pagecache and be done with it?

because what is in cache is then not coherent with what is on disk,
and a direct read is supposed to read the data that is present
in the file at the time it is issued. 

> All you need is to do a writeout before a direct IO read, which is
> what generic dio code does.

No, that's not good enough - after writeout but before the
direct I/O read is issued a process can fault the page and dirty
it. If you do a direct read, followed by a buffered read you should
get the same data. The only way to guarantee this is to chuck out
any cached pages across the range of the direct I/O so they are
fetched again from disk on the next buffered I/O. i.e. coherent
at the time the direct I/O is issued.

> I guess you'll say that direct writes still need to remove pages,

Yup.

> but in that case you'll either have to live with some racyness
> (which is what the generic code does), or have a higher level
> synchronisation to prevent buffered + direct IO writes I suppose?

The XFS inode iolock - direct I/O writes take it shared, buffered
writes takes it exclusive - so you can't do both at once. Buffered
reads take is shared, which is another reason why we need to purge
the cache on direct I/O writes - they can operate concurrently
(and coherently) with buffered reads.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

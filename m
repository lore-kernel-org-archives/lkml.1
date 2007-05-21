Return-Path: <linux-kernel-owner+w=401wt.eu-S1764004AbXEUKUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764004AbXEUKUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762204AbXEUKMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:12:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43418 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761836AbXEUKMB (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:12:01 -0400
Date: Mon, 21 May 2007 20:11:42 +1000
From: David Chinner <dgc@sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Christoph Hellwig <hch@lst.de>, xfs-masters@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [xfs-masters] Re: 2.6.22-rc1-mm1
Message-ID: <20070521101141.GX86004887@sgi.com>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464B304C.5040104@googlemail.com> <20070516094133.bec04e65.akpm@linux-foundation.org> <20070517020600.GS85884050@sgi.com> <20070517084135.GA8510@lst.de> <464CB577.5080106@googlemail.com> <20070518021114.GV86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518021114.GV86004887@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 12:11:14PM +1000, David Chinner wrote:
> On Thu, May 17, 2007 at 10:05:11PM +0200, Michal Piotrowski wrote:
> > I applied your patch and I get another oops
> > 
> > [  261.491499] XFS mounting filesystem loop0
> > [  261.501641] Ending clean XFS mount for filesystem: loop0
> > [  261.507698] SELinux: initialized (dev loop0, type xfs), uses xattr
> > [  261.567441] XFS mounting filesystem loop0
> > [  261.573931] allocation failed: out of vmalloc space - use vmalloc=<size> to increase size.
> > [  261.582935] xfs_buf_get_noaddr: failed to map pages
> > [  261.592478] Ending clean XFS mount for filesystem: loop0
> > [  261.618543] SELinux: initialized (dev loop0, type xfs), uses xattr
> > [  261.691563] XFS mounting filesystem loop0
> > [  261.698927] allocation failed: out of vmalloc space - use vmalloc=<size> to increase size.
> >                                   ^^^^^^^^^^^^^^^^^^^^
> >                                   interesting
> 
> Yeah, looks like a vmalloc leak is occurring. I haven't noticed
> it before because:
> 
> VmallocTotal: 137427898368 kB
> VmallocUsed:   3128272 kB
> VmallocChunk: 137424770048 kB
> 
> It takes a long time to leak enough vmapped space to run out on ia64...
> 
> That tends to imply we have a mapped buffer being leaked somewhere.
> Interestingly, I don't see a memory leak so we must be freeing the
> memory associated with the buffer, just not unmapping it first. Not
> sure how that can happen yet.....
.....
> 
> Looks like we're leaking 272kB of vmalloc space on each mount/unmount
> cycle. I'm trying to track this down now....

I've found what is going on here - kmem_alloc() is decidedly more
forgiving than manually built page arrays and vmap/vunmap. Prior
to this change we wouldn't have even leaked memory....

Christoph - this is an interaction with xfs_buf_associate_memory();
I'm not sure what it is doing is at all safe now that it never gets
passed kmem_alloc()d memory - it works for the log recovery case
because we use it in pairs - once to shorten the buffer and then once
to put it back the way it was.

But that doesn't work for the log buffers (we never return them to their
original state) and the log wrap case looks to work mostly by accident
now (and could posibly lead to double freeing pages)....

It seems that what we really need with the new code is a xfs_buf_clone()
operation followed by trimming the range to what the secondary I/O needs
to span. This would work for the log buffer case as well. Your thoughts?

In the meantime, the following patch appears to fix the leak.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2007-05-21 19:51:18.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2007-05-21 19:57:30.960084657 +1000
@@ -1457,7 +1457,7 @@ xlog_sync(xlog_t		*log,
 	} else {
 		iclog->ic_bwritecnt = 1;
 	}
-	XFS_BUF_SET_PTR(bp, (xfs_caddr_t) &(iclog->ic_header), count);
+	XFS_BUF_SET_COUNT(bp, count);
 	XFS_BUF_SET_FSPRIVATE(bp, iclog);	/* save for later */
 	XFS_BUF_ZEROFLAGS(bp);
 	XFS_BUF_BUSY(bp);

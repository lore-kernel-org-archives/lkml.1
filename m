Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbZCPFMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbZCPFMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 01:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZCPFMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 01:12:23 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:4463 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbZCPFMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 01:12:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMt7vUl5LAJ7/2dsb2JhbADQaoN/BocQ
X-IronPort-AV: E=Sophos;i="4.38,371,1233495000"; 
   d="scan'208";a="339515347"
Date: Mon, 16 Mar 2009 16:12:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Theodore Tso <tytso@mit.edu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Message-ID: <20090316051211.GB26138@disturbed>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
	tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903130004.40483.nickpiggin@yahoo.com.au> <200903141941.10030.phillips@phunq.net> <200903151445.04552.nickpiggin@yahoo.com.au> <20090315214426.GA6357@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090315214426.GA6357@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 05:44:26PM -0400, Theodore Tso wrote:
> On Sun, Mar 15, 2009 at 02:45:04PM +1100, Nick Piggin wrote:
> > > As it happens, Tux3 also physically allocates each _physical_ metadata
> > > block (i.e., what is currently called buffer cache) at the time it is
> > > dirtied.  I don't know if this is the best thing to do, but it is
> > > interesting that you do the same thing.  I also don't know if I want to
> > > trust a library to get this right, before having completely proved out
> > > the idea in a non-trival filesystem.  But good luck with that!  It
> > 
> > I'm not sure why it would be a big problem. fsblock isn't allocating
> > the block itself of course, it just asks the filesystem to. It's
> > trivial to do for fsblock.
> 
> So the really unfortunate thing about allocating the block as soon as
> the page is dirty is that it spikes out delayed allocation.  By
> delaying the physical allocation of the logical->physical mapping as
> long as possible, the filesystem can select the best possible physical
> location.

This is no different to the way delayed allocation with bufferheads
works. Both XFS and ext4 set the buffer_delay flag instead of
allocating up front so that later on in ->writepages we can do
optimal delayed allocation. AFAICT fsblock works the same way....

> XFS, for example, keeps a btree of free regions indexed by
> size so that it can select the perfect location for a newly written
> file which is 24k or 56k long.

Ah, no. It's far more complex than that. To begin with, XFS has
*two* freespace trees per allocation group - one indexed by extent size,
the other by extent starting block.

XFS looks for an exact or nearby extent start block match that is
big enough in the by-block tree. If it can't find a nearby match,
then it looks up a size match in the by-size tree. i.e. the
fundamental allocation assumption is that locality of data placement
matters far more than filling holes in the freespace trees.....

> In addition, XFS uses delayed allocation to avoid the problem of
> uninitalized data becoming visible in the event of a crash.

No it doesn't. Delayed allocation minimises the problem but doesn't
prevent it.  It has been known for years (since before I joined SGI
in 2002) that there is a theoretical timing gap in XFS where the
allocation transaction can commit and a crash occur before data hits
the disk hence exposing stale data.

The reality is that no-one has ever reported exposing stale data in
this scenario, and there has been plenty of effort expended trying
to trigger it. Hence it has remained in the realm of a theoretical
problem....

> If
> fsblock immediately allocates the physical block, then either the
> unitialized data might become available on a system crash (which
> is a security problem), or XFS is going to have to force all newly
> written data blocks to disk before a commit.  If that sounds
> familiar it's what ext3's data=ordered mode does, and it's what is
> responsible for the Firefox 3.0 fsync performance problem.

If this was to occur, the obvious solution to this problem is to
allocate unwritten extents and do conversion after data I/O
completion. That would result in correct metadata/data ordering in
all cases with only a small performance impact and without
introducing ext3-sync-the-world-like issues...

Ted, I appreciate you telling the world over and over again how bad
XFS is and what you think needs to be done to fix it. Truth is, this
would have been a much better email had you written about it from an
ext4 perspective. That way it wouldn't have been full of errors or
sound like a kid caught with his hand in the cookie jar:

"It's not my fault! I was only copying XFS! He did it first!"

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

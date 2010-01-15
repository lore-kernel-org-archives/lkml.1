Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab0AONeM (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363Ab0AONeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:34:11 -0500
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:40119 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753951Ab0AONeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:34:11 -0500
Date: Sat, 16 Jan 2010 00:33:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
        Christoph Hellwig <hch@infradead.org>,
        Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: lockdep: inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R}
	usage.
Message-ID: <20100115133322.GA4172@discord.disaster>
References: <20100115120253.GH28498@discord.disaster> <1263557473.4244.399.camel@laptop> <20100115124410.GI28498@discord.disaster> <1263559995.4244.403.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263559995.4244.403.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 01:53:15PM +0100, Peter Zijlstra wrote:
> On Fri, 2010-01-15 at 23:44 +1100, Dave Chinner wrote:
> > 
> > > > I can't work out what the <mumble>RECLAIM_FS<mumble> notations are
> > > > supposed to mean from the code and they are not documented at
> > > > all, so I need someone to explain what this means before I can
> > > > determine if it is a valid warning or not....
> > > 
> > > The <mumble>RECLAIM_FS<mumble> bit means that lock (iprune_sem) was
> > > taken from reclaim and is also taken over an allocation.
> > 
> > So there's an implicit, undocumented requirement that inode reclaim
> > during unmount requires a filesystem to do GFP_NOFS allocation? 
> 
> Well, I don't know enough about xfs (of filesystems in generic) to say
> that with any certainty, but I can imagine inode writeback from the sync
> that goes with umount to cause issues.
> 
> If this inode reclaim is past all that and the filesystem is basically
> RO, then I don't think so and this could be considered a false positive,
> in which case we need an annotation for this.

The issue is that the iprune_sem is held write locked over
dispose_list() even though the inodes have been removed from the
unused list. While iprune_sem is held write locked, we can't enter
shrink_icache_memory because that takes the iprune_sem in read mode.
Hence allocation anywhere in the dispose_list path has to be
GFP_NOFS to avoid this.

XFS relies on the PF_MEMALLOC flag to clear the __GFP_FS
flag in allocations so that the same code paths work in both
normal and reclaim situations (like _xfs_trans_alloc), but the
unmount path sets no such flag. Setting this flag would
avoid the problem, but is messy.

FWIW, I'm not sure why we need to hold the iprune_sem after the
inodes have been detached from the unused list in the unmount path.
The iprune_sem is there to prevent against concurrent access by the
shrink_icache_memory path, so once all the inodes are isolated it
seems the iprune_sem is not needed anymore. Of course, this code is
a maze of twisty passages, so there's likely to be something I've
missed that means that this is the only way it can work....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

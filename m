Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbZDANKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbZDANKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZDANKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:10:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:22318 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406AbZDANKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:10:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,306,1235980800"; 
   d="scan'208";a="126583326"
Date: Wed, 1 Apr 2009 21:07:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] writeback: guard against jiffies wraparound on
	inode->dirtied_when checks (try #2)
Message-ID: <20090401130737.GA13729@localhost>
References: <1238544239-31882-1-git-send-email-jlayton@redhat.com> <20090331172031.b2971f1e.akpm@linux-foundation.org> <20090331205018.228ea5f8@tleilax.poochiereds.net> <20090331180730.049d42e7.akpm@linux-foundation.org> <20090401065618.GB10423@localhost> <20090401075320.0f49b5bf@barsoom.rdu.redhat.com> <20090401122627.GA12945@localhost> <20090401084843.560d89ea@barsoom.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401084843.560d89ea@barsoom.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 08:48:43PM +0800, Jeff Layton wrote:
> > > > --- mm.orig/fs/fs-writeback.c
> > > > +++ mm/fs/fs-writeback.c
> > > > @@ -196,7 +196,7 @@ static void redirty_tail(struct inode *i
> > > >  		struct inode *tail_inode;
> > > >  
> > > >  		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
> > > > -		if (!time_after_eq(inode->dirtied_when,
> > > > +		if (time_before(inode->dirtied_when,
> > > >  				tail_inode->dirtied_when))
> > > >  			inode->dirtied_when = jiffies;
> > > >  	}
> > > 
> > > I think we need a similar change in this function in order to maintain
> > > the list order.
> > > 
> > > Consider this case:
> > > 
> > > We have an s_dirty list with a head inode that appears to be in the
> > > future. We start writeback and clear out s_dirty (all of the inodes are
> > > moved to s_io). A new inode is dirtied, and goes onto the empty s_dirty
> > > list with a dirtied_when value that equals now. The inode with the
> > > dirtied_when value that looks like it's in the future is redirtied while
> > > being written and redirty_tail is called. It goes back on the list
> > > without resetting dirtied_when even though it's actually older than the
> > > inode at the tail.
> > 
> > What's the difference? It _is_ the past because all 2 reference sites
> > are now taught to think so.
> > 
> > So s_dirty is still in order, and the writeback process won't be blocked.
> > 
> 
> Sanity check -- my understanding is this:
> 
> head == least-recently dirtied inode
> tail == most-recently dirtied inode
> 
> ...if so, then we are violating the list order if we don't make a
> change to redirty_tail. We're putting an inode that's far in the past
> back onto the tail of the list without resetting dirtied_when. A more
> recently-dirtied inode will precede one that was dirtied less recently.
> 
> Since the newly dirtied inode is closer to the head of the list, the
> older inode that's constantly being redirtied won't be written out
> until the newly dirtied one passes the older_than_this check (30s or
> so in the usual case).

If you call that out-of-order, yes it is. Sadly it cannot be improved
by playing with dirtied_when: the _physical_ order is still the same.

You know what? That's exactly the drawback of redirtying into s_dirty.
It's irrelevant to the resetting of dirtied_when. A new s_more_io_wait
is the only way to solve this problem.

> > > There is another option too that I'll throw out here...
> > > 
> > > We could just make dirtied_when a 64 bit value on 32 bit machines and
> > > use jiffies_64 there. On the upside there is no "problematic
> > > window" with that. The downside is that struct inode would grow by 4
> > > bytes on 32 bit arches, and checking jiffies_64 on such an arch is
> > > more computationally intensive. We'd also have to change the size of
> > > older_than_this value in the writeback_control struct too if we want to
> > > go this route...
> > 
> > Yes that could eliminate the 30s or more temporary writeback stillness.
> > The only problem is the extra costs for normal cases, especially the
> > space cost.
> > 
> 
> Correct. I'm not necessarily advocating that approach but it's one to
> consider...
> 
> If your s_more_io_wait patchset comes to fruition though then that
> change really won't be needed, so maybe it's best not to go that route.

Sorry for the delay. But I'm still curious about the redirty
process&timing of NFS/XFS. The conflicts with Jens' per-bdi pdflush
patches are another concern...

Thanks,
Fengguang

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYKZVfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYKZVfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbYKZVfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:35:00 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:56942 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbYKZVe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:34:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAAROLUl5LJfT/2dsb2JhbADTVIJ9
X-IronPort-AV: E=Sophos;i="4.33,670,1220193000"; 
   d="scan'208";a="264347684"
Date: Thu, 27 Nov 2008 08:34:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dan =?iso-8859-1?B?Tm/p?= <dpn@isomerica.net>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: Lockdep warning for iprune_mutex at shrink_icache_memory
Message-ID: <20081126213454.GI6291@disturbed>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Dan =?iso-8859-1?B?Tm/p?= <dpn@isomerica.net>,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
References: <20081125064357.5a4f1420@tuna> <20081126072625.GH6291@disturbed> <1227711779.4454.184.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1227711779.4454.184.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 04:02:59PM +0100, Peter Zijlstra wrote:
> On Wed, 2008-11-26 at 18:26 +1100, Dave Chinner wrote:
> > On Tue, Nov 25, 2008 at 06:43:57AM -0500, Dan Noé wrote:
> > > I have experienced the following lockdep warning on 2.6.28-rc6.  I
> > > would be happy to help debug, but I don't know this section of code at
> > > all.
> > > 
> > > =======================================================
> > > [ INFO: possible circular locking dependency detected ]
> > > 2.6.28-rc6git #1
> > > -------------------------------------------------------
> > > rsync/21485 is trying to acquire lock:
> > >  (iprune_mutex){--..}, at: [<ffffffff80310b14>]
> > > shrink_icache_memory+0x84/0x290
> > > 
> > > but task is already holding lock:
> > >  (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffffa01fcae5>]
> > > xfs_ilock+0x75/0xb0 [xfs]
> > 
> > False positive. memory reclaim can be invoked while we
> > are holding an inode lock, which means we go:
> > 
> > 	xfs_ilock -> iprune_mutex
> > 
> > And when the inode shrinker reclaims a dirty xfs inode,
> > we go:
> > 
> > 	iprune_mutex -> xfs_ilock
> > 
> > However, this cannot deadlock as the first case can
> > only occur with a referenced inode, and the second case
> > can only occur with an unreferenced inode. Hence we can
> > never get a situation where the inode being locked on
> > either side of the iprune_mutex is the same inode so
> > deadlock is impossible.
> > 
> > To avoid this false positive, either we need to turn off
> > lockdep checking on xfs inodes (not going to happen), or memory
> > reclaim needs to be able to tell lockdep that recursion on
> > filesystem lock classes may occur. Perhaps we can add a
> > simple annotation to the iprune mutex initialisation as well as
> > the xfs ilock initialisation to indicate that such recursion
> > is possible and allowed...
> 
> This is that: an inode has multiple stages in its life-cycle, thing
> again, right?

Sort of.

> Last time I talked to Christoph about that, he said it would be possible
> to get (v)fs hooks for when the inode changes data structures as its not
> really too FS specific or was fully filesystem specific, I can't
> remember.
> 
> The thing to do is re-annotate the inode locks whenever the inode
> changes data-structure, much like we do in unlock_new_inode().

Ok, that's really changing the class of the inode lock dependent
on it's type (it's directory inode specific) during initialisation.
That is, it is setting the class for the life of the inode, not
changing it half way through it's life cycle.

> So for each stage in the inode's life-cycle you need to create a key for
> each lock, such as:
> 
> struct lock_class_key xfs_active_inode_ilock;
> struct lock_class_key xfs_deleted_inode_ilock;
> ...
> 
> and on state change do something like:
> 
>   BUG_ON(rwsem_is_locked(&xfs_ilock->mrlock));
> 
>   init_rwsem(&xfs_ilock->mrlock);
>   lockdep_set_class(&xfs_ilock->mrlock, &xfs_deleted_inode_ilock);

I don't think that is possible for XFS - we can't re-init the inode
locks safely while they are still active. Apart from the fact that
the inode locks play a critical part in EOL synchronisation
(preventing use after free), the only way we could guarantee
exclusive access to the inode to be able to re-init the locks is to
already hold the inode locks.

However, if we can change the class of the lock while it is held, we
could probably use this technique because we track the reclaimable
state of the inode and handle it specially in lookup so we have all
the infrastructure to be able to do this dynamically. Is changing
the lock class dynamically possible/allowed?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

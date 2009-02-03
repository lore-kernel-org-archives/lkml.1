Return-Path: <linux-kernel-owner+w=401wt.eu-S1752256AbZBCUSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbZBCUSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbZBCUSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:18:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbZBCUSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:18:37 -0500
Date: Tue, 3 Feb 2009 15:05:07 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: spurious -ENOSPC on XFS
In-Reply-To: <20090203032740.GG24173@disturbed>
Message-ID: <Pine.LNX.4.64.0902031459350.28433@hs20-bc2-1.build.redhat.com>
References: <20090118173144.GA1999@infradead.org>
 <Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com>
 <20090120232422.GF10158@disturbed> <20090122205913.GA30859@infradead.org>
 <20090122224347.GA18751@infradead.org> <Pine.LNX.4.64.0901231509010.5179@hs20-bc2-1.build.redhat.com>
 <20090124071249.GF32390@disturbed> <Pine.LNX.4.64.0901291136050.19368@hs20-bc2-1.build.redhat.com>
 <20090131235725.GA24173@disturbed> <Pine.LNX.4.64.0902021214310.15622@hs20-bc2-1.build.redhat.com>
 <20090203032740.GG24173@disturbed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Dave Chinner wrote:

> > No, if you turn it into a trylock, it will randomly fail if any other 
> > process is holding the lock for whatever reason. So you will still get 
> > spurious -ENOSPCs, although with lower probability.
> 
> The flush is never, ever going to be perfect. While we are blocking
> waiting for the flush, other concurrent writes could be doing more
> delayed allocation. The flush won't catch these, so we can still get
> spurious ENOSPCs even with a *perfect* flush.

So you can turn it into a loop --- while there are delayed allocations, 
flush and retry.

... and if you turn it into trylock, what are you going to do with the 
inode that is just being written to? You should definitely flush it, but 
trylock will skip it because it's already locked.

> Hence there is no point in trying to make the code perfect - we
> can look at more complex solutions if and only if the simple
> solution is not sufficient.
> 
> > > If you make the xfs_ilock() there xfs_ilock_nowait() and avoid data
> > > writeback if we don't get the lock the deadlock goes away, right?
> > 
> > But that premature ENOSPC possibility will still exist.
> > The only right solution that I see is to drop this flushing code at all 
> > (because it's unfixable), catch -ENOSPCs exactly before you are about to 
> > return them to Linux VFS, flush at this point (you are not holding any 
> > locks here) and retry.
> 
> Still not perfect as soon as you consider concurrency (as per above).
> 
> > There seems to be more bugs with forgetting to flush delayed allocation 
> > --- you should flush delayed allocation after *every* failed allocate 
> > attempt, but the code flushes it only after failed delayed allocate 
> > attempt --- i.e. nondelayed allocators, such as xfs_iomap_write_direct 
> > (and maybe other places) will still return -ENOSPC without attempting to 
> > flush other inodes with delayed allocation.
> 
> xfs_iomap_write_direct() is for direct IO, and if that fails due to
> ENOSPC, we're going to return the error rather than try to flush
> delayed allocation blocks. Users of direct IO care more about
> deterministic response than trying to use every last byte of the
> filesystem. Such users also don't tend to mix buffered writes
> (hence delayed allocation) and direct IO on the same filesystem
> precisely because of the non-deterministic nature of buffered IO.
> Hence we don't flush here.
> 
> xfs_iomap_write_allocate() does the allocation of delayed extents,
> which we've already guaranteed that there is space for due to the
> flushing in xfs_iomap_write_delay(). Hence we don't flush here,
> either.
> 
> For metadata allocations (all over the place), we take a reservation
> first

And what if the reservation fails? Do you flush in this case?

> and so we could trigger a flush in certain circumstances if
> the reservation fails (to avoid recursion and transaction subsystem
> deadlocks). However, if you are not getting spurious enospc on
> creating inodes (as opposed to writing to them) then I see no
> immediate need for flushes there, either....
> 
> > Syncing should be really moved at the topmost place.
> 
> This can only be considered a best effort flush, not a sync.
> 
> > This is what I tried: I turned that 500ms wait into a completion:
> > 
> > 
> > Use xfs_sync_inodes and not sync_blockdev. sync_blockdev writes dirty 
> > metadata buffers, it doesn't touch inodes and pages at all.
> > 
> > Also, change that 500ms delay to a wait for completion, so that the
> > behavior is not dependent on magic timeout values. XFS developers insist
> > that it can't deadlock (I hope they're right).
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> .....
> > @@ -415,6 +419,7 @@ xfs_syncd_queue_work(
> >   * has failed with ENOSPC and we are in the process of scratching our
> >   * heads, looking about for more room...
> >   */
> > +#if 0
> >  STATIC void
> >  xfs_flush_inode_work(
> >  	struct xfs_mount *mp,
> > @@ -424,16 +429,20 @@ xfs_flush_inode_work(
> >  	filemap_flush(inode->i_mapping);
> >  	iput(inode);
> >  }
> > +#endif
> >  
> >  void
> >  xfs_flush_inode(
> >  	xfs_inode_t	*ip)
> >  {
> > +#if 0
> >  	struct inode	*inode = VFS_I(ip);
> > +	DECLARE_COMPLETION_ONSTACK(completion);
> >  
> >  	igrab(inode);
> > -	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inode_work);
> > -	delay(msecs_to_jiffies(500));
> > +	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inode_work, &completion);
> > +	wait_for_completion(&completion);
> > +#endif
> 
> Why did you turn off the initial inode flush?

Because it recurses into Linux VFS layer and deadlocks.

You can avoid XFS deadlock with trylock, but you can't avoid Linux VFS 
deadlocks --- you just must not call it.

> >  }
> >  
> >  /*
> > @@ -446,7 +455,7 @@ xfs_flush_device_work(
> >  	void		*arg)
> >  {
> >  	struct inode	*inode = arg;
> > -	sync_blockdev(mp->m_super->s_bdev);
> > +	xfs_sync_inodes(mp, SYNC_DELWRI | SYNC_IOWAIT);
> >  	iput(inode);
> 
> This should be:
> 
> 	xfs_sync_inodes(mp, SYNC_DELWRI);
> 	xfs_sync_inodes(mp, SYNC_DELWRI | SYNC_IOWAIT);
> 
> As it will flush the inodes asynchronously and then the second
> pass will wait for all the IO to complete. That will be much
> more efficient than synchronous flushing.

I see, I didn't know about this trick.

Mikulas

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

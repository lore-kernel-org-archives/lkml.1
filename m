Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbZAaX5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbZAaX5i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 18:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZAaX5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 18:57:30 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:28785 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848AbZAaX53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 18:57:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAORzhEl5LJ2q/2dsb2JhbADHX4QUBg
X-IronPort-AV: E=Sophos;i="4.37,357,1231075800"; 
   d="scan'208";a="307530372"
Date: Sun, 1 Feb 2009 10:57:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090131235725.GA24173@disturbed>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org
References: <20090113214949.GN8071@disturbed> <Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com> <20090118173144.GA1999@infradead.org> <Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com> <20090120232422.GF10158@disturbed> <20090122205913.GA30859@infradead.org> <20090122224347.GA18751@infradead.org> <Pine.LNX.4.64.0901231509010.5179@hs20-bc2-1.build.redhat.com> <20090124071249.GF32390@disturbed> <Pine.LNX.4.64.0901291136050.19368@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901291136050.19368@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 11:39:00AM -0500, Mikulas Patocka wrote:
> On Sat, 24 Jan 2009, Dave Chinner wrote:
> > On Fri, Jan 23, 2009 at 03:14:30PM -0500, Mikulas Patocka wrote:
> > > If I placed
> > > xfs_sync_inodes(ip->i_mount, SYNC_DELWRI);
> > > xfs_sync_inodes(ip->i_mount, SYNC_DELWRI | SYNC_IOWAIT);
> > > directly to xfs_flush_device, I got lock dependency warning (though not a 
> > > real deadlock).
> > 
> > Same reason memory reclaim gives lockdep warnings on XFS - we're
> > recursing into operations that take inode locks while we currently
> > hold an inode lock.  However, it shouldn't deadlock because
> > we should ever try to take the iolock on the inode that we current
> > hold it on.
> > 
> > > So synchronous flushing definitely needs some thinking and lock 
> > > rearchitecting.
> > 
> > No, not at all. At most the grabbing of the iolock in
> > xfs_sync_inodes_ag() needs to become a trylock....
> 
> You are wrong, the comments in the code are right. It really
> deadlocks if it is modified to use synchronous wait for the end of
> the flush and if the flush is done with xfs_sync_inodes:
> 
> xfssyncd      D 0000000000606808     0  4819      2
> Call Trace:
>  [0000000000606788] rwsem_down_failed_common+0x1ac/0x1d8
>  [0000000000606808] rwsem_down_read_failed+0x24/0x34
>  [0000000000606848] __down_read+0x30/0x40
>  [0000000000468a64] down_read_nested+0x48/0x58
>  [00000000100e6cc8] xfs_ilock+0x48/0x8c [xfs]
>  [000000001011018c] xfs_sync_inodes_ag+0x17c/0x2dc [xfs]
>  [000000001011034c] xfs_sync_inodes+0x60/0xc4 [xfs]
>  [00000000101103c4] xfs_flush_device_work+0x14/0x2c [xfs]
>  [000000001010ff1c] xfssyncd+0x110/0x174 [xfs]
>  [000000000046556c] kthread+0x54/0x88
>  [000000000042b2a0] kernel_thread+0x3c/0x54
>  [00000000004653b8] kthreadd+0xac/0x160

So it is stuck:

127                 /*
128                  * If we have to flush data or wait for I/O completion
129                  * we need to hold the iolock.
130                  */
131                 if ((flags & SYNC_DELWRI) && VN_DIRTY(inode)) {
132     >>>>>>>>            xfs_ilock(ip, XFS_IOLOCK_SHARED);
133                         lock_flags |= XFS_IOLOCK_SHARED;
134                         error = xfs_flush_pages(ip, 0, -1, fflag, FI_NONE);
135                         if (flags & SYNC_IOWAIT)
136                                 xfs_ioend_wait(ip);
137                 }

Given that we are stuck on the iolock in xfs_sync_inodes_ag(), I
suspect you should re-read my comments above about "lock
re-architecting" ;).

If you make the xfs_ilock() there xfs_ilock_nowait() and avoid data
writeback if we don't get the lock the deadlock goes away, right?

BTW, can you post the patch you are working on?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

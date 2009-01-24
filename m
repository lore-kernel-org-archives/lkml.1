Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZAXHNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZAXHNJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 02:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbZAXHMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 02:12:55 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:62214 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbZAXHMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 02:12:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtACAEpOekl5LAUpgWdsb2JhbACTewEBFiK2AIVM
X-IronPort-AV: E=Sophos;i="4.37,316,1231075800"; 
   d="scan'208";a="274278729"
Date: Sat, 24 Jan 2009 18:12:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090124071249.GF32390@disturbed>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com> <20090113214949.GN8071@disturbed> <Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com> <20090118173144.GA1999@infradead.org> <Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com> <20090120232422.GF10158@disturbed> <20090122205913.GA30859@infradead.org> <20090122224347.GA18751@infradead.org> <Pine.LNX.4.64.0901231509010.5179@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901231509010.5179@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 03:14:30PM -0500, Mikulas Patocka wrote:
> 
> 
> On Thu, 22 Jan 2009, Christoph Hellwig wrote:
> 
> > On Thu, Jan 22, 2009 at 03:59:13PM -0500, Christoph Hellwig wrote:
> > > On Wed, Jan 21, 2009 at 10:24:22AM +1100, Dave Chinner wrote:
> > > > Right, so you need to use internal xfs sync functions that don't
> > > > have these problems. That is:
> > > > 
> > > > 	error = xfs_sync_inodes(ip->i_mount, SYNC_DELWRI|SYNC_WAIT);
> > > > 
> > > > will do a blocking flush of all the inodes without deadlocks occurring.
> > > > Then you can remove the 500ms wait.
> > > 
> > > I've given this a try with Eric's testcase from #724 in the oss bugzilla,
> > > but it's not enough yet.  I thinks that's because SYNC_WAIT is rather
> > > meaningless for data writeout, and we need SYNC_IOWAIT instead.  The
> > > patch below gets the testcase working for me:
> > 
> > Actually I still see failures happing sometimes.  I guess tha'ts because
> > our flush is still asynchronous due to the schedule_work..
> 
> If I placed
> xfs_sync_inodes(ip->i_mount, SYNC_DELWRI);
> xfs_sync_inodes(ip->i_mount, SYNC_DELWRI | SYNC_IOWAIT);
> directly to xfs_flush_device, I got lock dependency warning (though not a 
> real deadlock).

Same reason memory reclaim gives lockdep warnings on XFS - we're
recursing into operations that take inode locks while we currently
hold an inode lock.  However, it shouldn't deadlock because
we should ever try to take the iolock on the inode that we current
hold it on.

> So synchronous flushing definitely needs some thinking and lock 
> rearchitecting.

No, not at all. At most the grabbing of the iolock in
xfs_sync_inodes_ag() needs to become a trylock....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

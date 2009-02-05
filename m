Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbZBEHoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbZBEHoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 02:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZBEHn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 02:43:59 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:20322 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbZBEHn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 02:43:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAL8kikl5LClx/2dsb2JhbADQN4QWBg
X-IronPort-AV: E=Sophos;i="4.37,384,1231075800"; 
   d="scan'208";a="283345662"
Date: Thu, 5 Feb 2009 18:43:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090205074353.GN24173@disturbed>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org
References: <20090122224347.GA18751@infradead.org> <Pine.LNX.4.64.0901231509010.5179@hs20-bc2-1.build.redhat.com> <20090124071249.GF32390@disturbed> <Pine.LNX.4.64.0901291136050.19368@hs20-bc2-1.build.redhat.com> <20090131235725.GA24173@disturbed> <Pine.LNX.4.64.0902021214310.15622@hs20-bc2-1.build.redhat.com> <20090203032740.GG24173@disturbed> <Pine.LNX.4.64.0902031459350.28433@hs20-bc2-1.build.redhat.com> <20090204120852.GK24173@disturbed> <Pine.LNX.4.64.0902042310240.27204@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0902042310240.27204@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 11:31:25PM -0500, Mikulas Patocka wrote:
> > > ... and if you turn it into trylock, what are you going to do with the 
> > > inode that is just being written to? You should definitely flush it, but 
> > > trylock will skip it because it's already locked.
> > 
> > We've already flushed it directly. You disabled that code fearing
> > deadlocks. I've made it synchronous (i.e. not handed off to
> > xfssyncd) because the flush path requires us to hold the lock we are
> > already holding....
> 
> This is not "fearing deadlocks". This was getting a real deadlock:

<sigh>

Thank you for *finally* telling me exactly what the deadlock is that
you've been handwaving about for the last week. It's not a VFS
deadlock, nor is it an inode lock deadlock - its a page lock deadlock.

Perhaps next time you will post the stack trace instead of vaguely
describing a deadlock so you don't waste several hours of another
developer's time looking for deadlocks in all the wrong places?

> This one was obtained on a machine with 4k filesystem blocks, 8k pages and 
> dd bs=1 on a nearly full filesystem.

That's helpful, too. I can write a test case to exercise that.

So, now I understand why you were suggesting going all the way back up
to the top of the IO path and flushing from there - so we don't hold
a page lock.

Perhaps we should just cull the direct inode flush completely.
If that inode has any significant delayed allocation space on it,
then the only reason it gets to an ENOSPC is that is has converted
all the speculative preallocation that it already has reserved
and is trying to allocate new space. Hence flushing it will not
return any extra space.

Hmmmmm - given that we hold the iolock exclusively, the trylock I
added into xfs_sync_inodes_ag() will fail on the inode we currently
hold page locks on (tries to get iolock shared) so that should avoid
deadlock on the page we currently hold locked.  Can you remove the
direct inode flush and just run with the modified device flush to see
if that triggers the deadlock you've been seeing?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

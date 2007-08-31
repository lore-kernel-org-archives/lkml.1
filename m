Return-Path: <linux-kernel-owner+w=401wt.eu-S965553AbXHaNvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965553AbXHaNvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 09:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965160AbXHaNvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 09:51:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60997 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965092AbXHaNvK (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 09:51:10 -0400
Date: Fri, 31 Aug 2007 23:50:42 +1000
From: David Chinner <dgc@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs-oss <xfs@oss.sgi.com>, Dave Chinner <dgc@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Increase lockdep MAX_LOCK_DEPTH
Message-ID: <20070831135042.GD422459@sgi.com>
References: <46D79C62.1010304@sandeen.net> <1188542389.6112.44.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188542389.6112.44.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 08:39:49AM +0200, Peter Zijlstra wrote:
> On Thu, 2007-08-30 at 23:43 -0500, Eric Sandeen wrote:
> > The xfs filesystem can exceed the current lockdep 
> > MAX_LOCK_DEPTH, because when deleting an entire cluster of inodes,
> > they all get locked in xfs_ifree_cluster().  The normal cluster
> > size is 8192 bytes, and with the default (and minimum) inode size 
> > of 256 bytes, that's up to 32 inodes that get locked.  Throw in a 
> > few other locks along the way, and 40 seems enough to get me through
> > all the tests in the xfsqa suite on 4k blocks.  (block sizes
> > above 8K will still exceed this though, I think)
> 
> As 40 will still not be enough for people with larger block sizes, this
> does not seems like a solid solution. Could XFS possibly batch in
> smaller (fixed sized) chunks, or does that have significant down sides?

The problem is not filesystem block size, it's the xfs inode cluster buffer
size / the size of the inodes that determines the lock depth. the common case
is 8k/256 = 32 inodes in a buffer, and they all get looked during inode
cluster writeback.

This inode writeback clustering is one of the reasons XFS doesn't suffer from
atime issues as much as other filesystems - it doesn't need to do as much I/O
to write back dirty inodes to disk.

IOWs, we are not going to make the inode clusters smallers - if anything they
are going to get *larger* in future so we do less I/O during inode writeback
than we do now.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

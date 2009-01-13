Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbZAMVuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbZAMVuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZAMVty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:49:54 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:1841 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835AbZAMVtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:49:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvcDAEuYbEl5LDnlgWdsb2JhbACUGgEBFiK6YIVv
X-IronPort-AV: E=Sophos;i="4.37,261,1231075800"; 
   d="scan'208";a="292881441"
Date: Wed, 14 Jan 2009 08:49:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090113214949.GN8071@disturbed>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 06:14:36AM -0500, Mikulas Patocka wrote:
> Hi
> 
> I discovered a bug in XFS in delayed allocation.
> 
> When you take a small partition (52MB in my case) and copy many small 
> files on it (source code) that barely fits there, you get -ENOSPC. Then 
> sync the partition, some free space pops up, click "retry" in MC an the 
> copy continues. They you get again -ENOSPC, you must sync, click "retry" 
> and go on. And so on few times until the source code finally fits on the 
> XFS partition.

Not a Bug. This is by design.

> This misbehavior is apparently caused by delayed allocation, delayed 
> allocation does not exactly know how much space will be occupied by data, 
> so it makes some upper bound guess.

No, we know *exactly* how much space is consumed by the data. What
we don't know is how much space will be required for additional
*metadata* to do the allocation so we reserve the worst case need so
hat we should never get an ENOSPC during async writeback when we
can't report the error to anyone.  Worst case is 4 metadata blocks
per allocation (delalloc extent, really).

If we ENOSPC in the delalloc path, we have two choices:

	1. potentially lock the system up due to OOM and being
	   unable to flush pages
	2. throw away user data without being able to report an
	   error to the application that wrote it originally.

Personally, I don't like either option, so premature ENOSPC at
write() time is fine by me....

> Because free space count is only a 
> guess, not the actual data being consumed, XFS should not return -ENOSPC 
> on behalf of it. When the free space overflows, XFS should sync itself, 
> retry allocation and only return -ENOSPC if it fails the second time, 
> after the sync.

It does, by graduated response (see xfs_iomap_write_delay() and
xfs_flush_space()):

	1. trigger async flush of the inode and retry
	2. retry again
	3. start a filesystem wide flush, wait 500ms and try again
	4. really ENOSPC now.

It could probably be improved but, quite frankly, XFS wasn't designed
for small filesystems so I don't think this is worth investing any
major effort in changing/fixing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

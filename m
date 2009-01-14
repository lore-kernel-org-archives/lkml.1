Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbZANE3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbZANE3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 23:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZANE3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 23:29:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbZANE3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 23:29:11 -0500
Date: Tue, 13 Jan 2009 23:28:58 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Dave Chinner <david@fromorbit.com>
cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: spurious -ENOSPC on XFS
In-Reply-To: <20090113214949.GN8071@disturbed>
Message-ID: <Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
 <20090113214949.GN8071@disturbed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This misbehavior is apparently caused by delayed allocation, delayed 
> > allocation does not exactly know how much space will be occupied by data, 
> > so it makes some upper bound guess.
> 
> No, we know *exactly* how much space is consumed by the data. What
> we don't know is how much space will be required for additional
> *metadata* to do the allocation so we reserve the worst case need so
> hat we should never get an ENOSPC during async writeback when we
> can't report the error to anyone.  Worst case is 4 metadata blocks
> per allocation (delalloc extent, really).
> 
> If we ENOSPC in the delalloc path, we have two choices:
> 
> 	1. potentially lock the system up due to OOM and being
> 	   unable to flush pages
> 	2. throw away user data without being able to report an
> 	   error to the application that wrote it originally.
> 
> Personally, I don't like either option, so premature ENOSPC at
> write() time is fine by me....
> 
> > Because free space count is only a 
> > guess, not the actual data being consumed, XFS should not return -ENOSPC 
> > on behalf of it. When the free space overflows, XFS should sync itself, 
> > retry allocation and only return -ENOSPC if it fails the second time, 
> > after the sync.
> 
> It does, by graduated response (see xfs_iomap_write_delay() and
> xfs_flush_space()):
> 
> 	1. trigger async flush of the inode and retry
> 	2. retry again
> 	3. start a filesystem wide flush, wait 500ms and try again

The result must not depend on magic timer values. If it does, you end up 
with undebbugable nondeterministic failures.

Why don't you change that 500ms wait to "wait until the flush finishes"? 
That would be correct.

> 	4. really ENOSPC now.
> 
> It could probably be improved but, quite frankly, XFS wasn't designed
> for small filesystems so I don't think this is worth investing any
> major effort in changing/fixing.
> 
> Cheers,
> 
> Dave.

Mikulas

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391Ab0ATKyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab0ATKyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 05:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325Ab0ATKyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 05:54:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab0ATKyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 05:54:14 -0500
Subject: Re: lockdep: inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R}
 usage.
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Dave Chinner <david@fromorbit.com>,
       linux-kernel@vger.kernel.org, mingo@redhat.com,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk
In-Reply-To: <20100119184631.GA11408@infradead.org>
References: <20100115120253.GH28498@discord.disaster>
	 <1263557473.4244.399.camel@laptop>
	 <20100115124410.GI28498@discord.disaster>
	 <1263559995.4244.403.camel@laptop>  <20100119184631.GA11408@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 20 Jan 2010 10:57:01 +0000
Message-ID: <1263985021.2528.34.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2010-01-19 at 13:46 -0500, Christoph Hellwig wrote:
> On Fri, Jan 15, 2010 at 01:53:15PM +0100, Peter Zijlstra wrote:
> > Well, I don't know enough about xfs (of filesystems in generic) to say
> > that with any certainty, but I can imagine inode writeback from the sync
> > that goes with umount to cause issues.
> > 
> > If this inode reclaim is past all that and the filesystem is basically
> > RO, then I don't think so and this could be considered a false positive,
> > in which case we need an annotation for this.
> 
> The issue is a bit more complicated.  In the unmount case
> invalidate_inodes() is indeed called after the filesystem is effectively
> read-only for user origination operations.  But there's a miriad of
> other invalidate_inodes() calls:
> 
>  - fs/block_dev.c:__invalidate_device()
> 
> 	This gets called from block device codes for various kinds of
> 	invalidations.  Doesn't make any sense at all to me, but hey..
> 
>  - fs/ext2/super.c:ext2_remount()
> 
> 	Appears like it's used to check for activate inodes during
> 	remount.  Very fishy usage, and could just be replaced with
> 	a list walk without any I/O
> 
>  - fs/gfs2/glock.c:gfs2_gl_hash_clear()
> 
> 	No idea.
> 
Its rather complicated and all down to using "special" inodes to cache
metadata so that GFS2 has two VFS inodes per "real" inode, one as per
normal and one just to cache metadata.

This causes a circular dependency between glocks and inodes since we
have something like this (in my best ascii art):

gfs2 inode -> iopen glock
           -> inode glock -> metadata inode

So at umount time, historically we've had to invalidate inodes once, and
then get rid of the inode glocks which implied a iput() on the metadata
inode and then invalidate inodes again to be rid of the metadata inodes.

This has been the source of many problems at umount time. In my -nmw git
tree at the moment, there are a couple of patches which are aimed at
fixing this issue. The solution is to embed a struct address_space in
each glock which caches metadata, rather than a complete inode.

>  - fs/gfs2/ops_fstype.c:fill_super()
> 
> 	Tries to kill all inodes in the fill_super error path, looks
> 	very fishy.
> 
For the same reason as above.

It should be possible to remove one or even both of these calls now. The
two patches in the -nmw tree do the bare minimum really to make the
change, but it should be possible to do a bit more clean up in that
area now,

Steve.



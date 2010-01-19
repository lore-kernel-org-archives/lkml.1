Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235Ab0ASSqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab0ASSqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 13:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859Ab0ASSqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 13:46:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab0ASSqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 13:46:34 -0500
Date: Tue, 19 Jan 2010 13:46:31 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, swhiteho@redhat.com
Subject: Re: lockdep: inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R}
	usage.
Message-ID: <20100119184631.GA11408@infradead.org>
References: <20100115120253.GH28498@discord.disaster> <1263557473.4244.399.camel@laptop> <20100115124410.GI28498@discord.disaster> <1263559995.4244.403.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263559995.4244.403.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 01:53:15PM +0100, Peter Zijlstra wrote:
> Well, I don't know enough about xfs (of filesystems in generic) to say
> that with any certainty, but I can imagine inode writeback from the sync
> that goes with umount to cause issues.
> 
> If this inode reclaim is past all that and the filesystem is basically
> RO, then I don't think so and this could be considered a false positive,
> in which case we need an annotation for this.

The issue is a bit more complicated.  In the unmount case
invalidate_inodes() is indeed called after the filesystem is effectively
read-only for user origination operations.  But there's a miriad of
other invalidate_inodes() calls:

 - fs/block_dev.c:__invalidate_device()

	This gets called from block device codes for various kinds of
	invalidations.  Doesn't make any sense at all to me, but hey..

 - fs/ext2/super.c:ext2_remount()

	Appears like it's used to check for activate inodes during
	remount.  Very fishy usage, and could just be replaced with
	a list walk without any I/O

 - fs/gfs2/glock.c:gfs2_gl_hash_clear()

	No idea.

 - fs/gfs2/ops_fstype.c:fill_super()

	Tries to kill all inodes in the fill_super error path, looks
	very fishy.

 - fs/ntfs/super.c:ntfs_fill_super()

	Failure case of fill_super again, does not look very useful.A

 - fs/smbfs/inode.c:smb_invalidate_inodes()

	Used when a connection goes bad.

In short we can't generally rely on this only happening on a dead fs.


But in the end we abuse iprune_sem to work around a ref counting
problem.  As long as we keep a reference to the superblock for each
inode on the dispose list the superblock can't go away and there's
no need for the lock at all.

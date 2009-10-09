Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbZJIKIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbZJIKIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760555AbZJIKIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:08:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38893 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760478AbZJIKIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:08:49 -0400
Date: Fri, 9 Oct 2009 12:08:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>, chris.mason@oracle.com
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091009100812.GV9228@kernel.dk>
References: <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain> <20091008123622.GA30316@wotan.suse.de> <20091008125746.GL9228@kernel.dk> <20091008132200.GB30316@wotan.suse.de> <20091009085451.GS9228@kernel.dk> <20091009095119.GT9228@kernel.dk> <20091009100249.GD17818@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009100249.GD17818@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09 2009, Nick Piggin wrote:
> On Fri, Oct 09, 2009 at 11:51:19AM +0200, Jens Axboe wrote:
> > Nick,
> > 
> > One more thing... I see you converted part of btrfs, but there's still
> > this one sitting in btrfs_invalidate_inodes()
> > 
> >         if (atomic_read(&inode->i_count) > 1)
> >                 d_prune_aliases(inode);
> > 
> > Not sure how best to solve that, with a __d_prune_aliases() that assumed
> > the lock was held it would be easy. But perhaps you have better ideas,
> > this email is more of a heads-up since perhaps you missed this spot
> > (CC'ing Chris).
> 
> It's OK, you can load inode->i_count integer atomically -- in this
> sequence d_prune_aliases can't have assumed anything about i_count
> anyway because regardless of its type it might have changed in
> between.

Right, it was already racy wrt i_count. So the below should be OK.

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d3dadb6..7e02b5d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3419,8 +3419,10 @@ again:
 		inode = igrab(&entry->vfs_inode);
 		if (inode) {
 			spin_unlock(&root->inode_lock);
-			if (atomic_read(&inode->i_count) > 1)
+
+			if (inode->i_count > 1)
 				d_prune_aliases(inode);
+
 			/*
 			 * btrfs_drop_inode will remove it from
 			 * the inode cache when its usage count

-- 
Jens Axboe


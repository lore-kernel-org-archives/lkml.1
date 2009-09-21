Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZIUNkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZIUNkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZIUNkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:40:42 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37126 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbZIUNkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:40:39 -0400
Date: Mon, 21 Sep 2009 15:40:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] fs: Fix busyloop in wb_writeback()
Message-ID: <20090921134042.GY23126@kernel.dk>
References: <1253121768-20673-1-git-send-email-jack@suse.cz> <20090916184106.GT23126@kernel.dk> <20090921130145.GA6266@localhost> <20090921130634.GX23126@kernel.dk> <20090921131057.GA15703@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921131057.GA15703@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21 2009, Wu Fengguang wrote:
> On Mon, Sep 21, 2009 at 09:06:34PM +0800, Jens Axboe wrote:
> > On Mon, Sep 21 2009, Wu Fengguang wrote:
> > > On Thu, Sep 17, 2009 at 02:41:06AM +0800, Jens Axboe wrote:
> > > > On Wed, Sep 16 2009, Jan Kara wrote:
> > > > > If all inodes are under writeback (e.g. in case when there's only one inode
> > > > > with dirty pages), wb_writeback() with WB_SYNC_NONE work basically degrades
> > > > > to busylooping until I_SYNC flags of the inode is cleared. Fix the problem by
> > > > > waiting on I_SYNC flags of an inode on b_more_io list in case we failed to
> > > > > write anything.
> > > > 
> > > > Interesting, so this will happen if the dirtier and flush thread end up
> > > > "fighting" each other over the same inode. I'll throw this into the
> > > > testing mix.
> > > > 
> > > > How did you notice?
> > > 
> > > Jens, I found another busy loop. Not sure about the solution, but here
> > > is the quick fact.
> > > 
> > > Tested git head is 1ef7d9aa32a8ee054c4d4fdcd2ea537c04d61b2f, which
> > > seems to be the last writeback patch in the linux-next tree. I cannot
> > > run the plain head of linux-next because it just refuses boot up.
> > > 
> > > On top of which Jan Kara's I_SYNC waiting patch and the attached
> > > debugging patch is applied.
> > > 
> > > Test commands are:
> > > 
> > >         # mount /mnt/test # ext4 fs
> > >         # echo 1 > /proc/sys/fs/dirty_debug
> > > 
> > >         # cp /dev/zero /mnt/test/zero0
> > > 
> > > After that the box is locked up, the system is busy doing these:
> > > 
> > > [   54.740295] requeue_io() +457: inode=79232
> > > [   54.740300] mm/page-writeback.c +539 balance_dirty_pages(): comm=cp pid=3327 n=0
> > > [   54.740303] global dirty=60345 writeback=10145 nfs=0 flags=_M towrite=1536 skipped=0
> > > [   54.740317] requeue_io() +457: inode=79232
> > > [   54.740322] mm/page-writeback.c +539 balance_dirty_pages(): comm=cp pid=3327 n=0
> > > [   54.740325] global dirty=60345 writeback=10145 nfs=0 flags=_M towrite=1536 skipped=0
> > > [   54.740339] requeue_io() +457: inode=79232
> > > [   54.740344] mm/page-writeback.c +539 balance_dirty_pages(): comm=cp pid=3327 n=0
> > > [   54.740347] global dirty=60345 writeback=10145 nfs=0 flags=_M towrite=1536 skipped=0
> > > ......
> > > 
> > > Basically the traces show that balance_dirty_pages() is busy looping.
> > > It cannot write anything because the inode always be requeued by this line:
> > > 
> > >         if (inode->i_state & I_SYNC) {
> > >                if (!wait) {
> > >                         requeue_io(inode);
> > >                         return 0;
> > >                 }
> > > 
> > > This seem to happen when the partition is FULL.
> > 
> > OK, I'll have to look into these issues soonish. I'll be travelling next
> > week though, so I cannot do more about it right now. If you have time to
> > work on tested patches, then that would be MUCH appreciated it!
> 
> Jens, your bug fix patches arrive just before I submit this bug report :)

Good!

-- 
Jens Axboe


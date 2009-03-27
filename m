Return-Path: <linux-kernel-owner+w=401wt.eu-S1757739AbZC0TUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739AbZC0TUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZC0TU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:20:26 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:30023 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZC0TUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:20:25 -0400
Subject: Re: Linux 2.6.29
From: Chris Mason <chris.mason@oracle.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090327075723.GT27476@kernel.dk>
References: <20090324132032.GK5814@mit.edu>
	 <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain>
	 <20090324184549.GE32307@mit.edu>
	 <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain>
	 <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk>
	 <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk>
	 <49CA9346.6040108@garzik.org>
	 <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain>
	 <20090327075723.GT27476@kernel.dk>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 15:14:54 -0400
Message-Id: <1238181294.27455.197.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.49CD25B4.0037:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 08:57 +0100, Jens Axboe wrote:
> On Wed, Mar 25 2009, Linus Torvalds wrote:
> > 
> > 
> > On Wed, 25 Mar 2009, Jeff Garzik wrote:
> > > 
> > > It is clearly possible to implement an fsync(2) that causes FLUSH CACHE to be
> > > issued, without adding full barrier support to a filesystem.  It is likely
> > > doable to avoid touching per-filesystem code at all, if we issue the flush
> > > from a generic fsync(2) code path in the kernel.
> > 
> > We could easily do that. It would even work for most cases. The 
> > problematic ones are where filesystems do their own disk management, but I 
> > guess those people can do their own fsync() management too.
> > 
> > Somebody send me the patch, we can try it out.
> 
> Here's a simple patch that does that. Not even tested, it compiles. Note
> that file systems that currently do blkdev_issue_flush() in their
> ->sync() should then get it removed.
> 

The filesystems vary a bit, but in general the perfect fsync (in a mail
server workload) works something like this:

step1: write out and wait for any dirty data
step2: join the running transaction

step3: hang around a bit and wait for friends and neighbors

step4: commit the transaction

step4a: write the log blocks
step4b: barrier.  This barrier also makes sure the data is on disk

step4c: write the commit block

step4d: barrier.  This barrier makes sure the commit block is on disk.

For ext34 and reiserfs, steps 4b,c,d are actually one call to submit_bh
where two caches flushes are done for us, but they really are two cache
flushes.

During step 3, we collect a bunch of other procs who are hopefully also
running fsync.  If we collect 50 procs, then single the barrier in step
5b does a cache flush on the data writes of all 50.  50 flushes this
patch does would be one flush if the FS did it right.

In a multi-process fsync heavy workload, every extra barrier is going to
have work to do because someone is always sending data down.

The flushes done by this patch also aren't helpful for the journaled
filesystem.  If we remove the barriers from step 4b or 4d, we no longer
have a consistent FS on power failure.  Log checksumming may allow us to
get rid of the barrier in step 4b, but then we wouldn't know the data
blocks were on disk before the transaction commit, and we've had a few
discussions on that already over the last two weeks.

The patch also assumes the FS has one bdev, which isn't true for btrfs.

xfs and btrfs at least want more control over that
filemap_fdatawrite/wait step because we have to repeat it inside the FS
anyway to make sure the inode properly updated before the commit.  I'd
much rather see a dumb fsync helper that looks like Jens' vfs_fsync, and
then let the filesystems make their own replacement for the helper in a
new address space operation or super operation.

That way we could also run the fsync on directories without the
directory mutex held, which is much faster.

Also, the patch is sending the return value from blkdev_issue_flush out
through vfs_fsync, which means I think it'll send -EOPNOTSUPP out to
userland.

So, I should be able to run any benchmark that does an fsync with this
patch and find large regressions.  It turns out it isn't quite that
easy.

First, I found that ext4 has a neat feature where it is already doing an
extra barrier on every fsync.

Even with that removed, the flushes made ext4 faster (doh!).  Looking at
the traces, ext4 and btrfs (which is totally unchanged by this patch)
both do a good job of turning my simple fsync hammering programs into
mostly sequential IO.

The extra flushes are just writing mostly sequential IO, and so they
aren't really hurting overall tput.  Plus, Ric reminded me the drive may
have some pass through for larger sequential writes, and ext4 and btrfs
may be doing enough to trigger that.

I should be able to run more complex benchmarks and get really bad
numbers out of this patch with ext4, but instead I'll try ext3...
  
This is a simple run with fs_mark using 64 threads to create 20k files
with fsync.  I timed how long it took to create 900 files.  Lower
numbers are better.

      unpatched    patched
ext3    236s         286s

-chris



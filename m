Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXCLCOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXCLCOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 22:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXCLCOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 22:14:03 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60526 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbXCLCOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 22:14:00 -0400
Date: Sun, 11 Mar 2007 19:13:38 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] fs: introduce perform_write aop
Message-ID: <20070312021337.GD18555@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070208105458.26443.41479.sendpatchset@linux.site> <20070309103913.GA4503@infradead.org> <20070309233301.GC18555@ca-server1.us.oracle.com> <20070310092541.GA22182@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310092541.GA22182@infradead.org>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 09:25:41AM +0000, Christoph Hellwig wrote:
> On Fri, Mar 09, 2007 at 03:33:01PM -0800, Mark Fasheh wrote:
> > ->kernel_write() as opposed to genericizing ->perform_write() would be fine
> > with me. Just so long as we get rid of ->prepare_write and ->commit_write in
> > that other kernel code doesn't call them directly. That interface just
> > doesn't work for Ocfs2.
> 
> It doesn't work for any filesystem that needs slightly fancy locking.
> That and the reason that's an interface that doesn't fit into our
> layering is why I want to get rid of it.  Note that fops->kernel_write
> might in fact use ->perform_write with an actor as Nick suggested.
> I'm not quite sure how it'll look like - I'd rather take care of the
> buffered write path first and then handle this issue once the first
> changes have stabilized.
> 
> > Right now I've got Ocfs2 implementing it's own lowest-level buffered write
> > code - think generic_file_buffered_write() replacement for Ocfs2. With some
> > duplicated code above that layer. What's nice is that I can abstract away
> > the "copy data into some target pages" bits such that the majority of that
> > code is re-usable for ocfs2's splice write operation. I'm not sure we could
> > have that low a level of abstraction for anyhing above individual the file
> > system though which also has to deal with non-kernel writes though. That's
> > where a ->kernel_write() might come in handy.
> 
> Why do you need your own low level buffered write functionality?  As in
> past times when filesystems want to come up I'd like to have a very
> good exaplanation on why you think it's needed and whether we shouldn't
> improve the generic buffered write code instead.

Fair enough - I personally tried everything I could before coming to the
conclusion that for the time being, Ocfs2 should have a seperate write path.

As you know, I've been adding sparse file support for Ocfs2. Putting aside
all the reasons to have real support for sparse files (as opposed to zeroing
allocated regions), the tree code changes alone has gotten us 90% the way to
supporting unwritten extents (much like xfs does).

Ocfs2 supports atomic data allocation units ('clusters', to use an
overloaded term) which can range in size from 4k to 1 meg. This means that
for allocating writes on page size < cluster size file systems, we have to
zero pages adjacent to the one being written so that a re-read doesn't
return dirty data. This alone requires page locking which we can't
realistically achieve via ->prepare_write() and ->commit_write(). I believe
NTFS has a similar restriction, which has lead to their own file write.

So, page locking was definitely the straw that broke the camels back. Some
other things which were akward or slightly less critically broken than the
page locking:

Since ocfs2 has a rather large (compared to a local file system) context to
build up during an allocating write, it became uncomfortable to pass that
around ->prepare_write() and ->commit_write() without putting that context
on our struct inode and protecting it with a lock. And since the existing
interfaces were so rigid, it actually required a lot more context to be
passed around than in my current code.

There's also the cluster lock / page lock inversion which we have to deal
with (it gets even worse if we fault in pages in the middle of the user copy
for a write). Granted, we fixed a lot of that before merging, but allocating
in write means taking even more cluster locks and I don't really feel
comfortable nesting so many of those within the page locks.

Finally, we get to the optimization problem - writing stuff one page at a
time. To be fair, my current stuff doesn't do a very good job of optimizing
the amount of data written in a given pass, but the groundwork is there to
easily write at least one clusters worth of user data at a time. My priority
has been mostly to stabilize it as opposed to performance tuning.

So, quite possibly, I overstated what Ocfs2 was doing earlier - we still
make use of as much generic code as we can. The O_DIRECT path for instance
wasn't touched. Ocfs2 still makes use of block_commit_write(), the standard
jbd mechanisms for ordered data mode, and though we got rid of
block_prepare_write() (for zeroing reasons), what we do is a much simpler
version.

By the way, the code in question can be found in the sparse_files branch of
ocfs2.git:

http://git.kernel.org/?p=linux/kernel/git/mfasheh/ocfs2.git;a=log;h=sparse_files

Your review has been extremely useful in the past, so I welcome any comments
you might have.

Though it's getting close to being put in ALL (for a spin in -mm), it's
definitely a work in progress branch. There's 3 patches to generic code
which I need to push out for review (it's pretty much just exporting symbols
which we'd need in any case). Also, some of the bug fixes and feature
adjustments need to get folded back into their respective patches.

> This codepath is so nasty that any duplication will be a maintaince
> horror.

All that said above, I agree that duplication sucks - it's what I've had to
do for the time being, but I'm 100% keen on re-merging things into a generic
path once we sort it out. Hence my interest in this thread. The Ocfs2 write
changes are almost complete and are testing well, so I think I'm in a good
position to start working on some of this stuff now.

I'm hoping that ->perform_write() can become the interface that Ocfs2 plugs
into. Just to list things out, here's the requirements I could come up with
off the top of my head:
  - allow locking of pages for zeroing
  - fault in user data before taking cluster locks and target inode page
    locks
  - give us enough information to write larger than one page worth of data
  - avoid forcing fancier file systems to stick write context information on
    their global inode structure.

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com

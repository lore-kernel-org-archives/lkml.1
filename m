Return-Path: <linux-kernel-owner+w=401wt.eu-S1761777AbXHVMnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761777AbXHVMnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 08:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758750AbXHVMnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 08:43:33 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:21421 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686AbXHVMnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 08:43:31 -0400
Date: Wed, 22 Aug 2007 08:42:01 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/6] writeback time order/delay fixes take 3
Message-ID: <20070822084201.2c4eceb6@think.oraclecorp.com>
In-Reply-To: <387745522.02814@ustc.edu.cn>
References: <386910467.21100@ustc.edu.cn>
	<20070821202314.335e86ec@think.oraclecorp.com>
	<387745522.02814@ustc.edu.cn>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 09:18:41 +0800
Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> On Tue, Aug 21, 2007 at 08:23:14PM -0400, Chris Mason wrote:
> > On Sun, 12 Aug 2007 17:11:20 +0800
> > Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > 
> > > Andrew and Ken,
> > > 
> > > Here are some more experiments on the writeback stuff.
> > > Comments are highly welcome~ 
> > 
> > I've been doing benchmarks lately to try and trigger fragmentation,
> > and one of them is a simulation of make -j N.  It takes a list of
> > all the .o files in the kernel tree, randomly sorts them and then
> > creates bogus files with the same names and sizes in clean kernel
> > trees.
> > 
> > This is basically creating a whole bunch of files in random order
> > in a whole bunch of subdirectories.
> > 
> > The results aren't pretty:
> > 
> > http://oss.oracle.com/~mason/compilebench/makej/compare-compile-dirs-0.png
> > 
> > The top graph shows one dot for each write over time.  It shows that
> > ext3 is basically writing all over the place the whole time.  But,
> > ext3 actually wins the read phase, so the layout isn't horrible.
> > My guess is that if we introduce some write clustering by sending a
> > group of inodes down at the same time, it'll go much much better.
> > 
> > Andrew has mentioned bringing a few radix trees into the writeback
> > paths before, it seems like file servers and other general uses
> > will benefit from better clustering here.
> > 
> > I'm hoping to talk you into trying it out ;)
> 
> Thank you for the description of problem. So far I have a similar one
> in mind: if we are to delay writeback of atime-dirty-only inodes to
> above 1 hour, some grouping/piggy-backing scenario would be
> beneficial.  (Which I guess does not deserve the complexity now that
> we have Ingo's make-reltime-default patch.)

Good clustering would definitely help some delayed atime writeback
scheme.

> 
> My vague idea is to
> - keep the s_io/s_more_io as a FIFO/cyclic writeback dispatching
> queue.
> - convert s_dirty to some radix-tree/rbtree based data structure.
>   It would have dual functions: delayed-writeback and
> clustered-writeback. 
> clustered-writeback:
> - Use inode number as clue of locality, hence the key for the sorted
>   tree.
> - Drain some more s_dirty inodes into s_io on every kupdate wakeup,
>   but do it in the ascending order of inode number instead of
>   ->dirtied_when. 
> 
> delayed-writeback:
> - Make sure that a full scan of the s_dirty tree takes <=30s, i.e.
>   dirty_expire_interval.

I think we should assume a full scan of s_dirty is impossible in the
presence of concurrent writers.  We want to be able to pick a start
time (right now) and find all the inodes older than that start time.
New things will come in while we're scanning.  But perhaps that's what
you're saying...

At any rate, we've got two types of lists now.  One keeps track of age
and the other two keep track of what is currently being written.  I
would try two things:

1) s_dirty stays a list for FIFO.  s_io becomes a radix tree that
indexes by inode number (or some arbitrary field the FS can set in the
inode).  Radix tree tags are used to indicate which things in s_io are
already in progress or are pending (hand waving because I'm not sure
exactly).

inodes are pulled off s_dirty and the corresponding slot in s_io is
tagged to indicate IO has started.  Any nearby inodes in s_io are also
sent down.

2) s_dirty and s_io both become radix trees.  s_dirty is indexed by a
sequence number that corresponds to age.  It is treated as a big
circular indexed list that can wrap around over time.  Radix tree tags
are used both on s_dirty and s_io to flag which inodes are in progress.

> 
> Notes:
> (1) I'm not sure inode number is correlated to disk location in
>     filesystems other than ext2/3/4. Or parent dir?

In general, it is a better assumption than sorting by time.  It may
make sense to one day let the FS provide a clustering hint
(corresponding to the first block in the file?), but for starters it
makes sense to just go with the inode number.

> (2) It duplicates some function of elevators. Why is it necessary?
>     Maybe we have no clue on the exact data location at this time?

The elevator can only sort the pending IO, and we send down a
relatively small window of all the dirty pages at a time.  If we sent
down all the dirty pages and let the elevator sort it out, we wouldn't
need this clustering at all.

But, that has other issues ;)

-chris



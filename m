Return-Path: <linux-kernel-owner+w=401wt.eu-S935142AbXEVSPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935142AbXEVSPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760408AbXEVSPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:15:33 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31979 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbXEVSPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:15:32 -0400
Date: Tue, 22 May 2007 14:12:03 -0400
From: Chris Mason <chris.mason@oracle.com>
To: John Stoffel <john@stoffel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
Message-ID: <20070522181203.GD6138@think.oraclecorp.com>
References: <20070516171156.GY26766@think.oraclecorp.com> <20070516112515.b6f247b2.akpm@linux-foundation.org> <20070516191339.GA26766@think.oraclecorp.com> <20070516123342.714a11d8.akpm@linux-foundation.org> <20070516195359.GE26766@think.oraclecorp.com> <20070516130413.1fd391bf.akpm@linux-foundation.org> <20070516201414.GF26766@think.oraclecorp.com> <20070516133726.0c68a65f.akpm@linux-foundation.org> <20070522163511.GB6138@think.oraclecorp.com> <18003.11605.97057.17796@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18003.11605.97057.17796@stoffel.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 01:50:13PM -0400, John Stoffel wrote:
> >>>>> "Chris" == Chris Mason <chris.mason@oracle.com> writes:
> 
> Chris> On Wed, May 16, 2007 at 01:37:26PM -0700, Andrew Morton wrote:

[ seeky writes while creating kernel trees on ext3 ]

> >> How do you know that it is a log flush rather than, say, pdflush
> >> hitting the blockdev inode and doing a big seeky write?
> 
> Chris> Ok, I did some more work to split out the two cases (block device inode
> Chris> writeback and log flushing).
> 
> Chris> I patched jbd's log_do_checkpoint to put all the blocks it
> Chris> wanted to write in a radix tree, then send them all down in
> Chris> order at the end.  The elevator should be helping here, but jbd
> Chris> is sending down 2,000 to 3,000 blocks during the checkpoint and
> Chris> upping nr_requests alone didn't seem to be doing the trick.
> 
> That seems like a really high number to me, in terms of the number of
> blocks being check pointed here.  Should we be more aggressively
> writing journal blocks?  Or having sub-transactions so we can write
> smaller atomic chunks, while still not forcing them to disk?  
> 

The FS is 40GB and the log is 32768 blocks.  So, writing 2,000 blocks as
part of a checkpoint seems reasonable.  If you're whipping up a quick
and dirty patch to sort all the blocks being checkpointed, working in
bigger batches will increase the changes the writes are sequential.  So
I don't think smaller sub-transactions will do the trick.

> I dunno, I'm probably smoking something here.  
> 
> Just thinking out loud, what's the worst possible layout of inodes and
> such that can be written in ext3?  And can we generate a test case
> which re-creates that layout and then the handling of it?  Is it when
> we try to write N inodes, and we do inode 1, then N, then 2, then N-1,
> etc?  So that the writes are spread out all over the place and don't
> have any clustering in them at all?  

I don't know the jbd code well enough, but it looks like it is putting
things down in the order they were logged.  So it should be possible,
but every FS is going to have a pathological worst case.  I'm actually
trying to tune the benchmark such that any bad performance is only from
allocator decisions and not writeback decisions.

> 
> Chris> Unpatched ext3 would break down into seeks after 8 kernel trees
> Chris> are created (222MB each).  With the radix sorting, the first 15
> Chris> kernel trees are created quickly, and then we slow down.
> 
> Chris> So I waited until around the 25th kernel tree was created, hit
> Chris> ctrl-c and ran sync.  vmstat showed writes going at 2MB/s, and
> Chris> sysrq-w showed sync was running the block device inode for most
> Chris> of the 2MB/s period.
> 
> How much data was written overall at this point?  And was it sorted at
> all, or were just sub-chunks of it sorted?  

Each tree is 222MB, plus metadata.  It works out to about 10GB when you
factor in space wasted due to partially used blocks.  writeback will be
somewhat sorted, well enough that file data seems to do down at 30MB/s
or so.  It's the metadata slowing things down.

> 
> Chris> My vaporware FS is able to maintain speed through the run
> Chris> because the allocator tries to keep data and metadata grouped
> Chris> into 256mb chunks, and so they don't end up mingling on disk
> Chris> until things get full.
> 
> So what happens when your vaporFS is told to allocate in 128Mb chunks
> doing this same test?  I assume it gets into the same type of problem?  

128MB chunks would probably perform well, it isn't so much the size of
the group that helps but not having mixed data and metadata in the same
group.

> 
> I'm happy to see these tests happening, even if I don't have alot to
> contribute otherwise.  :[  
> 
> One thought, do you have a list of the blocks being written for the
> dirty block device inode?  Should we be trying to push them out
> whenenever we write data blocks which are near by?  
> 

It's an option, but not a light programming chore.

> I wonder how ext4 will do with this?  

I would guess it'll score the same way.  The files are fairly small in
this dataset and ext4's jbd code is based on ext3.

-chris


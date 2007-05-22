Return-Path: <linux-kernel-owner+w=401wt.eu-S966356AbXEVRvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966356AbXEVRvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760221AbXEVRvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:51:49 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:38995 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760120AbXEVRvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:51:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18003.11605.97057.17796@stoffel.org>
Date: Tue, 22 May 2007 13:50:13 -0400
From: "John Stoffel" <john@stoffel.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
In-Reply-To: <20070522163511.GB6138@think.oraclecorp.com>
References: <20070516144205.GV26766@think.oraclecorp.com>
	<464B2AC2.10206@redhat.com>
	<20070516171156.GY26766@think.oraclecorp.com>
	<20070516112515.b6f247b2.akpm@linux-foundation.org>
	<20070516191339.GA26766@think.oraclecorp.com>
	<20070516123342.714a11d8.akpm@linux-foundation.org>
	<20070516195359.GE26766@think.oraclecorp.com>
	<20070516130413.1fd391bf.akpm@linux-foundation.org>
	<20070516201414.GF26766@think.oraclecorp.com>
	<20070516133726.0c68a65f.akpm@linux-foundation.org>
	<20070522163511.GB6138@think.oraclecorp.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Chris" == Chris Mason <chris.mason@oracle.com> writes:

Chris> On Wed, May 16, 2007 at 01:37:26PM -0700, Andrew Morton wrote:
>> On Wed, 16 May 2007 16:14:14 -0400
>> Chris Mason <chris.mason@oracle.com> wrote:
>> 
>> > On Wed, May 16, 2007 at 01:04:13PM -0700, Andrew Morton wrote:
>> > > > The good news is that if you let it run long enough, the times
>> > > > stabilize.  The bad news is:
>> > > > 
>> > > > create dir kernel-86 222MB in 15.85 seconds (14.03 MB/s)
>> > > > create dir kernel-87 222MB in 28.67 seconds (7.76 MB/s)
>> > > > create dir kernel-88 222MB in 18.12 seconds (12.27 MB/s)
>> > > > create dir kernel-89 222MB in 19.77 seconds (11.25 MB/s)
>> > > 
>> > > well hang on.  Doesn't this just mean that the first few runs were writing
>> > > into pagecache and the later ones were blocking due to dirty-memory limits?
>> > > 
>> > > Or do you have a sync in there?
>> > > 
>> > There's no sync,  but if you watch vmstat you can clearly see the log
>> > flushes, even when the overall create times are 11MB/s.  vmstat goes
>> > 30MB/s -> 4MB/s or less, then back up to 30MB/s.
>> 
>> How do you know that it is a log flush rather than, say, pdflush
>> hitting the blockdev inode and doing a big seeky write?

Chris> Ok, I did some more work to split out the two cases (block device inode
Chris> writeback and log flushing).

Chris> I patched jbd's log_do_checkpoint to put all the blocks it
Chris> wanted to write in a radix tree, then send them all down in
Chris> order at the end.  The elevator should be helping here, but jbd
Chris> is sending down 2,000 to 3,000 blocks during the checkpoint and
Chris> upping nr_requests alone didn't seem to be doing the trick.

That seems like a really high number to me, in terms of the number of
blocks being check pointed here.  Should we be more aggressively
writing journal blocks?  Or having sub-transactions so we can write
smaller atomic chunks, while still not forcing them to disk?  

I dunno, I'm probably smoking something here.  

Just thinking out loud, what's the worst possible layout of inodes and
such that can be written in ext3?  And can we generate a test case
which re-creates that layout and then the handling of it?  Is it when
we try to write N inodes, and we do inode 1, then N, then 2, then N-1,
etc?  So that the writes are spread out all over the place and don't
have any clustering in them at all?  

Chris> Unpatched ext3 would break down into seeks after 8 kernel trees
Chris> are created (222MB each).  With the radix sorting, the first 15
Chris> kernel trees are created quickly, and then we slow down.

Chris> So I waited until around the 25th kernel tree was created, hit
Chris> ctrl-c and ran sync.  vmstat showed writes going at 2MB/s, and
Chris> sysrq-w showed sync was running the block device inode for most
Chris> of the 2MB/s period.

How much data was written overall at this point?  And was it sorted at
all, or were just sub-chunks of it sorted?  

Chris> It looks as though the dirty pages on the block device inode
Chris> are spread out far enough that we're not getting good streaming
Chris> writes.  Mark Fasheh ran on a bigger raid array, where
Chris> performance was consistently good for the whole run.  I'm
Chris> assuming the larger write cache on the array was able to group
Chris> the data writes with the metadata on disk, while my poor little
Chris> sata drive wasn't.  Dave Chinner hinted that xfs is probably
Chris> suffering a similar problem, which is usually fixed by backing
Chris> the FS with stripes and big raid.

It sounds like Mark Fasheh just needs to have a bigger test case to
also hit the same wall.  His hardware just moves it out a bit.  

Chris> My vaporware FS is able to maintain speed through the run
Chris> because the allocator tries to keep data and metadata grouped
Chris> into 256mb chunks, and so they don't end up mingling on disk
Chris> until things get full.

So what happens when your vaporFS is told to allocate in 128Mb chunks
doing this same test?  I assume it gets into the same type of problem?  

I'm happy to see these tests happening, even if I don't have alot to
contribute otherwise.  :[  

One thought, do you have a list of the blocks being written for the
dirty block device inode?  Should we be trying to push them out
whenenever we write data blocks which are near by?  

I wonder how ext4 will do with this?  

John

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751659AbZIHQaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbZIHQaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZIHQaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:30:15 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:37016 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZIHQaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:30:13 -0400
Date: Tue, 8 Sep 2009 12:29:36 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090908162936.GA2975@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, david@fromorbit.com,
	hch@infradead.org, akpm@linux-foundation.org, jack@suse.cz,
	Theodore Ts'o <tytso@mit.edu>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com>
 <1252401791-22463-9-git-send-email-jens.axboe@oracle.com>
 <4AA633FD.3080006@gmail.com>
 <1252425983.7746.120.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252425983.7746.120.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AA68674.024D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 06:06:23PM +0200, Peter Zijlstra wrote:
> On Tue, 2009-09-08 at 13:37 +0300, Artem Bityutskiy wrote:
> > Hi,
> > 
> > On 09/08/2009 12:23 PM, Jens Axboe wrote:
> > > From: Theodore Ts'o<tytso@mit.edu>
> > >
> > > Originally, MAX_WRITEBACK_PAGES was hard-coded to 1024 because of a
> > > concern of not holding I_SYNC for too long.  (At least, that was the
> > > comment previously.)  This doesn't make sense now because the only
> > > time we wait for I_SYNC is if we are calling sync or fsync, and in
> > > that case we need to write out all of the data anyway.  Previously
> > > there may have been other code paths that waited on I_SYNC, but not
> > > any more.
> > >
> > > According to Christoph, the current writeback size is way too small,
> > > and XFS had a hack that bumped out nr_to_write to four times the value
> > > sent by the VM to be able to saturate medium-sized RAID arrays.  This
> > > value was also problematic for ext4 as well, as it caused large files
> > > to be come interleaved on disk by in 8 megabyte chunks (we bumped up
> > > the nr_to_write by a factor of two).
> > >
> > > So, in this patch, we make the MAX_WRITEBACK_PAGES a tunable,
> > > max_writeback_mb, and set it to a default value of 128 megabytes.
> > >
> > > http://bugzilla.kernel.org/show_bug.cgi?id=13930
> > >
> > > Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
> > > Signed-off-by: Jens Axboe<jens.axboe@oracle.com>
> > 
> > Would be nice to update doc files like
> > 
> > Documentation/sysctl/vm.txt
> > Documentation/filesystems/proc.txt
> 
> I'm still not convinced this knob is worth the patch and I'm inclined to
> flat out NAK it..
> 
> The whole point of MAX_WRITEBACK_PAGES seems to occasionally check the
> dirty stats again and not write out too much.

The problem is that 'too much' is a very abstract thing.  When a process
is stuck in balance_dirty_pages, we want them to do the minimal amount
of work (or waiting) required to get them safely back inside file_write().

> 
> Clearly the current limit isn't sufficient for some people,
>  - xfs/btrfs seem generally stuck in balance_dirty_pages()'s
> congestion_wait()
>  - ext4 generates inconveniently small extents

This is actually two different side of the same problem.  The filesystem
knows that bytes 0-N in the file are setup for delayed allocation.
Writepage is called on byte 0, and now the filesystem gets to decide how
big an extent to make.

It could decide to make an extent based on the total number of bytes
under delayed allocation, and hope the caller of writepage will be kind
enough to send down the pages contiguously afterward (xfs), or it could
make a smaller extent based on something closer to the total number of
bytes this particular writepages() call plans on writing (I guess what
ext4 is doing).

Either way, if pdflush or the bdi thread or whoever ends up switching to
another file during a big streaming write, the end result is that we
fragment.  We may fragment the file (ext4) or we may fragment the
writeback (xfs), but the end result isn't good.

Looking at two xfs examples, this is the IO for two concurrent streaming
writers (two different files) on 2.6.31-rc8 (pdflush is doing all the IO
in this graph, sorry the legend colors wrapped on me).  If you squint,
you can kind of see the fingers of IO as pdflush switches between files.

http://oss.oracle.com/~mason/seekwatcher/xfs-tag.png

And here is the IO when XFS forces nr_to_write much higher with a patch
from Christoph:

http://oss.oracle.com/~mason/seekwatcher/xfs-extend-tag.png

These graphs would look the same no matter what I did with
congestion_wait().  The first graph is slower just because pdflush
switches from one file to another.

> 
> 
> The first seems to suggest to me the number isn't well balanced against
> whatever drives congestion_wait() (that thing still gives me a
> head-ache).
> 
> # git grep clear_bdi_congested
> drivers/block/pktcdvd.c:                clear_bdi_congested(&pd->disk->queue->backing_dev_info,
> fs/fuse/dev.c:                  clear_bdi_congested(&fc->bdi, BLK_RW_SYNC);
> fs/fuse/dev.c:                  clear_bdi_congested(&fc->bdi, BLK_RW_ASYNC);
> fs/nfs/write.c:         clear_bdi_congested(&nfss->backing_dev_info, BLK_RW_ASYNC);
> include/linux/backing-dev.h:void clear_bdi_congested(struct backing_dev_info *bdi, int sync);
> include/linux/blkdev.h: clear_bdi_congested(&q->backing_dev_info, sync);
> mm/backing-dev.c:void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
> mm/backing-dev.c:EXPORT_SYMBOL(clear_bdi_congested);
> 
> Suggests that regular block devices don't even manage device congestion
> and it reverts to a simple timeout -- should we fix that?

Look for blk_clear_queue_congested().  It is managed, I personally don't
think it is very useful.  But, that's a different thread ;)

> 
> Now, suppose it were to do something useful, I'd think we'd want to
> limit write-out to whatever it takes so saturate the BDI.

If we don't want a blanket increase, I'd suggest that we just give the
FS a way to say: 'I know nr_to_write is only 32, but if you just write a
few blocks more, the system will be better off'.

Something like wbc->fs_write_hint

This way, when the FS allocates a great big contiguous delalloc extent,
it can set the wbc to reflect that we've got cheap and easy IO here.

> 
> 
> As to the extends, shouldn't ext4 allocate extends based on the amount
> of dirty pages in the file instead of however much we're going to write
> out now?

It probably does a mixture of both.

-chris


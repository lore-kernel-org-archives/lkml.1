Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbZIHR3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbZIHR3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbZIHR3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:29:14 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:49883 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZIHR3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:29:13 -0400
Date: Tue, 8 Sep 2009 13:28:42 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, "Theodore Ts'o" <tytso@mit.edu>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090908172842.GC2975@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, david@fromorbit.com,
	hch@infradead.org, akpm@linux-foundation.org, jack@suse.cz,
	Theodore Ts'o <tytso@mit.edu>,
	Wu Fengguang <fengguang.wu@intel.com>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com>
 <1252401791-22463-9-git-send-email-jens.axboe@oracle.com>
 <4AA633FD.3080006@gmail.com>
 <1252425983.7746.120.camel@twins>
 <20090908162936.GA2975@think>
 <1252428983.7746.140.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252428983.7746.140.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AA6944E.00ED:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 06:56:23PM +0200, Peter Zijlstra wrote:
> On Tue, 2009-09-08 at 12:29 -0400, Chris Mason wrote:
> 
> > > I'm still not convinced this knob is worth the patch and I'm inclined to
> > > flat out NAK it..
> > > 
> > > The whole point of MAX_WRITEBACK_PAGES seems to occasionally check the
> > > dirty stats again and not write out too much.
> > 
> > The problem is that 'too much' is a very abstract thing.  When a process
> > is stuck in balance_dirty_pages, we want them to do the minimal amount
> > of work (or waiting) required to get them safely back inside file_write().
> 
> >From the VMs POV I think we'd like to keep near the dirty limit as that
> maximizes the write cache efficiency. Of course that needs to be
> balanced against write out efficiency.
> 
> > > Clearly the current limit isn't sufficient for some people,
> > >  - xfs/btrfs seem generally stuck in balance_dirty_pages()'s
> > > congestion_wait()
> > >  - ext4 generates inconveniently small extents
> > 
> > This is actually two different side of the same problem.  The filesystem
> > knows that bytes 0-N in the file are setup for delayed allocation.
> > Writepage is called on byte 0, and now the filesystem gets to decide how
> > big an extent to make.
> > 
> > It could decide to make an extent based on the total number of bytes
> > under delayed allocation, and hope the caller of writepage will be kind
> > enough to send down the pages contiguously afterward (xfs), or it could
> > make a smaller extent based on something closer to the total number of
> > bytes this particular writepages() call plans on writing (I guess what
> > ext4 is doing).
> > 
> > Either way, if pdflush or the bdi thread or whoever ends up switching to
> > another file during a big streaming write, the end result is that we
> > fragment.  We may fragment the file (ext4) or we may fragment the
> > writeback (xfs), but the end result isn't good.
> 
> OK, so what we want is for a way to re-enter the whole
> writeback_inodes() path onto the same file, right?

It would help.

> 
> That would result in the writeback continuing where it left off last.
> 
> Wu, can we make writeback_inodes() do something like that? Pass some
> magic along in wbc maybe?
> 
> > Looking at two xfs examples, this is the IO for two concurrent streaming
> > writers (two different files) on 2.6.31-rc8 (pdflush is doing all the IO
> > in this graph, sorry the legend colors wrapped on me).  If you squint,
> > you can kind of see the fingers of IO as pdflush switches between files.
> > 
> > http://oss.oracle.com/~mason/seekwatcher/xfs-tag.png
> > 
> > And here is the IO when XFS forces nr_to_write much higher with a patch
> > from Christoph:
> > 
> > http://oss.oracle.com/~mason/seekwatcher/xfs-extend-tag.png
> > 
> > These graphs would look the same no matter what I did with
> > congestion_wait().  The first graph is slower just because pdflush
> > switches from one file to another.
> > 
> > > 
> > > 
> > > The first seems to suggest to me the number isn't well balanced against
> > > whatever drives congestion_wait() (that thing still gives me a
> > > head-ache).
> > > 
> > > # git grep clear_bdi_congested
> > > drivers/block/pktcdvd.c:                clear_bdi_congested(&pd->disk->queue->backing_dev_info,
> > > fs/fuse/dev.c:                  clear_bdi_congested(&fc->bdi, BLK_RW_SYNC);
> > > fs/fuse/dev.c:                  clear_bdi_congested(&fc->bdi, BLK_RW_ASYNC);
> > > fs/nfs/write.c:         clear_bdi_congested(&nfss->backing_dev_info, BLK_RW_ASYNC);
> > > include/linux/backing-dev.h:void clear_bdi_congested(struct backing_dev_info *bdi, int sync);
> > > include/linux/blkdev.h: clear_bdi_congested(&q->backing_dev_info, sync);
> > > mm/backing-dev.c:void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
> > > mm/backing-dev.c:EXPORT_SYMBOL(clear_bdi_congested);
> > > 
> > > Suggests that regular block devices don't even manage device congestion
> > > and it reverts to a simple timeout -- should we fix that?
> > 
> > Look for blk_clear_queue_congested().  It is managed, I personally don't
> > think it is very useful.  But, that's a different thread ;)
> 
> Ah, how blind I am ;-)
> 
> Right, so what can we do to make it useful? I think the intent is to
> limit the number of pages in writeback and provide some progress
> feedback to the vm.
> 
> Going by your experience we're failing there.

Well, congestion_wait is a stop sign but not a queue.  So, if you're
being nice and honoring congestion but another process (say O_DIRECT
random writes) doesn't, then you back off forever and none of your IO
gets done.

To get around this, you can add code to make sure that you do
_some_ io, but this isn't enough for your work to get done
quickly, and you do end up waiting in get_request() so the async
benefits of using the congestion test go away.

If we changed everyone to honor congestion, we end up with a poll model
because a ton of congestion_wait() callers create a thundering herd.

So, we could add a queue, and then congestion_wait() would look a lot
like get_request_wait().  I'd rather that everyone just used
get_request_wait, and then have us fix any latency problems in the
elevator.

For me, perfect would be one or more threads per-bdi doing the
writeback, and never checking for congestion (like what Jens' code
does).  The congestion_wait inside balance_dirty_pages() is really just
a schedule_timeout(), on a fully loaded box the congestion doesn't go
away anyway.  We should switch that to a saner system of waiting for
progress on the bdi writeback + dirty thresholds.

Btrfs would love to be able to send down a bio non-blocking.  That would
let me get rid of the congestion check I have today (I think Jens said
that would be an easy change and then I talked him into some small mods
of the writeback path).

> 
> > > Now, suppose it were to do something useful, I'd think we'd want to
> > > limit write-out to whatever it takes so saturate the BDI.
> > 
> > If we don't want a blanket increase, 
> 
> The thing is, this sysctl seems an utter cop out, we can't even explain
> how to calculate a number that'll work for a situation, the best we can
> do is say, prod at it and pray -- that's not good.
> 
> Last time I also asked if an increased number is good for every
> situation, I have a machine with a RAID5 array and USB storage, will it
> harm either situation?

If the goal is to make sure that pdflush or balance_dirty_pages only
does IO until some condition is met, we should add a flag to the bdi
that gets set when that condition is met.  Things will go a lot more
smoothly than magic numbers.

Then we can add the fs_hint as another change so the FS can tell
write_cache_pages callers how to do optimal IO based on its allocation
decisions.

> 
> > I'd suggest that we just give the
> > FS a way to say: 'I know nr_to_write is only 32, but if you just write a
> > few blocks more, the system will be better off'.
> > 
> > Something like wbc->fs_write_hint
> > 
> > This way, when the FS allocates a great big contiguous delalloc extent,
> > it can set the wbc to reflect that we've got cheap and easy IO here.
> 
> I think that's certainly a possibility.
> 
> What's the down-side of allocating extents based on the available dirty
> pages instead of the current write-out request? As long as we're good at
> generating sequential IO in general (yeah, I know we suck now) it
> doesn't really matter when it will be filled, as we know it will
> eventually be.

I'm guessing the small extents from ext4 come from tuning the allocator
for writeback performance instead of anti-fragmentation.  But I'm
guessing.

-chris


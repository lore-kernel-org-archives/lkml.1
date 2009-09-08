Return-Path: <linux-kernel-owner+w=401wt.eu-S1751326AbZIHQGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbZIHQGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbZIHQGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:06:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:37329 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZIHQGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:06:41 -0400
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
From: Peter Zijlstra <peterz@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, "Theodore Ts'o" <tytso@mit.edu>
In-Reply-To: <4AA633FD.3080006@gmail.com>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com>
	 <1252401791-22463-9-git-send-email-jens.axboe@oracle.com>
	 <4AA633FD.3080006@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 08 Sep 2009 18:06:23 +0200
Message-Id: <1252425983.7746.120.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 13:37 +0300, Artem Bityutskiy wrote:
> Hi,
> 
> On 09/08/2009 12:23 PM, Jens Axboe wrote:
> > From: Theodore Ts'o<tytso@mit.edu>
> >
> > Originally, MAX_WRITEBACK_PAGES was hard-coded to 1024 because of a
> > concern of not holding I_SYNC for too long.  (At least, that was the
> > comment previously.)  This doesn't make sense now because the only
> > time we wait for I_SYNC is if we are calling sync or fsync, and in
> > that case we need to write out all of the data anyway.  Previously
> > there may have been other code paths that waited on I_SYNC, but not
> > any more.
> >
> > According to Christoph, the current writeback size is way too small,
> > and XFS had a hack that bumped out nr_to_write to four times the value
> > sent by the VM to be able to saturate medium-sized RAID arrays.  This
> > value was also problematic for ext4 as well, as it caused large files
> > to be come interleaved on disk by in 8 megabyte chunks (we bumped up
> > the nr_to_write by a factor of two).
> >
> > So, in this patch, we make the MAX_WRITEBACK_PAGES a tunable,
> > max_writeback_mb, and set it to a default value of 128 megabytes.
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=13930
> >
> > Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
> > Signed-off-by: Jens Axboe<jens.axboe@oracle.com>
> 
> Would be nice to update doc files like
> 
> Documentation/sysctl/vm.txt
> Documentation/filesystems/proc.txt

I'm still not convinced this knob is worth the patch and I'm inclined to
flat out NAK it..

The whole point of MAX_WRITEBACK_PAGES seems to occasionally check the
dirty stats again and not write out too much.

Clearly the current limit isn't sufficient for some people,
 - xfs/btrfs seem generally stuck in balance_dirty_pages()'s
congestion_wait()
 - ext4 generates inconveniently small extents


The first seems to suggest to me the number isn't well balanced against
whatever drives congestion_wait() (that thing still gives me a
head-ache).

# git grep clear_bdi_congested
drivers/block/pktcdvd.c:                clear_bdi_congested(&pd->disk->queue->backing_dev_info,
fs/fuse/dev.c:                  clear_bdi_congested(&fc->bdi, BLK_RW_SYNC);
fs/fuse/dev.c:                  clear_bdi_congested(&fc->bdi, BLK_RW_ASYNC);
fs/nfs/write.c:         clear_bdi_congested(&nfss->backing_dev_info, BLK_RW_ASYNC);
include/linux/backing-dev.h:void clear_bdi_congested(struct backing_dev_info *bdi, int sync);
include/linux/blkdev.h: clear_bdi_congested(&q->backing_dev_info, sync);
mm/backing-dev.c:void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
mm/backing-dev.c:EXPORT_SYMBOL(clear_bdi_congested);

Suggests that regular block devices don't even manage device congestion
and it reverts to a simple timeout -- should we fix that?

Now, suppose it were to do something useful, I'd think we'd want to
limit write-out to whatever it takes so saturate the BDI.


As to the extends, shouldn't ext4 allocate extends based on the amount
of dirty pages in the file instead of however much we're going to write
out now?



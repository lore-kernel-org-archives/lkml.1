Return-Path: <linux-kernel-owner+w=401wt.eu-S932539AbZJLPHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbZJLPHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932156AbZJLPHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:07:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46529 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466AbZJLPHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:07:03 -0400
Date: Mon, 12 Oct 2009 17:06:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blkdev: flush disk cache on ->fsync
Message-ID: <20091012150626.GL9228@kernel.dk>
References: <20090820182432.GA31520@lst.de> <20091010161531.GA30289@lst.de> <x49skdoslfn.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49skdoslfn.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12 2009, Jeff Moyer wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
> > Is anyone going to pick up this patch?
> >
> > On Thu, Aug 20, 2009 at 08:24:32PM +0200, Christoph Hellwig wrote:
> >> Currently there is no barrier support in the block device code.  That
> >> means we cannot guarantee any sort of data integerity when using the
> >> block device node with dis kwrite caches enabled.  Using the raw block
> >> device node is a typical use case for virtualization (and I assume
> >> databases, too).  This patch changes block_fsync to issue a cache flush
> >> and thus make fsync on block device nodes actually useful.
> >> 
> >> Note that in mainline we would also need to add such code to the
> >> ->aio_write method for O_SYNC handling, but assuming that Jan's patch
> >> series for the O_SYNC rewrite goes in it will also call into ->fsync
> >> for 2.6.32.
> >> 
> >> 
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> >> 
> >> 
> >> diff --git a/fs/block_dev.c b/fs/block_dev.c
> >> index 94dfda2..298ad75 100644
> >> --- a/fs/block_dev.c
> >> +++ b/fs/block_dev.c
> >> @@ -398,7 +398,17 @@ static loff_t block_llseek(struct file *file, loff_t offset, int origin)
> >>   
> >>  static int block_fsync(struct file *filp, struct dentry *dentry, int datasync)
> >>  {
> >> -	return sync_blockdev(I_BDEV(filp->f_mapping->host));
> >> +	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
> >> +	int error;
> >> +
> >> +	error = sync_blockdev(bdev);
> >> +	if (error)
> >> +		return error;
> >> +	
> >> +	error = blkdev_issue_flush(bdev, NULL);
> >> +	if (error == -EOPNOTSUPP)
> >> +		error = 0;
> >> +	return error;
> >>  }
> >>  
> >>  /*
> > ---end quoted text---
> 
> Looks ok to me.  Jens?

Yep ditto!

> 
> Acked-by: Jeff Moyer <jmoyer@redhat.com>

-- 
Jens Axboe


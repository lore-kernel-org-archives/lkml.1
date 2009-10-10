Return-Path: <linux-kernel-owner+w=401wt.eu-S1761962AbZJJQQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962AbZJJQQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 12:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761949AbZJJQQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 12:16:09 -0400
Received: from verein.lst.de ([213.95.11.210]:34982 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761948AbZJJQQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 12:16:08 -0400
Date: Sat, 10 Oct 2009 18:15:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blkdev: flush disk cache on ->fsync
Message-ID: <20091010161531.GA30289@lst.de>
References: <20090820182432.GA31520@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820182432.GA31520@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is anyone going to pick up this patch?

On Thu, Aug 20, 2009 at 08:24:32PM +0200, Christoph Hellwig wrote:
> Currently there is no barrier support in the block device code.  That
> means we cannot guarantee any sort of data integerity when using the
> block device node with dis kwrite caches enabled.  Using the raw block
> device node is a typical use case for virtualization (and I assume
> databases, too).  This patch changes block_fsync to issue a cache flush
> and thus make fsync on block device nodes actually useful.
> 
> Note that in mainline we would also need to add such code to the
> ->aio_write method for O_SYNC handling, but assuming that Jan's patch
> series for the O_SYNC rewrite goes in it will also call into ->fsync
> for 2.6.32.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 94dfda2..298ad75 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -398,7 +398,17 @@ static loff_t block_llseek(struct file *file, loff_t offset, int origin)
>   
>  static int block_fsync(struct file *filp, struct dentry *dentry, int datasync)
>  {
> -	return sync_blockdev(I_BDEV(filp->f_mapping->host));
> +	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
> +	int error;
> +
> +	error = sync_blockdev(bdev);
> +	if (error)
> +		return error;
> +	
> +	error = blkdev_issue_flush(bdev, NULL);
> +	if (error == -EOPNOTSUPP)
> +		error = 0;
> +	return error;
>  }
>  
>  /*
---end quoted text---

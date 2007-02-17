Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbXBQG2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbXBQG2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 01:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946419AbXBQG2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 01:28:40 -0500
Received: from brick.kernel.dk ([62.242.22.158]:24501 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694AbXBQG2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 01:28:40 -0500
Date: Sat, 17 Feb 2007 07:28:32 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>,
       Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       dougg@torque.net
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
Message-ID: <20070217062832.GE3689@kernel.dk>
References: <Pine.LNX.4.44L0.0702161422100.3490-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0702161422100.3490-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16 2007, Alan Stern wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> 
> This patch (as854) separates out the two queue-oriented ioctls from
> the rest of the block-layer ioctls.  The idea is that they should
> apply to any driver using a request_queue, even if the driver doesn't
> implement a block-device interface.  The prototypical example is the
> sg driver, to which the patch adds the new interface.
> 
> This will make it possible for cdrecord and related programs to
> retrieve reliably the max_sectors value, regardless of whether the
> user points it to an sr or an sg device.  In particular, this will
> resolve Bugzilla entry #7026.

The block bits are fine with me, the sg calling point is a bit of a sore
thumb (a char driver calling into block layer ioctls) though. So the
block layer bits are certainly ok with me, if Doug acks the sg bit I'll
merge everything up.

(patch left below)

> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> Jens:
> 
> James said that he feels you should be be the person to accept this
> patch, since it affects the block layer.  Please merge it and send it
> on up the hierarchy.
> 
> Alan Stern
> 
> 
> 
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 58aab63..8444d0c 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -135,6 +135,31 @@ static int put_u64(unsigned long arg, u6
>  	return put_user(val, (u64 __user *)arg);
>  }
>  
> +static int blk_queue_locked_ioctl(struct request_queue *queue,
> +				  unsigned cmd, unsigned long arg)
> +{
> +	switch (cmd) {
> +	case BLKSSZGET: /* get block device hardware sector size */
> +		return put_int(arg, queue_hardsect_size(queue));
> +	case BLKSECTGET:
> +		return put_ushort(arg, queue->max_sectors);
> +	}
> +	return -ENOIOCTLCMD;
> +}
> +
> +int blk_queue_ioctl(struct request_queue *queue, unsigned cmd,
> +		    unsigned long arg)
> +{
> +	int ret;
> +
> +	lock_kernel();
> +	ret = blk_queue_locked_ioctl(queue, cmd, arg);
> +	unlock_kernel();
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(blk_queue_ioctl);
> +
>  static int blkdev_locked_ioctl(struct file *file, struct block_device *bdev,
>  				unsigned cmd, unsigned long arg)
>  {
> @@ -154,10 +179,6 @@ static int blkdev_locked_ioctl(struct fi
>  		return put_int(arg, bdev_read_only(bdev) != 0);
>  	case BLKBSZGET: /* get the logical block size (cf. BLKSSZGET) */
>  		return put_int(arg, block_size(bdev));
> -	case BLKSSZGET: /* get block device hardware sector size */
> -		return put_int(arg, bdev_hardsect_size(bdev));
> -	case BLKSECTGET:
> -		return put_ushort(arg, bdev_get_queue(bdev)->max_sectors);
>  	case BLKRASET:
>  	case BLKFRASET:
>  		if(!capable(CAP_SYS_ADMIN))
> @@ -278,6 +299,8 @@ int blkdev_ioctl(struct inode *inode, st
>  
>  	lock_kernel();
>  	ret = blkdev_locked_ioctl(file, bdev, cmd, arg);
> +	if (ret == -ENOIOCTLCMD)
> +		ret = blk_queue_locked_ioctl(bdev_get_queue(bdev), cmd, arg);
>  	unlock_kernel();
>  	if (ret != -ENOIOCTLCMD)
>  		return ret;
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 81e3bc7..d97244b 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -786,6 +786,11 @@ sg_ioctl(struct inode *inode, struct fil
>  				   sdp->disk->disk_name, (int) cmd_in));
>  	read_only = (O_RDWR != (filp->f_flags & O_ACCMODE));
>  
> +	/* block ioctls first */
> +	result = blk_queue_ioctl(sdp->device->request_queue, cmd_in, arg);
> +	if (result != -ENOIOCTLCMD)
> +		return result;
> +
>  	switch (cmd_in) {
>  	case SG_IO:
>  		{
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index e1c7286..550b04a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -754,6 +754,8 @@ extern void blk_queue_prep_rq(request_qu
>  extern void blk_queue_merge_bvec(request_queue_t *, merge_bvec_fn *);
>  extern void blk_queue_dma_alignment(request_queue_t *, int);
>  extern void blk_queue_softirq_done(request_queue_t *, softirq_done_fn *);
> +extern int blk_queue_ioctl(struct request_queue *queue, unsigned cmd,
> +			   unsigned long arg);
>  extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
>  extern int blk_queue_ordered(request_queue_t *, unsigned, prepare_flush_fn *);
>  extern void blk_queue_issue_flush_fn(request_queue_t *, issue_flush_fn *);
> 

-- 
Jens Axboe


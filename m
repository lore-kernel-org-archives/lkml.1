Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZICKYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZICKYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 06:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbZICKYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 06:24:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856AbZICKYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 06:24:35 -0400
Date: Thu, 3 Sep 2009 12:24:36 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/16] vfs: Rename generic_file_aio_write_nolock
Message-ID: <20090903102436.GC5060@duck.novell.com>
References: <1251899966-7316-1-git-send-email-jack@suse.cz> <1251899966-7316-7-git-send-email-jack@suse.cz> <20090902214722.GA4226@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090902214722.GA4226@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 02-09-09 23:47:22, Christoph Hellwig wrote:
> On Wed, Sep 02, 2009 at 03:59:16PM +0200, Jan Kara wrote:
> > generic_file_aio_write_nolock() is now used only by block devices and raw
> > character device. Filesystems should use __generic_file_aio_write() in case
> > generic_file_aio_write() doesn't suit them. So rename the function to
> > device_aio_write().
> 
> I would recommend this one on top:
> 
> Move it to fs/block_dev.c, rename it to blkdev_aio_write, export it _GPL
> only and make it very clear it's only for block devices and raw.
  Yes, fine with me. I'll replace my patch with yours so that we don't
rename the function twice unnecessarily.

> And btw, I'm not actually sure it is the right thing for raw.  Raw is
> supposed to do direct I/O only, and in fact forced O_DIRECT on.  Because
> there are no holes it also can't fall back to direct I/O.  So strictly
> spreaking we could just use __generic_file_aio_write directly.   That
> is until we care about the hw disk caches..
  I'm slightly confused with the above - probably you mean it cannot fall
back to buffered I/O and it could use generic_file_direct_write (because
__generic_file_aio_write is just blkdev_aio_write without syncing in case
of O_SYNC). The thing with using generic_file_direct_write() is that we'd
have to duplicate checks in the beginning of __generic_file_aio_write() so
I'm not sure the code will be cleaner in the end.

									Honza

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/drivers/char/raw.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/raw.c	2009-09-02 11:29:21.772122902 -0300
> +++ linux-2.6/drivers/char/raw.c	2009-09-02 11:29:31.996123226 -0300
> @@ -246,7 +246,7 @@ static const struct file_operations raw_
>  	.read	=	do_sync_read,
>  	.aio_read = 	generic_file_aio_read,
>  	.write	=	do_sync_write,
> -	.aio_write =	device_aio_write,
> +	.aio_write =	blkdev_aio_write,
>  	.open	=	raw_open,
>  	.release=	raw_release,
>  	.ioctl	=	raw_ioctl,
> Index: linux-2.6/fs/block_dev.c
> ===================================================================
> --- linux-2.6.orig/fs/block_dev.c	2009-09-02 11:26:33.344623333 -0300
> +++ linux-2.6/fs/block_dev.c	2009-09-02 15:04:15.125012009 -0300
> @@ -1405,6 +1405,33 @@ static long block_ioctl(struct file *fil
>  }
>  
>  /*
> + * Write data to the block device.  Only intended for the block device itself
> + * and the raw driver which basically is a fake block device.
> + *
> + * Does not take i_mutex for the write and thus is not for general purpose
> + * use.
> + */
> +ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
> +			 unsigned long nr_segs, loff_t pos)
> +{
> +	struct file *file = iocb->ki_filp;
> +	ssize_t ret;
> +
> +	BUG_ON(iocb->ki_pos != pos);
> +
> +	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
> +	if (ret > 0 || ret == -EIOCBQUEUED) {
> +		ssize_t err;
> +
> +		err = generic_write_sync(file, pos, ret);
> +		if (err < 0 && ret > 0)
> +			ret = err;
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(blkdev_aio_write);
> +
> +/*
>   * Try to release a page associated with block device when the system
>   * is under memory pressure.
>   */
> @@ -1436,7 +1463,7 @@ const struct file_operations def_blk_fop
>  	.read		= do_sync_read,
>  	.write		= do_sync_write,
>    	.aio_read	= generic_file_aio_read,
> -	.aio_write	= device_aio_write,
> +	.aio_write	= blkdev_aio_write,
>  	.mmap		= generic_file_mmap,
>  	.fsync		= block_fsync,
>  	.unlocked_ioctl	= block_ioctl,
> Index: linux-2.6/include/linux/fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/fs.h	2009-09-02 11:28:36.464127763 -0300
> +++ linux-2.6/include/linux/fs.h	2009-09-02 15:04:34.740769169 -0300
> @@ -2196,8 +2196,6 @@ extern ssize_t generic_file_aio_read(str
>  extern ssize_t __generic_file_aio_write(struct kiocb *, const struct iovec *, unsigned long,
>  		loff_t *);
>  extern ssize_t generic_file_aio_write(struct kiocb *, const struct iovec *, unsigned long, loff_t);
> -extern ssize_t device_aio_write(struct kiocb *iocb, const struct iovec *iov,
> -				unsigned long nr_segs, loff_t pos);
>  extern ssize_t generic_file_direct_write(struct kiocb *, const struct iovec *,
>  		unsigned long *, loff_t, loff_t *, size_t, size_t);
>  extern ssize_t generic_file_buffered_write(struct kiocb *, const struct iovec *,
> @@ -2207,6 +2205,10 @@ extern ssize_t do_sync_write(struct file
>  extern int generic_segment_checks(const struct iovec *iov,
>  		unsigned long *nr_segs, size_t *count, int access_flags);
>  
> +/* fs/block_dev.c */
> +extern ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
> +				unsigned long nr_segs, loff_t pos);
> +
>  /* fs/splice.c */
>  extern ssize_t generic_file_splice_read(struct file *, loff_t *,
>  		struct pipe_inode_info *, size_t, unsigned int);
> Index: linux-2.6/mm/filemap.c
> ===================================================================
> --- linux-2.6.orig/mm/filemap.c	2009-09-02 11:26:33.240134550 -0300
> +++ linux-2.6/mm/filemap.c	2009-09-02 11:27:03.488134215 -0300
> @@ -2398,41 +2398,6 @@ out:
>  EXPORT_SYMBOL(__generic_file_aio_write);
>  
>  /**
> - * device_aio_write - write data
> - * @iocb:	IO state structure
> - * @iov:	vector with data to write
> - * @nr_segs:	number of segments in the vector
> - * @pos:	position in file where to write
> - *
> - * This is a wrapper around __generic_file_aio_write() which takes care of
> - * syncing the file in case of O_SYNC file. It does not take i_mutex for the
> - * write itself but may do so during syncing. It is meant for users like block
> - * devices which do not need i_mutex during write. If your filesystem needs to
> - * do a write but already holds i_mutex, use __generic_file_aio_write()
> - * directly and then sync the file like generic_file_aio_write().
> - */
> -ssize_t device_aio_write(struct kiocb *iocb, const struct iovec *iov,
> -			 unsigned long nr_segs, loff_t pos)
> -{
> -	struct file *file = iocb->ki_filp;
> -	ssize_t ret;
> -
> -	BUG_ON(iocb->ki_pos != pos);
> -
> -	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
> -
> -	if (ret > 0 || ret == -EIOCBQUEUED) {
> -		ssize_t err;
> -
> -		err = generic_write_sync(file, pos, ret);
> -		if (err < 0 && ret > 0)
> -			ret = err;
> -	}
> -	return ret;
> -}
> -EXPORT_SYMBOL(device_aio_write);
> -
> -/**
>   * generic_file_aio_write - write data to a file
>   * @iocb:	IO state structure
>   * @iov:	vector with data to write
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

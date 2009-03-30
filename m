Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbZC3PXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbZC3PXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbZC3PWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:22:47 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61473 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbZC3PWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:22:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=IKpgReFxnp2djIcBg/zUxQHOO44Uq9DKrZ1/Js6BcMhBi9gSltUH25mta0F8rMypr3
         4ALo5tut0S6mYNqw4+qoxi/a27LPPmRcQU9hgNGEZ0eYnJeF9077fIVGlxU6pmEIZ9pO
         MuMezydDz6zzHmGkxP0EdXXIslWhLxgp8SYRU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Fernando Luis =?iso-8859-1?q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH 6/7] xfs: propagate issue-flush error code
Date: Mon, 30 Mar 2009 17:20:43 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49D0B535.2010106@oss.ntt.co.jp> <49D0BC0A.9050909@oss.ntt.co.jp>
In-Reply-To: <49D0BC0A.9050909@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903301720.48260.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009, Fernando Luis Vázquez Cao wrote:
> blkdev_issue_flush() may fail (i.e. due to media error on FLUSH CACHE
> command execution) so its users should check for the return value.
> 
> (This issues was first spotted Bartlomiej Zolnierkiewicz)
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-2.6.29-orig/fs/xfs/linux-2.6/xfs_buf.c linux-2.6.29/fs/xfs/linux-2.6/xfs_buf.c
> --- linux-2.6.29-orig/fs/xfs/linux-2.6/xfs_buf.c	2009-03-24 08:12:14.000000000 +0900
> +++ linux-2.6.29/fs/xfs/linux-2.6/xfs_buf.c	2009-03-30 14:44:34.000000000 +0900
> @@ -1446,6 +1446,7 @@ xfs_free_buftarg(
>   {
>   	xfs_flush_buftarg(btp, 1);
>   	if (mp->m_flags & XFS_MOUNT_BARRIER)
> +		/* FIXME: check return value */
>   		xfs_blkdev_issue_flush(btp);
>   	xfs_free_bufhash(btp);
>   	iput(btp->bt_mapping->host);
> diff -urNp linux-2.6.29-orig/fs/xfs/linux-2.6/xfs_super.c linux-2.6.29/fs/xfs/linux-2.6/xfs_super.c
> --- linux-2.6.29-orig/fs/xfs/linux-2.6/xfs_super.c	2009-03-24 08:12:14.000000000 +0900
> +++ linux-2.6.29/fs/xfs/linux-2.6/xfs_super.c	2009-03-30 15:16:42.000000000 +0900
> @@ -721,11 +721,11 @@ xfs_mountfs_check_barriers(xfs_mount_t *
>   	}
>   }
> 
> -void
> +int
>   xfs_blkdev_issue_flush(
>   	xfs_buftarg_t		*buftarg)
>   {
> -	blkdev_issue_flush(buftarg->bt_bdev, NULL);
> +	return block_flush_device(buftarg->bt_bdev);
>   }
> 
>   STATIC void
> diff -urNp linux-2.6.29-orig/fs/xfs/linux-2.6/xfs_super.h linux-2.6.29/fs/xfs/linux-2.6/xfs_super.h
> --- linux-2.6.29-orig/fs/xfs/linux-2.6/xfs_super.h	2009-03-24 08:12:14.000000000 +0900
> +++ linux-2.6.29/fs/xfs/linux-2.6/xfs_super.h	2009-03-30 14:46:31.000000000 +0900
> @@ -89,7 +89,7 @@ struct block_device;
> 
>   extern __uint64_t xfs_max_file_offset(unsigned int);
> 
> -extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
> +extern int xfs_blkdev_issue_flush(struct xfs_buftarg *);
> 
>   extern const struct export_operations xfs_export_operations;
>   extern struct xattr_handler *xfs_xattr_handlers[];
> diff -urNp linux-2.6.29-orig/fs/xfs/xfs_vnodeops.c linux-2.6.29/fs/xfs/xfs_vnodeops.c
> --- linux-2.6.29-orig/fs/xfs/xfs_vnodeops.c	2009-03-24 08:12:14.000000000 +0900
> +++ linux-2.6.29/fs/xfs/xfs_vnodeops.c	2009-03-30 15:08:21.000000000 +0900
> @@ -678,20 +678,20 @@ xfs_fsync(
>   		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>   	}
> 
> -	if ((ip->i_mount->m_flags & XFS_MOUNT_BARRIER) && changed) {
> +	if (!error && (ip->i_mount->m_flags & XFS_MOUNT_BARRIER) && changed) {
>   		/*
>   		 * If the log write didn't issue an ordered tag we need
>   		 * to flush the disk cache for the data device now.
>   		 */
>   		if (!log_flushed)
> -			xfs_blkdev_issue_flush(ip->i_mount->m_ddev_targp);
> +			error = xfs_blkdev_issue_flush(ip->i_mount->m_ddev_targp);

This is different from my original patch which preserved the original
error value...

>   		/*
>   		 * If this inode is on the RT dev we need to flush that
>   		 * cache as well.
>   		 */
> -		if (XFS_IS_REALTIME_INODE(ip))
> -			xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
> +		if (!error && XFS_IS_REALTIME_INODE(ip))
> +			error = xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);

This is also different and is a change in behavior
(it makes sense IMHO but please document it).

Thanks,
Bart

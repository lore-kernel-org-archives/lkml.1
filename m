Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbYKTV1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbYKTV1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 16:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468AbYKTV1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 16:27:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480AbYKTV07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 16:26:59 -0500
Date: Thu, 20 Nov 2008 13:26:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: hooanon05@yahoo.co.jp
Cc: tomas@slax.org, linux-kernel@vger.kernel.org, akinobu.mita@gmail.com,
       util-linux-ng@vger.kernel.org
Subject: Re: [PATCH] loop file resizable
Message-Id: <20081120132654.4c649eb0.akpm@linux-foundation.org>
In-Reply-To: <16149.1227066661@jrobl>
References: <492120DC.1070407@slax.org>
	<20081118164207.137e92be.akpm@linux-foundation.org>
	<16149.1227066661@jrobl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008 12:51:01 +0900
hooanon05@yahoo.co.jp wrote:

> The following patch against loop.c adds ability to 'resize' the loop device on the fly.
> This may be practically very useful.
> 
> One practical application is a loop file with XFS filesystem, already mounted:
> You can easily enlarge the file (append some bytes) and then call
> ioctl(fd, LOOP_SET_CAPACITY, new);
> The loop driver will learn about the new size and you can use xfs_growfs
> later on, which will allow you to use full capacity of the loop
> file without the need to unmount.
> 
> Please include it in mainline kernel.
> 
> Hope you like it.
> 
> Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
> Signed-off-by: Tomas Matejicek <tomas@slax.org>
> 
> Index: linux-2.6.27/drivers/block/loop.c
> ===================================================================
> retrieving revision 1.1
> retrieving revision 1.3
> diff -u -p -r1.1 -r1.3
> --- linux-2.6.27/drivers/block/loop.c	7 Nov 2008 13:07:06 -0000	1.1
> +++ linux-2.6.27/drivers/block/loop.c	19 Nov 2008 03:42:54 -0000	1.3
> @@ -1137,6 +1137,28 @@ loop_get_status64(struct loop_device *lo
>  	return err;
>  }
>  
> +static int loop_set_capacity(struct loop_device *lo, struct block_device *bdev)
> +{
> +	int err;
> +	sector_t sec;
> +	loff_t sz;
> +
> +	err = -ENXIO;
> +	if (lo->lo_state != Lo_bound)
> +		goto out;
> +	err = figure_loop_size(lo);
> +	if (err)
> +		goto out;
> +	sec = get_capacity(lo->lo_disk);
> +	sz = sec << 9;
> +	mutex_lock(&bdev->bd_mutex);
> +	bd_set_size(bdev, sz);
> +	mutex_unlock(&bdev->bd_mutex);
> +
> + out:
> +	return err;
> +}
> +
>  static int lo_ioctl(struct inode * inode, struct file * file,
>  	unsigned int cmd, unsigned long arg)
>  {
> @@ -1166,6 +1188,9 @@ static int lo_ioctl(struct inode * inode
>  	case LOOP_GET_STATUS64:
>  		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
>  		break;
> +	case LOOP_SET_CAPACITY:
> +		err = loop_set_capacity(lo, inode->i_bdev);
> +		break;
>  	default:
>  		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
>  	}
> @@ -1311,6 +1336,7 @@ static long lo_compat_ioctl(struct file 
>  			lo, (struct compat_loop_info __user *) arg);
>  		mutex_unlock(&lo->lo_ctl_mutex);
>  		break;
> +	case LOOP_SET_CAPACITY:
>  	case LOOP_CLR_FD:
>  	case LOOP_GET_STATUS64:
>  	case LOOP_SET_STATUS64:
> Index: linux-2.6.27/include/linux/loop.h
> ===================================================================
> retrieving revision 1.1
> retrieving revision 1.2
> diff -u -p -r1.1 -r1.2
> --- linux-2.6.27/include/linux/loop.h	7 Nov 2008 13:05:58 -0000	1.1
> +++ linux-2.6.27/include/linux/loop.h	8 Nov 2008 04:47:20 -0000	1.2
> @@ -160,5 +160,6 @@ int loop_unregister_transfer(int number)
>  #define LOOP_SET_STATUS64	0x4C04
>  #define LOOP_GET_STATUS64	0x4C05
>  #define LOOP_CHANGE_FD		0x4C06
> +#define LOOP_SET_CAPACITY	0x4C07
>  
>  #endif

Well if we're going to do this then I guess we'll need to tell the
util-linux people about it, as users will be needing some tool with
which to access the new fucntionality.

Presumably that would be some enhancement to losetup, or perhaps a new
tool.  Could the util-linux people please have a think about this and
comment?

Also, I'm not sure that the user interface is terribly good.  The user
must extend the file size and then we tell the loop driver to use all
of the new file size.  it would be better (more flexible) to allow
userspace to explicitly pass in the new size for the loop device.

But I'm not sure that this is worth bothering about.

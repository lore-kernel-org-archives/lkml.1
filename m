Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbYKSAmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbYKSAmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 19:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYKSAmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 19:42:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbYKSAmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 19:42:40 -0500
Date: Tue, 18 Nov 2008 16:42:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tomas M <tomas@slax.org>
Cc: linux-kernel@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] loop file resizable
Message-Id: <20081118164207.137e92be.akpm@linux-foundation.org>
In-Reply-To: <492120DC.1070407@slax.org>
References: <492120DC.1070407@slax.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 08:44:28 +0100
Tomas M <tomas@slax.org> wrote:

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

Various people have tried this before, if I recall correctly.  One was
Akinobu Mita (cc'ed here).

I don't recall why that patch never was merged?

> 
> 
> Index: linux-2.6.27/drivers/block/loop.c
> ===================================================================
> retrieving revision 1.1
> diff -u -p -r1.1 loop.c
> --- linux-2.6.27/drivers/block/loop.c	7 Nov 2008 13:07:06 -0000	1.1
> +++ linux-2.6.27/drivers/block/loop.c	8 Nov 2008 03:29:47 -0000
> @@ -1142,6 +1142,8 @@ static int lo_ioctl(struct inode * inode
>  {
>  	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
>  	int err;
> +	sector_t sec;
> +	loff_t sz;
>  
>  	mutex_lock(&lo->lo_ctl_mutex);
>  	switch (cmd) {
> @@ -1166,6 +1168,16 @@ static int lo_ioctl(struct inode * inode
>  	case LOOP_GET_STATUS64:
>  		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
>  		break;
> +	case LOOP_SET_CAPACITY:
> +		err = figure_loop_size(lo);
> +		if (!err) {

It would be neater to declare `sec' and `sz' here.

> +			sec = get_capacity(lo->lo_disk);
> +			sz = sec << 9;
> +			mutex_lock(&inode->i_bdev->bd_mutex);
> +			bd_set_size(inode->i_bdev, sz);
> +			mutex_unlock(&inode->i_bdev->bd_mutex);
> +		}
> +		break;
>  	default:
>  		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
>  	}
> @@ -1311,6 +1323,7 @@ static long lo_compat_ioctl(struct file 
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
> diff -u -p -r1.1 loop.h
> --- linux-2.6.27/include/linux/loop.h	7 Nov 2008 13:05:58 -0000	1.1
> +++ linux-2.6.27/include/linux/loop.h	8 Nov 2008 03:22:36 -0000
> @@ -160,5 +160,6 @@ int loop_unregister_transfer(int number)
>  #define LOOP_SET_STATUS64	0x4C04
>  #define LOOP_GET_STATUS64	0x4C05
>  #define LOOP_CHANGE_FD		0x4C06
> +#define LOOP_SET_CAPACITY	0x4C07


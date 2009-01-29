Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbZA2BOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbZA2BOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 20:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZA2BOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 20:14:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbZA2BOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 20:14:41 -0500
Date: Wed, 28 Jan 2009 17:14:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, Paul.Clements@steeleye.com
Subject: Re: nbd: add locking to nbd_ioctl
Message-Id: <20090128171406.31745655.akpm@linux-foundation.org>
In-Reply-To: <20090126173132.GA2605@elf.ucw.cz>
References: <20090126173132.GA2605@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 18:31:33 +0100
Pavel Machek <pavel@suse.cz> wrote:

> 
> The code was written to rely on big kernel lock to protect it from
> races. It mostly works when interface is not abused.
> 
> So this uses tx_lock to protect data structures from concurrent use
> between ioctl and worker threads.
> 
> Next step will be moving from ioctl to unlocked_ioctl. 

I hope I got the latest version of this...

The patch adds new trailing whitespace.  Either a) you wanted to add
new trailing whitespace or b) you're not running checkpatch.  Either
way: bad Pavel!

>
> ...
>
> +	case NBD_SET_SOCK:
> +		{
> +			struct file *file;
> +			if (lo->file)
> +				return -EBUSY;
> +			file = fget(arg);
> +			if (file) {
> +				struct inode *inode = file->f_path.dentry->d_inode;
> +				if (S_ISSOCK(inode->i_mode)) {
> +					lo->file = file;
> +					lo->sock = SOCKET_I(inode);
> +					if (max_part > 0)
> +						bdev->bd_invalidated = 1;
> +					return 0;
> +				} else {
> +					fput(file);
> +				}
>  			}
>  		}
> -		return error;
> +		return -EINVAL;

This isn't terribly readable - the -EINVAL is in fact specifically a
response to receiving a !S_ISSOCK fd, but this is presented in a
rather obfuscated way.

>  	case NBD_SET_BLKSIZE:
>  		lo->blksize = arg;
>  		lo->bytesize &= ~(lo->blksize-1);
> @@ -634,47 +626,65 @@ static int nbd_ioctl(struct block_device
>  		set_blocksize(bdev, lo->blksize);
>  		set_capacity(lo->disk, lo->bytesize >> 9);
>  		return 0;
> +
>  	case NBD_SET_SIZE:
>  		lo->bytesize = arg & ~(lo->blksize-1);
>  		bdev->bd_inode->i_size = lo->bytesize;
>  		set_blocksize(bdev, lo->blksize);
>  		set_capacity(lo->disk, lo->bytesize >> 9);
>  		return 0;
> +
>  	case NBD_SET_TIMEOUT:
>  		lo->xmit_timeout = arg * HZ;
>  		return 0;
> +
>  	case NBD_SET_SIZE_BLOCKS:
>  		lo->bytesize = ((u64) arg) * lo->blksize;
>  		bdev->bd_inode->i_size = lo->bytesize;
>  		set_blocksize(bdev, lo->blksize);
>  		set_capacity(lo->disk, lo->bytesize >> 9);
>  		return 0;
> +
>  	case NBD_DO_IT:
> -		if (lo->pid)
> -			return -EBUSY;
> -		if (!lo->file)
> -			return -EINVAL;
> -		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
> -		if (IS_ERR(thread))
> -			return PTR_ERR(thread);
> -		wake_up_process(thread);
> -		error = nbd_do_it(lo);
> -		kthread_stop(thread);
> -		if (error)
> -			return error;
> -		sock_shutdown(lo, 1);
> -		file = lo->file;
> -		lo->file = NULL;
> -		nbd_clear_que(lo);
> -		printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
> -		if (file)
> -			fput(file);
> -		lo->bytesize = 0;
> -		bdev->bd_inode->i_size = 0;
> -		set_capacity(lo->disk, 0);
> -		if (max_part > 0)
> -			ioctl_by_bdev(bdev, BLKRRPART, 0);
> -		return lo->harderror;
> +		{
> +			struct task_struct *thread;
> +			struct file *file;
> +			int error;
> +
> +			if (lo->pid)
> +				return -EBUSY;
> +			if (!lo->file)
> +				return -EINVAL;
> +
> +			mutex_unlock(&lo->tx_lock);
> +
> +			thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
> +			if (IS_ERR(thread)) {
> +				mutex_lock(&lo->tx_lock);
> +				return PTR_ERR(thread);
> +			}
> +			wake_up_process(thread);

We could/should use kthread_run() here.

> +			error = nbd_do_it(lo);
> +			kthread_stop(thread);
> +
> +			mutex_lock(&lo->tx_lock);
> +			if (error)
> +				return error;
> +			sock_shutdown(lo, 0);
> +			file = lo->file;
> +			lo->file = NULL;
> +			nbd_clear_que(lo);
> +			printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);

I don't get it - why are we warning about what appears to be an
expected operation?

> +			if (file)
> +				fput(file);
> +			lo->bytesize = 0;
> +			bdev->bd_inode->i_size = 0;
> +			set_capacity(lo->disk, 0);
> +			if (max_part > 0)
> +				ioctl_by_bdev(bdev, BLKRRPART, 0);
> +			return lo->harderror;
> +		}
> +


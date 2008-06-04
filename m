Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYFDQok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYFDQok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 12:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYFDQod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 12:44:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62860 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYFDQoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:44:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC PATCH] fs code: Push the BKL down into the file system ioctl handlers
Date: Wed, 4 Jun 2008 18:43:20 +0200
User-Agent: KMail/1.9.9
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
References: <20080522231524.52e21eb8@core>
In-Reply-To: <20080522231524.52e21eb8@core>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806041843.20965.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/rNGpuFjQJISsgqTcyxQQfcsaIJzM+57gd91C
 4xrMjG3NbgpvcY4zNOofWWOJmcM2hlbK/JMcjkF0NRL+kZMRa9
 uOciOP7RL1bqe74j/QFXw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2008, Alan Cox wrote:
> --- a/drivers/char/raw.c
> +++ b/drivers/char/raw.c
> @@ -116,13 +116,15 @@ static int raw_release(struct inode *inode, struct file *filp)
>  /*
>   * Forward ioctls to the underlying block device.
>   */
> -static int
> -raw_ioctl(struct inode *inode, struct file *filp,
> -                 unsigned int command, unsigned long arg)
> +static long raw_ioctl(struct file *filp, unsigned int command,
> +                                               unsigned long arg)
>  {
> +       long ret;
>         struct block_device *bdev = filp->private_data;
> -
> -       return blkdev_ioctl(bdev->bd_inode, NULL, command, arg);
> +       lock_kernel();
> +       ret = blkdev_ioctl(bdev->bd_inode, NULL, command, arg);
> +       unlock_kernel();
> +       return ret;
>  }
>  
>  static void bind_device(struct raw_config_request *rq)

blkdev_ioctl and compat_blkdev_ioctl are converted already (they take
the BKL in all places of doubt), so you can call these directly without
calling lock_kernel() again.

However, reading through that code again, I noticed two nastybits:
* there is no compat_raw_ioctl function, so any user space program
trying 32 bit block ioctl calls on a raw device has been broken ever
since my patch that moved the block compat_ioctl handlers into
the block/compat_ioctl.c file. The same problem seems to exist
on pktcdvd.c.

* If any block driver had implemented unlocked_ioctl, it would be
even worse: The raw driver passes filp->private_data->bd_inode as
the inode and NULL as the file. blkdev_ioctl drops the inode
argument when calling into a driver and only passes filp, so 
if a driver then tries to access filp->f_mapping->host,
it gets a NULL pointer dereference.
Fortunately, no block driver to date implements unlocked_ioctl, and
compat_ioctl was protected from this bug by the missing
compat_raw_ioctl.

I suppose the right fix for this will be to make the blkdev
unlocked_ioctl and compat_ioctl take a bdev argument instead
of file and inode.

	Arnd <><

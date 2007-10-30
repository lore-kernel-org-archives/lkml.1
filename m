Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbXJ3UCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbXJ3UCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758139AbXJ3UCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:02:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40602 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753975AbXJ3UCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:02:21 -0400
Date: Tue, 30 Oct 2007 13:01:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       bernie@codewiz.org
Subject: Re: [PATCH] Allow auto-destruction of loop devices.
Message-Id: <20071030130137.3345ae43.akpm@linux-foundation.org>
In-Reply-To: <1193612911.2915.80.camel@shinybook.infradead.org>
References: <1193612911.2915.80.camel@shinybook.infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 19:08:31 -0400
David Woodhouse <dwmw2@infradead.org> wrote:

> This allows a flag to be set on loop devices so that when they are
> closed for the last time, they'll self-destruct.
> 

Why do we want to do this?

> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 56e2304..7fae828 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -973,6 +973,10 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
>  	lo->transfer = xfer->transfer;
>  	lo->ioctl = xfer->ioctl;
>  
> +	if ( (lo->lo_flags & LO_FLAGS_AUTOCLEAR) !=
> +	     (info->lo_flags & LO_FLAGS_AUTOCLEAR))
> +		lo->lo_flags ^= LO_FLAGS_AUTOCLEAR;
> +
>  	lo->lo_encrypt_key_size = info->lo_encrypt_key_size;
>  	lo->lo_init[0] = info->lo_init[0];
>  	lo->lo_init[1] = info->lo_init[1];
> @@ -1331,6 +1335,10 @@ static int lo_release(struct inode *inode, struct file *file)
>  
>  	mutex_lock(&lo->lo_ctl_mutex);
>  	--lo->lo_refcnt;
> +
> +	if ((lo->lo_flags & LO_FLAGS_AUTOCLEAR) && !lo->lo_refcnt)
> +		loop_clr_fd(lo, inode->i_bdev);
> +
>  	mutex_unlock(&lo->lo_ctl_mutex);
>  
>  	return 0;
> diff --git a/include/linux/loop.h b/include/linux/loop.h
> index 26a0a10..46169a7 100644
> --- a/include/linux/loop.h
> +++ b/include/linux/loop.h
> @@ -76,6 +76,7 @@ struct loop_device {
>  enum {
>  	LO_FLAGS_READ_ONLY	= 1,
>  	LO_FLAGS_USE_AOPS	= 2,
> +	LO_FLAGS_AUTOCLEAR	= 4,
>  };
>  
>  #include <asm/posix_types.h>	/* for __kernel_old_dev_t */
> 
> -- 
> dwmw2

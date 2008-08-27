Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYH0IJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYH0IJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 04:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYH0II6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 04:08:58 -0400
Received: from www.tglx.de ([62.245.132.106]:32919 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbYH0II5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 04:08:57 -0400
Date: Wed, 27 Aug 2008 10:08:38 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       hjk@linutronix.de
Subject: Re: [PATCH, RFC] uio BKL removal
Message-ID: <20080827080838.GA2283@local>
References: <20080826171532.2414c7a2@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826171532.2414c7a2@bike.lwn.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 05:15:32PM -0600, Jonathan Corbet wrote:
> I had a moment to dedicate to the BKL removal cause, so I went for the
> UIO driver, which seemed simple.  The main thing I found was that there
> was locking around some idr accesses, but not all, so I filled that
> in.  With that in place, removing the BKL from uio_open() seems safe,
> especially since none of the in-tree UIO drivers have open() or
> release() methods.  
> 
> (Incidentally, I don't see how uio_pdrv.c could ever work - who initializes
> uioinfo?)

That has to be done somewhere in your board specific file, e.g. for ARM
boards in arch/arm/mach-xxx/board-something.c - the same place where you
setup your struct platform_device.

> 
> If there's no complaints, I'll feed this into linux-next via the
> bkl-removal tree.

Seems right.

Acked-by: Hans J. Koch <hjk@linutronix.de>

> 
> Thanks,
> 
> jon
> 
> ---
> UIO: BKL removal
> 
> Remove the BKL from the UIO driver, and add complete locking where needed
> to serialize idr accesses.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 3a6934b..4f28f4b 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -47,6 +47,9 @@ static struct uio_class {
>  	struct class *class;
>  } *uio_class;
>  
> +/* Protect idr accesses */
> +static DEFINE_MUTEX(minor_lock);
> +
>  /*
>   * attributes
>   */
> @@ -231,7 +234,6 @@ static void uio_dev_del_attributes(struct uio_device *idev)
>  
>  static int uio_get_minor(struct uio_device *idev)
>  {
> -	static DEFINE_MUTEX(minor_lock);
>  	int retval = -ENOMEM;
>  	int id;
>  
> @@ -253,7 +255,9 @@ exit:
>  
>  static void uio_free_minor(struct uio_device *idev)
>  {
> +	mutex_lock(&minor_lock);
>  	idr_remove(&uio_idr, idev->minor);
> +	mutex_unlock(&minor_lock);
>  }
>  
>  /**
> @@ -297,8 +301,9 @@ static int uio_open(struct inode *inode, struct file *filep)
>  	struct uio_listener *listener;
>  	int ret = 0;
>  
> -	lock_kernel();
> +	mutex_lock(&minor_lock);
>  	idev = idr_find(&uio_idr, iminor(inode));
> +	mutex_unlock(&minor_lock);
>  	if (!idev) {
>  		ret = -ENODEV;
>  		goto out;
> @@ -324,18 +329,15 @@ static int uio_open(struct inode *inode, struct file *filep)
>  		if (ret)
>  			goto err_infoopen;
>  	}
> -	unlock_kernel();
>  	return 0;
>  
>  err_infoopen:
> -
>  	kfree(listener);
> -err_alloc_listener:
>  
> +err_alloc_listener:
>  	module_put(idev->owner);
>  
>  out:
> -	unlock_kernel();
>  	return ret;
>  }
>  

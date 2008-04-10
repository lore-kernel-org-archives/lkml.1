Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbYDJVCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbYDJVCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 17:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYDJVCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 17:02:40 -0400
Received: from www.tglx.de ([62.245.132.106]:53692 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbYDJVCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 17:02:40 -0400
Date: Thu, 10 Apr 2008 23:02:29 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] UIO: hold a reference to the device's owner while
	the device is open
Message-ID: <20080410210229.GF3193@local>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 02:37:00PM +0200, Uwe Kleine-König wrote:
> Otherwise the device might just disappear while /dev/uioX is being used
> which results in an Oops.

Hi Uwe,
thanks for this one, good catch! Looks fine to me. There are some minor issues, see
below.
And I'd like to hear Greg's opinion: Do you agree we can omit
try_module_get() in uio_mmap()?

Thanks,
Hans

> 
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> ---
>  drivers/uio/uio.c |   40 +++++++++++++++++++++++-----------------
>  1 files changed, 23 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 1175908..005fc55 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -301,25 +301,35 @@ static int uio_open(struct inode *inode, struct file *filep)
>  	if (!idev)
>  		return -ENODEV;
>  
> +	if (!try_module_get(idev->owner)) {
> +		ret = -ENODEV;
> +		goto err_module_get;
> +	}
> +
>  	listener = kmalloc(sizeof(*listener), GFP_KERNEL);
> -	if (!listener)
> -		return -ENOMEM;
> +	if (!listener) {
> +		ret = -ENOMEM;
> +		goto err_alloc_listener;
> +	}
>  
>  	listener->dev = idev;
>  	listener->event_count = atomic_read(&idev->event);
>  	filep->private_data = listener;
>  
>  	if (idev->info->open) {
> -		if (!try_module_get(idev->owner))
> -			return -ENODEV;
>  		ret = idev->info->open(idev->info, inode);
> -		module_put(idev->owner);
> -	}
> +		if (ret) {
> +			kfree(listener);
> +err_alloc_listener:
>  
> -	if (ret)
> -		kfree(listener);
> +			module_put(idev->owner);
> +err_module_get:
>  
> -	return ret;
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
>  }

I really don't like these labels inside the if-block. I find it hard to
read. What about this:


if (idev->info->open) {
	ret = idev->info->open(idev->info, inode);
	if (ret)
		kfree(listener);
	return ret;
}

err_alloc_listener:
	module_put(idev->owner);
err_module_get:
	return ret;



The label err_module_get should probably be omitted because it's used only
once and has just one line of code. You could simply write "return ret"
instead of "goto err_module_get".

}


>  
>  static int uio_fasync(int fd, struct file *filep, int on)
> @@ -336,12 +346,11 @@ static int uio_release(struct inode *inode, struct file *filep)
>  	struct uio_listener *listener = filep->private_data;
>  	struct uio_device *idev = listener->dev;
>  
> -	if (idev->info->release) {
> -		if (!try_module_get(idev->owner))
> -			return -ENODEV;
> +	if (idev->info->release)
>  		ret = idev->info->release(idev->info, inode);
> -		module_put(idev->owner);
> -	}
> +
> +	module_put(idev->owner);
> +
>  	if (filep->f_flags & FASYNC)
>  		ret = uio_fasync(-1, filep, 0);
>  	kfree(listener);
> @@ -510,10 +519,7 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
>  		return -EINVAL;
>  
>  	if (idev->info->mmap) {
> -		if (!try_module_get(idev->owner))
> -			return -ENODEV;
>  		ret = idev->info->mmap(idev->info, vma);
> -		module_put(idev->owner);
>  		return ret;
>  	}
>  
> -- 
> 1.5.4.5

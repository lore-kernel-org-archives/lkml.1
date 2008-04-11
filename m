Return-Path: <linux-kernel-owner+w=401wt.eu-S1760475AbYDKLje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475AbYDKLje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759691AbYDKLj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:39:26 -0400
Received: from www.tglx.de ([62.245.132.106]:55057 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757837AbYDKLj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:39:26 -0400
Date: Fri, 11 Apr 2008 13:39:17 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4 v2] UIO: hold a reference to the device's owner
	while the device is open
Message-ID: <20080411113916.GE3185@local>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410210229.GF3193@local> <20080411065027.GB18096@digi.com> <20080411084454.GA3185@local> <20080411090739.GA31625@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080411090739.GA31625@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 11:07:39AM +0200, Uwe Kleine-König wrote:
> Otherwise the device might just disappear while /dev/uioX is being used
> which results in an Oops.
> 
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

Looks alright, thanks!

Signed-off-by: Hans J Koch <hjk@linutronix.de>

> ---
> 
> Hans J. Koch wrote:
> > > > The label err_module_get should probably be omitted because it's used only
> > > > once and has just one line of code. You could simply write "return ret"
> > > > instead of "goto err_module_get".
> > > This makes code shuffling easier.  For example if someone decides that
> > > try_module_get should be done after allocating listener then you only
> > > have to exchange the two corresponding code blocks and the two groups
> > > (label + cleanup) in the error handling block.
> > > If the error handling is spread over the whole functions you can easily
> > > miss something---as happend above. :-)
> > 
> > Well, it depends. It's all about readability. Any function should be
> > written in a way that makes it as clear as possible what it does. Your
> > code is certainly not critical regarding that aspect, but I think it can
> > still be improved. And a label that is used only once and contains only
> > one line of code is definetly unnecessary. I don't follow the
> > maybe-one-day-in-the-future-it-might-be-useful philosophy. I like code
> > that is as clean and readable as possible _now_.
> That thing about code reordering is minor compared to having all error
> handling in one place, but ...
> 
> >                                                  And as this patch is
> > not just a driver but affects the UIO core, this is even more important.
> > 
> > Could you please send an updated patch?
> ... , it's your code, so you can find a new version below.

It's not _my_ code, it's _our_ code, partly written by me. At home, I use any
coding style I like. But this is in mainline, so we use the coding style the
kernel community has agreed upon.

> 
> Best regards
> Uwe
> 
>  drivers/uio/uio.c |   36 +++++++++++++++++++++---------------
>  1 files changed, 21 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 1175908..55cc7b8 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -301,23 +301,33 @@ static int uio_open(struct inode *inode, struct file *filep)
>  	if (!idev)
>  		return -ENODEV;
>  
> +	if (!try_module_get(idev->owner))
> +		return -ENODEV;
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
> +		if (ret)
> +			goto err_infoopen;
>  	}
>  
> -	if (ret)
> -		kfree(listener);
> +	return 0;
> +
> +err_infoopen:
> +
> +	kfree(listener);
> +err_alloc_listener:
> +
> +	module_put(idev->owner);
>  
>  	return ret;
>  }
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
> 
> 
> -- 
> Uwe Kleine-König, Software Engineer
> Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
> Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962

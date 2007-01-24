Return-Path: <linux-kernel-owner+w=401wt.eu-S1750786AbXAXXn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750786AbXAXXn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 18:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbXAXXn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 18:43:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXAXXn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 18:43:57 -0500
Date: Wed, 24 Jan 2007 15:42:59 -0800
From: Greg KH <gregkh@suse.de>
To: Vitaly Bordug <vbordug@ru.mvista.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: drivers/base: device_bind_driver() fix
Message-ID: <20070124234259.GB2160@suse.de>
References: <20070124171441.6a07d06b@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124171441.6a07d06b@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 05:14:41PM +0300, Vitaly Bordug wrote:
> 
> Keeps sysfs from creating link if device is already bound to driver.
> Similar behavior was before the rework;

Which "rework" caused this?

> now without this patch fixed PHY will complain about not been able to
> create file in sysfs.

Which device is being bound to a driver before it is registered?  I know
the i2c layer does it, but I haven't had any people reporting issues
there.

> Signed-off-by: Vitaly Bordug <vbordug@ru.mvista.com>
> ---
> 
>  drivers/base/dd.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 510e788..6da3d01 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -26,12 +26,12 @@
>  #define to_drv(node) container_of(node, struct device_driver, kobj.entry)
>  
>  
> -static void driver_bound(struct device *dev)
> +static int driver_bound(struct device *dev)
>  {
>  	if (klist_node_attached(&dev->knode_driver)) {
>  		printk(KERN_WARNING "%s: device %s already bound\n",
>  			__FUNCTION__, kobject_name(&dev->kobj));
> -		return;
> +		return 0;
>  	}
>  
>  	pr_debug("bound device '%s' to driver '%s'\n",
> @@ -42,6 +42,7 @@ static void driver_bound(struct device *dev)
>  					     BUS_NOTIFY_BOUND_DRIVER, dev);
>  
>  	klist_add_tail(&dev->knode_driver, &dev->driver->klist_devices);
> +	return 1;

Please return 0 for "good" and -ERRORSOMETHING for a when a problem
happens, like the rest of the kernel.

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbXKPREv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbXKPREv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXKPREo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:04:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39236 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbXKPREn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:04:43 -0500
Subject: Re: [PATCH] Driver core: fix race in __device_release_driver
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0711161151340.3268-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0711161151340.3268-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 12:04:55 -0500
Message-Id: <1195232695.2533.120.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-16 at 11:57 -0500, Alan Stern wrote:
> This patch (as1013) was suggested by David Woodhouse; it fixes a race
> in the driver core.  If a device is unregistered at the same time as
> its driver is unloaded, the driver's code pages may be unmapped while
> the remove method is still running.  The calls to get_driver() and
> put_driver() were intended to prevent this, but they don't work if the
> driver's module count has already dropped to 0.
> 
> Instead, the patch keeps the device on the driver's list until after
> the remove method has returned.  This forces the necessary
> synchronization to occur.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: David Woodhouse <dwmw2@infradead.org>

Since we're submitting it rather than just using it to explain the
problem, I suppose I should add:
Signed-off-by: David Woodhouse <dwmw2@infradead.org>

> ---
> 
> This should be considered for 2.6.24.
> 
> 
> Index: usb-2.6/drivers/base/dd.c
> ===================================================================
> --- usb-2.6.orig/drivers/base/dd.c
> +++ usb-2.6/drivers/base/dd.c
> @@ -289,11 +289,10 @@ static void __device_release_driver(stru
>  {
>  	struct device_driver * drv;
>  
> -	drv = get_driver(dev->driver);
> +	drv = dev->driver;
>  	if (drv) {
>  		driver_sysfs_remove(dev);
>  		sysfs_remove_link(&dev->kobj, "driver");
> -		klist_remove(&dev->knode_driver);
>  
>  		if (dev->bus)
>  			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
> @@ -306,7 +305,7 @@ static void __device_release_driver(stru
>  			drv->remove(dev);
>  		devres_release_all(dev);
>  		dev->driver = NULL;
> -		put_driver(drv);
> +		klist_remove(&dev->knode_driver);
>  	}
>  }
>  
> 
-- 
dwmw2


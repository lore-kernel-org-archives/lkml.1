Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbZHGPlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbZHGPlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZHGPlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:41:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55007 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752935AbZHGPlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:41:22 -0400
Date: Fri, 7 Aug 2009 11:41:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH update x2] PM: Introduce core framework for run-time PM
 of I/O devices (rev. 13)
In-Reply-To: <200908062353.14822.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908071130440.3063-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Aug 2009, Rafael J. Wysocki wrote:

> Hi,
> 
> The patch below should address all of your most recent comments.

Only two comments.


> +static int __pm_request_idle(struct device *dev)
> +{
...
> +	if (dev->power.request_pending) {
> +		/* Any requests other then RPM_REQ_IDLE take precedence. */
> +		if (dev->power.request != RPM_REQ_NONE)

Replace != with ==.

> +			dev->power.request = RPM_REQ_IDLE;
> +		else if (dev->power.request != RPM_REQ_IDLE)
> +			retval = -EAGAIN;
> +		return retval;


> --- linux-2.6.orig/drivers/base/dd.c
> +++ linux-2.6/drivers/base/dd.c
...
> @@ -306,6 +317,8 @@ static void __device_release_driver(stru
>  
>  	drv = dev->driver;
>  	if (drv) {
> +		pm_runtime_disable(dev);
> +
>  		driver_sysfs_remove(dev);
>  
>  		if (dev->bus)
> @@ -324,6 +337,8 @@ static void __device_release_driver(stru
>  			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
>  						     BUS_NOTIFY_UNBOUND_DRIVER,
>  						     dev);
> +
> +		pm_runtime_enable(dev);
>  	}
>  }

We may need to be more careful here.  The driver's remove method may
want to do some runtime PM stuff to the device before giving up
control.  On the other hand I'm not sure what _should_ be done here, so
I can't suggest anything better.

Alan Stern


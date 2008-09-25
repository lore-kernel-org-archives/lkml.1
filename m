Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbYIYVVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbYIYVVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYIYVVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:21:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56597 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbYIYVVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:21:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: use pm_op methods for device types
Date: Thu, 25 Sep 2008 23:27:02 +0200
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0809251704580.2181-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0809251704580.2181-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809252327.03305.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 25 of September 2008, Alan Stern wrote:
> This patch (as1141) adds code to use the device type's pm_op methods,
> if they are defined.  It fixes a regression in the USB PM code; the
> various suspend and resume methods are defined in the device type
> rather than in the bus, because USB devices have to be handled
> differently from USB interfaces.  Without the patch, those methods
> never get called.
> 
> The patch also fixes a couple of spelling errors.

Hm, these changes are not needed in the current mainline, so there's a patch
in -next that removes the code added by this patch.

It might be better to find that patch and drop it instead, IMO.

> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Tested-by: Jiri Slaby <jirislaby@gmail.com>
> 
> ---
> 
> This should be merged before 2.6.27 is released, if possible.  
> Otherwise people will find their systems refuse to suspend when any USB
> devices are attached.
> 
> 
> 
> Index: usb-2.6/drivers/base/power/main.c
> ===================================================================
> --- usb-2.6.orig/drivers/base/power/main.c
> +++ usb-2.6/drivers/base/power/main.c
> @@ -107,7 +107,7 @@ void device_pm_remove(struct device *dev
>  }
>  
>  /**
> - *	pm_op - execute the PM operation appropiate for given PM event
> + *	pm_op - execute the PM operation appropriate for given PM event
>   *	@dev:	Device.
>   *	@ops:	PM operations to choose from.
>   *	@state:	PM transition of the system being carried out.
> @@ -166,7 +166,7 @@ static int pm_op(struct device *dev, str
>  }
>  
>  /**
> - *	pm_noirq_op - execute the PM operation appropiate for given PM event
> + *	pm_noirq_op - execute the PM operation appropriate for given PM event
>   *	@dev:	Device.
>   *	@ops:	PM operations to choose from.
>   *	@state: PM transition of the system being carried out.
> @@ -363,6 +363,13 @@ static int resume_device(struct device *
>  			goto End;
>  	}
>  
> +	if (dev->type && dev->type->pm) {
> +		pm_dev_dbg(dev, state, "type ");
> +		error = pm_op(dev, dev->type->pm, state);
> +		if (error)
> +			goto End;
> +	}
> +
>  	if (dev->class) {
>  		if (dev->class->pm) {
>  			pm_dev_dbg(dev, state, "class ");
> @@ -596,6 +603,13 @@ static int suspend_device(struct device 
>  			goto End;
>  	}
>  
> +	if (dev->type && dev->type->pm) {
> +		pm_dev_dbg(dev, state, "type ");
> +		error = pm_op(dev, dev->type->pm, state);
> +		if (error)
> +			goto End;
> +	}
> +
>  	if (dev->bus) {
>  		if (dev->bus->pm) {
>  			pm_dev_dbg(dev, state, "");
> 
> 
> 



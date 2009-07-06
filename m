Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbZGFWEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbZGFWEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 18:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZGFWEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 18:04:13 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:9655 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbZGFWEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 18:04:12 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2009 18:04:12 EDT
X-IronPort-AV: E=Sophos;i="4.42,358,1243828800"; 
   d="scan'208";a="57458311"
Message-ID: <4A5272A6.6090302@citrix.com>
Date: Mon, 06 Jul 2009 14:54:46 -0700
From: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: wait up to 5 minutes for device connection
References: <1246626771-11345-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1246626771-11345-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jul 2009 21:54:49.0176 (UTC) FILETIME=[6219B580:01C9FE84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/09 06:12, Paolo Bonzini wrote:
> Increases the device timeout from 10s to 5 minutes, giving the user a visual
> indication during that time in case there are problems.  The patch is a
> backport of changesets 144, 146, 150 and 909 in the Xenbits tree.
>   

This patch does a lot more than change the timeout.  Please split it
into logically distinct patches (one for each of the changesets, if that
makes sense) with proper descriptions and a note linking it back to the
source changeset.

Thanks,
    J

> Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/xen/xenbus/xenbus_probe.c |   42 +++++++++++++++++++++++++-----------
>  1 files changed, 29 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
> index d42e25d..4f69159 100644
> --- a/drivers/xen/xenbus/xenbus_probe.c
> +++ b/drivers/xen/xenbus/xenbus_probe.c
> @@ -843,7 +843,7 @@ postcore_initcall(xenbus_probe_init);
>  
>  MODULE_LICENSE("GPL");
>  
> -static int is_disconnected_device(struct device *dev, void *data)
> +static int is_device_connecting(struct device *dev, void *data)
>  {
>  	struct xenbus_device *xendev = to_xenbus_device(dev);
>  	struct device_driver *drv = data;
> @@ -861,14 +861,15 @@ static int is_disconnected_device(struct device *dev, void *data)
>  		return 0;
>  
>  	xendrv = to_xenbus_driver(dev->driver);
> -	return (xendev->state != XenbusStateConnected ||
> -		(xendrv->is_ready && !xendrv->is_ready(xendev)));
> +	return (xendev->state < XenbusStateConnected ||
> +		(xendev->state == XenbusStateConnected &&
> +		 xendrv->is_ready && !xendrv->is_ready(xendev)));
>  }
>  
> -static int exists_disconnected_device(struct device_driver *drv)
> +static int exists_connecting_device(struct device_driver *drv)
>  {
>  	return bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
> -				is_disconnected_device);
> +				is_device_connecting);
>  }
>  
>  static int print_device_status(struct device *dev, void *data)
> @@ -884,10 +885,13 @@ static int print_device_status(struct device *dev, void *data)
>  		/* Information only: is this too noisy? */
>  		printk(KERN_INFO "XENBUS: Device with no driver: %s\n",
>  		       xendev->nodename);
> -	} else if (xendev->state != XenbusStateConnected) {
> +	} else if (xendev->state < XenbusStateConnected) {
> +		enum xenbus_state rstate = XenbusStateUnknown;
> +		if (xendev->otherend)
> +			rstate = xenbus_read_driver_state(xendev->otherend);
>  		printk(KERN_WARNING "XENBUS: Timeout connecting "
> -		       "to device: %s (state %d)\n",
> -		       xendev->nodename, xendev->state);
> +		       "to device: %s (local state %d, remote state %d)\n",
> +		       xendev->nodename, xendev->state, rstate);
>  	}
>  
>  	return 0;
> @@ -897,7 +901,7 @@ static int print_device_status(struct device *dev, void *data)
>  static int ready_to_wait_for_devices;
>  
>  /*
> - * On a 10 second timeout, wait for all devices currently configured.  We need
> + * On a 5-minute timeout, wait for all devices currently configured.  We need
>   * to do this to guarantee that the filesystems and / or network devices
>   * needed for boot are available, before we can allow the boot to proceed.
>   *
> @@ -912,18 +916,30 @@ static int ready_to_wait_for_devices;
>   */
>  static void wait_for_devices(struct xenbus_driver *xendrv)
>  {
> -	unsigned long timeout = jiffies + 10*HZ;
> +	unsigned long start = jiffies;
>  	struct device_driver *drv = xendrv ? &xendrv->driver : NULL;
> +	unsigned int seconds_waited = 0;
>  
>  	if (!ready_to_wait_for_devices || !xen_domain())
>  		return;
>  
> -	while (exists_disconnected_device(drv)) {
> -		if (time_after(jiffies, timeout))
> -			break;
> +	while (exists_connecting_device(drv)) {
> +		if (time_after(jiffies, start + (seconds_waited+5)*HZ)) {
> +			if (!seconds_waited)
> +				printk(KERN_WARNING "XENBUS: Waiting for "
> +				       "devices to initialise: ");
> +			seconds_waited += 5;
> +			printk("%us...", 300 - seconds_waited);
> +			if (seconds_waited == 300)
> +				break;
> +		}
> +
>  		schedule_timeout_interruptible(HZ/10);
>  	}
>  
> +	if (seconds_waited)
> +		printk("\n");
> +
>  	bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
>  			 print_device_status);
>  }
>   


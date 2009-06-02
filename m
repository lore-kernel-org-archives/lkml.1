Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbZFBWxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbZFBWxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZFBWxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:53:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34796 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbZFBWxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:53:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH v2] usb: avoid PM error messages during resume if a device was disconnected
Date: Wed, 3 Jun 2009 00:53:40 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906021745380.3960-100000@iolanthe.rowland.org> <200906030026.08399.elendil@planet.nl>
In-Reply-To: <200906030026.08399.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906030053.41385.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 June 2009, Frans Pop wrote:
> Currently if a laptop is suspended e.g. while docked and then resumed after
> undocking it, the following errors get generated because the USB hub in the
> docking station and the devices connected to it are no longer available:
> pm_op(): usb_dev_resume+0x0/0x10 returns -19
> PM: Device 1-2 failed to resume: error -19
> pm_op(): usb_dev_resume+0x0/0x10 returns -19
> PM: Device 1-2.2 failed to resume: error -19
> pm_op(): usb_dev_resume+0x0/0x10 returns -19
> PM: Device 1-2.3 failed to resume: error -19
> 
> As the removal of USB devices while a system is suspended is a relatively
> common use case and in most cases not an error, just return success on
> -ENODEV. The user gets informed anyway as the USB subsystem generates
> regular disconnect messages for the devices shortly afterwards:
> usb 1-2: USB disconnect, address 3
> usb 1-2.2: USB disconnect, address 4
> usblp0: removed
> usb 1-2.3: USB disconnect, address 5
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> 
> On Tuesday 02 June 2009, Alan Stern wrote:
> > If we change -ENODEV to 0, the change should be made in usb_resume()
> > rather than usb_external_resume_device().
> 
> Like so?
> Agreed that it's cleaner and tested that it works just as well :-)
> 
> Cheers,
> FJP
> 
> diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
> index d0a21a5..0aaf26e 100644
> --- a/drivers/usb/core/driver.c
> +++ b/drivers/usb/core/driver.c
> @@ -1762,6 +1762,7 @@ int usb_suspend(struct device *dev, pm_message_t msg)
>  int usb_resume(struct device *dev, pm_message_t msg)
>  {
>  	struct usb_device	*udev;
> +	int			status;
>  
>  	udev = to_usb_device(dev);
>  
> @@ -1771,7 +1772,14 @@ int usb_resume(struct device *dev, pm_message_t msg)
>  	 */
>  	if (udev->skip_sys_resume)
>  		return 0;
> -	return usb_external_resume_device(udev, msg);
> +	status = usb_external_resume_device(udev, msg);
> +
> +	/* Avoid PM error messages for devices disconnected while suspended
> +	 * as we'll display regular disconnect messages just a bit later.
> +	 */
> +	if (status == -ENODEV)
> +		return 0;
> +	return status;

+ return status == -ENODEV ? 0 : status;

maybe?

>  }
>  
>  #endif /* CONFIG_PM */

Best,
Rafael

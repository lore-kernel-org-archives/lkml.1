Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbZFHUoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbZFHUoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 16:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbZFHUoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 16:44:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:53296 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750998AbZFHUop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 16:44:45 -0400
Date: Mon, 8 Jun 2009 16:44:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthew Garrett <mjg@redhat.com>
cc: alan-jenkins@tuffmail.co.uk, Pekka Enberg <penberg@cs.helsinki.fi>,
       Corentin Chary <corentin.chary@gmail.com>,
       <acpi4asus-user@lists.sourceforge.net>, <len.brown@intel.com>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
In-Reply-To: <20090608150039.GB17579@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0906081636190.13888-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Matthew Garrett wrote:

> On Sun, Jun 07, 2009 at 11:10:52PM -0400, Alan Stern wrote:
> > On Mon, 8 Jun 2009, Matthew Garrett wrote:
> > 
> > > On Sun, Jun 07, 2009 at 11:03:48PM -0400, Alan Stern wrote:
> > > 
> > > > There's no mechanism for this.  It many environments it couldn't work,
> > > > because the decision about whether to enable autosuspend is made when
> > > > the device is first created (i.e., when the creation uevent is
> > > > received), whereas driver binding doesn't occur until later.
> > > 
> > > There's a lot of power management situations where you don't end up with 
> > > the optimal power configuration until a driver's bound. It's certainly 
> > > possible to do this in userspace, but if we know that the hardware 
> > > supported by a given driver will always work then it seems reasonable to 
> > > have it whitelist autosuspend on that device.
> > 
> > Sure.  Such a thing could be added easily enough.  It just doesn't 
> > exist now, that's all.
> 
> Something roughly like this? We'd probably also want a function call so 
> drivers can do it based on the ID of the device they're handling, but in 
> some cases we can probably assume that all devices supported by the 
> driver will work.

My preference would be to use a function call always, rather than 
relying on static driver information.  It provides more flexibility.

> diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
> index d0a21a5..36f63a7 100644
> --- a/drivers/usb/core/driver.c
> +++ b/drivers/usb/core/driver.c
> @@ -355,6 +355,8 @@ int usb_driver_claim_interface(struct usb_driver *driver,
>  	iface->condition = USB_INTERFACE_BOUND;
>  	mark_active(iface);
>  	iface->pm_usage_cnt = !(driver->supports_autosuspend);
> +	if (driver->supports_autosuspend && driver->enable_autosuspend)
> +		udev->autosuspend_disabled=0;

Style violation: You should have blanks around the '=' sign.  :-)

>  	usb_pm_unlock(udev);

That's right.  If implemented as a function, turning off
udev->autosuspend_disabled is all the function would need to do
(provided we add the restriction that it should never be called from
anywhere except inside a driver's probe routine).

Alan Stern


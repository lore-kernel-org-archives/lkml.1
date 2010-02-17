Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab0BQNYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:24:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:35704 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496Ab0BQNYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:24:12 -0500
Date: Wed, 17 Feb 2010 14:24:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Marcel Holtmann <marcel@holtmann.org>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: S2R resume crash in 2.6.33-rc7 - NULL pointer dereference in
 dev_get_drvdata() for usbhid
In-Reply-To: <20100213193609.3337b3f0@neptune.home>
Message-ID: <alpine.LNX.2.00.1002171423010.30967@pobox.suse.cz>
References: <20100213135720.603e5f64@neptune.home> <Pine.LNX.4.44L0.1002131238580.23844-100000@netrider.rowland.org> <20100213193609.3337b3f0@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Feb 2010, Bruno Prémont wrote:

> > > This lets me guess that hid_add_device() is doing something wrong
> > > here when report parsing fails... (as that one is the only one which
> > > could be doing the initialization of usbhid which does work for the
> > > first interface announced by my keyboard)
> > 
> > I don't know about doing anything wrong...  However it does appear
> > that in this case the interface is registered on the HID bus but
> > doesn't get bound to a driver.  Jiri will know whether or not that's
> > the desired outcome.
> > 
> > On the other hand, I don't think there would be anything wrong with 
> > moving the
> > 
> > 	usbhid->intf = intf;
> > 	usbhid->ifnum = interface->desc.bInterfaceNumber;
> > 
> > lines from usbhid_start() to usbhid_probe(), just before the call to
> > hid_add_device().  It should fix the bug, and those lines do belong in
> > the probe routine.  Jiri, any problems with doing this?
> 
> With the below patch (which is only half of the move work) I don't
> get crashes anymore. Though I wonder if other initialization steps
> (like the spin_lock_init() right before setting usbhid->intf) would
> need to be moved as well.
> 
> Bruno
> 
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index e2997a8..690ca75 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -1154,6 +1154,8 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
>  
>  	hid->driver_data = usbhid;
>  	usbhid->hid = hid;
> +	usbhid->intf = intf;
> +	usbhid->ifnum = interface->desc.bInterfaceNumber;
>  
>  	ret = hid_add_device(hid);
>  	if (ret) {
> 

Thanks for beating me with looking into this guys.

I have pushed fix for this into for-next branch, so it should appear in 
tomorrow linux-next pile. If you still experience the problem, please let 
me know.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

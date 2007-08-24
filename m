Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbXHXSiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbXHXSiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761511AbXHXSiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:38:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60558 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468AbXHXSiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:38:11 -0400
Date: Fri, 24 Aug 2007 11:35:48 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Matt Colyer <matt@colyer.name>,
       linux-kernel@vger.kernel.org, jeffm@suse.de,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [RFC] USB: driver for iphone charging
Message-ID: <20070824183548.GA14879@kroah.com>
References: <200708240920.46397.oliver@neukum.org> <Pine.LNX.4.44L0.0708241006440.3862-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0708241006440.3862-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 10:08:46AM -0400, Alan Stern wrote:
> On Fri, 24 Aug 2007, Oliver Neukum wrote:
> 
> > This schedules the change via a workqueue, so you'll be reprobed. If you
> > fire of the first vendor command you are doing so before the configuration
> > is changed. How is this supposed to work?
> 
> I would do it like this:
> 
> static int iphone_probe(struct usb_interface *intf,
> 			const struct usb_device_id *id)
> {
> 	struct usb_device *udev = interface_to_usbdev(intf);
> 	int rc;
> 
> 	if (udev->actconfig->desc.bConfigurationValue != 3) {
> 		dbg(&udev->dev, "Calling set_configuration\n");
> 		rc = usb_driver_set_configuration(udev, 3);
> 	} else {
> 		dbg(&udev->dev, "Configuration set, sending magic comand\n");
> 		rc = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
> 				0x40, (USB_DIR_OUT | USB_TYPE_VENDOR |
> 					USB_RECIP_DEVICE),
> 				0x6400, 0, NULL, 0, 1000);
> 	}
> 	if (rc)
> 		dev_err(&udev->dev, "Command failed: %d\n", rc);
> 
> 	/* we don't really want to bind to the device, userspace programs can
> 	 * handle the syncing just fine, so get outta here. */
> 	return -ENODEV;
> }

Yeah, that would make more sense, if that is what is needed.

Can someone with a iphone test this out?  If you look at how the
berry_charge driver does it, the set_config stuff happens after the
magic command.  As I don't have an iphone, nor have I ever seen any
dumps of the command streams, I don't really know if the set_config
message really is necessary or not.

thanks,

greg k-h

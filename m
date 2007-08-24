Return-Path: <linux-kernel-owner+w=401wt.eu-S1765291AbXHXS4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765291AbXHXS4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759759AbXHXSzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:55:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57967 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758742AbXHXSzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:55:54 -0400
Date: Fri, 24 Aug 2007 14:55:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Oliver Neukum <oliver@neukum.org>, Matt Colyer <matt@colyer.name>,
       <linux-kernel@vger.kernel.org>, <jeffm@suse.de>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [RFC] USB: driver for iphone charging
In-Reply-To: <20070824183548.GA14879@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0708241449520.22079-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007, Greg KH wrote:

> Can someone with a iphone test this out?  If you look at how the
> berry_charge driver does it, the set_config stuff happens after the
> magic command.  As I don't have an iphone, nor have I ever seen any
> dumps of the command streams, I don't really know if the set_config
> message really is necessary or not.

You know, now that I think back on it, it may be that the Set-Config
really does have to come after the magic command.  Perhaps it triggers
the changeover.  In which case the subroutine should look like this:

static int iphone_probe(struct usb_interface *intf,
			const struct usb_device_id *id)
{
	struct usb_device *udev = interface_to_usbdev(intf);
	int rc;

	if (udev->actconfig->desc.bConfigurationValue != 3) {
		dbg(&udev->dev, "Sending magic comand\n");
		rc = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
				0x40, (USB_DIR_OUT | USB_TYPE_VENDOR |
					USB_RECIP_DEVICE),
				0x6400, 0, NULL, 0, 1000);
		if (rc)
			dev_err(&udev->dev, "Command failed: %d\n", rc);
		else {
			dbg(&udev->dev, "Calling set_configuration\n");
			rc = usb_driver_set_configuration(udev, 3);
			if (rc)
				dev_err(&udev->dev, "Set-Config failed: %d\n",
						rc);
		}
	}

	/* we don't really want to bind to the device, userspace programs can
	 * handle the syncing just fine, so get outta here. */
	return -ENODEV;
}

However Oliver's point is well taken.  This simple sort of manipulation
could easily be done by a user program, started up by udev.

Alan Stern


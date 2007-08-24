Return-Path: <linux-kernel-owner+w=401wt.eu-S1765985AbXHXOIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765985AbXHXOIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 10:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbXHXOIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 10:08:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42642 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751109AbXHXOIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 10:08:47 -0400
Date: Fri, 24 Aug 2007 10:08:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Greg KH <greg@kroah.com>, Matt Colyer <matt@colyer.name>,
       <linux-kernel@vger.kernel.org>, <jeffm@suse.de>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [RFC] USB: driver for iphone charging
In-Reply-To: <200708240920.46397.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0708241006440.3862-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007, Oliver Neukum wrote:

> This schedules the change via a workqueue, so you'll be reprobed. If you
> fire of the first vendor command you are doing so before the configuration
> is changed. How is this supposed to work?

I would do it like this:

static int iphone_probe(struct usb_interface *intf,
			const struct usb_device_id *id)
{
	struct usb_device *udev = interface_to_usbdev(intf);
	int rc;

	if (udev->actconfig->desc.bConfigurationValue != 3) {
		dbg(&udev->dev, "Calling set_configuration\n");
		rc = usb_driver_set_configuration(udev, 3);
	} else {
		dbg(&udev->dev, "Configuration set, sending magic comand\n");
		rc = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
				0x40, (USB_DIR_OUT | USB_TYPE_VENDOR |
					USB_RECIP_DEVICE),
				0x6400, 0, NULL, 0, 1000);
	}
	if (rc)
		dev_err(&udev->dev, "Command failed: %d\n", rc);

	/* we don't really want to bind to the device, userspace programs can
	 * handle the syncing just fine, so get outta here. */
	return -ENODEV;
}

Alan Stern


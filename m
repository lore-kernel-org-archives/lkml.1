Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYH0DM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYH0DM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 23:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYH0DMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 23:12:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:46603 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbYH0DMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 23:12:17 -0400
Date: Tue, 26 Aug 2008 20:12:05 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: Stefan Kopp <stefan_kopp@agilent.com>, Marcel Janssen <korgull@home.nl>,
       Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: add USB test and measurement class driver
Message-ID: <20080827031205.GA22912@kroah.com>
References: <20080827000501.GA29570@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827000501.GA29570@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 05:05:01PM -0700, Greg KH wrote:
> I've now added this to my tree, and any review comments are greatly
> welcome.

Heck, I'll review my own patch, as I noticed I forgot some things:

> ---
>  drivers/usb/class/Kconfig  |   10 
>  drivers/usb/class/Makefile |    1 
>  drivers/usb/class/usbtmc.c | 1058 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/usb/class/usbtmc.h |   24 +
>  include/linux/usb/tmc.h    |   27 +
>  5 files changed, 1120 insertions(+)

needs Documentation/ABI description of new sysfs files

> +/*
> + * This structure is the capabilities for the device
> + * See section 4.2.1.8 of the USBTMC specification for details.
> + */
> +struct usbtmc_dev_capabilities {
> +	__u8 interface_capabilities;
> +	__u8 device_capabilities;
> +	__u8 usb488_interface_capabilities;
> +	__u8 usb488_device_capabilities;
> +};

These should match the usbif description names to make it easier to
understand.

> +	/* USBTMC devices have only one setting, so use that */
> +	iface_desc = data->intf->cur_altsetting;
> +
> +	/* Find bulk in endpoint */
> +	for (n = 0; n < iface_desc->desc.bNumEndpoints; n++) {
> +		endpoint = &iface_desc->endpoint[n].desc;
> +
> +		if (usb_endpoint_is_bulk_in(endpoint)) {
> +			data->bulk_in = endpoint->bEndpointAddress;
> +			dev_dbg(dev, "Found bulk in endpoint at %u\n",
> +				data->bulk_in);
> +			break;
> +		}
> +	}
> +
> +	/* Find bulk out endpoint */
> +	for (n = 0; n < iface_desc->desc.bNumEndpoints; n++) {
> +		endpoint = &iface_desc->endpoint[n].desc;
> +
> +		if (usb_endpoint_is_bulk_out(endpoint)) {
> +			data->bulk_out = endpoint->bEndpointAddress;
> +			dev_dbg(dev, "Found Bulk out endpoint at %u\n",
> +				data->bulk_out);
> +			break;
> +		}
> +	}

This can all be done at probe() time, no need to wait until open().

> +static ssize_t usbtmc_write(struct file *filp, const char __user *buf,
> +			    size_t count, loff_t *f_pos)
> +{
> +	struct usbtmc_device_data *data;
> +	u8 *buffer;
> +	int retval;
> +	int actual;
> +	unsigned long int n_bytes;
> +	int n;
> +	int remaining;
> +	int done;
> +	int this_part;
> +
> +	data = filp->private_data;
> +	buffer = data->buffer;

This buffer should be local to the function, and not the device as we
could overlap reads and writes.  It should be removed from the device
itself to make sure everything is correct.  The ioctls already have
their own local buffers, fixing a bug in the original driver which used
1! buffer for all devices and all commands...

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S966910AbXFGXFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966910AbXFGXFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932197AbXFGXE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:04:57 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44256 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762068AbXFGXE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:04:56 -0400
Date: Thu, 7 Jun 2007 16:01:46 -0700
From: Greg KH <greg@kroah.com>
To: Kevin Lloyd <klloyd@sierrawireless.com>
Cc: gregkh@suse.de, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, linux@sierrawireless.com
Subject: Re: [PATCH 2.6.22-rc4] USB: add support for TRU-install (C) and
	new VID/PIDs to Sierra Wireless driver (ATTEMPT 2)
Message-ID: <20070607230146.GA5119@kroah.com>
References: <466751DA.40506@sierrawireless.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466751DA.40506@sierrawireless.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 05:31:22PM -0700, Kevin Lloyd wrote:
>  From: Kevin Lloyd <linux@sierrawireless.com>
> 
>  This patch is derived from the 2.6.22-rc4 kernel source and adds support for 
>  the
>  new TRU-install (C) feature (without this support new devices will not 
>  work), and
>  add new UMTS device VID/PIDs.
> 
>  There was a previous submission on Tuesday June 5th, it was pointed out that 
>  it was
>  targeted for an outdated kernel, please use this one instead.

Hm, I tried fixing this up by hand, but there is one major thing that I
think you need to change so I'll ask you to do it:

>  @@ -1,6 +1,8 @@
>  /*
>    USB Driver for Sierra Wireless
>  +  Targeted for 2.6.22 kernel

This is not needed.

>  +
>    Copyright (C) 2006  Kevin Lloyd <linux@sierrawireless.com>
>    IMPORTANT DISCLAIMER: This driver is not commercially supported by
>  @@ -15,9 +17,9 @@
>  */
>  -#define DRIVER_VERSION "v.1.0.6"
>  +#define DRIVER_VERSION "v.1.2.3"
>  #define DRIVER_AUTHOR "Kevin Lloyd <linux@sierrawireless.com>"
>  -#define DRIVER_DESC "USB Driver for Sierra Wireless USB modems"
>  +#define DRIVER_DESC "USB Driver for Sierra Wireless modems"
>  #include <linux/kernel.h>
>  #include <linux/jiffies.h>
>  @@ -28,66 +30,53 @@
>  #include <linux/usb.h>
>  #include <linux/usb/serial.h>
>  +#include "sierra.h"

Just put the .h stuff into the file, you don't need a separate file.

>  +int sierra_probe(struct usb_interface *iface, const struct usb_device_id 
>  *id);
>  +int sierra_set_power_state(struct usb_device *udev, unsigned long 
>  swiState);
>  +int sierra_set_ms_mode(struct usb_device *udev, SWIMS_SET_MODE_VALUE 
>  eSocMode);

All of these need to be static, and you can just reorganize where you
put them in the file to prevent the need for forward declarations.

>  static struct usb_driver sierra_driver = {
>  	.name       = "sierra",
>  -	.probe      = usb_serial_probe,
>  +	.probe      = sierra_probe,

This is scary, more below about this...

>  	.disconnect = usb_serial_disconnect,
>  	.id_table   = id_table,
>  	.no_dynamic_id = 	1,
>  };
>  +	/* Check if in installer mode */
>  +	if (id->driver_info == DEVICE_INSTALLER)
>  +	{

Wrong codeing style for this whole if/else chain.

>  +		dbg("SWIMS: FOUND DEVICE(SW)\n");
>  +		result = sierra_set_ms_mode(udev, SWIMS_SET_MODE_Modem);
>  +		dbg("SWIMS: swich result: %d\n",result);
>  +		return result;
>  +	}
>  +	/* Check if composite deviec */
>  +	else if (id->driver_info == DEVICE_1_PORT)
>  +	{
>  +		dbg("SWI: MODEM (Comp) FOUND");
>  +		sierra_device.num_ports = 1;
>  +		sierra_device.num_bulk_in = 1;
>  +		sierra_device.num_bulk_out = 1;

this is the big problem.  You are modifying a structure that is static
and should be read-only.  What happens if you have a system with more
than one type of these devices in it?  What happens then?

The proper way to do this is just use the calc_num_ports() callback
function in the usb_serial_driver structure.  That's where you can
calculate the proper number of ports for this device if you need to.  Or
you might need to do it in the probe() function of the usb_serial_driver
structure instead, depending on what you really need to do here.

So, can you fix this up and resend it?

>  +typedef __u16  SWIMS_SET_MODE_VALUE;

Heh, no typedefs please, just use __u16 here for where you used this
type (it's only 2 functions.)

>  +
>  +enum devicetype {
>  + DEVICE_3_PORT = 0,
>  + DEVICE_1_PORT = 1,
>  + DEVICE_INSTALLER = 2,
>  +};

tabs instead of leading spaces?

>  +
>  +/* per port private data */
>  +#define N_IN_URB	4
>  +#define N_OUT_URB	4
>  +#define IN_BUFLEN	4096
>  +#define OUT_BUFLEN	1024
>  +
>  +#define DEF_NUM_PORTS 3

Tab before the 3?

thanks,

greg k-h

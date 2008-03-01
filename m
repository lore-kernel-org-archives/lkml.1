Return-Path: <linux-kernel-owner+w=401wt.eu-S933989AbYCABT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbYCABT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 20:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759975AbYCABTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 20:19:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39728 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933494AbYCABTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 20:19:20 -0500
Date: Fri, 29 Feb 2008 16:33:42 -0800
From: Greg KH <greg@kroah.com>
To: Dirk Eibach <eibach@gdsys.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: add sysfs configuration interface for CP2101
Message-ID: <20080301003342.GB17761@kroah.com>
References: <20080229020245.61f1f8f4.akpm@linux-foundation.org> <47C7FB0F.1060902@gdsys.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C7FB0F.1060902@gdsys.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 01:31:11PM +0100, Dirk Eibach wrote:
> So here is a new try.

Please provide a full changelog entry, and signed-off-by: if you wish to
have it applied to the tree.

As you are adding new sysfs entries, I need some documentation to be
added in Documentation/ABI/ describing these new files and how they are
to be used.  See the instructions there for the format needed.


> 
> ---
> diff -purN linux-2.6.24/drivers/usb/serial/cp2101.c linux-2.6.24-diff/drivers/usb/serial/cp2101.c
> --- linux-2.6.24/drivers/usb/serial/cp2101.c	2008-01-24 23:58:37.000000000 +0100
> +++ linux-2.6.24-diff/drivers/usb/serial/cp2101.c	2008-02-29 13:15:58.168233146 +0100
> @@ -18,6 +18,8 @@
>   */
>  
>  #include <linux/kernel.h>
> +#include <linux/fs.h>
> +#include <linux/platform_device.h>
>  #include <linux/errno.h>
>  #include <linux/slab.h>
>  #include <linux/tty.h>
> @@ -52,6 +54,8 @@ static void cp2101_shutdown(struct usb_s
>  
>  static int debug;
>  
> +static int enable_config = false;
> +
>  static struct usb_device_id id_table [] = {
>  	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
>  	{ USB_DEVICE(0x0FCF, 0x1003) }, /* Dynastream ANT development board */
> @@ -125,6 +129,7 @@ static struct usb_serial_driver cp2101_d
>  #define CP2101_CONTROL		0x07	/* Flow control line states */
>  #define CP2101_MODEMCTL		0x13	/* Modem controls */
>  #define CP2101_CONFIG_6		0x19	/* 6 bytes of config data ??? */
> +#define CP2101_EEPROM		0xFF	/* write configuration eeprom */
>  
>  /* CP2101_UART */
>  #define UART_ENABLE		0x0001
> @@ -167,6 +172,20 @@ static struct usb_serial_driver cp2101_d
>  #define CONTROL_WRITE_DTR	0x0100
>  #define CONTROL_WRITE_RTS	0x0200
>  
> +/* CP2101 CONFIGURATION EEPROM */
> +#define EEPROM_RELOAD		0x0008
> +#define EEPROM_VENDOR_ID	0x3701
> +#define EEPROM_PRODUCT_ID	0x3702
> +#define EEPROM_PRODUCTSTRING	0x3703
> +#define EEPROM_SERIALNUMBER	0x3704
> +#define EEPROM_POWER_ATTRIB	0x3705
> +#define EEPROM_MAX_POWER	0x3706
> +#define EEPROM_RELEASE_VERSION	0x3707
> +#define EEPROM_LOCK		0x370a
> +
> +#define SERIALNUMBER_MAX_CHARS	63
> +#define PRODUCTSTRING_MAX_CHARS	126
> +
>  /*
>   * cp2101_get_config
>   * Reads from the CP2101 configuration registers
> @@ -704,11 +723,286 @@ static void cp2101_break_ctl (struct usb
>  	cp2101_set_config(port, CP2101_BREAK, &state, 2);
>  }
>  
> +/*
> + * When loaded with module parameter "enable_config=1" the driver offers the
> + * following sysfs attributes to customize USB configuration data:
> + * reload: write "1" to reboot CP210x and activate the new configuration
> + * vendor_id: write 16 bit value to set
> + * product_id: write 16 bit value to set


This seems odd, you know we already allow any usb vendor and product id
to be automatically added to a driver after it has been loaded through
sysfs, right?  Wouldn't that take care of the majority of the issues you
have here?

Oh, wait, this is setting the device itself, nevermind.

You should use configfs for this instead, that's what it is for moreso
than sysfs, right?

thanks,

greg k-h

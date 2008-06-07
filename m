Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbYFGGIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbYFGGIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 02:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYFGGIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 02:08:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524AbYFGGID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 02:08:03 -0400
Date: Fri, 6 Jun 2008 23:07:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, mzxreary@0pointer.de
Subject: Re: [PATCH] Add backlight driver for Nvidia-based Apple Macbook
 Pros
Message-Id: <20080606230745.304d116b.akpm@linux-foundation.org>
In-Reply-To: <20080607025436.GB24254@srcf.ucam.org>
References: <20080607025436.GB24254@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jun 2008 03:54:36 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Nvidia-based Apple Macbook Pros don't appear to handle backlight control 
> through the graphics card registers or ACPI, but instead trigger changes 
> via SMI calls. This driver registers a generic backlight device that 
> lets existing userspace deal with it. Code derived from Julien Blache's 
> Pommed application.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
>
> ...
>
> --- /dev/null
> +++ b/drivers/video/backlight/mbp_nvidia_bl.c
> @@ -0,0 +1,114 @@
> +/*
> + *  Backlight Driver for Nvidia 8600 in Macbook Pro
> + *
> + *  Copyright (c) Red Hat <mjg@redhat.com>
> + *  Based on code from Pommed:
> + *  Copyright (C) 2006 Nicolas Boichat <nicolas @boichat.ch>
> + *  Copyright (C) 2006 Felipe Alfaro Solana <felipe_alfaro @linuxmail.org>
> + *  Copyright (C) 2007 Julien BLACHE <jb@jblache.org>

Did this patch have appropriate attribution and signoffs?

> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + *  This driver triggers SMIs which cause the firmware to change the
> + *  backlight brightness. This is icky in many ways, but it's impractical to
> + *  get at the firmware code in order to figure out what it's actually doing.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/backlight.h>
> +#include <linux/err.h>
> +#include <linux/dmi.h>
> +#include <linux/io.h>
> +
> +struct backlight_device *mbp_backlight_device;
> +
> +static struct dmi_system_id __initdata mbp_device_table[] = {
> +	{
> +		.ident = "3,1",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3,1"),
> +		},
> +	},
> +	{
> +		.ident = "3,2",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3,2"),
> +		},
> +	},
> +	{
> +		.ident = "4,1",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4,1"),
> +		},
> +	},
> +	{ }
> +};
> +
> +static int mbp_send_intensity(struct backlight_device *bd)
> +{
> +	int intensity = bd->props.brightness;
> +
> +	outb(0x04 | (intensity << 4), 0xb3);
> +	outb(0xbf, 0xb2);
> +
> +	return 0;
> +}
> +
> +static int mbp_get_intensity(struct backlight_device *bd)
> +{
> +	outb(0x03, 0xb3);
> +	outb(0xbf, 0xb2);
> +	return inb(0xb3) >> 4;
> +}
> +
> +static struct backlight_ops mbp_ops = {
> +	.get_brightness = mbp_get_intensity,
> +	.update_status  = mbp_send_intensity,
> +};
> +
> +static int __init mbp_init(void)
> +{
> +	if (!dmi_check_system(mbp_device_table))
> +		return -ENODEV;
> +
> +	if (!request_region(0xb2, 2, "Macbook Pro backlight"))
> +		return -ENXIO;
> +
> +	mbp_backlight_device = backlight_device_register("mbp_backlight",
> +							 NULL, NULL,
> +							 &mbp_ops);
> +	if (IS_ERR(mbp_backlight_device))
> +		return PTR_ERR(mbp_backlight_device);

Missing release_region()?

> +	mbp_backlight_device->props.max_brightness = 15;
> +	mbp_backlight_device->props.brightness =
> +		mbp_get_intensity(mbp_backlight_device);
> +	backlight_update_status(mbp_backlight_device);
> +
> +	return 0;
> +}
> +
> +static void __exit mbp_exit(void)
> +{
> +	backlight_device_unregister(mbp_backlight_device);
> +
> +	release_region(0xb2, 2);
> +}
> +
> +module_init(mbp_init);
> +module_exit(mbp_exit);
> +
> +MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
> +MODULE_DESCRIPTION("Nvidia-based Macbook Pro Backlight Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("dmi:*:svnApple Inc.:pnMacBookPro3,1:*");
> +MODULE_ALIAS("dmi:*:svnApple Inc.:pnMacBookPro3,2:*");
> +MODULE_ALIAS("dmi:*:svnApple Inc.:pnMacBookPro4,1:*");


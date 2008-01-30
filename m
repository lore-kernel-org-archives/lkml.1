Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbYA3LAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbYA3LAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYA3LAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:00:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:56591 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYA3LAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:00:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=wgFG8b1Yyu4K4yxl83PtKkHWbjvkQd5J4yWPfMD05LG6r2Vk5ZLX9iYbGlOf6leY0o6K/IXPCiuanI47tbtIVW2jANSXhv4IyoRf/h8bNAPEl/ueuL7TFhm4BV+om0oHU4cHHaVMbPCbW+j0QrBfPTnFACEI9XafJXKwcBSLmdo=
Message-ID: <47A058B3.6000009@gmail.com>
Date: Wed, 30 Jan 2008 12:00:03 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@analog.com>
CC: linux-kernel@vger.kernel.org,
       Mike Frysinger <michael.frysinger@analog.com>
Subject: Re: [PATCH 1/1] [Blackfin] char driver for Blackfin on-chip OTP memory
References: <1201689401-2892-1-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1201689401-2892-1-git-send-email-bryan.wu@analog.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2008 11:36 AM, Bryan Wu wrote:
> From: Mike Frysinger <michael.frysinger@analog.com>
> 
> initial char driver for otp memory
> (only read supported atm ... needs real examples/docs for write support)
> 
> Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  drivers/char/Kconfig    |   28 +++++++
>  drivers/char/Makefile   |    1 +
>  drivers/char/bfin-otp.c |  203 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 232 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/char/bfin-otp.c
> 
[...]
> diff --git a/drivers/char/bfin-otp.c b/drivers/char/bfin-otp.c
> new file mode 100644
> index 0000000..896a987
> --- /dev/null
> +++ b/drivers/char/bfin-otp.c
> @@ -0,0 +1,203 @@
> +/*
> + * Blackfin On-Chip OTP Memory Interface
> + *  Supports BF52x/BF54x
> + *
> + * Copyright 2007-2008 Analog Devices Inc.
> + *
> + * Enter bugs at http://blackfin.uclinux.org/
> + *
> + * Licensed under the GPL-2 or later.
> + */
> +
> +#include <linux/cdev.h>
> +#include <linux/device.h>
> +#include <linux/errno.h>
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/types.h>
> +
> +#include <asm/blackfin.h>
> +#include <asm/uaccess.h>
> +
> +#define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
> +#define stampit() stamp("here i am")
> +
> +#define DRIVER_NAME "bfin-otp"
> +#define PFX DRIVER_NAME ": "
> +
> +DEFINE_MUTEX(bfin_otp_lock);

static?

> +
> +/* OTP Boot ROM functions */
> +#define _BOOTROM_OTP_COMMAND           0xEF000018
> +#define _BOOTROM_OTP_READ              0xEF00001A
> +#define _BOOTROM_OTP_WRITE             0xEF00001C
[...]
> +/**
> + *	bfin_otp_init - Initialize module
> + *
> + *	Registers the device and notifier handler. Actual device
> + *	initialization is handled by bfin_otp_open().
> + */
> +static int __init bfin_otp_init(void)
> +{
> +	int ret;
> +
> +	stampit();
> +
> +	ret = alloc_chrdev_region(&bfin_otp_dev_node, 0, 1, "otp");
> +	if (ret) {
> +		printk(KERN_ERR PFX "unable to get a char device\n");
> +		return ret;
> +	}
> +
> +	cdev_init(&bfin_otp_cdev, &bfin_otp_fops);
> +	bfin_otp_cdev.owner = THIS_MODULE;
> +	bfin_otp_cdev.ops = &bfin_otp_fops;

You don't need to set the fops again.

> +
> +	ret = cdev_add(&bfin_otp_cdev, bfin_otp_dev_node, 1);
> +	if (ret) {
> +		unregister_chrdev_region(bfin_otp_dev_node, 1);
> +		printk(KERN_ERR PFX "unable to register char device\n");
> +		return ret;
> +	}
> +
> +	bfin_otp_class = class_create(THIS_MODULE, "otp");
> +	device_create(bfin_otp_class, NULL, bfin_otp_dev_node, "otp");

Anyway, wouldn't be easier/better to use misc.c functionality here 
(misc_register() et al.)?

> +
> +	printk(KERN_INFO PFX "initialized\n");
> +
> +	return 0;
> +}

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761566AbXH0WlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761566AbXH0WlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbXH0Wkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:40:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39424 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600AbXH0Wkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:40:52 -0400
Date: Mon, 27 Aug 2007 15:40:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
Message-Id: <20070827154049.8c5e61fe.akpm@linux-foundation.org>
In-Reply-To: <300725321593711206@pripojeni.net>
References: <300725321593711206@pripojeni.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Aug 2007 07:09:02 -0700
Jiri Slaby <jirislaby@gmail.com> wrote:

> Hi,
> 
> is it possible to have this driver in the -mm tree for testing purposes until
> v4l library will be developped and image resize with bayer->rgb conversion
> will be moved there? (Then, I'll push it through v4l people.)
> 
> --
> stk11xx, add a new webcam driver
> 
> Adds support for stk1125, stk1135 and stkdcnew webcam built-in some
> notebooks.
> 
> ...
>
> --- /dev/null
> +++ b/drivers/media/video/stk1125.c
> @@ -0,0 +1,667 @@
> +/*
> + * STK-1125 part
> + *
> + * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
> + *
> + * Based on Nicolas VIVIEN's driver
> + *
> + * Licences
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#include <linux/usb.h>
> +#include <linux/types.h>
> +
> +#include "stk11xx.h"
> +
> +static int stk1125_load_microcode(struct stk11xx *dev)
> +{
> +	unsigned int i;
> +	const u8 *values_204, *values_205;
> +	int retok;
> +
> +	/* From 80x60 to 640x480 */
> +	const u8 values_1_204[] = {
> +		0x12, 0x11, 0x3b, 0x6a, 0x13, 0x10, 0x00, 0x01, 0x02, 0x13,
> +		0x39, 0x38, 0x37, 0x35, 0x0e, 0x12, 0x04, 0x0c, 0x0d, 0x17,
> +		0x18, 0x32, 0x19, 0x1a, 0x03, 0x1b, 0x16, 0x33, 0x34, 0x41,
> +		0x96, 0x3d, 0x69, 0x3a, 0x8e, 0x3c, 0x8f, 0x8b, 0x8c, 0x94,
> +		0x95, 0x40, 0x29, 0x0f, 0xa5, 0x1e, 0xa9, 0xaa, 0xab, 0x90,
> +		0x91, 0x9f, 0xa0, 0x24, 0x25, 0x26, 0x14, 0x2a, 0x2b
> +	};
> +	const u8 values_1_205[] = {
> +		0x45, 0x80, 0x01, 0x7d, 0x80, 0x00, 0x00, 0x80, 0x80, 0x80,
> +		0x50, 0x93, 0x00, 0x81, 0x20, 0x45, 0x00, 0x00, 0x00, 0x24,
> +		0xc4, 0xb6, 0x00, 0x3c, 0x36, 0x00, 0x07, 0xe2, 0xbf, 0x00,
> +		0x04, 0x19, 0x40, 0x0d, 0x00, 0x73, 0xdf, 0x06, 0x20, 0x88,
> +		0x88, 0xc1, 0x3f, 0x42, 0x80, 0x04, 0xb8, 0x92, 0x0a, 0x00,
> +		0x00, 0x00, 0x00, 0x68, 0x5c, 0xc3, 0x2e, 0x00, 0x00
> +	};
> +
> +	/* From 800x600 to 1280x1024 */
> +	const u8 values_2_204[] = {
> +		0x12, 0x11, 0x3b, 0x6a, 0x13, 0x10, 0x00, 0x01, 0x02, 0x13,
> +		0x39, 0x38, 0x37, 0x35, 0x0e, 0x12, 0x04, 0x0c, 0x0d, 0x17,
> +		0x18, 0x32, 0x19, 0x1a, 0x03, 0x1b, 0x16, 0x33, 0x34, 0x41,
> +		0x96, 0x3d, 0x69, 0x3a, 0x8e, 0x3c, 0x8f, 0x8b, 0x8c, 0x94,
> +		0x95, 0x40, 0x29, 0x0f, 0xa5, 0x1e, 0xa9, 0xaa, 0xab, 0x90,
> +		0x91, 0x9f, 0xa0, 0x24, 0x25, 0x26, 0x14, 0x2a, 0x2b
> +	};
> +	const u8 values_2_205[] = {
> +		0x05, 0x80, 0x01, 0x7d, 0x80, 0x00, 0x00, 0x80, 0x80, 0x80,
> +		0x50, 0x93, 0x00, 0x81, 0x20, 0x05, 0x00, 0x00, 0x00, 0x1b,
> +		0xbb, 0xa4, 0x01, 0x81, 0x12, 0x00, 0x07, 0xe2, 0xbf, 0x00,
> +		0x04, 0x19, 0x40, 0x0d, 0x00, 0x73, 0xdf, 0x06, 0x20, 0x88,
> +		0x88, 0xc1, 0x3f, 0x42, 0x80, 0x04, 0xb8, 0x92, 0x0a, 0x00,
> +		0x00, 0x00, 0x00, 0x68, 0x5c, 0xc3, 0x2e, 0x00, 0x00
> +	};

hm, OK, it seems that even though we've asked the compiler to build these
arrays on the stack at runtime it will, as an optimisation, create static
storage for them due to the `const'.  I don't know that the compielr _has_
to do that, nor do I know if all versions of gcc and other compilers will
also do this.

Perhaps it would be safer to put the `static' in there?  There are many
such sites.


> +	/* From the resolution */
> +	switch (dev->resolution) {
> +	case STK11XX_1280x1024:
> +	case STK11XX_1024x768:
> +	case STK11XX_800x600:
> +		values_204 = values_2_204;
> +		values_205 = values_2_205;
> +		break;
> +
> +	case STK11XX_640x480:
> +	case STK11XX_320x240:
> +	case STK11XX_160x120:
> +	case STK11XX_80x60:
> +	default:
> +		values_204 = values_1_204;
> +		values_205 = values_1_205;
> +		break;
> +	}
> +
> +	for (i = 0; i < 59; i++) {

ARRAY_SIZE would be nice, if only for clarity..

+		retok = stk11xx_check_device(dev, 500);
+		if (retok != 1) {
+			dev_err(&dev->udev->dev, "load microcode fail\n");
+			return -EIO;
+		}

Normally we'd use a return value of zero to indicate success.  So that the
negative return value can tell people _why_ it failed.

> +
> +	for (i = 0; i < 16; i++) {
> +		stk11xx_write_reg(dev, 0x0000, 0x25);
> +		stk11xx_write_reg(dev, 0x0000, 0x24);
> +		stk11xx_read_reg(dev, 0x0000, &value);
> +
> +		dev_dbg(&dev->udev->dev, "Loop 1: Read 0x0000 = %02x\n", value);
> +	}
> +
> +	ret = stk11xx_process_table(dev, table_2);
> +	if (ret)
> +		goto end;
> +
> +	for (i = 0; i < 16; i++) {
> +		stk11xx_write_reg(dev, 0x0000, 0x25);
> +		stk11xx_write_reg(dev, 0x0000, 0x24);
> +		stk11xx_read_reg(dev, 0x0000, &value);
> +
> +		dev_dbg(&dev->udev->dev, "Loop 2: Read 0x0000 = %02x\n", value);
> +	}
> +
> +	ret = stk11xx_process_table(dev, table_3);
> +	if (ret)
> +		goto end;
> +
> +	for (i = 0; i < 16; i++) {
> +		stk11xx_write_reg(dev, 0x0000, 0x25);
> +		stk11xx_write_reg(dev, 0x0000, 0x24);
> +		stk11xx_read_reg(dev, 0x0000, &value);
> +
> +		dev_dbg(&dev->udev->dev, "Loop 3: Read 0x0000 = %02x\n", value);
> +	}

Again, ARRAY_SIZE() would be clearer here.

> +	ret = stk11xx_process_table(dev, table_4);
> +	if (ret)
> +		goto end;
> +
> +	stk1125_cam_asleep(dev);
> +
> +	stk11xx_set_feature(dev, 0);
> +
> +end:
> +	return ret;
> +}
> +
>
> ...
>
> +	};
> +
> +	for (i = 0; i < 117; i++) {

lots of places..



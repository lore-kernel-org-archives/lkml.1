Return-Path: <linux-kernel-owner+w=401wt.eu-S1761707AbYBRNFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761707AbYBRNFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760543AbYBRNDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:03:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60341 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761214AbYBRNDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:03:15 -0500
Date: Mon, 18 Feb 2008 05:02:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] maple: add driver for Sega Dreamcast controller
Message-Id: <20080218050204.61261d93.akpm@linux-foundation.org>
In-Reply-To: <1203205815.6737.31.camel@localhost.localdomain>
References: <1203205815.6737.31.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 23:50:15 +0000 Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:

> Add support for the SEGA Dreamcast controller as a joystick device. Based on Yaegashi Takeshi's old 2.4 driver (never in mainline) with the addition of functioning removal (and reinsertion) code.
> 
> ...
>
> +static void dc_pad_callback(struct mapleq *mq)
> +{
> +	unsigned short buttons;
> +	struct maple_device *mapledev = mq->dev;
> +	struct dc_pad *pad = mapledev->private_data;
> +	struct input_dev *dev = pad->dev;
> +	unsigned char *res = mq->recvbuf;
> +
> +	buttons = ~*(unsigned short *)(res+8);

This is endianness-dependent.  Presumably it "works", but it's pretty poor
practice.

> ...
>
>> +static int dc_pad_connect(struct maple_device *mdev)
> +{
> +	int i, error;
> +	unsigned long data = be32_to_cpu(mdev->devinfo.function_data[0]);
> +	struct dc_pad *pad;
> +	struct input_dev *dev;
> +
> +	const short btn_bit[32] = {
> +		BTN_C, BTN_B, BTN_A, BTN_START, -1, -1, -1, -1,
> +		BTN_Z, BTN_Y, BTN_X, BTN_SELECT, -1, -1, -1, -1,
> +		-1, -1, -1, -1, -1, -1, -1, -1,
> +		-1, -1, -1, -1, -1, -1, -1, -1,
> +	};
> +
> +	const short abs_bit[32] = {
> +		-1, -1, -1, -1, ABS_HAT0Y, ABS_HAT0Y, ABS_HAT0X, ABS_HAT0X,
> +		-1, -1, -1, -1, ABS_HAT1Y, ABS_HAT1Y, ABS_HAT1X, ABS_HAT1X,
> +		ABS_GAS, ABS_BRAKE, ABS_X, ABS_Y, ABS_RX, ABS_RY, -1, -1,
> +		-1, -1, -1, -1, -1, -1, -1, -1,
> +	};
> +
> +	pad = kzalloc(sizeof(struct dc_pad), GFP_KERNEL);
> +	if (!pad)
> +		return -ENOMEM;
> +
> +	dev = input_allocate_device();
> +	if (!dev) {
> +		kfree(pad);
> +		return -ENOMEM;
> +	}
> +
> +	pad->dev = dev;
> +	pad->mdev = mdev;
> +	mdev->private_data = pad;
> +
> +	for (i = 0; i < 32; i++)
> +		if (data & (1<<i) && btn_bit[i] >= 0)
> +			pad->dev->keybit[BTN_JOYSTICK/32] |= BIT(btn_bit[i]);
> +
> +	if (pad->dev->keybit[BTN_JOYSTICK/32])
> +		pad->dev->evbit[0] |= BIT(EV_KEY);
> +
> +	for (i = 0; i < 32; i++)
> +		if (data & (1<<i) && abs_bit[i] >= 0)
> +			pad->dev->absbit[0] |= BIT(abs_bit[i]);
> +
> +	if (pad->dev->absbit[0])
> +		pad->dev->evbit[0] |= BIT(EV_ABS);
> +
> +	for (i = ABS_X; i <= ABS_BRAKE; i++) {
> +		pad->dev->absmax[i] = 255;
> +		pad->dev->absmin[i] = 0;
> +		pad->dev->absfuzz[i] = 0;
> +		pad->dev->absflat[i] = 0;
> +	}
> +
> +	for (i = ABS_HAT0X; i <= ABS_HAT3Y; i++) {
> +		pad->dev->absmax[i] = 1;
> +		pad->dev->absmin[i] = -1;
> +		pad->dev->absfuzz[i] = 0;
> +		pad->dev->absflat[i] = 0;
> +	}
> +
> +	pad->dev->open = dc_pad_open;
> +	pad->dev->close = dc_pad_close;
> +	pad->dev->private = pad;
> +	pad->dev->event = NULL;
> +	pad->dev->dev.parent = &mdev->dev;
> +	pad->dev->name = mdev->product_name;
> +	pad->dev->id.bustype = BUS_HOST;
> +	input_set_drvdata(dev, pad);
> +
> +	error = input_register_device(pad->dev);
> +	if (error) {
> +		input_free_device(pad->dev);
> +		kfree(pad);
> +		return -error;
> +	}
> +
> +	maple_getcond_callback(mdev, dc_pad_callback_idle, 0xFFFFFFFF,
> +		MAPLE_FUNC_CONTROLLER);
> +
> +	return 0;
> +}

The error handling in here would be more maintainable if it were to use the
usual `goto err_foo' approach - aim for only a single return statement per
function.


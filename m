Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYLVXHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYLVXHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:07:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbYLVXGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:06:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103AbYLVXGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:06:52 -0500
Date: Mon, 22 Dec 2008 15:06:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-sh@vger.kernel.org, lethal@linux-sh.org
Subject: Re: [PATCH] sh: maple: add support for Maple controller as a
 joystick
Message-Id: <20081222150636.8dc20d61.akpm@linux-foundation.org>
In-Reply-To: <1229728542.1441.6.camel@localhost.localdomain>
References: <1229728542.1441.6.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 23:15:42 +0000
Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:

> Not sure what happened with earlier submissions, so here is an up-to-date
> patch for the Dreamcast Maple controlled.
> 
> 
> Add support for the SEGA Dreamcast Maple controller as a joystick
> 
> ...
>
> +static void dc_pad_callback(struct mapleq *mq)
> +{
> +	unsigned short buttons;
> +	struct maple_device *mapledev = mq->dev;
> +	struct dc_pad *pad = maple_get_drvdata(mapledev);
> +	struct input_dev *dev = pad->dev;
> +	unsigned char *res = mq->recvbuf;
> +
> +	buttons = ~cpu_to_le16(*(unsigned short *)(res + 8));

hm, could that be simplified?

> +	input_report_abs(dev, ABS_HAT0Y,
> +			 (buttons & 0x0010 ? -1:0) + (buttons & 0x0020 ? 1:0));
> +	input_report_abs(dev, ABS_HAT0X,
> +			 (buttons & 0x0040 ? -1:0) + (buttons & 0x0080 ? 1:0));
> +	input_report_abs(dev, ABS_HAT1Y,
> +			 (buttons & 0x1000 ? -1:0) + (buttons & 0x2000 ? 1:0));
> +	input_report_abs(dev, ABS_HAT1X,
> +			 (buttons & 0x4000 ? -1:0) + (buttons & 0x8000 ? 1:0));
> +
> +	input_report_key(dev, BTN_C,      buttons & 0x0001);
> +	input_report_key(dev, BTN_B,      buttons & 0x0002);
> +	input_report_key(dev, BTN_A,      buttons & 0x0004);
> +	input_report_key(dev, BTN_START,  buttons & 0x0008);
> +	input_report_key(dev, BTN_Z,      buttons & 0x0100);
> +	input_report_key(dev, BTN_Y,      buttons & 0x0200);
> +	input_report_key(dev, BTN_X,      buttons & 0x0400);
> +	input_report_key(dev, BTN_SELECT, buttons & 0x0800);
> +
> +	input_report_abs(dev, ABS_GAS,   res[10]);
> +	input_report_abs(dev, ABS_BRAKE, res[11]);
> +	input_report_abs(dev, ABS_X,     res[12]);
> +	input_report_abs(dev, ABS_Y,     res[13]);
> +	input_report_abs(dev, ABS_RX,    res[14]);
> +	input_report_abs(dev, ABS_RY,    res[15]);
> +}
> +
> +static int dc_pad_open(struct input_dev *dev)
> +{
> +	struct dc_pad *pad;
> +
> +	pad = dev->dev.platform_data;
> +	maple_getcond_callback(pad->mdev, dc_pad_callback, HZ/20,
> +		MAPLE_FUNC_CONTROLLER);
> +	return 0;
> +}
> +
> +static void dc_pad_close(struct input_dev *dev)
> +{
> +	struct dc_pad *pad;
> +	
> +	pad = dev->dev.platform_data;
> +	maple_getcond_callback(pad->mdev, dc_pad_callback, 0,
> +		MAPLE_FUNC_CONTROLLER);
> +}
> +
> +/* allow the controller to be used */
> +static int probe_maple_controller(struct device *dev)
> +{
> +	struct maple_device *mdev = to_maple_dev(dev);
> +	struct maple_driver *mdrv = to_maple_driver(dev->driver);
> +	int i, error;
> +	struct dc_pad *pad;
> +	struct input_dev *idev;
> +	unsigned long data = be32_to_cpu(mdev->devinfo.function_data[0]);
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

These could be made static.

There's a risk that the compiler will go and assemble these arrays on
the stack each time this function is called.  gcc (some versions, at
least) will actually internally turn these into static arrays
(assembled at compile time) but it's best to do this explicitly.


> +	pad = kzalloc(sizeof(struct dc_pad), GFP_KERNEL);
> +	idev = input_allocate_device();
> +	if (!pad || !idev){
> +		error = ENOMEM;
>
> ...
>
> +	return -error;

Please don't do this.  People occasionally grep the tree for instances
of 'EFOO' which are missing the "-" sign, which is a useful service. 
The above trick just makes things harder for them.

>
> ...
>

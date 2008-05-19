Return-Path: <linux-kernel-owner+w=401wt.eu-S1760278AbYESPfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbYESPfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYESPfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:35:44 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:25620 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYESPfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:35:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GC1EXAWC2mjvYkCCs5fhBujTq9YdAHSvUmesfjPnmzDt0iZd7xXedUG7SrF6AyFb87zdfnvnbRf1pRCJfNJITgzmFtdRJjZrHYU8BuRH98smIdVBmJVW0msUdgOyCMykReGi5p7/SkIJBuchm676XfVmGlTxC891U+1wWSF2C/4=
Date: Mon, 19 May 2008 11:35:37 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pau Oliva Fora <pau@eslack.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, penberg@cs.helsinki.fi
Subject: Re: [PATCH] Add support for HTC Shift Touchscreen
Message-ID: <20080519112104.ZZRA012@mailhub.coreip.homeip.net>
References: <482ED31E.2000009@eslack.org> <483198F8.3000201@eslack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483198F8.3000201@eslack.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pau,

On Mon, May 19, 2008 at 05:12:56PM +0200, Pau Oliva Fora wrote:
> From: Pau Oliva Fora <pau@eslack.org>
>
> The patch below adds support for HTC Shift UMPC touchscreen.
>
> Signed-off-by: Pau Oliva Fora <pau@eslack.org>
>

Thank you for the patch, overall looks very good, some comments below:

> +
> +#define DRIVER_VERSION	"0.8"
> +#define DRIVER_DESC	"HTC Shift touchscreen driver v" DRIVER_VERSION
> +

I'd lose the driver version, kernel version should be enough for
tracking.

> +MODULE_AUTHOR("Pau Oliva Fora <pau@eslack.org>");
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL");
> +
> +#define HTCPEN_PORT_IRQ_CLEAR 0x068
> +#define HTCPEN_PORT_INIT 0x06c
> +#define HTCPEN_PORT_INDEX 0x0250
> +#define HTCPEN_PORT_DATA 0x0251
> +#define HTCPEN_IRQ 3
> +
> +#define X_INDEX 3
> +#define Y_INDEX 5
> +#define LSB_XY_INDEX 0xc
> +#define X_AXIS_MAX 2040
> +#define Y_AXIS_MAX 2040
> +#define DEVICE_ENABLE 0xa2
> +
> +static int inverse_x;
> +module_param(inverse_x, bool, 0644);
> +MODULE_PARM_DESC(inverse_x, "If set X axis is inversed");
> +static int inverse_y;
> +module_param(inverse_y, bool, 0644);
> +MODULE_PARM_DESC(inverse_y, "If set Y axis is inversed");

For some reason 'inverted' sounds better to my ear. Anyone with
native English has any opinion here?

> +
> +static void poll_htcpen(struct input_dev *htcpen_dev)
> +{
> +	unsigned short x, y, xy;
> +	unsigned short touch;
> +
> +	/* 0=press ; 1=release */
> +	outb_p(0xb, HTCPEN_PORT_INDEX);
> +	touch = inb_p(HTCPEN_PORT_DATA);
> +	if (touch)
> +		touch = 0;
> +	else
> +		touch = 1;
> +
> +	input_report_key(htcpen_dev, BTN_TOUCH, touch);
> +
> +	/* only update X/Y when screen is being touched */
> +	if (touch) {
> +		outb_p(X_INDEX, HTCPEN_PORT_INDEX);
> +		x = inb_p(HTCPEN_PORT_DATA);
> +
> +		outb_p(Y_INDEX, HTCPEN_PORT_INDEX);
> +		y = inb_p(HTCPEN_PORT_DATA);
> +
> +		outb_p(LSB_XY_INDEX, HTCPEN_PORT_INDEX);
> +		xy = inb_p(HTCPEN_PORT_DATA);
> +
> +		/* get high resolution value of X and Y using LSB */
> +		x = X_AXIS_MAX - ((x * 8) + ((xy >> 4) & 0xf));
> +		y = (y * 8) + (xy & 0xf);
> +		if (inverse_x)
> +			x = X_AXIS_MAX - x;
> +		if (inverse_y)
> +			y = Y_AXIS_MAX - y;
> +
> +		input_report_abs(htcpen_dev, ABS_X, x);
> +		input_report_abs(htcpen_dev, ABS_Y, y);
> +	}
> +

Maybe do:
	if (inb_p(HTCPEN_PORT_DATA)) {
		input_report_key(htcpen_dev, BTN_TOUCH, 0);
	} else {
		...

		input_report_key(htcpen_dev, BTN_TOUCH, 1);
		input_report_abs(htcpen_dev, ABS_X, x);
		input_report_abs(htcpen_dev, ABS_Y, y);
	}

> +	input_sync(htcpen_dev);
> +
> +	inb_p(HTCPEN_PORT_IRQ_CLEAR);
> +}
> +
> +static irqreturn_t htcpen_interrupt(int irq, void *handle)
> +{
> +	struct input_dev *htcpen_dev = handle;
> +
> +	poll_htcpen(htcpen_dev);
> +	return IRQ_HANDLED;
> +}

Why don't you put the poll straight into IRQ handler body?

> +
> +static int __devinit htcpen_isa_probe(struct device *dev, unsigned int id)
> +{
> +	int err;
> +	struct input_dev *htcpen_dev;
> +
> +	printk(KERN_INFO "htcpen: %s\n", DRIVER_DESC);

If you want the driver to print identification string it should go
into the module init function, but I'd rather just keep it silent. If
it finds the device input core will print nice message about the
device.

> +
> +	inb_p(HTCPEN_PORT_IRQ_CLEAR);
> +
> +	htcpen_dev = input_allocate_device();
> +	if (!htcpen_dev) {
> +		printk(KERN_ERR "htcpen: can't allocate device\n");
> +		err = -ENOMEM;
> +		goto input_alloc_failed;
> +	}
> +
> +	htcpen_dev->name = "HTC Pen TouchScreen";
> +	htcpen_dev->id.bustype = BUS_ISA;
> +	htcpen_dev->id.vendor = 0;
> +	htcpen_dev->id.product = 0;
> +	htcpen_dev->id.version = 0;

input_allocate_device() zeroes the memory so initialize just what is
needed.

> +
> +	input_set_abs_params(htcpen_dev, ABS_X, 0, X_AXIS_MAX, 0, 0);
> +	input_set_abs_params(htcpen_dev, ABS_Y, 0, Y_AXIS_MAX, 0, 0);
> +
> +	htcpen_dev->evbit[0] = BIT_MASK(EV_ABS) | BIT_MASK(EV_KEY);

> +	htcpen_dev->absbit[0] = BIT_MASK(ABS_X) | BIT_MASK(ABS_Y);
Not needed, input_set_abs_params does this for you.

> +	htcpen_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
> +
> +	err = request_irq(HTCPEN_IRQ, htcpen_interrupt, 0, "htcpen",
> +		htcpen_dev);
> +	if (err) {
> +		printk(KERN_ERR "htcpen: irq busy\n");
> +		err = -EBUSY;

Just report the error returned by request_irq, no need to override it.

> +		goto request_irq_failed;
> +	}
> +
> +	err = input_register_device(htcpen_dev);
> +	if (err)
> +		goto input_register_failed;
> +
> +	outb_p(DEVICE_ENABLE, HTCPEN_PORT_INIT);
> +
> +	dev_set_drvdata(dev, htcpen_dev);
> +	return 0;
> +
> + input_register_failed:
> +	free_irq(HTCPEN_IRQ, htcpen_dev);
> + request_irq_failed:
> +	input_free_device(htcpen_dev);
> + input_alloc_failed:
> +	return err;
> +}
> +
> +static int __devinit htcpen_isa_match(struct device *dev, unsigned int id)
> +{
> +	unsigned short val1, val2;
> +
> +	/* device detection */
> +	outb_p(0x8, HTCPEN_PORT_INIT);
> +	val1 = inb_p(HTCPEN_PORT_INIT);
> +	val2 = inb_p(HTCPEN_PORT_IRQ_CLEAR);
> +	if ((val1 > 0xa) || (val2 != 0x55)) {
> +		printk(KERN_ERR "htcpen: no such device (%x|%x)\n", val1, val2);

KERN_DEBUG at most, I'd simply remove. Not having a device is not an
error.

> +		return 0;
> +	}
> +	return 1;
> +}
> +
> +static int __devexit htcpen_isa_remove(struct device *dev, unsigned int id)
> +{
> +	input_unregister_device(dev_get_drvdata(dev));

At this point the structure may be freed, but interrupts are still
running and you haven't stopped the device. I would recommend
implementing ->open() and ->close methonds for the input_dev and start
and stop the device from there (I thought one of your patches did just
that).

> +	free_irq(HTCPEN_IRQ, dev_get_drvdata(dev));
> +	input_free_device(dev_get_drvdata(dev));

Never call input_free_device after input_unregister_device. The
input_dev structure is refcounted and will free itself one last user
drops its reference. input_free_device may cause attempt to free
already freed memory.

> +	dev_set_drvdata(dev, NULL);
> +	printk(KERN_INFO "htcpen: module removed\n");

Kill this too.

> +	return 0;
> +}
> +
> +static struct isa_driver htcpen_isa_driver = {
> +	.match		= htcpen_isa_match,
> +	.probe		= htcpen_isa_probe,
> +	.remove		= __devexit_p(htcpen_isa_remove),
> +	.driver = {
> +		.owner	= THIS_MODULE,
> +		.name	= "htcpen",
> +	}
> +};
> +
> +static int __init htcpen_isa_init(void)
> +{
> +	return isa_register_driver(&htcpen_isa_driver, 1);
> +}
> +
> +static void __exit htcpen_isa_exit(void)
> +{
> +	isa_unregister_driver(&htcpen_isa_driver);
> +}
> +
-- 
Dmitry

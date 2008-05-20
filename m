Return-Path: <linux-kernel-owner+w=401wt.eu-S1764933AbYETMnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764933AbYETMnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYETMnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:43:01 -0400
Received: from aksay.ru ([80.254.111.40]:34002 "EHLO aksay.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbYETMm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:42:59 -0400
Date: Tue, 20 May 2008 16:37:50 +0400
From: Andrey Panin <pazke@pazke.donpac.ru>
To: Pau Oliva Fora <pau@eslack.org>
Cc: dmitry.torokhov@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Add support for HTC Shift Touchscreen
Message-ID: <20080520123750.GD17237@pazke.donpac.ru>
Mail-Followup-To: Pau Oliva Fora <pau@eslack.org>,
	dmitry.torokhov@gmail.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <482ED31E.2000009@eslack.org> <483198F8.3000201@eslack.org> <20080519112104.ZZRA012@mailhub.coreip.homeip.net> <4832087C.6060009@eslack.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7DO5AaGCk89r4vaK"
Content-Disposition: inline
In-Reply-To: <4832087C.6060009@eslack.org>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 141, 05 20, 2008 at 01:08:44AM +0200, Pau Oliva Fora wrote:
> From: Pau Oliva Fora <pau@eslack.org>
>
> The patch below adds support for HTC Shift UMPC touchscreen.
>
> Signed-off-by: Pau Oliva Fora <pau@eslack.org>
>
> ---
>
> Patch against linux-2.6.25.4, should apply clean on other versions too.
> Includes all the suggestions from Sam Ravnborg, Pekka Enberg,
> Marcin Slusarz and Dmitry Torokhov. Thank you all for your help.
>
> diff -uprN linux-2.6.25.4/drivers/input/touchscreen/htcpen.c linux/driver=
s/input/touchscreen/htcpen.c
> --- linux-2.6.25.4/drivers/input/touchscreen/htcpen.c	1970-01-01 01:00:00=
=2E000000000 +0100
> +++ linux/drivers/input/touchscreen/htcpen.c	2008-05-20 00:55:42.00000000=
0 +0200
> @@ -0,0 +1,196 @@
> +/*
> + * HTC Shift touchscreen driver
> + *
> + * Copyright (C) 2008 Pau Oliva Fora <pof@eslack.org>
> + *
> + * Thanks to:
> + * 	Heikki Linnakangas - Penmount LPC touchscreen driver
> + * 	Wacom / Ping Cheng - Help on linuxwacom-devel
> + * 	Esteve Espuna      - Ideas, tips, moral support :)
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms of the GNU General Public License version 2 as publis=
hed
> + * by the Free Software Foundation.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/init.h>
> +#include <linux/irq.h>
> +#include <linux/isa.h>
> +
> +MODULE_AUTHOR("Pau Oliva Fora <pau@eslack.org>");
> +MODULE_DESCRIPTION("HTC Shift touchscreen driver");
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
> +#define TOUCH_INDEX 0xb
> +#define LSB_XY_INDEX 0xc
> +#define X_AXIS_MAX 2040
> +#define Y_AXIS_MAX 2040
> +#define DEVICE_ENABLE 0xa2
> +
> +static int invert_x;
> +module_param(invert_x, bool, 0644);
> +MODULE_PARM_DESC(invert_x, "If set, X axis is inverted");
> +static int invert_y;
> +module_param(invert_y, bool, 0644);
> +MODULE_PARM_DESC(invert_y, "If set, Y axis is inverted");
> +
> +static irqreturn_t htcpen_interrupt(int irq, void *handle)
> +{
> +	struct input_dev *htcpen_dev =3D handle;
> +	unsigned short x, y, xy;
> +
> +	/* 0=3Dpress ; 1=3Drelease */
> +	outb_p(TOUCH_INDEX, HTCPEN_PORT_INDEX);
> +
> +	/* only update X/Y when screen is being touched */
> +	if (inb_p(HTCPEN_PORT_DATA)) {
> +		input_report_key(htcpen_dev, BTN_TOUCH, 0);
> +	} else {
> +		outb_p(X_INDEX, HTCPEN_PORT_INDEX);
> +		x =3D inb_p(HTCPEN_PORT_DATA);
> +
> +		outb_p(Y_INDEX, HTCPEN_PORT_INDEX);
> +		y =3D inb_p(HTCPEN_PORT_DATA);
> +
> +		outb_p(LSB_XY_INDEX, HTCPEN_PORT_INDEX);
> +		xy =3D inb_p(HTCPEN_PORT_DATA);
> +
> +		/* get high resolution value of X and Y using LSB */
> +		x =3D X_AXIS_MAX - ((x * 8) + ((xy >> 4) & 0xf));
> +		y =3D (y * 8) + (xy & 0xf);
> +		if (invert_x)
> +			x =3D X_AXIS_MAX - x;
> +		if (invert_y)
> +			y =3D Y_AXIS_MAX - y;
> +
> +		input_report_key(htcpen_dev, BTN_TOUCH, 1);
> +		input_report_abs(htcpen_dev, ABS_X, x);
> +		input_report_abs(htcpen_dev, ABS_Y, y);
> +	}
> +
> +	input_sync(htcpen_dev);
> +
> +	inb_p(HTCPEN_PORT_IRQ_CLEAR);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int htcpen_open(struct input_dev *dev)
> +{
> +	outb_p(DEVICE_ENABLE, HTCPEN_PORT_INIT);
> +	return 0;
> +}
> +
> +static void htcpen_close(struct input_dev *dev)
> +{
> +	free_irq(HTCPEN_IRQ, dev);
> +}
> +
> +static int __devinit htcpen_isa_probe(struct device *dev, unsigned int i=
d)
> +{
> +	int err;
> +	struct input_dev *htcpen_dev;
> +
> +	printk(KERN_ERR "principi del prove\n");
> +
> +	inb_p(HTCPEN_PORT_IRQ_CLEAR);
> +
> +	htcpen_dev =3D input_allocate_device();
> +	if (!htcpen_dev) {
> +		printk(KERN_ERR "htcpen: can't allocate device\n");
> +		err =3D -ENOMEM;
> +		goto input_alloc_failed;
> +	}
> +
> +	htcpen_dev->name =3D "HTC Pen TouchScreen";
> +	htcpen_dev->id.bustype =3D BUS_ISA;
> +
> +	input_set_abs_params(htcpen_dev, ABS_X, 0, X_AXIS_MAX, 0, 0);
> +	input_set_abs_params(htcpen_dev, ABS_Y, 0, Y_AXIS_MAX, 0, 0);
> +
> +	htcpen_dev->evbit[0] =3D BIT_MASK(EV_ABS) | BIT_MASK(EV_KEY);
> +	htcpen_dev->keybit[BIT_WORD(BTN_TOUCH)] =3D BIT_MASK(BTN_TOUCH);
> +	htcpen_dev->open =3D htcpen_open;
> +	htcpen_dev->close =3D htcpen_close;
> +
> +	err =3D request_irq(HTCPEN_IRQ, htcpen_interrupt, 0, "htcpen",
> +		htcpen_dev);
> +	if (err) {
> +		printk(KERN_ERR "htcpen: irq busy\n");
> +		goto request_irq_failed;
> +	}

You must call request_region() to reserve ioport range here.

> +
> +	err =3D input_register_device(htcpen_dev);
> +	if (err)
> +		goto input_register_failed;
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
> +static int __devinit htcpen_isa_match(struct device *dev, unsigned int i=
d)
> +{
> +	unsigned short val1, val2;
> +	/* device detection */
> +	outb_p(0x8, HTCPEN_PORT_INIT);
> +	val1 =3D inb_p(HTCPEN_PORT_INIT);
> +	val2 =3D inb_p(HTCPEN_PORT_IRQ_CLEAR);
> +	if ((val1 > 0xc) || (val2 !=3D 0x55)) {
> +		printk(KERN_DEBUG "htcpen: no such device (%x|%x)\n",
> +			val1, val2);
> +		return 0;
> +	}

Poking on random ioports isn't very nice detection method.=20
Has this machine useful DMI table ?

> +	return 1;
> +}
> +
> +static int __devexit htcpen_isa_remove(struct device *dev, unsigned int =
id)
> +{
> +	input_unregister_device(dev_get_drvdata(dev));
> +	dev_set_drvdata(dev, NULL);
> +	return 0;
> +}
> +
> +static struct isa_driver htcpen_isa_driver =3D {
> +	.match		=3D htcpen_isa_match,
> +	.probe		=3D htcpen_isa_probe,
> +	.remove		=3D __devexit_p(htcpen_isa_remove),
> +	.driver =3D {
> +		.owner	=3D THIS_MODULE,
> +		.name	=3D "htcpen",
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
> +module_init(htcpen_isa_init);
> +module_exit(htcpen_isa_exit);
> diff -uprN linux-2.6.25.4/drivers/input/touchscreen/Kconfig linux/drivers=
/input/touchscreen/Kconfig
> --- linux-2.6.25.4/drivers/input/touchscreen/Kconfig	2008-05-15 17:00:12.=
000000000 +0200
> +++ linux/drivers/input/touchscreen/Kconfig	2008-05-19 15:48:52.000000000=
 +0200
> @@ -134,6 +134,18 @@ config TOUCHSCREEN_HP7XX
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called jornada720_ts.
>
> +config TOUCHSCREEN_HTCPEN
> +	tristate "HTC Shift X9500 touchscreen"
> +	depends on ISA
> +	help
> +	  Say Y here if you have an HTC Shift UMPC also known as HTC X9500
> +	  Clio / Shangrila and want to support the built-in touchscreen.
> +
> +	  If unsure, say N.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called htcpen.
> +
>  config TOUCHSCREEN_PENMOUNT
>  	tristate "Penmount serial touchscreen"
>  	select SERIO
> diff -uprN linux-2.6.25.4/drivers/input/touchscreen/Makefile linux/driver=
s/input/touchscreen/Makefile
> --- linux-2.6.25.4/drivers/input/touchscreen/Makefile	2008-05-15 17:00:12=
=2E000000000 +0200
> +++ linux/drivers/input/touchscreen/Makefile	2008-05-17 03:10:12.00000000=
0 +0200
> @@ -14,6 +14,7 @@ obj-$(CONFIG_TOUCHSCREEN_MTOUCH)	+=3D mtou
>  obj-$(CONFIG_TOUCHSCREEN_MK712)		+=3D mk712.o
>  obj-$(CONFIG_TOUCHSCREEN_HP600)		+=3D hp680_ts_input.o
>  obj-$(CONFIG_TOUCHSCREEN_HP7XX)		+=3D jornada720_ts.o
> +obj-$(CONFIG_TOUCHSCREEN_HTCPEN)	+=3D htcpen.o
>  obj-$(CONFIG_TOUCHSCREEN_USB_COMPOSITE)	+=3D usbtouchscreen.o
>  obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+=3D penmount.o
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+=3D touchright.o
> --- linux-2.6.25.4/MAINTAINERS	2008-05-15 17:00:12.000000000 +0200
> +++ linux/MAINTAINERS	2008-05-19 15:40:11.000000000 +0200
> @@ -1875,6 +1875,12 @@ M:	mikulas@artax.karlin.mff.cuni.cz
>  W:	http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi
>  S:	Maintained
>
> +HTCPEN TOUCHSCREEN DRIVER
> +P:	Pau Oliva Fora
> +M:	pof@eslack.org
> +L:	linux-input@vger.kernel.org
> +S:	Maintained
> +
>  HUGETLB FILESYSTEM
>  P:	William Irwin
>  M:	wli@holomorphy.com

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--7DO5AaGCk89r4vaK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIMsYeIWZCBzwS8mkRAkYsAJ4pyB5IJFjKq9WCk3fXc9M0E0+JSgCfXuny
NLlNeMurF3rgBcDV2uNMXhA=
=sYkJ
-----END PGP SIGNATURE-----

--7DO5AaGCk89r4vaK--

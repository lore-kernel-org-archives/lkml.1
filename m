Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbYGULUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbYGULUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbYGULUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:20:16 -0400
Received: from bokovka.donpac.ru ([80.254.111.46]:35769 "EHLO
	bokovka.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYGULUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:20:15 -0400
X-Greylist: delayed 2449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2008 07:20:14 EDT
Date: Mon, 21 Jul 2008 14:36:59 +0400
From: Andrey Panin <pazke@pazke.donpac.ru>
To: Sean Young <sean@mess.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Led driver for technologic systems 5500
Message-ID: <20080721103659.GA19498@pazke.donpac.ru>
Mail-Followup-To: Sean Young <sean@mess.org>, linux-kernel@vger.kernel.org
References: <20080719122339.GA28813@atlantis.8hz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20080719122339.GA28813@atlantis.8hz.com>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 201, 07 19, 2008 at 12:23:39PM +0000, Sean Young wrote:
> Here is a patch for the led on the Technologic Systems 5500 board. Detect=
ion
> is a bit flimsy; Is there anything that can be done about that?

Does this system contain usable DMI info ? If yes, use dmi_check_system().

> Signed-off-by: Sean Young <sean@mess.org>
> ---
> diff -urpN linux-2.6.26/drivers/leds/Kconfig /home/sean/tiger/linux-2.6.2=
6/drivers/leds/Kconfig
> --- linux-2.6.26/drivers/leds/Kconfig	2008-07-13 22:51:29.000000000 +0100
> +++ /home/sean/tiger/linux-2.6.26/drivers/leds/Kconfig	2008-07-17 15:14:5=
5.000000000 +0100
> @@ -147,6 +147,16 @@ config LEDS_CLEVO_MAIL
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called leds-clevo-mail.
> =20
> +config LEDS_TS5500
> +	tristate "LED Support for the TS-5500"
> +	depends on LEDS_CLASS && X86
> +	help
> +	  This driver makes the led on the Technology Systems 5500=20
> +	  (and possibly other models) accessible for userspace.=20
> +
> +	  Note that this led is hardwired to be xor'ed with Compact Flash
> +	  activity.
> +
>  comment "LED Triggers"
> =20
>  config LEDS_TRIGGERS
> diff -urpN linux-2.6.26/drivers/leds/leds-ts5500.c /home/sean/tiger/linux=
-2.6.26/drivers/leds/leds-ts5500.c
> --- linux-2.6.26/drivers/leds/leds-ts5500.c	1970-01-01 01:00:00.000000000=
 +0100
> +++ /home/sean/tiger/linux-2.6.26/drivers/leds/leds-ts5500.c	2008-07-19 1=
3:08:19.000000000 +0100
> @@ -0,0 +1,99 @@
> +/*
> + * Copyright (C) 2008 Sean Young <sean@mess.org>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/delay.h>
> +#include <linux/string.h>
> +#include <linux/io.h>
> +#include <linux/leds.h>
> +
> +static struct platform_device *ts5500_platform_device;
> +
> +static void ts5500_led_set(struct led_classdev *led_dev, enum led_bright=
ness value)
> +{
> +	outb(value ? 1 : 0, 0x77);
> +}
> +
> +static struct led_classdev ts5500_led =3D {
> +	.name =3D "ts5500:green",
> +	.brightness_set =3D ts5500_led_set,
> +};
> +
> +static int __devinit ts5500leds_probe(struct platform_device *pdev)
> +{
> +	return led_classdev_register(&pdev->dev, &ts5500_led);
> +}
> +
> +static int __devexit ts5500leds_remove(struct platform_device *pdev)
> +{
> +	led_classdev_unregister(&ts5500_led);
> +	return 0;
> +}
> +
> +static struct platform_driver ts5500leds_driver =3D {
> +	.driver		=3D {
> +		.name	=3D "ts5500-leds",
> +		.owner	=3D THIS_MODULE,
> +	},
> +	.probe		=3D ts5500leds_probe,
> +	.remove		=3D __devexit_p(ts5500leds_remove),
> +};
> +
> +
> +static int __init ts5500leds_init(void)
> +{
> +	int rc;
> +	uint8_t product_code;
> +
> +	if (!request_region(0x74, 1, "ts5500-leds"))
> +		return -ENODEV;
> +
> +	product_code =3D inb(0x74);
> +
> +	release_region(0x74, 1);
> +
> +	if (product_code !=3D 0x60)
> +		return -ENODEV;
> +
> +	if (!request_region(0x77, 1, "ts5500-leds"))
> +		return -ENODEV;
> +
> +	rc =3D platform_driver_register(&ts5500leds_driver);
> +	if (rc)
> +		goto free_port;
> +
> +	ts5500_platform_device =3D platform_device_alloc("ts5500-leds", -1);
> +	if (!ts5500_platform_device)
> +		goto driver_unreg;
> +
> +	rc =3D platform_device_add(ts5500_platform_device);
> +	if (rc)
> +		goto free_device;
> +
> +	return 0;
> +
> +free_port:
> +	release_region(0x77, 1);
> +free_device:
> +	platform_device_put(ts5500_platform_device);
> +driver_unreg:
> +	platform_driver_unregister(&ts5500leds_driver);
> +
> +	return rc;
> +}
> +
> +static void __exit ts5500leds_exit(void)
> +{
> +	platform_device_unregister(ts5500_platform_device);
> +	platform_driver_unregister(&ts5500leds_driver);
> +	release_region(0x77, 1);
> +}
> +
> +module_init(ts5500leds_init);
> +module_exit(ts5500leds_exit);
> +
> +MODULE_AUTHOR("Sean Young <sean@mess.org>");
> +MODULE_DESCRIPTION("LED driver for the Technology Systems 5500");
> +MODULE_LICENSE("GPL");
> diff -urpN linux-2.6.26/drivers/leds/Makefile /home/sean/tiger/linux-2.6.=
26/drivers/leds/Makefile
> --- linux-2.6.26/drivers/leds/Makefile	2008-07-13 22:51:29.000000000 +0100
> +++ /home/sean/tiger/linux-2.6.26/drivers/leds/Makefile	2008-07-17 15:14:=
55.000000000 +0100
> @@ -21,6 +21,7 @@ obj-$(CONFIG_LEDS_CM_X270)             =20
>  obj-$(CONFIG_LEDS_CLEVO_MAIL)		+=3D leds-clevo-mail.o
>  obj-$(CONFIG_LEDS_HP6XX)		+=3D leds-hp6xx.o
>  obj-$(CONFIG_LEDS_FSG)			+=3D leds-fsg.o
> +obj-$(CONFIG_LEDS_TS5500)		+=3D leds-ts5500.o
> =20
>  # LED Triggers
>  obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+=3D ledtrig-timer.o
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIhGbLIWZCBzwS8mkRAtxVAKC1rp6tNwlGw4bRzvBogAyU/myvXACcDPjo
Du3q4LOIprVQ8/CEF8Ifia0=
=9ToG
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYHSGhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYHSGhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 02:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYHSGgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 02:36:53 -0400
Received: from bokovka.donpac.ru ([80.254.111.46]:57081 "EHLO
	bokovka.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYHSGgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 02:36:52 -0400
Date: Tue, 19 Aug 2008 10:32:38 +0400
From: Andrey Panin <pazke@pazke.donpac.ru>
To: Claudio Nieder <private@claudio.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Backlight driver for Tabletkiosk Sahara TouchIT-213
	Tablet PC
Message-ID: <20080819063238.GD15867@pazke.donpac.ru>
Mail-Followup-To: Claudio Nieder <private@claudio.ch>,
	Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
	linux-kernel@vger.kernel.org
References: <488E0D2A.1000005@claudio.ch> <1217270428.6059.39.camel@dax.rpnet.com> <488E25F4.4020405@claudio.ch> <20080811134940.b3bcde83.akpm@linux-foundation.org> <48A1CA9A.4000007@claudio.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bKyqfOwhbdpXa4YI"
Content-Disposition: inline
In-Reply-To: <48A1CA9A.4000007@claudio.ch>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 225, 08 12, 2008 at 07:38:34PM +0200, Claudio Nieder wrote:
> Hi,
>=20
> > I believe the mdelay()s could be converted to the preferable msleep()?
>=20
> thank you for the remark. I have changed the mdelay to msleep in my
> patch, reapplied it to the current Linus tree, built a kernel, installed
> it on my computer and tested it. It works perfectly as you surely
> expected. The corrected patch is included here.

Poking at random ports isn't very nice. Is it possible to autodetect this t=
ablet PC ?
Has it specific PCI ids or usefull DMI table ?

> BTW: I have noticed that some other drivers in video/backlight still use
> mdelay: ili9320.c, locomolcd.c and vgg2432a4.c.
>=20
> claudio
>=20
>=20
> Signed-off-by: Claudio Nieder <private@claudio.ch>
>=20
> ---
>  drivers/video/backlight/Kconfig     |    7 +
>  drivers/video/backlight/Makefile    |    1 +
>  drivers/video/backlight/kb3886_bl.c |  218 +++++++++++++++++++++++++++++=
++++++
>  3 files changed, 226 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kc=
onfig
> index 452b770..bc65541 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -164,3 +164,10 @@ config BACKLIGHT_MBP_NVIDIA
>           If you have an Apple Macbook Pro with Nvidia graphics hardware =
say Y
>  	 to enable a driver for its backlight
>=20
> +config BACKLIGHT_SAHARA
> +	tristate "Tabletkiosk Sahara Touch-iT Backlight Driver"
> +	depends on BACKLIGHT_CLASS_DEVICE && X86
> +	default y
> +	help
> +	  If you have a Tabletkiosk Sahara Touch-iT, say y to enable the
> +	  backlight driver.
> diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/M=
akefile
> index b405aac..f4a1183 100644
> --- a/drivers/video/backlight/Makefile
> +++ b/drivers/video/backlight/Makefile
> @@ -16,4 +16,5 @@ obj-$(CONFIG_BACKLIGHT_PROGEAR) +=3D progear_bl.o
>  obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) +=3D cr_bllcd.o
>  obj-$(CONFIG_BACKLIGHT_PWM)	+=3D pwm_bl.o
>  obj-$(CONFIG_BACKLIGHT_MBP_NVIDIA) +=3D mbp_nvidia_bl.o
> +obj-$(CONFIG_BACKLIGHT_SAHARA)	+=3D kb3886_bl.o
>=20
> diff --git a/drivers/video/backlight/kb3886_bl.c
> b/drivers/video/backlight/kb3886_bl.c
> new file mode 100644
> index 0000000..60eec06
> --- /dev/null
> +++ b/drivers/video/backlight/kb3886_bl.c
> @@ -0,0 +1,218 @@
> +/*
> + *  Backlight Driver for the KB3886 Backlight
> + *
> + *  Copyright (c) 2007 Claudio Nieder
> + *
> + *  Based on corgi_bl.c by Richard Purdie and kb3886 driver by Robert Wo=
erle
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/mutex.h>
> +#include <linux/fb.h>
> +#include <linux/backlight.h>
> +#include <linux/delay.h>
> +
> +
> +/*
> + * The following is what corgi has in arch/arm/mach-pxa/corgi.c and
> + * corgi_lcd.c. On kernelnebwies it was suggested I put the platform_dev=
ice
> + * code in my driver.
> + */
> +
> +#define KB3886_PARENT 0x64
> +#define KB3886_IO 0x60
> +#define KB3886_ADC_DAC_PWM 0xC4
> +#define KB3886_PWM0_WRITE 0x81
> +#define KB3886_PWM0_READ 0x41
> +
> +static DEFINE_MUTEX(bl_mutex);
> +
> +void kb3886_bl_set_intensity(int intensity)

static ?

> +{
> +	mutex_lock(&bl_mutex);
> +	intensity =3D intensity&0xff;
> +	outb(KB3886_ADC_DAC_PWM, KB3886_PARENT);
> +	msleep(10);
> +	outb(KB3886_PWM0_WRITE, KB3886_IO);
> +	msleep(10);
> +	outb(intensity, KB3886_IO);
> +	mutex_unlock(&bl_mutex);
> +}
> +
> +struct kb3886bl_machinfo {
> +	int max_intensity;
> +	int default_intensity;
> +	int limit_mask;
> +	void (*set_bl_intensity)(int intensity);
> +};
> +
> +static struct kb3886bl_machinfo kb3886_bl_machinfo =3D {
> +	.max_intensity =3D 0xff,
> +	.default_intensity =3D 0xa0,
> +	.limit_mask =3D 0x7f,
> +	.set_bl_intensity =3D kb3886_bl_set_intensity,
> +};
> +
> +static struct platform_device kb3886bl_device =3D {
> +	.name		=3D "kb3886-bl",
> +	.dev		=3D {
> +		.platform_data	=3D &kb3886_bl_machinfo,
> +	},
> +	.id		=3D -1,
> +};
> +
> +static struct platform_device *devices[] __initdata =3D {
> +	&kb3886bl_device,
> +};
> +
> +static void __init sahara_init(void)
> +{
> +	platform_add_devices(devices, ARRAY_SIZE(devices));
> +}

Why do you need this wrapper ?

> +
> +/*
> + * Back to driver
> + */
> +
> +static int kb3886bl_intensity;
> +static struct backlight_device *kb3886_backlight_device;
> +static struct kb3886bl_machinfo *bl_machinfo;
> +
> +static unsigned long kb3886bl_flags;
> +#define KB3886BL_SUSPENDED     0x01
> +#define KB3886BL_BATTLOW       0x02
> +
> +static int kb3886bl_send_intensity(struct backlight_device *bd)
> +{
> +	int intensity =3D bd->props.brightness;
> +
> +	if (bd->props.power !=3D FB_BLANK_UNBLANK)
> +		intensity =3D 0;
> +	if (bd->props.fb_blank !=3D FB_BLANK_UNBLANK)
> +		intensity =3D 0;
> +	if (kb3886bl_flags & KB3886BL_SUSPENDED)
> +		intensity =3D 0;
> +	if (kb3886bl_flags & KB3886BL_BATTLOW)
> +		intensity &=3D bl_machinfo->limit_mask;
> +
> +	bl_machinfo->set_bl_intensity(intensity);
> +
> +	kb3886bl_intensity =3D intensity;
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int kb3886bl_suspend(struct platform_device *pdev, pm_message_t s=
tate)
> +{
> +	struct backlight_device *bd =3D platform_get_drvdata(pdev);
> +
> +	kb3886bl_flags |=3D KB3886BL_SUSPENDED;
> +	backlight_update_status(bd);
> +	return 0;
> +}
> +
> +static int kb3886bl_resume(struct platform_device *pdev)
> +{
> +	struct backlight_device *bd =3D platform_get_drvdata(pdev);
> +
> +	kb3886bl_flags &=3D ~KB3886BL_SUSPENDED;
> +	backlight_update_status(bd);
> +	return 0;
> +}
> +#else
> +#define kb3886bl_suspend	NULL
> +#define kb3886bl_resume		NULL
> +#endif
> +
> +static int kb3886bl_get_intensity(struct backlight_device *bd)
> +{
> +	return kb3886bl_intensity;
> +}
> +
> +/*
> + * Called when the battery is low to limit the backlight intensity.
> + * If limit=3D=3D0 clear any limit, otherwise limit the intensity
> + */
> +void kb3886bl_limit_intensity(int limit)
> +{
> +	if (limit)
> +		kb3886bl_flags |=3D KB3886BL_BATTLOW;
> +	else
> +		kb3886bl_flags &=3D ~KB3886BL_BATTLOW;
> +	backlight_update_status(kb3886_backlight_device);
> +}
> +EXPORT_SYMBOL(kb3886bl_limit_intensity);

This function is unused. Looks like you copied it from corgi_bl.c where
it is called from platform code.

> +
> +
> +static struct backlight_ops kb3886bl_ops =3D {
> +	.get_brightness =3D kb3886bl_get_intensity,
> +	.update_status  =3D kb3886bl_send_intensity,
> +};
> +
> +static int kb3886bl_probe(struct platform_device *pdev)
> +{
> +	struct kb3886bl_machinfo *machinfo =3D pdev->dev.platform_data;
> +
> +	bl_machinfo =3D machinfo;
> +	if (!machinfo->limit_mask)
> +		machinfo->limit_mask =3D -1;
> +
> +	kb3886_backlight_device =3D backlight_device_register("kb3886-bl",
> +		&pdev->dev, NULL, &kb3886bl_ops);
> +	if (IS_ERR (kb3886_backlight_device))
> +		return PTR_ERR(kb3886_backlight_device);
> +
> +	platform_set_drvdata(pdev, kb3886_backlight_device);
> +
> +	kb3886_backlight_device->props.max_brightness =3D machinfo->max_intensi=
ty;
> +	kb3886_backlight_device->props.power =3D FB_BLANK_UNBLANK;
> +	kb3886_backlight_device->props.brightness =3D machinfo->default_intensi=
ty;
> +	backlight_update_status(kb3886_backlight_device);
> +
> +	return 0;
> +}
> +
> +static int kb3886bl_remove(struct platform_device *pdev)
> +{
> +	struct backlight_device *bd =3D platform_get_drvdata(pdev);
> +
> +	backlight_device_unregister(bd);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver kb3886bl_driver =3D {
> +	.probe		=3D kb3886bl_probe,
> +	.remove		=3D kb3886bl_remove,
> +	.suspend	=3D kb3886bl_suspend,
> +	.resume		=3D kb3886bl_resume,
> +	.driver		=3D {
> +		.name	=3D "kb3886-bl",
> +	},
> +};
> +
> +static int __init kb3886_init(void)
> +{
> +	sahara_init();
> +	return platform_driver_register(&kb3886bl_driver);
> +}
> +
> +static void __exit kb3886_exit(void)
> +{
> +	platform_driver_unregister(&kb3886bl_driver);
> +}
> +
> +module_init(kb3886_init);
> +module_exit(kb3886_exit);
> +
> +MODULE_AUTHOR("Claudio Nieder <private@claudio.ch>");
> +MODULE_DESCRIPTION("Tabletkiosk Sahara Touch-iT Backlight Driver");
> +MODULE_LICENSE("GPL");
> --=20
> 1.4.4.4
>=20
>=20
> --=20
> Claudio Nieder, Talweg 6, CH-8610 Uster, Tel +4179 357 6743, www.claudio.=
ch
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--bKyqfOwhbdpXa4YI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIqmkGIWZCBzwS8mkRAt+JAKCMnwMIrw9uR/us6bP6VQA/ynjiIACfUAOc
zw/7OgKN9xccFw/OlkjmJPA=
=J0QC
-----END PGP SIGNATURE-----

--bKyqfOwhbdpXa4YI--

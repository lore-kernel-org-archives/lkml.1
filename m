Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab0BUNlj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 08:41:39 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:47530 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0BUNlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 08:41:37 -0500
Date: Sun, 21 Feb 2010 10:35:29 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Daniel Oliveira Nascimento <don@syst.com.br>,
       Len Brown <len.brown@intel.com>, Anisse Astier <anisse@astier.eu>,
       Thomas Renninger <trenn@suse.de>, Matt Chen <machen@novell.com>,
       Harald Welte <laforge@gnumonks.org>, Martin Lucina <mato@kotelna.sk>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       pancho horrillo <pancho@pancho.name>,
       Mike Frysinger <vapier@gentoo.org>,
       Vivek Kutal <vivek.kutal@azingo.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/3] backlight: fix missing/incomplete registration
 failure handling
Message-ID: <20100221133528.GB1840@holoscopio.com>
References: <20100221001049.2f63f5d6@neptune.home>
 <20100221002831.689bace8@neptune.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <20100221002831.689bace8@neptune.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 21, 2010 at 12:28:31AM +0100, Bruno Pr=C3=A9mont wrote:
> Check newly registered backlight_device for error and properly
> return error to parent
>=20
> Signed-off-by: Bruno Pr=C3=A9mont <bonbons@linux-vserver.org>
> ---
>  drivers/platform/x86/classmate-laptop.c |    2 ++
>  drivers/platform/x86/msi-wmi.c          |    4 +++-
>  drivers/platform/x86/panasonic-laptop.c |    4 +++-
>  drivers/usb/misc/appledisplay.c         |    1 +
>  drivers/video/bf54x-lq043fb.c           |    8 ++++++++
>  drivers/video/bfin-t350mcqb-fb.c        |    8 ++++++++
>  6 files changed, 25 insertions(+), 2 deletions(-)
>=20

I think you should split the patch for every driver. Then, every
mantainer may ack only its particular section of the patch.

> diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x=
86/classmate-laptop.c
> index bfae789..66f6aad 100644
> --- a/drivers/platform/x86/classmate-laptop.c
> +++ b/drivers/platform/x86/classmate-laptop.c
> @@ -463,6 +463,8 @@ static int cmpc_bl_add(struct acpi_device *acpi)
> =20
>  	bd =3D backlight_device_register("cmpc_bl", &acpi->dev,
>  				       acpi->handle, &cmpc_bl_ops);
> +	if (IS_ERR(bd))
> +		return PTR_ERR(bd);
>  	bd->props.max_brightness =3D 7;
>  	dev_set_drvdata(&acpi->dev, bd);
>  	return 0;
> diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wm=
i.c
> index 5f7cff1..2ffbfcf 100644
> --- a/drivers/platform/x86/msi-wmi.c
> +++ b/drivers/platform/x86/msi-wmi.c
> @@ -251,8 +251,10 @@ static int __init msi_wmi_init(void)
>  	if (!acpi_video_backlight_support()) {
>  		backlight =3D backlight_device_register(DRV_NAME,
>  				NULL, NULL, &msi_backlight_ops);
> -		if (IS_ERR(backlight))
> +		if (IS_ERR(backlight)) {
> +			err =3D PTR_ERR(backlight);
>  			goto err_free_input;
> +		}
> =20
>  		backlight->props.max_brightness =3D ARRAY_SIZE(backlight_map) - 1;
>  		err =3D bl_get(NULL);
> diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x=
86/panasonic-laptop.c
> index 9012d8d..9b17343 100644
> --- a/drivers/platform/x86/panasonic-laptop.c
> +++ b/drivers/platform/x86/panasonic-laptop.c
> @@ -644,8 +644,10 @@ static int acpi_pcc_hotkey_add(struct acpi_device *d=
evice)
>  	/* initialize backlight */
>  	pcc->backlight =3D backlight_device_register("panasonic", NULL, pcc,
>  						   &pcc_backlight_ops);
> -	if (IS_ERR(pcc->backlight))
> +	if (IS_ERR(pcc->backlight)) {
> +		result =3D PTR_ERR(pcc->backlight);
>  		goto out_input;
> +	}
> =20
>  	if (!acpi_pcc_retrieve_biosdata(pcc, pcc->sinf)) {
>  		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
> diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisp=
lay.c
> index ef79ca2..413f154 100644
> --- a/drivers/usb/misc/appledisplay.c
> +++ b/drivers/usb/misc/appledisplay.c
> @@ -283,6 +283,7 @@ static int appledisplay_probe(struct usb_interface *i=
face,
>  						&appledisplay_bl_data);
>  	if (IS_ERR(pdata->bd)) {
>  		dev_err(&iface->dev, "Backlight registration failed\n");
> +		retval =3D PTR_ERR(pdata->bd);
>  		goto error;
>  	}
> =20
> diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
> index db4e6f7..a589216 100644
> --- a/drivers/video/bf54x-lq043fb.c
> +++ b/drivers/video/bf54x-lq043fb.c
> @@ -678,6 +678,12 @@ static int __devinit bfin_bf54x_probe(struct platfor=
m_device *pdev)
>  	bl_dev =3D
>  	    backlight_device_register("bf54x-bl", NULL, NULL,
>  				      &bfin_lq043fb_bl_ops);
> +	if (IS_ERR(bl_dev)) {
> +		printk(KERN_ERR DRIVER_NAME
> +		       ": unable to register backlight.\n");
> +		ret =3D -EINVAL;
> +		goto out9;
> +	}
>  	bl_dev->props.max_brightness =3D 255;
> =20
>  	lcd_dev =3D lcd_device_register(DRIVER_NAME, &pdev->dev, NULL, &bfin_lc=
d_ops);
> @@ -686,6 +692,8 @@ static int __devinit bfin_bf54x_probe(struct platform=
_device *pdev)
> =20
>  	return 0;
> =20
> +out9:
> +	unregister_framebuffer(fbinfo);
>  out8:
>  	free_irq(info->irq, info);
>  out7:
> diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mc=
qb-fb.c
> index bc204c6..fe1492b 100644
> --- a/drivers/video/bfin-t350mcqb-fb.c
> +++ b/drivers/video/bfin-t350mcqb-fb.c
> @@ -572,6 +572,12 @@ static int __devinit bfin_t350mcqb_probe(struct plat=
form_device *pdev)
>  	bl_dev =3D
>  	    backlight_device_register("bf52x-bl", NULL, NULL,
>  				      &bfin_lq043fb_bl_ops);
> +	if (IS_ERR(bl_dev)) {
> +		printk(KERN_ERR DRIVER_NAME
> +		       ": unable to register backlight.\n");
> +		ret =3D -EINVAL;
> +		goto out9;
> +	}
>  	bl_dev->props.max_brightness =3D 255;
> =20
>  	lcd_dev =3D lcd_device_register(DRIVER_NAME, NULL, &bfin_lcd_ops);
> @@ -580,6 +586,8 @@ static int __devinit bfin_t350mcqb_probe(struct platf=
orm_device *pdev)
> =20
>  	return 0;
> =20
> +out9:
> +	unregister_framebuffer(fbinfo);
>  out8:
>  	free_irq(info->irq, info);
>  out7:
> --=20
> 1.6.4.4
>=20

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuBNqAACgkQyTpryRcqtS15HACfVQz1uStlJRp3mjAA8KLSlMeW
vYsAnishemhGzRkV8dqshPJ3pU+4pO9H
=sKGs
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--

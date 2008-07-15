Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbYGODKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbYGODKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYGODKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:10:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42994 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbYGODKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:10:13 -0400
Date: Tue, 15 Jul 2008 13:10:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: implement OpenFirmare GPIO LED driver
Message-Id: <20080715131004.32646dae.sfr@canb.auug.org.au>
In-Reply-To: <20080714164114.GA18784@polina.dev.rtsoft.ru>
References: <20080714164114.GA18784@polina.dev.rtsoft.ru>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Jul_2008_13_10_04_+1000_JPX3fhZjiHZlAYkg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Jul_2008_13_10_04_+1000_JPX3fhZjiHZlAYkg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

On Mon, 14 Jul 2008 20:41:14 +0400 Anton Vorontsov <avorontsov@ru.mvista.co=
m> wrote:
>
> +static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
> +					const struct of_device_id *match)
> +{
> +	int ret;
> +	struct of_gpio_led *led;
> +	struct device_node *np =3D ofdev->node;
> +
> +	led =3D kzalloc(sizeof(*led), GFP_KERNEL);
> +	if (!led)
> +		return -ENOMEM;
> +
> +	led->np =3D np;

You need to take a reference if you are keeping a pointer to a
device_node, so:
	led->np =3D of_node_get(np);

> +	led->cdev.name =3D of_get_property(np, "label", NULL);
> +	if (!led->cdev.name)
> +		led->cdev.name =3D ofdev->dev.bus_id;

Please use dev_name() in new code:
		led->cdev.name =3D dev_name(&ofdev->dev);

> +	led->cdev.brightness_set =3D gpio_led_set;
> +
> +	ret =3D gpio_request(led->gpio, ofdev->dev.bus_id);

dev_name() again.

> +err_get_gpio:

	of_node_put(led->np);

> +	kfree(led);
> +	return ret;
> +}
> +
> +static int __devexit of_gpio_leds_remove(struct of_device *ofdev)
> +{
> +	struct of_gpio_led *led =3D dev_get_drvdata(&ofdev->dev);
> +
> +	led_classdev_unregister(&led->cdev);
> +	cancel_work_sync(&led->work);
> +	gpio_free(led->gpio);
> +	of_node_put(led->np);

This was going to be unbalanced, but is now correct.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Jul_2008_13_10_04_+1000_JPX3fhZjiHZlAYkg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh8FQ0ACgkQjjKRsyhoI8zeoQCfUMM1DNIvqwa8d/uiM3FTjuIH
EZUAoKeYYZNL2PMSiKDgHxZz877bYRTt
=HVeE
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Jul_2008_13_10_04_+1000_JPX3fhZjiHZlAYkg--

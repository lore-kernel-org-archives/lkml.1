Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab0BIANT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 19:13:19 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:38224 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab0BIANR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 19:13:17 -0500
Date: Mon, 8 Feb 2010 22:08:10 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org,
       Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: setup hotkey polling after changing
 hotkey_driver_mask
Message-ID: <20100209000810.GC1420@holoscopio.com>
References: <1265567528-1180-1-git-send-email-cascardo@holoscopio.com>
 <20100208155059.eed393a6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <20100208155059.eed393a6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 08, 2010 at 03:50:59PM -0800, Andrew Morton wrote:
> On Sun,  7 Feb 2010 16:32:07 -0200
> Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:
>=20
> > Brightness notification does not work until the user writes to
> > hotkey_mask attribute. That's because the polling thread will only run
> > if hotkey_user_mask is set and someone is reading the input device or if
> > hotkey_driver_mask is set. In this second case, this condition is not
> > tested after the mask is changed, because the brightness and volume
> > drivers are started after the hotkey drivers.
> >=20
> > This fix test for the polling condition that ends up starting the
> > polling thread after hotkey_driver_mask is set in brightness and volume
> > init functions.
> >=20
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > ---
> >  drivers/platform/x86/thinkpad_acpi.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x8=
6/thinkpad_acpi.c
> > index e67e4fe..d69749d 100644
> > --- a/drivers/platform/x86/thinkpad_acpi.c
> > +++ b/drivers/platform/x86/thinkpad_acpi.c
> > @@ -6272,6 +6272,11 @@ static int __init brightness_init(struct ibm_ini=
t_struct *iibm)
> >  	tpacpi_hotkey_driver_mask_set(hotkey_driver_mask
> >  				| TP_ACPI_HKEY_BRGHTUP_MASK
> >  				| TP_ACPI_HKEY_BRGHTDWN_MASK);;
> > +
> > +#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
> > +	hotkey_poll_setup(true);
> > +#endif
> > +
> >  	return 0;
> >  }
> > =20
> > @@ -6903,6 +6908,10 @@ static int __init volume_init(struct ibm_init_st=
ruct *iibm)
> >  			| TP_ACPI_HKEY_VOLDWN_MASK
> >  			| TP_ACPI_HKEY_MUTE_MASK);
> > =20
> > +#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
> > +	hotkey_poll_setup(true);
> > +#endif
> > +
> >  	return 0;
> >  }
>=20
> Something like this is needed, methinks:
>=20
> - Avoid ifdefs
>=20
> - Make sure that hotkey_mutex is held when calling hotkey_poll_setup:
>   use hotkey_poll_setup_safe.  Doesn't matter much in __init code.
>=20
> --- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-setup-hotkey-pol=
ling-after-changing-hotkey_driver_mask-fix
> +++ a/drivers/platform/x86/thinkpad_acpi.c
> @@ -2597,6 +2597,10 @@ static void hotkey_poll_set_freq(unsigne
> =20
>  #else /* CONFIG_THINKPAD_ACPI_HOTKEY_POLL */
> =20
> +static void hotkey_poll_setup(bool __unused)
> +{
> +}
> +
>  static void hotkey_poll_setup_safe(bool __unused)
>  {
>  }
> @@ -2694,9 +2698,7 @@ static ssize_t hotkey_mask_store(struct=20
> =20
>  	res =3D hotkey_user_mask_set(t);
> =20
> -#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
>  	hotkey_poll_setup(true);
> -#endif
> =20
>  	mutex_unlock(&hotkey_mutex);
> =20
> @@ -6273,9 +6275,7 @@ static int __init brightness_init(struct
>  				| TP_ACPI_HKEY_BRGHTUP_MASK
>  				| TP_ACPI_HKEY_BRGHTDWN_MASK);;
> =20
> -#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
> -	hotkey_poll_setup(true);
> -#endif
> +	hotkey_poll_setup_safe(true);
> =20
>  	return 0;
>  }
> _
>=20

How about the added call to volume_init?

Regards,
Cascardo.

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktwp2oACgkQyTpryRcqtS2coACfbZDEq96vsBvTbDnWj7YrjvPu
zlcAniPSLtsXegJczIFPtciHxnrAtiFh
=ZYsN
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--

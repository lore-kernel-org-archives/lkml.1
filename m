Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0BJAWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 19:22:10 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:55516 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab0BJAWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 19:22:08 -0500
Date: Tue, 9 Feb 2010 22:16:52 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] thinkpad-acpi: setup hotkey polling after changing
 hotkey_driver_mask
Message-ID: <20100210001651.GA1422@holoscopio.com>
References: <1265567528-1180-1-git-send-email-cascardo@holoscopio.com>
 <20100209003706.GC21680@khazad-dum.debian.net>
 <20100209013736.GE21680@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20100209013736.GE21680@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 08, 2010 at 11:37:36PM -0200, Henrique de Moraes Holschuh wrote:
> Thadeu, thanks for the detailed analysis of the problem.
>=20
> Please test the commit below, it should fix things cleanly.  I am quite
> tired right now, so I might have missed some details, but it survived a f=
ast
> testing and compiled without warnings both with and without poll support
> compiled in.
>=20
> Tested in a T43 by crippling the input device open handle to not start the
> poller, and by crippling hotkey_mask support to force the driver to think=
 it
> needs to default to poll mode.  Both volume and brightness reporting work=
ed
> fine in the test.
>=20
> If it does fixes the issues you observed, I will add the tested-by, and s=
end
> it to Len.
>=20

Sorry for the delay. Takes a while to build a kernel in my old notebook
with a not-so-large config.

It works nice for me. This was a fix that has crossed my mind, but since
other init was doing the other way (hotkey_init), I did prefer that too.
Anyway, your way is cleaner and the right way.  :-)

Tested-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Thanks and my best regards,
Cascardo.

>=20
> commit 8e05920a6cb236b21f31391b4479ec29ce65ccdf
> Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Date:   Mon Feb 8 22:40:28 2010 -0200
>=20
>     thinkpad-acpi: make driver events work in NVRAM poll mode
>    =20
>     Thadeu Lima de Souza Cascardo reports this:
>    =20
>     Brightness notification does not work until the user writes to
>     hotkey_mask attribute.  That's because the polling thread will only r=
un
>     if hotkey_user_mask is set and someone is reading the input device or
>     if hotkey_driver_mask is set.  In this second case, this condition is
>     not tested after the mask is changed, because the brightness and
>     volume drivers are started after the hotkey drivers.
>    =20
>     Fix tpacpi_hotkey_driver_mask_set() to call hotkey_poll_setup(), so
>     that the poller kthread will be started when needed.
>    =20
>     Reported-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
>     Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
>     Cc: Andrew Morton <akpm@linux-foundation.org>
>=20
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/=
thinkpad_acpi.c
> index d12b61b..09c1fe6 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -2086,6 +2086,7 @@ static struct attribute_set *hotkey_dev_attributes;
> =20
>  static void tpacpi_driver_event(const unsigned int hkey_event);
>  static void hotkey_driver_event(const unsigned int scancode);
> +static void hotkey_poll_setup(const bool may_warn);
> =20
>  /* HKEY.MHKG() return bits */
>  #define TP_HOTKEY_TABLET_MASK (1 << 3)
> @@ -2268,6 +2269,8 @@ static int tpacpi_hotkey_driver_mask_set(const u32 =
mask)
> =20
>  	rc =3D hotkey_mask_set((hotkey_acpi_mask | hotkey_driver_mask) &
>  							~hotkey_source_mask);
> +	hotkey_poll_setup(true);
> +
>  	mutex_unlock(&hotkey_mutex);
> =20
>  	return rc;
> @@ -2552,7 +2555,7 @@ static void hotkey_poll_stop_sync(void)
>  }
> =20
>  /* call with hotkey_mutex held */
> -static void hotkey_poll_setup(bool may_warn)
> +static void hotkey_poll_setup(const bool may_warn)
>  {
>  	const u32 poll_driver_mask =3D hotkey_driver_mask & hotkey_source_mask;
>  	const u32 poll_user_mask =3D hotkey_user_mask & hotkey_source_mask;
> @@ -2583,7 +2586,7 @@ static void hotkey_poll_setup(bool may_warn)
>  	}
>  }
> =20
> -static void hotkey_poll_setup_safe(bool may_warn)
> +static void hotkey_poll_setup_safe(const bool may_warn)
>  {
>  	mutex_lock(&hotkey_mutex);
>  	hotkey_poll_setup(may_warn);
> @@ -2601,7 +2604,11 @@ static void hotkey_poll_set_freq(unsigned int freq)
> =20
>  #else /* CONFIG_THINKPAD_ACPI_HOTKEY_POLL */
> =20
> -static void hotkey_poll_setup_safe(bool __unused)
> +static void hotkey_poll_setup(const bool __unused)
> +{
> +}
> +
> +static void hotkey_poll_setup_safe(const bool __unused)
>  {
>  }
> =20
>=20
> --=20
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktx+vMACgkQyTpryRcqtS1VkQCbBgBAJTz1s6aiaev8MuvbG7ez
KTsAn0YIM6u4j7sOav5CxddByKvoCRXn
=77Ba
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--

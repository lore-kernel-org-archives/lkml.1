Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbZGBHS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbZGBHS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 03:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbZGBHSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 03:18:14 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:59071 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbZGBHSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 03:18:13 -0400
Date: Thu, 2 Jul 2009 09:18:08 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Ben Nizette <bn@niasdigital.com>
Cc: s.hauer@pengutronix.de, linux-kernel <linux-kernel@vger.kernel.org>,
       kernel <kernel@avr32linux.org>, Ben Nizette <bn@niasdigital.com>
Subject: Re: [PATCH] MMC Core: Drop initialization frequency floor to 50kHz
Message-ID: <20090702091808.6108d0a9@mjolnir.ossman.eu>
In-Reply-To: <1246492196.2980.17.camel@linux-51e8.site>
References: <1246492196.2980.17.camel@linux-51e8.site>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-18386-1246519094-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-18386-1246519094-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 02 Jul 2009 09:49:56 +1000
Ben Nizette <bn@niasdigital.com> wrote:

> Patch
>=20
> commit 8dfd0374be84793360db7fff2e635d2cd3bbcb21
> Author: Sascha Hauer <s.hauer@pengutronix.de>
> Date:   Thu Apr 9 08:32:02 2009 +0200
>=20
>     MMC core: limit minimum initialization frequency to 400kHz
>=20
> Was recently merged.  This is too fast for at least one setup
> permutation - the one on my desk which through trial and error won't
> initialise at anything above ~350kHz (older Sandisk 256MB SD on
> atmel-mci).
>=20
> To avoid a string of "just found card X which requires clock
> (current_clock - epsilon)" this patch drops the floor right down to
> 50kHz.  This is about the slowest rate before which the discovery
> process takes a noticeable slowdown.
>=20
> Signed-off-by: Ben Nizette <bn@niasdigital.com>
> ---

50 kHz seems very low. I'd be more comfortable if we deviate from
specified behaviour as little as possible, say 300 kHz. Has anyone
checked what USB readers use?

And have you confirmed that the card is actually getting 350 kHz when
it fails? Perhaps there is a bug that is causing it to actually run at
a higher frequency.

> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index d84c880..6ee1931 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -708,12 +708,13 @@ static void mmc_power_up(struct mmc_host *host)
>  	 */
>  	mmc_delay(10);
> =20
> -	if (host->f_min > 400000) {
> -		pr_warning("%s: Minimum clock frequency too high for "
> -				"identification mode\n", mmc_hostname(host));
> -		host->ios.clock =3D host->f_min;
> -	} else
> -		host->ios.clock =3D 400000;
> +	/*
> +	 * Card discovery is typically done at the controller's minimum
> +	 * allowable frequency but for some controllers this is minimum
> +	 * is unreasonably slow.  In that case we limit slow clock rate
> +	 * to 50KHz.
> +	 */
> +	host->ios.clock =3D max(host->f_min, 50000);
> =20

I like getting that warning for too fast controllers. It makes it
easier to spot possible problems.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-18386-1246519094-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpMXzUACgkQ7b8eESbyJLhERwCdF5YW2Duhzjd6L48IFnEPOa6B
0K4AnRpdp4mUoczL1/COvJqqRsM6ErAe
=LUPf
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-18386-1246519094-0001-2--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab0CFX4e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 18:56:34 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48085 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635Ab0CFX4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 18:56:33 -0500
X-Sasl-enc: 6y6uoVdjo7y/hdHaLgQdfeQc3SQAPwjldIoWVRB7TLnm 1267919791
Message-ID: <4B92EB48.9000309@imap.cc>
Date: Sun, 07 Mar 2010 00:54:48 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: linux-kernel@vger.kernel.org, Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: [PATCHv3] drivers: isdn: get rid of custom strtoul()
References: <1267169216-31328-1-git-send-email-andy.shevchenko@gmail.com>
In-Reply-To: <1267169216-31328-1-git-send-email-andy.shevchenko@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6CE452DD002109F30538D7CD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6CE452DD002109F30538D7CD
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 26.02.2010 08:26 schrieb Andy Shevchenko:
> There were two methods isdn_gethex() and isdn_getnum() which are custom=

> implementations of strtoul(). Get rid of them in regard to
> strict_strtoul() kernel's function.
>=20
> The patch should be applied on top of "[PATCH 3/4] gigaset: reduce sysl=
og
> clutter" [1]
>=20
> [1] http://patchwork.kernel.org/patch/81327/
>=20
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Hansjoerg Lipp <hjlipp@web.de>
> Cc: Tilman Schmidt <tilman@imap.cc>

Acked-by: Tilman Schmidt <tilman@imap.cc>

Thanks,
Tilman

> ---
>  drivers/isdn/gigaset/ev-layer.c |   82 +++++++++----------------------=
-------
>  1 files changed, 20 insertions(+), 62 deletions(-)
>=20
> diff --git a/drivers/isdn/gigaset/ev-layer.c b/drivers/isdn/gigaset/ev-=
layer.c
> index c8f89b7..b1a334b 100644
> --- a/drivers/isdn/gigaset/ev-layer.c
> +++ b/drivers/isdn/gigaset/ev-layer.c
> @@ -420,64 +420,18 @@ static const struct zsau_resp_t {
>  	{NULL,				ZSAU_UNKNOWN}
>  };
> =20
> -/*
> - * Get integer from char-pointer
> - */
> -static int isdn_getnum(char *p)
> -{
> -	int v =3D -1;
> -
> -	gig_dbg(DEBUG_EVENT, "string: %s", p);
> -
> -	while (*p >=3D '0' && *p <=3D '9')
> -		v =3D ((v < 0) ? 0 : (v * 10)) + (int) ((*p++) - '0');
> -	if (*p)
> -		v =3D -1; /* invalid Character */
> -	return v;
> -}
> -
> -/*
> - * Get integer from char-pointer
> - */
> -static int isdn_gethex(char *p)
> -{
> -	int v =3D 0;
> -	int c;
> -
> -	gig_dbg(DEBUG_EVENT, "string: %s", p);
> -
> -	if (!*p)
> -		return -1;
> -
> -	do {
> -		if (v > (INT_MAX - 15) / 16)
> -			return -1;
> -		c =3D *p;
> -		if (c >=3D '0' && c <=3D '9')
> -			c -=3D '0';
> -		else if (c >=3D 'a' && c <=3D 'f')
> -			c -=3D 'a' - 10;
> -		else if (c >=3D 'A' && c <=3D 'F')
> -			c -=3D 'A' - 10;
> -		else
> -			return -1;
> -		v =3D v * 16 + c;
> -	} while (*++p);
> -
> -	return v;
> -}
> -
>  /* retrieve CID from parsed response
>   * returns 0 if no CID, -1 if invalid CID, or CID value 1..65535
>   */
>  static int cid_of_response(char *s)
>  {
> -	int cid;
> +	unsigned long cid;
> +	int rc;
> =20
>  	if (s[-1] !=3D ';')
>  		return 0;	/* no CID separator */
> -	cid =3D isdn_getnum(s);
> -	if (cid < 0)
> +	rc =3D strict_strtoul(s, 10, &cid);
> +	if (rc)
>  		return 0;	/* CID not numeric */
>  	if (cid < 1 || cid > 65535)
>  		return -1;	/* CID out of range */
> @@ -647,24 +601,28 @@ void gigaset_handle_modem_response(struct cardsta=
te *cs)
>  		case RT_ZCAU:
>  			event->parameter =3D -1;
>  			if (curarg + 1 < params) {
> -				i =3D isdn_gethex(argv[curarg]);
> -				j =3D isdn_gethex(argv[curarg + 1]);
> -				if (i >=3D 0 && i < 256 && j >=3D 0 && j < 256)
> -					event->parameter =3D (unsigned) i << 8
> -							   | j;
> -				curarg +=3D 2;
> +				unsigned long hi, lo;
> +				int rh, rl;
> +
> +				rh =3D strict_strtoul(argv[curarg++], 16, &hi);
> +				rl =3D strict_strtoul(argv[curarg++], 16, &lo);
> +
> +				if (rh =3D=3D 0 && hi < 256 && rl =3D=3D 0 && lo < 256)
> +					event->parameter =3D (hi << 8) | lo;
>  			} else
>  				curarg =3D params - 1;
>  			break;
>  		case RT_NUMBER:
>  		case RT_HEX:
>  			if (curarg < params) {
> -				if (param_type =3D=3D RT_HEX)
> -					event->parameter =3D
> -						isdn_gethex(argv[curarg]);
> -				else
> -					event->parameter =3D
> -						isdn_getnum(argv[curarg]);
> +				int base =3D (param_type =3D=3D RT_HEX) ? 16 : 10;
> +				unsigned long res;
> +				int rc;
> +
> +				rc =3D strict_strtoul(argv[curarg], base, &res);
> +				if (rc =3D=3D 0)
> +					event->parameter =3D res;
> +
>  				++curarg;
>  			} else
>  				event->parameter =3D -1;

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig6CE452DD002109F30538D7CD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkuS61MACgkQQ3+did9BuFtBNwCffvkqoQwwRKDp3nEcPgvC7d46
QLUAoIAnwyWtOdsdX6BadyB2CaSmJo8o
=Yr02
-----END PGP SIGNATURE-----

--------------enig6CE452DD002109F30538D7CD--

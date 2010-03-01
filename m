Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab0CAOk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:40:26 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57510 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311Ab0CAOkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:40:23 -0500
X-Sasl-enc: 3u8yrLzrLqD0ysTuH+EYUIOaLItWtmtET/xnyyjEGPBx 1267454422
Message-ID: <4B8BD190.1060609@imap.cc>
Date: Mon, 01 Mar 2010 15:39:12 +0100
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
 boundary="------------enig15484FB532A3452E910CC7E5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig15484FB532A3452E910CC7E5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 2010-02-26 08:26 schrieb Andy Shevchenko:
> There were two methods isdn_gethex() and isdn_getnum() which are custom=

> implementations of strtoul(). Get rid of them in regard to
> strict_strtoul() kernel's function.
>=20
> The patch should be applied on top of "[PATCH 3/4] gigaset: reduce sysl=
og
> clutter" [1]

That patch is now in net-next, so that remark isn't needed anymore.

> --- a/drivers/isdn/gigaset/ev-layer.c
> +++ b/drivers/isdn/gigaset/ev-layer.c
[...]
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

If you want to give the two decoded value variables speaking names (as
opposed to the generic "i" and "j") I'd prefer that they correspond to
their actual meaning (which of course you couldn't know). What you
called "hi" is the "cause type", and what you called "lo", the "cause
value". More appropriate variable names would therefore be, for example,
"cautype" and "cauvalue".

Of course that's only cosmetic, but it would still be nice if you could
take it into account if you're doing another version of the patch.

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

That's not quite correct. (Sorry for not catching that in the last
review.) The original code would set event->parameter to -1 if the
argv[curarg] string isn't valid. Your code will leave it unchanged
in that case.

As a remedy, you can just set event->parameter =3D -1 at the beginning
of the case, just as in the case RT_ZCAU above. That will also make
the else clause below unnecessary.

>  				++curarg;
>  			} else
>  				event->parameter =3D -1;

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enig15484FB532A3452E910CC7E5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkuL0ZAACgkQQ3+did9BuFsJtQCgivD29YBnj6/pBd+u9JO7wlsv
GQcAnjB3FIsyQVFxW87iaceUqW/+vFRG
=m5WZ
-----END PGP SIGNATURE-----

--------------enig15484FB532A3452E910CC7E5--

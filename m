Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbZHPJLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbZHPJLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbZHPJLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:11:16 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:40673 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZHPJLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KJLsCYmY6r3myrDeHPbx2YO14LgxM0xdynIkD9yn9MgFL7v38G2MI7JVVdSbD5oeB2
         FiYkODbOhU41VmuvMuUe6gpo39aUkaxq+JFn0jh2OYp+d0Y6qBWK2+ME694msbLn05QL
         PX59oicBK0JHAVq8+ObELDN7ncrmL7TozJPsM=
Date: Sun, 16 Aug 2009 12:14:25 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make shr to divide by power of 2 (resend)
Message-ID: <20090816091425.GB7968@localdomain.by>
References: <20090815134312.GA7533@localdomain.by>
 <4A86BC96.9040702@gmail.com>
 <alpine.LFD.2.00.0908150947260.14440@localhost>
 <20090815141212.GA7692@localdomain.by>
 <4A871DAF.10609@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <4A871DAF.10609@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/15/09 22:42), Jiri Slaby wrote:
> On 08/15/2009 04:12 PM, Sergey Senozhatsky wrote:
> > On (08/15/09 09:49), Robert P. J. Day wrote:
> >> On Sat, 15 Aug 2009, Jiri Slaby wrote:
> >>
> >>> On 08/15/2009 03:43 PM, Sergey Senozhatsky wrote:
> >>>> Make an arithmetic right shift to divide by power of 2.
> >>>
> >>> Why? Is out there a compiler not doing that?
> >>>
> >>> Seems like it should be rather converted to DIV_ROUND_UP.
> >>>
> >=20
> >                                 =20
> > It was duscussed, so I'll just copy paste my answer.
> > On (08/08/09 09:35), Andi Kleen wrote:
> >> DIV should be always slower than a SHIFT.
> >>
> >> But it has nothing really to do with the CPU. The point is that the co=
mpiler
> >> always selects a suitable one by itself. Rewriting x / 2 to x >> 1 is
> >> one of the easiest exercises in compiler optimizations.
> >>
> >> The only case when the compiler cannot do this easily by itself is
> >> when the dividend is not a constant.
>=20
> I think Andi (Cced again) meant divisor. When a divisor is constant, you
> can always transform division to some of subs/adds/muls/shifts.

Cced  Andi Kleen <andi@firstfloor.org>


>=20
> >         int width =3D (vc->vc_font.width + 7) >> 3;
> >=20
> >> That said -Os sometimes screws us up on this, but it's still not worth
> >> doing this change manually.
> >>
> >=20
> > My point is that it should 'look the same'.
> > I mean there are 5
> >         int width =3D (vc->vc_font.width + 7) >> 3;
> > *not exactly this one, but vc->vc_font.width (+ 7)? >> 3
> >=20
> > and _only_ one
> >         int width =3D (vc->vc_font.width + 7) / 8;
> >=20
> >=20
> >>   it does seem like a DIV_ROUND_UP would be better but perhaps another
> >> solution would be to define a meaningful macro name for that
> >> operation.  if that conversion is going to be done regularly, a macro
> >> with an informative name might be in order.  if it's a one-shot
> >> operation, though, not much point.
> >>
> >=20
> > No, it's not a one-shot.
> >=20
> > grep -c '>>' bitblit.c
> > 7
>=20
> Then please use DIV_ROUND_UP macro (or whatever alias) all over the place.
>=20

Sorry, once again (just to clear).

There are different shr/shl operations in bitblit.c. Like,
#1
cur_height =3D vc->vc_font.height >> 1
cur_height =3D (vc->vc_font.height << 1)/3;
c |=3D c >> 1;
u32 idx =3D vc->vc_font.width >> 3;
etc.

So, should I convert it to something like:
#2
cur_height =3D DIV_XXX(vc->vc_font.height, 2)
cur_height =3D DIV_XXX( MUL_XXX(vc->vc_font.height, 2), 3); or cur_height =
=3D DIV_XXX( (vc->vc_font.height * 2), 3);
c |=3D DIV_XXX(c, 1);
u32 idx =3D DIV_XXX(vc->vc_font.width, 8);

#1 is better-looking I think.

	Sergey
--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqHzfEACgkQfKHnntdSXjQ/vwP/eV4r3e8KbeuSNRxD1/0liUpn
cESRFsmRSLPrGJ5OJ2hcNlPPCSgZK8mhHgcivEPtOJMV9p5tsvfaKFm7ZgDaMyRs
AvlSmQFgVftQ7n8AIqy4GfY1sjQE35qW+QGhzR7OYapYvvxrw4l8rOIxFQ1x8l3P
N2CNdX3auYb1yCZF/7w=
=q7l1
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbZIKF20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbZIKF20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 01:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZIKF2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 01:28:25 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:55597 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbZIKF2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 01:28:24 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make sure the value in abs() does not get truncated if it is greater than 2^32
Date: Fri, 11 Sep 2009 07:28:21 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-git; KDE/4.3.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <200909032312.10418.eike-kernel@sf-tec.de> <20090910133913.097bb9a3.akpm@linux-foundation.org>
In-Reply-To: <20090910133913.097bb9a3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1635503.ypKlWicuEv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909110728.22302.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1635503.ypKlWicuEv
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> On Thu, 3 Sep 2009 23:12:01 +0200
>=20
> Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
> > I was just digging a bit around in linux/kernel.h and stumbled over the
> > abs() makro. For me it looks as it would return wrong results on 64 bit
> > platforms if the input value is greater than 2^32.
>=20
> Yes, it will truncate.
>=20
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index d6320a3..1e6eb66 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -145,7 +145,7 @@ extern int _cond_resched(void);
> >  #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
> >
> >  #define abs(x) ({				\
> > -		int __x =3D (x);			\
> > +		long __x =3D (x);			\
> >  		(__x < 0) ? -__x : __x;		\
> >  	})
>=20
> I wonder if that ends up producing worse code in the normal case.
>=20
> We could use typeof to address that but what about
>=20
> 	unsigned foo =3D -1;
> 	signed bar =3D abs(foo);
>=20
> ?
>=20
> That'll currently return 1 but if we use typeof it'll return
> 0xffffffffU which gets turned into -1.

I have not tested this, but what might happen with:

unsigned long a =3D 7;
long b =3D 9;
return abs(a - b);

I thought about using typeof but that's too much compiler magic for me to g=
et=20
right. If you can, go for it.

We could also try to check sizeof(__x) and then use either int or long to g=
et=20
the same code for the common code but behave right for big values.

Eike

--nextPart1635503.ypKlWicuEv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkqp3/YACgkQXKSJPmm5/E4P6wCeKv+uuLTENILuNaJxEfg8Yzy+
jfYAoKdwk3Wul4GWqI6WcVh2HZd6mR2S
=s15w
-----END PGP SIGNATURE-----

--nextPart1635503.ypKlWicuEv--

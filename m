Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZJGCwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZJGCwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 22:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZJGCv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 22:51:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38633 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274AbZJGCv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 22:51:58 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Eric Sesterhenn <snakebyte@gmx.de>, Roman Zippel <zippel@linux-m68k.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YylRrt/c1DAypDVebS2N"
Date: Wed, 07 Oct 2009 03:51:18 +0100
Message-Id: <1254883878.4246.191.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: hfsplus corrupts filesystems >2TB
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YylRrt/c1DAypDVebS2N
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

A Debian bug report <http://bugs.debian.org/550010> alerted me to the
fact that hfsplus is not using enough bits for some sector calculations.

hfsplus_get_block() does:

	u32 ablock, dblock, mask;
...
	map_bh(bh_result, sb, (dblock << HFSPLUS_SB(sb).fs_shift) + HFSPLUS_SB(sb)=
.blockoffset + (iblock & mask));

which results in overflow when the sector number is >2^32.  Now it might
be sufficient to change the last line to:

	map_bh(bh_result, sb, ((sector_t)dblock << HFSPLUS_SB(sb).fs_shift) + HFSP=
LUS_SB(sb).blockoffset + (iblock & mask));

but there may be many other places where u32 must be changed to
sector_t.

For Debian's stable release, I'm intending to prevent mounting volumes
larger than 2^32 sectors (2TB).  Is anyone interested in fixing this
properly or should I submit the same change for mainline?

Ben.

--=20
Ben Hutchings
To err is human; to really foul things up requires a computer.

--=-YylRrt/c1DAypDVebS2N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUASswCIee/yOyVhhEJAQLT/A/8Dsi+NcS1XjLe33I4A29mEFNNMhPl0Zxt
YIYpXkuUqAodsMxIm0aIEHa0kGBDyn84w6mPvLupdvdaCPA5Xp4ofz5oKrjBOnaW
r0atqGajYbHZ0MQpTPg9rsGVigBW0b77GCgudh4kbiC34L/PlktZ9yAKcjDFpKfv
PVJEBuDeloMYhG46cniD+jlTnsf+valdFlXfZQw9nt4kzwVsM6H+0aKUNmb9SL5r
w8zCkwOAjLonYWtJLMNhko9dMIu3eB8xYVbBEXZWoMN66xXEDxt4dzrCwwCgd0BE
xmdnQyk02Rw3Z7RVv3sXiLyGEXApmpfVSaKgCvNAHVT+meoRo8MbKWDXG7PYkOM+
UJK887FLnJs9yrzZHcE+WwJOEN7ahU0yLk0BoWq7xKXhrojNAT6z37+7PTxlzDKO
OkNzZ0fp/3f7wS+7VjCWV9BEVSZvR2SBmCAtSzR8AsZ3f5jo1u4Vvf1XZX0jrCts
+4M0sl1ojOj3XgiOH26dMn1tdHho3YVvqyRgNIn9B4pm2IWuP/1bLrPhwexjKAf6
94vR68WC613YJeH7lJmp/DNcVJ5D1ymIF0eF5lSSqfwfp5DdMjFb+nFWetTG60zU
hsFsu/ySG80TCYVsV6pqUipzPifrr7fw7yNG8Epw9tZcPlaHYCuF+EjAzPqWxsff
DTUVDOa92CA=
=tQwK
-----END PGP SIGNATURE-----

--=-YylRrt/c1DAypDVebS2N--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbYIFIlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbYIFIlQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 04:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYIFIlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 04:41:00 -0400
Received: from flock1.newmail.ru ([82.204.219.207]:39079 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751649AbYIFIk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 04:40:59 -0400
From: Andrey Borzenkov <arvidjaar@newmail.ru>
To: hpa@zytor.com
Subject: [PATCH] Ghost EDD devices in /sys again
Date: Sat, 6 Sep 2008 12:40:21 +0400
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200809052219.44093.arvidjaar@newmail.ru>
In-Reply-To: <200809052219.44093.arvidjaar@newmail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16065783.KIKdLyPWuv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809061240.25925.arvidjaar@newmail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart16065783.KIKdLyPWuv
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 05 September 2008, Andrey Borzenkov wrote:
> This is regression but old enough. Apparently I had for whatever reasons
> EDD turned off till recently. This is 2.6.27-rc5 just in case.
>=20
> In 2006 I fixed ghost devices due to buggy BIOS:
>=20
> http://marc.info/?l=3Dlinux-kernel&m=3D114087765422490&w=3D2
>=20
> Later edd.S has been rewritten in C, and apparently this patch has been
> lost:
>=20
> {pts/1}% ls /sys/firmware/edd
> int13_dev80/  int13_dev84/  int13_dev88/  int13_dev8c/
> int13_dev81/  int13_dev85/  int13_dev89/  int13_dev8d/
> int13_dev82/  int13_dev86/  int13_dev8a/  int13_dev8e/
> int13_dev83/  int13_dev87/  int13_dev8b/  int13_dev8f/
>=20
> But I have just a single disk. This is the same system BTW.
>=20
> Unfortunately I do not speak asm language of C; if somebody could provide
> equivalent fix for current edd.c, I am more than ready to test it.

Was it really that simple?

Subject: [PATCH] Fix ghost devices under /sys/firmware/edd
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

Some BIOSes do not always set CF on error before return from int13.
The patch adds additional check for status being zero (AH =3D=3D 0).

This was fixed for edd.S in
http://marc.info/?l=3Dlinux-kernel&m=3D114087765422490&w=3D2, but lost
again when edd.S was rewritten in C.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 arch/x86/boot/edd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/arch/x86/boot/edd.c b/arch/x86/boot/edd.c
index d93cbc6..bf4ae6f 100644
=2D-- a/arch/x86/boot/edd.c
+++ b/arch/x86/boot/edd.c
@@ -32,7 +32,9 @@ static int read_mbr(u8 devno, void *buf)
 		     : "+a" (ax), "+c" (cx), "+d" (dx), "+b" (bx)
 		     : : "esi", "edi", "memory");
=20
=2D	return -(u8)ax;		/* 0 or -1 */
+	/* Some BIOSes do not set carry flag on error but still return
+	 * error in AH. The condition below is expected to catch both */
+	return -!!ax;		/* 0 or -1 */
 }
=20
 static u32 read_mbr_sig(u8 devno, struct edd_info *ei, u32 *mbrsig)

--nextPart16065783.KIKdLyPWuv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjCQfYACgkQR6LMutpd94ygTgCcDTP4yRPAQflIK9jWL/YO8u35
o7wAnjpI5xmGR1VZ93X+ZCsrqr/PZjJV
=QQtH
-----END PGP SIGNATURE-----

--nextPart16065783.KIKdLyPWuv--

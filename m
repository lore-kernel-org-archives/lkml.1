Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbXJ1KdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbXJ1KdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 06:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbXJ1KdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 06:33:16 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:53203 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbXJ1KdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 06:33:16 -0400
Message-ID: <47246560.3040009@web.de>
Date: Sun, 28 Oct 2007 11:33:04 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Dave Young <hidave.darkstar@gmail.com>, Greg KH <greg@kroah.com>,
       akpm@linux-foundation.org
Subject: [PATCH] fix param_sysfs_builtin name length check
X-Enigmail-Version: 0.95.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6606920DAA1E9E57B37927DC"
X-Provags-ID: V01U2FsdGVkX187BkXFX4mTF7nBAFC2p7P6jPR1IrLNsE4OBI+s
	VlLtS8iA43VwyqJgSOqxDvDy4vtbHgRvrsKklRjysAlncnBaRQ
	ImYNChQo4=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6606920DAA1E9E57B37927DC
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Commit faf8c714f4508207a9c81cc94dafc76ed6680b44 caused a regression:
parameter names longer than MAX_KBUILD_MODNAME will now be rejected,
although we just need to keep the module name part that short. This
patch restores the old behaviour while still avoiding that memchr is
called with its length parameter larger than the total string length.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 kernel/params.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

Index: linux-2.6.24-rc1-xeno/kernel/params.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.24-rc1-xeno.orig/kernel/params.c
+++ linux-2.6.24-rc1-xeno/kernel/params.c
@@ -592,19 +592,16 @@ static void __init param_sysfs_builtin(v
=20
 	for (i=3D0; i < __stop___param - __start___param; i++) {
 		char *dot;
-		size_t kplen;
+		size_t max_name_len;
=20
 		kp =3D &__start___param[i];
-		kplen =3D strlen(kp->name);
+		max_name_len =3D
+			min_t(size_t, MAX_KBUILD_MODNAME, strlen(kp->name));
=20
-		/* We do not handle args without periods. */
-		if (kplen > MAX_KBUILD_MODNAME) {
-			DEBUGP("kernel parameter name is too long: %s\n", kp->name);
-			continue;
-		}
-		dot =3D memchr(kp->name, '.', kplen);
+		dot =3D memchr(kp->name, '.', max_name_len);
 		if (!dot) {
-			DEBUGP("couldn't find period in %s\n", kp->name);
+			DEBUGP("couldn't find period in first %d characters "
+			       "of %s\n", MAX_KBUILD_MODNAME, kp->name);
 			continue;
 		}
 		name_len =3D dot - kp->name;


--------------enig6606920DAA1E9E57B37927DC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHJGVmniDOoMHTA+kRAlLtAJ9FOvHYjvx8BrFrskO5w/FnuDfV9wCdHM18
owWe7VSn+BByus34nMykpjo=
=Jwmw
-----END PGP SIGNATURE-----

--------------enig6606920DAA1E9E57B37927DC--
